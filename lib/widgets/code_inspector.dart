import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:flutter_highlight/themes/atom-one-light.dart';
import '../models/component_item.dart';
import '../theme/app_theme.dart';

class CodeInspector extends StatefulWidget {
  const CodeInspector({super.key, required this.item});

  final ComponentItem item;

  @override
  State<CodeInspector> createState() => _CodeInspectorState();
}

class _CodeInspectorState extends State<CodeInspector> {
  bool _copied = false;

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: widget.item.codeSnippet));
    setState(() => _copied = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _copied = false);
  }

  @override
  void didUpdateWidget(CodeInspector old) {
    super.didUpdateWidget(old);
    if (old.item.id != widget.item.id) _copied = false;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = context.colors;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: colors.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _InspectorHeader(copied: _copied, onCopy: _copy, isDark: isDark),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.zero,
              child: HighlightView(
                widget.item.codeSnippet,
                language: 'dart',
                theme: isDark ? atomOneDarkTheme : atomOneLightTheme,
                padding: const EdgeInsets.all(16),
                textStyle: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12.5,
                  height: 1.6,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InspectorHeader extends StatelessWidget {
  const _InspectorHeader({
    required this.copied,
    required this.onCopy,
    required this.isDark,
  });

  final bool copied;
  final VoidCallback onCopy;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.border)),
      ),
      child: Row(
        children: [
          const Icon(Icons.code_rounded, size: 16),
          const SizedBox(width: 8),
          const Text(
            'Code Inspector',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
          const Spacer(),
          _CopyButton(copied: copied, onCopy: onCopy),
        ],
      ),
    );
  }
}

class _CopyButton extends StatelessWidget {
  const _CopyButton({required this.copied, required this.onCopy});

  final bool copied;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: TextButton.icon(
        onPressed: onCopy,
        style: TextButton.styleFrom(
          foregroundColor: copied ? AppTheme.success : AppTheme.accent,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: copied ? AppTheme.success : AppTheme.accent,
              width: 1,
            ),
          ),
          minimumSize: const Size(0, 0),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        icon: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Icon(
            copied ? Icons.check_rounded : Icons.copy_rounded,
            size: 14,
            key: ValueKey(copied),
          ),
        ),
        label: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Text(
            copied ? 'Copied!' : 'Copy code',
            key: ValueKey(copied),
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
