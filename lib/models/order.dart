import 'coffee_bean.dart';

enum OrderStatus {
  roasting,
  roastReady,
  outForDelivery,
  delivered;

  String get displayName {
    switch (this) {
      case OrderStatus.roasting:
        return 'Drum Roasting in Progress';
      case OrderStatus.roastReady:
        return 'Roast Ready & Valve-Sealed';
      case OrderStatus.outForDelivery:
        return 'Out for Delivery (Addis Courier)';
      case OrderStatus.delivered:
        return 'Delivered';
    }
  }

  String get amharicTitle {
    switch (this) {
      case OrderStatus.roasting:
        return 'በመቆላት ላይ';
      case OrderStatus.roastReady:
        return 'ቆሎው ተዘጋጅቷል';
      case OrderStatus.outForDelivery:
        return 'በመንገድ ላይ';
      case OrderStatus.delivered:
        return 'ደርሷል';
    }
  }
}

class OrderItem {
  final CoffeeBean bean;
  final double quantityKg;
  final RoastLevel roastLevel;
  final GrindType grindType;
  final DeliveryFrequency frequency;

  const OrderItem({
    required this.bean,
    required this.quantityKg,
    required this.roastLevel,
    required this.grindType,
    this.frequency = DeliveryFrequency.oneTime,
  });

  int get lineTotalETB {
    final base = (bean.pricePerKgETB * quantityKg).round();
    final discount = (base * frequency.discountRate).round();
    return base - discount;
  }
}

class Order {
  final String id;
  final String orderNumber;
  final List<OrderItem> items;
  final int totalETB;
  final OrderStatus status;
  final String roasteryName;
  final String courierName;
  final String courierPhone;
  final String courierPlate;
  final String destinationAddress;
  final int estimatedMinutesRemaining;
  final int distanceMeters;
  final String activeCorridor;
  final double corridorSpeedKmh;
  final String createdAtLabel;
  final String batchCode;

  const Order({
    required this.id,
    required this.orderNumber,
    required this.items,
    required this.totalETB,
    required this.status,
    required this.roasteryName,
    required this.courierName,
    required this.courierPhone,
    required this.courierPlate,
    required this.destinationAddress,
    required this.estimatedMinutesRemaining,
    required this.distanceMeters,
    required this.activeCorridor,
    required this.corridorSpeedKmh,
    required this.createdAtLabel,
    required this.batchCode,
  });

  Order copyWith({
    OrderStatus? status,
    int? estimatedMinutesRemaining,
    int? distanceMeters,
  }) {
    return Order(
      id: id,
      orderNumber: orderNumber,
      items: items,
      totalETB: totalETB,
      status: status ?? this.status,
      roasteryName: roasteryName,
      courierName: courierName,
      courierPhone: courierPhone,
      courierPlate: courierPlate,
      destinationAddress: destinationAddress,
      estimatedMinutesRemaining:
          estimatedMinutesRemaining ?? this.estimatedMinutesRemaining,
      distanceMeters: distanceMeters ?? this.distanceMeters,
      activeCorridor: activeCorridor,
      corridorSpeedKmh: corridorSpeedKmh,
      createdAtLabel: createdAtLabel,
      batchCode: batchCode,
    );
  }
}
