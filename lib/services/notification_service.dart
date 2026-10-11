import 'dart:async';
import 'package:flutter/services.dart';
import '../models/notification_item.dart';
import '../models/user_profile.dart';

class MockNotificationService {
  static final MockNotificationService instance =
      MockNotificationService._internal();

  MockNotificationService._internal();

  final StreamController<NotificationItem> _alertStreamController =
      StreamController<NotificationItem>.broadcast();

  Stream<NotificationItem> get alertStream => _alertStreamController.stream;

  final List<NotificationItem> _history = [
    NotificationItem(
      id: 'notif-seed-1',
      type: NotificationType.roastReady,
      title: 'Roast Ready: Yirgacheffe Kochere G1',
      amharicTitle: 'ቆሎው ተዘጋጅቷል — ይርጋጨፌ ኮቸሬ',
      body:
          'Batch #ETH-2610-A finished roasting at 204°C at Galani Artisan Roasters and is sealed in a one-way valve bag.',
      orderNumber: 'YB-9042',
      timestamp: DateTime.now().subtract(const Duration(minutes: 26)),
      isRead: true,
    ),
    NotificationItem(
      id: 'notif-seed-2',
      type: NotificationType.orderDispatched,
      title: 'Order Dispatched via Bole Corridor',
      amharicTitle: 'ትዕዛዝዎ በመንገድ ላይ ነው',
      body:
          'Courier Abebe Tadesse (Plate AA-2-B4029) departed Galani Roasters. Estimated arrival: 14 mins.',
      orderNumber: 'YB-9042',
      timestamp: DateTime.now().subtract(const Duration(minutes: 12)),
      isRead: false,
    ),
  ];

  List<NotificationItem> get history => List.unmodifiable(_history);

  int get unreadCount => _history.where((n) => !n.isRead).length;

  Future<NotificationItem?> triggerRoastReady({
    required String orderNumber,
    required String beanName,
    required String roasteryName,
    required NotificationPreferences prefs,
  }) async {
    if (!prefs.roastReady) {
      return null;
    }
    if (prefs.soundAndHaptics) {
      await HapticFeedback.mediumImpact();
    }
    final item = NotificationItem(
      id: 'roast-${DateTime.now().millisecondsSinceEpoch}',
      type: NotificationType.roastReady,
      title: 'Roast Ready: $beanName',
      amharicTitle: 'ትኩስ ቆሎ ተዘጋጅቷል!',
      body:
          '$beanName has completed its artisan drum roast curve at $roasteryName and is degassing for dispatch.',
      orderNumber: orderNumber,
      timestamp: DateTime.now(),
    );
    _history.insert(0, item);
    _alertStreamController.add(item);
    return item;
  }

  Future<NotificationItem?> triggerOrderDispatched({
    required String orderNumber,
    required String courierName,
    required String courierPlate,
    required String destination,
    required int etaMinutes,
    required NotificationPreferences prefs,
  }) async {
    if (!prefs.orderDispatched) {
      return null;
    }
    if (prefs.soundAndHaptics) {
      await HapticFeedback.heavyImpact();
    }
    final item = NotificationItem(
      id: 'dispatch-${DateTime.now().millisecondsSinceEpoch}',
      type: NotificationType.orderDispatched,
      title: 'Order #$orderNumber Dispatched',
      amharicTitle: 'ትዕዛዝዎ ተልኳል — $courierName',
      body:
          'Courier $courierName ($courierPlate) is en route to $destination via Africa Ave. ETA: $etaMinutes mins.',
      orderNumber: orderNumber,
      timestamp: DateTime.now(),
    );
    _history.insert(0, item);
    _alertStreamController.add(item);
    return item;
  }

  Future<NotificationItem?> triggerProximityAlert({
    required String orderNumber,
    required String courierName,
    required int distanceMeters,
    required NotificationPreferences prefs,
  }) async {
    if (!prefs.proximityAlert) {
      return null;
    }
    if (prefs.soundAndHaptics) {
      await HapticFeedback.selectionClick();
    }
    final item = NotificationItem(
      id: 'prox-${DateTime.now().millisecondsSinceEpoch}',
      type: NotificationType.proximityAlert,
      title: 'Courier Approaching ($distanceMeters m away)',
      amharicTitle: 'አድራሹ በቅርብ ርቀት ላይ ይገኛል',
      body:
          '$courierName is within $distanceMeters meters of your gate with freshly roasted Ethiopian Bunna.',
      orderNumber: orderNumber,
      timestamp: DateTime.now(),
    );
    _history.insert(0, item);
    _alertStreamController.add(item);
    return item;
  }

  void markAllRead() {
    for (var i = 0; i < _history.length; i++) {
      _history[i] = _history[i].copyWith(isRead: true);
    }
  }
}
