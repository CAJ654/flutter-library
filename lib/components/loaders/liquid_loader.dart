import 'package:flutter/material.dart';
import 'dart:math' as math;

const liquidLoaderCode = r'''
class LiquidCircleLoader extends StatefulWidget {
  const LiquidCircleLoader({
    super.key,
    this.size = 120,
    this.progress = 0.65,
    this.color = const Color(0xFF6C63FF),
  });

  final double size;
  final double progress;
  final Color color;

  @override
  State<LiquidCircleLoader> createState() => _LiquidCircleLoaderState();
}

class _LiquidCircleLoaderState extends State<LiquidCircleLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this, duration: const Duration(seconds: 2))..repeat();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: widget.size,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, __) => CustomPaint(
          painter: _LiquidPainter(
            progress: widget.progress,
            wavePhase: _ctrl.value * 2 * math.pi,
            color: widget.color,
          ),
        ),
      ),
    );
  }
}

class _LiquidPainter extends CustomPainter {
  const _LiquidPainter({
    required this.progress,
    required this.wavePhase,
    required this.color,
  });

  final double progress;
  final double wavePhase;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = math.min(cx, cy);

    // Clip to circle
    canvas.clipPath(Path()..addOval(Rect.fromCircle(center: Offset(cx, cy), radius: r)));

    // Background
    canvas.drawCircle(Offset(cx, cy), r, Paint()..color = color.withOpacity(0.12));

    // Liquid fill
    final fillY = cy + r * (1 - 2 * progress);
    final wavePath = Path()..moveTo(0, fillY);
    for (double x = 0; x <= size.width; x++) {
      final y = fillY + math.sin((x / size.width) * 2 * math.pi + wavePhase) * 8
          + math.sin((x / size.width) * 4 * math.pi + wavePhase * 1.3) * 4;
      wavePath.lineTo(x, y);
    }
    wavePath
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(wavePath, Paint()..color = color);

    // Border ring
    canvas.drawCircle(
      Offset(cx, cy), r - 2,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );

    // Percentage text
    final pct = '${(progress * 100).round()}%';
    final tp = TextPainter(
      text: TextSpan(
        text: pct,
        style: TextStyle(
          color: progress > 0.5 ? Colors.white : color,
          fontSize: r * 0.32,
          fontWeight: FontWeight.w700,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(cx - tp.width / 2, cy - tp.height / 2));
  }

  @override
  bool shouldRepaint(_LiquidPainter old) =>
      old.progress != progress || old.wavePhase != wavePhase;
}
''';

class LiquidCircleLoader extends StatefulWidget {
  const LiquidCircleLoader({
    super.key,
    this.darkMode = false,
    this.progressValue = 0.65,
  });

  final bool darkMode;
  final double progressValue;

  @override
  State<LiquidCircleLoader> createState() => _LiquidCircleLoaderState();
}

class _LiquidCircleLoaderState extends State<LiquidCircleLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..repeat();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bg = widget.darkMode ? const Color(0xFF0D1117) : const Color(0xFFF6F8FA);

    return Container(
      color: bg,
      padding: const EdgeInsets.all(40),
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, __) => CustomPaint(
          size: const Size(130, 130),
          painter: _LiquidPainter(
            progress: widget.progressValue,
            wavePhase: _ctrl.value * 2 * math.pi,
            color: const Color(0xFF6C63FF),
          ),
        ),
      ),
    );
  }
}

class _LiquidPainter extends CustomPainter {
  const _LiquidPainter({
    required this.progress,
    required this.wavePhase,
    required this.color,
  });

  final double progress;
  final double wavePhase;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = math.min(cx, cy);

    canvas.save();
    canvas.clipPath(Path()..addOval(Rect.fromCircle(center: Offset(cx, cy), radius: r - 1)));

    // Background fill
    canvas.drawCircle(Offset(cx, cy), r, Paint()..color = color.withOpacity(0.1));

    // Liquid wave fill
    final fillY = cy + r * (1 - 2 * progress);
    final wavePath = Path()..moveTo(0, fillY);
    for (double x = 0; x <= size.width; x++) {
      final y = fillY
          + math.sin((x / size.width) * 2 * math.pi + wavePhase) * 7
          + math.sin((x / size.width) * 4 * math.pi + wavePhase * 1.4) * 3.5;
      wavePath.lineTo(x, y);
    }
    wavePath
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(wavePath, Paint()..color = color);
    canvas.restore();

    // Outer ring
    canvas.drawCircle(
      Offset(cx, cy),
      r - 1.5,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );

    // Percentage text
    final pct = '${(progress * 100).round()}%';
    final tp = TextPainter(
      text: TextSpan(
        text: pct,
        style: TextStyle(
          color: progress > 0.5 ? Colors.white : color,
          fontSize: r * 0.30,
          fontWeight: FontWeight.w800,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(cx - tp.width / 2, cy - tp.height / 2));
  }

  @override
  bool shouldRepaint(_LiquidPainter old) =>
      old.progress != progress || old.wavePhase != wavePhase;
}
