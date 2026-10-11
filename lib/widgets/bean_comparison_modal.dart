import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../models/coffee_bean.dart';

class BeanComparisonModal extends StatelessWidget {
  final List<CoffeeBean> beans;

  const BeanComparisonModal({
    super.key,
    required this.beans,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Side-by-Side Ethiopian Micro-Lot Comparison',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 14),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: beans.map((bean) {
                  return Container(
                    width: 220,
                    margin: const EdgeInsets.only(right: 12),
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
                          '${bean.category} · ${bean.region}',
                          style: const TextStyle(
                            color: AppTheme.accentGoldLight,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          bean.name,
                          style: const TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Divider(height: 18),
                        _MetricRow('SCA Score', '${bean.cupScore} pts'),
                        _MetricRow('Price / kg', '${bean.pricePerKgETB} ETB'),
                        _MetricRow('Elevation', bean.elevation),
                        _MetricRow('Process', bean.processMethod),
                        _MetricRow('Roast', bean.defaultRoast.shortLabel),
                        const Divider(height: 18),
                        _MetricRow('Floral', '${bean.flavorProfile.floral}/100'),
                        _MetricRow('Citrus', '${bean.flavorProfile.citrus}/100'),
                        _MetricRow(
                            'Sweetness', '${bean.flavorProfile.sweetness}/100'),
                        _MetricRow('Body', '${bean.flavorProfile.body}/100'),
                        _MetricRow(
                            'Acidity', '${bean.flavorProfile.acidity}/100'),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  final String label;
  final String value;

  const _MetricRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: AppTheme.textMuted, fontSize: 11),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
