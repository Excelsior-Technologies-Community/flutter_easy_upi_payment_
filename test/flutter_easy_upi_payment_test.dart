import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_easy_upi_payment/flutter_easy_upi_payment.dart';

void main() {
  group('UpiPaymentUtils', () {
    test('validates UPI ID correctly', () {
      expect(
        UpiPaymentUtils.isValidVpa('user@upi'),
        isTrue,
      );

      expect(
        UpiPaymentUtils.isValidVpa('invalid-upi'),
        isFalse,
      );
    });

    test('validates payment amount correctly', () {
      expect(
        UpiPaymentUtils.isValidAmount(10),
        isTrue,
      );

      expect(
        UpiPaymentUtils.isValidAmount(0),
        isFalse,
      );

      expect(
        UpiPaymentUtils.isValidAmount(-10),
        isFalse,
      );
    });

    test('builds UPI URI correctly', () {
      const config = UpiPaymentConfig(
        payeeVpa: 'merchant@upi',
        payeeName: 'Test Merchant',
        amount: 100,
        transactionId: 'TXN123',
        transactionNote: 'Test Payment',
      );

      final uri = UpiPaymentUtils.buildUpiUri(config);

      expect(uri.startsWith('upi://pay?'), isTrue);
      expect(uri.contains('merchant%40upi'), isTrue);
      expect(uri.contains('100.00'), isTrue);
      expect(uri.contains('TXN123'), isTrue);
    });
  });

  group('UpiPaymentResponse', () {
    test('parses successful response', () {
      const rawResponse =
          'Status=SUCCESS&txnRef=TXN123&responseCode=00';

      final response =
      UpiPaymentResponse.fromRawResponse(
        rawResponse,
        transactionId: 'TXN123',
      );

      expect(
        response.status,
        UpiPaymentStatus.success,
      );

      expect(
        response.transactionId,
        'TXN123',
      );
    });

    test('parses failed response', () {
      const rawResponse =
          'Status=FAILURE&txnRef=TXN456';

      final response =
      UpiPaymentResponse.fromRawResponse(
        rawResponse,
        transactionId: 'TXN456',
      );

      expect(
        response.status,
        UpiPaymentStatus.failed,
      );
    });
  });
}