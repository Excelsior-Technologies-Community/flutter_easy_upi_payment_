enum UpiPaymentStatus {
  success,
  submitted,
  failed,
  cancelled,
  unknown,
}

class UpiPaymentResponse {
  final UpiPaymentStatus status;
  final String? transactionId;
  final String? responseCode;
  final String? approvalReference;
  final String? rawResponse;
  final String message;

  const UpiPaymentResponse({
    required this.status,
    required this.message,
    this.transactionId,
    this.responseCode,
    this.approvalReference,
    this.rawResponse,
  });

  bool get isSuccess => status == UpiPaymentStatus.success;

  bool get isFailed => status == UpiPaymentStatus.failed;

  bool get isCancelled => status == UpiPaymentStatus.cancelled;

  factory UpiPaymentResponse.fromRawResponse(
      String response, {
        String? transactionId,
      }) {
    final data = <String, String>{};

    for (final part in response.split('&')) {
      final index = part.indexOf('=');

      if (index <= 0) continue;

      final key = Uri.decodeComponent(part.substring(0, index)).toLowerCase();
      final value = Uri.decodeComponent(part.substring(index + 1));

      data[key] = value;
    }

    final statusValue = (data['status'] ?? '').toLowerCase();

    final status = switch (statusValue) {
      'success' => UpiPaymentStatus.success,
      'submitted' => UpiPaymentStatus.submitted,
      'failure' || 'failed' => UpiPaymentStatus.failed,
      'cancelled' || 'canceled' => UpiPaymentStatus.cancelled,
      _ => UpiPaymentStatus.unknown,
    };

    return UpiPaymentResponse(
      status: status,
      transactionId: data['txnref'] ?? transactionId,
      responseCode: data['responsecode'],
      approvalReference: data['approvalrefno'],
      rawResponse: response,
      message: _messageForStatus(status),
    );
  }

  static String _messageForStatus(UpiPaymentStatus status) {
    switch (status) {
      case UpiPaymentStatus.success:
        return 'Payment successful';
      case UpiPaymentStatus.submitted:
        return 'Payment submitted';
      case UpiPaymentStatus.failed:
        return 'Payment failed';
      case UpiPaymentStatus.cancelled:
        return 'Payment cancelled';
      case UpiPaymentStatus.unknown:
        return 'Payment status could not be determined';
    }
  }
}