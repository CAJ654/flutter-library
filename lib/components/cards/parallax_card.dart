import 'package:flutter/material.dart';
import 'dart:math' as math;

const parallaxCardCode = r'''
class ParallaxProductCard extends StatefulWidget {
  const ParallaxProductCard({super.key});

  @override
  State<ParallaxProductCard> createState() => _ParallaxProductCardState();
}

class _ParallaxProductCardState extends State<ParallaxProductCard> {
  Offset _tilt = Offset.zero;
  bool _hovered = false;

  void _onHover(PointerHoverEvent e, Size size) {
    final dx = (e.localPosition.dx / size.width - 0.5) * 2;
    final dy = (e.localPosition.dy / size.height - 0.5) * 2;
    setState(() {
      _tilt = Offset(dx, dy);
      _hovered = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (e) {
        final box = context.findRenderObject() as RenderBox;
        _onHover(e, box.size);
      },
      onExit: (_) => setState(() {
        _tilt = Offset.zero;
        _hovered = false;
      }),
      child: TweenAnimationBuilder<Offset>(
        tween: Tween(end: _tilt),
        duration: const Duration(milliseconds: 150),
        builder: (_, tilt, child) => Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(tilt.dx * 0.2)
            ..rotateX(-tilt.dy * 0.2),
          child: child,
        ),
        child: _CardContent(hovered: _hovered),
      ),
    );
  }
}
''';

class ParallaxProductCard extends StatefulWidget {
  const ParallaxProductCard({super.key, this.darkMode = false});

  final bool darkMode;

  @override
  State<ParallaxProductCard> createState() => _ParallaxProductCardState();
}

class _ParallaxProductCardState extends State<ParallaxProductCard> {
  Offset _tilt = Offset.zero;
  bool _hovered = false;

  void _onHover(Offset local, Size size) {
    final dx = (local.dx / size.width - 0.5) * 2;
    final dy = (local.dy / size.height - 0.5) * 2;
    setState(() {
      _tilt = Offset(dx, dy);
      _hovered = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bg = widget.darkMode ? const Color(0xFF0D1117) : const Color(0xFFF6F8FA);

    return Container(
      color: bg,
      padding: const EdgeInsets.all(40),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onHover: (e) {
          final box = context.findRenderObject() as RenderBox;
          _onHover(box.globalToLocal(e.position), box.size);
        },
        onExit: (_) => setState(() {
          _tilt = Offset.zero;
          _hovered = false;
        }),
        child: TweenAnimationBuilder<Offset>(
          tween: Tween(end: _tilt),
          duration: const Duration(milliseconds: 180),
          builder: (_, tilt, child) => Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(tilt.dx * 0.25)
              ..rotateX(-tilt.dy * 0.25),
            child: child,
          ),
          child: _buildCard(),
        ),
      ),
    );
  }

  Widget _buildCard() {
    final isDark = widget.darkMode;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 260,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C2128) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? const Color(0xFF30363D) : const Color(0xFFE0E0E0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(_hovered ? 0.25 : 0.1),
            blurRadius: _hovered ? 32 : 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 180,
              transform: Matrix4.identity()..scale(_hovered ? 1.04 : 1.0),
              transformAlignment: Alignment.center,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF6C63FF), Color(0xFF9D97FF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: CustomPaint(
                    size: const Size(80, 80),
                    painter: _ProductIconPainter(),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Wireless Headphones',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: isDark ? Colors.white : const Color(0xFF24292F),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Premium audio, 30h battery',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? const Color(0xFF8B949E) : const Color(0xFF57606A),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$149.00',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                        color: Color(0xFF6C63FF),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6C63FF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Add',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final cx = size.width / 2;
    final cy = size.height / 2;

    // Headphone arc
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx, cy), width: 60, height: 60),
      math.pi,
      math.pi,
      false,
      paint..color = Colors.white.withOpacity(0.7),
    );
    // Ear cups
    canvas.drawCircle(Offset(cx - 30, cy), 10, paint..style = PaintingStyle.fill..color = Colors.white.withOpacity(0.5));
    canvas.drawCircle(Offset(cx + 30, cy), 10, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
