import 'package:flutter/material.dart';
import '../../state/app_controller.dart';
import '../widgets/design_widgets.dart';
import '../../domain/models.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/utils/string_utils.dart';
import '../widgets/figma/bottom_nav.dart';
import '../theme/ui_palette.dart';

class FigmaUsersScreen extends StatefulWidget {
  const FigmaUsersScreen({super.key, required this.controller});
  final AppController controller;

  @override
  State<FigmaUsersScreen> createState() => _FigmaUsersScreenState();
}

class _FigmaUsersScreenState extends State<FigmaUsersScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.controller.loadUsers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiPalette.background,
      body: Stack(
        children: [
          // Content
          RefreshIndicator(
            onRefresh: () => widget.controller.loadUsers(),
            displacement: 100,
            color: UiPalette.primary,
            child: ListenableBuilder(
              listenable: widget.controller,
              builder: (context, _) {
                final users = widget.controller.filteredUsers;

                return CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    // Space for pinned header
                    const SliverToBoxAdapter(child: SizedBox(height: 120)),

                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 12),
                            _buildStatsRow(),
                            const SizedBox(height: 24),
                            _buildSearchField(),
                            const SizedBox(height: 32),
                            _buildListTitle(users.length),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),

                    if (widget.controller.isLoading && users.isEmpty)
                      const SliverFillRemaining(
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (users.isEmpty)
                      SliverFillRemaining(child: _buildEmptyState())
                    else
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 150),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate((context, i) {
                            final user = users[i];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: PremiumUserCard(
                                user: user,
                                onToggleStatus:
                                    () => widget.controller.toggleUserStatus(
                                      user.id,
                                    ),
                                onDelete: () => _confirmDelete(context, user),
                                onUpdateRole:
                                    (role) => widget.controller.updateUserRole(
                                      user.id,
                                      role,
                                    ),
                              ),
                            ).animateIn(delayMs: 100 + (i * 20));
                          }, childCount: users.length),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),

          // Pinned Header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 8,
                left: 20,
                right: 20,
                bottom: 12,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFB).withValues(alpha: 0.9),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TopHeader(
                title: 'Người dùng',
                subtitle: 'Quản trị hệ thống',
                showBackButton: true,
                onBack: () => Navigator.pop(context),
              ),
            ),
          ),

          // Bottom Navigation
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: FigmaBottomNav(
                index: 4, // Sync with Profile tab
                onChanged: (index) {
                  widget.controller.setTab(index);
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildGradientStat(
            'Tổng cộng',
            widget.controller.totalUsers.toString(),
            [const Color(0xFF6366F1), const Color(0xFF818CF8)],
            Icons.people_rounded,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildGradientStat(
            'Khách hàng',
            widget.controller.totalCustomers.toString(),
            [const Color(0xFF00B14F), const Color(0xFF34D399)],
            Icons.person_pin_rounded,
          ),
        ),
      ],
    ).animateIn();
  }

  Widget _buildSearchField() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: widget.controller.setUserSearch,
        decoration: InputDecoration(
          hintText: 'Tìm kiếm tên, email, SĐT...',
          hintStyle: GoogleFonts.dmSans(
            color: const Color(0xFFA0ABBB),
            fontSize: 15,
          ),
          prefixIcon: const Icon(Icons.search_rounded, color: UiPalette.primary),
          suffixIcon:
              _searchController.text.isNotEmpty
                  ? IconButton(
                    icon: const Icon(Icons.clear_rounded, size: 20),
                    onPressed: () {
                      _searchController.clear();
                      widget.controller.setUserSearch('');
                      setState(() {});
                    },
                  )
                  : null,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    ).animateIn(delayMs: 100);
  }

  Widget _buildListTitle(int count) {
    return Text(
      'DANH SÁCH TÀI KHOẢN ($count)',
      style: GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w800,
        color: const Color(0xFF64748B),
        letterSpacing: 1.2,
      ),
    ).animateIn(delayMs: 150);
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_off_rounded, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'Không tìm thấy người dùng nào',
            style: GoogleFonts.dmSans(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildGradientStat(
    String title,
    String value,
    List<Color> colors,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: colors[0].withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(height: 16),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          Text(
            title,
            style: GoogleFonts.dmSans(
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, User user) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            title: Text(
              'Xác nhận xóa',
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold),
            ),
            content: Text(
              'Bạn chắc chắn muốn xóa người dùng ${user.fullName}?',
              style: GoogleFonts.dmSans(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Hủy',
                  style: GoogleFonts.dmSans(color: UiPalette.textSecondary),
                ),
              ),
              TextButton(
                onPressed: () {
                  widget.controller.deleteUser(user.id);
                  Navigator.pop(context);
                },
                child: Text(
                  'Xóa',
                  style: GoogleFonts.dmSans(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
    );
  }
}

class PremiumUserCard extends StatelessWidget {
  const PremiumUserCard({
    super.key,
    required this.user,
    required this.onToggleStatus,
    required this.onDelete,
    required this.onUpdateRole,
  });

  final User user;
  final VoidCallback onToggleStatus;
  final VoidCallback onDelete;
  final Function(String) onUpdateRole;

  @override
  Widget build(BuildContext context) {
    final isActive = user.isActive;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        leading: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                UiPalette.primary.withValues(alpha: 0.1),
                UiPalette.primary.withValues(alpha: 0.05),
              ],
            ),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              user.fullName.isNotEmpty ? user.fullName[0].toUpperCase() : '?',
              style: GoogleFonts.plusJakartaSans(
                color: UiPalette.primary,
                fontWeight: FontWeight.w800,
                fontSize: 18,
              ),
            ),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                user.fullName,
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: UiPalette.textDark,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color:
                    user.role == 'ADMIN'
                        ? const Color(0xFFF0F9FF)
                        : const Color(0xFFF5F3FF),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color:
                      user.role == 'ADMIN'
                          ? const Color(0xFFBAE6FD)
                          : const Color(0xFFDDD6FE),
                  width: 0.5,
                ),
              ),
              child: Text(
                user.role,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  color:
                      user.role == 'ADMIN'
                          ? const Color(0xFF0369A1)
                          : const Color(0xFF6D28D9),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.email_outlined,
                    size: 14,
                    color: Color(0xFF94A3B8),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      user.email,
                      style: GoogleFonts.dmSans(
                        fontSize: 13,
                        color: UiPalette.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(
                    Icons.phone_enabled_outlined,
                    size: 14,
                    color: Color(0xFF94A3B8),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    user.phoneNumber,
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: UiPalette.textPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        trailing: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFB),
            borderRadius: BorderRadius.circular(12),
          ),
          child: PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded, color: Color(0xFF64748B)),
            offset: const Offset(0, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 8,
            onSelected: (v) {
              if (v == 'toggle') onToggleStatus();
              if (v == 'delete') onDelete();
              if (v == 'admin') onUpdateRole('ADMIN');
              if (v == 'user') onUpdateRole('USER');
            },
            itemBuilder:
                (ctx) => [
                  PopupMenuItem(
                    value: 'toggle',
                    child: Row(
                      children: [
                        Icon(
                          isActive
                              ? Icons.lock_outline_rounded
                              : Icons.lock_open_rounded,
                          size: 20,
                          color: const Color(0xFF475569),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          isActive ? 'Khóa tài khoản' : 'Mở khóa',
                          style: GoogleFonts.dmSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: user.role == 'ADMIN' ? 'user' : 'admin',
                    child: Row(
                      children: [
                        Icon(
                          user.role == 'ADMIN'
                              ? Icons.person_outline
                              : Icons.admin_panel_settings_outlined,
                          size: 20,
                          color: const Color(0xFF475569),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          user.role == 'ADMIN' ? 'Gỡ ADMIN' : 'Cấp ADMIN',
                          style: GoogleFonts.dmSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(height: 1),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        const Icon(
                          Icons.delete_outline_rounded,
                          size: 20,
                          color: Colors.red,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Xóa người dùng',
                          style: GoogleFonts.dmSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
          ),
        ),
      ),
    );
  }
}
