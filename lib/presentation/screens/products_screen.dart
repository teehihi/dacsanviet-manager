import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.only(bottom: 120),
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(24, 60, 24, 12),
              color: Colors.white,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Quản Lý Sản phẩm',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: UiPalette.textDark,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.tune, color: UiPalette.textDark, size: 24),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F7),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: TextField(
                      onChanged: controller.setProductSearch,
                      style: GoogleFonts.dmSans(color: UiPalette.textDark),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: const Icon(Icons.search, color: Color(0xFFA0A0A0), size: 22),
                        hintText: 'Tìm kiếm sản phẩm...',
                        hintStyle: GoogleFonts.dmSans(color: const Color(0xFFA0A0A0)),
                        contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: controller.availableCategories.map((c) {
                  final active = controller.productCategory == c;
                  return GestureDetector(
                    onTap: () => controller.setProductCategory(c),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        color: active ? UiPalette.primary : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: active
                            ? [BoxShadow(color: UiPalette.primary.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4))]
                            : [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 2))],
                        border: Border.all(color: active ? UiPalette.primary : const Color(0xFFF1F1F1)),
                      ),
                      child: Text(
                        c,
                        style: GoogleFonts.dmSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: active ? Colors.white : UiPalette.textSecondary,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: controller.filteredProducts.length,
                itemBuilder: (ctx, i) {
                  final p = controller.filteredProducts[i];
                  return ProductCard(
                    data: ProductData(p.name, p.category, _currencyStr(p.price), p.stock, p.imageUrl),
                    onEdit: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => ProductFormDialog(
                          isEdit: true,
                          initialData: {
                            'name': p.name,
                            'price': p.price,
                            'stock': p.stock,
                            'category': p.category,
                            'imageUrl': p.imageUrl,
                          },
                          onSaved: (name, category, price, stock, imageUrl) {
                            controller.updateProduct(p.id, name: name, category: category, price: price, stock: stock, imageUrl: imageUrl);
                          },
                        ),
                      );
                    },
                    onDelete: () => controller.deleteProduct(p.id),
                  ).animateIn(delayMs: i * 50);
                },
              ),
            ),
          ],
        ),
        Positioned(
          right: 24,
          bottom: 120,
          child: GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (ctx) => ProductFormDialog(
                  onSaved: (name, category, price, stock, imageUrl) {
                    controller.addProduct(name: name, category: category, price: price, stock: stock, imageUrl: imageUrl);
                  },
                ),
              );
            },
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: UiPalette.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: UiPalette.primary.withValues(alpha: 0.4),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  )
                ],
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 32),
            ),
          ),
        ),
      ],
    );
  }

  String _currencyStr(int value) {
    final raw = value.toString();
    final b = StringBuffer();
    for (var i = 0; i < raw.length; i++) {
        final reverseIndex = raw.length - i;
        b.write(raw[i]);
        if (reverseIndex > 1 && reverseIndex % 3 == 1) b.write(',');
    }
    return '₫$b';
  }
}
