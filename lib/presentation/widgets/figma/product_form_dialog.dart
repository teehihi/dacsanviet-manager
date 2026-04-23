import 'dart:io';
import 'package:flutter/material.dart' hide Category;
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../theme/ui_palette.dart';
import '../../../domain/api_config.dart';
import '../../../domain/models.dart';

class ProductFormDialog extends StatefulWidget {
  final Map<String, dynamic>? initialData;
  final bool isEdit;
  final List<Category> categories;
  final Function(
    String name,
    String categoryId,
    int price,
    int stock,
    String? imageUrl,
    List<String>? imageFiles,
    String? description,
  )
  onSaved;

  const ProductFormDialog({
    super.key,
    this.initialData,
    this.isEdit = false,
    required this.categories,
    required this.onSaved,
  });

  @override
  State<ProductFormDialog> createState() => _ProductFormDialogState();
}

class _ProductFormDialogState extends State<ProductFormDialog> {
  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController stockController;
  late TextEditingController descriptionController;
  String? selectedCategoryId;
  late TextEditingController imageUrlController;

  List<File> _selectedImages = [];
  bool _isUploading = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(
      text: widget.initialData?['name'] ?? '',
    );
    priceController = TextEditingController(
      text: widget.initialData?['price']?.toString() ?? '',
    );
    stockController = TextEditingController(
      text: widget.initialData?['stock']?.toString() ?? '',
    );
    imageUrlController = TextEditingController(
      text: widget.initialData?['imageUrl'] ?? '',
    );
    descriptionController = TextEditingController(
      text: widget.initialData?['description'] ?? '',
    );

    // Try to find category ID from initial name or ID
    if (widget.isEdit && widget.initialData?['category'] != null) {
      final initialCatName = widget.initialData?['category'];
      try {
        selectedCategoryId = widget.categories
            .firstWhere((c) => c.name == initialCatName)
            .id;
      } catch (_) {
        if (widget.categories.isNotEmpty) {
          selectedCategoryId = widget.categories.first.id;
        }
      }
    } else if (widget.categories.isNotEmpty) {
      selectedCategoryId = widget.categories.first.id;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    stockController.dispose();
    stockController.dispose();
    descriptionController.dispose();
    imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: SingleChildScrollView(
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
                      child: const Icon(
                        Icons.close,
                        size: 20,
                        color: Colors.grey,
                      ),
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
                        _buildLabel('Tồn kho'),
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
              _buildCategoryDropdown(),
              const SizedBox(height: 16),
              _buildLabel('Mô tả sản phẩm'),
              _buildTextField(
                controller: descriptionController,
                hint: 'Nhập mô tả sản phẩm...',
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              _buildLabel('Hình ảnh sản phẩm'),
              const SizedBox(height: 8),
              _buildImagePicker(),
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
                      onPressed: _save,
                      label: widget.isEdit ? 'Lưu thay đổi' : 'Thêm mới',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedCategoryId,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFFAAAAAA)),
          items: widget.categories.map((Category cat) {
            return DropdownMenuItem<String>(
              value: cat.id,
              child: Text(
                cat.name,
                style: GoogleFonts.dmSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: UiPalette.textDark,
                ),
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedCategoryId = value;
            });
          },
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
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
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
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (images.isNotEmpty) {
        setState(() {
          // Append new images to existing list instead of replacing
          _selectedImages.addAll(images.map((xfile) => File(xfile.path)));
          // Limit to 5 images max
          if (_selectedImages.length > 5) {
            _selectedImages = _selectedImages.sublist(0, 5);
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
      }
    }
  }

  Widget _buildImagePicker() {
    if (_selectedImages.isNotEmpty) {
      return Column(
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: _selectedImages.length + 1,
            itemBuilder: (context, index) {
              if (index == _selectedImages.length) {
                // Add more button
                return GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9F9F9),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFE0E0E0),
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: const Icon(
                      Icons.add_photo_alternate_outlined,
                      color: UiPalette.primary,
                      size: 32,
                    ),
                  ),
                );
              }

              return Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE0E0E0)),
                      image: DecorationImage(
                        image: FileImage(_selectedImages[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedImages.removeAt(index);
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  if (index == 0)
                    Positioned(
                      bottom: 4,
                      left: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: UiPalette.primary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Chính',
                          style: GoogleFonts.dmSans(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      );
    }

    // Show existing images if editing
    if (widget.isEdit && imageUrlController.text.isNotEmpty) {
      return GestureDetector(
        onTap: _pickImage,
        child: Container(
          height: 140,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE0E0E0)),
            image: DecorationImage(
              image: NetworkImage(
                _formatImageUrl(imageUrlController.text),
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.black.withValues(alpha: 0.2),
            ),
            child: const Icon(Icons.camera_alt, color: Colors.white, size: 32),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 140,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFF9F9F9),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFE0E0E0),
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.cloud_upload_outlined,
              color: UiPalette.primary,
              size: 32,
            ),
            const SizedBox(height: 12),
            Text(
              'Tải ảnh lên (tối đa 5)',
              style: GoogleFonts.dmSans(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: UiPalette.textDark,
              ),
            ),
          ],
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
        backgroundColor: isSecondary
            ? const Color(0xFFF1F1F1)
            : UiPalette.primary,
        foregroundColor: isSecondary ? UiPalette.textDark : Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Text(
        label,
        style: GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    );
  }

  void _save() {
    final name = nameController.text.trim();
    final price = int.tryParse(priceController.text) ?? 0;
    final stock = int.tryParse(stockController.text) ?? 0;
    final imageUrl = imageUrlController.text.trim().isEmpty
        ? null
        : imageUrlController.text.trim();
    final description = descriptionController.text.trim().isEmpty
        ? null
        : descriptionController.text.trim();

    if (name.isNotEmpty && selectedCategoryId != null) {
      widget.onSaved(
        name,
        selectedCategoryId!,
        price,
        stock,
        imageUrl,
        _selectedImages.isNotEmpty ? _selectedImages.map((f) => f.path).toList() : null,
        description,
      );
      Navigator.pop(context);
    }
  }

  String _formatImageUrl(String url) {
    if (url.startsWith('http')) return url;
    return '${ApiConfig.baseUrl}${url.startsWith("/") ? "" : "/"}$url';
  }
}
