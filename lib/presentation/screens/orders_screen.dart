import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/ui_palette.dart';
import '../../domain/models.dart';
import '../../state/app_controller.dart';
import '../widgets/figma/order_card.dart';
import '../widgets/design_widgets.dart';

class FigmaOrdersScreen extends StatefulWidget {
  const FigmaOrdersScreen({super.key, required this.controller});
  final AppController controller;

  @override
  State<FigmaOrdersScreen> createState() => _FigmaOrdersScreenState();
}

class _FigmaOrdersScreenState extends State<FigmaOrdersScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => widget.controller.loadOrders(),
      color: UiPalette.primary,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 120),
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
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
                const SizedBox(height: 16),
                Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F7),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: widget.controller.setOrderSearch,
                    style: GoogleFonts.dmSans(color: UiPalette.textDark),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: const Icon(Icons.search, color: Color(0xFFA0A0A0), size: 22),
                      hintText: 'Tìm mã đơn, tên, SĐT...',
                      hintStyle: GoogleFonts.dmSans(color: const Color(0xFFA0A0A0)),
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.close, size: 20),
                              onPressed: () {
                                _searchController.clear();
                                widget.controller.setOrderSearch('');
                              },
                            )
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: OrderStatus.values.map((s) {
                      final active = widget.controller.orderFilter == s;
                      return GestureDetector(
                        onTap: () => widget.controller.setOrderFilter(s),
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
            child: ListenableBuilder(
              listenable: widget.controller,
              builder: (ctx, _) {
                final orders = widget.controller.filteredOrders;
                return Column(
                  children: orders.isNotEmpty
                      ? orders
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
                                      ? () => widget.controller.confirmOrder(o.id)
                                      : (o.status == OrderStatus.shipping ? () => widget.controller.completeOrder(o.id) : null),
                                  onReject: o.status == OrderStatus.pending ? () => widget.controller.rejectOrder(o.id) : null,
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
                );
              }
            ),
          ),
        ],
      ),
    );
  }
}
