import '../api_service.dart';
import '../api_config.dart';
import '../api_response.dart';
import '../models.dart';

/// User Service for Admin
class UserService {
  /// Get all users with pagination
  static Future<ApiResponse<Map<String, dynamic>>> getUsers({
    int page = 1,
    int limit = 50,
    String? search,
  }) async {
    return await ApiService.get<Map<String, dynamic>>(
      '${ApiConfig.apiPrefix}/admin/users',
      queryParams: {
        'page': page.toString(),
        'limit': limit.toString(),
        if (search != null && search.isNotEmpty) 'q': search,
      },
      fromJson: (data) => data as Map<String, dynamic>,
    );
  }
  
  /// Get user by ID
  static Future<ApiResponse<User>> getUserById(String id) async {
    return await ApiService.get<User>(
      '${ApiConfig.apiPrefix}/admin/users/$id',
      fromJson: (data) => User.fromJson(data['user']),
    );
  }
  
  /// Update user
  static Future<ApiResponse<User>> updateUser({
    required String id,
    String? fullName,
    String? phoneNumber,
  }) async {
    return await ApiService.put<User>(
      '${ApiConfig.apiPrefix}/admin/users/$id',
      body: {
        if (fullName != null) 'fullName': fullName,
        if (phoneNumber != null) 'phoneNumber': phoneNumber,
      },
      fromJson: (data) => User.fromJson(data['user']),
    );
  }
  
  /// Delete user
  static Future<ApiResponse<void>> deleteUser(String id) async {
    return await ApiService.delete<void>(
      '${ApiConfig.apiPrefix}/admin/users/$id',
    );
  }
  
  /// Toggle user status (active/inactive)
  static Future<ApiResponse<User>> toggleUserStatus(String id) async {
    return await ApiService.patch<User>(
      '${ApiConfig.apiPrefix}/admin/users/$id/toggle-status',
      fromJson: (data) => User.fromJson(data['user']),
    );
  }
  
  /// Get user statistics
  static Future<ApiResponse<Map<String, dynamic>>> getUserStats() async {
    return await ApiService.get<Map<String, dynamic>>(
      '${ApiConfig.apiPrefix}/admin/users/stats',
      fromJson: (data) => data as Map<String, dynamic>,
    );
  }
}
