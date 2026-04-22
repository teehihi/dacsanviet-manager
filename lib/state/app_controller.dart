import 'package:flutter/foundation.dart' hide Category;
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../domain/domain.dart';
import '../domain/services/socket_service.dart';
import '../domain/services/notification_service.dart';
import '../domain/utils/parse_utils.dart';
import '../domain/utils/string_utils.dart';

class AppController extends ChangeNotifier {
  bool _isAuthenticated = false;
  int _tabIndex = 0;
  String _productSearch = '';
  String _productCategory = 'Tất cả';
  String _userSearch = '';
  String _orderSearch = '';
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
  int _currentMonthOrders = 0;
  int _totalProducts = 0;
  int _totalUsers = 0;

  int get totalRevenue => _totalRevenue;
  int get totalOrders => _totalOrders;
  int get currentMonthOrders => _currentMonthOrders;

  List<Product> get products => List.unmodifiable(_products);
  List<Order> get orders => List.unmodifiable(_orders);

  List<User> _users = [];
  List<User> get users => List.unmodifiable(_users);

  List<Category> _categories = [];
  List<Category> get categories => List<Category>.unmodifiable(_categories);

  List<String> get availableCategories => [
    'Tất cả',
    ..._categories.map((c) => c.name),
  ];

  List<Coupon> _coupons = [];
  List<Coupon> get coupons => List.unmodifiable(_coupons);

  Map<String, dynamic>? _revenueData;
  Map<String, dynamic>? get revenueData => _revenueData;

  Map<String, dynamic>? _couponStats;
  Map<String, dynamic>? get couponStats => _couponStats;

  // --- Notifications management ---
  final List<AdminNotification> _notifications = [];
  List<AdminNotification> get notifications =>
      List.unmodifiable(_notifications.reversed);

  void addNotification(
    String title,
    String body, {
    Map<String, dynamic>? data,
  }) {
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
      final response = await AuthService.login(
        email: email,
        password: password,
      );

      if (response.success && response.data != null) {
        final userData = response.data!['user'];
        _isAuthenticated = true;
        _user = User.fromJson(userData);


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
          loadCategories(),
          loadCoupons(),
          loadInitialDashboardData(),
          loadCouponStats(),
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
      debugPrint('📥 AppController: Loading products from ${ApiConfig.adminProducts}...');
      final response = await ProductService.getProducts(limit: 100);

      if (response.success && response.data != null) {
        final productsData = response.data!['products'] as List? ?? [];
        debugPrint('📊 AppController: Received ${productsData.length} raw products. Keys: ${response.data!.keys}');

        _products = productsData
            .map((p) {
              try {
                return Product.fromJson(p as Map<String, dynamic>);
              } catch (e) {
                debugPrint('⚠️ Error parsing single product: $e | Data: $p');
                return null;
              }
            })
            .whereType<Product>()
            .toList();

        final pagination = response.data!['pagination'];
        if (pagination != null) {
          _totalProducts = ParseUtils.parseInt(pagination['totalItems'] ?? pagination['total']);
        } else {
          _totalProducts = _products.length;
        }

        notifyListeners();
        debugPrint('✅ AppController: Processed ${_products.length} products. Total count: $_totalProducts');
      } else {
        debugPrint('❌ AppController: Failed to load products: ${response.message}');
      }
    } catch (e) {
      debugPrint('❌ AppController: Exception loading products: $e');
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
      final uri = Uri.parse(
        '${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/admin/orders',
      ).replace(queryParameters: {'limit': '100'});

      final response = await http
          .get(uri, headers: ApiConfig.getAuthHeaders(sessionId))
          .timeout(ApiConfig.connectionTimeout);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final jsonData = jsonDecode(response.body);

        if (jsonData is Map && jsonData['success'] == true) {
          final ordersData = jsonData['data']['orders'] as List? ?? [];

          _orders = ordersData.map((o) => Order.fromJson(o)).toList();

          final pagination = jsonData['data']['pagination'];
          if (pagination != null) {
            _totalOrders =
                pagination['totalItems'] ??
                pagination['total'] ??
                _orders.length;
          } else {
            _totalOrders = _orders.length;
          }

          // Don't calculate revenue here - it will be loaded from revenue API
          // _totalRevenue is set by loadRevenueOverview() which uses delivered_revenue from backend
          
          notifyListeners();
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

  void setUserSearch(String value) {
    _userSearch = value.trim().toLowerCase();
    notifyListeners();
  }

  void setOrderSearch(String value) {
    _orderSearch = value.trim().toLowerCase();
    notifyListeners();
  }

  List<Product> get filteredProducts {
    return _products.where((p) {
      final passCategory =
          _productCategory == 'Tất cả' || p.category == _productCategory;
      final passSearch =
          _productSearch.isEmpty ||
          StringUtils.containsSearch(p.name, _productSearch) ||
          StringUtils.containsSearch(p.category, _productSearch);
      return passCategory && passSearch;
    }).toList();
  }

  Future<void> loadCategories() async {
    try {
      debugPrint('📥 AppController: Loading categories...');
      final response = await CategoryService.getAllCategories();
      if (response.success && response.data != null) {
        _categories = response.data!;
        debugPrint('✅ AppController: Loaded ${_categories.length} categories');
        notifyListeners();
      } else {
        debugPrint('❌ AppController: Failed to load categories: ${response.message}');
      }
    } catch (e) {
      debugPrint('❌ AppController: Exception loading categories: $e');
    }
  }

  Future<void> addCategory({
    required String name,
    String? description,
    String? imageUrl,
    File? imageFile,
    String? parentId,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      final response = await CategoryService.createCategory(
        name: name,
        description: description,
        imageUrl: imageUrl,
        imageFile: imageFile,
      );

      if (response.success) {
        await loadCategories();
      } else {
        _error = response.message;
      }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Lỗi tạo danh mục: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateCategory(
    String id, {
    required String name,
    String? description,
    String? imageUrl,
    File? imageFile,
    String? parentId,
    bool? isActive,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      final response = await CategoryService.updateCategory(
        id,
        name: name,
        description: description,
        imageUrl: imageUrl,
        imageFile: imageFile,
      );

      if (response.success) {
        await loadCategories();
      } else {
        _error = response.message;
      }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Lỗi cập nhật danh mục: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteCategory(String id) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      final response = await CategoryService.deleteCategory(id);
      if (response.success) {
        await loadCategories();
      } else {
        _error = response.message;
      }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Lỗi xóa danh mục: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addProductToCategory(String categoryId, String productId) async {
    _isLoading = true;
    notifyListeners();
    final response = await CategoryService.addProductToCategory(categoryId, productId);
    if (response.success) {
      // Reload products and categories to reflect changes
      await loadProducts();
      await loadCategories();
      _isLoading = false;
      notifyListeners();
      return true;
    }
    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<void> addProduct({
    required String name,
    required String categoryId,
    required int price,
    required int stock,
    String? imageUrl,
    List<String>? imageFiles,
  }) async {
    try {
      final response = await ProductService.createProduct(
        name: name,
        description: name,
        price: price.toDouble(),
        stock: stock,
        categoryId: categoryId,
        imageUrl: imageUrl,
        imageFiles: imageFiles,
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
    required String categoryId,
    required int price,
    required int stock,
    String? imageUrl,
    List<String>? imageFiles,
  }) async {
    try {
      final response = await ProductService.updateProduct(
        id: int.parse(id),
        name: name,
        price: price.toDouble(),
        stock: stock,
        categoryId: categoryId,
        imageUrl: imageUrl,
        imageFiles: imageFiles,
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

  List<Order> get filteredOrders {
    return _orders.where((o) {
      final passStatus = o.status == _orderFilter;
      final passSearch =
          _orderSearch.isEmpty ||
          StringUtils.containsSearch(o.code, _orderSearch) ||
          StringUtils.containsSearch(o.customerName, _orderSearch) ||
          StringUtils.containsSearch(o.phone, _orderSearch);
      return passStatus && passSearch;
    }).toList();
  }

  Future<void> rejectOrder(String id, {String? reason}) async {
    try {
      final order = _orders.firstWhere((o) => o.id == id);
      final response = await OrderService.updateOrderStatus(
        orderId: order.code,
        status: 'CANCELLED',
        cancelReason: reason ?? 'Hủy bởi quản trị viên',
      );

      if (response.success) {
        await loadOrders();
        await loadRevenueOverview();
      } else {
        _error = response.message;
        notifyListeners();
      }
    } catch (e) {
      _error = 'Lỗi hủy đơn hàng: $e';
      notifyListeners();
    }
  }

  Future<void> confirmOrder(String id, {String? carrierName, double? shippingFee}) async {
    try {
      final order = _orders.firstWhere((o) => o.id == id);
      debugPrint('📦 [confirmOrder] id=$id order.code=${order.code} carrier=$carrierName fee=$shippingFee');

      final response = await OrderService.updateOrderStatus(
        orderId: order.code,
        status: 'SHIPPING',
        carrierName: carrierName ?? 'Giao Hàng Nhanh',
        shippingFee: shippingFee,
      );

      debugPrint('📦 [confirmOrder] response.success=${response.success} message=${response.message}');

      if (response.success) {
        debugPrint('📦 [confirmOrder] ✅ Success → reloading orders');
        await loadOrders();
      } else {
        debugPrint('📦 [confirmOrder] ❌ Failed: ${response.message}');
        _error = response.message;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('📦 [confirmOrder] 💥 Exception: $e');
      _error = 'Lỗi xác nhận đơn hàng: $e';
      notifyListeners();
    }
  }

  Future<void> completeOrder(String id, {String? paymentMethod}) async {
    try {
      final order = _orders.firstWhere((o) => o.id == id);
      final response = await OrderService.updateOrderStatus(
        orderId: order.code,
        status: 'DELIVERED',
        paymentMethod: paymentMethod,
      );

      if (response.success) {
        await loadOrders();
        await loadRevenueOverview();
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
        final pagination = response.data!['pagination'];
        _totalUsers = pagination != null
            ? (pagination['total'] ?? _users.length)
            : _users.length;
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

  Future<void> updateUserRole(String id, String role) async {
    try {
      final response = await UserService.updateUserRole(id, role);
      if (response.success) {
        await loadUsers();
      } else {
        _error = response.message;
        notifyListeners();
      }
    } catch (e) {
      _error = 'Lỗi cập nhật quyền hạn: $e';
      notifyListeners();
    }
  }

  // --- Coupon Management ---
  Future<void> loadCoupons() async {
    try {
      debugPrint('📥 AppController: Loading coupons and stats...');
      // Admin API for coupons returns { coupons, stats }
      final response = await ApiService.get<Map<String, dynamic>>(
        ApiConfig.adminCoupons,
        fromJson: (json) => json as Map<String, dynamic>,
      );

      if (response.success && response.data != null) {
        final couponsData = response.data!['coupons'] as List? ?? [];
        _coupons = couponsData.map((c) => Coupon.fromJson(c)).toList();
        
        if (response.data!['stats'] != null) {
          _couponStats = response.data!['stats'];
        }
        
        notifyListeners();
        debugPrint('✅ AppController: Loaded ${_coupons.length} coupons and stats');
      }
    } catch (e) {
      debugPrint('❌ AppController: Error loading coupons: $e');
    }
  }

  Future<void> loadCouponStats() async {
    try {
      final response = await CouponService.getCouponStats();
      if (response.success && response.data != null) {
        _couponStats = response.data;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading coupon stats: $e');
    }
  }

  Future<void> addCoupon(Map<String, dynamic> data) async {
    try {
      final response = await CouponService.createCoupon(data);
      if (response.success) {
        await loadCoupons();
        await loadCouponStats();
      } else {
        _error = response.message;
        notifyListeners();
      }
    } catch (e) {
      _error = 'Lỗi tạo mã giảm giá: $e';
      notifyListeners();
    }
  }

  Future<void> updateCoupon(String id, Map<String, dynamic> data) async {
    try {
      final response = await CouponService.updateCoupon(id, data);
      if (response.success) {
        await loadCoupons();
      } else {
        _error = response.message;
        notifyListeners();
      }
    } catch (e) {
      _error = 'Lỗi cập nhật mã giảm giá: $e';
      notifyListeners();
    }
  }

  Future<void> deleteCoupon(String id) async {
    try {
      final response = await CouponService.deleteCoupon(id);
      if (response.success) {
        await loadCoupons();
        await loadCouponStats();
      } else {
        _error = response.message;
        notifyListeners();
      }
    } catch (e) {
      _error = 'Lỗi xóa mã giảm giá: $e';
      notifyListeners();
    }
  }

  Future<void> toggleCouponStatus(String id) async {
    try {
      final response = await CouponService.toggleCouponStatus(id);
      if (response.success) {
        await loadCoupons();
        await loadCouponStats();
      } else {
        _error = response.message;
        notifyListeners();
      }
    } catch (e) {
      _error = 'Lỗi thay đổi trạng thái: $e';
      notifyListeners();
    }
  }

  // --- Revenue Management ---
  List<dynamic> _revenueByCategoryData = [];
  List<dynamic> get revenueByCategoryData => _revenueByCategoryData;

  List<dynamic> _revenueByPaymentData = [];
  List<dynamic> get revenueByPaymentData => _revenueByPaymentData;

  Future<void> loadRevenueOverview() async {
    try {
      final response = await RevenueService.getRevenueOverview();
      if (response.success && response.data != null) {
        _revenueData = response.data;
        debugPrint('📊 AppController: Revenue raw data overview: ${_revenueData!['overview']}');
        
        if (_revenueData!['overview'] != null) {
          final delRev = _revenueData!['overview']['delivered_revenue'];
          final totOrd = _revenueData!['overview']['total_orders'];
          debugPrint('📊 AppController: delivered_revenue type: ${delRev.runtimeType}, total_orders type: ${totOrd.runtimeType}');
          
          _totalRevenue = ParseUtils.parseInt(delRev);
          _totalOrders = ParseUtils.parseInt(totOrd);
        }
        notifyListeners();
        debugPrint('✅ AppController: Loaded revenue overview');
      }
    } catch (e) {
      debugPrint('Error loading revenue overview: $e');
    }
  }

  int get totalProducts => _totalProducts;
  int get totalUsers => _totalUsers;
  int get totalCustomers => _users.where((u) => u.role == 'USER').length;

  List<User> get filteredUsers {
    return _users.where((u) {
      final passSearch =
          _userSearch.isEmpty ||
          StringUtils.containsSearch(u.fullName, _userSearch) ||
          StringUtils.containsSearch(u.email ?? '', _userSearch) ||
          StringUtils.containsSearch(u.phoneNumber ?? '', _userSearch);
      return passSearch;
    }).toList();
  }

  Future<void> loadRevenueByCategory() async {
    try {
      final response = await RevenueService.getRevenueByCategory();
      if (response.success && response.data != null) {
        _revenueByCategoryData = response.data!;
        notifyListeners();
        debugPrint('✅ AppController: Loaded revenue by category (${_revenueByCategoryData.length} items)');
      }
    } catch (e) {
      debugPrint('Error loading revenue by category: $e');
    }
  }

  Future<void> loadRevenueByPayment() async {
    try {
      final response = await RevenueService.getRevenueByPaymentMethod();
      if (response.success && response.data != null) {
        _revenueByPaymentData = response.data!;
        notifyListeners();
        debugPrint('✅ AppController: Loaded revenue by payment (${_revenueByPaymentData.length} items)');
      }
    } catch (e) {
      debugPrint('Error loading revenue by payment: $e');
    }
  }

  Future<void> loadInitialDashboardData() async {
    final now = DateTime.now();
    final start = now.subtract(Duration(days: now.weekday - 1));
    final end = start.add(const Duration(days: 6));
    
    final startStr = start.toIso8601String().split('T')[0];
    final endStr = end.toIso8601String().split('T')[0];
    
    await loadAllRevenueData(startDate: startStr, endDate: endStr);
  }

  Future<void> loadAllRevenueData({String? startDate, String? endDate}) async {
    try {
      final response = await RevenueService.getDashboardData(startDate: startDate, endDate: endDate);
      if (response.success && response.data != null) {
        _revenueData = response.data;
        
        if (_revenueData!['global'] != null) {
          final delRev = _revenueData!['global']['all_time_revenue'];
          final totOrd = _revenueData!['global']['all_time_orders'];
          final curMonOrd = _revenueData!['global']['current_month_orders'];
          _totalRevenue = ParseUtils.parseInt(delRev);
          _totalOrders = ParseUtils.parseInt(totOrd);
          _currentMonthOrders = ParseUtils.parseInt(curMonOrd);
        }
        
        _revenueByCategoryData = _revenueData!['categories'] ?? [];
        _revenueByPaymentData = _revenueData!['paymentMethods'] ?? [];
        
        notifyListeners();
        debugPrint('✅ AppController: Loaded unified dashboard data');
      }
    } catch (e) {
      debugPrint('Error loading dashboard data: $e');
    }
  }
  Future<String> chatWithAI(String message, {List<Map<String, dynamic>>? history}) async {
    try {
      final response = await ApiService.post<Map<String, dynamic>>(
        ApiConfig.adminAiChat,
        body: {
          'message': message,
          'history': history,
          'context': {
            'totalRevenue': _totalRevenue,
            'totalOrders': _totalOrders,
            'totalProducts': _totalProducts,
            'totalUsers': _totalUsers,
            'revenueData': _revenueData,
          }
        },
        fromJson: (json) => json as Map<String, dynamic>,
      );

      if (response.success && response.data != null) {
        return response.data!['reply'] ?? 'Không nhận được câu trả lời từ AI.';
      } else {
        return response.message;
      }
    } catch (e) {
      return 'Lỗi kết nối AI: $e';
    }
  }
}
