class Roastery {
  final String id;
  final String name;
  final String amharicName;
  final String district;
  final String masterRoaster;
  final double rating;
  final int reviewsCount;
  final bool isLiveRoasting;
  final String currentBatchBean;
  final int drumTemperatureCelsius;
  final int roastProgressPercent;
  final int avgDispatchMinutes;
  final String specialtyFocus;
  final double distanceKm;

  const Roastery({
    required this.id,
    required this.name,
    required this.amharicName,
    required this.district,
    required this.masterRoaster,
    required this.rating,
    required this.reviewsCount,
    required this.isLiveRoasting,
    required this.currentBatchBean,
    required this.drumTemperatureCelsius,
    required this.roastProgressPercent,
    required this.avgDispatchMinutes,
    required this.specialtyFocus,
    required this.distanceKm,
  });
}
