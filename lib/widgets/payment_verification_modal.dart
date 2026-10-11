import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../services/parse_service.dart';

class PaymentVerificationModal extends StatefulWidget {
  final int totalETB;
  final String paymentMethod;
  final String subCity;
  final void Function(String transactionRef) onVerified;

  const PaymentVerificationModal({
    super.key,
    required this.totalETB,
    required this.paymentMethod,
    required this.subCity,
    required this.onVerified,
  });

  @override
  State<PaymentVerificationModal> createState() =>
      _PaymentVerificationModalState();
}

class _PaymentVerificationModalState extends State<PaymentVerificationModal> {
  final TextEditingController _phoneController =
      TextEditingController(text: '+251 911 234 567');
  final TextEditingController _pinController =
      TextEditingController(text: '4829');
  bool _isProcessing = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _confirmPayment() async {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);
    await Future<void>.delayed(const Duration(milliseconds: 450));
    if (!mounted) return;
    final prefix = widget.paymentMethod.toLowerCase().contains('telebirr')
        ? 'TLB'
        : widget.paymentMethod.toLowerCase().contains('cbe')
            ? 'CBE'
            : 'CHP';
    final txRef =
        'TX-ET-$prefix-${100000 + DateTime.now().millisecondsSinceEpoch % 899999}';
    Navigator.of(context).pop();
    widget.onVerified(txRef);
  }

  @override
  Widget build(BuildContext context) {
    final preVat = (widget.totalETB / 1.15).round();
    final vat = widget.totalETB - preVat;
    final idempKey = ParseService.computeIdempotencyKey(
      'CHK',
      '${widget.paymentMethod}-${widget.totalETB}-${widget.subCity}',
    );

    return Container(
      padding: EdgeInsets.fromLTRB(
        22,
        18,
        22,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ETHIOPIAN PAYMENT GATEWAY · የክፍያ ማረጋገጫ',
                      style: TextStyle(
                        color: AppTheme.accentGoldLight,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.paymentMethod,
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.surfaceElevated,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.borderSubtle),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Merchant: Yene Bunna Specialty Coffee PLC · TIN 0049182736',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Dispatch Sub-City: ${widget.subCity}',
                    style: const TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Idempotency Key: $idempKey',
                    style: const TextStyle(
                      color: AppTheme.accentGoldLight,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Divider(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Amount Due (Incl. 15% VAT)',
                        style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${widget.totalETB} ETB (VAT: $vat ETB)',
                        style: const TextStyle(
                          color: AppTheme.accentGoldLight,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Ethiopian Mobile / Account Number',
                prefixIcon: Icon(Icons.phone_android, size: 18),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _pinController,
              obscureText: true,
              maxLength: 6,
              decoration: const InputDecoration(
                labelText: 'USSD Push / OTP Verification PIN',
                prefixIcon: Icon(Icons.lock_outline, size: 18),
                counterText: '',
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentGold,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: _isProcessing ? null : _confirmPayment,
                icon: const Icon(Icons.verified_user_outlined, size: 18),
                label: Text(
                  _isProcessing
                      ? 'Verifying Idempotent Settlement...'
                      : 'Authorize ${widget.totalETB} ETB & Start Roasting',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
