enum OrderStatus { pending, shipping, complete, cancelled }

extension OrderStatusX on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.pending:
        return 'Chờ xác nhận';
      case OrderStatus.shipping:
        return 'Đang giao';
      case OrderStatus.complete:
        return 'Đã giao';
      case OrderStatus.cancelled:
        return 'Đã hủy';
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
  User({
    required this.id,
    required this.email,
    required this.fullName,
    required this.phoneNumber,
    required this.role,
    required this.isActive,
    this.address,
    this.avatarUrl,
    this.createdAt,
  });

  final String id;
  final String email;
  String fullName;
  String phoneNumber;
  String role;
  bool isActive;
  String? address;
  String? avatarUrl;
  final DateTime? createdAt;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      email: json['email'] ?? '',
      fullName: json['fullName'] ?? json['full_name'] ?? json['username'] ?? '',
      phoneNumber: json['phoneNumber'] ?? json['phone_number'] ?? json['phone'] ?? '',
      role: json['role'] ?? 'USER',
      isActive: json['isActive'] == 1 || json['isActive'] == true || json['is_active'] == 1 || json['is_active'] == true,
      address: json['address']?.toString(),
      avatarUrl: json['avatarUrl'] ?? json['avatar_url'],
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : 
                 json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null,
    );
  }
}


class AdminNotification {
  final String id;
  final String title;
  final String body;
  final DateTime timestamp;
  final Map<String, dynamic>? data;

  AdminNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    this.data,
  });
}

class Coupon {
  final String id;
  final String code;
  final String type; // 'FIXED', 'PERCENTAGE'
  final double value;
  final double minOrderAmount;
  final double? maxDiscountAmount;
  final int? usageLimit;
  final int usedCount;
  final DateTime? validFrom;
  final DateTime? validTo;
  final String? description;
  final bool isActive;

  Coupon({
    required this.id,
    required this.code,
    required this.type,
    required this.value,
    required this.minOrderAmount,
    this.maxDiscountAmount,
    this.usageLimit,
    required this.usedCount,
    this.validFrom,
    this.validTo,
    this.description,
    required this.isActive,
  });

  factory Coupon.fromJson(Map<String, dynamic> json) {
    return Coupon(
      id: json['id'].toString(),
      code: json['code'] ?? '',
      type: json['type'] ?? 'FIXED',
      value: (json['value'] ?? 0).toDouble(),
      minOrderAmount: (json['min_order_amount'] ?? 0).toDouble(),
      maxDiscountAmount: json['max_discount_amount'] != null ? json['max_discount_amount'].toDouble() : null,
      usageLimit: json['usage_limit'],
      usedCount: json['used_count'] ?? 0,
      validFrom: json['valid_from'] != null ? DateTime.tryParse(json['valid_from']) : null,
      validTo: json['valid_to'] != null ? DateTime.tryParse(json['valid_to']) : null,
      description: json['description'],
      isActive: json['is_active'] == 1 || json['is_active'] == true,
    );
  }
}

class Category {
  final String id;
  final String name;
  final String? description;
  final String? imageUrl;
  final bool isActive;

  Category({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    required this.isActive,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      description: json['description'],
      imageUrl: json['image_url'],
      isActive: json['is_active'] == 1 || json['is_active'] == true,
    );
  }
}

