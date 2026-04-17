import '../api_service.dart';
import '../api_config.dart';
import '../api_response.dart';

/// Authentication Service
class AuthService {
  /// Login with email and password
  static Future<ApiResponse<Map<String, dynamic>>> login({
    required String email,
    required String password,
  }) async {
    final response = await ApiService.post<Map<String, dynamic>>(
      ApiConfig.authLogin,
      body: {
        'email': email,
        'password': password,
      },
      fromJson: (data) => data as Map<String, dynamic>,
    );
    
    // Save token if login successful
    if (response.success && response.data != null) {
      // Try different possible locations for token
      String? token;
      
      // Priority 1: data.token (main JWT token)
      token = response.data!['token'] as String?;
      
      // Priority 2: data.tokens.accessToken
      if (token == null && response.data!['tokens'] != null && response.data!['tokens'] is Map) {
        token = response.data!['tokens']['accessToken'] as String?;
      }
      
      // Priority 3: data.session.sessionId (fallback)
      if (token == null && response.data!['session'] != null && response.data!['session'] is Map) {
        token = response.data!['session']['sessionId'] as String?;
      }
      
      // Priority 4: data.sessionId (fallback)
      token ??= response.data!['sessionId'] as String?;
      
      if (token != null) {
        ApiService.setSessionId(token);
        print('✅ Token saved: ${token.substring(0, 20)}...');
      } else {
        print('⚠️ No token found in response');
      }
    }
    
    return response;
  }
  
  /// Register new account
  static Future<ApiResponse<Map<String, dynamic>>> register({
    required String username,
    required String email,
    required String password,
    String? fullName,
    String? phoneNumber,
  }) async {
    return await ApiService.post<Map<String, dynamic>>(
      ApiConfig.authRegister,
      body: {
        'username': username,
        'email': email,
        'password': password,
        if (fullName != null) 'fullName': fullName,
        if (phoneNumber != null) 'phoneNumber': phoneNumber,
      },
      fromJson: (data) => data as Map<String, dynamic>,
    );
  }
  
  /// Logout
  static Future<ApiResponse<Map<String, dynamic>>> logout() async {
    final response = await ApiService.post<Map<String, dynamic>>(
      ApiConfig.authLogout,
      fromJson: (data) => data as Map<String, dynamic>,
    );
    
    // Clear session ID
    if (response.success) {
      ApiService.setSessionId(null);
    }
    
    return response;
  }
  
  /// Check session validity
  static Future<ApiResponse<Map<String, dynamic>>> checkSession() async {
    return await ApiService.post<Map<String, dynamic>>(
      ApiConfig.authCheckSession,
      fromJson: (data) => data as Map<String, dynamic>,
    );
  }
  
  /// Logout from all devices
  static Future<ApiResponse<Map<String, dynamic>>> logoutAll() async {
    final response = await ApiService.post<Map<String, dynamic>>(
      '${ApiConfig.authLogout}-all',
      fromJson: (data) => data as Map<String, dynamic>,
    );
    
    // Clear session ID
    if (response.success) {
      ApiService.setSessionId(null);
    }
    
    return response;
  }
}
