enum NotificationType {
  roastReady,
  orderDispatched,
  proximityAlert,
  lowStock,
  subscriptionRenewal;

  String get badgeLabel {
    switch (this) {
      case NotificationType.roastReady:
        return 'ROAST READY';
      case NotificationType.orderDispatched:
        return 'ORDER DISPATCHED';
      case NotificationType.proximityAlert:
        return 'COURIER < 500M';
      case NotificationType.lowStock:
        return 'LOW BEAN STOCK';
      case NotificationType.subscriptionRenewal:
        return 'SUBSCRIPTION';
    }
  }
}

class NotificationItem {
  final String id;
  final NotificationType type;
  final String title;
  final String amharicTitle;
  final String body;
  final String orderNumber;
  final DateTime timestamp;
  final bool isRead;

  const NotificationItem({
    required this.id,
    required this.type,
    required this.title,
    required this.amharicTitle,
    required this.body,
    required this.orderNumber,
    required this.timestamp,
    this.isRead = false,
  });

  NotificationItem copyWith({bool? isRead}) {
    return NotificationItem(
      id: id,
      type: type,
      title: title,
      amharicTitle: amharicTitle,
      body: body,
      orderNumber: orderNumber,
      timestamp: timestamp,
      isRead: isRead ?? this.isRead,
    );
  }
}
