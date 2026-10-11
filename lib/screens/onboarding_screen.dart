import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

class OnboardingSlideData {
  final String stepLabel;
  final String amharicKicker;
  final String title;
  final String subtitle;
  final List<String> highlights;
  final IconData icon;

  const OnboardingSlideData({
    required this.stepLabel,
    required this.amharicKicker,
    required this.title,
    required this.subtitle,
    required this.highlights,
    required this.icon,
  });
}

class OnboardingScreen extends StatefulWidget {
  final bool initialDontShowAgain;
  final void Function({required bool dontShowAgain}) onFinish;

  const OnboardingScreen({
    super.key,
    this.initialDontShowAgain = false,
    required this.onFinish,
  });

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  late bool _dontShowAgain;

  static const List<OnboardingSlideData> _slides = [
    OnboardingSlideData(
      stepLabel: '01 / 03',
      amharicKicker: 'ምዕራፍ ፩ · ከምንጩ የተመረጠ ምርጥ ቡና',
      title: 'Direct-from-Origin Ethiopian Highland Terroir',
      subtitle:
          'Explore single-origin micro-lots and signature blends from Yirgacheffe, Guji, Sidama, Harar, Limu, and Keffa with verified ECX Grade-1 Q-Grader scores (88.8–91.8 SCA).',
      highlights: [
        'Interactive 6-region Ethiopian Rift Valley terroir map',
        'ECX Lot QR traceability & washing station GPS coordinates',
        'High-altitude 1,850m–2,320m MASL heirloom arabica lots',
      ],
      icon: Icons.terrain_outlined,
    ),
    OnboardingSlideData(
      stepLabel: '02 / 03',
      amharicKicker: 'ምዕራፍ ፪ · ትኩስ ቆሎ እና የጀበና ሥነ-ሥርዓት',
      title: 'Artisan Cast-Iron Drum Roasting & Jebena Ceremony',
      subtitle:
          'Roasted to order in Bole, Kazanchis, Piazza, and Old Airport. Select custom grind profiles for Traditional Clay Jebena (Abol, Tona, Baraka), V60 Pour-Over, or Espresso.',
      highlights: [
        'Live 18-minute cast-iron drum temperature telemetry',
        'Book in-person Roastery Cupping Flights & Jebena tours',
        'Built-in 3-stage Traditional Jebena Ceremony timer',
      ],
      icon: Icons.local_fire_department_outlined,
    ),
    OnboardingSlideData(
      stepLabel: '03 / 03',
      amharicKicker: 'ምዕራፍ ፫ · ፈጣን አቅርቦት እና አስተማማኝ ክፍያ',
      title: '22-Minute Addis Courier Dispatch & Verified Payments',
      subtitle:
          'Track your motorbike courier live across Addis Ababa corridors with 500m proximity radar, recurring Buna replenishment (-15% Weekly), and Telebirr / Chapa verification.',
      highlights: [
        'Live Addis Ababa motorbike radar & Roast Ready push alerts',
        'Telebirr, CBE Birr & Chapa USSD/PIN verified checkout',
        'Official 15% Ethiopian VAT tax invoices (TIN 0049182736)',
      ],
      icon: Icons.delivery_dining_outlined,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _dontShowAgain = widget.initialDontShowAgain;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _handleNext() {
    if (_currentIndex < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
      );
    } else {
      widget.onFinish(dontShowAgain: _dontShowAgain);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Top Bar with Skip & Don't Show Again Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Yene Bunna · Step ${_slides[_currentIndex].stepLabel}',
                    style: const TextStyle(
                      color: AppTheme.accentGoldLight,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () =>
                            widget.onFinish(dontShowAgain: true),
                        child: const Text(
                          "Don't Show Again",
                          style: TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppTheme.accentGold),
                        ),
                        onPressed: () =>
                            widget.onFinish(dontShowAgain: _dontShowAgain),
                        child: const Text(
                          'Skip (ዝለል) →',
                          style: TextStyle(
                            color: AppTheme.accentGoldLight,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 3 Onboarding Slides PageView
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _slides.length,
                  onPageChanged: (idx) => setState(() => _currentIndex = idx),
                  itemBuilder: (context, idx) {
                    final slide = _slides[idx];
                    return Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceCard,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: AppTheme.borderSubtle),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: AppTheme.surfaceElevated,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppTheme.accentGold),
                              ),
                              child: Icon(
                                slide.icon,
                                color: AppTheme.accentGoldLight,
                                size: 28,
                              ),
                            ),
                            const SizedBox(height: 18),
                            Text(
                              slide.amharicKicker,
                              style: const TextStyle(
                                color: AppTheme.accentGoldLight,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              slide.title,
                              style: const TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              slide.subtitle,
                              style: const TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 14,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 20),
                            ...slide.highlights.map(
                              (h) => Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.check_circle_outline,
                                      color: AppTheme.accentGold,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        h,
                                        style: const TextStyle(
                                          color: AppTheme.textPrimary,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 14),

              // "Don't show onboarding again" Checkbox
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: AppTheme.accentGold,
                checkColor: Colors.black,
                value: _dontShowAgain,
                onChanged: (val) =>
                    setState(() => _dontShowAgain = val ?? false),
                title: const Text(
                  "Don't show onboarding screens again (ይህን መግቢያ ዳግም አታሳይ)",
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ),

              // Slide Indicators & Next/Continue Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: List.generate(_slides.length, (idx) {
                      final active = idx == _currentIndex;
                      return Container(
                        margin: const EdgeInsets.only(right: 6),
                        width: active ? 28 : 10,
                        height: 8,
                        decoration: BoxDecoration(
                          color: active
                              ? AppTheme.accentGold
                              : AppTheme.borderSubtle,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      );
                    }),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accentGold,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 13,
                      ),
                    ),
                    onPressed: _handleNext,
                    icon: const Icon(Icons.arrow_forward, size: 16),
                    label: Text(
                      _currentIndex < _slides.length - 1
                          ? 'Next (${_currentIndex + 2}/${_slides.length})'
                          : 'Continue to Sign In',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
