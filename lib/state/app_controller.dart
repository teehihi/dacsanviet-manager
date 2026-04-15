import 'package:flutter/foundation.dart';

import '../domain/models.dart';

class AppController extends ChangeNotifier {
  bool _isAuthenticated = false;
  int _tabIndex = 0;
  String _productSearch = '';
  String _productCategory = 'Tất cả';
  OrderStatus _orderFilter = OrderStatus.pending;

  bool get isAuthenticated => _isAuthenticated;
  int get tabIndex => _tabIndex;
  String get productSearch => _productSearch;
  String get productCategory => _productCategory;
  OrderStatus get orderFilter => _orderFilter;

  final List<Product> _products = [
    Product(id: 'p1', name: 'Nước mắm Phú Quốc', category: 'Gia vị', price: 250000, stock: 45),
    Product(id: 'p2', name: 'Cà phê Buôn Ma Thuột', category: 'Đồ uống', price: 180000, stock: 32),
    Product(id: 'p3', name: 'Bánh pía Sóc Trăng', category: 'Bánh kẹo', price: 120000, stock: 28),
    Product(id: 'p4', name: 'Mứt dừa Bến Tre', category: 'Bánh kẹo', price: 95000, stock: 56),
    Product(id: 'p5', name: 'Tôm khô Cà Mau', category: 'Hải sản', price: 280000, stock: 24),
  ];

  final List<Order> _orders = [
    Order(
      id: 'o1',
      code: 'DH-2456',
      customerName: 'Nguyễn Văn A',
      phone: '0901 234 567',
      address: 'Quận 1, TP.HCM',
      productSummary: 'Nước mắm Phú Quốc x2',
      totalAmount: 500000,
      paymentMethod: 'COD',
      status: OrderStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
    ),
    Order(
      id: 'o2',
      code: 'DH-2457',
      customerName: 'Trần Thị B',
      phone: '0912 345 678',
      address: 'Quận 3, TP.HCM',
      productSummary: 'Cà phê Buôn Ma Thuột x1',
      totalAmount: 180000,
      paymentMethod: 'ZaloPay',
      status: OrderStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(minutes: 25)),
    ),
    Order(
      id: 'o3',
      code: 'DH-2455',
      customerName: 'Phạm Thị D',
      phone: '0934 567 890',
      address: 'Quận 2, TP.HCM',
      productSummary: 'Mứt dừa Bến Tre x2',
      totalAmount: 190000,
      paymentMethod: 'Momo',
      status: OrderStatus.shipping,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    Order(
      id: 'o4',
      code: 'DH-2453',
      customerName: 'Võ Thị F',
      phone: '0956 789 012',
      address: 'Quận 4, TP.HCM',
      productSummary: 'Tôm khô Cà Mau x2',
      totalAmount: 560000,
      paymentMethod: 'VNPay',
      status: OrderStatus.complete,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  List<Product> get products => List.unmodifiable(_products);
  List<Order> get orders => List.unmodifiable(_orders);

  void login() {
    _isAuthenticated = true;
    notifyListeners();
  }

  void logout() {
    _isAuthenticated = false;
    _tabIndex = 0;
    notifyListeners();
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

  List<Product> get filteredProducts {
    return _products.where((p) {
      final passCategory = _productCategory == 'Tất cả' || p.category == _productCategory;
      final passSearch = _productSearch.isEmpty || p.name.toLowerCase().contains(_productSearch);
      return passCategory && passSearch;
    }).toList();
  }

  void addProduct({
    required String name,
    required String category,
    required int price,
    required int stock,
    String? imageUrl,
  }) {
    final id = 'p${DateTime.now().microsecondsSinceEpoch}';
    _products.insert(0, Product(id: id, name: name, category: category, price: price, stock: stock, imageUrl: imageUrl));
    notifyListeners();
  }

  void updateProduct(
    String id, {
    required String name,
    required String category,
    required int price,
    required int stock,
    String? imageUrl,
  }) {
    final i = _products.indexWhere((p) => p.id == id);
    if (i < 0) return;
    _products[i]
      ..name = name
      ..category = category
      ..price = price
      ..stock = stock
      ..imageUrl = imageUrl;
    notifyListeners();
  }

  void deleteProduct(String id) {
    _products.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  void setOrderFilter(OrderStatus status) {
    _orderFilter = status;
    notifyListeners();
  }

  List<Order> get filteredOrders => _orders.where((o) => o.status == _orderFilter).toList();

  void rejectOrder(String id) {
    _orders.removeWhere((o) => o.id == id);
    notifyListeners();
  }

  void confirmOrder(String id) {
    final order = _orders.where((o) => o.id == id).firstOrNull;
    if (order == null) return;
    order.status = OrderStatus.shipping;
    notifyListeners();
  }

  void completeOrder(String id) {
    final order = _orders.where((o) => o.id == id).firstOrNull;
    if (order == null) return;
    order.status = OrderStatus.complete;
    notifyListeners();
  }

  int get totalOrders => _orders.length;
  int get totalProducts => _products.length;
  int get totalRevenue => _orders.fold(0, (sum, o) => sum + o.totalAmount);
  int get totalCustomers => _orders.map((o) => o.phone).toSet().length;
}
