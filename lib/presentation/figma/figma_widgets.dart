import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../state/app_controller.dart';
import '../widgets/design_widgets.dart';
import 'figma_assets.dart';

class FigmaSplashScreen extends StatelessWidget {
  const FigmaSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(FigmaAssets.splashBg, fit: BoxFit.cover),
            ),
            Positioned.fill(child: Container(color: const Color(0xFF00B14F).withValues(alpha: 0.70))),
            Positioned.fill(
              child: Opacity(
                opacity: 0.30,
                child: ClipRect(
                  child: Align(
                    alignment: const Alignment(-0.55, -0.08),
                    widthFactor: 3.5709,
                    heightFactor: 1.0942,
                    child: Image.asset(FigmaAssets.splashBg, fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
            Positioned(
              left: -43.96,
              top: -95.65,
              child: _BlurCircle(size: 478.254, color: Colors.white.withValues(alpha: 0.10), blur: 64),
            ),
            Positioned(
              left: -90.21,
              top: 478.25,
              child: _BlurCircle(size: 573.905, color: const Color(0xFF05DF72).withValues(alpha: 0.20), blur: 64),
            ),
            Center(
              child: SizedBox(
                width: 224.358,
                height: 168.001,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      left: (224.358 - 128) / 2,
                      top: -47.5,
                      child: Container(
                        width: 128,
                        height: 128,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: const [
                            BoxShadow(color: Color(0x26000000), blurRadius: 32, offset: Offset(0, 8)),
                          ],
                        ),
                        child: Center(
                          child: Image.asset(FigmaAssets.logoSplash, width: 163, height: 92, fit: BoxFit.contain),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 30.22,
                      top: 100,
                      child: Text(
                        'DacSanViet',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 48,
                          fontWeight: FontWeight.w700,
                          height: 36 / 48,
                          letterSpacing: -0.75,
                          color: Colors.white,
                          shadows: const [Shadow(color: Color(0x40000000), blurRadius: 4, offset: Offset(0, 4))],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      top: 144,
                      child: SizedBox(
                        width: 224.358,
                        child: Text(
                          'Quản lý bán hàng thông minh',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.dmSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            height: 24 / 24,
                            color: Colors.white.withValues(alpha: 0.80),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FigmaLoginScreen extends StatefulWidget {
  const FigmaLoginScreen({super.key, required this.onLogin});
  final VoidCallback onLogin;

  @override
  State<FigmaLoginScreen> createState() => _FigmaLoginScreenState();
}

class _FigmaLoginScreenState extends State<FigmaLoginScreen> {
  final email = TextEditingController(text: 'admin@dacsanviet.vn');
  final password = TextEditingController(text: '12345678');
  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SizedBox.expand(
        child: Stack(
          children: [
            Positioned.fill(child: Container(color: const Color(0xFFF7F7F7))),
            Positioned(
              left: -43.96,
              top: -191.30,
              child: _BlurCircle(size: 478.254, color: UiPalette.primary.withValues(alpha: 0.20), blur: 80),
            ),
            Positioned(
              left: 101.09,
              top: 669.56,
              child: _BlurCircle(size: 382.603, color: const Color(0xFF51A2FF).withValues(alpha: 0.20), blur: 80),
            ),
            SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(top: 181.86, bottom: 24),
                  child: Container(
                    width: 407.741,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.80),
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(color: Colors.white, width: 0.664),
                      boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 80, offset: Offset(0, 24))],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: Column(
                        children: [
                          Transform.translate(
                            offset: const Offset(0, -15.52),
                            child: Image.asset(FigmaAssets.logoLogin, width: 163, height: 92, fit: BoxFit.contain),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Chào mừng trở lại! 👋',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.plusJakartaSans(fontSize: 24, fontWeight: FontWeight.w700, color: const Color(0xFF1A1A1A), height: 32 / 24),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Đăng nhập để quản lý cửa hàng của bạn',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF6B6B6B), height: 20 / 14),
                          ),
                          const SizedBox(height: 24),
                          _LabeledInput(
                            label: 'Email',
                            controller: email,
                            iconAsset: FigmaAssets.loginEmail,
                            hint: 'admin@dacsanviet.vn',
                            obscure: false,
                          ),
                          const SizedBox(height: 20),
                          _LabeledInput(
                            label: 'Mật khẩu',
                            controller: password,
                            iconAsset: FigmaAssets.loginLock,
                            hint: '••••••••',
                            obscure: obscure,
                            trailing: GestureDetector(
                              onTap: () => setState(() => obscure = !obscure),
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.transparent),
                                alignment: Alignment.center,
                                child: SvgPicture.asset(FigmaAssets.loginEye, width: 20, height: 20),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(padding: EdgeInsets.zero, foregroundColor: UiPalette.primary),
                              child: Text('Quên mật khẩu?', style: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w700)),
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 60,
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: widget.onLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: UiPalette.primary,
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                shadowColor: const Color(0x6600B14F),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Đăng nhập', style: GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
                                  const SizedBox(width: 10),
                                  SvgPicture.asset(FigmaAssets.loginArrow, width: 20, height: 20),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Chưa có tài khoản? ', style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF6B6B6B))),
                              Text('Đăng ký ngay', style: GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.w700, color: UiPalette.primary)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FigmaHomeScreen extends StatelessWidget {
  const FigmaHomeScreen({super.key, required this.controller});
  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.only(bottom: 120),
          children: [
            Container(
              height: 199.964,
              padding: const EdgeInsets.fromLTRB(15.994, 39.995, 15.994, 0),
              decoration: const BoxDecoration(
                color: UiPalette.primary,
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(32)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text('Xin chào,', style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white.withValues(alpha: 0.80))),
                      const SizedBox(height: 4),
                      Text('Nguyễn Nhật Thiên 👋', style: GoogleFonts.plusJakartaSans(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white, height: 32 / 24)),
                    ],
                  ),
                  Container(
                    width: 39.995,
                    height: 39.995,
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.20), shape: BoxShape.circle),
                    child: Stack(
                      children: [
                        Center(child: SvgPicture.asset(FigmaAssets.homeBell, width: 19.992, height: 19.992)),
                        Positioned(
                          left: 22.01,
                          top: 8,
                          child: Container(
                            width: 7.997,
                            height: 7.997,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFB2C36),
                              shape: BoxShape.circle,
                              border: Border.all(color: UiPalette.primary, width: 0.69),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15.994, 0, 15.994, 0),
              child: Transform.translate(
                offset: const Offset(0, -64),
                child: Column(
                  children: [
                    _RevenueCardFigma(),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _MiniStatCardFigma(
                          iconBg: UiPalette.primary.withValues(alpha: 0.10),
                          icon: SvgPicture.asset(FigmaAssets.statOrders, width: 15.994, height: 15.994),
                          value: '${controller.totalOrders}',
                          label: 'Đơn hàng',
                        ),
                        _MiniStatCardFigma(
                          iconBg: const Color(0xFFFF6900).withValues(alpha: 0.10),
                          icon: SvgPicture.asset(FigmaAssets.statRevenue, width: 15.994, height: 15.994),
                          value: '₫45.2M',
                          label: 'Doanh thu',
                        ),
                        _MiniStatCardFigma(
                          iconBg: const Color(0xFF2B7FFF).withValues(alpha: 0.10),
                          icon: SvgPicture.asset(FigmaAssets.statProducts, width: 15.994, height: 15.994),
                          value: '${controller.totalProducts}',
                          label: 'Sản phẩm',
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    SectionCard(
                      title: 'Biểu đồ doanh thu',
                      child: const SizedBox(height: 210, child: ChartPlaceholder()),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class FigmaBottomNav extends StatelessWidget {
  const FigmaBottomNav({super.key, required this.index, required this.onChanged});

  final int index;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    const height = 69.3095;
    const radius = 36.0;
    return Container(
      height: height,
      margin: const EdgeInsets.fromLTRB(32, 0, 32, 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9).withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: const Color(0xFFF9F9F9).withValues(alpha: 0.85), width: 0.664),
        boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 40, offset: Offset(0, 20), spreadRadius: -8)],
      ),
      child: Stack(
        children: [
          _NavButton(icon: FigmaAssets.navHome, left: 7.99, onTap: () => onChanged(0), active: index == 0, label: 'Trang chủ', activeIcon: FigmaAssets.navHomeActive),
          _NavButton(icon: FigmaAssets.navCube, left: 59.98, onTap: () => onChanged(1), active: index == 1, label: 'Sản phẩm', activeIcon: FigmaAssets.navProducts),
          _NavButton(icon: FigmaAssets.navBox, left: 111.97, onTap: () => onChanged(2), active: index == 2, label: 'Đơn hàng', activeIcon: FigmaAssets.navOrders),
          _NavButton(icon: FigmaAssets.navChart, left: 163.95, onTap: () => onChanged(3), active: index == 3, label: 'Thống kê', activeIcon: FigmaAssets.navStats),
          _NavButton(icon: FigmaAssets.navUser, left: 215.94, onTap: () => onChanged(4), active: index == 4, label: 'Cá nhân', activeIcon: FigmaAssets.navProfile),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.icon,
    required this.left,
    required this.onTap,
    required this.active,
    required this.label,
    required this.activeIcon,
  });

  final String icon;
  final String activeIcon;
  final double left;
  final VoidCallback onTap;
  final bool active;
  final String label;

  @override
  Widget build(BuildContext context) {
    const top = 7.99;
    const h = 51.998;
    return Positioned(
      left: left,
      top: top,
      child: GestureDetector(
        onTap: onTap,
        child: active
            ? Container(
                height: h,
                width: 139.678,
                decoration: BoxDecoration(
                  color: UiPalette.primary,
                  borderRadius: BorderRadius.circular(26),
                  boxShadow: const [BoxShadow(color: Color(0x4D00B14F), blurRadius: 20, offset: Offset(0, 8))],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(activeIcon, width: 23.996, height: 23.996),
                    const SizedBox(width: 7.992),
                    Text(label, style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white, height: 21 / 14)),
                  ],
                ),
              )
            : SizedBox(
                width: 47.991,
                height: h,
                child: Center(child: Image.asset(icon, width: 23.996, height: 23.996)),
              ),
      ),
    );
  }
}

class _RevenueCardFigma extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(19.992),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [BoxShadow(color: Color(0x0F000000), blurRadius: 30, offset: Offset(0, 8))],
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
                  Text('Tổng doanh thu tháng', style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF6B6B6B))),
                  const SizedBox(height: 4),
                  Text('₫45,200,000', style: GoogleFonts.plusJakartaSans(fontSize: 30, fontWeight: FontWeight.w700, color: const Color(0xFF1A1A1A), height: 36 / 30)),
                ],
              ),
              Container(
                height: 31.977,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    SvgPicture.asset(FigmaAssets.homeTrend, width: 15.994, height: 15.994),
                    const SizedBox(width: 6),
                    Text('12.5%', style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w700, color: const Color(0xFF008236))),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(height: 0.992, color: const Color(0x14000000)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              _QuickActionFigma(bg: Color(0x1A00B14F), icon: FigmaAssets.homeAdd, label: 'Thêm SP'),
              _QuickActionFigma(bg: Color(0x1AFF6900), icon: FigmaAssets.homeOrders, label: 'Đơn hàng'),
              _QuickActionFigma(bg: Color(0x1A2B7FFF), icon: FigmaAssets.homeQr, label: 'QR Code'),
              _QuickActionFigma(bg: Color(0x1AAD46FF), icon: FigmaAssets.homeWallet, label: 'Ví'),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickActionFigma extends StatelessWidget {
  const _QuickActionFigma({required this.bg, required this.icon, required this.label});

  final Color bg;
  final String icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 55,
      child: Column(
        children: [
          Container(
            width: 47.992,
            height: 47.992,
            decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
            child: Center(child: Image.asset(icon, width: 19.992, height: 19.992)),
          ),
          const SizedBox(height: 8),
          Text(label, style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w600, color: const Color(0xFF1A1A1A), height: 16.5 / 11), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _MiniStatCardFigma extends StatelessWidget {
  const _MiniStatCardFigma({required this.iconBg, required this.icon, required this.value, required this.label});

  final Color iconBg;
  final Widget icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 124.673,
      height: 122.464,
      padding: const EdgeInsets.fromLTRB(15.994, 15.994, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 20, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 31.998,
            height: 31.998,
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Center(child: icon),
          ),
          const SizedBox(height: 12),
          Text(value, style: GoogleFonts.dmSans(fontSize: 18, fontWeight: FontWeight.w700, color: const Color(0xFF1A1A1A), height: 28 / 18)),
          const SizedBox(height: 2),
          Text(label, style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w600, color: const Color(0xFF6B6B6B), height: 16.5 / 11)),
        ],
      ),
    );
  }
}

class _LabeledInput extends StatelessWidget {
  const _LabeledInput({
    required this.label,
    required this.controller,
    required this.iconAsset,
    required this.hint,
    required this.obscure,
    this.trailing,
  });

  final String label;
  final TextEditingController controller;
  final String iconAsset;
  final String hint;
  final bool obscure;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 7.99),
            child: Text(label, style: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w700, color: const Color(0xFF6B6B6B))),
          ),
          const SizedBox(height: 6),
          SizedBox(
            // Avoid 0.9px overflow caused by fractional heights + font metrics.
            height: 56.5,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    padding: const EdgeInsets.only(left: 48, right: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5E5E5).withValues(alpha: 0.50),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.centerLeft,
                    child: TextField(
                      controller: controller,
                      obscureText: obscure,
                      style: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w600, color: const Color(0xFF6B6B6B).withValues(alpha: 0.60)),
                      decoration: InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        hintText: hint,
                        hintStyle: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w600, color: const Color(0xFF6B6B6B).withValues(alpha: 0.60)),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 15.994,
                  top: 7.99,
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: Center(child: SvgPicture.asset(iconAsset, width: 20, height: 20)),
                  ),
                ),
                if (trailing != null) Positioned(right: 8, top: 7.99, child: trailing!),
              ],
            ),
          ),
        ],
      );
  }
}

class _BlurCircle extends StatelessWidget {
  const _BlurCircle({required this.size, required this.color, required this.blur});
  final double size;
  final Color color;
  final double blur;

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}

