import 'dart:async';
import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const SplashScreen({
    super.key,
    required this.onComplete,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _progress = 0.2;
  Timer? _progressTimer;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();
    _progressTimer = Timer.periodic(const Duration(milliseconds: 220), (_) {
      if (!mounted) return;
      setState(() {
        _progress = (_progress + 0.18).clamp(0.0, 1.0);
      });
    });

    _navigationTimer = Timer(const Duration(milliseconds: 1650), () {
      if (mounted) {
        widget.onComplete();
      }
    });
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    _navigationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'YENE BUNNA · ADDIS ABABA',
                    style: TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                  TextButton(
                    onPressed: widget.onComplete,
                    child: const Text(
                      'Skip Splash →',
                      style: TextStyle(
                        color: AppTheme.accentGoldLight,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 82,
                    height: 82,
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceCard,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: AppTheme.accentGold,
                        width: 1.5,
                      ),
                    ),
                    child: const Icon(
                      Icons.local_fire_department_outlined,
                      color: AppTheme.accentGoldLight,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'የኔ ቡና · DIRECT-FROM-ORIGIN COFFEE HOUSE',
                    style: TextStyle(
                      color: AppTheme.accentGoldLight,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Yene Bunna',
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 38,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Single-Origin Ethiopian Highland Terroir · Live Addis Ababa Cast-Iron Drum Roasting',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: 240,
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: _progress,
                            minHeight: 6,
                            backgroundColor: AppTheme.surfaceElevated,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AppTheme.accentGold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Calibrating ECX Terroir & Parse Sync (${(_progress * 100).round()}%)',
                          style: const TextStyle(
                            color: AppTheme.textMuted,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Text(
                'Yirgacheffe · Guji · Sidama · Harar · Limu · Keffa',
                style: TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
