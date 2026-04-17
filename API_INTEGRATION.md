# API Integration Guide - DacSanVietManager

## Tổng quan

DacSanVietManager đã được tích hợp với Backend API từ `GroupAPI_JWT_OTP`. Tài liệu này hướng dẫn cách sử dụng các service đã được tạo.

## Cấu trúc API

```
lib/domain/
├── api_config.dart          # Cấu hình API endpoints và base URL
├── api_response.dart        # Generic response wrapper
├── api_service.dart         # Base HTTP service
└── services/
    ├── auth_service.dart    # Authentication service
    ├── product_service.dart # Product management
    ├── order_service.dart   # Order management
    ├── revenue_service.dart # Revenue statistics
    └── user_service.dart    # User management
```

## Cấu hình Backend

### 1. Cập nhật Base URL

Mở file `lib/domain/api_config.dart` và cập nhật `baseUrl`:

```dart
class ApiConfig {
  // Thay đổi URL này theo địa chỉ backend của bạn
  static const String baseUrl = 'http://localhost:3001';
  
  // Hoặc nếu chạy trên thiết bị thật:
  // static const String baseUrl = 'http://192.168.1.100:3001';
}
```

### 2. Khởi động Backend

```bash
cd DacSanVietBackend
npm install
npm start
```

Backend sẽ chạy tại `http://localhost:3001`

## Sử dụng Services

### Authentication Service

```dart
import 'package:dac_san_viet_manager/domain/services/auth_service.dart';

// Đăng nhập
final response = await AuthService.login(
  email: 'admin@dacsanviet.com',
  password: 'admin123',
);

if (response.success) {
  final user = response.data!['user'];
  final sessionId = response.data!['sessionId'];
  print('Logged in as: ${user['email']}');
}

// Đăng xuất
await AuthService.logout();

// Kiểm tra session
final sessionCheck = await AuthService.checkSession();
```

### Product Service

```dart
import 'package:dac_san_viet_manager/domain/services/product_service.dart';

// Lấy danh sách sản phẩm
final response = await ProductService.getProducts(
  page: 1,
  limit: 20,
  search: 'bánh',
  category: 'Bánh kẹo',
);

if (response.success) {
  final products = response.data!['products'];
  final total = response.data!['total'];
  print('Found $total products');
}

// Tạo sản phẩm mới
final createResponse = await ProductService.createProduct(
  name: 'Bánh đậu xanh Hải Dương',
  description: 'Bánh đậu xanh truyền thống',
  price: 150000,
  stock: 100,
  category: 'Bánh kẹo',
  imageUrl: 'https://example.com/image.jpg',
  discount: 10.0,
);

// Cập nhật sản phẩm
await ProductService.updateProduct(
  id: 1,
  name: 'Bánh đậu xanh Hải Dương (Mới)',
  price: 160000,
);

// Xóa sản phẩm
await ProductService.deleteProduct(1);

// Thống kê sản phẩm
final stats = await ProductService.getProductStats();
```

### Order Service

```dart
import 'package:dac_san_viet_manager/domain/services/order_service.dart';

// Lấy danh sách đơn hàng
final response = await OrderService.getOrders(
  page: 1,
  limit: 20,
  status: 'NEW',
);

// Lấy chi tiết đơn hàng
final orderDetail = await OrderService.getOrderById('ORD-123456');

// Cập nhật trạng thái đơn hàng
await OrderService.updateOrderStatus(
  orderId: 'ORD-123456',
  status: 'CONFIRMED',
);

// Hủy đơn hàng
await OrderService.cancelOrder('ORD-123456');

// Thống kê đơn hàng
final stats = await OrderService.getOrderStats();
```

### Revenue Service

```dart
import 'package:dac_san_viet_manager/domain/services/revenue_service.dart';

// Thống kê doanh thu
final response = await RevenueService.getRevenueStats(
  startDate: '2026-01-01',
  endDate: '2026-12-31',
  period: 'month',
);

// Doanh thu theo ngày
final daily = await RevenueService.getDailyRevenue();

// Doanh thu theo tháng
final monthly = await RevenueService.getMonthlyRevenue();

// Doanh thu theo năm
final yearly = await RevenueService.getYearlyRevenue();

// Top sản phẩm bán chạy
final topProducts = await RevenueService.getTopProducts(limit: 10);
```

### User Service

```dart
import 'package:dac_san_viet_manager/domain/services/user_service.dart';

// Lấy danh sách người dùng
final response = await UserService.getUsers(
  page: 1,
  limit: 20,
  search: 'nguyen',
  role: 'USER',
);

// Lấy thông tin người dùng
final user = await UserService.getUserById(1);

// Cập nhật người dùng
await UserService.updateUser(
  id: 1,
  fullName: 'Nguyễn Văn A',
  phoneNumber: '0123456789',
);

// Xóa người dùng
await UserService.deleteUser(1);

// Kích hoạt/vô hiệu hóa người dùng
await UserService.toggleUserStatus(1);

// Thống kê người dùng
final stats = await UserService.getUserStats();
```

## Xử lý Response

Tất cả các service đều trả về `ApiResponse<T>`:

```dart
final response = await ProductService.getProducts();

if (response.success) {
  // Thành công
  final data = response.data;
  print('Success: ${response.message}');
} else {
  // Thất bại
  print('Error: ${response.message}');
  print('Details: ${response.error}');
}
```

## Xử lý Authentication

Session ID được tự động lưu sau khi đăng nhập và được gửi kèm trong mọi request:

```dart
// Đăng nhập - session ID được lưu tự động
await AuthService.login(
  email: 'admin@dacsanviet.com',
  password: 'admin123',
);

// Các request tiếp theo sẽ tự động gửi kèm session ID
await ProductService.getProducts();

// Đăng xuất - session ID được xóa
await AuthService.logout();
```

## Tài khoản Admin mặc định

```
Email: admin@dacsanviet.com
Password: admin123
```

## API Endpoints

### Authentication
- `POST /api/auth/login` - Đăng nhập
- `POST /api/auth/register` - Đăng ký
- `POST /api/auth/logout` - Đăng xuất
- `POST /api/auth/check-session` - Kiểm tra session

### Admin Products
- `GET /api/admin/products` - Danh sách sản phẩm
- `GET /api/admin/products/:id` - Chi tiết sản phẩm
- `POST /api/admin/products` - Tạo sản phẩm
- `PUT /api/admin/products/:id` - Cập nhật sản phẩm
- `DELETE /api/admin/products/:id` - Xóa sản phẩm

### Admin Orders
- `GET /api/orders` - Danh sách đơn hàng
- `GET /api/orders/:id` - Chi tiết đơn hàng
- `PUT /api/orders/:id/status` - Cập nhật trạng thái

### Admin Revenue
- `GET /api/admin/revenue` - Thống kê doanh thu
- `GET /api/admin/revenue/daily` - Doanh thu theo ngày
- `GET /api/admin/revenue/monthly` - Doanh thu theo tháng
- `GET /api/admin/revenue/yearly` - Doanh thu theo năm

### Admin Users
- `GET /api/admin/users` - Danh sách người dùng
- `GET /api/users/:id` - Chi tiết người dùng
- `PUT /api/users/:id` - Cập nhật người dùng
- `DELETE /api/users/:id` - Xóa người dùng

## Lưu ý

1. **CORS**: Backend đã được cấu hình CORS cho phép tất cả origins
2. **Timeout**: Mặc định timeout là 30 giây
3. **Error Handling**: Luôn kiểm tra `response.success` trước khi sử dụng data
4. **Session Management**: Session ID được quản lý tự động
5. **Network**: Đảm bảo backend đang chạy và có thể truy cập được

## Chạy ứng dụng

```bash
cd DacSanVietManager
flutter pub get
flutter run
```

## Troubleshooting

### Lỗi kết nối
- Kiểm tra backend đang chạy: `http://localhost:3001`
- Kiểm tra base URL trong `api_config.dart`
- Nếu chạy trên thiết bị thật, dùng IP máy tính thay vì localhost

### Lỗi authentication
- Kiểm tra tài khoản admin đã được tạo trong database
- Kiểm tra session ID được lưu sau khi login

### Lỗi CORS
- Backend đã cấu hình CORS, không cần thay đổi gì
