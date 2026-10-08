import 'upi_app.dart';

class UpiPaymentConfig {
  final String payeeVpa;
  final String payeeName;
  final double amount;
  final String transactionId;
  final String transactionNote;
  final String currency;
  final UpiApp? preferredApp;

  const UpiPaymentConfig({
    required this.payeeVpa,
    required this.payeeName,
    required this.amount,
    required this.transactionId,
    this.transactionNote = 'UPI Payment',
    this.currency = 'INR',
    this.preferredApp,
  });

  UpiPaymentConfig copyWith({
    String? payeeVpa,
    String? payeeName,
    double? amount,
    String? transactionId,
    String? transactionNote,
    String? currency,
    UpiApp? preferredApp,
  }) {
    return UpiPaymentConfig(
      payeeVpa: payeeVpa ?? this.payeeVpa,
      payeeName: payeeName ?? this.payeeName,
      amount: amount ?? this.amount,
      transactionId: transactionId ?? this.transactionId,
      transactionNote: transactionNote ?? this.transactionNote,
      currency: currency ?? this.currency,
      preferredApp: preferredApp ?? this.preferredApp,
    );
  }

  Map<String, String> toMap() {
    return {
      'pa': payeeVpa,
      'pn': payeeName,
      'am': amount.toStringAsFixed(2),
      'tr': transactionId,
      'tn': transactionNote,
      'cu': currency,
    };
  }
}