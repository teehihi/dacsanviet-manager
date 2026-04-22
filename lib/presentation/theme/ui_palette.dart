import 'dart:ui';
import 'package:flutter/material.dart';

class UiPalette {
  static const primary = Color(0xFF00B14F);
  static const primaryDark = Color(0xFF00893D);
  static const primaryLight = Color(0xFFE6F7ED);
  
  static const primaryGradient = [Color(0xFF00B14F), Color(0xFF00D25B)];
  
  static const success = Color(0xFF00B14F);
  static const successBg = Color(0xFFE6F7ED);
  static const warning = Color(0xFFFF6900);
  static const warningBg = Color(0xFFFFF0E6);
  static const error = Color(0xFFFF4B4B);
  static const errorBg = Color(0xFFFFEEEE);
  static const info = Color(0xFF2B7FFF);
  static const infoBg = Color(0xFFEAF4FF);
  
  static const accent = Color(0xFFFFD700); // Gold for premium feel
  
  static const textPrimary = Color(0xFF1A1A1A);
  static const textSecondary = Color(0xFF6B6B6B);
  static const background = Color(0xFFF7F7F7);
  static const border = Color(0xFFF1F4F8);
  static const shadow = Color(0x0F000000);

  // Glassmorphism
  static Color glassBackground = Colors.white.withValues(alpha: 0.85);
  static const glassBorder = Color(0x33FFFFFF);

  // Aliases for backward compatibility
  static const textMuted = textSecondary;
  static const textDark = textPrimary;
  static const primarySoft = primaryLight;
}
