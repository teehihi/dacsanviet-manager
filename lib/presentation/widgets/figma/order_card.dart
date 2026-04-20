import 'package:flutter/material.dart';
import '../../theme/ui_palette.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({
    super.key, 
    required this.orderCode, 
    required this.state,
    required this.customerName,
    required this.phone,
    required this.address,
    required this.productSummary,
    required this.totalAmount,
    this.imageUrl,
    this.onConfirm,
    this.onReject,
  });

  final String orderCode;
  final String state;
  final String customerName;
  final String phone;
  final String address;
  final String productSummary;
  final int totalAmount;
  final String? imageUrl;
  final VoidCallback? onConfirm;
  final VoidCallback? onReject;

  @override
  Widget build(BuildContext context) {
    final isPending = state == 'Chờ xác nhận' || state == 'pending';
    final isShipping = state == 'Đang giao' || state == 'shipping';
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(color: UiPalette.shadow, blurRadius: 30, offset: Offset(0, 10)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: UiPalette.border.withValues(alpha: 0.3),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      orderCode, 
                      style: const TextStyle(
                        fontSize: 15, 
                        fontWeight: FontWeight.w800, 
                        color: UiPalette.textPrimary,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  StatusPill(text: state),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   _OrderInfoRow(icon: Icons.person_rounded, title: customerName, subtitle: '$phone • $address'),
                   const SizedBox(height: 12),
                   _OrderInfoRow(
                      icon: Icons.inventory_2_rounded, 
                      title: 'Sản phẩm', 
                      subtitle: productSummary,
                      imageUrl: imageUrl,
                   ),
                   const Divider(height: 32, color: UiPalette.border),
                   Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Tổng thanh toán', style: TextStyle(color: UiPalette.textSecondary, fontSize: 12)),
                          Text(
                            '₫${totalAmount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: UiPalette.primary),
                          ),
                        ],
                      ),
                      if (isPending) ...[
                        Row(
                          children: [
                            _SmallButton(onPressed: onReject, label: 'Từ chối', isPrimary: false),
                            const SizedBox(width: 8),
                            _SmallButton(onPressed: onConfirm, label: 'Xác nhận', isPrimary: true),
                          ],
                        ),
                      ] else if (isShipping) ...[
                        Row(
                          children: [
                            _SmallButton(onPressed: onReject, label: 'Hủy đơn', isPrimary: false),
                            const SizedBox(width: 8),
                            _SmallButton(onPressed: onConfirm, label: 'Đã giao', isPrimary: true),
                          ],
                        ),
                      ] else
                        TextButton(
                          onPressed: () {}, 
                          child: const Text('Chi tiết', style: TextStyle(fontWeight: FontWeight.w700, color: UiPalette.primary)),
                        ),

                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StatusPill extends StatelessWidget {
  const StatusPill({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    Color bg = UiPalette.warningBg;
    Color fg = UiPalette.warning;
    
    final t = text.toLowerCase();
    if (t.contains('đang giao') || t.contains('shipping')) {
      bg = UiPalette.infoBg;
      fg = UiPalette.info;
    } else if (t.contains('hoàn thành') || t.contains('đã giao') || t.contains('complete')) {
      bg = UiPalette.successBg;
      fg = UiPalette.success;
    } else if (t.contains('từ chối') || t.contains('hủy') || t.contains('rejected')) {
      bg = UiPalette.errorBg;
      fg = UiPalette.error;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
      child: Text(text, style: TextStyle(color: fg, fontSize: 12, fontWeight: FontWeight.w700)),
    );
  }
}

class _OrderInfoRow extends StatelessWidget {
  const _OrderInfoRow({required this.icon, required this.title, required this.subtitle, this.imageUrl});
  final IconData icon;
  final String title;
  final String subtitle;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: UiPalette.border.withValues(alpha: 0.5), 
            shape: BoxShape.circle,
          ),
          child: ClipOval(
            child: imageUrl != null && imageUrl!.isNotEmpty
                ? Image.network(
                    imageUrl!,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)));
                    },
                    errorBuilder: (context, error, stackTrace) => Icon(icon, size: 18, color: UiPalette.textSecondary),
                  )
                : Icon(icon, size: 18, color: UiPalette.textSecondary),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: UiPalette.textPrimary)),
              Text(subtitle, style: const TextStyle(color: UiPalette.textSecondary, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ],
    );
  }
}

class _SmallButton extends StatelessWidget {
  const _SmallButton({required this.onPressed, required this.label, required this.isPrimary});
  final VoidCallback? onPressed;
  final String label;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? UiPalette.primary : Colors.white,
        foregroundColor: isPrimary ? Colors.white : UiPalette.textPrimary,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: isPrimary ? BorderSide.none : const BorderSide(color: UiPalette.border),
        ),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
    );
  }
}
