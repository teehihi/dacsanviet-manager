import 'dart:ui';
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
  final email = TextEditingController(text: 'admin@dacsanviet.com');
  final password = TextEditingController(text: 'admin123');
  bool obscure = true;
  bool isLoading = false;
  String? errorMessage;

  Future<void> _handleLogin() async {
    if (email.text.isEmpty || password.text.isEmpty) {
      setState(() {
        errorMessage = 'Vui lòng nhập email và mật khẩu';
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // Call the onLogin callback which should handle the actual login
      widget.onLogin();
    } catch (e) {
      setState(() {
        errorMessage = 'Đăng nhập thất bại: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFF8FBFF),
                  Color(0xFFE3F2FD),
                  Color(0xFFF1F8E9),
                ],
              ),
            ),
          ),
          Positioned(
            left: -100,
            top: -100,
            child: BlurCircle(
              size: 450,
              color: UiPalette.primary.withValues(alpha: 0.12),
              blur: 90,
            ),
          ),
          Positioned(
            right: -80,
            bottom: 100,
            child: BlurCircle(
              size: 380,
              color: const Color(0xFF2B7FFF).withValues(alpha: 0.1),
              blur: 90,
            ),
          ),
          Positioned(
            left: 50,
            bottom: -150,
            child: BlurCircle(
              size: 400,
              color: UiPalette.accent.withValues(alpha: 0.08),
              blur: 100,
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 30,
                ),
                child: Column(
                  children: [
                    Hero(
                      tag: 'logo',
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Image.asset(FigmaAssets.logoLogin, width: 150),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(38),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                        child: Container(
                          padding: const EdgeInsets.all(28),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(38),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.5),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 40,
                                offset: const Offset(0, 20),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Chào mừng trở lại! 👋',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800,
                                  color: UiPalette.textPrimary,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Đăng nhập để tiếp tục quản lý.',
                                style: GoogleFonts.dmSans(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: UiPalette.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 36),
                              LabeledInput(
                                label: 'Email',
                                controller: email,
                                iconAsset: FigmaAssets.loginEmail,
                                hint: 'admin@dacsanviet.vn',
                                obscure: false,
                              ),
                              const SizedBox(height: 24),
                              LabeledInput(
                                label: 'Mật khẩu',
                                controller: password,
                                iconAsset: FigmaAssets.loginLock,
                                hint: '••••••••',
                                obscure: obscure,
                                trailing: IconButton(
                                  icon: SvgPicture.asset(
                                    FigmaAssets.loginEye,
                                    width: 22,
                                    colorFilter: ColorFilter.mode(
                                      UiPalette.textSecondary.withValues(alpha: 0.7),
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  onPressed: () =>
                                      setState(() => obscure = !obscure),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {},
                                  style: TextButton.styleFrom(
                                    visualDensity: VisualDensity.compact,
                                  ),
                                  child: Text(
                                    'Quên mật khẩu?',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: UiPalette.primary,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              if (errorMessage != null)
                                Container(
                                  padding: const EdgeInsets.all(14),
                                  margin: const EdgeInsets.only(bottom: 20),
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade50.withValues(alpha: 0.7),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: Colors.red.shade100,
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.error_outline_rounded,
                                        color: Colors.red.shade700,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          errorMessage!,
                                          style: GoogleFonts.dmSans(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.red.shade800,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              Container(
                                width: double.infinity,
                                height: 62,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: UiPalette.primary.withValues(alpha: 0.3),
                                      blurRadius: 20,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                  gradient: const LinearGradient(
                                    colors: UiPalette.primaryGradient,
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                ),
                                child: ElevatedButton(
                                  onPressed: isLoading ? null : _handleLogin,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: isLoading
                                      ? const SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2.5,
                                          ),
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Đăng nhập',
                                              style: GoogleFonts.plusJakartaSans(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            SvgPicture.asset(
                                              FigmaAssets.loginArrow,
                                              width: 20,
                                              height: 20,
                                              colorFilter: const ColorFilter.mode(
                                                Colors.white,
                                                BlendMode.srcIn,
                                              ),
                                            ),
                                          ],
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Chưa có tài khoản? ',
                          style: GoogleFonts.dmSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: UiPalette.textSecondary,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'Đăng ký ngay',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: UiPalette.primary,
                            ),
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
