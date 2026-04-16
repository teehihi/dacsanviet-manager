import 'dart:async';
import 'package:flutter/material.dart';

import '../state/app_controller.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/products_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/stats_screen.dart';
import 'screens/profile_screen.dart';
import 'widgets/figma/bottom_nav.dart';

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  final controller = AppController();
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      if (mounted) setState(() => _showSplash = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        if (_showSplash) return const FigmaSplashScreen();
        if (!controller.isAuthenticated) return FigmaLoginScreen(onLogin: controller.login);

        return Scaffold(
          body: Stack(
            children: [
              _buildBody(controller.tabIndex),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: FigmaBottomNav(
                  index: controller.tabIndex,
                  onChanged: controller.setTab,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody(int index) {
    switch (index) {
      case 0: return FigmaHomeScreen(controller: controller);
      case 1: return FigmaProductsScreen(controller: controller);
      case 2: return FigmaOrdersScreen(controller: controller);
      case 3: return FigmaStatsScreen(controller: controller);
      case 4: return FigmaProfileScreen(controller: controller);
      default: return const SizedBox.shrink();
    }
  }
}
