import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../data/coffee_seed_data.dart';
import '../services/cart_state.dart';
import '../widgets/roaster_dispatch_console_modal.dart';
import '../widgets/roastery_visit_modal.dart';

class RoastersScreen extends StatelessWidget {
  const RoastersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartState = CartStateScope.of(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                cartState.tr('roasters_title'),
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppTheme.accentGold),
              ),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => const RoasterDispatchConsoleModal(),
                );
              },
              icon: const Icon(
                Icons.cloud_upload_outlined,
                size: 15,
                color: AppTheme.accentGoldLight,
              ),
              label: const Text(
                'Roaster Ops',
                style: TextStyle(
                  color: AppTheme.accentGoldLight,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          cartState.tr('roasters_subtitle'),
          style: const TextStyle(
            color: AppTheme.textMuted,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 16),
        ...CoffeeSeedData.roasteries.map((roaster) {
          return Container(
            margin: const EdgeInsets.only(bottom: 14),
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
                      '${roaster.district} · ${roaster.distanceKm} km away',
                      style: const TextStyle(
                        color: AppTheme.accentGoldLight,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      roaster.isLiveRoasting
                          ? 'LIVE DRUM · ${roaster.drumTemperatureCelsius}°C'
                          : 'BATCH READY',
                      style: TextStyle(
                        color: roaster.isLiveRoasting
                            ? AppTheme.highlandGreen
                            : AppTheme.textMuted,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  roaster.name,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '${roaster.amharicName} · Master Roaster: ${roaster.masterRoaster}',
                  style: const TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Active Drum Batch: ${roaster.currentBatchBean} (${roaster.roastProgressPercent}%)',
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: roaster.roastProgressPercent / 100.0,
                    minHeight: 6,
                    backgroundColor: AppTheme.surfaceElevated,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppTheme.accentGold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '★ ${roaster.rating} (${roaster.reviewsCount}) · Avg Dispatch ${roaster.avgDispatchMinutes}m',
                      style: const TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 12,
                      ),
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppTheme.accentGold),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => RoasteryVisitModal(roastery: roaster),
                        );
                      },
                      child: const Text(
                        'Book Cupping',
                        style: TextStyle(
                          color: AppTheme.accentGoldLight,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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
