import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';
import '../core/theme/app_theme.dart';
import '../services/cart_state.dart';
import '../widgets/payment_verification_modal.dart';
import '../widgets/subscription_scheduler_card.dart';

class CartFavoritesScreen extends StatefulWidget {
  const CartFavoritesScreen({super.key});

  @override
  State<CartFavoritesScreen> createState() => _CartFavoritesScreenState();
}

class _CartFavoritesScreenState extends State<CartFavoritesScreen> {
  String _selectedSubCity = AppConstants.addisSubCities.first;
  String _selectedPayment = AppConstants.paymentMethods.first;
  final TextEditingController _promoController = TextEditingController();

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  void _openPaymentGateway(BuildContext context, CartState cartState) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PaymentVerificationModal(
        totalETB: cartState.grandTotalETB,
        paymentMethod: _selectedPayment,
        subCity: _selectedSubCity,
        onVerified: (txRef) async {
          final order = await cartState.placeCheckoutOrder(
            subCity: _selectedSubCity,
            paymentMethod: _selectedPayment,
            paymentReference: txRef,
          );
          if (!context.mounted || order == null) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Order #${order.orderNumber} verified ($txRef) via $_selectedPayment!',
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartState = CartStateScope.of(context);
    final items = cartState.items;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          cartState.tr('cart_tab'),
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),

        // Recurring Subscription Scheduler Card
        SubscriptionSchedulerCard(
          schedule: cartState.subscription,
          onChanged: cartState.updateSubscription,
          onToggleBean: cartState.toggleBeanInSubscription,
        ),
        const SizedBox(height: 16),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Bag Items (${items.length})',
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (items.isNotEmpty)
              TextButton.icon(
                onPressed: cartState.clearCart,
                icon: const Icon(
                  Icons.delete_sweep_outlined,
                  size: 16,
                  color: Colors.redAccent,
                ),
                label: const Text(
                  'Clear Cart',
                  style: TextStyle(color: Colors.redAccent, fontSize: 12),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        if (items.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.surfaceCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.borderSubtle),
            ),
            child: const Center(
              child: Text(
                'Your coffee bag is empty. Explore Ethiopian terroirs to add fresh micro-lots.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppTheme.textMuted),
              ),
            ),
          )
        else
          ...List.generate(items.length, (index) {
            final item = items[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
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
                          item.bean.name,
                          style: const TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${item.bean.category} · ${item.roastLevel.displayName} · ${item.grindType.displayName}',
                          style: const TextStyle(
                            color: AppTheme.textMuted,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${item.lineTotalETB} ETB',
                          style: const TextStyle(
                            color: AppTheme.accentGoldLight,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () =>
                            cartState.updateItemQuantity(index, -0.25),
                        icon: const Icon(Icons.remove_circle_outline, size: 20),
                      ),
                      Text(
                        '${item.quantityKg} kg',
                        style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      IconButton(
                        onPressed: () =>
                            cartState.updateItemQuantity(index, 0.25),
                        icon: const Icon(Icons.add_circle_outline, size: 20),
                      ),
                      IconButton(
                        onPressed: () => cartState.removeCartItem(index),
                        icon: const Icon(
                          Icons.delete_outline,
                          size: 20,
                          color: Colors.redAccent,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),

        const SizedBox(height: 16),
        // Checkout Summary & Payment
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
              const Text(
                'Addis Sub-City & Telebirr / CBE Checkout',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                initialValue: _selectedSubCity,
                dropdownColor: AppTheme.surfaceElevated,
                items: AppConstants.addisSubCities
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedSubCity = val);
                },
                decoration: const InputDecoration(
                  labelText: 'Delivery Sub-City',
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                initialValue: _selectedPayment,
                dropdownColor: AppTheme.surfaceElevated,
                items: AppConstants.paymentMethods
                    .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedPayment = val);
                },
                decoration: const InputDecoration(
                  labelText: 'Payment Method',
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _promoController,
                      decoration: const InputDecoration(
                        hintText: 'Promo code (BUNA10 / HABESHA20)',
                        isDense: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: () =>
                        cartState.applyPromoCode(_promoController.text),
                    child: const Text('Apply'),
                  ),
                ],
              ),
              const Divider(height: 24),
              _SummaryLine(
                label: 'Subtotal',
                value: '${cartState.subtotalETB} ETB',
              ),
              if (cartState.subscriptionSavingsETB > 0)
                _SummaryLine(
                  label: 'Subscriber Savings',
                  value: '-${cartState.subscriptionSavingsETB} ETB',
                  highlight: true,
                ),
              if (cartState.promoDiscountETB > 0)
                _SummaryLine(
                  label: 'Promo (${cartState.appliedPromoCode})',
                  value: '-${cartState.promoDiscountETB} ETB',
                  highlight: true,
                ),
              _SummaryLine(
                label: 'Addis Courier Dispatch',
                value: cartState.deliveryFeeETB == 0
                    ? 'FREE'
                    : '${cartState.deliveryFeeETB} ETB',
              ),
              const SizedBox(height: 8),
              _SummaryLine(
                label: 'Total (Incl. 15% VAT)',
                value: '${cartState.grandTotalETB} ETB',
                bold: true,
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentGold,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: items.isEmpty
                      ? null
                      : () => _openPaymentGateway(context, cartState),
                  child: Text(
                    '${cartState.tr('checkout_btn')} · ${cartState.grandTotalETB} ETB',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SummaryLine extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  final bool highlight;

  const _SummaryLine({
    required this.label,
    required this.value,
    this.bold = false,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: bold ? AppTheme.textPrimary : AppTheme.textSecondary,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
              fontSize: bold ? 15 : 13,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: highlight
                  ? AppTheme.highlandGreen
                  : bold
                      ? AppTheme.accentGoldLight
                      : AppTheme.textPrimary,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
              fontSize: bold ? 16 : 13,
            ),
          ),
        ],
      ),
    );
  }
}
