import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/ui_palette.dart';
import '../../domain/models.dart';
import '../../domain/models/shipping_provider.dart';
import '../../state/app_controller.dart';
import '../widgets/figma/order_card.dart';
import '../widgets/design_widgets.dart';
import '../widgets/shipping_provider_selector.dart';
import 'order_detail_screen.dart';

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
                          .map((o) {
                              final product = widget.controller.products.isEmpty 
                                  ? null 
                                  : widget.controller.products.firstWhere(
                                      (p) => o.productSummary.contains(p.name), 
                                      orElse: () => widget.controller.products.first,
                                    );
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => OrderDetailScreen(order: o, controller: widget.controller),
                                      ),
                                    );
                                  },
                                  child: OrderCard(
                                    orderCode: o.code,
                                    state: o.status.label,
                                    customerName: o.customerName,
                                    phone: o.phone,
                                    address: o.address,
                                    productSummary: o.productSummary,
                                    totalAmount: o.totalAmount,
                                    imageUrl: product?.imageUrl,
                                    onConfirm: o.status == OrderStatus.pending
                                        ? () async => _showCarrierDialog(context, o.id)
                                        : (o.status == OrderStatus.shipping ? () async => _showPaymentMethodDialog(context, o.id) : null),
                                    onReject: o.status == OrderStatus.pending 
                                        ? () async => _showCancelDialog(context, o.id, isReject: true)
                                        : (o.status == OrderStatus.shipping ? () async => _showCancelDialog(context, o.id) : null),
                                  ).animateIn(),
                                ),
                              );
                            })
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

  Future<void> _showCarrierDialog(BuildContext context, String orderId) async {
    debugPrint('🚚 [CarrierDialog] Opening for orderId=$orderId');
    final ShippingProvider? provider = await showShippingProviderSheet(
      context,
      providers: kDefaultShippingProviders,
    );

    debugPrint('🚚 [CarrierDialog] Sheet closed, provider=${provider?.name}, mounted=${context.mounted}');

    if (provider != null && context.mounted) {
      debugPrint('🚚 [CarrierDialog] Calling confirmOrder with carrier=${provider.name} fee=${provider.fee}');
      await widget.controller.confirmOrder(
        orderId,
        carrierName: provider.name,
        shippingFee: provider.fee.toDouble(),
      );
      debugPrint('🚚 [CarrierDialog] confirmOrder done, error=${widget.controller.error}');
    }
  }


  // Improved version with StatefulBuilder for selection update
  void _showCancelDialog(BuildContext context, String orderId, {bool isReject = false}) {
    final reasons = [
      'Khách hàng thay đổi ý định',
      'Không liên lạc được khách hàng',
      'Địa chỉ giao hàng không chính xác',
      'Hết hàng tại kho',
      'Khách hàng từ chối nhận hàng',
    ];
    String? selectedReason;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setInternalState) => AlertDialog(
          title: Text(isReject ? 'Từ chối đơn hàng' : 'Hủy đơn hàng', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Vui lòng chọn lý do:', style: GoogleFonts.dmSans(fontSize: 14, color: UiPalette.textSecondary)),
              const SizedBox(height: 12),
              ...reasons.map((r) => RadioListTile<String>(
                title: Text(r, style: GoogleFonts.dmSans(fontSize: 14)),
                value: r,
                groupValue: selectedReason,
                contentPadding: EdgeInsets.zero,
                activeColor: UiPalette.primary,
                onChanged: (val) {
                  setInternalState(() => selectedReason = val);
                },
              )),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Hủy')),
            FilledButton(
              onPressed: selectedReason == null ? null : () {
                widget.controller.rejectOrder(orderId, reason: selectedReason);
                Navigator.pop(ctx);
              },
              child: const Text('Đồng ý'),
            ),
          ],
        ),
      ),
    );
  }

  void _showPaymentMethodDialog(BuildContext context, String orderId) {
    final methods = [
      {'val': 'COD', 'label': 'Thanh toán khi nhận hàng (COD)'},
      {'val': 'BANK_TRANSFER', 'label': 'Chuyển khoản ngân hàng'},
      {'val': 'VNPAY', 'label': 'Cổng thanh toán VNPAY'},
      {'val': 'MOMO', 'label': 'Ví điện tử MoMo'},
    ];
    String selected = methods[0]['val']!;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setInternalState) => AlertDialog(
          title: Text('Xác nhận thanh toán', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Chọn hình thức thanh toán thực tế:', style: GoogleFonts.dmSans(fontSize: 14, color: UiPalette.textSecondary)),
              const SizedBox(height: 12),
              ...methods.map((m) => RadioListTile<String>(
                title: Text(m['label']!, style: GoogleFonts.dmSans(fontSize: 14)),
                value: m['val']!,
                groupValue: selected,
                contentPadding: EdgeInsets.zero,
                activeColor: UiPalette.primary,
                onChanged: (val) {
                  if (val != null) {
                    setInternalState(() => selected = val);
                  }
                },
              )),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Hủy')),
            FilledButton(
              onPressed: () {
                widget.controller.completeOrder(orderId, paymentMethod: selected);
                Navigator.pop(ctx);
              },
              child: const Text('Hoàn tất giao hàng'),
            ),
          ],
        ),
      ),
    );
  }
}

