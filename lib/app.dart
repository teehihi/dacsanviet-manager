import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'presentation/theme/ui_palette.dart';
import 'presentation/app_root.dart';

class DacSanVietManagerApp extends StatelessWidget {
  const DacSanVietManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DacSanVietManager',
      builder: (context, child) {
        final media = MediaQuery.of(context);
        return MediaQuery(
          data: media.copyWith(
            // Keep typography stable across emulators/devices for Figma parity.
            textScaler: media.textScaler.clamp(minScaleFactor: 0.9, maxScaleFactor: 1.15),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: UiPalette.primary),
        scaffoldBackgroundColor: UiPalette.background,
        textTheme: GoogleFonts.dmSansTextTheme().copyWith(
          displayLarge: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, color: UiPalette.textDark),
          displayMedium: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, color: UiPalette.textDark),
          displaySmall: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, color: UiPalette.textDark),
          headlineLarge: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, color: UiPalette.textDark),
          headlineMedium: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, color: UiPalette.textDark),
          titleLarge: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, color: UiPalette.textDark),
        ).apply(
          bodyColor: UiPalette.textDark,
          displayColor: UiPalette.textDark,
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: UiPalette.border),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          hintStyle: TextStyle(color: UiPalette.textMuted),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: UiPalette.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: UiPalette.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: UiPalette.primary, width: 1.2),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: UiPalette.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        useMaterial3: true,
      ),
      home: const AppRoot(),
    );
  }
}
