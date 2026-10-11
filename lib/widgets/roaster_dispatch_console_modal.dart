import 'package:flutter/material.dart';
import '../core/config/parse_classes.dart';
import '../core/theme/app_theme.dart';
import '../data/coffee_seed_data.dart';
import '../services/cart_state.dart';
import '../services/parse_service.dart';

class RoasterDispatchConsoleModal extends StatefulWidget {
  const RoasterDispatchConsoleModal({super.key});

  @override
  State<RoasterDispatchConsoleModal> createState() =>
      _RoasterDispatchConsoleModalState();
}

class _RoasterDispatchConsoleModalState
    extends State<RoasterDispatchConsoleModal> {
  bool _isSeeding = false;
  String? _seedStatus;

  Future<void> _handleSeedCatalog(CartState cartState) async {
    if (_isSeeding) return;
    setState(() {
      _isSeeding = true;
      _seedStatus = null;
    });
    final count = await ParseService.instance.seedPremiumCoffeeCatalog(
      CoffeeSeedData.beans,
      sessionToken: cartState.authService.currentUser?.sessionToken,
    );
    if (!mounted) return;
    setState(() {
      _isSeeding = false;
      _seedStatus =
          'Idempotent Upsert Complete: $count/${CoffeeSeedData.beans.length} lots synced to Back4App ${ParseClasses.premiumCoffee} (zero duplicate rows).';
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartState = CartStateScope.of(context);
    final activeOrder = cartState.activeOrder;
    final ledgerSize = ParseService.instance.idempotencyLedger.length;

    return Container(
      padding: const EdgeInsets.all(22),
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
                  children: const [
                    Text(
                      'IDEMPOTENT BACK4APP SEEDER & ROASTER OPS',
                      style: TextStyle(
                        color: AppTheme.accentGoldLight,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Idempotent Catalog Upsert & Live Dispatch',
                      style: TextStyle(
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
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.bgDark,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.borderSubtle),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'GET-then-PUT/POST Upsert Guard Active',
                    style: TextStyle(
                      color: AppTheme.highlandGreen,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Ledger Keys: $ledgerSize',
                    style: const TextStyle(
                      color: AppTheme.accentGoldLight,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
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
                  Text(
                    'Idempotent ${ParseClasses.premiumCoffee} Seeder (${CoffeeSeedData.beans.length} Lots)',
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Upserts all Single-Origin & Blend lots by unique beanId without creating duplicate rows on repeated runs.',
                    style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
                  ),
                  if (_seedStatus != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      _seedStatus!,
                      style: const TextStyle(
                        color: AppTheme.highlandGreen,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentGold,
                        foregroundColor: Colors.black,
                      ),
                      onPressed: _isSeeding
                          ? null
                          : () => _handleSeedCatalog(cartState),
                      icon: const Icon(Icons.cloud_upload_outlined, size: 16),
                      label: Text(
                        _isSeeding
                            ? 'Upserting ${CoffeeSeedData.beans.length} Lots...'
                            : 'Idempotent Upsert All ${CoffeeSeedData.beans.length} Lots',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
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
                  Text(
                    'Roaster Drum & Courier Dispatch · #${activeOrder.orderNumber}',
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Current Stage: ${activeOrder.status.displayName} (${activeOrder.roasteryName})',
                    style: const TextStyle(
                      color: AppTheme.accentGoldLight,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppTheme.accentGold),
                      ),
                      onPressed: () async {
                        await cartState.advanceActiveOrderStage();
                        await ParseService.instance.saveOrderToParse(
                          cartState.activeOrder,
                          sessionToken:
                              cartState.authService.currentUser?.sessionToken,
                        );
                      },
                      icon: const Icon(
                        Icons.local_fire_department_outlined,
                        size: 16,
                        color: AppTheme.accentGoldLight,
                      ),
                      label: const Text(
                        'Advance Stage & Idempotent Upsert Order',
                        style: TextStyle(
                          color: AppTheme.accentGoldLight,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
