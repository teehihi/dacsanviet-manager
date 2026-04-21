/// Model đơn vị vận chuyển – chuẩn hóa, sẵn sàng cho API sau này.
class ShippingProvider {
  final String id;
  final String name;

  /// Đường dẫn asset logo (local). Null = dùng fallback icon.
  final String? logoAsset;

  /// Thời gian giao dự kiến, VD: "1–2 ngày"
  final String estimatedTime;

  /// Phí ship (VNĐ)
  final int fee;

  /// Có thể mở rộng: url logo từ API, rating, note...
  const ShippingProvider({
    required this.id,
    required this.name,
    this.logoAsset,
    required this.estimatedTime,
    required this.fee,
  });

  /// Factory để parse từ API JSON sau này
  factory ShippingProvider.fromJson(Map<String, dynamic> json) {
    return ShippingProvider(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      logoAsset: json['logo_asset'],
      estimatedTime: json['estimated_time'] ?? '',
      fee: (json['fee'] ?? 0) is int
          ? json['fee']
          : int.tryParse(json['fee'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'logo_asset': logoAsset,
        'estimated_time': estimatedTime,
        'fee': fee,
      };
}

/// Danh sách đơn vị vận chuyển mặc định (hardcode, có thể thay bằng API).
/// Logo path phải khớp với khai báo trong pubspec.yaml.
const kDefaultShippingProviders = <ShippingProvider>[
  ShippingProvider(
    id: 'ghn',
    name: 'Giao Hàng Nhanh',
    logoAsset: 'assets/shipping_logos/ghn.png',
    estimatedTime: '1–2 ngày',
    fee: 22000,
  ),
  ShippingProvider(
    id: 'jt',
    name: 'J&T Express',
    logoAsset: 'assets/shipping_logos/jt.png',
    estimatedTime: '2–3 ngày',
    fee: 18000,
  ),
  ShippingProvider(
    id: 'viettel',
    name: 'Viettel Post',
    logoAsset: 'assets/shipping_logos/viettel-post.png',
    estimatedTime: '2–4 ngày',
    fee: 15000,
  ),
  ShippingProvider(
    id: 'ghtk',
    name: 'Giao Hàng Tiết Kiệm',
    logoAsset: 'assets/shipping_logos/ghtk.png',
    estimatedTime: '3–5 ngày',
    fee: 12000,
  ),
  ShippingProvider(
    id: 'vnpost',
    name: 'VN Post',
    logoAsset: 'assets/shipping_logos/vnpost.png',
    estimatedTime: '3–7 ngày',
    fee: 10000,
  ),
];
