import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/ui_palette.dart';
import '../theme/figma_assets.dart';
import '../widgets/figma/common_widgets.dart';

class FigmaSplashScreen extends StatelessWidget {
  const FigmaSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(FigmaAssets.splashBg, fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    UiPalette.primary.withValues(alpha: 0.6),
                    UiPalette.primary.withValues(alpha: 0.8),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: -100,
            top: -100,
            child: BlurCircle(
              size: 400,
              color: Colors.white.withValues(alpha: 0.1),
              blur: 60,
            ),
          ),
          Positioned(
            right: -50,
            bottom: 100,
            child: BlurCircle(
              size: 300,
              color: const Color(0xFF05DF72).withValues(alpha: 0.2),
              blur: 60,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 32,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Image.asset(FigmaAssets.logoSplash, width: 80),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'DacSanViet',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 48,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Quản lý bán hàng thông minh',
                  style: GoogleFonts.dmSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
