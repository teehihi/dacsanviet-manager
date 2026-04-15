## dacsanviet-manager

Flutter Admin/Manager UI cho dự án **DacSanViet**.

### Chạy dự án

```bash
flutter pub get
flutter run
```

### Đã implement theo Figma (pixel mapping)

- **Splash**: `38:6341`
- **Login**: `38:6284`
- **Home**: `1:339`
- **BottomNav**: `9:2515` (custom nav theo Figma)

### Tồn đọng / Known issues

- **Hot restart có thể báo thiếu asset** nếu trước đó app đã build với tên asset cũ (`.png` → `.svg`/`.jpg`).
  - Cách xử lý: `flutter clean && flutter pub get`, stop app và chạy lại `flutter run`.
- **Các icon từ Figma là SVG**: dự án dùng `flutter_svg` để render. Nếu xoá dependency/đổi path sẽ lỗi `invalid image data`.
- **Các tab còn lại (Sản phẩm/Đơn hàng/Thống kê/Cá nhân)** hiện mới ở mức “app chạy thật + dữ liệu mock”, chưa map pixel-perfect theo các node Figma tương ứng.
- **Biểu đồ**: hiện dùng placeholder (không phải chart library) để giữ layout theo thiết kế.

# dac_san_viet_manager

Dac San Viet Manager App for Admin

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
