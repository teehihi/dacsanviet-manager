import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/ui_palette.dart';
import '../theme/figma_assets.dart';
import '../widgets/figma/home_widgets.dart';
import '../widgets/figma/common_widgets.dart';
import '../../state/app_controller.dart';

class FigmaHomeScreen extends StatelessWidget {
  const FigmaHomeScreen({super.key, required this.controller});
  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 120),
      children: [
        // Header Section
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: UiPalette.primary,
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(40)),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(bottomRight: Radius.circular(40)),
                child: Opacity(
                  opacity: 0.1,
                  child: Image.asset(FigmaAssets.splashBg, fit: BoxFit.cover),
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Xin chào,',
                              style: GoogleFonts.dmSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.white.withValues(alpha: 0.8),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${controller.user?.name ?? "Quản trị viên"} 👋',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        _buildHeaderIcon(FigmaAssets.homeBell),
                      ],
                    ),
                    const SizedBox(height: 24),
                    RevenueCard(controller: controller),
                  ],
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),
        
        // Mini Stats
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              MiniStatCard(
                iconBg: const Color(0xFFE6F7ED),
                iconAsset: FigmaAssets.statOrders,
                value: '${controller.totalOrders}',
                label: 'Đơn hàng',
              ),
              const SizedBox(width: 12),
              MiniStatCard(
                iconBg: const Color(0xFFFFF0E6),
                iconAsset: FigmaAssets.statRevenue,
                value: _currencyShort(controller.totalRevenue),
                label: 'Doanh thu',
              ),
              const SizedBox(width: 12),
              MiniStatCard(
                iconBg: const Color(0xFFEBF3FF),
                iconAsset: FigmaAssets.statProducts,
                value: '${controller.totalProducts}',
                label: 'Sản phẩm',
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Revenue Chart
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SectionCard(
            title: 'Biểu đồ doanh thu',
            actionLabel: 'Tuần này',
            onAction: () {},
            child: const Padding(
              padding: EdgeInsets.only(top: 10, left: 10),
              child: ChartPlaceholder(),
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Recent Orders
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SectionCard(
            title: 'Đơn hàng mới',
            onAction: () => controller.setTab(2),
            child: Column(
              children: [
                const SizedBox(height: 12),
                ...controller.orders.take(3).map((o) {
                    final product = controller.products.firstWhere((p) => o.productSummary.contains(p.name), orElse: () => controller.products.first);
                    return OrderHomeItem(
                        name: o.customerName,
                        product: o.productSummary,
                        price: _currencyFull(o.totalAmount),
                        status: o.status.name,
                        orderId: o.code.replaceAll('DH-', ''),
                        imageUrl: product.imageUrl,
                    );
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderIcon(String asset) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: SvgPicture.asset(asset, width: 22, colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
      ),
    );
  }

  String _currencyShort(int value) {
    if (value >= 1000000) return '${(value / 1000000).toStringAsFixed(1)}M';
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(0)}K';
    return value.toString();
  }

  String _currencyFull(int value) {
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
