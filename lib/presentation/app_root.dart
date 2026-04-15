import 'dart:async';

import 'package:flutter/material.dart';

import '../domain/models.dart';
import '../state/app_controller.dart';
import 'figma/figma_widgets.dart';
import 'widgets/design_widgets.dart';

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  final AppController controller = AppController();
  bool showSplash = true;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 1800), () {
      if (mounted) setState(() => showSplash = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSplash) return const FigmaSplashScreen();
    return AnimatedBuilder(
      animation: controller,
      builder: (_, child) => controller.isAuthenticated
          ? _MainShell(controller: controller)
          : FigmaLoginScreen(onLogin: controller.login),
    );
  }
}

class _MainShell extends StatelessWidget {
  const _MainShell({required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    final pages = [
      FigmaHomeScreen(controller: controller),
      _ProductsPage(controller: controller),
      _OrdersPage(controller: controller),
      _StatsPage(controller: controller),
      _ProfilePage(controller: controller),
    ];
    return Scaffold(
      body: SafeArea(child: pages[controller.tabIndex]),
      bottomNavigationBar: FigmaBottomNav(index: controller.tabIndex, onChanged: controller.setTab),
    );
  }
}

class _ProductsPage extends StatelessWidget {
  const _ProductsPage({required this.controller});
  final AppController controller;

  static const categories = ['Tất cả', 'Gia vị', 'Đồ uống', 'Bánh kẹo', 'Hải sản'];

  @override
  Widget build(BuildContext context) {
    final products = controller.filteredProducts;
    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const TopHeader(title: 'Quản lý sản phẩm', subtitle: ''),
            const SizedBox(height: 8),
            TextField(
              onChanged: controller.setProductSearch,
              decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Tìm kiếm sản phẩm...'),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categories.map((c) => CategoryChip(c, controller.productCategory == c)).toList(),
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: products.map((p) {
                return SizedBox(
                  width: (MediaQuery.of(context).size.width - 44) / 2,
                  height: 312,
                  child: ProductCard(data: ProductData(p.name, p.category, _currency(p.price), p.stock)),
                );
              }).toList(),
            ),
            const SizedBox(height: 80),
          ],
        ),
        Positioned(
          right: 20,
          bottom: 20,
          child: FloatingActionButton(
            backgroundColor: UiPalette.primary,
            onPressed: () => _showProductForm(context),
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }

  Future<void> _showProductForm(BuildContext context, {Product? product}) async {
    final name = TextEditingController(text: product?.name ?? '');
    final price = TextEditingController(text: product?.price.toString() ?? '0');
    final stock = TextEditingController(text: product?.stock.toString() ?? '0');
    final image = TextEditingController(text: product?.imageUrl ?? '');
    String category = product?.category ?? 'Gia vị';
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setState) => Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(ctx).viewInsets.bottom + 16),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product == null ? 'Thêm sản phẩm mới' : 'Sửa sản phẩm', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  TextField(controller: name, decoration: const InputDecoration(labelText: 'Tên sản phẩm')),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(child: TextField(controller: price, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Giá'))),
                      const SizedBox(width: 8),
                      Expanded(child: TextField(controller: stock, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Tồn kho'))),
                    ],
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    initialValue: category,
                    decoration: const InputDecoration(labelText: 'Danh mục'),
                    items: categories.where((c) => c != 'Tất cả').map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                    onChanged: (v) => setState(() => category = v ?? category),
                  ),
                  const SizedBox(height: 10),
                  TextField(controller: image, decoration: const InputDecoration(labelText: 'Link ảnh (tuỳ chọn)')),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(child: OutlinedButton(onPressed: () => Navigator.pop(ctx), child: const Text('Huỷ'))),
                      const SizedBox(width: 8),
                      Expanded(
                        child: FilledButton(
                          onPressed: () {
                            final parsedPrice = int.tryParse(price.text) ?? 0;
                            final parsedStock = int.tryParse(stock.text) ?? 0;
                            if (product == null) {
                              controller.addProduct(
                                name: name.text.trim(),
                                category: category,
                                price: parsedPrice,
                                stock: parsedStock,
                                imageUrl: image.text.trim().isEmpty ? null : image.text.trim(),
                              );
                            } else {
                              controller.updateProduct(
                                product.id,
                                name: name.text.trim(),
                                category: category,
                                price: parsedPrice,
                                stock: parsedStock,
                                imageUrl: image.text.trim().isEmpty ? null : image.text.trim(),
                              );
                            }
                            Navigator.pop(ctx);
                          },
                          child: Text(product == null ? 'Thêm mới' : 'Lưu'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _OrdersPage extends StatelessWidget {
  const _OrdersPage({required this.controller});
  final AppController controller;

  @override
  Widget build(BuildContext context) {
    final orders = controller.filteredOrders;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const TopHeader(title: 'Đơn hàng', subtitle: ''),
        const SizedBox(height: 10),
        Row(
          children: OrderStatus.values.map((s) {
            final selected = controller.orderFilter == s;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                selected: selected,
                label: Text(s.label),
                onSelected: (_) => controller.setOrderFilter(s),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        ...orders.map((o) => _OrderActionCard(order: o, controller: controller)),
      ],
    );
  }
}

class _OrderActionCard extends StatelessWidget {
  const _OrderActionCard({required this.order, required this.controller});
  final Order order;
  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: UiPalette.border)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(children: [Text(order.code, style: const TextStyle(fontWeight: FontWeight.w800)), const Spacer(), StatusPill(text: order.status.label)]),
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.person),
              title: Text(order.customerName),
              subtitle: Text('${order.phone} • ${order.address}'),
            ),
            ListTile(contentPadding: EdgeInsets.zero, leading: const Icon(Icons.inventory_2), title: const Text('Sản phẩm'), subtitle: Text(order.productSummary)),
            Row(
              children: [
                Expanded(child: Text('Thanh toán (${order.paymentMethod})\n${_currency(order.totalAmount)}', style: const TextStyle(fontWeight: FontWeight.w800))),
                if (order.status == OrderStatus.pending) ...[
                  OutlinedButton(onPressed: () => controller.rejectOrder(order.id), child: const Text('Từ chối')),
                  const SizedBox(width: 8),
                  FilledButton(onPressed: () => controller.confirmOrder(order.id), child: const Text('Xác nhận')),
                ] else if (order.status == OrderStatus.shipping)
                  FilledButton(onPressed: () => controller.completeOrder(order.id), child: const Text('Đã giao'))
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

class _StatsPage extends StatelessWidget {
  const _StatsPage({required this.controller});
  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const TopHeader(title: 'Thống kê', subtitle: ''),
        const SizedBox(height: 10),
        const SectionCard(title: 'Bộ lọc thời gian', child: TimerFilter()),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: MiniStat(title: 'Doanh thu', value: _currency(controller.totalRevenue))),
            const SizedBox(width: 8),
            Expanded(child: MiniStat(title: 'Đơn hàng', value: '${controller.totalOrders}')),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: MiniStat(title: 'Khách hàng', value: '${controller.totalCustomers}')),
            const SizedBox(width: 8),
            Expanded(child: MiniStat(title: 'Sản phẩm', value: '${controller.totalProducts}')),
          ],
        ),
        const SizedBox(height: 12),
        const SectionCard(title: 'Doanh thu', child: SizedBox(height: 220, child: ChartPlaceholder(bars: true))),
        const SizedBox(height: 12),
        const SectionCard(title: 'Xu hướng đơn hàng', child: SizedBox(height: 170, child: ChartPlaceholder())),
      ],
    );
  }
}

class TimerFilter extends StatefulWidget {
  const TimerFilter({super.key});

  @override
  State<TimerFilter> createState() => _TimerFilterState();
}

class _TimerFilterState extends State<TimerFilter> {
  String selected = 'Tuần';

  @override
  Widget build(BuildContext context) {
    const items = ['Hôm nay', 'Tuần', 'Tháng', 'Năm'];
    return Wrap(
      spacing: 8,
      children: items
          .map((e) => ChoiceChip(
                selected: selected == e,
                label: Text(e),
                onSelected: (_) => setState(() => selected = e),
              ))
          .toList(),
    );
  }
}

class _ProfilePage extends StatelessWidget {
  const _ProfilePage({required this.controller});
  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const TopHeader(title: 'Cá nhân', subtitle: ''),
        const SizedBox(height: 10),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: const [
                CircleAvatar(radius: 42, backgroundColor: UiPalette.primarySoft, child: Icon(Icons.person, size: 42, color: UiPalette.primary)),
                SizedBox(height: 8),
                Text('Nguyễn Nhật Thiên', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                Text('Chủ cửa hàng', style: TextStyle(color: UiPalette.textMuted)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        ...const ['Tên cửa hàng', 'Email', 'Số điện thoại', 'Địa chỉ']
            .map((e) => ListTile(title: Text(e), subtitle: Text('DacSanViet Store'), trailing: Icon(Icons.chevron_right))),
        const SizedBox(height: 6),
        ...const ['Thông báo', 'Bảo mật', 'Trợ giúp & Hỗ trợ'].map((e) => ListTile(title: Text(e), trailing: Icon(Icons.chevron_right))),
        const SizedBox(height: 10),
        FilledButton.icon(onPressed: controller.logout, icon: const Icon(Icons.logout), label: const Text('Đăng xuất')),
      ],
    );
  }
}

String _currency(int value) {
  final raw = value.toString();
  final b = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    final reverseIndex = raw.length - i;
    b.write(raw[i]);
    if (reverseIndex > 1 && reverseIndex % 3 == 1) b.write(',');
  }
  return '₫$b';
}
