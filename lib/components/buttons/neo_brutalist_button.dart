import 'package:flutter/material.dart';

const neoBrutalistButtonCode = r'''
class NeoBrutalistButton extends StatefulWidget {
  const NeoBrutalistButton({
    super.key,
    required this.label,
    this.onPressed,
    this.disabled = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool disabled;

  @override
  State<NeoBrutalistButton> createState() => _NeoBrutalistButtonState();
}

class _NeoBrutalistButtonState extends State<NeoBrutalistButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    const shadow = Offset(5, 5);
    final offset = _pressed || widget.disabled ? Offset.zero : shadow;

    return GestureDetector(
      onTapDown: widget.disabled ? null : (_) => setState(() => _pressed = true),
      onTapUp: widget.disabled ? null : (_) {
        setState(() => _pressed = false);
        widget.onPressed?.call();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        transform: Matrix4.translationValues(
            shadow.dx - offset.dx, shadow.dy - offset.dy, 0),
        decoration: BoxDecoration(
          color: widget.disabled ? const Color(0xFFE0E0E0) : const Color(0xFFFFE566),
          border: Border.all(color: Colors.black, width: 2.5),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              offset: offset,
              blurRadius: 0,
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        child: Text(
          widget.label,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 15,
            color: widget.disabled ? Colors.black38 : Colors.black,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}
''';

class NeoBrutalistButton extends StatefulWidget {
  const NeoBrutalistButton({
    super.key,
    this.label = 'Click Me',
    this.disabled = false,
    this.darkMode = false,
  });

  final String label;
  final bool disabled;
  final bool darkMode;

  @override
  State<NeoBrutalistButton> createState() => _NeoBrutalistButtonState();
}

class _NeoBrutalistButtonState extends State<NeoBrutalistButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    const shadow = Offset(6, 6);
    final offset = (_pressed || widget.disabled) ? Offset.zero : shadow;
    final bg = widget.darkMode ? const Color(0xFF0D1117) : const Color(0xFFF6F8FA);

    return Container(
      color: bg,
      padding: const EdgeInsets.all(40),
      child: GestureDetector(
        onTapDown: widget.disabled ? null : (_) => setState(() => _pressed = true),
        onTapUp: widget.disabled
            ? null
            : (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 80),
          transform: Matrix4.translationValues(
            shadow.dx - offset.dx,
            shadow.dy - offset.dy,
            0,
          ),
          decoration: BoxDecoration(
            color: widget.disabled ? const Color(0xFFBDBDBD) : const Color(0xFFFFE566),
            border: Border.all(
              color: widget.darkMode ? Colors.white : Colors.black,
              width: 2.5,
            ),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: widget.darkMode ? Colors.white : Colors.black,
                offset: offset,
                blurRadius: 0,
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
          child: Text(
            widget.label,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 15,
              color: widget.disabled ? Colors.black38 : Colors.black,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }
}
