import '../api_service.dart';
import '../api_config.dart';
import '../api_response.dart';
import '../models.dart';

class CouponService {
  static const String couponPath = '${ApiConfig.apiPrefix}/admin/coupons';

  static Future<ApiResponse<List<Coupon>>> getCoupons() async {
    return await ApiService.get<List<Coupon>>(
      couponPath,
      fromJson: (data) {
        if (data is List) {
          return data.map((json) => Coupon.fromJson(json)).toList();
        }
        return [];
      },
    );
  }

  static Future<ApiResponse<Map<String, dynamic>>> createCoupon(Map<String, dynamic> data) async {
    return await ApiService.post<Map<String, dynamic>>(
      couponPath,
      body: data,
      fromJson: (data) => data as Map<String, dynamic>,
    );
  }

  static Future<ApiResponse<Map<String, dynamic>>> updateCoupon(String id, Map<String, dynamic> data) async {
    return await ApiService.put<Map<String, dynamic>>(
      '$couponPath/$id',
      body: data,
      fromJson: (data) => data as Map<String, dynamic>,
    );
  }

  static Future<ApiResponse<Map<String, dynamic>>> deleteCoupon(String id) async {
    return await ApiService.delete<Map<String, dynamic>>(
      '$couponPath/$id',
      fromJson: (data) => data as Map<String, dynamic>,
    );
  }

  static Future<ApiResponse<Map<String, dynamic>>> toggleCouponStatus(String id) async {
    return await ApiService.patch<Map<String, dynamic>>(
      '$couponPath/$id/toggle-status',
      body: {},
      fromJson: (data) => data as Map<String, dynamic>,
    );
  }

  static Future<ApiResponse<Map<String, dynamic>>> getCouponStats() async {
    return await ApiService.get<Map<String, dynamic>>(
      '$couponPath/stats',
      fromJson: (data) => data as Map<String, dynamic>,
    );
  }
}
