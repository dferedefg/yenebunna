import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../data/coffee_seed_data.dart';
import '../models/coffee_bean.dart';
import '../models/subscription_schedule.dart';

class SubscriptionSchedulerCard extends StatelessWidget {
  final SubscriptionSchedule schedule;
  final ValueChanged<SubscriptionSchedule> onChanged;
  final ValueChanged<String> onToggleBean;

  const SubscriptionSchedulerCard({
    super.key,
    required this.schedule,
    required this.onChanged,
    required this.onToggleBean,
  });

  static const List<String> deliveryDays = [
    'Monday Morning',
    'Wednesday Afternoon',
    'Friday Morning',
    'Saturday Ceremony Drop',
  ];

  @override
  Widget build(BuildContext context) {
    final frequencies = [
      DeliveryFrequency.weekly,
      DeliveryFrequency.biWeekly,
      DeliveryFrequency.monthly,
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: schedule.isActive
              ? AppTheme.accentGold.withValues(alpha: 0.65)
              : AppTheme.borderSubtle,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Buna Replenishment Subscription',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Freshly drum-roasted drops with subscriber savings',
                      style: TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: schedule.isActive,
                activeThumbColor: AppTheme.accentGold,
                onChanged: (val) =>
                    onChanged(schedule.copyWith(isActive: val)),
              ),
            ],
          ),
          if (schedule.isActive) ...[
            const SizedBox(height: 12),
            const Text(
              'Delivery Cadence & Discount',
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: frequencies.map((freq) {
                final isSelected = schedule.frequency == freq;
                return OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: isSelected
                        ? AppTheme.accentGold
                        : AppTheme.surfaceElevated,
                    side: BorderSide(
                      color: isSelected
                          ? AppTheme.accentGold
                          : AppTheme.borderSubtle,
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () =>
                      onChanged(schedule.copyWith(frequency: freq)),
                  child: Text(
                    freq.displayName,
                    style: TextStyle(
                      color: isSelected ? Colors.black : AppTheme.textPrimary,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 14),
            const Text(
              'Preferred Addis Delivery Window',
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: deliveryDays.map((day) {
                final active = schedule.preferredDay == day;
                return ChoiceChip(
                  label: Text(day),
                  selected: active,
                  selectedColor: AppTheme.accentGold,
                  labelStyle: TextStyle(
                    color: active ? Colors.black : AppTheme.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                  onSelected: (_) =>
                      onChanged(schedule.copyWith(preferredDay: day)),
                );
              }).toList(),
            ),
            const SizedBox(height: 14),
            const Text(
              'Customize Monthly Micro-Lot Box Rotation',
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            ...CoffeeSeedData.beans.take(4).map((bean) {
              final included = schedule.selectedBeanIds.contains(bean.id);
              return CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,
                activeColor: AppTheme.accentGold,
                checkColor: Colors.black,
                value: included,
                onChanged: (_) => onToggleBean(bean.id),
                title: Text(
                  bean.name,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  '${bean.region} · ${bean.processMethod} · ${bean.pricePerKgETB} ETB/kg',
                  style: const TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 11,
                  ),
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
}
