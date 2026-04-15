import 'package:flutter/material.dart';

class UiPalette {
  static const primary = Color(0xFF00B14F);
  static const primarySoft = Color(0xFFE7F8EE);
  static const border = Color(0xFFE7ECF1);
  static const textDark = Color(0xFF172B4D);
  static const textMuted = Color(0xFF6B778C);
}

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
  const MiniStat({super.key, required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: UiPalette.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(color: UiPalette.primarySoft, borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.trending_up, size: 14, color: UiPalette.primary),
                ),
                const SizedBox(width: 8),
                Expanded(child: Text(title, style: const TextStyle(color: UiPalette.textMuted, fontSize: 12))),
              ],
            ),
            const Spacer(),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 21, color: UiPalette.textDark)),
          ],
        ),
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

class ChartPlaceholder extends StatelessWidget {
  const ChartPlaceholder({super.key, this.bars = false});

  final bool bars;

  @override
  Widget build(BuildContext context) {
    final heights = bars
        ? <double>[32, 46, 38, 64, 76, 88, 108]
        : <double>[42, 54, 66, 58, 84, 96, 112];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FCFA),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: UiPalette.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: heights.map((h) {
          return Container(
            width: 18,
            height: h,
            decoration: BoxDecoration(
              color: bars ? UiPalette.primary.withValues(alpha: 0.85) : UiPalette.primarySoft,
              borderRadius: BorderRadius.circular(6),
            ),
          );
        }).toList(),
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

class StatusPill extends StatelessWidget {
  const StatusPill({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    Color bg = const Color(0xFFFFF6E6);
    Color fg = const Color(0xFFB76A00);
    if (text.contains('Đang giao')) {
      bg = const Color(0xFFEAF4FF);
      fg = const Color(0xFF1565C0);
    } else if (text.contains('Hoàn thành') || text.contains('Đã giao')) {
      bg = const Color(0xFFE7F8EE);
      fg = const Color(0xFF008A3E);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
      child: Text(text, style: TextStyle(color: fg, fontSize: 12, fontWeight: FontWeight.w700)),
    );
  }
}

class OrderCard extends StatelessWidget {
  const OrderCard({super.key, required this.orderCode, required this.state});

  final String orderCode;
  final String state;

  @override
  Widget build(BuildContext context) {
    final isPending = state == 'Chờ xác nhận';
    final isShipping = state == 'Đang giao';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: UiPalette.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              children: [
                Text(orderCode, style: const TextStyle(fontWeight: FontWeight.w800)),
                const Spacer(),
                StatusPill(text: state),
              ],
            ),
            const SizedBox(height: 8),
            const ListTile(leading: Icon(Icons.person), title: Text('Nguyễn Văn A'), subtitle: Text('0901 234 567 • Quận 1, TP.HCM')),
            const ListTile(leading: Icon(Icons.inventory_2), title: Text('Sản phẩm'), subtitle: Text('Nước mắm Phú Quốc x2')),
            Row(
              children: [
                const Expanded(child: Text('Thanh toán (COD)\n₫500,000', style: TextStyle(fontWeight: FontWeight.w800))),
                if (isPending) ...[
                  OutlinedButton(onPressed: () {}, child: const Text('Từ chối')),
                  const SizedBox(width: 8),
                  FilledButton(onPressed: () {}, child: const Text('Xác nhận')),
                ] else if (isShipping)
                  FilledButton(onPressed: () {}, child: const Text('Đã giao thành công'))
                else
                  TextButton(onPressed: () {}, child: const Text('Chi tiết')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryChip extends StatelessWidget {
  const CategoryChip(this.label, this.active, {super.key});

  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(
          label,
          style: TextStyle(color: active ? Colors.white : UiPalette.textMuted, fontWeight: FontWeight.w700),
        ),
        selected: active,
        selectedColor: UiPalette.primary,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: UiPalette.border),
        ),
        onSelected: (_) {},
      ),
    );
  }
}

class ProductData {
  const ProductData(this.name, this.category, this.price, this.stock);

  final String name;
  final String category;
  final String price;
  final int stock;
}

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.data});

  final ProductData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: UiPalette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
                    gradient: LinearGradient(colors: [Color(0xFFF2FAF5), Colors.white]),
                  ),
                  child: const Center(child: Icon(Icons.image, size: 54, color: UiPalette.primary)),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: UiPalette.primarySoft, borderRadius: BorderRadius.circular(999)),
                    child: Text(
                      '${data.stock}',
                      style: const TextStyle(color: UiPalette.primary, fontWeight: FontWeight.w700, fontSize: 11),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data.category, style: const TextStyle(color: UiPalette.textMuted, fontSize: 12)),
                const SizedBox(height: 2),
                Text(data.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(data.price, style: const TextStyle(fontWeight: FontWeight.w800, color: UiPalette.primary)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: UiPalette.border),
                          foregroundColor: UiPalette.textDark,
                        ),
                        onPressed: () {},
                        icon: const Icon(Icons.edit, size: 16),
                        label: const Text('Sửa'),
                      ),
                    ),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.delete_outline)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
