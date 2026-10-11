import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../models/order.dart';

class LiveCourierTrackingWidget extends StatefulWidget {
  final Order order;
  final VoidCallback onAdvanceStage;

  const LiveCourierTrackingWidget({
    super.key,
    required this.order,
    required this.onAdvanceStage,
  });

  @override
  State<LiveCourierTrackingWidget> createState() =>
      _LiveCourierTrackingWidgetState();
}

class _LiveCourierTrackingWidgetState extends State<LiveCourierTrackingWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
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
                children: [
                  Text(
                    'Addis Ababa Live Courier · #${order.orderNumber}',
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${order.activeCorridor} · ${order.corridorSpeedKmh} km/h avg',
                    style: const TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceElevated,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.accentGold, width: 1),
                ),
                child: Text(
                  order.estimatedMinutesRemaining > 0
                      ? 'ETA ${order.estimatedMinutesRemaining} min'
                      : 'Arrived',
                  style: const TextStyle(
                    color: AppTheme.accentGoldLight,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 170,
            width: double.infinity,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                return CustomPaint(
                  painter: _AddisRoutePainter(
                    progress: _controller.value,
                    status: order.status,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Courier: ${order.courierName} (${order.courierPlate})',
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Destination: ${order.destinationAddress}',
                      style: const TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentGold,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: widget.onAdvanceStage,
                child: const Text(
                  'Advance Stage',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AddisRoutePainter extends CustomPainter {
  final double progress;
  final OrderStatus status;

  const _AddisRoutePainter({
    required this.progress,
    required this.status,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = const Color(0xFF15100C);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(14),
      ),
      bg,
    );

    final roadPaint = Paint()
      ..color = AppTheme.borderSubtle
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    // Addis corridor road network
    canvas.drawLine(
      Offset(0, size.height * 0.65),
      Offset(size.width, size.height * 0.35),
      roadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.25, 0),
      Offset(size.width * 0.65, size.height),
      roadPaint,
    );

    final start = Offset(size.width * 0.16, size.height * 0.72);
    final end = Offset(size.width * 0.84, size.height * 0.28);

    final routePaint = Paint()
      ..color = AppTheme.accentGold
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke;

    canvas.drawLine(start, end, routePaint);

    // Roastery Origin Marker
    final originPaint = Paint()..color = AppTheme.accentGoldLight;
    canvas.drawCircle(start, 7, originPaint);

    // Customer Destination Marker
    final destPaint = Paint()..color = AppTheme.highlandGreen;
    canvas.drawCircle(end, 7, destPaint);

    // Interpolated Courier Position
    final double t = status == OrderStatus.delivered
        ? 1.0
        : status == OrderStatus.roasting
            ? 0.08
            : (0.25 + 0.65 * progress);

    final courierOffset = Offset.lerp(start, end, t) ?? start;
    final courierPaint = Paint()..color = Colors.white;
    canvas.drawCircle(courierOffset, 8, courierPaint);
  }

  @override
  bool shouldRepaint(covariant _AddisRoutePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.status != status;
  }
}
