import 'package:flutter/services.dart';

import '../models/upi_app.dart';
import '../models/upi_payment_config.dart';
import '../models/upi_payment_response.dart';
import 'upi_payment_utils.dart';

class UpiPaymentLauncher {
  static const MethodChannel _channel =
  MethodChannel('flutter_easy_upi_payment');

  const UpiPaymentLauncher._();

  static Future<UpiPaymentResponse> launch(
      UpiPaymentConfig config,
      ) async {
    if (!UpiPaymentUtils.isValidVpa(config.payeeVpa)) {
      return const UpiPaymentResponse(
        status: UpiPaymentStatus.failed,
        message: 'Invalid UPI ID',
      );
    }

    if (!UpiPaymentUtils.isValidAmount(config.amount)) {
      return const UpiPaymentResponse(
        status: UpiPaymentStatus.failed,
        message: 'Invalid payment amount',
      );
    }

    try {
      final result = await _channel.invokeMethod<String>(
        'launchUpiPayment',
        {
          'upiUri': UpiPaymentUtils.buildUpiUri(config),
          'packageName': config.preferredApp?.packageName,
        },
      );

      if (result == null || result.trim().isEmpty) {
        return const UpiPaymentResponse(
          status: UpiPaymentStatus.unknown,
          message: 'No response received from UPI application',
        );
      }

      return UpiPaymentResponse.fromRawResponse(
        result,
        transactionId: config.transactionId,
      );
    } on PlatformException catch (error) {
      return UpiPaymentResponse(
        status: UpiPaymentStatus.failed,
        transactionId: config.transactionId,
        message: error.message ?? 'Unable to start UPI payment',
      );
    } catch (error) {
      return UpiPaymentResponse(
        status: UpiPaymentStatus.failed,
        transactionId: config.transactionId,
        message: error.toString(),
      );
    }
  }
}