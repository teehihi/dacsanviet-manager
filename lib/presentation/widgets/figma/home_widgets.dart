import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/ui_palette.dart';
import '../../theme/figma_assets.dart';
import '../../../state/app_controller.dart';
import '../../screens/coupons_screen.dart';
import '../../screens/categories_screen.dart';
import '../../../domain/utils/parse_utils.dart';

class RevenueCard extends StatelessWidget {
  const RevenueCard({super.key, required this.controller});
  final AppController controller;

  @override
  Widget build(BuildContext context) {
    final global = controller.revenueData?['global'];
    
    // Debug: Print all global data
    debugPrint('🔍 RevenueCard: global = $global');
    
    // Use current_month_revenue for monthly revenue display
    final monthlyRevenue = global?['current_month_revenue'] ?? 0;
    final lastMonthRevenue = global?['last_month_revenue'] ?? 0;
    
    debugPrint('🔍 RevenueCard: monthlyRevenue = $monthlyRevenue (${monthlyRevenue.runtimeType})');
    debugPrint('🔍 RevenueCard: lastMonthRevenue = $lastMonthRevenue (${lastMonthRevenue.runtimeType})');
    
    // Calculate real growth percentage
    String growth = "0%";
    bool isPositive = true;
    if (lastMonthRevenue != null && ParseUtils.parseInt(lastMonthRevenue) > 0) {
      final current = ParseUtils.parseInt(monthlyRevenue);
      final last = ParseUtils.parseInt(lastMonthRevenue);
      final growthPercent = ((current - last) / last * 100);
      isPositive = growthPercent >= 0;
      growth = "${isPositive ? '+' : ''}${growthPercent.toStringAsFixed(1)}%";
    } else if (ParseUtils.parseInt(monthlyRevenue) > 0) {
      growth = "+100%";
    }
    
    debugPrint('🔍 RevenueCard: growth = $growth, isPositive = $isPositive'); 

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 40,
            offset: const Offset(0, 16),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Doanh thu tháng này',
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: UiPalette.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${ParseUtils.formatPrice(monthlyRevenue)}đ',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: UiPalette.textPrimary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: isPositive ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(
                      isPositive ? Icons.north_east_rounded : Icons.south_east_rounded, 
                      size: 14, 
                      color: isPositive ? const Color(0xFF008236) : const Color(0xFFDC2626),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      growth,
                      style: GoogleFonts.dmSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isPositive ? const Color(0xFF008236) : const Color(0xFFDC2626),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              QuickAction(
                bg: const Color(0xFFE6F7ED),
                icon: FigmaAssets.homeAdd,
                iconColor: UiPalette.primary,
                label: 'Thêm SP',
                onTap: () {
                  controller.setTab(1); // Navigate to Products tab
                },
              ),
              QuickAction(
                bg: const Color(0xFFFFF0E6),
                icon: FigmaAssets.homeOrders,
                iconColor: const Color(0xFFFF6900),
                label: 'Đơn hàng',
                onTap: () => controller.setTab(2),
              ),
              QuickAction(
                bg: const Color(0xFFEBF3FF),
                icon: FigmaAssets.homeCategory,
                iconColor: const Color(0xFF2B7FFF),
                label: 'Danh mục',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoriesScreen(controller: controller),
                    ),
                  );
                },
              ),
              QuickAction(
                bg: const Color(0xFFF5E6FF),
                icon: FigmaAssets.homeWallet, // Using wallet icon for coupon as temporary
                iconColor: const Color(0xFFAD46FF),
                label: 'Coupon',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FigmaCouponsScreen(controller: controller),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class QuickAction extends StatelessWidget {
  const QuickAction({
    super.key,
    required this.bg,
    required this.icon,
    required this.label,
    required this.iconColor,
    required this.onTap,
  });

  final Color bg;
  final String icon;
  final String label;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
            child: Center(
              child: SvgPicture.asset(
                icon,
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: GoogleFonts.dmSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: UiPalette.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class MiniStatCard extends StatelessWidget {
  const MiniStatCard({
    super.key,
    required this.iconBg,
    required this.iconAsset,
    required this.value,
    required this.label,
  });

  final Color iconBg;
  final String iconAsset;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
              child: Center(
                child: SvgPicture.asset(
                  iconAsset,
                  width: 18,
                  height: 18,
                  colorFilter: ColorFilter.mode(
                    iconBg.computeLuminance() > 0.5 ? Colors.black.withValues(alpha: 0.6) : Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: UiPalette.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.dmSans(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: UiPalette.textSecondary,
                height: 1.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}


class ChartPlaceholder extends StatelessWidget {
  const ChartPlaceholder({super.key, this.controller});
  final AppController? controller;

  @override
  Widget build(BuildContext context) {
    final chartData = controller?.revenueData?['chartData'] as List? ?? [];
    final groupType = controller?.revenueData?['groupType'] ?? 'daily';
    
    List<dynamic> weekDays = chartData.isNotEmpty ? chartData : [];
    
    // Fallback for design previews
    if (weekDays.isEmpty) {
      // Generate Mon-Sun of current week
      final now = DateTime.now();
      final monday = now.subtract(Duration(days: (now.weekday - 1)));
      weekDays = List.generate(7, (i) => {
        'label': monday.add(Duration(days: i)).toIso8601String().split('T')[0],
        'revenue': (i + 1) * 200000.0,
      });
    }
    
    final List<FlSpot> spots = [];
    double maxRevenue = 100000;
    
    for (int i = 0; i < weekDays.length; i++) {
        final rev = weekDays[i]['revenue'];
        double val = (rev is int ? rev : double.tryParse(rev.toString()) ?? 0.0).toDouble();
        spots.add(FlSpot(i.toDouble(), val));
        if (val > maxRevenue) maxRevenue = val;
    }

    return Padding(
      padding: const EdgeInsets.only(top: 20, right: 10),
      child: SizedBox(
        height: 200,
        child: LineChart(
          LineChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: maxRevenue / 4,
              getDrawingHorizontalLine: (value) => const FlLine(
                color: Color(0xFFF1F5F9),
                strokeWidth: 1,
              ),
            ),
            titlesData: FlTitlesData(
              show: true,
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    int index = value.toInt();
                    if (index < 0 || index >= weekDays.length) return const SizedBox();
                    final labelRaw = weekDays[index]['label'].toString();
                    
                    String labelDisplay = '';
                    if (groupType == 'hourly') {
                      final parts = labelRaw.split(' ');
                      if (parts.length > 1) {
                          final timeParts = parts[1].split(':');
                          labelDisplay = '${timeParts[0]}h';
                      }
                    } else if (groupType == 'monthly') {
                      final parts = labelRaw.split('-');
                      if (parts.length > 1) {
                          labelDisplay = '${parts[1]}/${parts[0].substring(2)}';
                      }
                    } else {
                      final parts = labelRaw.split('-');
                      if (parts.length == 3) {
                          labelDisplay = '${parts[2]}/${parts[1]}';
                      } else {
                        try {
                          final date = DateTime.parse(labelRaw);
                          labelDisplay = '${date.day}/${date.month}';
                        } catch (_) {
                          labelDisplay = labelRaw;
                        }
                      }
                    }

                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        labelDisplay,
                        style: GoogleFonts.dmSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF94A3B8),
                        ),
                      ),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: maxRevenue / 4,
                  reservedSize: 42,
                  getTitlesWidget: (value, meta) {
                    String text = '';
                    if (value >= 1000000) {
                      text = '${(value / 1000000).toStringAsFixed(1)}M';
                    } else if (value >= 1000) {
                      text = '${(value / 1000).toInt()}K';
                    } else {
                      text = value.toInt().toString();
                    }
                    return Text(
                      text,
                      style: GoogleFonts.dmSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF94A3B8),
                      ),
                    );
                  },
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            minX: 0,
            maxX: (weekDays.length - 1).toDouble(),
            minY: 0,
            maxY: maxRevenue * 1.2,
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                gradient: LinearGradient(
                  colors: [UiPalette.primary, UiPalette.primary.withValues(alpha: 0.5)],
                ),
                barWidth: 4,
                isStrokeCapRound: true,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: [
                      UiPalette.primary.withValues(alpha: 0.2),
                      UiPalette.primary.withValues(alpha: 0.0),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ],
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                getTooltipColor: (_) => UiPalette.textPrimary,
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((spot) {
                    return LineTooltipItem(
                      '₫${spot.y.toInt().toString().replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (Match m) => "${m[1]},")}',
                      GoogleFonts.dmSans(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    );
                  }).toList();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class OrderHomeItem extends StatelessWidget {
  const OrderHomeItem({
    super.key,
    required this.name,
    required this.product,
    required this.price,
    required this.status,
    required this.orderId,
    this.imageUrl,
  });

  final String name;
  final String product;
  final String price;
  final String status;
  final String orderId;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(16),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: imageUrl != null && imageUrl!.isNotEmpty
                  ? Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)));
                      },
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.inventory_2_rounded, color: Color(0xFF94A3B8), size: 24),
                    )
                  : const Icon(Icons.inventory_2_rounded, color: Color(0xFF94A3B8), size: 24),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.dmSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: UiPalette.textPrimary,
                      ),
                    ),
                    _buildStatusPill(status),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  product,
                  style: GoogleFonts.dmSans(
                    fontSize: 13,
                    color: UiPalette.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      price,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: UiPalette.primary,
                      ),
                    ),
                    Text(
                      '#$orderId',
                      style: GoogleFonts.dmSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF94A3B8),
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

  Widget _buildStatusPill(String status) {
    Color bg = const Color(0xFFFEF3C7);
    Color fg = const Color(0xFFD97706);
    String label = 'Chờ xử lý';

    final s = status.toLowerCase();
    if (s.contains('đang giao') || s.contains('shipping')) {
      bg = const Color(0xFFDBEAFE);
      fg = const Color(0xFF2563EB);
      label = 'Đang giao';
    } else if (s.contains('hoàn thành') || s.contains('đã giao') || s.contains('complete')) {
      bg = const Color(0xFFDCFCE7);
      fg = const Color(0xFF16A34A);
      label = 'Hoàn thành';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: GoogleFonts.dmSans(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: fg,
        ),
      ),
    );
  }
}
