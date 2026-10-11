class NotificationPreferences {
  final bool orderDispatched;
  final bool roastReady;
  final bool proximityAlert;
  final bool lowStockAlert;
  final bool soundAndHaptics;

  const NotificationPreferences({
    this.orderDispatched = true,
    this.roastReady = true,
    this.proximityAlert = true,
    this.lowStockAlert = true,
    this.soundAndHaptics = true,
  });

  NotificationPreferences copyWith({
    bool? orderDispatched,
    bool? roastReady,
    bool? proximityAlert,
    bool? lowStockAlert,
    bool? soundAndHaptics,
  }) {
    return NotificationPreferences(
      orderDispatched: orderDispatched ?? this.orderDispatched,
      roastReady: roastReady ?? this.roastReady,
      proximityAlert: proximityAlert ?? this.proximityAlert,
      lowStockAlert: lowStockAlert ?? this.lowStockAlert,
      soundAndHaptics: soundAndHaptics ?? this.soundAndHaptics,
    );
  }
}

class UserProfile {
  final String fullName;
  final String amharicName;
  final String phone;
  final String defaultSubCity;
  final String loyaltyTier;
  final int loyaltyPoints;
  final int dailyCupIntake;
  final List<String> unlockedOriginStamps;
  final NotificationPreferences notificationPreferences;

  const UserProfile({
    required this.fullName,
    required this.amharicName,
    required this.phone,
    required this.defaultSubCity,
    required this.loyaltyTier,
    required this.loyaltyPoints,
    required this.dailyCupIntake,
    required this.unlockedOriginStamps,
    required this.notificationPreferences,
  });

  UserProfile copyWith({
    NotificationPreferences? notificationPreferences,
    int? loyaltyPoints,
    String? defaultSubCity,
  }) {
    return UserProfile(
      fullName: fullName,
      amharicName: amharicName,
      phone: phone,
      defaultSubCity: defaultSubCity ?? this.defaultSubCity,
      loyaltyTier: loyaltyTier,
      loyaltyPoints: loyaltyPoints ?? this.loyaltyPoints,
      dailyCupIntake: dailyCupIntake,
      unlockedOriginStamps: unlockedOriginStamps,
      notificationPreferences:
          notificationPreferences ?? this.notificationPreferences,
    );
  }
}
