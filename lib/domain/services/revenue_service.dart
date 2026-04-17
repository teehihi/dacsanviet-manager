import '../api_service.dart';
import '../api_config.dart';
import '../api_response.dart';

/// Revenue Service for Admin
class RevenueService {
  /// Get revenue statistics
  static Future<ApiResponse<Map<String, dynamic>>> getRevenueStats({
    String? startDate,
    String? endDate,
    String? period, // 'day', 'week', 'month', 'year'
  }) async {
    return await ApiService.get<Map<String, dynamic>>(
      ApiConfig.adminRevenue,
      queryParams: {
        if (startDate != null) 'startDate': startDate,
        if (endDate != null) 'endDate': endDate,
        if (period != null) 'period': period,
      },
      fromJson: (data) => data as Map<String, dynamic>,
    );
  }
  
  /// Get daily revenue
  static Future<ApiResponse<Map<String, dynamic>>> getDailyRevenue() async {
    return await ApiService.get<Map<String, dynamic>>(
      '${ApiConfig.adminRevenue}/daily',
      fromJson: (data) => data as Map<String, dynamic>,
    );
  }
  
  /// Get monthly revenue
  static Future<ApiResponse<Map<String, dynamic>>> getMonthlyRevenue() async {
    return await ApiService.get<Map<String, dynamic>>(
      '${ApiConfig.adminRevenue}/monthly',
      fromJson: (data) => data as Map<String, dynamic>,
    );
  }
  
  /// Get yearly revenue
  static Future<ApiResponse<Map<String, dynamic>>> getYearlyRevenue() async {
    return await ApiService.get<Map<String, dynamic>>(
      '${ApiConfig.adminRevenue}/yearly',
      fromJson: (data) => data as Map<String, dynamic>,
    );
  }
  
  /// Get top selling products
  static Future<ApiResponse<List<dynamic>>> getTopProducts({
    int limit = 10,
  }) async {
    return await ApiService.get<List<dynamic>>(
      '${ApiConfig.adminRevenue}/top-products',
      queryParams: {
        'limit': limit.toString(),
      },
      fromJson: (data) => data as List<dynamic>,
    );
  }
}
