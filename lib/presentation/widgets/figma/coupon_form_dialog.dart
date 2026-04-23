import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../theme/ui_palette.dart';

class CouponFormDialog extends StatefulWidget {
  final Map<String, dynamic>? initialData;
  final bool isEdit;
  final Function(Map<String, dynamic> data) onSaved;

  const CouponFormDialog({
    super.key,
    this.initialData,
    this.isEdit = false,
    required this.onSaved,
  });

  @override
  State<CouponFormDialog> createState() => _CouponFormDialogState();
}

class _CouponFormDialogState extends State<CouponFormDialog> {
  late TextEditingController codeController;
  late TextEditingController valueController;
  late TextEditingController minAmountController;
  late TextEditingController descriptionController;
  late TextEditingController usageLimitController;
  String type = 'FIXED';
  DateTime? validFrom;
  DateTime? validTo;

  @override
  void initState() {
    super.initState();
    codeController = TextEditingController(text: widget.initialData?['code'] ?? '');
    valueController =
        TextEditingController(text: widget.initialData?['value']?.toString() ?? '');
    minAmountController = TextEditingController(
      text: widget.initialData?['min_order_amount']?.toString() ?? '0',
    );
    descriptionController =
        TextEditingController(text: widget.initialData?['description'] ?? '');
    usageLimitController = TextEditingController(
      text: widget.initialData?['usage_limit']?.toString() ?? '100',
    );
    type = widget.initialData?['type'] ?? 'FIXED';
    // Normalize: PERCENT -> PERCENTAGE để khớp với dropdown items
    if (type == 'PERCENT') type = 'PERCENTAGE';
    
    if (widget.initialData?['valid_from'] != null) {
      if (widget.initialData!['valid_from'] is DateTime) {
        validFrom = widget.initialData!['valid_from'];
      } else {
        validFrom = DateTime.tryParse(widget.initialData!['valid_from'].toString());
      }
    }
    
    if (widget.initialData?['valid_to'] != null) {
      if (widget.initialData!['valid_to'] is DateTime) {
        validTo = widget.initialData!['valid_to'];
      } else {
        validTo = DateTime.tryParse(widget.initialData!['valid_to'].toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.isEdit ? 'Sửa mã giảm giá' : 'Thêm mã giảm giá',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: UiPalette.textDark,
                ),
              ),
              const SizedBox(height: 24),
              _buildField('Mã giảm giá', codeController, hint: 'DEC2024'),
              const SizedBox(height: 16),
              _buildDropdown('Loại giảm giá'),
              const SizedBox(height: 16),
              _buildField(
                type == 'FIXED' ? 'Số tiền giảm (₫)' : 'Phần trăm (%)',
                valueController,
                hint: '0',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              _buildField(
                'Đơn hàng tối thiểu (₫)',
                minAmountController,
                hint: '0',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              _buildField(
                'Số lượt dùng tối đa',
                usageLimitController,
                hint: '100',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildDatePicker(
                      'Bắt đầu',
                      validFrom,
                      (d) => setState(() => validFrom = d),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildDatePicker(
                      'Kết thúc',
                      validTo,
                      (d) => setState(() => validTo = d),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildField(
                'Mô tả',
                descriptionController,
                hint: 'Nhập mô tả...',
                maxLines: 2,
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        'Hủy',
                        style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.w700,
                          color: UiPalette.textSecondary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: UiPalette.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Lưu',
                        style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
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

  Widget _buildField(
    String label,
    TextEditingController controller, {
    String? hint,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.dmSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: UiPalette.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: const Color(0xFFF9F9F9),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.dmSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: UiPalette.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF9F9F9),
            borderRadius: BorderRadius.circular(14),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: type,
              isExpanded: true,
              items: const [
                DropdownMenuItem(value: 'FIXED', child: Text('Giảm giá cố định')),
                DropdownMenuItem(
                  value: 'PERCENTAGE',
                  child: Text('Giảm phần trăm'),
                ),
              ],
              onChanged: (v) {
                if (v != null) setState(() => type = v);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker(
    String label,
    DateTime? date,
    Function(DateTime) onPicked,
  ) {
    final fmt = DateFormat('dd/MM/yyyy');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.dmSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: UiPalette.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final d = await showDatePicker(
              context: context,
              initialDate: date ?? DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
            );
            if (d != null) onPicked(d);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF9F9F9),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: UiPalette.primary),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    date != null ? fmt.format(date) : 'Chọn ngày',
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _save() {
    if (codeController.text.isEmpty) return;
    widget.onSaved({
      'code': codeController.text.trim().toUpperCase(),
      'type': type,
      'value': double.tryParse(valueController.text) ?? 0,
      'min_order_amount': double.tryParse(minAmountController.text) ?? 0,
      'usage_limit': int.tryParse(usageLimitController.text) ?? 100,
      'description': descriptionController.text.trim(),
      'valid_from': validFrom?.toIso8601String(),
      'valid_to': validTo?.toIso8601String(),
      'is_active': 1,
    });
    Navigator.pop(context);
  }
}
