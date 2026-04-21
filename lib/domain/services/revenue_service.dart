import '../api_service.dart';
import '../api_config.dart';
import '../api_response.dart';

class RevenueService {
  static const String revenuePath = '${ApiConfig.apiPrefix}/admin/revenue';

  static Future<ApiResponse<Map<String, dynamic>>> getDashboardData({String? startDate, String? endDate}) async {
    return await ApiService.get<Map<String, dynamic>>(
      '$revenuePath/dashboard',
      queryParams: {
        if (startDate != null) 'startDate': startDate,
        if (endDate != null) 'endDate': endDate,
      },
      fromJson: (data) => data as Map<String, dynamic>,
    );
  }

  static Future<ApiResponse<Map<String, dynamic>>> getRevenueOverview({String? startDate, String? endDate}) async {
    return await ApiService.get<Map<String, dynamic>>(
      '$revenuePath/overview',
      queryParams: {
        if (startDate != null) 'startDate': startDate,
        if (endDate != null) 'endDate': endDate,
      },
      fromJson: (data) => data as Map<String, dynamic>,
    );
  }

  static Future<ApiResponse<Map<String, dynamic>>> getRevenueStats() async {
    return await getRevenueOverview();
  }

  static Future<ApiResponse<List<dynamic>>> getRevenueByCategory({String? startDate, String? endDate}) async {
    return await ApiService.get<List<dynamic>>(
      '$revenuePath/by-category',
      queryParams: {
        if (startDate != null) 'startDate': startDate,
        if (endDate != null) 'endDate': endDate,
      },
      fromJson: (data) => data as List<dynamic>,
    );
  }

  static Future<ApiResponse<List<dynamic>>> getRevenueByPaymentMethod({String? startDate, String? endDate}) async {
    return await ApiService.get<List<dynamic>>(
      '$revenuePath/by-payment-method',
      queryParams: {
        if (startDate != null) 'startDate': startDate,
        if (endDate != null) 'endDate': endDate,
      },
      fromJson: (data) => data as List<dynamic>,
    );
  }

  static Future<ApiResponse<List<dynamic>>> getProfitAnalysis() async {
    return await ApiService.get<List<dynamic>>(
      '$revenuePath/profit',
      fromJson: (data) => data as List<dynamic>,
    );
  }

  static Future<ApiResponse<List<dynamic>>> getCLV() async {
    return await ApiService.get<List<dynamic>>(
      '$revenuePath/customer-lifetime-value',
      fromJson: (data) => data as List<dynamic>,
    );
  }
}
