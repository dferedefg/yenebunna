import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';
import '../core/l10n/app_localizations.dart';
import '../data/coffee_seed_data.dart';
import '../models/address_payment.dart';
import '../models/coffee_bean.dart';
import '../models/notification_item.dart';
import '../models/order.dart';
import '../models/review.dart';
import '../models/subscription_schedule.dart';
import '../models/user_profile.dart';
import 'auth_service.dart';
import 'notification_service.dart';
import 'parse_service.dart';

class CartState extends ChangeNotifier {
  final AuthService authService = AuthService();

  CartState() {
    authService.addListener(notifyListeners);
  }

  AppLanguage _language = AppLanguage.en;
  bool _isHydratingCloud = false;
  String _lastCloudSyncLabel = 'Ready to hydrate';

  final List<OrderItem> _items = [
    OrderItem(
      bean: CoffeeSeedData.beans[0],
      quantityKg: 0.5,
      roastLevel: RoastLevel.light,
      grindType: GrindType.wholeBean,
      frequency: DeliveryFrequency.biWeekly,
    ),
    OrderItem(
      bean: CoffeeSeedData.beans[2],
      quantityKg: 0.5,
      roastLevel: RoastLevel.medium,
      grindType: GrindType.jebenaFine,
      frequency: DeliveryFrequency.biWeekly,
    ),
  ];

  final Set<String> _favoriteBeanIds = {
    'yirgacheffe-kochere-g1',
    'guji-uraga-anaerobic',
    'limu-kossa-gesha',
  };

  final List<MarketplaceReview> _reviews = [
    const MarketplaceReview(
      id: 'rev-1',
      beanId: 'yirgacheffe-kochere-g1',
      authorName: 'Meron Tadesse',
      rating: 5,
      brewMethod: 'V60 / Pour-Over',
      comment:
          'Incredibly clean bergamot and white jasmine aroma. Brewed at 93°C on a Hario V60—tastes like a championship lot.',
      createdAtLabel: '2 days ago',
    ),
    const MarketplaceReview(
      id: 'rev-2',
      beanId: 'guji-uraga-anaerobic',
      authorName: 'Yohannes Kebede',
      rating: 5,
      brewMethod: 'Espresso Fine',
      comment:
          'Syrupy blueberry and dark cacao notes. Pulls a thick tiger-striped crema on my home espresso machine.',
      createdAtLabel: '4 days ago',
    ),
    const MarketplaceReview(
      id: 'rev-3',
      beanId: 'addis-ceremonial-blend',
      authorName: 'Hanna Alemu',
      rating: 5,
      brewMethod: 'Jebena Fine (Traditional)',
      comment:
          'Our family used this blend for Sunday Abol, Tona, and Baraka pours. Rich Harar mocha body with sweet Sidama finish!',
      createdAtLabel: '5 days ago',
    ),
  ];

  final List<SavedAddress> _savedAddresses = [
    const SavedAddress(
      id: 'addr-1',
      label: 'Home Residence',
      subCity: 'Bole Medhanialem (ቦሌ መድኃኔዓለም)',
      woreda: 'Woreda 03',
      streetAndGateNotes: 'Behind Edna Mall, Green Gate #402',
      isDefault: true,
    ),
    const SavedAddress(
      id: 'addr-2',
      label: 'Kazanchis Studio Office',
      subCity: 'Kirkos — Kazanchis (ቂርቆስ ካዛንቺስ)',
      woreda: 'Woreda 08',
      streetAndGateNotes: 'Near ECA Compound, 4th Floor Suite B',
      isDefault: false,
    ),
  ];

  final List<SavedPaymentMethod> _savedPaymentMethods = [
    const SavedPaymentMethod(
      id: 'pay-1',
      provider: 'Telebirr Instant (ቴሌብር)',
      accountHolder: 'Dawit Gebremedhin',
      maskedAccount: '+251 911 ••• 482',
      isDefault: true,
    ),
    const SavedPaymentMethod(
      id: 'pay-2',
      provider: 'CBE Birr Mobile (ሲቢኢ ብር)',
      accountHolder: 'Dawit Gebremedhin',
      maskedAccount: '100028•••••94',
      isDefault: false,
    ),
  ];

  SubscriptionSchedule _subscription = const SubscriptionSchedule(
    isActive: true,
    frequency: DeliveryFrequency.biWeekly,
    preferredDay: 'Friday Morning',
    timeWindow: '8:00 AM – 11:00 AM',
    roastersChoiceRotation: true,
    selectedBeanIds: ['yirgacheffe-kochere-g1', 'sidama-bensa-bombe'],
  );

  Order _activeOrder = CoffeeSeedData.initialActiveOrder;
  final List<Order> _pastOrders = List.of(CoffeeSeedData.pastOrders);
  UserProfile _userProfile = CoffeeSeedData.initialUserProfile;
  String? _selectedRegion;
  String _appliedPromoCode = '';

  AppLanguage get language => _language;
  bool get isHydratingCloud => _isHydratingCloud;
  String get lastCloudSyncLabel => _lastCloudSyncLabel;
  List<OrderItem> get items => List.unmodifiable(_items);
  Set<String> get favoriteBeanIds => Set.unmodifiable(_favoriteBeanIds);
  List<MarketplaceReview> get reviews => List.unmodifiable(_reviews);
  List<SavedAddress> get savedAddresses => List.unmodifiable(_savedAddresses);
  List<SavedPaymentMethod> get savedPaymentMethods =>
      List.unmodifiable(_savedPaymentMethods);
  SubscriptionSchedule get subscription => _subscription;
  Order get activeOrder => _activeOrder;
  List<Order> get pastOrders => List.unmodifiable(_pastOrders);
  UserProfile get userProfile => _userProfile;
  String? get selectedRegion => _selectedRegion;
  String get appliedPromoCode => _appliedPromoCode;

  List<NotificationItem> get notifications =>
      MockNotificationService.instance.history;

  int get unreadNotificationCount =>
      MockNotificationService.instance.unreadCount;

  String tr(String key) => AppStrings.of(_language, key);

  void toggleLanguage() {
    _language =
        _language == AppLanguage.en ? AppLanguage.am : AppLanguage.en;
    notifyListeners();
  }

  Future<int> hydrateFromBack4App() async {
    _isHydratingCloud = true;
    notifyListeners();
    final remoteReviews = await ParseService.instance.fetchReviewsFromParse();
    var mergedCount = 0;
    for (final rev in remoteReviews) {
      final exists = _reviews.any((r) => r.id == rev.id);
      if (!exists) {
        _reviews.insert(0, rev);
        mergedCount++;
      }
    }
    _isHydratingCloud = false;
    _lastCloudSyncLabel =
        'Hydrated ${_reviews.length} reviews (${mergedCount} new from Parse)';
    notifyListeners();
    return mergedCount;
  }

  List<MarketplaceReview> reviewsForBean(String beanId) {
    return _reviews.where((r) => r.beanId == beanId).toList();
  }

  Future<void> addReview({
    required String beanId,
    required int rating,
    required String brewMethod,
    required String comment,
  }) async {
    final author = authService.currentUser?.fullName ?? _userProfile.fullName;
    final review = MarketplaceReview(
      id: 'rev-${DateTime.now().millisecondsSinceEpoch}',
      beanId: beanId,
      authorName: author,
      rating: rating,
      brewMethod: brewMethod,
      comment: comment,
      createdAtLabel: 'Just now',
    );
    _reviews.insert(0, review);
    notifyListeners();
    await ParseService.instance.saveReviewToParse(
      review,
      sessionToken: authService.currentUser?.sessionToken,
    );
  }

  Future<void> addSavedAddress({
    required String label,
    required String subCity,
    required String woreda,
    required String streetAndGateNotes,
  }) async {
    final newAddr = SavedAddress(
      id: 'addr-${DateTime.now().millisecondsSinceEpoch}',
      label: label,
      subCity: subCity,
      woreda: woreda,
      streetAndGateNotes: streetAndGateNotes,
      isDefault: _savedAddresses.isEmpty,
    );
    _savedAddresses.add(newAddr);
    notifyListeners();
    await ParseService.instance.saveAddressToParse(
      newAddr,
      sessionToken: authService.currentUser?.sessionToken,
    );
  }

  void setDefaultAddress(String id) {
    for (var i = 0; i < _savedAddresses.length; i++) {
      final addr = _savedAddresses[i];
      _savedAddresses[i] = addr.copyWith(isDefault: addr.id == id);
      if (addr.id == id) {
        _userProfile = _userProfile.copyWith(defaultSubCity: addr.subCity);
      }
    }
    notifyListeners();
  }

  Future<void> addSavedPaymentMethod({
    required String provider,
    required String accountHolder,
    required String maskedAccount,
  }) async {
    final newPay = SavedPaymentMethod(
      id: 'pay-${DateTime.now().millisecondsSinceEpoch}',
      provider: provider,
      accountHolder: accountHolder,
      maskedAccount: maskedAccount,
      isDefault: _savedPaymentMethods.isEmpty,
    );
    _savedPaymentMethods.add(newPay);
    notifyListeners();
    await ParseService.instance.savePaymentMethodToParse(
      newPay,
      sessionToken: authService.currentUser?.sessionToken,
    );
  }

  void setDefaultPaymentMethod(String id) {
    for (var i = 0; i < _savedPaymentMethods.length; i++) {
      final pay = _savedPaymentMethods[i];
      _savedPaymentMethods[i] = pay.copyWith(isDefault: pay.id == id);
    }
    notifyListeners();
  }

  void selectRegion(String? region) {
    if (_selectedRegion == region) {
      _selectedRegion = null;
    } else {
      _selectedRegion = region;
    }
    notifyListeners();
  }

  bool isFavorite(String beanId) => _favoriteBeanIds.contains(beanId);

  void toggleFavorite(String beanId) {
    if (_favoriteBeanIds.contains(beanId)) {
      _favoriteBeanIds.remove(beanId);
    } else {
      _favoriteBeanIds.add(beanId);
      ParseService.instance.saveFavoriteItemToParse(
        beanId,
        sessionToken: authService.currentUser?.sessionToken,
      );
    }
    notifyListeners();
  }

  void addToCart({
    required CoffeeBean bean,
    double quantityKg = 0.5,
    RoastLevel? roastLevel,
    GrindType grindType = GrindType.wholeBean,
    DeliveryFrequency? frequency,
  }) {
    final chosenRoast = roastLevel ?? bean.defaultRoast;
    final chosenFreq = frequency ??
        (_subscription.isActive
            ? _subscription.frequency
            : DeliveryFrequency.oneTime);

    final existingIndex = _items.indexWhere(
      (i) =>
          i.bean.id == bean.id &&
          i.roastLevel == chosenRoast &&
          i.grindType == grindType,
    );

    if (existingIndex >= 0) {
      final current = _items[existingIndex];
      _items[existingIndex] = OrderItem(
        bean: current.bean,
        quantityKg:
            double.parse((current.quantityKg + quantityKg).toStringAsFixed(2)),
        roastLevel: current.roastLevel,
        grindType: current.grindType,
        frequency: chosenFreq,
      );
    } else {
      _items.add(
        OrderItem(
          bean: bean,
          quantityKg: quantityKg,
          roastLevel: chosenRoast,
          grindType: grindType,
          frequency: chosenFreq,
        ),
      );
    }
    notifyListeners();
  }

  void updateItemQuantity(int index, double deltaKg) {
    if (index < 0 || index >= _items.length) return;
    final updated = _items[index].quantityKg + deltaKg;
    if (updated <= 0.1) {
      _items.removeAt(index);
    } else {
      final current = _items[index];
      _items[index] = OrderItem(
        bean: current.bean,
        quantityKg: double.parse(updated.toStringAsFixed(2)),
        roastLevel: current.roastLevel,
        grindType: current.grindType,
        frequency: current.frequency,
      );
    }
    notifyListeners();
  }

  void removeCartItem(int index) {
    if (index < 0 || index >= _items.length) return;
    _items.removeAt(index);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  void updateSubscription(SubscriptionSchedule nextSchedule) {
    _subscription = nextSchedule;
    notifyListeners();
  }

  void toggleBeanInSubscription(String beanId) {
    final currentList = List<String>.from(_subscription.selectedBeanIds);
    if (currentList.contains(beanId)) {
      if (currentList.length > 1) {
        currentList.remove(beanId);
      }
    } else {
      currentList.add(beanId);
    }
    _subscription = _subscription.copyWith(selectedBeanIds: currentList);
    notifyListeners();
  }

  void applyPromoCode(String code) {
    _appliedPromoCode = code.trim().toUpperCase();
    notifyListeners();
  }

  int get subtotalETB {
    return _items.fold(0, (sum, item) => sum + item.lineTotalETB);
  }

  int get subscriptionSavingsETB {
    if (!_subscription.isActive) return 0;
    return (subtotalETB * _subscription.frequency.discountRate).round();
  }

  int get promoDiscountETB {
    if (_appliedPromoCode == 'BUNA10') {
      return (subtotalETB * 0.10).round();
    }
    if (_appliedPromoCode == 'HABESHA20') {
      return (subtotalETB * 0.20).round();
    }
    return 0;
  }

  int get deliveryFeeETB {
    if (_items.isEmpty) return 0;
    if (_appliedPromoCode == 'ADDISFREESHIP' ||
        subtotalETB >= AppConstants.freeDeliveryThresholdETB) {
      return 0;
    }
    return AppConstants.standardDeliveryFeeETB;
  }

  int get grandTotalETB {
    final afterDiscounts =
        (subtotalETB - subscriptionSavingsETB - promoDiscountETB)
            .clamp(0, 999999);
    return afterDiscounts + deliveryFeeETB;
  }

  Future<Order?> placeCheckoutOrder({
    required String subCity,
    required String paymentMethod,
    String? paymentReference,
  }) async {
    if (_items.isEmpty) return null;
    final newOrderNum = 'YB-${9100 + DateTime.now().millisecond % 899}';
    final firstBean = _items.first.bean;
    final created = Order(
      id: 'ord-${DateTime.now().millisecondsSinceEpoch}',
      orderNumber: newOrderNum,
      items: List.of(_items),
      totalETB: grandTotalETB,
      status: OrderStatus.roasting,
      roasteryName: firstBean.roasterName,
      courierName: 'Samuel Bekele',
      courierPhone: '+251 911 894 210',
      courierPlate: 'AA-2-C1940',
      destinationAddress: subCity,
      estimatedMinutesRemaining: 24,
      distanceMeters: 2300,
      activeCorridor: 'Africa Ave (Bole Road)',
      corridorSpeedKmh: 29.0,
      createdAtLabel: 'Just now',
      batchCode: 'BATCH-ETH-2610-A',
    );
    _activeOrder = created;
    _items.clear();
    _userProfile = _userProfile.copyWith(
      loyaltyPoints: _userProfile.loyaltyPoints + 120,
      defaultSubCity: subCity,
    );
    notifyListeners();

    await ParseService.instance.saveOrderToParse(
      created,
      sessionToken: authService.currentUser?.sessionToken,
      paymentReference: paymentReference,
    );

    await MockNotificationService.instance.triggerRoastReady(
      orderNumber: newOrderNum,
      beanName: firstBean.name,
      roasteryName: firstBean.roasterName,
      prefs: _userProfile.notificationPreferences,
    );
    notifyListeners();
    return created;
  }

  Future<void> advanceActiveOrderStage() async {
    final currentStatus = _activeOrder.status;
    if (currentStatus == OrderStatus.roasting) {
      _activeOrder = _activeOrder.copyWith(
        status: OrderStatus.roastReady,
        estimatedMinutesRemaining: 19,
        distanceMeters: 1850,
      );
      await MockNotificationService.instance.triggerRoastReady(
        orderNumber: _activeOrder.orderNumber,
        beanName: _activeOrder.items.first.bean.name,
        roasteryName: _activeOrder.roasteryName,
        prefs: _userProfile.notificationPreferences,
      );
    } else if (currentStatus == OrderStatus.roastReady) {
      _activeOrder = _activeOrder.copyWith(
        status: OrderStatus.outForDelivery,
        estimatedMinutesRemaining: 11,
        distanceMeters: 460,
      );
      await MockNotificationService.instance.triggerOrderDispatched(
        orderNumber: _activeOrder.orderNumber,
        courierName: _activeOrder.courierName,
        courierPlate: _activeOrder.courierPlate,
        destination: _activeOrder.destinationAddress,
        etaMinutes: 11,
        prefs: _userProfile.notificationPreferences,
      );
    } else if (currentStatus == OrderStatus.outForDelivery) {
      _activeOrder = _activeOrder.copyWith(
        status: OrderStatus.delivered,
        estimatedMinutesRemaining: 0,
        distanceMeters: 0,
      );
      _pastOrders.insert(0, _activeOrder);
    } else {
      _activeOrder = _activeOrder.copyWith(
        status: OrderStatus.roasting,
        estimatedMinutesRemaining: 22,
        distanceMeters: 2100,
      );
    }
    notifyListeners();
  }

  void reorderPastOrder(Order order) {
    for (final item in order.items) {
      addToCart(
        bean: item.bean,
        quantityKg: item.quantityKg,
        roastLevel: item.roastLevel,
        grindType: item.grindType,
        frequency: item.frequency,
      );
    }
  }

  void updateNotificationPreferences(NotificationPreferences nextPrefs) {
    _userProfile = _userProfile.copyWith(notificationPreferences: nextPrefs);
    notifyListeners();
  }

  Future<NotificationItem?> triggerTestRoastReadyAlert() async {
    final res = await MockNotificationService.instance.triggerRoastReady(
      orderNumber: _activeOrder.orderNumber,
      beanName: 'Yirgacheffe Kochere Grade 1',
      roasteryName: 'Galani Artisan Roasters',
      prefs: _userProfile.notificationPreferences,
    );
    notifyListeners();
    return res;
  }

  Future<NotificationItem?> triggerTestOrderDispatchedAlert() async {
    final res = await MockNotificationService.instance.triggerOrderDispatched(
      orderNumber: _activeOrder.orderNumber,
      courierName: _activeOrder.courierName,
      courierPlate: _activeOrder.courierPlate,
      destination: _activeOrder.destinationAddress,
      etaMinutes: 12,
      prefs: _userProfile.notificationPreferences,
    );
    notifyListeners();
    return res;
  }

  void markNotificationsRead() {
    MockNotificationService.instance.markAllRead();
    notifyListeners();
  }
}

class CartStateScope extends InheritedNotifier<CartState> {
  const CartStateScope({
    super.key,
    required CartState notifier,
    required super.child,
  }) : super(notifier: notifier);

  static CartState of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<CartStateScope>();
    assert(scope != null, 'No CartStateScope found in widget tree');
    return scope!.notifier!;
  }
}
