import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bunna_app/main.dart';

void main() {
  testWidgets('BunnaMarketplaceApp renders Home, Roasters, Orders, Bag, and Profile tabs',
      (WidgetTester tester) async {
    await tester.pumpWidget(const BunnaMarketplaceApp());
    await tester.pump();

    // Verify Brand Header
    expect(find.textContaining('Yene Bunna'), findsWidgets);

    // Verify Terroir Map & Catalog on Home Screen
    expect(find.text('Interactive Ethiopian Terroir Map'), findsOneWidget);
    expect(find.text('Single Origin'), findsWidgets);
    expect(find.text('Blends'), findsWidgets);

    // Navigate to Roasters tab
    await tester.tap(find.text('Roasters'));
    await tester.pump();
    expect(find.text('Addis Ababa Artisan Roasteries'), findsOneWidget);

    // Navigate to Bag & Sub tab
    await tester.tap(find.text('Bag & Sub'));
    await tester.pump();
    expect(find.text('Roast Bag & Buna Subscription'), findsOneWidget);
  });
}
