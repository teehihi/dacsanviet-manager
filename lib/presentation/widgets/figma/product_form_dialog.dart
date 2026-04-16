import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/ui_palette.dart';

class ProductFormDialog extends StatefulWidget {
  final Map<String, dynamic>? initialData;
  final bool isEdit;
  final Function(String name, String category, int price, int stock, String? imageUrl) onSaved;

  const ProductFormDialog({
    super.key,
    this.initialData,
    this.isEdit = false,
    required this.onSaved,
  });

  @override
  State<ProductFormDialog> createState() => _ProductFormDialogState();
}

class _ProductFormDialogState extends State<ProductFormDialog> {
  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController stockController;
  late TextEditingController categoryController;
  late TextEditingController imageUrlController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.initialData?['name'] ?? '');
    priceController = TextEditingController(text: widget.initialData?['price']?.toString() ?? '');
    stockController = TextEditingController(text: widget.initialData?['stock']?.toString() ?? '');
    categoryController = TextEditingController(text: widget.initialData?['category'] ?? '');
    imageUrlController = TextEditingController(text: widget.initialData?['imageUrl'] ?? '');
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    stockController.dispose();
    categoryController.dispose();
    imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.isEdit ? 'Sửa sản phẩm' : 'Thêm sản phẩm mới',
                  style: GoogleFonts.dmSans(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: UiPalette.textDark,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, size: 20, color: Colors.grey),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildLabel('Tên sản phẩm'),
            _buildTextField(
              controller: nameController,
              hint: 'VD: Cà phê Buôn Ma Thuột...',
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Giá (VNĐ)'),
                      _buildTextField(
                        controller: priceController,
                        hint: '0',
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Tôn kho'),
                      _buildTextField(
                        controller: stockController,
                        hint: '0',
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildLabel('Danh mục'),
            _buildTextField(
              controller: categoryController,
              hint: 'Chọn danh mục...',
            ),
            const SizedBox(height: 16),
            _buildLabel('Hình ảnh sản phẩm'),
            const SizedBox(height: 8),
            _buildImagePicker(),
            const SizedBox(height: 16),
            _buildDividerWithText('HOẶC NHẬP LINK'),
            const SizedBox(height: 16),
            _buildTextField(
              controller: imageUrlController,
              hint: 'https://...',
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: _buildButton(
                    onPressed: () => Navigator.pop(context),
                    label: 'Huỷ',
                    isSecondary: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildButton(
                    onPressed: () {
                      final name = nameController.text.trim();
                      final category = categoryController.text.trim().isEmpty ? 'Gia vị' : categoryController.text.trim();
                      final price = int.tryParse(priceController.text) ?? 0;
                      final stock = int.tryParse(stockController.text) ?? 0;
                      final imageUrl = imageUrlController.text.trim().isEmpty ? null : imageUrlController.text.trim();

                      if (name.isNotEmpty) {
                        widget.onSaved(name, category, price, stock, imageUrl);
                        Navigator.pop(context);
                      }
                    },
                    label: widget.isEdit ? 'Lưu thay đổi' : 'Thêm mới',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: GoogleFonts.dmSans(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF6B6B6B),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: GoogleFonts.dmSans(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: UiPalette.textDark,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.dmSans(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: const Color(0xFFAAAAAA),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    if (widget.isEdit && imageUrlController.text.isNotEmpty) {
      return Container(
        height: 140,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: NetworkImage(imageUrlController.text),
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    return Container(
      height: 140,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFFBFDFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 1,
          style: BorderStyle.none, // We will use custom dashed border if needed
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xFFE0E0E0).withValues(alpha: 0.5),
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: UiPalette.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.cloud_upload_outlined,
                  color: UiPalette.primary,
                  size: 28,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Tải ảnh lên từ thiết bị',
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: UiPalette.textDark,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Hỗ trợ JPG, PNG, WEBP',
                style: GoogleFonts.dmSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF999999),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDividerWithText(String text) {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey.withValues(alpha: 0.2))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            text,
            style: GoogleFonts.dmSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF888888),
              letterSpacing: 0.5,
            ),
          ),
        ),
        Expanded(child: Divider(color: Colors.grey.withValues(alpha: 0.2))),
      ],
    );
  }

  Widget _buildButton({
    required VoidCallback onPressed,
    required String label,
    bool isSecondary = false,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isSecondary ? const Color(0xFFF1F1F1) : UiPalette.primary,
        foregroundColor: isSecondary ? UiPalette.textDark : Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Text(
        label,
        style: GoogleFonts.dmSans(
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
