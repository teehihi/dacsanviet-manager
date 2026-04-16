enum OrderStatus { pending, shipping, complete }

extension OrderStatusX on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.pending:
        return 'Chờ xác nhận';
      case OrderStatus.shipping:
        return 'Đang giao';
      case OrderStatus.complete:
        return 'Đã giao';
    }
  }
}

class Product {
  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.stock,
    this.imageUrl,
  });

  final String id;
  String name;
  String category;
  int price;
  int stock;
  String? imageUrl;
}

class Order {
  Order({
    required this.id,
    required this.code,
    required this.customerName,
    required this.phone,
    required this.address,
    required this.productSummary,
    required this.totalAmount,
    required this.paymentMethod,
    required this.status,
    required this.createdAt,
  });

  final String id;
  final String code;
  final String customerName;
  final String phone;
  final String address;
  final String productSummary;
  final int totalAmount;
  final String paymentMethod;
  OrderStatus status;
  final DateTime createdAt;
}

class User {
  User({required this.id, required this.name, required this.email, this.avatarUrl});
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
}
