import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../models/order.dart';
import '../services/cart_state.dart';
import '../widgets/live_courier_tracking_widget.dart';
import '../widgets/qr_lot_verifier_modal.dart';
import '../widgets/vat_receipt_modal.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  void _openInvoice(BuildContext context, Order order) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => VatReceiptModal(order: order),
    );
  }

  void _openLotVerifier(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => const QrLotVerifierModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartState = CartStateScope.of(context);
    final activeOrder = cartState.activeOrder;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          cartState.tr('orders_title'),
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),

        // Interactive Addis Ababa Courier Map & Stage Simulator
        LiveCourierTrackingWidget(
          order: activeOrder,
          onAdvanceStage: () {
            cartState.advanceActiveOrderStage();
          },
        ),
        const SizedBox(height: 16),

        // Active Order Details Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surfaceCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.borderSubtle),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order #${activeOrder.orderNumber} · ${activeOrder.batchCode}',
                    style: const TextStyle(
                      color: AppTheme.accentGoldLight,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    activeOrder.status.displayName,
                    style: const TextStyle(
                      color: AppTheme.highlandGreen,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${activeOrder.status.amharicTitle} · ${activeOrder.roasteryName}',
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => _openLotVerifier(context),
                    icon: const Icon(Icons.qr_code_scanner, size: 15),
                    label: const Text(
                      'Verify Lot',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => _openInvoice(context, activeOrder),
                    icon: const Icon(Icons.receipt_long, size: 16),
                    label: const Text(
                      'VAT Invoice',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
              const Divider(height: 22),
              ...activeOrder.items.map((it) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '${it.quantityKg}kg ${it.bean.name} (${it.roastLevel.displayName})',
                          style: const TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      Text(
                        '${it.lineTotalETB} ETB',
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
            ],
          ),
        ),
        const SizedBox(height: 20),

        const Text(
          'Past Completed Roasts (Quick 1-Tap Reorder)',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        ...cartState.pastOrders.map((Order past) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.surfaceCard,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.borderSubtle),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '#${past.orderNumber} · ${past.createdAtLabel}',
                        style: const TextStyle(
                          color: AppTheme.textMuted,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        past.items.map((e) => e.bean.name).join(', '),
                        style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '${past.totalETB} ETB · ${past.roasteryName}',
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      tooltip: 'VAT Invoice',
                      onPressed: () => _openInvoice(context, past),
                      icon: const Icon(
                        Icons.receipt_long_outlined,
                        size: 18,
                        color: AppTheme.accentGoldLight,
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {
                        cartState.reorderPastOrder(past);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Reordered #${past.orderNumber} into your bag!',
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.replay, size: 15),
                      label: const Text('Reorder'),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
