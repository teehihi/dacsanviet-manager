import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/ui_palette.dart';
import '../../state/app_controller.dart';
import '../widgets/figma/common_widgets.dart';
import '../widgets/figma/home_widgets.dart';

class FigmaStatsScreen extends StatefulWidget {
  const FigmaStatsScreen({super.key, required this.controller});
  final AppController controller;

  @override
  State<FigmaStatsScreen> createState() => _FigmaStatsScreenState();
}

class _FigmaStatsScreenState extends State<FigmaStatsScreen> {
  String _selectedPeriod = 'week'; // 'day', 'week', 'month', 'year'
  
  @override
  void initState() {
    super.initState();
    _loadDataForPeriod(_selectedPeriod);
  }

  /// Tính date range từ period string và gọi loadAllRevenueData
  void _loadDataForPeriod(String period) {
    final now = DateTime.now();
    DateTime? startDate;
    final endDate = now;

    if (period == 'day') {
      startDate = DateTime(now.year, now.month, now.day);
    } else if (period == 'week') {
      final weekStart = now.subtract(Duration(days: now.weekday - 1));
      startDate = DateTime(weekStart.year, weekStart.month, weekStart.day);
    } else if (period == 'month') {
      startDate = DateTime(now.year, now.month, 1);
    } else if (period == 'year') {
      startDate = DateTime(now.year, 1, 1);
    }

    String? startStr;
    String? endStr;
    if (startDate != null) {
      startStr = '${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}';
      endStr   = '${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}';
    }

    widget.controller.loadAllRevenueData(startDate: startStr, endDate: endStr);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final overview = widget.controller.revenueData?['overview'];
        final topProducts = widget.controller.revenueData?['topProducts'] as List? ?? [];
        final monthly = widget.controller.revenueData?['monthly'] as List? ?? [];
        final categoryData = widget.controller.revenueByCategoryData;
        final paymentData = widget.controller.revenueByPaymentData;

        return CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
              elevation: 4,
              shadowColor: Colors.black.withValues(alpha: 0.1),
              toolbarHeight: 90,
              title: _buildHeader(),
              titleSpacing: 0,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(64),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildPeriodFilter(),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(bottom: 120, top: 20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Overview Stats Grid - tappable for detail
                  GestureDetector(
                    onTap: overview != null ? () => _showOverviewDetail(overview) : null,
                    child: _buildOverviewGrid(overview),
                  ),
                  const SizedBox(height: 24),

                  // Revenue Chart
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SectionCard(
                      title: 'Biểu đồ doanh thu',
                      child: SizedBox(
                        height: 220,
                        child: ChartPlaceholder(controller: widget.controller),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Revenue Breakdown Cards
                  if (overview != null) GestureDetector(
                    onTap: () => _showOverviewDetail(overview),
                    child: _buildRevenueBreakdown(overview),
                  ),
                  const SizedBox(height: 20),

                  // Top Products
                  if (topProducts.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _buildTopProductsSection(topProducts),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Revenue by Category
                  if (categoryData.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _buildCategoryRevenueSection(categoryData),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Revenue by Payment
                  if (paymentData.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _buildPaymentMethodSection(paymentData),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Monthly Trends
                  if (monthly.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _buildMonthlyTrendsSection(monthly),
                    ),
                    const SizedBox(height: 20),
                  ],
                ]),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Thống kê doanh thu',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: UiPalette.textDark,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Phân tích chi tiết hoạt động kinh doanh',
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  color: UiPalette.textSecondary,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () => _loadDataForPeriod(_selectedPeriod),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: UiPalette.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.refresh_rounded, color: UiPalette.primary, size: 22),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip('Hôm nay', 'day'),
            const SizedBox(width: 8),
            _buildFilterChip('Tuần này', 'week'),
            const SizedBox(width: 8),
            _buildFilterChip('Tháng này', 'month'),
            const SizedBox(width: 8),
            _buildFilterChip('Năm nay', 'year'),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedPeriod == value;
    return GestureDetector(
      onTap: () {
        if (_selectedPeriod == value) return;
        setState(() => _selectedPeriod = value);
        _loadDataForPeriod(value);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? UiPalette.primary : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: isSelected 
                ? UiPalette.primary.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.04),
              blurRadius: isSelected ? 12 : 8,
              offset: Offset(0, isSelected ? 4 : 2),
            ),
          ],
        ),
        child: Text(
          label,
          style: GoogleFonts.dmSans(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: isSelected ? Colors.white : UiPalette.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewGrid(Map<String, dynamic>? overview) {
    int currentRev = _pInt(overview?['delivered_revenue']);
    int currentCount = _pInt(overview?['delivered_count']);

    int profit = _pInt(overview?['delivered_profit']);
    int avg = currentCount > 0 ? (currentRev ~/ currentCount) : 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              _buildStatTile(
                icon: Icons.trending_up_rounded,
                iconColor: const Color(0xFF16A34A),
                iconBg: const Color(0xFFDCFCE7),
                title: 'Tổng doanh thu',
                value: _currencyStr(currentRev),
              ),
              const SizedBox(width: 12),
              _buildStatTile(
                icon: Icons.check_circle_outline,
                iconColor: const Color(0xFF2563EB),
                iconBg: const Color(0xFFDBEAFE),
                title: 'Lợi nhuận',
                value: _currencyStr(profit),
                subtitle: '$currentCount đơn • Trừ phí ship hãng',
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildStatTile(
                icon: Icons.shopping_bag_outlined,
                iconColor: const Color(0xFFD97706),
                iconBg: const Color(0xFFFEF3C7),
                title: 'Số đơn hoàn thành',
                value: '$currentCount',
              ),
              const SizedBox(width: 12),
              _buildStatTile(
                icon: Icons.monetization_on_outlined,
                iconColor: const Color(0xFF7C3AED),
                iconBg: const Color(0xFFF3E8FF),
                title: 'TB/Đơn hàng',
                value: _currencyStr(avg),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatTile({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String value,
    String? subtitle,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.dmSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: UiPalette.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: UiPalette.textDark,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: GoogleFonts.dmSans(fontSize: 11, color: UiPalette.textMuted),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueBreakdown(Map<String, dynamic> overview) {
    final pending = _pInt(overview['pending_revenue']);
    final cancelled = _pInt(overview['cancelled_revenue']);
    final cancelledCount = _pInt(overview['cancelled_count']);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Phân tích trạng thái',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: UiPalette.textDark,
              ),
            ),
            const SizedBox(height: 16),
            _buildBreakdownRow(
              'Đang xử lý',
              _currencyStr(pending),
              Icons.hourglass_bottom_rounded,
              const Color(0xFFD97706),
              const Color(0xFFFEF3C7),
            ),
            const SizedBox(height: 12),
            _buildBreakdownRow(
              'Đã huỷ ($cancelledCount đơn)',
              _currencyStr(cancelled),
              Icons.cancel_outlined,
              const Color(0xFFDC2626),
              const Color(0xFFFEE2E2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBreakdownRow(String label, String value, IconData icon, Color color, Color bg) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.dmSans(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: UiPalette.textDark,
            ),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildTopProductsSection(List<dynamic> products) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader('Top sản phẩm bán chạy', onViewAll: () => _showTopProductsDetail(products)),
          const SizedBox(height: 16),
          ...products.take(5).toList().asMap().entries.map((entry) {
            final i = entry.key;
            final p = entry.value;
            final name = p['name'] ?? 'N/A';
            final totalSold = _pInt(p['total_sold']);
            final totalRev = _pInt(p['total_revenue']);
            return _buildProductRow(i + 1, name, totalSold, totalRev);
          }),
        ],
      ),
    );
  }

  Widget _buildProductRow(int rank, String name, int sold, int revenue) {
    final rankColors = [
      const Color(0xFFFFD700),
      const Color(0xFFC0C0C0),
      const Color(0xFFCD7F32),
    ];
    final color = rank <= 3 ? rankColors[rank - 1] : const Color(0xFFE2E8F0);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                '$rank',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: rank <= 3 ? color : UiPalette.textMuted,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: UiPalette.textDark,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Đã bán: $sold',
                  style: GoogleFonts.dmSans(fontSize: 12, color: UiPalette.textMuted),
                ),
              ],
            ),
          ),
          Text(
            _currencyStr(revenue),
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: UiPalette.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryRevenueSection(List<dynamic> categories) {
    // Calculate total for percentage
    double totalRev = 0;
    for (var c in categories) {
      totalRev += _pInt(c['total_revenue']).toDouble();
    }

    final catColors = [
      const Color(0xFF16A34A),
      const Color(0xFF2563EB),
      const Color(0xFFD97706),
      const Color(0xFF7C3AED),
      const Color(0xFFDC2626),
      const Color(0xFF0891B2),
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader('Doanh thu theo danh mục', onViewAll: () => _showCategoryDetail(categories)),
          const SizedBox(height: 24),
          
          // Pie Chart for visual distribution
          if (categories.isNotEmpty)
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 4,
                  centerSpaceRadius: 40,
                  sections: categories.asMap().entries.map((entry) {
                    final i = entry.key;
                    final c = entry.value;
                    final rev = _pInt(c['total_revenue']).toDouble();
                    final pct = totalRev > 0 ? (rev / totalRev * 100) : 0.0;
                    return PieChartSectionData(
                      color: catColors[i % catColors.length],
                      value: rev,
                      title: '${pct.toStringAsFixed(0)}%',
                      radius: 50,
                      titleStyle: GoogleFonts.dmSans(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          const SizedBox(height: 24),
          // Progress bars
          ...categories.asMap().entries.map((entry) {
            final i = entry.key;
            final c = entry.value;
            final name = c['category_name'] ?? 'N/A';
            final rev = _pInt(c['total_revenue']);
            final qty = _pInt(c['total_quantity']);
            final pct = totalRev > 0 ? (rev / totalRev * 100) : 0.0;
            final color = catColors[i % catColors.length];

            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            name,
                            style: GoogleFonts.dmSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: UiPalette.textDark,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '${pct.toStringAsFixed(1)}% • $qty sp',
                        style: GoogleFonts.dmSans(fontSize: 12, color: UiPalette.textMuted),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: pct / 100,
                      backgroundColor: color.withValues(alpha: 0.1),
                      color: color,
                      minHeight: 8,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      _currencyStr(rev),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: color,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodSection(List<dynamic> payments) {
    final paymentIcons = {
      'COD': Icons.local_shipping_outlined,
      'VNPAY': Icons.qr_code_2_rounded,
      'MOMO': Icons.account_balance_wallet_outlined,
      'BANK_TRANSFER': Icons.account_balance_outlined,
      'CREDIT_CARD': Icons.credit_card_outlined,
    };

    final paymentLabels = {
      'COD': 'Thanh toán khi nhận',
      'VNPAY': 'VNPay',
      'MOMO': 'MoMo',
      'BANK_TRANSFER': 'Chuyển khoản',
      'CREDIT_CARD': 'Thẻ tín dụng',
    };

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader('Phương thức thanh toán', onViewAll: () => _showPaymentDetail(payments)),
          const SizedBox(height: 16),
          ...payments.map((p) {
            final method = p['payment_method']?.toString() ?? 'OTHER';
            final orders = _pInt(p['order_count']);
            final rev = _pInt(p['total_revenue']);
            final icon = paymentIcons[method] ?? Icons.payment_outlined;
            final label = paymentLabels[method] ?? method;

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFB),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: UiPalette.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(icon, color: UiPalette.primary, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          style: GoogleFonts.dmSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: UiPalette.textDark,
                          ),
                        ),
                        Text(
                          '$orders đơn hàng',
                          style: GoogleFonts.dmSans(fontSize: 12, color: UiPalette.textMuted),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    _currencyStr(rev),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: UiPalette.primary,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildMonthlyTrendsSection(List<dynamic> monthly) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader('Xu hướng theo tháng', onViewAll: () => _showMonthlyDetail(monthly)),
          const SizedBox(height: 16),
          ...monthly.take(6).map((m) {
            final month = m['month']?.toString() ?? '';
            final orders = _pInt(m['order_count']);
            final rev = _pInt(m['revenue']);

            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFB),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDBEAFE),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        'T${month.split('-').last}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF2563EB),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tháng ${month.split('-').last}/${month.split('-').first}',
                          style: GoogleFonts.dmSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: UiPalette.textDark,
                          ),
                        ),
                        Text(
                          '$orders đơn hàng',
                          style: GoogleFonts.dmSans(fontSize: 12, color: UiPalette.textMuted),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    _currencyStr(rev),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF16A34A),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // --- Utility helpers ---
  int _pInt(dynamic val) {
    if (val == null) return 0;
    if (val is int) return val;
    if (val is double) return val.toInt();
    return double.tryParse(val.toString())?.toInt() ?? 0;
  }

  String _currencyStr(int value) {
    if (value == 0) return '₫0';
    final raw = value.toString();
    final b = StringBuffer();
    for (var i = 0; i < raw.length; i++) {
      final reverseIndex = raw.length - i;
      b.write(raw[i]);
      if (reverseIndex > 1 && reverseIndex % 3 == 1) b.write(',');
    }
    return '₫$b';
  }

  // --- Section Header with "Xem tất cả" button ---
  Widget _sectionHeader(String title, {VoidCallback? onViewAll}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: UiPalette.textDark,
          ),
        ),
        if (onViewAll != null)
          GestureDetector(
            onTap: onViewAll,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: UiPalette.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Xem tất cả',
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: UiPalette.primary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_forward_ios, size: 10, color: UiPalette.primary),
                ],
              ),
            ),
          ),
      ],
    );
  }

  // --- Bottom Sheet wrapper ---
  void _showDetailSheet({required String title, required Widget child}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Title
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: UiPalette.textDark,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(ctx),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F7),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.close, size: 18, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(height: 1, color: Colors.grey.withValues(alpha: 0.1)),
              // Content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(24),
                  child: child,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Detail: Revenue Overview ---
  void _showOverviewDetail(Map<String, dynamic> overview) {
    _showDetailSheet(
      title: 'Tổng quan doanh thu',
      child: Column(
        children: [
          _detailRow('Tổng tiền (Mọi trạng thái)', _currencyStr(_pInt(overview['total_revenue'])), Icons.attach_money, const Color(0xFF16A34A)),
          _detailRow('Doanh thu đã giao', _currencyStr(_pInt(overview['delivered_revenue'])), Icons.check_circle, const Color(0xFF2563EB)),
          _detailRow('Số đơn đã giao', '${_pInt(overview['delivered_count'])} đơn', Icons.local_shipping, const Color(0xFF2563EB)),
          _detailRow('Doanh thu đang xử lý', _currencyStr(_pInt(overview['pending_revenue'])), Icons.hourglass_bottom, const Color(0xFFD97706)),
          _detailRow('Doanh thu đã huỷ', _currencyStr(_pInt(overview['cancelled_revenue'])), Icons.cancel, const Color(0xFFDC2626)),
          _detailRow('Số đơn đã huỷ', '${_pInt(overview['cancelled_count'])} đơn', Icons.remove_circle, const Color(0xFFDC2626)),
          _detailRow('Tổng đơn hàng', '${_pInt(overview['total_orders'])} đơn', Icons.shopping_bag, const Color(0xFFD97706)),
          _detailRow('Giá trị TB/Đơn', _currencyStr(_pInt(overview['avg_order_value'])), Icons.analytics, const Color(0xFF7C3AED)),
        ],
      ),
    );
  }

  // --- Detail: Top Products ---
  void _showTopProductsDetail(List<dynamic> products) {
    _showDetailSheet(
      title: 'Tất cả sản phẩm bán chạy',
      child: Column(
        children: products.asMap().entries.map((entry) {
          final i = entry.key;
          final p = entry.value;
          final name = p['name'] ?? 'N/A';
          final totalSold = _pInt(p['total_sold']);
          final totalRev = _pInt(p['total_revenue']);
          final price = _pInt(p['price']);
          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFB),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: i < 3
                        ? [const Color(0xFFFFD700), const Color(0xFFC0C0C0), const Color(0xFFCD7F32)][i].withValues(alpha: 0.2)
                        : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      '${i + 1}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: i < 3
                            ? [const Color(0xFFFFD700), const Color(0xFFC0C0C0), const Color(0xFFCD7F32)][i]
                            : UiPalette.textMuted,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w600, color: UiPalette.textDark)),
                      const SizedBox(height: 2),
                      Text(
                        'Giá: ${_currencyStr(price)} • Đã bán: $totalSold',
                        style: GoogleFonts.dmSans(fontSize: 12, color: UiPalette.textMuted),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(_currencyStr(totalRev), style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w700, color: UiPalette.primary)),
                    Text('doanh thu', style: GoogleFonts.dmSans(fontSize: 10, color: UiPalette.textMuted)),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // --- Detail: Category Revenue ---
  void _showCategoryDetail(List<dynamic> categories) {
    double totalRev = 0;
    for (var c in categories) {
      totalRev += _pInt(c['total_revenue']).toDouble();
    }

    _showDetailSheet(
      title: 'Chi tiết theo danh mục',
      child: Column(
        children: categories.map((c) {
          final name = c['category_name'] ?? 'N/A';
          final rev = _pInt(c['total_revenue']);
          final qty = _pInt(c['total_quantity']);
          final orders = _pInt(c['order_count']);
          final pct = totalRev > 0 ? (rev / totalRev * 100) : 0.0;
          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFB),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(name, style: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w700, color: UiPalette.textDark)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: UiPalette.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text('${pct.toStringAsFixed(1)}%', style: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w700, color: UiPalette.primary)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _miniInfo(Icons.shopping_bag_outlined, '$orders đơn hàng'),
                    const SizedBox(width: 16),
                    _miniInfo(Icons.inventory_2_outlined, '$qty sản phẩm'),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Doanh thu', style: GoogleFonts.dmSans(fontSize: 12, color: UiPalette.textMuted)),
                    Text(_currencyStr(rev), style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w800, color: const Color(0xFF16A34A))),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // --- Detail: Payment Methods ---
  void _showPaymentDetail(List<dynamic> payments) {
    double totalRev = 0;
    for (var p in payments) {
      totalRev += _pInt(p['total_revenue']).toDouble();
    }

    final paymentLabels = {
      'COD': 'Thanh toán khi nhận',
      'VNPAY': 'VNPay',
      'MOMO': 'MoMo',
      'BANK_TRANSFER': 'Chuyển khoản',
      'CREDIT_CARD': 'Thẻ tín dụng',
    };

    _showDetailSheet(
      title: 'Chi tiết thanh toán',
      child: Column(
        children: [
          // Summary
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [UiPalette.primary.withValues(alpha: 0.1), UiPalette.primary.withValues(alpha: 0.02)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Tổng doanh thu', style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w600, color: UiPalette.textDark)),
                Text(_currencyStr(totalRev.toInt()), style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w800, color: UiPalette.primary)),
              ],
            ),
          ),
          ...payments.map((p) {
            final method = p['payment_method']?.toString() ?? 'OTHER';
            final orders = _pInt(p['order_count']);
            final rev = _pInt(p['total_revenue']);
            final label = paymentLabels[method] ?? method;
            final pct = totalRev > 0 ? (rev / totalRev * 100) : 0.0;
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFB),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(label, style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w700, color: UiPalette.textDark)),
                      Text('${pct.toStringAsFixed(1)}%', style: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w700, color: UiPalette.primary)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(value: pct / 100, backgroundColor: const Color(0xFFE2E8F0), color: UiPalette.primary, minHeight: 6),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('$orders đơn hàng', style: GoogleFonts.dmSans(fontSize: 12, color: UiPalette.textMuted)),
                      Text(_currencyStr(rev), style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w700, color: const Color(0xFF16A34A))),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // --- Detail: Monthly Trends ---
  void _showMonthlyDetail(List<dynamic> monthly) {
    _showDetailSheet(
      title: 'Chi tiết theo tháng',
      child: Column(
        children: monthly.map((m) {
          final month = m['month']?.toString() ?? '';
          final orders = _pInt(m['order_count']);
          final rev = _pInt(m['revenue']);
          final parts = month.split('-');
          final displayMonth = parts.length == 2 ? 'Tháng ${parts[1]}/${parts[0]}' : month;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFB),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDBEAFE),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      parts.length == 2 ? 'T${parts[1]}' : '?',
                      style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w800, color: const Color(0xFF2563EB)),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(displayMonth, style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w600, color: UiPalette.textDark)),
                      Text('$orders đơn hàng', style: GoogleFonts.dmSans(fontSize: 12, color: UiPalette.textMuted)),
                    ],
                  ),
                ),
                Text(_currencyStr(rev), style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w700, color: const Color(0xFF16A34A))),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // --- Reusable detail row ---
  Widget _detailRow(String label, String value, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFB),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(label, style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w600, color: UiPalette.textDark)),
          ),
          Text(value, style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w700, color: color)),
        ],
      ),
    );
  }

  Widget _miniInfo(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: UiPalette.textMuted),
        const SizedBox(width: 4),
        Text(text, style: GoogleFonts.dmSans(fontSize: 12, color: UiPalette.textMuted)),
      ],
    );
  }
}
