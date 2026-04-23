import 'package:flutter/material.dart' hide Category;
import 'package:google_fonts/google_fonts.dart';
import '../../domain/models.dart';
import '../theme/ui_palette.dart';
import '../../state/app_controller.dart';
import '../widgets/figma/product_card.dart';
import '../widgets/design_widgets.dart' hide ProductData;
import '../widgets/figma/product_form_dialog.dart';

class FigmaProductsScreen extends StatelessWidget {
  const FigmaProductsScreen({super.key, required this.controller});
  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      body: Stack(
        children: [
          // Content
          SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                await controller.loadProducts();
                await controller.loadCategories();
              },
              color: UiPalette.primary,
              displacement: 80,
              child: ListenableBuilder(
                listenable: controller,
                builder: (context, _) {
                  return ListView(
                    padding: const EdgeInsets.only(bottom: 150),
                    children: [
                      // Space for fixed header (TopHeader + Search + Category)
                      const SizedBox(height: 200),

                      const SizedBox(height: 24),

                      // Product Grid
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: controller.filteredProducts.isEmpty
                            ? _buildEmptyState()
                            : GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 0.72,
                                      crossAxisSpacing: 16,
                                      mainAxisSpacing: 16,
                                    ),
                                itemCount: controller.filteredProducts.length,
                                itemBuilder: (ctx, i) {
                                  final p = controller.filteredProducts[i];
                                  return ProductCard(
                                    data: ProductData(
                                      p.name,
                                      p.category,
                                      _currencyStr(p.price),
                                      p.stock,
                                      p.imageUrl,
                                    ),
                                    onEdit: () {
                                      showDialog(
                                        context: context,
                                        builder: (ctx) => ProductFormDialog(
                                          isEdit: true,
                                          categories: controller.categories
                                              .cast<Category>(),
                                          initialData: {
                                            'name': p.name,
                                            'price': p.price,
                                            'stock': p.stock,
                                            'category': p.category,
                                            'imageUrl': p.imageUrl,
                                            'description': p.description,
                                          },
                                          onSaved:
                                              (
                                                name,
                                                categoryId,
                                                price,
                                                stock,
                                                imageUrl,
                                                imageFiles,
                                                description,
                                              ) {
                                                controller.updateProduct(
                                                  p.id,
                                                  name: name,
                                                  categoryId: categoryId,
                                                  price: price,
                                                  stock: stock,
                                                  imageUrl: imageUrl,
                                                  imageFiles: imageFiles,
                                                  description: description,
                                                );
                                              },
                                        ),
                                      );
                                    },
                                    onDelete: () =>
                                        controller.deleteProduct(p.id),
                                  ).animateIn(delayMs: i * 40);
                                },
                              ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),

          // Pinned Header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 8,
                left: 20,
                right: 20,
                bottom: 12,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFB).withValues(alpha: 0.9),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const TopHeader(
                    title: 'Sản phẩm',
                    subtitle: 'Quản lý kho hàng',
                    showBackButton: false,
                  ),
                  const SizedBox(height: 12),
                  _buildSearchField(),
                  const SizedBox(height: 12),
                  // Category Filter Chips (Simplified here for layout)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: controller.availableCategories.map((c) {
                        final active = controller.productCategory == c;
                        return GestureDetector(
                          onTap: () => controller.setProductCategory(c),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: active ? UiPalette.primary : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: active
                                    ? UiPalette.primary
                                    : const Color(0xFFF1F1F1),
                              ),
                            ),
                            child: Text(
                              c,
                              style: GoogleFonts.dmSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: active ? Colors.white : UiPalette.textSecondary,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // FAB
          Positioned(
            right: 24,
            bottom: 110,
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (ctx) => ProductFormDialog(
                    categories: controller.categories.cast<Category>(),
                    onSaved:
                        (name, categoryId, price, stock, imageUrl, imageFiles, description) {
                          controller.addProduct(
                            name: name,
                            categoryId: categoryId,
                            price: price,
                            stock: stock,
                            imageUrl: imageUrl,
                            imageFiles: imageFiles,
                            description: description,
                          );
                        },
                  ),
                );
              },
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: UiPalette.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: UiPalette.primary.withValues(alpha: 0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.add_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ).animateIn(delayMs: 400),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        onChanged: controller.setProductSearch,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: Color(0xFFA0A0A0),
            size: 20,
          ),
          hintText: 'Tìm kiếm sản phẩm...',
          hintStyle: GoogleFonts.dmSans(
            color: const Color(0xFFA0A0A0),
            fontSize: 14,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.only(top: 100),
      child: Column(
        children: [
          const Icon(
            Icons.inventory_2_outlined,
            size: 80,
            color: Color(0xFFE0E0E0),
          ),
          const SizedBox(height: 20),
          Text(
            'Không có sản phẩm nào',
            style: GoogleFonts.dmSans(
              color: Colors.grey[500],
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Thử thay đổi bộ lọc hoặc từ khóa tìm kiếm',
            style: GoogleFonts.dmSans(color: Colors.grey[400], fontSize: 13),
          ),
        ],
      ).animateIn(),
    );
  }

  String _currencyStr(int value) {
    final raw = value.toString();
    final b = StringBuffer();
    for (var i = 0; i < raw.length; i++) {
      final reverseIndex = raw.length - i;
      b.write(raw[i]);
      if (reverseIndex > 1 && reverseIndex % 3 == 1) b.write('.');
    }
    return '₫$b';
  }
}
