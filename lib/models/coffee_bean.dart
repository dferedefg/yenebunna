enum RoastLevel {
  light,
  medium,
  dark,
  green;

  String get displayName {
    switch (this) {
      case RoastLevel.light:
        return 'Light Filter Roast';
      case RoastLevel.medium:
        return 'Medium Omni Roast';
      case RoastLevel.dark:
        return 'Dark Jebena Roast';
      case RoastLevel.green:
        return 'Raw Green Beans';
    }
  }

  String get shortLabel {
    switch (this) {
      case RoastLevel.light:
        return 'Light Roast';
      case RoastLevel.medium:
        return 'Medium Roast';
      case RoastLevel.dark:
        return 'Dark Roast';
      case RoastLevel.green:
        return 'Green Beans';
    }
  }

  String get amharicLabel {
    switch (this) {
      case RoastLevel.light:
        return 'ቀላል ቆሎ';
      case RoastLevel.medium:
        return 'መካከለኛ ቆሎ';
      case RoastLevel.dark:
        return 'ጠቆር ያለ ቆሎ';
      case RoastLevel.green:
        return 'ጥሬ ቡና';
    }
  }
}

enum GrindType {
  wholeBean,
  jebenaFine,
  pourOver,
  espresso,
  frenchPress;

  String get displayName {
    switch (this) {
      case GrindType.wholeBean:
        return 'Whole Bean';
      case GrindType.jebenaFine:
        return 'Jebena Fine (Traditional)';
      case GrindType.pourOver:
        return 'V60 / Pour-Over';
      case GrindType.espresso:
        return 'Espresso Fine';
      case GrindType.frenchPress:
        return 'Coarse / French Press';
    }
  }
}

enum DeliveryFrequency {
  oneTime,
  weekly,
  biWeekly,
  monthly;

  String get displayName {
    switch (this) {
      case DeliveryFrequency.oneTime:
        return 'One-Time Roast Drop';
      case DeliveryFrequency.weekly:
        return 'Weekly Replenishment (-15%)';
      case DeliveryFrequency.biWeekly:
        return 'Bi-Weekly Replenishment (-12%)';
      case DeliveryFrequency.monthly:
        return 'Monthly Replenishment (-10%)';
    }
  }

  double get discountRate {
    switch (this) {
      case DeliveryFrequency.oneTime:
        return 0.0;
      case DeliveryFrequency.weekly:
        return 0.15;
      case DeliveryFrequency.biWeekly:
        return 0.12;
      case DeliveryFrequency.monthly:
        return 0.10;
    }
  }
}

class FlavorProfile {
  final int floral;
  final int citrus;
  final int sweetness;
  final int body;
  final int acidity;

  const FlavorProfile({
    required this.floral,
    required this.citrus,
    required this.sweetness,
    required this.body,
    required this.acidity,
  });
}

class CoffeeBean {
  final String id;
  final String name;
  final String amharicName;
  final String category; // 'Single Origin' or 'Blends'
  final String region;
  final String subRegion;
  final String elevation;
  final String processMethod;
  final String varietal;
  final double cupScore;
  final int pricePerKgETB;
  final List<String> flavorNotes;
  final String roasterName;
  final String harvestYear;
  final String story;
  final FlavorProfile flavorProfile;
  final RoastLevel defaultRoast;

  const CoffeeBean({
    required this.id,
    required this.name,
    required this.amharicName,
    this.category = 'Single Origin',
    required this.region,
    required this.subRegion,
    required this.elevation,
    required this.processMethod,
    required this.varietal,
    required this.cupScore,
    required this.pricePerKgETB,
    required this.flavorNotes,
    required this.roasterName,
    required this.harvestYear,
    required this.story,
    required this.flavorProfile,
    this.defaultRoast = RoastLevel.medium,
  });
}
