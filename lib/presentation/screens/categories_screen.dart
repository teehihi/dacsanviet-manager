import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../state/app_controller.dart';
import '../../domain/models.dart';
import '../../domain/domain.dart';
import '../../domain/api_config.dart';
import '../theme/ui_palette.dart';
import '../widgets/figma/category_form_dialog.dart';
import '../widgets/figma/add_product_to_category_dialog.dart';
import '../../domain/utils/parse_utils.dart';

class CategoriesScreen extends StatefulWidget {
  final AppController controller;
  const CategoriesScreen({super.key, required this.controller});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_errorListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.controller.loadCategories();
      widget.controller.loadProducts();
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(_errorListener);
    super.dispose();
  }

  void _errorListener() {
    if (widget.controller.error != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.controller.error!),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showCategoryForm(BuildContext context, {Category? category}) {
    showDialog(
      context: context,
      builder: (context) => CategoryFormDialog(
        category: category,
        onSave: (name, description, imageUrl, imageFile) {
          if (category == null) {
            widget.controller.addCategory(
              name: name,
              description: description,
              imageUrl: imageUrl,
              imageFile: imageFile,
            );
          } else {
            widget.controller.updateCategory(
              category.id,
              name: name,
              description: description,
              imageUrl: imageUrl,
              imageFile: imageFile,
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final categories = widget.controller.categories;
        final isLoading = widget.controller.isLoading;

        return Scaffold(
          backgroundColor: const Color(0xFFF9FBF9),
          appBar: AppBar(
            title: Text(
              'Quản lý Danh mục',
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            actions: [
              IconButton(
                onPressed: () => _showCategoryForm(context),
                icon: const Icon(Icons.add_circle_outline, color: Color(0xFF2E7D32)),
              ),
            ],
          ),
          body: isLoading
              ? const Center(child: CircularProgressIndicator())
              : categories.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        return _buildCategoryCard(context, category);
                      },
                    ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.category_outlined, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'Chưa có danh mục nào',
            style: GoogleFonts.inter(color: Colors.grey, fontSize: 16),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showCategoryForm(context),
            icon: const Icon(Icons.add),
            label: const Text('Thêm danh mục đầu tiên'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE8F5E9),
              foregroundColor: const Color(0xFF2E7D32),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, Category category) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      color: Colors.white,
      child: InkWell(
        onTap: () => _showCategoryProducts(context, category),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Category Image
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F4F0),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: category.imageUrl != null && category.imageUrl!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          category.imageUrl!.startsWith('http')
                              ? category.imageUrl!
                              : '${ApiConfig.baseUrl}${category.imageUrl!}',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.category, color: Color(0xFF2E7D32)),
                        ),
                      )
                    : const Icon(Icons.category, color: Color(0xFF2E7D32)),
              ),
              const SizedBox(width: 16),
              // Category Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.name,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1D1B20),
                      ),
                    ),
                    if (category.description != null && category.description!.isNotEmpty)
                      Text(
                        category.description!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: const Color(0xFF49454F),
                        ),
                      ),
                  ],
                ),
              ),
              // Actions
              IconButton(
                onPressed: () => _showCategoryForm(context, category: category),
                icon: const Icon(Icons.edit_outlined, color: Colors.blue, size: 20),
              ),
              IconButton(
                onPressed: () => _confirmDelete(context, category),
                icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, Category category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc muốn xóa danh mục "${category.name}"? Các sản phẩm trong danh mục này sẽ không còn danh mục.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              widget.controller.deleteCategory(category.id);
              Navigator.pop(context);
            },
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showCategoryProducts(BuildContext context, Category category) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _CategoryProductsSheet(category: category, controller: widget.controller),
    );
  }
}

class _CategoryProductsSheet extends StatefulWidget {
  final Category category;
  final AppController controller;
  const _CategoryProductsSheet({required this.category, required this.controller});

  @override
  State<_CategoryProductsSheet> createState() => _CategoryProductsSheetState();
}

class _CategoryProductsSheetState extends State<_CategoryProductsSheet> {
  List<Product> _categoryProducts = [];
  bool _isLoadingProducts = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoadingProducts = true;
    });
    debugPrint('📥 Loading products for category: ${widget.category.name} (ID: ${widget.category.id})');
    final response = await CategoryService.getCategoryProducts(widget.category.id);
    debugPrint('📊 API Response success: ${response.success}, items: ${response.data?.length ?? 0}');
    if (response.success) {
      setState(() {
        _categoryProducts = response.data ?? [];
        _isLoadingProducts = false;
      });
    } else {
      setState(() {
        _isLoadingProducts = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.category.name,
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${_categoryProducts.length} sản phẩm',
                        style: GoogleFonts.inter(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => _showAddProductDialog(context),
                  icon: const Icon(Icons.add_box, color: Color(0xFF2E7D32), size: 28),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: _isLoadingProducts
                ? const Center(child: CircularProgressIndicator())
                : _categoryProducts.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.shopping_bag_outlined, size: 48, color: Colors.grey[300]),
                            const SizedBox(height: 16),
                            Text(
                              'Chưa có sản phẩm nào trong danh mục này',
                              style: GoogleFonts.inter(color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _categoryProducts.length,
                        itemBuilder: (context, index) {
                          final product = _categoryProducts[index];
                          return ListTile(
                            leading: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F4F0),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: product.imageUrl != null && product.imageUrl!.isNotEmpty
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        product.imageUrl!.startsWith('http')
                                            ? product.imageUrl!
                                            : '${ApiConfig.baseUrl}${product.imageUrl!}',
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) =>
                                            const Icon(Icons.shopping_bag_outlined),
                                      ),
                                    )
                                  : const Icon(Icons.shopping_bag_outlined),
                            ),
                            title: Text(product.name, style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                            subtitle: Text('${ParseUtils.formatPrice(product.price)}đ', style: GoogleFonts.inter(color: const Color(0xFF2E7D32), fontWeight: FontWeight.w500)),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  void _showAddProductDialog(BuildContext context) {
    final allProducts = widget.controller.products;
    final categoryProductsIds = _categoryProducts.map((p) => p.id).toSet();
    
    // Lọc ra các sản phẩm chưa có trong category này
    final availableProducts = allProducts.where((p) => !categoryProductsIds.contains(p.id)).toList();

    showDialog(
      context: context,
      builder: (context) => AddProductToCategoryDialog(
        availableProducts: availableProducts,
        onAdd: (product) async {
          final success = await widget.controller.addProductToCategory(widget.category.id, product.id);
          if (success) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Đã thêm ${product.name} vào danh mục')),
              );
            }
            _loadProducts();
          } else {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Lỗi khi thêm sản phẩm vào danh mục')),
              );
            }
          }
        },
      ),
    );
  }
}
