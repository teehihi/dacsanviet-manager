import 'package:flutter/widgets.dart';

import '../screens/design_screens.dart';

class DesignRegistry {
  static const titles = [
    '38:6341 Splash',
    '38:6284 Login',
    '1:339 Home',
    '9:3316 Order Pending',
    '9:3636 Order Shipping',
    '9:3878 Order Complete',
    '1:606 Products',
    '9:3106 Product Filtered',
    '39:8168 Add Product',
    '39:8543 Edit Product',
    '9:4435 Statistics',
    '9:6025 Profile',
    '9:2515 Bottom Nav',
    '9:4246 Order State',
    '9:5792 Time Filter',
  ];

  static Widget buildScreen(int index) {
    switch (index) {
      case 0:
        return const SplashDesignScreen();
      case 1:
        return const LoginDesignScreen();
      case 2:
        return const HomeDesignScreen();
      case 3:
        return const OrderDesignScreen(state: 'Chờ xác nhận');
      case 4:
        return const OrderDesignScreen(state: 'Đang giao');
      case 5:
        return const OrderDesignScreen(state: 'Đã giao');
      case 6:
        return const ProductsDesignScreen();
      case 7:
        return const ProductsDesignScreen(filtered: true);
      case 8:
        return const ProductFormDesignScreen(isEdit: false);
      case 9:
        return const ProductFormDesignScreen(isEdit: true);
      case 10:
        return const StatisticsDesignScreen();
      case 11:
        return const ProfileDesignScreen();
      case 12:
        return const BottomNavDesignScreen();
      case 13:
        return const OrderStateDesignScreen();
      case 14:
        return const TimerDesignScreen();
      default:
        return const SizedBox.shrink();
    }
  }
}
