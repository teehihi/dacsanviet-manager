import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../domain/models.dart';
import '../domain/domain.dart';
import '../domain/services/socket_service.dart';
import '../domain/services/auth_service.dart';
import '../domain/api_service.dart';
import '../domain/services/notification_service.dart';

class AppController extends ChangeNotifier {
  bool _isAuthenticated = false;
  int _tabIndex = 0;
  String _productSearch = '';
  String _productCategory = 'Tất cả';
  OrderStatus _orderFilter = OrderStatus.pending;
  User? _user;
  bool _isLoading = false;
  String? _error;

  bool get isAuthenticated => _isAuthenticated;
  int get tabIndex => _tabIndex;
  String get productSearch => _productSearch;
  String get productCategory => _productCategory;
  OrderStatus get orderFilter => _orderFilter;
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<Product> _products = [];
  List<Order> _orders = [];
  int _totalRevenue = 0;
  int _totalOrders = 0;
  int _totalProducts = 0;
  int _totalUsers = 0;

  List<Product> get products => List.unmodifiable(_products);
  List<Order> get orders => List.unmodifiable(_orders);
  
  List<User> _users = [];
  List<User> get users => List.unmodifiable(_users);

  // --- Notifications management ---
  final List<AdminNotification> _notifications = [];
  List<AdminNotification> get notifications => List.unmodifiable(_notifications.reversed);

  void addNotification(String title, String body, {Map<String, dynamic>? data}) {
    final notification = AdminNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      body: body,
      timestamp: DateTime.now(),
      data: data,
    );
    _notifications.add(notification);
    notifyListeners();
  }

  void removeNotification(String id) {
    _notifications.removeWhere((n) => n.id == id);
    notifyListeners();
  }

  void clearAllNotifications() {
    _notifications.clear();
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    if (_isLoading) {
      debugPrint('⚠️ Login already in progress, skipping...');
      return false;
    }
    
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      debugPrint('🔐 Attempting login...');
      final response = await AuthService.login(email: email, password: password);
      
      if (response.success && response.data != null) {
        final userData = response.data!['user'];
        _isAuthenticated = true;
        _user = User(
          id: userData['id'].toString(),
          fullName: userData['fullName'] ?? userData['username'],
          email: userData['email'],
          phoneNumber: userData['phone_number'] ?? '',
          role: userData['role'] ?? 'ADMIN',
          isActive: true,
        );
        
        debugPrint('✅ Login successful, loading data...');
        
        // Connect Socket
        final token = ApiService.sessionId;
        if (token != null) {
          SocketService().connect(token);
          SocketService().onNotificationReceived = (data) {
            _handleSocketNotification(data);
          };

          // --- Update FCM Token for Push Notifications ---
          NotificationService().getFCMToken().then((fcmToken) {
            if (fcmToken != null) {
              AuthService.updateFcmToken(fcmToken).then((res) {
                if (res.success) {
                  debugPrint('✅ FCM Token updated on server');
                }
              });
            }
          });
        }

        // Load initial data
        await Future.wait([
          loadProducts(),
          loadOrders(),
          loadUsers(),
        ]);
        
        _isLoading = false;
        notifyListeners();
        debugPrint('✅ All data loaded successfully');
        return true;
      } else {
        _error = response.message;
        _isLoading = false;
        notifyListeners();
        debugPrint('❌ Login failed: ${response.message}');
        return false;
      }
    } catch (e) {
      _error = 'Lỗi kết nối: $e';
      _isLoading = false;
      notifyListeners();
      debugPrint('❌ Login error: $e');
      return false;
    }
  }

  Future<void> loadProducts() async {
    try {
      debugPrint('Loading products...');
      // Use public products endpoint
      final uri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.products}')
          .replace(queryParameters: {'limit': '100'});
      
      final response = await http.get(uri, headers: ApiConfig.defaultHeaders)
          .timeout(ApiConfig.connectionTimeout);
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final jsonData = jsonDecode(response.body);
        
        // Check if response has success field
        if (jsonData is Map && jsonData['success'] == true) {
          final productsData = jsonData['data'] as List;
          
          _products = productsData.map((p) => Product(
            id: p['id'].toString(),
            name: p['name'] ?? '',
            category: p['category'] ?? 'Khác',
            price: (p['price'] is int) ? p['price'] : (p['price'] as double).toInt(),
            stock: p['stock'] ?? 0,
            imageUrl: p['imageUrl'] ?? p['image_url'],
          )).toList();
          
          if (jsonData['pagination'] != null) {
            _totalProducts = jsonData['pagination']['totalItems'] ?? _products.length;
          } else {
            _totalProducts = _products.length;
          }
          
          debugPrint('✅ Loaded ${_products.length} products');
        } else {
          debugPrint('❌ Invalid response format');
        }
      } else {
        debugPrint('❌ HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      debugPrint('❌ Error loading products: $e');
    }
  }

  Future<void> loadOrders() async {
    try {
      debugPrint('Loading orders...');
      // Orders endpoint requires authentication, use session ID
      final sessionId = ApiService.sessionId;
      if (sessionId == null) {
        debugPrint('⚠️ No session ID, skipping orders');
        return;
      }
      
      // Use Admin API for all orders
      final uri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/admin/orders')
          .replace(queryParameters: {'limit': '100'});
      
      final response = await http.get(
        uri,
        headers: ApiConfig.getAuthHeaders(sessionId),
      ).timeout(ApiConfig.connectionTimeout);
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final jsonData = jsonDecode(response.body);
        
        if (jsonData is Map && jsonData['success'] == true) {
          final ordersData = jsonData['data'] as List? ?? [];
          
          _orders = ordersData.map((o) {
            // Parse status
            OrderStatus status;
            final statusStr = o['status']?.toString().toUpperCase() ?? 'NEW';
            if (statusStr == 'NEW' || statusStr == 'PENDING') {
              status = OrderStatus.pending;
            } else if (statusStr == 'CONFIRMED' || statusStr == 'SHIPPING') {
              status = OrderStatus.shipping;
            } else {
              status = OrderStatus.complete;
            }

            // Parse items for product summary
            String productSummary = '';
            if (o['items'] != null && o['items'] is List) {
              final items = o['items'] as List;
              productSummary = items.map((item) => '${item['product_name'] ?? 'Sản phẩm'} x${item['quantity'] ?? 1}').join(', ');
            }

            return Order(
              id: o['id'].toString(),
              code: o['order_number'] ?? 'ORD-${o['id']}',
              customerName: o['customer_name'] ?? o['customerName'] ?? 'Khách hàng',
              phone: o['phone'] ?? '',
              address: o['shipping_address'] ?? o['shippingAddress'] ?? '',
              productSummary: productSummary.isNotEmpty ? productSummary : 'Đơn hàng',
              totalAmount: (o['total_amount'] ?? o['totalAmount'] ?? 0) is int 
                  ? (o['total_amount'] ?? o['totalAmount'] ?? 0)
                  : ((o['total_amount'] ?? o['totalAmount'] ?? 0) as double).toInt(),
              paymentMethod: o['payment_method'] ?? o['paymentMethod'] ?? 'COD',
              status: status,
              createdAt: DateTime.tryParse(o['created_at'] ?? o['createdAt'] ?? '') ?? DateTime.now(),
            );
          }).toList();
          
          if (jsonData['pagination'] != null) {
            _totalOrders = jsonData['pagination']['totalItems'] ?? _orders.length;
          } else {
            _totalOrders = _orders.length;
          }
          
          _totalRevenue = _orders
              .where((o) => o.status == OrderStatus.complete)
              .fold(0, (sum, o) => sum + o.totalAmount);
          debugPrint('✅ Loaded ${_orders.length} orders');
        } else {
          debugPrint('❌ Invalid response format');
        }
      } else {
        debugPrint('❌ HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      debugPrint('❌ Error loading orders: $e');
    }
  }

  Future<void> logout() async {
    try {
      await AuthService.logout();
    } catch (_) {}
    
    SocketService().disconnect();
    _isAuthenticated = false;
    _tabIndex = 0;
    _products = [];
    _orders = [];
    _user = null;
    notifyListeners();
  }

  void _handleSocketNotification(dynamic data) {
    debugPrint('🔔 System Logic: Processing socket data: $data');
    
    // Refresh relevant data based on type
    if (data is Map) {
      final type = data['type'];
      if (type == 'NEW_ORDER' || type == 'ORDER_UPDATED') {
        loadOrders();
      } else if (type == 'NEW_USER') {
        loadUsers();
      }
      
      // Show system notification
      NotificationService().showLocalNotification(
        title: data['title'] ?? 'Thông báo hệ thống',
        body: data['body'] ?? 'Có hoạt động mới trong quản trị.',
      );

      // Save to internal notifications list
      addNotification(
        data['title'] ?? 'Thông báo hệ thống',
        data['body'] ?? 'Có hoạt động mới trong quản trị.',
        data: data is Map<String, dynamic> ? data : null,
      );

      // Notify UI via _error (as a quick snackbar mechanism)
      _error = 'Thông báo: ${data['title'] ?? 'Cập nhật từ hệ thống'}';
      notifyListeners();
      
      // Clear error after a while
      Future.delayed(const Duration(seconds: 4), () {
        if (_error?.startsWith('Thông báo:') ?? false) {
          _error = null;
          notifyListeners();
        }
      });
    }
  }

  void setTab(int index) {
    _tabIndex = index;
    notifyListeners();
  }

  void setProductSearch(String value) {
    _productSearch = value.trim().toLowerCase();
    notifyListeners();
  }

  void setProductCategory(String category) {
    _productCategory = category;
    notifyListeners();
  }

  // Get dynamic categories from products list
  List<String> get availableCategories {
    final Set<String> cats = {'Tất cả'};
    for (var p in _products) {
      if (p.category.isNotEmpty) cats.add(p.category);
    }
    return cats.toList();
  }

  List<Product> get filteredProducts {
    return _products.where((p) {
      final passCategory = _productCategory == 'Tất cả' || p.category == _productCategory;
      final passSearch = _productSearch.isEmpty || p.name.toLowerCase().contains(_productSearch);
      return passCategory && passSearch;
    }).toList();
  }

  Future<void> addProduct({
    required String name,
    required String category,
    required int price,
    required int stock,
    String? imageUrl,
  }) async {
    try {
      final response = await ProductService.createProduct(
        name: name,
        description: name,
        price: price.toDouble(),
        stock: stock,
        category: category,
        imageUrl: imageUrl,
      );
      
      if (response.success) {
        await loadProducts();
      } else {
        _error = response.message;
        notifyListeners();
      }
    } catch (e) {
      _error = 'Lỗi tạo sản phẩm: $e';
      notifyListeners();
    }
  }

  Future<void> updateProduct(
    String id, {
    required String name,
    required String category,
    required int price,
    required int stock,
    String? imageUrl,
  }) async {
    try {
      final response = await ProductService.updateProduct(
        id: int.parse(id),
        name: name,
        price: price.toDouble(),
        stock: stock,
        category: category,
        imageUrl: imageUrl,
      );
      
      if (response.success) {
        await loadProducts();
      } else {
        _error = response.message;
        notifyListeners();
      }
    } catch (e) {
      _error = 'Lỗi cập nhật sản phẩm: $e';
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      final response = await ProductService.deleteProduct(int.parse(id));
      
      if (response.success) {
        await loadProducts();
      } else {
        _error = response.message;
        notifyListeners();
      }
    } catch (e) {
      _error = 'Lỗi xóa sản phẩm: $e';
      notifyListeners();
    }
  }

  void setOrderFilter(OrderStatus status) {
    _orderFilter = status;
    notifyListeners();
  }

  List<Order> get filteredOrders => _orders.where((o) => o.status == _orderFilter).toList();

  Future<void> rejectOrder(String id) async {
    try {
      final order = _orders.firstWhere((o) => o.id == id);
      final response = await OrderService.updateOrderStatus(
        orderId: order.code,
        status: 'CANCELLED',
      );
      
      if (response.success) {
        await loadOrders();
      } else {
        _error = response.message;
        notifyListeners();
      }
    } catch (e) {
      _error = 'Lỗi hủy đơn hàng: $e';
      notifyListeners();
    }
  }

  Future<void> confirmOrder(String id) async {
    try {
      final order = _orders.firstWhere((o) => o.id == id);
      final response = await OrderService.updateOrderStatus(
        orderId: order.code,
        status: 'CONFIRMED',
      );
      
      if (response.success) {
        await loadOrders();
      } else {
        _error = response.message;
        notifyListeners();
      }
    } catch (e) {
      _error = 'Lỗi xác nhận đơn hàng: $e';
      notifyListeners();
    }
  }

  Future<void> completeOrder(String id) async {
    try {
      final order = _orders.firstWhere((o) => o.id == id);
      final response = await OrderService.updateOrderStatus(
        orderId: order.code,
        status: 'DELIVERED',
      );
      
      if (response.success) {
        await loadOrders();
      } else {
        _error = response.message;
        notifyListeners();
      }
    } catch (e) {
      _error = 'Lỗi hoàn thành đơn hàng: $e';
      notifyListeners();
    }
  }

  Future<void> loadUsers() async {
    try {
      debugPrint('Loading users...');
      final response = await UserService.getUsers(limit: 100);
      
      if (response.success && response.data != null) {
        final usersData = response.data!['users'] as List? ?? [];
        _users = usersData.map((u) => User.fromJson(u)).toList();
        _totalUsers = response.data!['total'] ?? _users.length;
        debugPrint('✅ Loaded ${_users.length} users');
        notifyListeners();
      } else {
        debugPrint('❌ Error loading users: ${response.message}');
      }
    } catch (e) {
      debugPrint('❌ Exception loading users: $e');
    }
  }

  Future<void> toggleUserStatus(String id) async {
    try {
      final response = await UserService.toggleUserStatus(id);
      if (response.success) {
        await loadUsers();
      } else {
        _error = response.message;
        notifyListeners();
      }
    } catch (e) {
      _error = 'Lỗi cập nhật trạng thái: $e';
      notifyListeners();
    }
  }

  Future<void> deleteUser(String id) async {
    try {
      final response = await UserService.deleteUser(id);
      if (response.success) {
        await loadUsers();
      } else {
        _error = response.message;
        notifyListeners();
      }
    } catch (e) {
      _error = 'Lỗi xóa người dùng: $e';
      notifyListeners();
    }
  }

  int get totalOrders => _totalOrders;
  int get totalProducts => _totalProducts;
  int get totalRevenue => _totalRevenue;
  int get totalUsers => _totalUsers;
  int get totalCustomers => _users.where((u) => u.role == 'USER').length;
}
