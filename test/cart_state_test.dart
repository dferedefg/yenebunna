import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bunna_app/core/config/parse_classes.dart';
import 'package:flutter_bunna_app/core/config/parse_config.dart';
import 'package:flutter_bunna_app/data/coffee_seed_data.dart';
import 'package:flutter_bunna_app/models/coffee_bean.dart';
import 'package:flutter_bunna_app/services/cart_state.dart';

void main() {
  group('ParseConfig & ParseClasses Verification', () {
    test('ParseConfig has non-empty Back4App credentials by default', () {
      expect(ParseConfig.hasCredentials, isTrue);
      expect(ParseConfig.serverUrl, equals('https://parseapi.back4app.com'));
    });

    test('ParseClasses uses MarketplaceOrder and MarketplaceReview', () {
      expect(ParseClasses.order, equals('MarketplaceOrder'));
      expect(ParseClasses.review, equals('MarketplaceReview'));
      expect(ParseClasses.cartItem, equals('CartItem'));
      expect(ParseClasses.address, equals('Address'));
      expect(ParseClasses.paymentMethod, equals('PaymentMethod'));
      expect(ParseClasses.favoriteItem, equals('FavoriteItem'));
    });
  });

  group('CartState Shopping Cart & Subscription Math', () {
    test('addToCart, updateItemQuantity, removeCartItem, and clearCart work', () {
      final cart = CartState();
      final initialCount = cart.items.length;
      expect(initialCount, greaterThan(0));

      final hararBean = CoffeeSeedData.beans[3];
      cart.addToCart(
        bean: hararBean,
        quantityKg: 1.0,
        roastLevel: RoastLevel.dark,
        grindType: GrindType.jebenaFine,
      );
      expect(cart.items.length, equals(initialCount + 1));

      cart.updateItemQuantity(cart.items.length - 1, 0.5);
      expect(cart.items.last.quantityKg, equals(1.5));

      cart.removeCartItem(cart.items.length - 1);
      expect(cart.items.length, equals(initialCount));

      cart.clearCart();
      expect(cart.items, isEmpty);
      expect(cart.subtotalETB, equals(0));
    });

    test('Promo codes BUNA10 and HABESHA20 calculate discounts accurately', () {
      final cart = CartState();
      final subtotal = cart.subtotalETB;
      cart.applyPromoCode('BUNA10');
      expect(cart.promoDiscountETB, equals((subtotal * 0.10).round()));

      cart.applyPromoCode('HABESHA20');
      expect(cart.promoDiscountETB, equals((subtotal * 0.20).round()));
    });
  });
}
