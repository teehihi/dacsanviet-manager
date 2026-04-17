import '../api_service.dart';
import '../api_config.dart';
import '../api_response.dart';

/// Order Service for Admin
class OrderService {
  /// Get all orders with pagination
  static Future<ApiResponse<Map<String, dynamic>>> getOrders({
    int page = 1,
    int limit = 20,
    String? status,
    String? search,
  }) async {
    return await ApiService.get<Map<String, dynamic>>(
      ApiConfig.orders,
      queryParams: {
        'page': page.toString(),
        'limit': limit.toString(),
        if (status != null) 'status': status,
        if (search != null) 'search': search,
      },
      fromJson: (data) => data as Map<String, dynamic>,
    );
  }
  
  /// Get order by ID
  static Future<ApiResponse<Map<String, dynamic>>> getOrderById(String orderId) async {
    return await ApiService.get<Map<String, dynamic>>(
      '${ApiConfig.orders}/$orderId',
      fromJson: (data) => data as Map<String, dynamic>,
    );
  }
  
  /// Update order status
  static Future<ApiResponse<Map<String, dynamic>>> updateOrderStatus({
    required String orderId,
    required String status,
  }) async {
    return await ApiService.put<Map<String, dynamic>>(
      '${ApiConfig.orders}/$orderId/status',
      body: {
        'status': status,
      },
      fromJson: (data) => data as Map<String, dynamic>,
    );
  }
  
  /// Get order statistics
  static Future<ApiResponse<Map<String, dynamic>>> getOrderStats() async {
    return await ApiService.get<Map<String, dynamic>>(
      '${ApiConfig.orders}/stats',
      fromJson: (data) => data as Map<String, dynamic>,
    );
  }
  
  /// Cancel order
  static Future<ApiResponse<Map<String, dynamic>>> cancelOrder(String orderId) async {
    return await ApiService.put<Map<String, dynamic>>(
      '${ApiConfig.orders}/$orderId/cancel',
      fromJson: (data) => data as Map<String, dynamic>,
    );
  }
}
