import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';
import 'api_response.dart';

/// Base API Service for making HTTP requests
class ApiService {
  static String? _sessionId;
  
  static void setSessionId(String? sessionId) {
    _sessionId = sessionId;
  }
  
  static String? get sessionId => _sessionId;
  
  static Map<String, String> get _headers {
    if (_sessionId != null) {
      return ApiConfig.getAuthHeaders(_sessionId!);
    }
    return ApiConfig.defaultHeaders;
  }
  
  /// GET request
  static Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, String>? queryParams,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}$endpoint')
          .replace(queryParameters: queryParams);
      
      final response = await http.get(
        uri,
        headers: _headers,
      ).timeout(ApiConfig.connectionTimeout);
      
      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return ApiResponse<T>(
        success: false,
        message: 'Network error: $e',
        error: e.toString(),
      );
    }
  }
  
  /// POST request
  static Future<ApiResponse<T>> post<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}$endpoint');
      
      final response = await http.post(
        uri,
        headers: _headers,
        body: body != null ? jsonEncode(body) : null,
      ).timeout(ApiConfig.connectionTimeout);
      
      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return ApiResponse<T>(
        success: false,
        message: 'Network error: $e',
        error: e.toString(),
      );
    }
  }
  
  /// PUT request
  static Future<ApiResponse<T>> put<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}$endpoint');
      
      final response = await http.put(
        uri,
        headers: _headers,
        body: body != null ? jsonEncode(body) : null,
      ).timeout(ApiConfig.connectionTimeout);
      
      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return ApiResponse<T>(
        success: false,
        message: 'Network error: $e',
        error: e.toString(),
      );
    }
  }
  
  /// PATCH request
  static Future<ApiResponse<T>> patch<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}$endpoint');
      
      final response = await http.patch(
        uri,
        headers: _headers,
        body: body != null ? jsonEncode(body) : null,
      ).timeout(ApiConfig.connectionTimeout);
      
      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return ApiResponse<T>(
        success: false,
        message: 'Network error: $e',
        error: e.toString(),
      );
    }
  }
  
  /// DELETE request
  static Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}$endpoint');
      
      final response = await http.delete(
        uri,
        headers: _headers,
      ).timeout(ApiConfig.connectionTimeout);
      
      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return ApiResponse<T>(
        success: false,
        message: 'Network error: $e',
        error: e.toString(),
      );
    }
  }

  /// POST Multipart request
  static Future<ApiResponse<T>> postMultipart<T>(
    String endpoint, {
    Map<String, String>? fields,
    Map<String, dynamic>? files,
    T Function(dynamic)? fromJson,
  }) async {
    return multipartRequest<T>(
      endpoint,
      method: 'POST',
      fields: fields,
      files: files,
      fromJson: fromJson,
    );
  }

  /// PUT Multipart request
  static Future<ApiResponse<T>> putMultipart<T>(
    String endpoint, {
    Map<String, String>? fields,
    Map<String, dynamic>? files,
    T Function(dynamic)? fromJson,
  }) async {
    return multipartRequest<T>(
      endpoint,
      method: 'PUT',
      fields: fields,
      files: files,
      fromJson: fromJson,
    );
  }

  /// Multipart request (for file uploads)
  static Future<ApiResponse<T>> multipartRequest<T>(
    String endpoint, {
    String method = 'POST',
    Map<String, String>? fields,
    Map<String, dynamic>? files, // fieldName: filePath or List<filePath>
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}$endpoint');
      final request = http.MultipartRequest(method, uri);
      
      // Only add Authorization header, NOT Content-Type
      // MultipartRequest sets its own Content-Type with boundary automatically
      if (_sessionId != null) {
        request.headers['Authorization'] = 'Bearer $_sessionId';
      }
      request.headers['Accept'] = 'application/json';
      
      // Add fields
      if (fields != null) {
        request.fields.addAll(fields);
      }
      
      // Add files (support both single file and multiple files)
      if (files != null) {
        for (var entry in files.entries) {
          if (entry.value is List) {
            // Multiple files with same field name
            for (var filePath in entry.value) {
              request.files.add(await http.MultipartFile.fromPath(
                entry.key,
                filePath,
              ));
            }
          } else if (entry.value is String) {
            // Single file
            request.files.add(await http.MultipartFile.fromPath(
              entry.key,
              entry.value,
            ));
          }
        }
      }
      
      final streamedResponse = await request.send().timeout(ApiConfig.connectionTimeout);
      final response = await http.Response.fromStream(streamedResponse);
      
      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return ApiResponse<T>(
        success: false,
        message: 'Multipart error: $e',
        error: e.toString(),
      );
    }
  }
  
  /// Handle HTTP response
  static ApiResponse<T> _handleResponse<T>(
    http.Response response,
    T Function(dynamic)? fromJson,
  ) {
    try {
      final jsonData = jsonDecode(response.body);
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ApiResponse<T>.fromJson(jsonData, fromJson);
      } else {
        return ApiResponse<T>(
          success: false,
          message: jsonData['message'] ?? 'Request failed',
          error: jsonData['error'],
        );
      }
    } catch (e) {
      return ApiResponse<T>(
        success: false,
        message: 'Failed to parse response: $e',
        error: e.toString(),
      );
    }
  }
}
