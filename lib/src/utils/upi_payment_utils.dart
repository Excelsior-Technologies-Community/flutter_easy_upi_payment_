import 'dart:convert';

import '../models/upi_payment_config.dart';

class UpiPaymentUtils {
  const UpiPaymentUtils._();

  static String buildUpiUri(UpiPaymentConfig config) {
    final query = config.toMap().entries
        .map(
          (entry) =>
      '${Uri.encodeQueryComponent(entry.key)}=${Uri.encodeQueryComponent(entry.value)}',
    )
        .join('&');

    return 'upi://pay?$query';
  }

  static String buildAppSpecificUri(UpiPaymentConfig config) {
    return buildUpiUri(config);
  }

  static String encodeBase64(String value) {
    return base64Encode(utf8.encode(value));
  }

  static bool isValidVpa(String vpa) {
    final regex = RegExp(r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9._-]+$');
    return regex.hasMatch(vpa.trim());
  }

  static bool isValidAmount(double amount) {
    return amount > 0 && amount.isFinite;
  }
}