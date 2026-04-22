/// API Configuration for DacSanViet Backend
class ApiConfig {
  // Base URL - Change this to your backend server address
  // For Android Emulator: use 10.0.2.2 instead of localhost
  // For iOS Simulator: use localhost
  // For Real Device: use your computer's IP address (e.g., 192.168.1.100)
  static const String baseUrl = 'http://10.0.2.2:3001';

  // Alternative URLs (uncomment the one you need):
  // static const String baseUrl = 'http://localhost:3001'; // iOS Simulator
  // static const String baseUrl = 'http://192.168.1.100:3001'; // Real Device

  // API Endpoints
  static const String apiPrefix = '/api';

  // Auth endpoints
  static const String authLogin = '$apiPrefix/auth/login';
  static const String authRegister = '$apiPrefix/auth/register';
  static const String authLogout = '$apiPrefix/auth/logout';
  static const String authCheckSession = '$apiPrefix/auth/check-session';

  // Admin endpoints
  static const String adminProducts = '$apiPrefix/admin/products';
  static const String adminCoupons = '$apiPrefix/admin/coupons';
  static const String adminRevenue = '$apiPrefix/admin/revenue';
  static const String adminUsers = '$apiPrefix/admin/users';
  static const String adminOrders = '$apiPrefix/admin/orders';
  static const String adminAiChat = '$apiPrefix/admin/ai/chat';

  // Products endpoints
  static const String products = '$apiPrefix/products';

  // Orders endpoints
  static const String orders = '$apiPrefix/orders';

  // Users endpoints
  static const String users = '$apiPrefix/users';

  // Reviews endpoints
  static const String reviews = '$apiPrefix/reviews';

  // Coupons endpoints
  static const String coupons = '$apiPrefix/coupons';

  // Notifications endpoints
  static const String notifications = '$apiPrefix/notifications';

  // Categories endpoints
  static const String categories = '$apiPrefix/categories';
  static const String adminCategories = '$apiPrefix/categories';

  // Timeout settings
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Headers
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Map<String, String> getAuthHeaders(String sessionId) {
    return {...defaultHeaders, 'Authorization': 'Bearer $sessionId'};
  }
}
