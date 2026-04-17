import '../api_service.dart';
import '../api_config.dart';
import '../api_response.dart';

/// User Service for Admin
class UserService {
  /// Get all users with pagination
  static Future<ApiResponse<Map<String, dynamic>>> getUsers({
    int page = 1,
    int limit = 20,
    String? search,
    String? role,
  }) async {
    return await ApiService.get<Map<String, dynamic>>(
      ApiConfig.adminUsers,
      queryParams: {
        'page': page.toString(),
        'limit': limit.toString(),
        if (search != null) 'search': search,
        if (role != null) 'role': role,
      },
      fromJson: (data) => data as Map<String, dynamic>,
    );
  }
  
  /// Get user by ID
  static Future<ApiResponse<Map<String, dynamic>>> getUserById(int id) async {
    return await ApiService.get<Map<String, dynamic>>(
      '${ApiConfig.users}/$id',
      fromJson: (data) => data as Map<String, dynamic>,
    );
  }
  
  /// Update user
  static Future<ApiResponse<Map<String, dynamic>>> updateUser({
    required int id,
    String? username,
    String? email,
    String? fullName,
    String? phoneNumber,
    String? role,
  }) async {
    return await ApiService.put<Map<String, dynamic>>(
      '${ApiConfig.users}/$id',
      body: {
        if (username != null) 'username': username,
        if (email != null) 'email': email,
        if (fullName != null) 'fullName': fullName,
        if (phoneNumber != null) 'phoneNumber': phoneNumber,
        if (role != null) 'role': role,
      },
      fromJson: (data) => data as Map<String, dynamic>,
    );
  }
  
  /// Delete user
  static Future<ApiResponse<Map<String, dynamic>>> deleteUser(int id) async {
    return await ApiService.delete<Map<String, dynamic>>(
      '${ApiConfig.users}/$id',
      fromJson: (data) => data as Map<String, dynamic>,
    );
  }
  
  /// Toggle user status (active/inactive)
  static Future<ApiResponse<Map<String, dynamic>>> toggleUserStatus(int id) async {
    return await ApiService.put<Map<String, dynamic>>(
      '${ApiConfig.users}/$id/toggle-status',
      fromJson: (data) => data as Map<String, dynamic>,
    );
  }
  
  /// Get user statistics
  static Future<ApiResponse<Map<String, dynamic>>> getUserStats() async {
    return await ApiService.get<Map<String, dynamic>>(
      '${ApiConfig.users}/stats',
      fromJson: (data) => data as Map<String, dynamic>,
    );
  }
}
