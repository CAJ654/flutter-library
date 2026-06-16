import 'package:flutter/material.dart';

const animatedTextFieldCode = r'''
class AnimatedTextField extends StatefulWidget {
  const AnimatedTextField({
    super.key,
    required this.label,
    this.hint,
  });

  final String label;
  final String? hint;

  @override
  State<AnimatedTextField> createState() => _AnimatedTextFieldState();
}

class _AnimatedTextFieldState extends State<AnimatedTextField>
    with SingleTickerProviderStateMixin {
  final _focus = FocusNode();
  final _ctrl = TextEditingController();
  late final AnimationController _animCtrl;
  late final Animation<double> _labelAnim;

  bool get _hasContent => _ctrl.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 200));
    _labelAnim = CurvedAnimation(
      parent: _animCtrl, curve: Curves.easeOutCubic);
    _focus.addListener(() => setState(() {
      _focus.hasFocus || _hasContent
          ? _animCtrl.forward()
          : _animCtrl.reverse();
    }));
  }

  @override
  void dispose() {
    _focus.dispose();
    _ctrl.dispose();
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _labelAnim,
      builder: (context, _) {
        final focused = _focus.hasFocus;
        return Container(
          height: 60,
          decoration: BoxDecoration(
            border: Border.all(
              color: focused ? const Color(0xFF6C63FF) : const Color(0xFFBDBDBD),
              width: focused ? 2 : 1.5,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: Lerp(14, 10).evaluate(_labelAnim),
                top: Lerp(18, -9).evaluate(_labelAnim),
                child: Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    widget.label,
                    style: TextStyle(
                      fontSize: Lerp(15, 11).evaluate(_labelAnim),
                      color: focused ? const Color(0xFF6C63FF)
                          : const Color(0xFF9E9E9E),
                      fontWeight: focused ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 14, right: 14, top: 22),
                child: TextField(
                  controller: _ctrl,
                  focusNode: _focus,
                  decoration: const InputDecoration.collapsed(hintText: null),
                  onChanged: (_) => setState(() {}),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
''';

class AnimatedTextField extends StatefulWidget {
  const AnimatedTextField({
    super.key,
    this.label = 'Email address',
    this.darkMode = false,
  });

  final String label;
  final bool darkMode;

  @override
  State<AnimatedTextField> createState() => _AnimatedTextFieldState();
}

class _AnimatedTextFieldState extends State<AnimatedTextField>
    with SingleTickerProviderStateMixin {
  final _focus = FocusNode();
  final _ctrl = TextEditingController();
  late final AnimationController _animCtrl;
  late final Animation<double> _anim;

  bool get _floated => _focus.hasFocus || _ctrl.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 220));
    _anim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutCubic);
    _focus.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (_floated) {
      _animCtrl.forward();
    } else {
      _animCtrl.reverse();
    }
    setState(() {});
  }

  @override
  void dispose() {
    _focus.removeListener(_onFocusChange);
    _focus.dispose();
    _ctrl.dispose();
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.darkMode;
    final bgColor = isDark ? const Color(0xFF0D1117) : const Color(0xFFF6F8FA);
    final surfaceColor = isDark ? const Color(0xFF161B22) : Colors.white;
    final borderColor = isDark ? const Color(0xFF30363D) : const Color(0xFFD0D7DE);
    final textColor = isDark ? const Color(0xFFE6EDF3) : const Color(0xFF24292F);

    return Container(
      color: bgColor,
      padding: const EdgeInsets.all(40),
      child: AnimatedBuilder(
        animation: _anim,
        builder: (context, _) {
          final focused = _focus.hasFocus;
          final labelTop = _floated ? -10.0 : 19.0;
          final labelLeft = 14.0;
          final labelFontSize = _floated ? 11.0 : 15.0;
          final labelColor = focused
              ? const Color(0xFF6C63FF)
              : isDark
                  ? const Color(0xFF8B949E)
                  : const Color(0xFF57606A);

          return SizedBox(
            width: 300,
            height: 60,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    border: Border.all(
                      color: focused ? const Color(0xFF6C63FF) : borderColor,
                      width: focused ? 2 : 1.5,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: focused
                        ? [
                            BoxShadow(
                              color: const Color(0xFF6C63FF).withOpacity(0.15),
                              blurRadius: 8,
                              spreadRadius: 2,
                            )
                          ]
                        : null,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 14, right: 14, top: 20),
                    child: TextField(
                      controller: _ctrl,
                      focusNode: _focus,
                      style: TextStyle(color: textColor, fontSize: 15),
                      decoration: const InputDecoration.collapsed(hintText: null),
                      onChanged: (_) {
                        if (_ctrl.text.isNotEmpty && !_floated) _animCtrl.forward();
                        setState(() {});
                      },
                    ),
                  ),
                ),
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  top: labelTop,
                  left: labelLeft,
                  child: Container(
                    color: surfaceColor,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOutCubic,
                      style: TextStyle(
                        fontSize: labelFontSize,
                        color: labelColor,
                        fontWeight: focused ? FontWeight.w600 : FontWeight.normal,
                      ),
                      child: Text(widget.label),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
