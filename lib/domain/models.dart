import 'api_config.dart';

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

  factory Product.fromJson(Map<String, dynamic> json) {
    String? rawUrl = json['image_url']?.toString() ?? json['imageUrl']?.toString();
    
    // Resolve relative URL
    if (rawUrl != null && !rawUrl.startsWith('http')) {
      final baseUrl = ApiConfig.baseUrl;
      final separator = (baseUrl.endsWith('/') || rawUrl.startsWith('/')) ? '' : '/';
      rawUrl = '$baseUrl$separator$rawUrl';
    }

    return Product(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      category: json['category_name'] ?? json['category'] ?? '',
      price: int.tryParse(json['price']?.toString() ?? '0') ?? 0,
      stock: int.tryParse(json['stock_quantity']?.toString() ?? json['stock']?.toString() ?? '0') ?? 0,
      imageUrl: rawUrl,
    );
  }
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
    this.deliveredAt,
    this.confirmedAt,
    this.cancelledAt,
    this.items,
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
  final DateTime? deliveredAt;
  final DateTime? confirmedAt;
  final DateTime? cancelledAt;
  final List<OrderItem>? items;

  factory Order.fromJson(Map<String, dynamic> json) {
    // Parse status
    OrderStatus status;
    final statusStr = (json['status']?.toString() ?? 'NEW').toUpperCase();
    if (statusStr == 'NEW' || statusStr == 'PENDING' || statusStr == 'PREPARING') {
      status = OrderStatus.pending;
    } else if (statusStr == 'CONFIRMED' || statusStr == 'SHIPPING') {
      status = OrderStatus.shipping;
    } else if (statusStr == 'DELIVERED' || statusStr == 'COMPLETE') {
      status = OrderStatus.complete;
    } else if (statusStr == 'CANCELLED' || statusStr == 'REJECTED') {
      status = OrderStatus.cancelled;
    } else {
      status = OrderStatus.complete;
    }

    // Parse items
    List<OrderItem>? items;
    String productSummary = '';
    if (json['items'] != null && json['items'] is List) {
      final itemsList = json['items'] as List;
      items = itemsList.map((i) => OrderItem.fromJson(i as Map<String, dynamic>)).toList();
      productSummary = items.map((item) => '${item.productName} x${item.quantity}').join(', ');
    } else {
      productSummary = json['productSummary'] ?? json['product_summary'] ?? 'Đơn hàng';
    }

    return Order(
      id: json['id']?.toString() ?? '',
      code: json['order_number'] ?? json['code'] ?? 'ORD-${json['id']}',
      customerName: json['customer_name'] ?? json['customerName'] ?? 'Khách hàng',
      phone: json['phone'] ?? json['customer_phone'] ?? '',
      address: json['shipping_address_text'] ?? json['shipping_address'] ?? json['address'] ?? '',
      productSummary: productSummary,
      totalAmount: (json['total_amount'] ?? json['totalAmount'] ?? 0) is int 
          ? (json['total_amount'] ?? json['totalAmount'] ?? 0) 
          : (double.tryParse((json['total_amount'] ?? json['totalAmount'] ?? 0).toString())?.toInt() ?? 0),
      paymentMethod: json['payment_method'] ?? json['paymentMethod'] ?? 'COD',
      status: status,
      createdAt: (json['created_at'] != null ? DateTime.tryParse(json['created_at']) : 
                  json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : 
                  json['order_date'] != null ? DateTime.tryParse(json['order_date']) : null)?.toLocal() ?? DateTime.now(),
      deliveredAt: (json['delivered_at'] != null ? DateTime.tryParse(json['delivered_at']) : 
                    json['deliveredAt'] != null ? DateTime.tryParse(json['deliveredAt']) : null)?.toLocal(),
      confirmedAt: (json['confirmed_at'] != null ? DateTime.tryParse(json['confirmed_at']) : 
                    json['confirmedAt'] != null ? DateTime.tryParse(json['confirmedAt']) : null)?.toLocal(),
      cancelledAt: (json['cancelled_at'] != null ? DateTime.tryParse(json['cancelled_at']) : 
                    json['cancelledAt'] != null ? DateTime.tryParse(json['cancelledAt']) : null)?.toLocal(),
      items: items,
    );
  }
  
  // Get the most recent status change time
  DateTime get lastStatusChangeTime {
    if (deliveredAt != null) return deliveredAt!;
    if (cancelledAt != null) return cancelledAt!;
    if (confirmedAt != null) return confirmedAt!;
    return createdAt;
  }
}

class OrderItem {
  OrderItem({
    required this.productName,
    required this.quantity,
    required this.price,
    this.productImage,
  });

  final String productName;
  final int quantity;
  final int price;
  final String? productImage;

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    String? rawUrl = json['product_image_url'] ?? json['product_image'] ?? json['productImage'];
    
    // Resolve relative URL
    if (rawUrl != null && !rawUrl.startsWith('http')) {
      final baseUrl = ApiConfig.baseUrl;
      final separator = (baseUrl.endsWith('/') || rawUrl.startsWith('/')) ? '' : '/';
      rawUrl = '$baseUrl$separator$rawUrl';
    }

    return OrderItem(
      productName: json['product_name'] ?? json['productName'] ?? '',
      quantity: (json['quantity'] ?? 0) is int ? json['quantity'] : (int.tryParse(json['quantity'].toString()) ?? 0),
      price: (json['unit_price'] ?? json['price'] ?? 0) is int 
          ? (json['unit_price'] ?? json['price'] ?? 0) 
          : (double.tryParse((json['unit_price'] ?? json['price'] ?? 0).toString())?.toInt() ?? 0),
      productImage: rawUrl,
    );
  }
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
    String? rawUrl = json['avatarUrl']?.toString() ?? json['avatar_url']?.toString();
    
    // Resolve relative URL
    if (rawUrl != null && !rawUrl.startsWith('http')) {
      final baseUrl = ApiConfig.baseUrl;
      final separator = (baseUrl.endsWith('/') || rawUrl.startsWith('/')) ? '' : '/';
      rawUrl = '$baseUrl$separator$rawUrl';
    }

    return User(
      id: json['id']?.toString() ?? '',
      email: json['email'] ?? '',
      fullName: json['fullName'] ?? json['full_name'] ?? json['username'] ?? '',
      phoneNumber: json['phoneNumber'] ?? json['phone_number'] ?? json['phone'] ?? '',
      role: json['role'] ?? 'USER',
      isActive: json['isActive'] == 1 || json['isActive'] == true || json['is_active'] == 1 || json['is_active'] == true,
      address: json['address']?.toString(),
      avatarUrl: rawUrl,
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
    String? rawUrl = json['image_url']?.toString() ?? json['imageUrl']?.toString();
    
    // Resolve relative URL
    if (rawUrl != null && !rawUrl.startsWith('http')) {
      final baseUrl = ApiConfig.baseUrl;
      final separator = (baseUrl.endsWith('/') || rawUrl.startsWith('/')) ? '' : '/';
      rawUrl = '$baseUrl$separator$rawUrl';
    }

    return Category(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      description: json['description'],
      imageUrl: rawUrl,
      isActive: json['is_active'] == 1 || json['is_active'] == true,
    );
  }
}

