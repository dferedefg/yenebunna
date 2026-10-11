import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../data/coffee_seed_data.dart';
import '../models/coffee_bean.dart';
import '../services/cart_state.dart';
import '../widgets/bean_card.dart';
import '../widgets/bean_comparison_modal.dart';
import '../widgets/bean_detail_modal.dart';
import '../widgets/ethiopian_origin_map.dart';
import '../widgets/jebena_ceremony_timer_modal.dart';
import '../widgets/qr_lot_verifier_modal.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'All';
  String _selectedBrand = 'All Brands';

  static const List<String> _categories = [
    'All',
    'Single Origin',
    'Blends',
    'Light Roast',
    'Medium Roast',
    'Dark Roast',
  ];

  static const List<String> _brands = [
    'All Brands',
    'Galani Artisan Roasters',
    'Hega Specialty Roastery',
    'Sidama Coffee Guild',
    'Mokarar Piazza Heritage',
    'Tomoca Heritage Roasters',
  ];

  @override
  Widget build(BuildContext context) {
    final cartState = CartStateScope.of(context);
    final selectedRegion = cartState.selectedRegion;
    final authUser = cartState.authService.currentUser;

    final filteredBeans = CoffeeSeedData.beans.where((bean) {
      if (selectedRegion != null && bean.region != selectedRegion) {
        return false;
      }
      if (_selectedCategory == 'Single Origin' &&
          bean.category != 'Single Origin') {
        return false;
      }
      if (_selectedCategory == 'Blends' && bean.category != 'Blends') {
        return false;
      }
      if (_selectedCategory == 'Light Roast' &&
          bean.defaultRoast != RoastLevel.light) {
        return false;
      }
      if (_selectedCategory == 'Medium Roast' &&
          bean.defaultRoast != RoastLevel.medium) {
        return false;
      }
      if (_selectedCategory == 'Dark Roast' &&
          bean.defaultRoast != RoastLevel.dark) {
        return false;
      }
      if (_selectedBrand != 'All Brands' &&
          bean.roasterName != _selectedBrand) {
        return false;
      }
      if (_searchQuery.trim().isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        return bean.name.toLowerCase().contains(q) ||
            bean.region.toLowerCase().contains(q) ||
            bean.roasterName.toLowerCase().contains(q) ||
            bean.category.toLowerCase().contains(q) ||
            bean.flavorNotes.any((f) => f.toLowerCase().contains(q));
      }
      return true;
    }).toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Personalized Habesha Greeting & Jebena Timer Action
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surfaceCard,
            borderRadius: BorderRadius.circular(18),
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
                      authUser != null
                          ? '${cartState.tr('hero_greeting_user')}, ${authUser.fullName} · እንኳን ደህና መጡ'
                          : cartState.tr('hero_greeting_guest'),
                      style: const TextStyle(
                        color: AppTheme.accentGoldLight,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      cartState.tr('hero_title'),
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${cartState.userProfile.loyaltyTier} · ${cartState.userProfile.loyaltyPoints} pts',
                      style: const TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppTheme.accentGold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (_) => const JebenaCeremonyTimerModal(),
                  );
                },
                icon: const Icon(
                  Icons.timer_outlined,
                  size: 16,
                  color: AppTheme.accentGoldLight,
                ),
                label: Text(
                  cartState.tr('jebena_timer'),
                  style: const TextStyle(
                    color: AppTheme.accentGoldLight,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Interactive Ethiopian Terroir Map
        EthiopianOriginMap(
          selectedRegion: selectedRegion,
          onSelectRegion: cartState.selectRegion,
        ),
        const SizedBox(height: 16),

        // Search & Product Categorization Section
        TextField(
          onChanged: (value) => setState(() => _searchQuery = value),
          style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14),
          decoration: InputDecoration(
            hintText: 'Search coffee type, brand, roast, or flavor note...',
            hintStyle: const TextStyle(color: AppTheme.textMuted, fontSize: 13),
            prefixIcon: const Icon(Icons.search, color: AppTheme.textMuted),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, size: 18),
                    onPressed: () => setState(() => _searchQuery = ''),
                  )
                : null,
            filled: true,
            fillColor: AppTheme.surfaceCard,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppTheme.borderSubtle),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppTheme.borderSubtle),
            ),
          ),
        ),
        const SizedBox(height: 10),

        // Category Tabs (Single Origin, Blends, Roast Levels)
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _categories.map((cat) {
              final active = _selectedCategory == cat;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(cat),
                  selected: active,
                  selectedColor: AppTheme.accentGold,
                  labelStyle: TextStyle(
                    color: active ? Colors.black : AppTheme.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  onSelected: (_) => setState(() => _selectedCategory = cat),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 8),

        // Brand / Roastery Filter Row
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _brands.map((brand) {
              final active = _selectedBrand == brand;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: active
                        ? AppTheme.surfaceElevated
                        : Colors.transparent,
                    side: BorderSide(
                      color:
                          active ? AppTheme.accentGold : AppTheme.borderSubtle,
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  ),
                  onPressed: () => setState(() => _selectedBrand = brand),
                  child: Text(
                    brand,
                    style: TextStyle(
                      color: active
                          ? AppTheme.accentGoldLight
                          : AppTheme.textMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),

        // Micro-Lot Catalog Header + Compare & ECX QR Verifier Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                '$_selectedCategory Catalog (${filteredBeans.length})',
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            TextButton.icon(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (_) => const QrLotVerifierModal(),
                );
              },
              icon: const Icon(
                Icons.qr_code_scanner,
                size: 15,
                color: AppTheme.accentGoldLight,
              ),
              label: const Text(
                'ECX Lot QR',
                style: TextStyle(
                  color: AppTheme.accentGoldLight,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton.icon(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (_) => BeanComparisonModal(
                    beans: filteredBeans.length >= 2
                        ? filteredBeans.take(3).toList()
                        : CoffeeSeedData.beans.take(3).toList(),
                  ),
                );
              },
              icon: const Icon(
                Icons.compare_arrows,
                size: 16,
                color: AppTheme.accentGoldLight,
              ),
              label: const Text(
                'Compare',
                style: TextStyle(
                  color: AppTheme.accentGoldLight,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ...filteredBeans.map((CoffeeBean bean) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: BeanCard(
              bean: bean,
              isFavorite: cartState.isFavorite(bean.id),
              onToggleFavorite: () => cartState.toggleFavorite(bean.id),
              onQuickAdd: () {
                cartState.addToCart(bean: bean, quantityKg: 0.5);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Added 500g ${bean.name} to your bag'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              onTapDetail: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => BeanDetailModal(
                    bean: bean,
                    onAddToBag: ({
                      required quantityKg,
                      required roastLevel,
                      required grindType,
                      required frequency,
                    }) {
                      cartState.addToCart(
                        bean: bean,
                        quantityKg: quantityKg,
                        roastLevel: roastLevel,
                        grindType: grindType,
                        frequency: frequency,
                      );
                    },
                  ),
                );
              },
            ),
          );
        }),
      ],
    );
  }
}
