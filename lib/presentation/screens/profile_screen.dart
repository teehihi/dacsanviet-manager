import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/ui_palette.dart';
import '../../state/app_controller.dart';
import 'users_screen.dart';
import 'coupons_screen.dart';

class FigmaProfileScreen extends StatelessWidget {
  const FigmaProfileScreen({super.key, required this.controller});
  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 120),
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            // Green Header Background
            Container(
              height: 180,
              padding: const EdgeInsets.fromLTRB(24, 60, 24, 0),
              decoration: const BoxDecoration(
                color: UiPalette.primary,
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(40)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cá nhân',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.edit_outlined, color: Colors.white, size: 22),
                  ),
                ],
              ),
            ),

            // Profile Card (Name, Stats) - positioned to overlap
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 120, 24, 0),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 40), // Space for avatar
                    Text(
                      controller.user?.fullName ?? 'Nguyễn Nhật Thiên',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: UiPalette.textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      controller.user?.role == 'ADMIN' ? 'Quản trị viên' : 'Người dùng',
                      style: GoogleFonts.dmSans(
                        fontSize: 14,
                        color: UiPalette.textMuted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          _buildMiniStat('248', 'Đơn hàng', UiPalette.primary),
                          const SizedBox(width: 12),
                          _buildMiniStat('106M', 'Doanh thu', const Color(0xFFF2994A)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Overlapping Avatar - positioned relative to the card
            Positioned(
              top: 85,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 20,
                      )
                    ],
                  ),
                  child: Stack(
                    children: [
                      const Center(child: Icon(Icons.person_outline, size: 45, color: UiPalette.primary)),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(color: UiPalette.primary, shape: BoxShape.circle),
                          child: const Icon(Icons.camera_alt, size: 14, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: _buildSectionTitle('THÔNG TIN CỬA HÀNG'),
        ),
        const SizedBox(height: 16),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              _ProfileItem(icon: Icons.storefront_outlined, label: 'Tên cửa hàng', value: 'DacSanViet Store'),
              _ProfileItem(icon: Icons.email_outlined, label: 'Email', value: 'thien@dacsanviet.vn'),
              _ProfileItem(icon: Icons.phone_outlined, label: 'Số điện thoại', value: '0901 234 567'),
              _ProfileItem(icon: Icons.location_on_outlined, label: 'Địa chỉ', value: 'Quận 1, TP.HCM'),
            ],
          ),
        ),

        const SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: _buildSectionTitle('CÀI ĐẶT'),
        ),
        const SizedBox(height: 16),
        
        // Settings Grouped Card
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                )
              ],
            ),
            child: Column(
              children: [
                _SettingsItem(
                  icon: Icons.people_outline_rounded,
                  label: 'Quản lý người dùng',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FigmaUsersScreen(controller: controller),
                      ),
                    );
                  },
                ),
                _buildDivider(),
                _SettingsItem(
                  icon: Icons.confirmation_num_outlined,
                  label: 'Quản lý khuyến mãi',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FigmaCouponsScreen(controller: controller),
                      ),
                    );
                  },
                ),
                _buildDivider(),
                _SettingsItem(
                  icon: Icons.notifications_none_rounded,
                  label: 'Thông báo',
                  onTap: () {},
                ),
                _buildDivider(),
                _SettingsItem(
                  icon: Icons.lock_outline_rounded,
                  label: 'Bảo mật',
                  onTap: () {},
                ),
                _buildDivider(),
                _SettingsItem(
                  icon: Icons.help_outline_rounded,
                  label: 'Trợ giúp & Hỗ trợ',
                  onTap: () {},
                  isLast: true,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 40),
        
        // Logout Button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: GestureDetector(
            onTap: controller.logout,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: const Color(0xFFFFEEEE), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF0000).withValues(alpha: 0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.logout_rounded, color: Color(0xFFFF4848), size: 22),
                  const SizedBox(width: 12),
                  Text(
                    'Đăng xuất',
                    style: GoogleFonts.dmSans(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFFF4848),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 24),
        Center(
          child: Text(
            'DacSanViet Admin v1.0.0',
            style: GoogleFonts.dmSans(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: const Color(0xFFAAAAAA),
            ),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildMiniStat(String value, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(value, style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w800, color: color)),
            Text(label, style: GoogleFonts.dmSans(fontSize: 12, color: UiPalette.textMuted)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: UiPalette.textMuted,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Divider(color: Colors.black.withValues(alpha: 0.04), height: 1),
    );
  }
}

class _ProfileItem extends StatelessWidget {
  const _ProfileItem({required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 22, color: UiPalette.textSecondary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.dmSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: UiPalette.textMuted,
                  ),
                ),
                Text(
                  value,
                  style: GoogleFonts.dmSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: UiPalette.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: Color(0xFFE0E0E0), size: 20),
        ],
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  const _SettingsItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isLast = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFB),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 22, color: UiPalette.textSecondary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.dmSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: UiPalette.textPrimary,
                ),
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Color(0xFFE0E0E0), size: 20),
          ],
        ),
      ),
    );
  }
}
