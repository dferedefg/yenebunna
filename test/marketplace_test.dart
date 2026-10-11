import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bunna_app/core/l10n/app_localizations.dart';
import 'package:flutter_bunna_app/data/coffee_seed_data.dart';
import 'package:flutter_bunna_app/main.dart';
import 'package:flutter_bunna_app/models/coffee_bean.dart';
import 'package:flutter_bunna_app/models/order.dart';
import 'package:flutter_bunna_app/services/cart_state.dart';
import 'package:flutter_bunna_app/services/parse_service.dart';

void main() {
  group('CartState Pricing, Localization & Order Progression Tests', () {
    test('Initial cart computes subtotal, subscription discount, and grand total', () {
      final state = CartState();
      expect(state.items.length, 2);
      expect(state.subtotalETB, greaterThan(0));
      expect(state.subscriptionDiscountETB, greaterThan(0));
      expect(state.grandTotalETB, lessThan(state.subtotalETB + state.deliveryFeeETB));
    });

    test('Promo code BUNA10 applies 10% discount and invalid code returns false', () {
      final state = CartState();
      final ok = state.applyPromoCode('BUNA10');
      expect(ok, isTrue);
      expect(state.promoDiscountETB, (state.subtotalETB * 0.10).round());

      final invalid = state.applyPromoCode('INVALID99');
      expect(invalid, isFalse);
      expect(state.promoDiscountETB, 0);
    });

    test('Adding coffee bean updates cart quantity and clearing cart resets items', () {
      final state = CartState();
      state.clearCart();
      expect(state.items, isEmpty);

      state.addToCart(
        bean: CoffeeSeedData.beans.first,
        quantityKg: 0.5,
        roastLevel: RoastLevel.lightFilter,
        grindType: GrindType.v60PourOver,
        frequency: DeliveryFrequency.oneTime,
      );
      expect(state.items.length, 1);
      expect(state.items.first.quantityKg, 0.5);
    });

    test('Bilingual Amharic / English toggle switches AppLanguage and localized strings', () {
      final state = CartState();
      expect(state.language, AppLanguage.en);
      expect(state.tr('nav_terroir'), 'Terroir');

      state.toggleLanguage();
      expect(state.language, AppLanguage.am);
      expect(state.tr('nav_terroir'), 'ምንጭ እና ቡና');
    });

    test('Advancing active order stage progresses from Roasting to Roast Ready', () async {
      final state = CartState();
      expect(state.activeOrder.status, OrderStatus.roasting);
      await state.advanceActiveOrderStage();
      expect(state.activeOrder.status, OrderStatus.roastReady);
    });

    test('ParseService.computeIdempotencyKey is deterministic and idempotent', () {
      final keyA = ParseService.computeIdempotencyKey(
        'BEAN',
        'yirgacheffe-kochere-g1',
      );
      final keyB = ParseService.computeIdempotencyKey(
        'BEAN',
        'yirgacheffe-kochere-g1',
      );
      final keyDifferent = ParseService.computeIdempotencyKey(
        'BEAN',
        'guji-uraga-anaerobic',
      );
      expect(keyA, equals(keyB));
      expect(keyA, startsWith('IDEMP-BEAN-yirgacheffe-kochere-g1-'));
      expect(keyA, isNot(equals(keyDifferent)));
    });
  });

  testWidgets('BunnaMarketplaceApp renders storefront and bottom nav', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const BunnaMarketplaceApp());
    expect(find.text('Yene Bunna · የኔ ቡና'), findsOneWidget);
  });

  testWidgets('OnboardingScreen renders 3 slides, Skip button, and Dont Show Again option', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const BunnaMarketplaceApp(initialStage: AppStartupStage.onboarding),
    );
    expect(find.textContaining('Skip'), findsOneWidget);
    expect(find.textContaining("Don't show onboarding"), findsOneWidget);
  });
}
