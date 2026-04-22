class ParseUtils {
  static int parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) {
      // Remove commas if any (common in price strings)
      final cleanString = value.replaceAll(',', '').trim();
      return int.tryParse(cleanString) ?? (double.tryParse(cleanString)?.toInt() ?? 0);
    }
    return 0;
  }

  static double parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is num) return value.toDouble();
    if (value is String) {
      final cleanString = value.replaceAll(',', '').trim();
      return double.tryParse(cleanString) ?? 0.0;
    }
    return 0.0;
  }

  static String formatPrice(dynamic value) {
    final price = parseInt(value);
    final String priceStr = price.toString();
    final StringBuffer buffer = StringBuffer();
    
    for (int i = 0; i < priceStr.length; i++) {
      int reverseIndex = priceStr.length - i;
      buffer.write(priceStr[i]);
      if (reverseIndex > 1 && reverseIndex % 3 == 1) {
        buffer.write('.');
      }
    }
    
    return buffer.toString();
  }
}
