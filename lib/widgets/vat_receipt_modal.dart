import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../models/order.dart';

class VatReceiptModal extends StatelessWidget {
  final Order order;

  const VatReceiptModal({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    final preVat = (order.totalETB / 1.15).round();
    final vatAmount = order.totalETB - preVat;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: const BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
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
                    'ETHIOPIAN VAT INVOICE & ECX CERTIFICATE',
                    style: TextStyle(
                      color: AppTheme.accentGoldLight,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Invoice #${order.orderNumber} · TIN 0049182736',
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
          const Divider(height: 22),
          Text(
            'Roastery Hub: ${order.roasteryName}',
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
          ),
          Text(
            'Traceability Lot: ${order.batchCode}',
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
          ),
          Text(
            'Delivery Address: ${order.destinationAddress}',
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 12),
          ...order.items.map((item) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${item.quantityKg}kg ${item.bean.name} (${item.roastLevel.shortLabel})',
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Text(
                    '${item.lineTotalETB} ETB',
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }),
          const Divider(height: 22),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Net Subtotal (Excl. VAT)',
                style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
              ),
              Text(
                '$preVat ETB',
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Ethiopian Value Added Tax (15% VAT)',
                style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
              ),
              Text(
                '$vatAmount ETB',
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Paid',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '${order.totalETB} ETB',
                style: const TextStyle(
                  color: AppTheme.accentGoldLight,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
