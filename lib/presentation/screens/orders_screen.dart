import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/ui_palette.dart';
import '../../domain/models.dart';
import '../../state/app_controller.dart';
import '../widgets/figma/order_card.dart';
import '../widgets/figma/loading_widgets.dart';

class FigmaOrdersScreen extends StatelessWidget {
  const FigmaOrdersScreen({super.key, required this.controller});
  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 120),
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(24, 60, 24, 12),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Đơn hàng',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: UiPalette.textDark,
                ),
              ),
              const SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: OrderStatus.values.map((s) {
                    final active = controller.orderFilter == s;
                    return GestureDetector(
                      onTap: () => controller.setOrderFilter(s),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: active ? UiPalette.primary : const Color(0xFFF5F5F7),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: active
                              ? [BoxShadow(color: UiPalette.primary.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))]
                              : [],
                        ),
                        child: Text(
                          s.label,
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
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: controller.filteredOrders.isNotEmpty
                ? controller.filteredOrders
                    .map((o) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: OrderCard(
                            orderCode: o.code,
                            state: o.status.label,
                            customerName: o.customerName,
                            phone: o.phone,
                            address: o.address,
                            productSummary: o.productSummary,
                            totalAmount: o.totalAmount,
                            onConfirm: o.status == OrderStatus.pending
                                ? () => controller.confirmOrder(o.id)
                                : (o.status == OrderStatus.shipping ? () => controller.completeOrder(o.id) : null),
                            onReject: o.status == OrderStatus.pending ? () => controller.rejectOrder(o.id) : null,
                          ).animateIn(),
                        ))
                    .toList()
                : [
                    const SizedBox(height: 80),
                    Center(
                      child: Column(
                        children: [
                          Icon(Icons.shopping_bag_outlined, size: 64, color: UiPalette.textSecondary.withValues(alpha: 0.2)),
                          const SizedBox(height: 16),
                          Text(
                            'Không có đơn hàng nào',
                            style: GoogleFonts.dmSans(fontSize: 16, color: UiPalette.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ],
          ),
        ),
      ],
    );
  }
}
