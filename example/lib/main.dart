import 'package:flutter/material.dart';
import 'package:flutter_easy_upi_payment/flutter_easy_upi_payment.dart';

void main() {
  runApp(const EasyUpiPaymentExample());
}

class EasyUpiPaymentExample extends StatelessWidget {
  const EasyUpiPaymentExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Easy UPI Payment',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F7FA),
      ),
      home: const PaymentPage(),
    );
  }
}

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController(
    text: 'Sufiyan Shaikh',
  );

  final _upiController = TextEditingController(
    text: 'example@upi',
  );

  final _amountController = TextEditingController(
    text: '10.00',
  );

  final _noteController = TextEditingController(
    text: 'Flutter UPI Payment',
  );

  UpiApp? _selectedApp;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _upiController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _makePayment() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final amount = double.parse(
      _amountController.text.trim(),
    );

    final config = UpiPaymentConfig(
      payeeName: _nameController.text.trim(),
      payeeVpa: _upiController.text.trim(),
      amount: amount,
      transactionId:
      'TXN${DateTime.now().millisecondsSinceEpoch}',
      transactionNote: _noteController.text.trim(),
      preferredApp: _selectedApp,
    );

    setState(() {
      _isLoading = true;
    });

    final response = await UpiPaymentLauncher.launch(config);

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    _showPaymentResult(response);
  }

  void _showPaymentResult(UpiPaymentResponse response) {
    final theme = Theme.of(context);

    final Color color;
    final IconData icon;
    final String title;

    switch (response.status) {
      case UpiPaymentStatus.success:
        color = Colors.green;
        icon = Icons.check_circle_rounded;
        title = 'Payment Successful';
        break;

      case UpiPaymentStatus.submitted:
        color = Colors.orange;
        icon = Icons.schedule_rounded;
        title = 'Payment Submitted';
        break;

      case UpiPaymentStatus.failed:
        color = theme.colorScheme.error;
        icon = Icons.error_rounded;
        title = 'Payment Failed';
        break;

      case UpiPaymentStatus.cancelled:
        color = Colors.orange;
        icon = Icons.cancel_rounded;
        title = 'Payment Cancelled';
        break;

      case UpiPaymentStatus.unknown:
        color = theme.colorScheme.primary;
        icon = Icons.help_rounded;
        title = 'Unknown Status';
        break;
    }

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: theme.colorScheme.surface,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              24,
              8,
              24,
              30,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 42,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  response.message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 14,
                  ),
                ),
                if (response.transactionId != null) ...[
                  const SizedBox(height: 18),
                  Text(
                    'Transaction ID',
                    style: TextStyle(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    response.transactionId!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Done',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 1.5,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final amount =
        double.tryParse(_amountController.text) ?? 0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Easy UPI Payment',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            20,
            8,
            20,
            32,
          ),
          children: [
            const Text(
              'Make a secure payment',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.8,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Pay directly using any supported UPI application.',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context)
                    .colorScheme
                    .onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),

            // Payment preview card.
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF6750A4),
                    Color(0xFF8B6FC9),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.10),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(
                            alpha: 0.16,
                          ),
                          borderRadius:
                          BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.account_balance_wallet_rounded,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Paying to',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              _nameController.text,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    '₹${amount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    _upiController.text,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Divider(
                    color: Colors.white.withValues(
                      alpha: 0.18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.receipt_long_rounded,
                        color: Colors.white70,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _noteController.text,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            _textField(
              controller: _nameController,
              label: 'Payee name',
              hint: 'Enter payee name',
              icon: Icons.person_outline_rounded,
              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty) {
                  return 'Enter payee name';
                }
                return null;
              },
            ),

            const SizedBox(height: 14),

            _textField(
              controller: _upiController,
              label: 'UPI ID',
              hint: 'example@upi',
              icon: Icons.alternate_email_rounded,
              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty) {
                  return 'Enter UPI ID';
                }

                if (!UpiPaymentUtils.isValidVpa(
                  value.trim(),
                )) {
                  return 'Enter a valid UPI ID';
                }

                return null;
              },
            ),

            const SizedBox(height: 14),

            _textField(
              controller: _amountController,
              label: 'Amount',
              hint: '10.00',
              icon: Icons.currency_rupee_rounded,
              keyboardType:
              const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: (value) {
                final parsed = double.tryParse(
                  value?.trim() ?? '',
                );

                if (parsed == null || parsed <= 0) {
                  return 'Enter a valid amount';
                }

                return null;
              },
            ),

            const SizedBox(height: 14),

            _textField(
              controller: _noteController,
              label: 'Payment note',
              hint: 'Enter payment note',
              icon: Icons.notes_rounded,
            ),

            const SizedBox(height: 22),

            const Text(
              'Preferred UPI app',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 10),

            DropdownButtonFormField<UpiApp?>(
              initialValue: _selectedApp,
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.apps_rounded,
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
              hint: const Text(
                'Any available UPI app',
              ),
              items: [
                const DropdownMenuItem<UpiApp?>(
                  value: null,
                  child: Text(
                    'Any available UPI app',
                  ),
                ),
                ...UpiApp.values
                    .where(
                      (app) => app != UpiApp.other,
                )
                    .map(
                      (app) => DropdownMenuItem<UpiApp?>(
                    value: app,
                    child: Text(
                      app.displayName,
                    ),
                  ),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedApp = value;
                });
              },
            ),

            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: FilledButton.icon(
                onPressed:
                _isLoading ? null : _makePayment,
                icon: _isLoading
                    ? const SizedBox(
                  width: 21,
                  height: 21,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.white,
                  ),
                )
                    : const Icon(
                  Icons.lock_rounded,
                ),
                label: Text(
                  _isLoading
                      ? 'Opening UPI...'
                      : 'Continue to Pay',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 14),

            Row(
              mainAxisAlignment:
              MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.verified_user_rounded,
                  size: 16,
                  color: Colors.green.shade600,
                ),
                const SizedBox(width: 6),
                Text(
                  'Secure UPI payment',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}