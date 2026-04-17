# Debug Guide - DacSanVietManager

## Vấn đề: Logcat chạy liên tục, không load được sản phẩm

### Các bước debug:

#### 1. Clean build
```bash
cd DacSanVietManager
flutter clean
flutter pub get
```

#### 2. Kiểm tra Backend đang chạy
```bash
# Kiểm tra backend
curl http://localhost:3001/api/products

# Nếu thành công, sẽ thấy JSON response với danh sách sản phẩm
```

#### 3. Chạy app với verbose logs
```bash
flutter run -v
```

#### 4. Xem Flutter logs (không phải logcat)
Trong terminal chạy `flutter run`, tìm các dòng:
- `🔐 Attempting login...`
- `✅ Login successful, loading data...`
- `Loading products...`
- `✅ Loaded X products`
- `Loading orders...`
- `✅ Loaded X orders`
- `✅ All data loaded successfully`

#### 5. Nếu thấy lỗi "Network error"
Kiểm tra API URL trong `lib/domain/api_config.dart`:
```dart
// Android Emulator
static const String baseUrl = 'http://10.0.2.2:3001';

// iOS Simulator
// static const String baseUrl = 'http://localhost:3001';

// Real Device (thay IP máy tính của bạn)
// static const String baseUrl = 'http://192.168.1.100:3001';
```

#### 6. Test API trực tiếp từ emulator
```bash
# Vào emulator terminal hoặc dùng adb
adb shell

# Test kết nối
curl http://10.0.2.2:3001/api/products
```

#### 7. Kiểm tra response format
Backend trả về:
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "name": "Sản phẩm",
      "price": 100000,
      ...
    }
  ],
  "pagination": {
    "totalItems": 12
  }
}
```

App đang parse:
```dart
final productsData = response.data is List 
    ? response.data as List
    : (response.data!['data'] ?? []) as List;
```

#### 8. Nếu vẫn không load được

**Option A: Dùng dữ liệu tĩnh tạm thời**
Uncomment dữ liệu tĩnh trong AppController để test UI trước:
```dart
// Thêm vào cuối login() method
if (_products.isEmpty) {
  _products = [
    Product(id: '1', name: 'Test Product', category: 'Test', price: 100000, stock: 10),
  ];
}
```

**Option B: Kiểm tra CORS**
Backend có thể block request từ emulator. Kiểm tra backend logs.

**Option C: Tăng timeout**
Trong `api_config.dart`:
```dart
static const Duration connectionTimeout = Duration(seconds: 60);
```

#### 9. Hot Restart
Sau khi sửa code, nhấn `R` (capital R) trong terminal để hot restart:
```
r - Hot reload
R - Hot restart
q - Quit
```

#### 10. Kiểm tra Flutter Doctor
```bash
flutter doctor -v
```

## Common Issues

### Issue 1: "Could not get dex checksums"
**Solution:** 
```bash
flutter clean
flutter pub get
flutter run
```

### Issue 2: "Network error: ClientException"
**Solution:** Kiểm tra:
- Backend đang chạy
- URL đúng (10.0.2.2 cho Android emulator)
- Firewall không block port 3001

### Issue 3: "Failed to parse response"
**Solution:** 
- Xem backend logs
- Kiểm tra response format
- Thêm try-catch và print response

### Issue 4: App trắng xóa
**Solution:**
- Kiểm tra `isLoading` state
- Kiểm tra `isAuthenticated` state
- Xem Flutter logs

### Issue 5: Infinite loop / Logcat spam
**Solution:**
- Đã fix: Removed `notifyListeners()` from `loadProducts()` và `loadOrders()`
- Chỉ gọi `notifyListeners()` trong `login()` sau khi load xong

## Debug Checklist

- [ ] Backend đang chạy tại port 3001
- [ ] `flutter clean` đã chạy
- [ ] API URL đúng (10.0.2.2 cho Android)
- [ ] Có thể curl được API từ terminal
- [ ] Flutter logs hiển thị "Loading products..."
- [ ] Flutter logs hiển thị "✅ Loaded X products"
- [ ] Không có error trong Flutter logs
- [ ] App không ở trạng thái loading vô hạn

## Test Commands

```bash
# Test backend
curl http://localhost:3001/api/products

# Test từ emulator perspective
curl http://10.0.2.2:3001/api/products

# Clean và rebuild
flutter clean && flutter pub get && flutter run

# Run với verbose
flutter run -v

# Hot restart trong app
# Nhấn 'R' trong terminal
```

## Expected Console Output

```
🔐 Attempting login...
✅ Login successful, loading data...
Loading products...
✅ Loaded 12 products
Loading orders...
✅ Loaded 4 orders
✅ All data loaded successfully
```

## Nếu vẫn không được

1. Chụp màn hình Flutter logs (không phải logcat)
2. Chụp màn hình backend logs
3. Chụp màn hình app UI
4. Share để debug tiếp
