import 'dart:io';
import 'package:flutter/foundation.dart' show debugPrint;
import '../models.dart';
import '../api_config.dart';
import '../api_service.dart';
import '../api_response.dart';
import '../utils/parse_utils.dart';

class CategoryService {
  static Future<ApiResponse<List<Category>>> getAllCategories() async {
    return ApiService.get<List<Category>>(
      ApiConfig.categories,
      fromJson: (json) {
        final List<dynamic> categoriesJson = json as List<dynamic>;
        return categoriesJson.map((c) => Category.fromJson(c)).toList();
      },
    );
  }

  static Future<ApiResponse<Category>> getCategoryById(String id) async {
    return ApiService.get<Category>(
      '${ApiConfig.categories}/$id',
      fromJson: (json) => Category.fromJson(json),
    );
  }

  static Future<ApiResponse<List<Product>>> getCategoryProducts(String id) async {
    return ApiService.get<List<Product>>(
      '${ApiConfig.categories}/$id/products',
      fromJson: (json) {
        final List<dynamic> productsJson = (json as List<dynamic>?) ?? [];
        debugPrint('✅ CategoryService: Loaded ${productsJson.length} products for category $id');
        
        return productsJson.map((p) {
          try {
            return Product.fromJson(p as Map<String, dynamic>);
          } catch (e) {
            debugPrint('⚠️ CategoryService: Error parsing product: $e | Data: $p');
            return null;
          }
        }).whereType<Product>().toList();
      },
    );
  }

  static Future<ApiResponse<dynamic>> createCategory({
    required String name,
    String? description,
    String? imageUrl,
    File? imageFile,
  }) async {
    final Map<String, String> fields = {
      'name': name,
      if (description != null) 'description': description,
      if (imageUrl != null) 'image_url': imageUrl,
    };

    if (imageFile != null) {
      return ApiService.postMultipart<dynamic>(
        ApiConfig.adminCategories,
        fields: fields,
        files: {'image': imageFile.path},
      );
    } else {
      return ApiService.post<dynamic>(
        ApiConfig.adminCategories,
        body: fields,
      );
    }
  }

  static Future<ApiResponse<dynamic>> updateCategory(
    String id, {
    String? name,
    String? description,
    String? imageUrl,
    File? imageFile,
  }) async {
    final Map<String, String> fields = {
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (imageUrl != null) 'image_url': imageUrl,
    };

    if (imageFile != null) {
      return ApiService.putMultipart<dynamic>(
        '${ApiConfig.adminCategories}/$id',
        fields: fields,
        files: {'image': imageFile.path},
      );
    } else {
      return ApiService.put<dynamic>(
        '${ApiConfig.adminCategories}/$id',
        body: fields,
      );
    }
  }

  static Future<ApiResponse<dynamic>> deleteCategory(String id) async {
    return ApiService.delete<dynamic>('${ApiConfig.adminCategories}/$id');
  }

  static Future<ApiResponse<dynamic>> addProductToCategory(String categoryId, String productId) async {
    return ApiService.post<dynamic>(
      '${ApiConfig.categories}/$categoryId/add-product',
      body: {'productId': productId},
    );
  }
}
