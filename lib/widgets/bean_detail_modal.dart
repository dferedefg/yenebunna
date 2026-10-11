import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../models/coffee_bean.dart';
import '../services/cart_state.dart';

class BeanDetailModal extends StatefulWidget {
  final CoffeeBean bean;
  final void Function({
    required double quantityKg,
    required RoastLevel roastLevel,
    required GrindType grindType,
    required DeliveryFrequency frequency,
  }) onAddToBag;

  const BeanDetailModal({
    super.key,
    required this.bean,
    required this.onAddToBag,
  });

  @override
  State<BeanDetailModal> createState() => _BeanDetailModalState();
}

class _BeanDetailModalState extends State<BeanDetailModal> {
  late RoastLevel _selectedRoast;
  GrindType _selectedGrind = GrindType.wholeBean;
  double _selectedWeightKg = 0.5;
  final DeliveryFrequency _selectedFrequency = DeliveryFrequency.biWeekly;

  int _newRating = 5;
  final TextEditingController _reviewCommentController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedRoast = widget.bean.defaultRoast;
  }

  @override
  void dispose() {
    _reviewCommentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartState = CartStateScope.of(context);
    final beanReviews = cartState.reviewsForBean(widget.bean.id);
    final basePrice = (widget.bean.pricePerKgETB * _selectedWeightKg).round();
    final finalPrice =
        (basePrice * (1.0 - _selectedFrequency.discountRate)).round();

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
      decoration: const BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.borderSubtle,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '${widget.bean.region} · ${widget.bean.subRegion} · ${widget.bean.elevation}',
              style: const TextStyle(
                color: AppTheme.accentGoldLight,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.bean.name,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              '${widget.bean.amharicName} · Varietal: ${widget.bean.varietal}',
              style: const TextStyle(
                color: AppTheme.textMuted,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              widget.bean.story,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 13,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Select Roast Curve',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: RoastLevel.values.map((roast) {
                final active = roast == _selectedRoast;
                return ChoiceChip(
                  label: Text(roast.displayName),
                  selected: active,
                  selectedColor: AppTheme.accentGold,
                  labelStyle: TextStyle(
                    color: active ? Colors.black : AppTheme.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  onSelected: (_) => setState(() => _selectedRoast = roast),
                );
              }).toList(),
            ),
            const SizedBox(height: 14),
            const Text(
              'Select Grind Preparation',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: GrindType.values.map((grind) {
                final active = grind == _selectedGrind;
                return ChoiceChip(
                  label: Text(grind.displayName),
                  selected: active,
                  selectedColor: AppTheme.accentGold,
                  labelStyle: TextStyle(
                    color: active ? Colors.black : AppTheme.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  onSelected: (_) => setState(() => _selectedGrind = grind),
                );
              }).toList(),
            ),
            const SizedBox(height: 14),
            const Text(
              'Bag Weight',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [0.25, 0.5, 1.0].map((kg) {
                final active = _selectedWeightKg == kg;
                final label = kg == 1.0 ? '1 kg' : '${(kg * 1000).round()}g';
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor:
                          active ? AppTheme.accentGold : Colors.transparent,
                      side: BorderSide(
                        color: active
                            ? AppTheme.accentGold
                            : AppTheme.borderSubtle,
                      ),
                    ),
                    onPressed: () => setState(() => _selectedWeightKg = kg),
                    child: Text(
                      label,
                      style: TextStyle(
                        color: active ? Colors.black : AppTheme.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentGold,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  widget.onAddToBag(
                    quantityKg: _selectedWeightKg,
                    roastLevel: _selectedRoast,
                    grindType: _selectedGrind,
                    frequency: _selectedFrequency,
                  );
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Add to Bag · $finalPrice ETB',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const Divider(height: 28),
            // Community Cupping Reviews (Synced with Back4App MarketplaceReview)
            Text(
              'Community Cupping Notes (${beanReviews.length})',
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text(
                  'Your Rating:',
                  style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
                ),
                const SizedBox(width: 8),
                ...List.generate(5, (idx) {
                  final starVal = idx + 1;
                  return IconButton(
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () => setState(() => _newRating = starVal),
                    icon: Icon(
                      starVal <= _newRating ? Icons.star : Icons.star_border,
                      size: 18,
                      color: AppTheme.accentGold,
                    ),
                  );
                }),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _reviewCommentController,
                    style: const TextStyle(fontSize: 12),
                    decoration: const InputDecoration(
                      hintText: 'Share your V60, Jebena, or Espresso notes...',
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.surfaceElevated,
                    foregroundColor: AppTheme.accentGoldLight,
                  ),
                  onPressed: () {
                    final text = _reviewCommentController.text.trim();
                    if (text.isEmpty) return;
                    cartState.addReview(
                      beanId: widget.bean.id,
                      rating: _newRating,
                      brewMethod: _selectedGrind.displayName,
                      comment: text,
                    );
                    _reviewCommentController.clear();
                  },
                  child: const Text('Post', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ...beanReviews.map((rev) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceElevated,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTheme.borderSubtle),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${rev.authorName} · ${rev.brewMethod}',
                          style: const TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '★ ${rev.rating}/5 · ${rev.createdAtLabel}',
                          style: const TextStyle(
                            color: AppTheme.accentGoldLight,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      rev.comment,
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
