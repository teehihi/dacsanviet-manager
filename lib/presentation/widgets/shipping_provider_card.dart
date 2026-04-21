import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/models/shipping_provider.dart';
import '../theme/ui_palette.dart';

/// Card UI cho 1 đơn vị vận chuyển – selectable, có logo, fee, ETA.
class ShippingProviderCard extends StatefulWidget {
  const ShippingProviderCard({
    super.key,
    required this.provider,
    required this.isSelected,
    required this.onTap,
  });

  final ShippingProvider provider;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<ShippingProviderCard> createState() => _ShippingProviderCardState();
}

class _ShippingProviderCardState extends State<ShippingProviderCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.97,
      upperBound: 1.0,
      value: 1.0,
    );
    _scaleAnimation = _scaleController;
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails _) => _scaleController.reverse();
  void _handleTapUp(TapUpDetails _) {
    _scaleController.forward();
    widget.onTap();
  }

  void _handleTapCancel() => _scaleController.forward();

  String _formatFee(int fee) {
    if (fee == 0) return 'Miễn phí';
    final formatted = fee.toString().replaceAllMapped(
          RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (m) => '.',
        );
    return '$formatted đ';
  }

  @override
  Widget build(BuildContext context) {
    final isSelected = widget.isSelected;

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? UiPalette.primary.withValues(alpha: 0.06)
                : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? UiPalette.primary : const Color(0xFFE8E8E8),
              width: isSelected ? 2.0 : 1.0,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: UiPalette.primary.withValues(alpha: 0.12),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Row(
            children: [
              // ── Logo ─────────────────────────────────────────
              _LogoBadge(
                logoAsset: widget.provider.logoAsset,
                isSelected: isSelected,
              ),
              const SizedBox(width: 14),

              // ── Info ─────────────────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.provider.name,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: UiPalette.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.schedule_rounded,
                          size: 12,
                          color: UiPalette.textSecondary,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          widget.provider.estimatedTime,
                          style: GoogleFonts.dmSans(
                            fontSize: 12,
                            color: UiPalette.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // ── Fee + Check ───────────────────────────────────
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: isSelected
                        ? Container(
                            key: const ValueKey('check'),
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              color: UiPalette.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 14,
                            ),
                          )
                        : const SizedBox(
                            key: ValueKey('empty'),
                            width: 22,
                            height: 22,
                          ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _formatFee(widget.provider.fee),
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: widget.provider.fee == 0
                          ? UiPalette.primary
                          : UiPalette.textPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Logo badge với fallback về icon nếu asset lỗi
class _LogoBadge extends StatelessWidget {
  const _LogoBadge({required this.logoAsset, required this.isSelected});

  final String? logoAsset;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : const Color(0xFFF5F5F7),
        borderRadius: BorderRadius.circular(12),
        border: isSelected
            ? Border.all(color: UiPalette.primary.withValues(alpha: 0.3), width: 1.5)
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: logoAsset != null
            ? Padding(
                padding: const EdgeInsets.all(6),
                child: Image.asset(
                  logoAsset!,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => _fallbackIcon(),
                ),
              )
            : _fallbackIcon(),
      ),
    );
  }

  Widget _fallbackIcon() {
    return Center(
      child: Icon(
        Icons.local_shipping_rounded,
        color: UiPalette.primary,
        size: 28,
      ),
    );
  }
}
