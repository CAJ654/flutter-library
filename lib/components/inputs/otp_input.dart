import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const otpInputCode = r'''
class OtpInput extends StatefulWidget {
  const OtpInput({super.key, this.length = 6, this.onCompleted});

  final int length;
  final ValueChanged<String>? onCompleted;

  @override
  State<OtpInput> createState() => _OtpInputState();
}

class _OtpInputState extends State<OtpInput> {
  late final List<TextEditingController> _ctrls;
  late final List<FocusNode> _nodes;

  @override
  void initState() {
    super.initState();
    _ctrls = List.generate(widget.length, (_) => TextEditingController());
    _nodes = List.generate(widget.length, (_) => FocusNode());
  }

  void _onChanged(String value, int index) {
    if (value.isNotEmpty && index < widget.length - 1) {
      _nodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _nodes[index - 1].requestFocus();
    }
    final code = _ctrls.map((c) => c.text).join();
    if (code.length == widget.length) widget.onCompleted?.call(code);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.length, (i) {
        final focused = _nodes[i].hasFocus;
        return Padding(
          padding: EdgeInsets.only(right: i < widget.length - 1 ? 10 : 0),
          child: _OtpBox(
            controller: _ctrls[i],
            focusNode: _nodes[i],
            focused: focused,
            onChanged: (v) => _onChanged(v, i),
          ),
        );
      }),
    );
  }

  @override
  void dispose() {
    for (final c in _ctrls) c.dispose();
    for (final n in _nodes) n.dispose();
    super.dispose();
  }
}
''';

class OtpInput extends StatefulWidget {
  const OtpInput({super.key, this.length = 6, this.darkMode = false});

  final int length;
  final bool darkMode;

  @override
  State<OtpInput> createState() => _OtpInputState();
}

class _OtpInputState extends State<OtpInput> {
  late final List<TextEditingController> _ctrls;
  late final List<FocusNode> _nodes;
  bool _completed = false;

  @override
  void initState() {
    super.initState();
    _ctrls = List.generate(widget.length, (_) => TextEditingController());
    _nodes = List.generate(widget.length, (i) {
      final node = FocusNode();
      node.addListener(() => setState(() {}));
      node.onKeyEvent = (_, event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.backspace &&
            _ctrls[i].text.isEmpty &&
            i > 0) {
          _nodes[i - 1].requestFocus();
          _ctrls[i - 1].clear();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      };
      return node;
    });
  }

  @override
  void dispose() {
    for (final c in _ctrls) {
      c.dispose();
    }
    for (final n in _nodes) {
      n.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.isNotEmpty && index < widget.length - 1) {
      _nodes[index + 1].requestFocus();
    }
    final code = _ctrls.map((c) => c.text).join();
    setState(() => _completed = code.length == widget.length);
  }

  void _reset() {
    for (final c in _ctrls) {
      c.clear();
    }
    setState(() => _completed = false);
    _nodes[0].requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.darkMode;
    final bg = isDark ? const Color(0xFF0D1117) : const Color(0xFFF6F8FA);

    return Container(
      color: bg,
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Enter verification code',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: isDark ? const Color(0xFFE6EDF3) : const Color(0xFF24292F),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'We sent a 6-digit code to your email',
            style: TextStyle(
              fontSize: 12,
              color: isDark ? const Color(0xFF8B949E) : const Color(0xFF57606A),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(widget.length, (i) {
              final focused = _nodes[i].hasFocus;
              final hasValue = _ctrls[i].text.isNotEmpty;
              return Padding(
                padding: EdgeInsets.only(right: i < widget.length - 1 ? 10 : 0),
                child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 46,
                    height: 54,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF161B22) : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: _completed
                            ? const Color(0xFF4CAF50)
                            : focused
                                ? const Color(0xFF6C63FF)
                                : hasValue
                                    ? const Color(0xFF6C63FF).withOpacity(0.5)
                                    : isDark
                                        ? const Color(0xFF30363D)
                                        : const Color(0xFFD0D7DE),
                        width: focused ? 2 : 1.5,
                      ),
                      boxShadow: focused
                          ? [
                              BoxShadow(
                                color: const Color(0xFF6C63FF).withOpacity(0.15),
                                blurRadius: 8,
                              )
                            ]
                          : null,
                    ),
                    child: Center(
                      child: TextField(
                        controller: _ctrls[i],
                        focusNode: _nodes[i],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : const Color(0xFF24292F),
                        ),
                        decoration: const InputDecoration(
                          counterText: '',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        onChanged: (v) => _onChanged(v, i),
                      ),
                    ),
                  ),
              );
            }),
          ),
          if (_completed) ...[
            const SizedBox(height: 20),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle_rounded, color: Color(0xFF4CAF50), size: 18),
                const SizedBox(width: 6),
                Text(
                  'Code verified!',
                  style: const TextStyle(
                    color: Color(0xFF4CAF50),
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: _reset,
                  child: Text(
                    'Reset',
                    style: TextStyle(
                      color: const Color(0xFF6C63FF),
                      fontSize: 13,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
