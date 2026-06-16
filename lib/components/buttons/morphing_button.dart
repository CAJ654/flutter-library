import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

// Exported code snippet string used by the Code Inspector panel.
const morphingButtonCode = r'''
class MorphingButton extends StatefulWidget {
  const MorphingButton({super.key, this.onTap});
  final VoidCallback? onTap;
  @override
  State<MorphingButton> createState() => _MorphingButtonState();
}

class _MorphingButtonState extends State<MorphingButton>
    with TickerProviderStateMixin {
  _Phase _phase = _Phase.idle;

  late final AnimationController _morphCtrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 400));
  late final AnimationController _successCtrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 500));

  Future<void> _handleTap() async {
    if (_phase != _Phase.idle) return;
    setState(() => _phase = _Phase.loading);
    _morphCtrl.forward();
    await Future.delayed(const Duration(seconds: 2));
    _morphCtrl.reverse();
    _successCtrl.forward();
    setState(() => _phase = _Phase.success);
    await Future.delayed(const Duration(seconds: 2));
    _successCtrl.reset();
    setState(() => _phase = _Phase.idle);
  }

  @override
  void dispose() {
    _morphCtrl.dispose();
    _successCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
        width: _phase == _Phase.idle ? 180 : 56,
        height: 56,
        decoration: BoxDecoration(
          color: _phase == _Phase.success
              ? const Color(0xFF4CAF50)
              : const Color(0xFF6C63FF),
          borderRadius: BorderRadius.circular(
              _phase == _Phase.idle ? 14 : 28),
        ),
        child: Center(child: _buildChild()),
      ),
    );
  }

  Widget _buildChild() {
    if (_phase == _Phase.loading) {
      return const SizedBox(
        width: 24, height: 24,
        child: CircularProgressIndicator(
            strokeWidth: 2.5, color: Colors.white),
      );
    }
    if (_phase == _Phase.success) {
      return const Icon(Icons.check_rounded, color: Colors.white, size: 26);
    }
    return const Text('Submit',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600,
            fontSize: 15));
  }
}

enum _Phase { idle, loading, success }
''';

enum _Phase { idle, loading, success }

class MorphingButton extends StatefulWidget {
  const MorphingButton({super.key, this.darkMode = false});

  final bool darkMode;

  @override
  State<MorphingButton> createState() => _MorphingButtonState();
}

class _MorphingButtonState extends State<MorphingButton> with TickerProviderStateMixin {
  _Phase _phase = _Phase.idle;

  Future<void> _handleTap() async {
    if (_phase != _Phase.idle) return;
    setState(() => _phase = _Phase.loading);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _phase = _Phase.success);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _phase = _Phase.idle);
  }

  @override
  Widget build(BuildContext context) {
    final bg = widget.darkMode ? const Color(0xFF0D1117) : const Color(0xFFF6F8FA);
    return Container(
      color: bg,
      padding: const EdgeInsets.all(40),
      child: GestureDetector(
        onTap: _handleTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
          width: _phase == _Phase.idle ? 180 : 56,
          height: 56,
          decoration: BoxDecoration(
            color: _phase == _Phase.success
                ? AppTheme.success
                : AppTheme.accent,
            borderRadius: BorderRadius.circular(_phase == _Phase.idle ? 14 : 28),
            boxShadow: [
              BoxShadow(
                color: (_phase == _Phase.success ? AppTheme.success : AppTheme.accent)
                    .withOpacity(0.4),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Center(child: _buildChild()),
        ),
      ),
    );
  }

  Widget _buildChild() {
    if (_phase == _Phase.loading) {
      return const SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
      );
    }
    if (_phase == _Phase.success) {
      return const Icon(Icons.check_rounded, color: Colors.white, size: 24);
    }
    return const Text(
      'Submit',
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15),
    );
  }
}
