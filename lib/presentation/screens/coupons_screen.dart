import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../theme/ui_palette.dart';
import '../../state/app_controller.dart';
import '../widgets/figma/common_widgets.dart';
import '../widgets/figma/coupon_form_dialog.dart';
import '../widgets/design_widgets.dart';
import '../../domain/models.dart';

class FigmaCouponsScreen extends StatefulWidget {
  const FigmaCouponsScreen({super.key, required this.controller});
  final AppController controller;

  @override
  State<FigmaCouponsScreen> createState() => _FigmaCouponsScreenState();
}

class _FigmaCouponsScreenState extends State<FigmaCouponsScreen> {
  @override
  void initState() {
    super.initState();
    debugPrint('🎯 FigmaCouponsScreen initState - coupons count: ${widget.controller.coupons.length}');
    widget.controller.loadCoupons();
  }

  void _showAddCoupon() {
    showDialog(
      context: context,
      builder: (context) => CouponFormDialog(
        onSaved: (data) => widget.controller.addCoupon(data),
      ),
    );
  }

  void _showEditCoupon(Coupon coupon) {
    showDialog(
      context: context,
      builder: (context) => CouponFormDialog(
        isEdit: true,
        initialData: {
          'id': coupon.id,
          'code': coupon.code,
          'type': coupon.type,
          'value': coupon.value,
          'min_order_amount': coupon.minOrderAmount,
          'description': coupon.description,
          'usage_limit': coupon.usageLimit,
          'valid_from': coupon.validFrom,
          'valid_to': coupon.validTo,
        },
        onSaved: (data) => widget.controller.updateCoupon(coupon.id, data),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiPalette.background,
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: widget.controller,
            builder: (context, _) {
              final coupons = widget.controller.coupons;

              return ListView(
                padding: const EdgeInsets.only(bottom: 150),
                children: [
                  const SizedBox(height: 120), // Height for pinned header
                  
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _buildStatsRow(),
                  ),
                  
                  const SizedBox(height: 32),

                  if (widget.controller.isLoading && coupons.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(50),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else if (coupons.isEmpty)
                    _buildEmptyState()
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children:
                            coupons
                                .map(
                                  (c) => _CouponCard(
                                    coupon: c,
                                    onEdit: () => _showEditCoupon(c),
                                    onDelete:
                                        () => widget.controller.deleteCoupon(
                                          c.id,
                                        ),
                                    onToggle:
                                        () =>
                                            widget.controller.toggleCouponStatus(
                                              c.id,
                                            ),
                                  ),
                                )
                                .toList(),
                      ),
                    ),
                ],
              );
            },
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
              child: TopHeader(
                title: 'Mã giảm giá',
                subtitle: 'Quản lý chương trình ưu đãi',
                showBackButton: true,
                onBack: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddCoupon,
        backgroundColor: UiPalette.primary,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }

  Widget _buildStatsRow() {
    final stats = widget.controller.couponStats;
    if (stats == null) return const SizedBox.shrink();

    return Row(
      children: [
        Expanded(
          child: MiniStat(
            title: 'Tổng số',
            value: stats['total_coupons']?.toString() ?? '0',
            icon: const Icon(Icons.confirmation_num_outlined,
                size: 16, color: UiPalette.primary),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: MiniStat(
            title: 'Đang chạy',
            value: stats['active_coupons']?.toString() ?? '0',
            icon: const Icon(Icons.check_circle_outline,
                size: 16, color: Colors.green),
            iconColor: Colors.green,
            iconBg: Colors.green.withValues(alpha: 0.1),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: MiniStat(
            title: 'Đã dùng',
            value: stats['total_usages']?.toString() ?? '0',
            icon: const Icon(Icons.people_outline,
                size: 16, color: Colors.orange),
            iconColor: Colors.orange,
            iconBg: Colors.orange.withValues(alpha: 0.1),
          ),
        ),
      ],
    ).animateIn();
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 150),
          Icon(
            Icons.confirmation_num_outlined,
            size: 100,
            color: Colors.grey.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 24),
          Text(
            'Chưa có mã giảm giá nào',
            style: GoogleFonts.dmSans(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Nhấn nút + để thêm mã mới',
            style: GoogleFonts.dmSans(color: Colors.grey[400], fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _CouponCard extends StatelessWidget {
  const _CouponCard({
    required this.coupon,
    required this.onEdit,
    required this.onDelete,
    required this.onToggle,
  });
  final Coupon coupon;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    bool isExpired =
        coupon.validTo != null && coupon.validTo!.isBefore(DateTime.now());
    final active = coupon.isActive && !isExpired;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color:
                        active
                            ? UiPalette.primary.withValues(alpha: 0.1)
                            : Colors.grey.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.confirmation_num_rounded,
                    color: active ? UiPalette.primary : Colors.grey,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            coupon.code,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: UiPalette.textDark,
                              letterSpacing: 0.5,
                            ),
                          ),
                          _buildStatusTag(active),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        coupon.description ??
                            'Giảm ${coupon.type == 'PERCENTAGE' ? '${coupon.value}%' : '${_formatCurrency(coupon.value.toInt())}'}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.dmSans(
                          fontSize: 14,
                          color: UiPalette.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _buildDivider(),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 12, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _buildMiniIcon(Icons.person_outline,
                        '${coupon.usedCount}/${coupon.usageLimit ?? "∞"}'),
                    const SizedBox(width: 16),
                    _buildMiniIcon(
                      Icons.event_available_outlined,
                      coupon.validTo != null
                          ? '${coupon.validTo!.day}/${coupon.validTo!.month}'
                          : 'Vĩnh viễn',
                      color: isExpired ? Colors.red : null,
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 20),
                      onPressed: onEdit,
                      color: UiPalette.primary,
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 20),
                      onPressed: onDelete,
                      color: Colors.red[300],
                    ),
                    Switch.adaptive(
                      value: coupon.isActive,
                      activeColor: UiPalette.primary,
                      onChanged: (_) => onToggle(),
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

  Widget _buildMiniIcon(IconData icon, String text, {Color? color}) {
    return Row(
      children: [
        Icon(icon, size: 14, color: color ?? Colors.grey[400]),
        const SizedBox(width: 4),
        Text(
          text,
          style: GoogleFonts.dmSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color ?? UiPalette.textDark,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusTag(bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: active ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        active ? 'ĐANG CHẠY' : 'DỪNG',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: active ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        const SizedBox(
          width: 10,
          height: 20,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: UiPalette.background,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
          ),
        ),
        Expanded(
          child: DashSeparator(
            color: Colors.grey.withValues(alpha: 0.2),
            height: 1,
          ),
        ),
        const SizedBox(
          width: 10,
          height: 20,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: UiPalette.background,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _formatCurrency(int value) {
    final fmt = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    return fmt.format(value);
  }
}

class DashSeparator extends StatelessWidget {
  const DashSeparator({super.key, this.height = 1, this.color = Colors.black});
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 5.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(decoration: BoxDecoration(color: color)),
            );
          }),
        );
      },
    );
  }
}
