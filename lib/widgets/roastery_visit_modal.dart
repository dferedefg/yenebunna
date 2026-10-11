import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../models/roastery.dart';

class RoasteryVisitModal extends StatefulWidget {
  final Roastery roastery;

  const RoasteryVisitModal({
    super.key,
    required this.roastery,
  });

  @override
  State<RoasteryVisitModal> createState() => _RoasteryVisitModalState();
}

class _RoasteryVisitModalState extends State<RoasteryVisitModal> {
  String _selectedDay = 'Saturday Morning (10:00 AM)';
  String _selectedExperience = 'Sensory Cupping Flight (5 Origins)';
  int _guests = 2;

  static const List<String> _slots = [
    'Friday Afternoon (3:00 PM)',
    'Saturday Morning (10:00 AM)',
    'Sunday Jebena & Drum Tour (11:00 AM)',
  ];

  static const List<String> _experiences = [
    'Sensory Cupping Flight (5 Origins)',
    'Live Drum Roasting & Green Grading',
    'Traditional Clay Jebena Ceremony',
  ];

  @override
  Widget build(BuildContext context) {
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
          Text(
            'Book Visit · ${widget.roastery.name}',
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            '${widget.roastery.district} · Hosted by ${widget.roastery.masterRoaster}',
            style: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
          ),
          const SizedBox(height: 14),
          DropdownButtonFormField<String>(
            initialValue: _selectedDay,
            dropdownColor: AppTheme.surfaceElevated,
            items: _slots
                .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                .toList(),
            onChanged: (v) {
              if (v != null) setState(() => _selectedDay = v);
            },
            decoration: const InputDecoration(labelText: 'Session Time Window'),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            initialValue: _selectedExperience,
            dropdownColor: AppTheme.surfaceElevated,
            items: _experiences
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (v) {
              if (v != null) setState(() => _selectedExperience = v);
            },
            decoration: const InputDecoration(labelText: 'Cupping Experience'),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Number of Guests'),
              Row(
                children: [
                  IconButton(
                    onPressed: () =>
                        setState(() => _guests = (_guests - 1).clamp(1, 8)),
                    icon: const Icon(Icons.remove_circle_outline),
                  ),
                  Text('$_guests Guests'),
                  IconButton(
                    onPressed: () =>
                        setState(() => _guests = (_guests + 1).clamp(1, 8)),
                    icon: const Icon(Icons.add_circle_outline),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentGold,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 13),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Confirmed $_selectedExperience ($_guests guests) at ${widget.roastery.name} for $_selectedDay!',
                    ),
                  ),
                );
              },
              child: const Text(
                'Confirm Roastery Reservation',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
