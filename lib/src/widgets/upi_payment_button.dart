import 'package:flutter/material.dart';

import '../models/upi_payment_config.dart';
import '../models/upi_payment_response.dart';
import '../utils/upi_payment_launcher.dart';

class UpiPaymentButton extends StatefulWidget {
  final UpiPaymentConfig config;
  final String label;
  final Widget? icon;
  final VoidCallback? onPressed;
  final ValueChanged<UpiPaymentResponse>? onResult;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double height;
  final double borderRadius;

  const UpiPaymentButton({
    super.key,
    required this.config,
    this.label = 'Pay with UPI',
    this.icon,
    this.onPressed,
    this.onResult,
    this.backgroundColor,
    this.foregroundColor,
    this.height = 52,
    this.borderRadius = 14,
  });

  @override
  State<UpiPaymentButton> createState() => _UpiPaymentButtonState();
}

class _UpiPaymentButtonState extends State<UpiPaymentButton> {
  bool _isLoading = false;

  Future<void> _pay() async {
    if (_isLoading) return;

    widget.onPressed?.call();

    setState(() {
      _isLoading = true;
    });

    final response = await UpiPaymentLauncher.launch(widget.config);

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    widget.onResult?.call(response);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      height: widget.height,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _pay,
        style: ElevatedButton.styleFrom(
          backgroundColor:
          widget.backgroundColor ?? theme.colorScheme.primary,
          foregroundColor:
          widget.foregroundColor ?? theme.colorScheme.onPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: _isLoading
              ? const SizedBox(
            key: ValueKey('loading'),
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2.4),
          )
              : Row(
            key: const ValueKey('button'),
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.icon ??
                  const Icon(
                    Icons.account_balance_wallet_rounded,
                  ),
              const SizedBox(width: 10),
              Text(
                widget.label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}