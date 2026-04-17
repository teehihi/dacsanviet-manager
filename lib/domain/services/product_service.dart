import '../api_service.dart';
import '../api_config.dart';
import '../api_response.dart';

/// Product Service for Admin
class ProductService {
  /// Get all products with pagination
  static Future<ApiResponse<Map<String, dynamic>>> getProducts({
    int page = 1,
    int limit = 20,
    String? search,
    String? category,
  }) async {
    return await ApiService.get<Map<String, dynamic>>(
      ApiConfig.adminProducts,
      queryParams: {
        'page': page.toString(),
        'limit': limit.toString(),
        if (search != null) 'search': search,
        if (category != null) 'category': category,
      },
      fromJson: (data) => data as Map<String, dynamic>,
    );
  }
  
  /// Get product by ID
  static Future<ApiResponse<Map<String, dynamic>>> getProductById(int id) async {
    return await ApiService.get<Map<String, dynamic>>(
      '${ApiConfig.adminProducts}/$id',
      fromJson: (data) => data as Map<String, dynamic>,
    );
  }
  
  /// Create new product
  static Future<ApiResponse<Map<String, dynamic>>> createProduct({
    required String name,
    required String description,
    required double price,
    required int stock,
    String? category,
    String? imageUrl,
    double? discount,
  }) async {
    return await ApiService.post<Map<String, dynamic>>(
      ApiConfig.adminProducts,
      body: {
        'name': name,
        'description': description,
        'price': price,
        'stock': stock,
        if (category != null) 'category': category,
        if (imageUrl != null) 'image_url': imageUrl,
        if (discount != null) 'discount': discount,
      },
      fromJson: (data) => data as Map<String, dynamic>,
    );
  }
  
  /// Update product
  static Future<ApiResponse<Map<String, dynamic>>> updateProduct({
    required int id,
    String? name,
    String? description,
    double? price,
    int? stock,
    String? category,
    String? imageUrl,
    double? discount,
  }) async {
    return await ApiService.put<Map<String, dynamic>>(
      '${ApiConfig.adminProducts}/$id',
      body: {
        if (name != null) 'name': name,
        if (description != null) 'description': description,
        if (price != null) 'price': price,
        if (stock != null) 'stock': stock,
        if (category != null) 'category': category,
        if (imageUrl != null) 'image_url': imageUrl,
        if (discount != null) 'discount': discount,
      },
      fromJson: (data) => data as Map<String, dynamic>,
    );
  }
  
  /// Delete product
  static Future<ApiResponse<Map<String, dynamic>>> deleteProduct(int id) async {
    return await ApiService.delete<Map<String, dynamic>>(
      '${ApiConfig.adminProducts}/$id',
      fromJson: (data) => data as Map<String, dynamic>,
    );
  }
  
  /// Get product statistics
  static Future<ApiResponse<Map<String, dynamic>>> getProductStats() async {
    return await ApiService.get<Map<String, dynamic>>(
      '${ApiConfig.adminProducts}/stats',
      fromJson: (data) => data as Map<String, dynamic>,
    );
  }
}
