import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/ui_palette.dart';
import '../../state/app_controller.dart';
import '../widgets/figma/common_widgets.dart';
import '../widgets/figma/home_widgets.dart';
class FigmaStatsScreen extends StatelessWidget {
  const FigmaStatsScreen({super.key, required this.controller});
  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 120),
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(24, 60, 24, 20),
          color: Colors.white,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Thống kê',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: UiPalette.textDark,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.calendar_today_outlined, color: UiPalette.textDark, size: 22),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F7),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: ['Hôm nay', 'Tuần', 'Tháng', 'Năm'].map((e) {
                    final active = e == 'Hôm nay';
                    return Expanded(
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: active ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: active
                                ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)]
                                : [],
                          ),
                          child: Center(
                            child: Text(
                              e,
                              style: GoogleFonts.dmSans(
                                fontSize: 13,
                                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                                color: active ? UiPalette.textDark : UiPalette.textMuted,
                              ),
                            ),
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
            children: [
              Row(
                children: [
                  MiniStatCard(
                    iconBg: UiPalette.successBg,
                    iconAsset: '', // I'll use icons directly if assets are missing
                    value: _currencyStr(controller.totalRevenue),
                    label: 'Doanh thu',
                  ),
                  const SizedBox(width: 12),
                  MiniStatCard(
                    iconBg: UiPalette.warningBg,
                    iconAsset: '',
                    value: '${controller.totalOrders}',
                    label: 'Đơn hàng',
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SectionCard(
                title: 'Doanh thu theo tháng',
                child: const SizedBox(height: 220, child: ChartPlaceholder(bars: true)),
              ),
              const SizedBox(height: 24),
              SectionCard(
                title: 'Xu hướng đơn hàng',
                child: const SizedBox(height: 180, child: ChartPlaceholder()),
              ),
            ],
          ),
        ),
      ],
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
