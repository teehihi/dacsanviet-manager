import '../api_service.dart';
import '../api_config.dart';
import '../api_response.dart';
import '../models.dart';

/// Product Service for Admin
class ProductService {
  /// Get all categories
  static Future<ApiResponse<List<Category>>> getCategories() async {
    return await ApiService.get<List<Category>>(
      '${ApiConfig.products}/categories',
      fromJson: (data) {
        if (data is List) {
          return data.map((json) => Category.fromJson(json)).toList();
        }
        return [];
      },
    );
  }

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
    String? categoryId,
    String? imageUrl,
    List<String>? imageFiles,
    double? discount,
    bool isActive = true,
  }) async {
    if (imageFiles != null && imageFiles.isNotEmpty) {
      return await ApiService.multipartRequest<Map<String, dynamic>>(
        ApiConfig.adminProducts,
        method: 'POST',
        fields: {
          'name': name,
          'description': description,
          'price': price.toInt().toString(),
          'stock_quantity': stock.toString(),
          if (categoryId != null) 'category_id': categoryId,
          'is_active': isActive ? '1' : '0',
        },
        files: {'images': imageFiles},
        fromJson: (data) => data as Map<String, dynamic>,
      );
    }
    return await ApiService.post<Map<String, dynamic>>(
      ApiConfig.adminProducts,
      body: {
        'name': name,
        'description': description,
        'price': price,
        'stock_quantity': stock,
        if (categoryId != null) 'category_id': categoryId,
        if (imageUrl != null) 'image_url': imageUrl,
        'is_active': isActive ? 1 : 0,
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
    String? categoryId,
    String? imageUrl,
    List<String>? imageFiles,
    bool? isActive,
  }) async {
    if (imageFiles != null && imageFiles.isNotEmpty) {
      return await ApiService.multipartRequest<Map<String, dynamic>>(
        '${ApiConfig.adminProducts}/$id',
        method: 'PUT',
        fields: {
          if (name != null) 'name': name,
          if (description != null) 'description': description,
          if (price != null) 'price': price.toInt().toString(),
          if (stock != null) 'stock_quantity': stock.toString(),
          if (categoryId != null) 'category_id': categoryId,
          if (isActive != null) 'is_active': isActive ? '1' : '0',
        },
        files: {'images': imageFiles},
        fromJson: (data) => data as Map<String, dynamic>,
      );
    }
    return await ApiService.put<Map<String, dynamic>>(
      '${ApiConfig.adminProducts}/$id',
      body: {
        if (name != null) 'name': name,
        if (description != null) 'description': description,
        if (price != null) 'price': price,
        if (stock != null) 'stock_quantity': stock,
        if (categoryId != null) 'category_id': categoryId,
        if (imageUrl != null) 'image_url': imageUrl,
        if (isActive != null) 'is_active': isActive ? 1 : 0,
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
