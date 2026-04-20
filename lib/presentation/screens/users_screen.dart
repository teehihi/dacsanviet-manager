import 'package:flutter/material.dart';
import '../../state/app_controller.dart';
import '../widgets/design_widgets.dart';
import '../../domain/models.dart';
import 'package:google_fonts/google_fonts.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: widget.controller,
          builder: (context, _) {
            final users = widget.controller.users;
            
            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: const Color(0xFFEFF1F3)),
                                ),
                                child: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Expanded(
                              child: TopHeader(title: 'Người dùng', subtitle: 'Hệ thống Quản trị'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),
                        
                        // Premium Stats Section
                        Row(
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
                                [const Color(0xFFF59E0B), const Color(0xFFFBBF24)],
                                Icons.person_pin_rounded,
                              ),
                            ),
                          ],
                        ).animateIn(),
                        
                        const SizedBox(height: 24),
                        
                        // Luxury Search Bar
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              )
                            ],
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: (v) => setState(() {}),
                            decoration: InputDecoration(
                              hintText: 'Tìm kiếm tên, email, SĐT...',
                              hintStyle: GoogleFonts.dmSans(color: const Color(0xFFA0ABBB), fontSize: 15),
                              prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF6366F1)),
                              suffixIcon: _searchController.text.isNotEmpty 
                                ? IconButton(
                                    icon: const Icon(Icons.clear_rounded, size: 20),
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() {});
                                    },
                                  ) 
                                : null,
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(vertical: 18),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ).animateIn(delayMs: 100),
                        
                        const SizedBox(height: 32),
                        
                        Text(
                          'DANH SÁCH TÀI KHOẢN',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF64748B),
                            letterSpacing: 1.2,
                          ),
                        ).animateIn(delayMs: 150),
                        
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
                
                if (widget.controller.isLoading && users.isEmpty)
                  const SliverFillRemaining(child: Center(child: CircularProgressIndicator()))
                else if (users.isEmpty)
                  SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person_off_rounded, size: 64, color: Colors.grey[300]),
                          const SizedBox(height: 16),
                          Text('Không tìm thấy người dùng nào', 
                            style: GoogleFonts.dmSans(color: Colors.grey[500])),
                        ],
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, i) {
                          final user = users[i];
                          // Filter logic local (optional if controller already filters)
                          if (_searchController.text.isNotEmpty) {
                            final q = _searchController.text.toLowerCase();
                            if (!user.fullName.toLowerCase().contains(q) && 
                                !user.email.toLowerCase().contains(q) &&
                                !user.phoneNumber.contains(q)) {
                              return const SizedBox.shrink();
                            }
                          }
                          
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: PremiumUserCard(
                              user: user,
                              onToggleStatus: () => widget.controller.toggleUserStatus(user.id),
                              onDelete: () => _confirmDelete(context, user),
                            ),
                          ).animateIn(delayMs: 200 + (i * 40));
                        },
                        childCount: users.length,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildGradientStat(String title, String value, List<Color> colors, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: colors[0].withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(height: 16),
          Text(value, style: GoogleFonts.plusJakartaSans(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white)),
          Text(title, style: GoogleFonts.dmSans(fontSize: 13, color: Colors.white.withValues(alpha: 0.8), fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, User user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text('Xác nhận xóa', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800)),
        content: Text('Bạn có chắc chắn muốn xóa người dùng ${user.fullName}? Hành động này không thể hoàn tác.', 
          style: GoogleFonts.dmSans()),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), 
            child: Text('Hủy', style: GoogleFonts.dmSans(color: Colors.grey))),
          TextButton(
            onPressed: () {
              widget.controller.deleteUser(user.id);
              Navigator.pop(context);
            }, 
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFFFF4D4D).withValues(alpha: 0.1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text('Xóa ngay', style: GoogleFonts.dmSans(color: const Color(0xFFFF4D4D), fontWeight: FontWeight.bold)),
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
  });

  final User user;
  final VoidCallback onToggleStatus;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final isActive = user.isActive;
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () {}, // Detail view coming soon
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    _buildAvatar(user),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  user.fullName,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16,
                                    color: const Color(0xFF1E293B),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 6),
                              _buildStatusIndicator(isActive),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            user.email,
                            style: GoogleFonts.dmSans(
                              color: const Color(0xFF64748B),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildActionMenu(context),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    _buildInfoChip(
                      isActive ? Icons.verified_user_rounded : Icons.lock_rounded, 
                      isActive ? 'Hoạt động' : 'Tạm khóa',
                      isActive ? const Color(0xFF10B981) : const Color(0xFFF43F5E),
                    ),
                    const SizedBox(width: 8),
                    _buildInfoChip(
                      Icons.shield_rounded, 
                      user.role.toUpperCase(),
                      user.role.toUpperCase() == 'ADMIN' ? const Color(0xFF8B5CF6) : const Color(0xFF3B82F6),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFB),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.phone_rounded, size: 14, color: Color(0xFF94A3B8)),
                          const SizedBox(width: 6),
                          Text(
                            user.phoneNumber,
                            style: GoogleFonts.dmSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF475569),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(User user) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [const Color(0xFF6366F1).withValues(alpha: 0.1), const Color(0xFF6366F1).withValues(alpha: 0.2)],
        ),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: user.avatarUrl != null 
        ? ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Image.network(user.avatarUrl!, fit: BoxFit.cover),
          )
        : Center(
            child: Text(
              user.fullName.isNotEmpty ? user.fullName[0].toUpperCase() : 'U',
              style: GoogleFonts.plusJakartaSans(
                color: const Color(0xFF6366F1),
                fontWeight: FontWeight.w800,
                fontSize: 20,
              ),
            ),
          ),
    );
  }

  Widget _buildStatusIndicator(bool isActive) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? const Color(0xFF10B981) : const Color(0xFFF43F5E),
        boxShadow: [
          BoxShadow(
            color: (isActive ? const Color(0xFF10B981) : const Color(0xFFF43F5E)).withValues(alpha: 0.4),
            blurRadius: 4,
            spreadRadius: 1,
          )
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionMenu(BuildContext context) {
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      icon: const Icon(Icons.more_vert_rounded, color: Color(0xFF94A3B8)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 10,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      onSelected: (val) {
        if (val == 'delete') onDelete();
        if (val == 'toggle') onToggleStatus();
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'toggle',
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(10)),
                child: Icon(user.isActive ? Icons.lock_outline_rounded : Icons.lock_open_rounded, size: 18, color: const Color(0xFF475569)),
              ),
              const SizedBox(width: 12),
              Text(user.isActive ? 'Khóa tài khoản' : 'Mở khóa', style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: const Color(0xFFFEF2F2), borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.delete_outline_rounded, size: 18, color: Color(0xFFF43F5E)),
              ),
              const SizedBox(width: 12),
              Text('Xóa tài khoản', style: GoogleFonts.dmSans(fontWeight: FontWeight.w600, color: const Color(0xFFF43F5E))),
            ],
          ),
        ),
      ],
    );
  }
}
