import 'dart:async';
import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

class JebenaCeremonyTimerModal extends StatefulWidget {
  const JebenaCeremonyTimerModal({super.key});

  @override
  State<JebenaCeremonyTimerModal> createState() =>
      _JebenaCeremonyTimerModalState();
}

class _JebenaCeremonyTimerModalState extends State<JebenaCeremonyTimerModal> {
  int _stageIndex = 0;
  int _secondsRemaining = 180;
  bool _isRunning = false;
  Timer? _timer;

  static const List<Map<String, dynamic>> _stages = [
    {
      'name': '1st Pour — Abol (አቦል)',
      'duration': 180,
      'desc':
          'First bold extraction in the black clay Jebena. Rich, intense, and aromatic.',
    },
    {
      'name': '2nd Pour — Tona (ቶና)',
      'duration': 150,
      'desc':
          'Refill water over the grounds and simmer for a balanced, honeyed middle cup.',
    },
    {
      'name': '3rd Pour — Baraka (በረካ)',
      'duration': 120,
      'desc':
          'The blessing cup. Delicate, floral, and shared to seal hospitality.',
    },
  ];

  void _toggleTimer() {
    if (_isRunning) {
      _timer?.cancel();
      setState(() => _isRunning = false);
    } else {
      setState(() => _isRunning = true);
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_secondsRemaining > 0) {
          setState(() => _secondsRemaining--);
        } else {
          timer.cancel();
          setState(() => _isRunning = false);
        }
      });
    }
  }

  void _selectStage(int index) {
    _timer?.cancel();
    setState(() {
      _stageIndex = index;
      _secondsRemaining = _stages[index]['duration'] as int;
      _isRunning = false;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stage = _stages[_stageIndex];
    final mins = (_secondsRemaining ~/ 60).toString().padLeft(2, '0');
    final secs = (_secondsRemaining % 60).toString().padLeft(2, '0');

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
            'Traditional Ethiopian Jebena Ceremony Timer',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: List.generate(_stages.length, (i) {
              final selected = i == _stageIndex;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor:
                          selected ? AppTheme.accentGold : Colors.transparent,
                      side: BorderSide(
                        color: selected
                            ? AppTheme.accentGold
                            : AppTheme.borderSubtle,
                      ),
                    ),
                    onPressed: () => _selectStage(i),
                    child: Text(
                      i == 0
                          ? 'Abol'
                          : i == 1
                              ? 'Tona'
                              : 'Baraka',
                      style: TextStyle(
                        color: selected ? Colors.black : AppTheme.textPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
          Text(
            stage['name'] as String,
            style: const TextStyle(
              color: AppTheme.accentGoldLight,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            stage['desc'] as String,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              '$mins:$secs',
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 44,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
              ),
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentGold,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 13),
              ),
              onPressed: _toggleTimer,
              icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
              label: Text(
                _isRunning ? 'Pause Ceremony Timer' : 'Start Brewing Stage',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
