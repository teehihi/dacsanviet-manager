import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/ui_palette.dart';
import '../theme/figma_assets.dart';
import '../widgets/figma/common_widgets.dart';

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
      backgroundColor: UiPalette.background,
      body: Stack(
        children: [
          Positioned(
            left: -150,
            top: -150,
            child: BlurCircle(size: 400, color: UiPalette.primary.withValues(alpha: 0.15), blur: 80),
          ),
          Positioned(
            right: -100,
            bottom: -50,
            child: BlurCircle(size: 350, color: const Color(0xFF51A2FF).withValues(alpha: 0.15), blur: 80),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                child: Column(
                  children: [
                    Image.asset(FigmaAssets.logoLogin, width: 140),
                    const SizedBox(height: 48),
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 40,
                            offset: const Offset(0, 20),
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Chào mừng trở lại! 👋',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: UiPalette.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Đăng nhập để tiếp tục quản lý.',
                            style: GoogleFonts.dmSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: UiPalette.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 32),
                          LabeledInput(
                            label: 'Email',
                            controller: email,
                            iconAsset: FigmaAssets.loginEmail,
                            hint: 'admin@dacsanviet.vn',
                            obscure: false,
                          ),
                          const SizedBox(height: 20),
                          LabeledInput(
                            label: 'Mật khẩu',
                            controller: password,
                            iconAsset: FigmaAssets.loginLock,
                            hint: '••••••••',
                            obscure: obscure,
                            trailing: IconButton(
                              icon: SvgPicture.asset(FigmaAssets.loginEye, width: 20, colorFilter: const ColorFilter.mode(Color(0xFF6B6B6B), BlendMode.srcIn)),
                              onPressed: () => setState(() => obscure = !obscure),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {},
                              child: Text(
                                'Quên mật khẩu?',
                                style: GoogleFonts.dmSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: UiPalette.primary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: ElevatedButton(
                              onPressed: widget.onLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: UiPalette.primary,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                                elevation: 0,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Đăng nhập',
                                    style: GoogleFonts.dmSans(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  SvgPicture.asset(FigmaAssets.loginArrow, width: 20, height: 20),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Chưa có tài khoản? ',
                          style: GoogleFonts.dmSans(fontSize: 14, color: UiPalette.textSecondary),
                        ),
                        Text(
                          'Đăng ký ngay',
                          style: GoogleFonts.dmSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: UiPalette.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
