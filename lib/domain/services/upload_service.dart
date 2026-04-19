import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../api_config.dart';
import '../api_service.dart';
import '../api_response.dart';

/// Upload Service for images
class UploadService {
  /// Upload image file
  static Future<ApiResponse<Map<String, dynamic>>> uploadImage(
    File imageFile,
  ) async {
    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}/api/upload/image');
      final request = http.MultipartRequest('POST', uri);

      // Add session ID if available
      final sessionId = ApiService.sessionId;
      if (sessionId != null) {
        request.headers['Authorization'] = 'Bearer $sessionId';
      }

      // Add image file
      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile.path),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final jsonData = jsonDecode(response.body);
        return ApiResponse<Map<String, dynamic>>(
          success: jsonData['success'] ?? true,
          message: jsonData['message'] ?? 'Upload successful',
          data: jsonData['data'] as Map<String, dynamic>?,
        );
      } else {
        final jsonData = jsonDecode(response.body);
        return ApiResponse<Map<String, dynamic>>(
          success: false,
          message: jsonData['message'] ?? 'Upload failed',
        );
      }
    } catch (e) {
      return ApiResponse<Map<String, dynamic>>(
        success: false,
        message: 'Upload error: $e',
      );
    }
  }
}
