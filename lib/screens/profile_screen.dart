import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../services/cart_state.dart';
import '../widgets/roaster_dispatch_console_modal.dart';
import 'auth_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartState = CartStateScope.of(context);
    final authService = cartState.authService;
    final authUser = authService.currentUser;
    final profile = cartState.userProfile;
    final prefs = profile.notificationPreferences;
    final notifications = cartState.notifications;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Bilingual Language Switcher & Live Back4App Cloud GET Hydration Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surfaceCard,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppTheme.borderSubtle),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'PRODUCTION CLOUD & LANGUAGE · ቋንቋ እና ክላውድ',
                    style: TextStyle(
                      color: AppTheme.accentGoldLight,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    cartState.lastCloudSyncLabel,
                    style: const TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppTheme.accentGold),
                      ),
                      onPressed: cartState.toggleLanguage,
                      icon: const Icon(
                        Icons.language,
                        size: 16,
                        color: AppTheme.accentGoldLight,
                      ),
                      label: Text(
                        cartState.tr('lang_switch'),
                        style: const TextStyle(
                          color: AppTheme.accentGoldLight,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentGold,
                        foregroundColor: Colors.black,
                      ),
                      onPressed: cartState.isHydratingCloud
                          ? null
                          : () async {
                              final added =
                                  await cartState.hydrateFromBack4App();
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Back4App GET Hydration complete ($added new cloud records merged).',
                                  ),
                                ),
                              );
                            },
                      icon: const Icon(Icons.cloud_sync_outlined, size: 16),
                      label: Text(
                        cartState.isHydratingCloud
                            ? 'Syncing...'
                            : cartState.tr('sync_cloud'),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppTheme.accentGold),
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => const RoasterDispatchConsoleModal(),
                    );
                  },
                  icon: const Icon(
                    Icons.cloud_upload_outlined,
                    size: 16,
                    color: AppTheme.accentGoldLight,
                  ),
                  label: const Text(
                    '1-Click PremiumCoffee Cloud Seeder & Roaster Ops',
                    style: TextStyle(
                      color: AppTheme.accentGoldLight,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Authentication Card or Signed-In Account Card
        if (authUser == null)
          AuthScreen(authService: authService)
        else
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surfaceCard,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppTheme.borderSubtle),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${profile.loyaltyTier.toUpperCase()} · ${authUser.provider.name.toUpperCase()}',
                      style: const TextStyle(
                        color: AppTheme.accentGoldLight,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppTheme.borderSubtle),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                      ),
                      onPressed: authService.signOut,
                      icon: const Icon(Icons.logout, size: 14),
                      label: const Text(
                        'Sign Out',
                        style: TextStyle(fontSize: 11),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${authUser.fullName} (${authUser.amharicName})',
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${authUser.email} · ${profile.defaultSubCity} · ${profile.loyaltyPoints} Bunna Points',
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: profile.unlockedOriginStamps.map((stamp) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceElevated,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppTheme.borderSubtle),
                      ),
                      child: Text(
                        '✓ $stamp Stamp',
                        style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        const SizedBox(height: 16),

        // Saved Addis Ababa Delivery Addresses & Payment Methods (Back4App Address & PaymentMethod)
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surfaceCard,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppTheme.borderSubtle),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Saved Addis Ababa Addresses & Payment Accounts',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Synced with Back4App Parse Address & PaymentMethod classes',
                style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
              ),
              const SizedBox(height: 12),
              ...cartState.savedAddresses.map((addr) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  leading: Icon(
                    addr.isDefault
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                    color: AppTheme.accentGold,
                    size: 18,
                  ),
                  title: Text(
                    '${addr.label} · ${addr.subCity}',
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    '${addr.woreda} · ${addr.streetAndGateNotes}',
                    style: const TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 11,
                    ),
                  ),
                  onTap: () => cartState.setDefaultAddress(addr.id),
                );
              }),
              const Divider(height: 18),
              ...cartState.savedPaymentMethods.map((pay) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  leading: Icon(
                    pay.isDefault
                        ? Icons.account_balance_wallet
                        : Icons.account_balance_wallet_outlined,
                    color: AppTheme.accentGoldLight,
                    size: 18,
                  ),
                  title: Text(
                    '${pay.provider} (${pay.maskedAccount})',
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    'Account Holder: ${pay.accountHolder}',
                    style: const TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 11,
                    ),
                  ),
                  onTap: () => cartState.setDefaultPaymentMethod(pay.id),
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Notification Preferences & Live Sandbox
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surfaceCard,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppTheme.borderSubtle),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Notification Preferences (የማሳወቂያ ቅንብሮች)',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Configure push alerts for Roast Ready and Order Dispatched events',
                style: TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                activeThumbColor: AppTheme.accentGold,
                title: const Text(
                  "'Order Dispatched' Alerts",
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: const Text(
                  'Notify when Addis Ababa motorbike courier leaves the roastery',
                  style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
                ),
                value: prefs.orderDispatched,
                onChanged: (val) {
                  cartState.updateNotificationPreferences(
                    prefs.copyWith(orderDispatched: val),
                  );
                },
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                activeThumbColor: AppTheme.accentGold,
                title: const Text(
                  "'Roast Ready' Alerts",
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: const Text(
                  'Notify when cast-iron drum roasting completes & bag is valve-sealed',
                  style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
                ),
                value: prefs.roastReady,
                onChanged: (val) {
                  cartState.updateNotificationPreferences(
                    prefs.copyWith(roastReady: val),
                  );
                },
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                activeThumbColor: AppTheme.accentGold,
                title: const Text(
                  'Courier Proximity (<500m) Radar',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                value: prefs.proximityAlert,
                onChanged: (val) {
                  cartState.updateNotificationPreferences(
                    prefs.copyWith(proximityAlert: val),
                  );
                },
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                activeThumbColor: AppTheme.accentGold,
                title: const Text(
                  'Sound Chimes & Haptic Vibration',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                value: prefs.soundAndHaptics,
                onChanged: (val) {
                  cartState.updateNotificationPreferences(
                    prefs.copyWith(soundAndHaptics: val),
                  );
                },
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentGold,
                        foregroundColor: Colors.black,
                      ),
                      onPressed: () async {
                        final res =
                            await cartState.triggerTestRoastReadyAlert();
                        if (!context.mounted) return;
                        if (res == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "'Roast Ready' alerts are currently muted in preferences.",
                              ),
                            ),
                          );
                        }
                      },
                      child: const Text(
                        "Test 'Roast Ready'",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppTheme.accentGold),
                      ),
                      onPressed: () async {
                        final res =
                            await cartState.triggerTestOrderDispatchedAlert();
                        if (!context.mounted) return;
                        if (res == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "'Order Dispatched' alerts are currently muted in preferences.",
                              ),
                            ),
                          );
                        }
                      },
                      child: const Text(
                        "Test 'Dispatched'",
                        style: TextStyle(
                          color: AppTheme.accentGoldLight,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Notification Feed Log
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Alert Log (${notifications.length})',
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            TextButton(
              onPressed: cartState.markNotificationsRead,
              child: const Text('Mark All Read'),
            ),
          ],
        ),
        ...notifications.map((item) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.surfaceCard,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: item.isRead
                    ? AppTheme.borderSubtle
                    : AppTheme.accentGold.withValues(alpha: 0.7),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${item.type.badgeLabel} · #${item.orderNumber}',
                  style: const TextStyle(
                    color: AppTheme.accentGoldLight,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.title,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.body,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
