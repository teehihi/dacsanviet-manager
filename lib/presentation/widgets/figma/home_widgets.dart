import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/ui_palette.dart';
import '../../theme/figma_assets.dart';
import '../../../state/app_controller.dart';

class RevenueCard extends StatelessWidget {
  const RevenueCard({super.key, required this.controller});
  final AppController controller;

  @override
  Widget build(BuildContext context) {
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
                    'Tổng doanh thu tháng',
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: UiPalette.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _currencyStr(controller.totalRevenue),
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
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.north_east_rounded, size: 14, color: Color(0xFF008236)),
                    const SizedBox(width: 4),
                    Text(
                      '12.5%',
                      style: GoogleFonts.dmSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF008236),
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
                onTap: () {},
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
                icon: FigmaAssets.homeQr,
                iconColor: const Color(0xFF2B7FFF),
                label: 'QR Code',
                onTap: () {},
              ),
              QuickAction(
                bg: const Color(0xFFF5E6FF),
                icon: FigmaAssets.homeWallet,
                iconColor: const Color(0xFFAD46FF),
                label: 'Ví',
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _currencyStr(int value) {
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
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: UiPalette.textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class ChartPlaceholder extends StatelessWidget {
  const ChartPlaceholder({super.key, this.bars = false});
  final bool bars;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 160,
          child: CustomPaint(
            painter: _ChartPainter(bars: bars),
            size: Size.infinite,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'].map((day) {
            return Text(
              day,
              style: GoogleFonts.dmSans(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF94A3B8),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _ChartPainter extends CustomPainter {
  _ChartPainter({required this.bars});
  final bool bars;

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = const Color(0xFFF1F5F9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Draw horizontal grid lines
    const gridLines = 4;
    for (var i = 0; i <= gridLines; i++) {
        final y = size.height - (i * size.height / gridLines);
        canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
        
        // Draw Y labels
        final textPainter = TextPainter(
          text: TextSpan(
            text: '${i * 2000}',
            style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 9),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        textPainter.paint(canvas, Offset(-25, y - 5));
    }

    if (bars) {
      final barWidth = size.width / 14;
      final paint = Paint()
        ..color = UiPalette.primary
        ..style = PaintingStyle.fill;

      for (var i = 0; i < 7; i++) {
        final x = i * (size.width / 6.5);
        final h = size.height * (0.3 + (i % 3 * 0.2));
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(x, size.height - h, barWidth, h),
            const Radius.circular(6),
          ),
          paint,
        );
      }
    } else {
      // Line Chart Path
      final points = [
        Offset(0, size.height * 0.7),
        Offset(size.width * 0.16, size.height * 0.75),
        Offset(size.width * 0.33, size.height * 0.5),
        Offset(size.width * 0.5, size.height * 0.6),
        Offset(size.width * 0.66, size.height * 0.3),
        Offset(size.width * 0.83, size.height * 0.1),
        Offset(size.width, size.height * 0.2),
      ];

      final path = Path();
      path.moveTo(points[0].dx, points[0].dy);
      for (var i = 1; i < points.length; i++) {
          final prev = points[i-1];
          final cur = points[i];
          path.cubicTo(
              prev.dx + (cur.dx - prev.dx) / 2, prev.dy,
              prev.dx + (cur.dx - prev.dx) / 2, cur.dy,
              cur.dx, cur.dy
          );
      }

      // Area fill
      final areaPath = Path.from(path);
      areaPath.lineTo(size.width, size.height);
      areaPath.lineTo(0, size.height);
      areaPath.close();

      final fillPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            UiPalette.primary.withValues(alpha: 0.2),
            UiPalette.primary.withValues(alpha: 0.0),
          ],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
      canvas.drawPath(areaPath, fillPaint);

      final linePaint = Paint()
        ..color = UiPalette.primary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round;
      canvas.drawPath(path, linePaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
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
                  ? Image.network(imageUrl!, fit: BoxFit.cover)
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
