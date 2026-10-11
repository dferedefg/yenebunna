import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

class RegionTerroirNode {
  final String name;
  final String amharic;
  final String elevation;
  final String cupProfile;
  final Offset normalizedPos;
  final Color color;

  const RegionTerroirNode({
    required this.name,
    required this.amharic,
    required this.elevation,
    required this.cupProfile,
    required this.normalizedPos,
    required this.color,
  });
}

class EthiopianOriginMap extends StatelessWidget {
  final String? selectedRegion;
  final ValueChanged<String?> onSelectRegion;

  const EthiopianOriginMap({
    super.key,
    required this.selectedRegion,
    required this.onSelectRegion,
  });

  static const List<RegionTerroirNode> regions = [
    RegionTerroirNode(
      name: 'Yirgacheffe',
      amharic: 'ይርጋጨፌ',
      elevation: '1,950–2,200m',
      cupProfile: 'Jasmine · Bergamot · Meyer Lemon',
      normalizedPos: Offset(0.46, 0.72),
      color: Color(0xFFF59E0B),
    ),
    RegionTerroirNode(
      name: 'Guji',
      amharic: 'ጉጂ',
      elevation: '2,150–2,350m',
      cupProfile: 'Wild Blueberry · Hibiscus · Cacao',
      normalizedPos: Offset(0.55, 0.77),
      color: Color(0xFFD97706),
    ),
    RegionTerroirNode(
      name: 'Sidama',
      amharic: 'ሲዳማ',
      elevation: '2,000–2,220m',
      cupProfile: 'Ripe Peach · Raw Honey · Mandarin',
      normalizedPos: Offset(0.48, 0.63),
      color: Color(0xFF10B981),
    ),
    RegionTerroirNode(
      name: 'Harar',
      amharic: 'ሐረር',
      elevation: '1,750–1,950m',
      cupProfile: 'Dark Mocha · Cardamom · Blackberry',
      normalizedPos: Offset(0.72, 0.44),
      color: Color(0xFFEC4899),
    ),
    RegionTerroirNode(
      name: 'Limu',
      amharic: 'ሊሙ',
      elevation: '1,850–2,050m',
      cupProfile: 'Orange Blossom · Caramel · Apricot',
      normalizedPos: Offset(0.32, 0.52),
      color: Color(0xFF38BDF8),
    ),
    RegionTerroirNode(
      name: 'Keffa',
      amharic: 'ከፋ',
      elevation: '1,900–2,100m',
      cupProfile: 'Wild Berries · Clove · Forest Honey',
      normalizedPos: Offset(0.28, 0.64),
      color: Color(0xFFA855F7),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final activeNode = regions.where((r) => r.name == selectedRegion).isNotEmpty
        ? regions.firstWhere((r) => r.name == selectedRegion)
        : null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.borderSubtle, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Interactive Ethiopian Terroir Map',
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Tap a highland zone to filter single-origin micro-lots',
                    style: TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              if (selectedRegion != null)
                TextButton(
                  onPressed: () => onSelectRegion(null),
                  child: const Text(
                    'Reset Map',
                    style: TextStyle(
                      color: AppTheme.accentGold,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 220,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                const height = 220.0;
                return Stack(
                  children: [
                    CustomPaint(
                      size: Size(width, height),
                      painter: _EthiopiaMapPainter(
                        selectedRegion: selectedRegion,
                      ),
                    ),
                    ...regions.map((node) {
                      final isSelected = node.name == selectedRegion;
                      final left = (node.normalizedPos.dx * width) - 42;
                      final top = (node.normalizedPos.dy * height) - 18;
                      return Positioned(
                        left: left.clamp(4.0, width - 92.0),
                        top: top.clamp(4.0, height - 40.0),
                        child: GestureDetector(
                          onTap: () => onSelectRegion(node.name),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 9,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppTheme.accentGold
                                  : AppTheme.bgDark.withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isSelected
                                    ? Colors.white
                                    : node.color.withValues(alpha: 0.7),
                                width: isSelected ? 1.5 : 1.0,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.terrain,
                                  size: 12,
                                  color:
                                      isSelected ? Colors.black : node.color,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  node.name,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: isSelected
                                        ? Colors.black
                                        : AppTheme.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          if (activeNode != null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.surfaceElevated,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.accentGold.withValues(alpha: 0.5),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${activeNode.name} (${activeNode.amharic}) · ${activeNode.elevation}',
                          style: const TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Signature Terroir: ${activeNode.cupProfile}',
                          style: const TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: regions.map((node) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppTheme.borderSubtle),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => onSelectRegion(node.name),
                      child: Text(
                        '${node.name} · ${node.elevation}',
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}

class _EthiopiaMapPainter extends CustomPainter {
  final String? selectedRegion;

  const _EthiopiaMapPainter({this.selectedRegion});

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()
      ..color = const Color(0xFF17110D)
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(14),
      ),
      bgPaint,
    );

    // Subtle topographic contour lines
    final gridPaint = Paint()
      ..color = AppTheme.borderSubtle.withValues(alpha: 0.4)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;

    for (var i = 1; i < 5; i++) {
      final dy = (size.height / 5) * i;
      canvas.drawLine(Offset(0, dy), Offset(size.width, dy), gridPaint);
    }

    // Simplified Ethiopia Polygon Outline
    final outlinePath = Path()
      ..moveTo(size.width * 0.35, size.height * 0.08)
      ..lineTo(size.width * 0.58, size.height * 0.12)
      ..lineTo(size.width * 0.72, size.height * 0.30)
      ..lineTo(size.width * 0.92, size.height * 0.46)
      ..lineTo(size.width * 0.76, size.height * 0.74)
      ..lineTo(size.width * 0.56, size.height * 0.90)
      ..lineTo(size.width * 0.34, size.height * 0.86)
      ..lineTo(size.width * 0.14, size.height * 0.64)
      ..lineTo(size.width * 0.18, size.height * 0.36)
      ..close();

    final landFill = Paint()
      ..color = const Color(0xFF241A14)
      ..style = PaintingStyle.fill;

    final landBorder = Paint()
      ..color = AppTheme.accentGold.withValues(alpha: 0.45)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    canvas.drawPath(outlinePath, landFill);
    canvas.drawPath(outlinePath, landBorder);

    // Great Rift Valley Fault Line
    final riftPath = Path()
      ..moveTo(size.width * 0.64, size.height * 0.25)
      ..quadraticBezierTo(
        size.width * 0.50,
        size.height * 0.52,
        size.width * 0.42,
        size.height * 0.86,
      );

    final riftPaint = Paint()
      ..color = const Color(0xFF38BDF8).withValues(alpha: 0.35)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    canvas.drawPath(riftPath, riftPaint);
  }

  @override
  bool shouldRepaint(covariant _EthiopiaMapPainter oldDelegate) {
    return oldDelegate.selectedRegion != selectedRegion;
  }
}
