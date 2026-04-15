import 'package:flutter/material.dart';

import '../widgets/design_widgets.dart';

class SplashDesignScreen extends StatelessWidget {
  const SplashDesignScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF61D487), Color(0xFF00B14F)],
        ),
      ),
      child: Column(
        children: [
          const Spacer(),
          Container(
            width: 128,
            height: 128,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: const [BoxShadow(blurRadius: 20, color: Colors.black26)],
            ),
            child: const Icon(Icons.storefront, size: 64, color: UiPalette.primary),
          ),
          const SizedBox(height: 24),
          const Text('DacSanViet', style: TextStyle(fontSize: 46, color: Colors.white, fontWeight: FontWeight.w800)),
          const Text('Quản lý bán hàng thông minh', style: TextStyle(fontSize: 18, color: Colors.white70, fontWeight: FontWeight.w600)),
          const Spacer(),
          const Text('PHÁT TRIỂN BỞI', style: TextStyle(color: Colors.white70, letterSpacing: 2)),
          const SizedBox(height: 16),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MemberAvatar(name: 'Phạm Văn Hậu', role: 'BE Dev'),
              MemberAvatar(name: 'Nguyễn Nhật Thiên', role: 'Team Leader - FE Dev'),
              MemberAvatar(name: 'Trương Công Anh', role: 'BE Dev'),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class LoginDesignScreen extends StatelessWidget {
  const LoginDesignScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFEFFAF3), Color(0xFFF6F8FA)],
        ),
      ),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: UiPalette.border),
            boxShadow: const [BoxShadow(color: Color(0x12000000), blurRadius: 16, offset: Offset(0, 8))],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.storefront, size: 84, color: UiPalette.primary),
              const SizedBox(height: 16),
              const Text('Chào mừng trở lại! 👋', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 28)),
              const SizedBox(height: 8),
              const Text('Đăng nhập để quản lý cửa hàng của bạn', style: TextStyle(color: UiPalette.textMuted)),
              const SizedBox(height: 32),
              const TextField(decoration: InputDecoration(prefixIcon: Icon(Icons.email), hintText: 'admin@dacsanviet.vn')),
              const SizedBox(height: 12),
              const TextField(
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: Icon(Icons.visibility_off),
                  hintText: '••••••••',
                ),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(onPressed: () {}, child: const Text('Quên mật khẩu?')),
              ),
              const SizedBox(height: 8),
              FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.login),
                label: const Text('Đăng nhập'),
                style: FilledButton.styleFrom(minimumSize: const Size(double.infinity, 52)),
              ),
              const SizedBox(height: 12),
              TextButton(onPressed: () {}, child: const Text('Chưa có tài khoản? Đăng ký ngay')),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeDesignScreen extends StatelessWidget {
  const HomeDesignScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        TopHeader(title: 'Nguyễn Nhật Thiên 👋', subtitle: 'Xin chào,'),
        SizedBox(height: 12),
        RevenueCard(),
        SizedBox(height: 12),
        StatTilesRow(),
        SizedBox(height: 12),
        SectionCard(title: 'Biểu đồ doanh thu', child: SizedBox(height: 180, child: ChartPlaceholder())),
        SizedBox(height: 12),
        SectionCard(title: 'Đơn hàng mới', child: RecentOrdersList()),
      ],
    );
  }
}

class OrderDesignScreen extends StatelessWidget {
  const OrderDesignScreen({super.key, required this.state});

  final String state;

  @override
  Widget build(BuildContext context) {
    final entries = ['DH-2456', 'DH-2457', 'DH-2458'];
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const TopHeader(title: 'Đơn hàng', subtitle: ''),
        const SizedBox(height: 10),
        const OrderStateDesignScreen(compact: true),
        const SizedBox(height: 10),
        ...entries.map((e) => OrderCard(orderCode: e, state: state)),
      ],
    );
  }
}

class ProductsDesignScreen extends StatelessWidget {
  const ProductsDesignScreen({super.key, this.filtered = false});

  final bool filtered;

  @override
  Widget build(BuildContext context) {
    final products = filtered
        ? const [ProductData('Cà phê Buôn Ma Thuột', 'Đồ uống', '180.000 ₫', 32)]
        : const [
            ProductData('Nước mắm Phú Quốc', 'Gia vị', '250.000 ₫', 45),
            ProductData('Cà phê Buôn Ma Thuột', 'Đồ uống', '180.000 ₫', 32),
            ProductData('Bánh pía Sóc Trăng', 'Bánh kẹo', '120.000 ₫', 28),
            ProductData('Mứt dừa Bến Tre', 'Bánh kẹo', '95.000 ₫', 56),
          ];
    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const TopHeader(title: 'Quản Lý Sản phẩm', subtitle: ''),
            const SizedBox(height: 8),
            const TextField(decoration: InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Tìm kiếm sản phẩm...')),
            const SizedBox(height: 10),
            const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  CategoryChip('Tất cả', true),
                  CategoryChip('Gia vị', false),
                  CategoryChip('Đồ uống', false),
                  CategoryChip('Bánh kẹo', false),
                  CategoryChip('Hải sản', false),
                ],
              ),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: .6,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (_, i) => ProductCard(data: products[i]),
            ),
          ],
        ),
        Positioned(
          right: 20,
          bottom: 20,
          child: FloatingActionButton(
            backgroundColor: UiPalette.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            onPressed: () {},
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}

class ProductFormDesignScreen extends StatelessWidget {
  const ProductFormDesignScreen({super.key, required this.isEdit});

  final bool isEdit;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          isEdit ? 'Sửa sản phẩm' : 'Thêm sản phẩm mới',
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        _field('Tên sản phẩm', isEdit ? 'Cà phê Buôn Ma Thuột' : 'VD: Cà phê Buôn Ma Thuột...'),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _field('Giá (VNĐ)', isEdit ? '180000' : '0')),
            const SizedBox(width: 10),
            Expanded(child: _field('Tồn kho', isEdit ? '32' : '0')),
          ],
        ),
        const SizedBox(height: 12),
        _field('Danh mục', 'Đồ uống'),
        const SizedBox(height: 12),
        const Text('Hình ảnh sản phẩm', style: TextStyle(fontWeight: FontWeight.w700, color: UiPalette.textDark)),
        const SizedBox(height: 6),
        Container(
          height: 150,
          decoration: BoxDecoration(
            color: const Color(0xFFFBFDFC),
            border: Border.all(color: UiPalette.border),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: isEdit
                ? const Icon(Icons.image, size: 72, color: Colors.green)
                : const Icon(Icons.upload_file, size: 72, color: Colors.black45),
          ),
        ),
        const SizedBox(height: 8),
        _field('URL ảnh', isEdit ? 'https://images.unsplash.com/...' : 'https://...'),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: OutlinedButton(onPressed: () {}, child: const Text('Huỷ'))),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton(
                onPressed: () {},
                child: Text(isEdit ? 'Lưu thay đổi' : 'Thêm mới'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _field(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        TextField(decoration: InputDecoration(hintText: value)),
      ],
    );
  }
}

class StatisticsDesignScreen extends StatelessWidget {
  const StatisticsDesignScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        TopHeader(title: 'Thống kê', subtitle: ''),
        SizedBox(height: 8),
        TimerDesignScreen(compact: true),
        SizedBox(height: 12),
        StatTilesGrid(),
        SizedBox(height: 12),
        SectionCard(title: 'Doanh thu', child: SizedBox(height: 220, child: ChartPlaceholder(bars: true))),
        SizedBox(height: 12),
        SectionCard(title: 'Xu hướng đơn hàng', child: SizedBox(height: 180, child: ChartPlaceholder())),
        SizedBox(height: 12),
        SectionCard(title: 'Phân bổ danh mục', child: SizedBox(height: 180, child: ChartPlaceholder(bars: true))),
      ],
    );
  }
}

class ProfileDesignScreen extends StatelessWidget {
  const ProfileDesignScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const TopHeader(title: 'Cá nhân', subtitle: ''),
        const SizedBox(height: 8),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: UiPalette.border),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                CircleAvatar(radius: 42, backgroundColor: UiPalette.primarySoft, child: Icon(Icons.person, size: 42, color: UiPalette.primary)),
                SizedBox(height: 8),
                Text('Nguyễn Nhật Thiên', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: UiPalette.textDark)),
                Text('Chủ cửa hàng', style: TextStyle(color: UiPalette.textMuted)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        _sectionTitle('Thông tin cửa hàng'),
        ...const ['Tên cửa hàng', 'Email', 'Số điện thoại', 'Địa chỉ']
            .map((e) => ListTile(title: Text(e), subtitle: const Text('DacSanViet Store'), trailing: const Icon(Icons.chevron_right))),
        const SizedBox(height: 10),
        _sectionTitle('Cài đặt'),
        ...const ['Thông báo', 'Bảo mật', 'Trợ giúp & Hỗ trợ']
            .map((e) => ListTile(title: Text(e), trailing: const Icon(Icons.chevron_right))),
        const SizedBox(height: 10),
        FilledButton.icon(
          style: FilledButton.styleFrom(backgroundColor: UiPalette.primary),
          onPressed: () {},
          icon: const Icon(Icons.logout),
          label: const Text('Đăng xuất'),
        ),
        const SizedBox(height: 8),
        const Center(child: Text('DacSanViet Admin v1.0.0', style: TextStyle(color: Colors.black54))),
      ],
    );
  }

  static Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
    );
  }
}

class BottomNavDesignScreen extends StatelessWidget {
  const BottomNavDesignScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: UiPalette.border),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: BottomNavigationBar(
            currentIndex: 0,
            selectedItemColor: UiPalette.primary,
            unselectedItemColor: UiPalette.textMuted,
            showUnselectedLabels: true,
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
              BottomNavigationBarItem(icon: Icon(Icons.inventory_2), label: 'Sản phẩm'),
              BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Đơn hàng'),
              BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Thống kê'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Cá nhân'),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderStateDesignScreen extends StatelessWidget {
  const OrderStateDesignScreen({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final width = compact ? double.infinity : 420.0;
    return SizedBox(
      width: width,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: UiPalette.border),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              StatusPill(text: 'Chờ xác nhận'),
              StatusPill(text: 'Đang giao'),
              StatusPill(text: 'Hoàn thành'),
            ],
          ),
        ),
      ),
    );
  }
}

class TimerDesignScreen extends StatelessWidget {
  const TimerDesignScreen({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final chips = const ['Hôm nay', 'Tuần', 'Tháng', 'Năm'];
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: UiPalette.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: compact
            ? Wrap(
                spacing: 8,
                children: chips
                    .map((e) => ChoiceChip(
                          selected: e == 'Tuần',
                          selectedColor: UiPalette.primary,
                          labelStyle: TextStyle(color: e == 'Tuần' ? Colors.white : UiPalette.textMuted, fontWeight: FontWeight.w700),
                          label: Text(e),
                        ))
                    .toList(),
              )
            : Column(
                children: chips
                    .map((e) => ListTile(title: Text(e), trailing: const Icon(Icons.radio_button_unchecked)))
                    .toList(),
              ),
      ),
    );
  }
}
