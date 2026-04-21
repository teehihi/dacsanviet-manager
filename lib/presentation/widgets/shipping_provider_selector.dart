import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../domain/models/shipping_provider.dart';
import '../theme/ui_palette.dart';
import 'shipping_provider_card.dart';

/// Widget selector danh sách đơn vị vận chuyển dạng card.
/// Quản lý state selected internally, gọi [onChanged] khi user chọn.
class ShippingProviderSelector extends StatefulWidget {
  const ShippingProviderSelector({
    super.key,
    required this.providers,
    this.initialSelected,
    required this.onChanged,
  });

  final List<ShippingProvider> providers;
  final ShippingProvider? initialSelected;
  final ValueChanged<ShippingProvider> onChanged;

  @override
  State<ShippingProviderSelector> createState() =>
      _ShippingProviderSelectorState();
}

class _ShippingProviderSelectorState extends State<ShippingProviderSelector> {
  late ShippingProvider _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialSelected ?? widget.providers.first;
  }

  void _select(ShippingProvider provider) {
    if (_selected.id == provider.id) return;
    setState(() => _selected = provider);
    widget.onChanged(provider);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < widget.providers.length; i++)
          ShippingProviderCard(
            provider: widget.providers[i],
            isSelected: _selected.id == widget.providers[i].id,
            onTap: () => _select(widget.providers[i]),
          )
              .animate(delay: Duration(milliseconds: 40 * i))
              .fadeIn(duration: 200.ms)
              .slideY(begin: 0.15, end: 0, duration: 220.ms, curve: Curves.easeOut),
      ],
    );
  }
}

/// Hàm tiện ích: mở bottom sheet chọn đơn vị vận chuyển.
/// Trả về [ShippingProvider] được chọn, hoặc null nếu user cancel.
///
/// Ví dụ:
/// ```dart
/// final provider = await showShippingProviderSheet(context);
/// if (provider != null) confirmOrder(id, carrier: provider.name);
/// ```
Future<ShippingProvider?> showShippingProviderSheet(
  BuildContext context, {
  List<ShippingProvider> providers = kDefaultShippingProviders,
  ShippingProvider? initialSelected,
}) {
  ShippingProvider current = initialSelected ?? providers.first;

  return showModalBottomSheet<ShippingProvider>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => _ShippingProviderSheet(
      providers: providers,
      initialSelected: current,
      onConfirm: (provider) => Navigator.pop(ctx, provider),
      onCancel: () => Navigator.pop(ctx),
    ),
  );
}

// ─── Private bottom sheet widget ───────────────────────────────────────────

class _ShippingProviderSheet extends StatefulWidget {
  const _ShippingProviderSheet({
    required this.providers,
    required this.initialSelected,
    required this.onConfirm,
    required this.onCancel,
  });

  final List<ShippingProvider> providers;
  final ShippingProvider initialSelected;
  final ValueChanged<ShippingProvider> onConfirm;
  final VoidCallback onCancel;

  @override
  State<_ShippingProviderSheet> createState() => _ShippingProviderSheetState();
}

class _ShippingProviderSheetState extends State<_ShippingProviderSheet> {
  late ShippingProvider _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialSelected;
  }


  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).viewInsets.bottom +
        MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Drag handle ────────────────────────────────────
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 4),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFDDDDDD),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // ── Header ────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: UiPalette.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.local_shipping_rounded,
                    color: UiPalette.primary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Chọn đơn vị vận chuyển',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: UiPalette.textPrimary,
                        ),
                      ),
                      Text(
                        'Chọn đơn vị phù hợp với đơn hàng',
                        style: GoogleFonts.dmSans(
                          fontSize: 12,
                          color: UiPalette.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: widget.onCancel,
                  icon: const Icon(Icons.close_rounded),
                  color: UiPalette.textSecondary,
                  iconSize: 20,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          const Divider(height: 1, indent: 24, endIndent: 24),
          const SizedBox(height: 16),

          // ── Provider list (scrollable) ─────────────────────
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.45,
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ShippingProviderSelector(
                providers: widget.providers,
                initialSelected: widget.initialSelected,
                onChanged: (p) => setState(() => _selected = p),
              ),
            ),
          ),

          const SizedBox(height: 8),
          const Divider(height: 1),

          // ── CTA ───────────────────────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(20, 14, 20, 14 + bottomPad),
            child: SizedBox(
              width: double.infinity,
              height: 54,
              child: FilledButton(
                onPressed: () => widget.onConfirm(_selected),
                style: FilledButton.styleFrom(
                  backgroundColor: UiPalette.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.local_shipping_rounded,
                      size: 18,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Xác nhận & Giao hàng',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .slideY(begin: 0.2, end: 0, duration: 300.ms, curve: Curves.easeOutCubic)
        .fadeIn(duration: 250.ms);
  }
}
