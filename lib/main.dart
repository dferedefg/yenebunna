import 'dart:async';
import 'package:flutter/material.dart';
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'models/notification_item.dart';
import 'screens/auth_screen.dart';
import 'screens/cart_favorites_screen.dart';
import 'screens/home_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/roasters_screen.dart';
import 'screens/splash_screen.dart';
import 'services/cart_state.dart';
import 'services/notification_service.dart';
import 'widgets/bottom_nav_bar.dart';

enum AppStartupStage { splash, onboarding, auth, home }

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const BunnaMarketplaceApp(
      initialStage: AppStartupStage.splash,
    ),
  );
}

class BunnaMarketplaceApp extends StatefulWidget {
  final AppStartupStage initialStage;

  const BunnaMarketplaceApp({
    super.key,
    this.initialStage = AppStartupStage.home,
  });

  @override
  State<BunnaMarketplaceApp> createState() => _BunnaMarketplaceAppState();
}

class _BunnaMarketplaceAppState extends State<BunnaMarketplaceApp> {
  final CartState _cartState = CartState();
  late AppStartupStage _startupStage;
  bool _dontShowOnboardingAgain = false;
  int _selectedIndex = 0;
  NotificationItem? _activeBannerAlert;
  StreamSubscription<NotificationItem>? _alertSubscription;
  Timer? _bannerDismissTimer;

  @override
  void initState() {
    super.initState();
    _startupStage = widget.initialStage;
    _cartState.hydrateFromBack4App();
    _alertSubscription =
        MockNotificationService.instance.alertStream.listen((alert) {
      _bannerDismissTimer?.cancel();
      setState(() => _activeBannerAlert = alert);
      _bannerDismissTimer = Timer(const Duration(seconds: 4), () {
        if (mounted) {
          setState(() => _activeBannerAlert = null);
        }
      });
    });
  }

  @override
  void dispose() {
    _alertSubscription?.cancel();
    _bannerDismissTimer?.cancel();
    _cartState.dispose();
    super.dispose();
  }

  Widget _buildActiveRoot() {
    if (_startupStage == AppStartupStage.splash) {
      return SplashScreen(
        onComplete: () {
          setState(() {
            _startupStage = _dontShowOnboardingAgain
                ? AppStartupStage.auth
                : AppStartupStage.onboarding;
          });
        },
      );
    }

    if (_startupStage == AppStartupStage.onboarding) {
      return OnboardingScreen(
        initialDontShowAgain: _dontShowOnboardingAgain,
        onFinish: ({required bool dontShowAgain}) {
          setState(() {
            _dontShowOnboardingAgain = dontShowAgain;
            _startupStage = AppStartupStage.auth;
          });
        },
      );
    }

    if (_startupStage == AppStartupStage.auth) {
      return Scaffold(
        backgroundColor: AppTheme.bgDark,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: AuthScreen(
                  authService: _cartState.authService,
                  onBackToOnboarding: () {
                    setState(() => _startupStage = AppStartupStage.onboarding);
                  },
                  onSkipToHome: () {
                    setState(() => _startupStage = AppStartupStage.home);
                  },
                  onAuthSuccess: () {
                    setState(() => _startupStage = AppStartupStage.home);
                  },
                ),
              ),
            ),
          ),
        ),
      );
    }

    final screens = const [
      HomeScreen(),
      RoastersScreen(),
      OrdersScreen(),
      CartFavoritesScreen(),
      ProfileScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Text(
              'Yene Bunna · የኔ ቡና',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 19,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _dontShowOnboardingAgain = false;
                _startupStage = AppStartupStage.splash;
              });
            },
            child: const Text(
              'Intro',
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 12,
              ),
            ),
          ),
          TextButton(
            onPressed: _cartState.toggleLanguage,
            child: Text(
              _cartState.language.badgeLabel,
              style: const TextStyle(
                color: AppTheme.accentGoldLight,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          TextButton.icon(
            onPressed: () => setState(() => _selectedIndex = 2),
            icon: const Icon(
              Icons.local_shipping_outlined,
              size: 16,
              color: AppTheme.accentGoldLight,
            ),
            label: Text(
              '#${_cartState.activeOrder.orderNumber}',
              style: const TextStyle(
                color: AppTheme.accentGoldLight,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          IndexedStack(
            index: _selectedIndex,
            children: screens,
          ),
          if (_activeBannerAlert != null)
            Positioned(
              top: 10,
              left: 14,
              right: 14,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceElevated,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppTheme.accentGold,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.notifications_active,
                        color: AppTheme.accentGoldLight,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _activeBannerAlert!.title,
                              style: const TextStyle(
                                color: AppTheme.textPrimary,
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              _activeBannerAlert!.body,
                              style: const TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () =>
                            setState(() => _activeBannerAlert = null),
                        icon: const Icon(Icons.close, size: 18),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BunnaBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: (idx) => setState(() => _selectedIndex = idx),
        cartItemCount: _cartState.items.length,
        unreadAlertCount: _cartState.unreadNotificationCount,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CartStateScope(
      notifier: _cartState,
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: AnimatedBuilder(
          animation: _cartState,
          builder: (context, _) => _buildActiveRoot(),
        ),
      ),
    );
  }
}
