import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shimmer/shimmer.dart';
import '../theme/ui_palette.dart';

class MemberAvatar extends StatelessWidget {
  const MemberAvatar({super.key, required this.name, required this.role});

  final String name;
  final String role;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white54, width: 2)),
          child: const CircleAvatar(
            radius: 34,
            backgroundColor: Colors.white24,
            child: CircleAvatar(radius: 30, child: Icon(Icons.person)),
          ),
        ),
        const SizedBox(height: 8),
        Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12)),
        Text(role, style: const TextStyle(color: Colors.white70, fontSize: 11)),
      ],
    );
  }
}

class TopHeader extends StatelessWidget {
  const TopHeader({super.key, required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (subtitle.isNotEmpty) Text(subtitle, style: const TextStyle(color: UiPalette.textMuted)),
              Text(title, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: UiPalette.textDark)),
            ],
          ),
        ),
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: UiPalette.border),
          ),
          child: const Icon(Icons.notifications_none_rounded),
        ),
      ],
    );
  }
}

class RevenueCard extends StatelessWidget {
  const RevenueCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(colors: [Color(0xFF14C767), Color(0xFF00A84A)]),
      ),
      child: const Padding(
        padding: EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tổng doanh thu tháng', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600)),
            SizedBox(height: 4),
            Text('₫45,200,000', style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: 14),
            Row(
              children: [
                _QuickAction(icon: Icons.add_business, text: 'Thêm SP'),
                SizedBox(width: 10),
                _QuickAction(icon: Icons.receipt_long, text: 'Đơn hàng'),
                SizedBox(width: 10),
                _QuickAction(icon: Icons.qr_code_2, text: 'QR Code'),
                SizedBox(width: 10),
                _QuickAction(icon: Icons.wallet, text: 'Ví'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, size: 18, color: Colors.white),
          ),
          const SizedBox(height: 6),
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 11)),
        ],
      ),
    );
  }
}

class MiniStat extends StatelessWidget {
  const MiniStat({
    super.key, 
    required this.title, 
    required this.value,
    this.icon,
    this.iconColor = UiPalette.primary,
    this.iconBg = UiPalette.primarySoft,
  });

  final String title;
  final String value;
  final Widget? icon;
  final Color iconColor;
  final Color iconBg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: UiPalette.shadow, blurRadius: 20, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Center(
              child: icon ?? Icon(Icons.trending_up, size: 16, color: iconColor),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value, 
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title, 
            style: const TextStyle(color: UiPalette.textMuted, fontSize: 11, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class StatTilesRow extends StatelessWidget {
  const StatTilesRow({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: MiniStat(title: 'Đơn hàng', value: '248')),
        SizedBox(width: 8),
        Expanded(child: MiniStat(title: 'Doanh thu', value: '₫45.2M')),
        SizedBox(width: 8),
        Expanded(child: MiniStat(title: 'Sản phẩm', value: '64')),
      ],
    );
  }
}

class StatTilesGrid extends StatelessWidget {
  const StatTilesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.55,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        MiniStat(title: 'Tổng doanh thu', value: '₫134M'),
        MiniStat(title: 'Đơn hàng', value: '453'),
        MiniStat(title: 'Khách hàng', value: '289'),
        MiniStat(title: 'Giá trị TB', value: '₫295K'),
      ],
    );
  }
}

class SectionCard extends StatelessWidget {
  const SectionCard({super.key, required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: UiPalette.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 20, color: UiPalette.textDark)),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}


class RecentOrdersList extends StatelessWidget {
  const RecentOrdersList({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        OrderRow(name: 'Nguyễn Văn A', product: 'Nước mắm Phú Quốc', code: '#2456', price: '₫250,000', state: 'Chờ xử lý'),
        OrderRow(name: 'Trần Thị B', product: 'Cà phê Buôn Ma Thuột', code: '#2455', price: '₫180,000', state: 'Đang giao'),
        OrderRow(name: 'Lê Văn C', product: 'Bánh pía Sóc Trăng', code: '#2454', price: '₫120,000', state: 'Hoàn thành'),
      ],
    );
  }
}

class OrderRow extends StatelessWidget {
  const OrderRow({
    super.key,
    required this.name,
    required this.product,
    required this.code,
    required this.price,
    required this.state,
  });

  final String name;
  final String product;
  final String code;
  final String price;
  final String state;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: UiPalette.border),
      ),
      child: Row(
        children: [
          const CircleAvatar(child: Icon(Icons.person)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(product, style: const TextStyle(color: UiPalette.textMuted)),
                const SizedBox(height: 2),
                Text(price, style: const TextStyle(fontWeight: FontWeight.w700, color: UiPalette.primary)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [Text(code), Text(state, style: const TextStyle(fontSize: 12, color: UiPalette.textMuted))],
          ),
        ],
      ),
    );
  }
}



class ProductData {
  const ProductData(this.name, this.category, this.price, this.stock, [this.imageUrl]);

  final String name;
  final String category;
  final String price;
  final int stock;
  final String? imageUrl;
}


class ShimmerLoading extends StatelessWidget {
  const ShimmerLoading({super.key, required this.width, required this.height, this.borderRadius = 12});

  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

// Extension to easily add premium animation to any widget
extension PremiumAnimation on Widget {
  Widget animateIn({int delayMs = 0}) {
    return animate(delay: delayMs.ms)
        .fadeIn(duration: 400.ms, curve: Curves.easeOut)
        .slideY(begin: 0.1, end: 0, duration: 400.ms, curve: Curves.easeOut);
  }
}
