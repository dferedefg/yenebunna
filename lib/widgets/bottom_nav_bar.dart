import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

class BunnaBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final int cartItemCount;
  final int unreadAlertCount;

  const BunnaBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.cartItemCount = 0,
    this.unreadAlertCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      _NavSpec(
        icon: Icons.public_outlined,
        activeIcon: Icons.public,
        label: 'Terroir',
        amharic: 'መነሻ',
      ),
      _NavSpec(
        icon: Icons.local_fire_department_outlined,
        activeIcon: Icons.local_fire_department,
        label: 'Roasters',
        amharic: 'መቁያ',
      ),
      _NavSpec(
        icon: Icons.delivery_dining_outlined,
        activeIcon: Icons.delivery_dining,
        label: 'Orders',
        amharic: 'ትዕዛዞች',
      ),
      _NavSpec(
        icon: Icons.shopping_bag_outlined,
        activeIcon: Icons.shopping_bag,
        label: 'Bag & Sub',
        amharic: 'ቅርጫት',
        badge: cartItemCount,
      ),
      _NavSpec(
        icon: Icons.person_outline,
        activeIcon: Icons.person,
        label: 'Profile',
        amharic: 'መገለጫ',
        badge: unreadAlertCount,
      ),
    ];

    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.surfaceCard,
        border: Border(
          top: BorderSide(color: AppTheme.borderSubtle, width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 66,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              final spec = items[index];
              final isSelected = index == currentIndex;
              return Expanded(
                child: InkWell(
                  onTap: () => onTap(index),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Icon(
                            isSelected ? spec.activeIcon : spec.icon,
                            size: 22,
                            color: isSelected
                                ? AppTheme.accentGold
                                : AppTheme.textMuted,
                          ),
                          if (spec.badge > 0)
                            Positioned(
                              right: -8,
                              top: -4,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 1),
                                decoration: BoxDecoration(
                                  color: AppTheme.accentGold,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '${spec.badge}',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        spec.label,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected
                              ? AppTheme.textPrimary
                              : AppTheme.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavSpec {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String amharic;
  final int badge;

  const _NavSpec({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.amharic,
    this.badge = 0,
  });
}
