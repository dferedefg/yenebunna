import 'coffee_bean.dart';

class SubscriptionSchedule {
  final bool isActive;
  final DeliveryFrequency frequency;
  final String preferredDay;
  final String timeWindow;
  final bool roastersChoiceRotation;
  final List<String> selectedBeanIds;
  final GrindType preferredGrind;
  final RoastLevel preferredRoast;

  const SubscriptionSchedule({
    required this.isActive,
    required this.frequency,
    required this.preferredDay,
    required this.timeWindow,
    required this.roastersChoiceRotation,
    required this.selectedBeanIds,
    this.preferredGrind = GrindType.wholeBean,
    this.preferredRoast = RoastLevel.medium,
  });

  SubscriptionSchedule copyWith({
    bool? isActive,
    DeliveryFrequency? frequency,
    String? preferredDay,
    String? timeWindow,
    bool? roastersChoiceRotation,
    List<String>? selectedBeanIds,
    GrindType? preferredGrind,
    RoastLevel? preferredRoast,
  }) {
    return SubscriptionSchedule(
      isActive: isActive ?? this.isActive,
      frequency: frequency ?? this.frequency,
      preferredDay: preferredDay ?? this.preferredDay,
      timeWindow: timeWindow ?? this.timeWindow,
      roastersChoiceRotation:
          roastersChoiceRotation ?? this.roastersChoiceRotation,
      selectedBeanIds: selectedBeanIds ?? this.selectedBeanIds,
      preferredGrind: preferredGrind ?? this.preferredGrind,
      preferredRoast: preferredRoast ?? this.preferredRoast,
    );
  }
}
