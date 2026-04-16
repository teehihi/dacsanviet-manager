import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/ui_palette.dart';
import '../../theme/figma_assets.dart';

class FigmaBottomNav extends StatelessWidget {
  const FigmaBottomNav({super.key, required this.index, required this.onChanged});

  final int index;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    const height = 70.0;
    const radius = 35.0;
    
    return Container(
      height: height,
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 20),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9).withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: Colors.white, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 40,
            offset: const Offset(0, 16),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _NavButton(
            icon: FigmaAssets.navHome,
            activeIcon: FigmaAssets.navHomeActive,
            label: 'Trang chủ',
            isActive: index == 0,
            onTap: () => onChanged(0),
          ),
          _NavButton(
            icon: FigmaAssets.navCube,
            activeIcon: FigmaAssets.navProducts,
            label: 'Sản phẩm',
            isActive: index == 1,
            onTap: () => onChanged(1),
          ),
          _NavButton(
            icon: FigmaAssets.navChart,
            activeIcon: FigmaAssets.navOrders,
            label: 'Đơn hàng',
            isActive: index == 2,
            onTap: () => onChanged(2),
          ),
          _NavButton(
            icon: FigmaAssets.navUser,
            activeIcon: FigmaAssets.navStats,
            label: 'Thống kê',
            isActive: index == 3,
            onTap: () => onChanged(3),
          ),
          _NavButton(
            icon: FigmaAssets.navBox,
            activeIcon: FigmaAssets.navProfile,
            label: 'Cá nhân',
            isActive: index == 4,
            onTap: () => onChanged(4),
          ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String icon;
  final String activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: isActive ? 16 : 12,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: isActive ? UiPalette.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
          boxShadow: isActive ? [
            BoxShadow(
              color: UiPalette.primary.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            )
          ] : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              isActive ? activeIcon : icon,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                isActive ? Colors.white : const Color(0xFF6B6B6B),
                BlendMode.srcIn,
              ),
            ),
            if (isActive) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.dmSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
