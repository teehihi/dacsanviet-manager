import 'package:flutter/material.dart';
import '../../theme/ui_palette.dart';
import '../../../domain/api_config.dart';

class ProductData {
  const ProductData(this.name, this.category, this.price, this.stock, [this.imageUrl]);
  final String name;
  final String category;
  final String price;
  final int stock;
  final String? imageUrl;
}

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.data, this.onEdit, this.onDelete});
  final ProductData data;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  String _formatImageUrl(String url) {
    if (url.startsWith('http')) return url;
    return '${ApiConfig.baseUrl}${url.startsWith("/") ? "" : "/"}$url';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                    color: Color(0xFFF9F9F9),
                  ),
                  child: data.imageUrl != null && data.imageUrl!.isNotEmpty
                      ? ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                          child: Image.network(
                            '${_formatImageUrl(data.imageUrl!)}?t=${DateTime.now().millisecondsSinceEpoch ~/ 60000}',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.image_outlined, size: 48, color: Color(0xFFE0E0E0))),
                          ),
                        )
                      : const Center(
                          child: Icon(Icons.image_outlined, size: 54, color: Color(0xFFE0E0E0)),
                        ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.inventory_2_outlined, size: 12, color: Colors.white),
                        const SizedBox(width: 4),
                        Text(
                          '${data.stock}',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.category.toUpperCase(),
                  style: const TextStyle(color: Color(0xFFA0A0A0), fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.5),
                ),
                const SizedBox(height: 4),
                Text(
                  data.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Color(0xFF1A1A1A)),
                ),
                const SizedBox(height: 4),
                Text(
                  data.price,
                  style: const TextStyle(fontWeight: FontWeight.w800, color: UiPalette.primary, fontSize: 16),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: onEdit,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE6F7ED),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.edit_outlined, size: 14, color: UiPalette.primary),
                              SizedBox(width: 4),
                              Text('Sửa', style: TextStyle(color: UiPalette.primary, fontWeight: FontWeight.w700, fontSize: 13)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: onDelete,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFEBEB),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.delete_outline, size: 20, color: Color(0xFFFF4D4D)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
