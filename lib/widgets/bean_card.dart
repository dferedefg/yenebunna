import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../models/coffee_bean.dart';

class BeanCard extends StatelessWidget {
  final CoffeeBean bean;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;
  final VoidCallback onTapDetail;
  final VoidCallback onQuickAdd;

  const BeanCard({
    super.key,
    required this.bean,
    required this.isFavorite,
    required this.onToggleFavorite,
    required this.onTapDetail,
    required this.onQuickAdd,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapDetail,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surfaceCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.borderSubtle, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${bean.region.toUpperCase()} · ${bean.processMethod.toUpperCase()} · SCA ${bean.cupScore}',
                  style: const TextStyle(
                    color: AppTheme.accentGoldLight,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.4,
                  ),
                ),
                InkWell(
                  onTap: onToggleFavorite,
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.redAccent : AppTheme.textMuted,
                    size: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              bean.name,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '${bean.amharicName} · ${bean.elevation} · ${bean.roasterName}',
              style: const TextStyle(
                color: AppTheme.textMuted,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              bean.flavorNotes.join(' · '),
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${bean.pricePerKgETB} ETB / kg',
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Default: ${bean.defaultRoast.displayName}',
                      style: const TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentGold,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: onQuickAdd,
                  icon: const Icon(Icons.add_shopping_cart, size: 16),
                  label: const Text(
                    'Add 500g',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
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
