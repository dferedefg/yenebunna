# Yene Bunna (የኔ ቡና) — Ethiopian Specialty Coffee Marketplace (Flutter MVP)

A complete, self-contained **Flutter & Dart MVP** clone of the Ethiopian Specialty Coffee Customer Marketplace.

## Key Features Included
1. **Interactive Ethiopian Origin Map (`lib/widgets/ethiopian_origin_map.dart`)**:
   - Hardware-accelerated `CustomPainter` vector map of Ethiopia's 6 premier coffee terroirs (Yirgacheffe, Guji, Sidama, Harar, Limu, Keffa).
   - Displays the Great Rift Valley fault line, Lake Tana, Lake Hawassa, and Lake Abaya with interactive regional tap hit-testing.
2. **Artisan Roasteries & Live Drum Curve (`lib/screens/roasters_screen.dart`)**:
   - Live cast-iron drum roasting telemetry across Addis Ababa districts (Bole, Piazza, Kazanchis, Old Airport) plus Roastery Visit booking.
3. **Recurring Buna Replenishment Subscription (`lib/widgets/subscription_scheduler_card.dart`)**:
   - Weekly (-15%), Bi-Weekly (-12%), and Monthly (-10%) cadence scheduling, preferred delivery day selection, and customizable micro-lot rotation box.
4. **Live Addis Ababa Courier Tracking (`lib/widgets/live_courier_tracking_widget.dart`)**:
   - Vector road map of Addis Ababa (Bole Road / Africa Ave, Meskel Square, Kazanchis) with animated motorbike courier interpolation, traffic speed telemetry, and 500m proximity radar.
5. **Mock Push Notification Service & Preferences (`lib/services/notification_service.dart` & `lib/screens/profile_screen.dart`)**:
   - Real-time in-app toast banners and haptic feedback for `'Roast Ready'` and `'Order Dispatched'` events, controlled by user preference switches and live sandbox triggers.
6. **Traditional 3-Stage Jebena Ceremony Timer (`lib/widgets/jebena_ceremony_timer_modal.dart`)**:
   - Interactive brewing timer for **Abol (አቦል)**, **Tona (ቶና)**, and **Baraka (በረካ)**.

## Quick Start

```bash
cd flutter_bunna_app
flutter create --platforms=android,ios,web .
flutter pub get
flutter run
```
