import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

class QrLotVerifierModal extends StatefulWidget {
  const QrLotVerifierModal({super.key});

  @override
  State<QrLotVerifierModal> createState() => _QrLotVerifierModalState();
}

class _QrLotVerifierModalState extends State<QrLotVerifierModal> {
  String _selectedBatch = 'BATCH-ETH-2610-A';

  static const Map<String, Map<String, String>> _lots = {
    'BATCH-ETH-2610-A': {
      'bean': 'Yirgacheffe Kochere Grade 1',
      'station': 'Chelelektu Washing Station, Gedeo Zone',
      'altitude': '2,120m MASL',
      'roaster': 'Galani Artisan Roasters · Drum #2 (204°C)',
      'qGrader': 'Ato Yared Mekonnen · SCA 90.5 pts',
      'moisture': '10.8% · Water Activity 0.54 aw',
    },
    'BATCH-SID-2609-C': {
      'bean': 'Sidama Bensa Bombe Natural',
      'station': 'Bombe Mountain Drying Tables, Sidama',
      'altitude': '2,180m MASL',
      'roaster': 'Sidama Coffee Guild Lab · Drum #1 (201°C)',
      'qGrader': 'Ato Bereket Alemu · SCA 89.5 pts',
      'moisture': '11.1% · Water Activity 0.56 aw',
    },
    'BATCH-GUJ-2610-K': {
      'bean': 'Guji Uraga Raro Anaerobic',
      'station': 'Raro Boda Fermentation Lot, Oromia',
      'altitude': '2,290m MASL',
      'roaster': 'Hega Specialty Roastery · Drum #1 (198°C)',
      'qGrader': 'W/ro Selamawit Tadesse · SCA 91.8 pts',
      'moisture': '10.5% · Water Activity 0.52 aw',
    },
  };

  @override
  Widget build(BuildContext context) {
    final lot = _lots[_selectedBatch]!;
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: const BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ECX Lot QR & Harvest Traceability Verifier',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: _lots.keys.map((code) {
              final active = _selectedBatch == code;
              return ChoiceChip(
                label: Text(code),
                selected: active,
                selectedColor: AppTheme.accentGold,
                labelStyle: TextStyle(
                  color: active ? Colors.black : AppTheme.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
                onSelected: (_) => setState(() => _selectedBatch = code),
              );
            }).toList(),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.surfaceElevated,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.borderSubtle),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lot['bean']!,
                  style: const TextStyle(
                    color: AppTheme.accentGoldLight,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text('Washing Station: ${lot['station']}'),
                Text('Elevation: ${lot['altitude']}'),
                Text('Roast Telemetry: ${lot['roaster']}'),
                Text('Q-Grader Verification: ${lot['qGrader']}'),
                Text('Green Lab Specs: ${lot['moisture']}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
