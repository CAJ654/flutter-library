import 'package:flutter/material.dart';
import '../models/component_item.dart';
import '../theme/app_theme.dart';

class SandboxCanvas extends StatelessWidget {
  const SandboxCanvas({
    super.key,
    required this.item,
    required this.props,
    required this.onPropChanged,
    this.onToggleTheme,
    this.themeIcon,
    this.themeTooltip,
  });

  final ComponentItem item;
  final Map<String, dynamic> props;
  final void Function(String key, dynamic value) onPropChanged;
  final VoidCallback? onToggleTheme;
  final IconData? themeIcon;
  final String? themeTooltip;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ComponentHeader(
        item: item,
        onToggleTheme: onToggleTheme,
        themeIcon: themeIcon,
        themeTooltip: themeTooltip,
      ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.card,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: colors.border),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child: Center(
                child: SingleChildScrollView(
                  child: item.builder(props),
                ),
              ),
            ),
          ),
        ),
        if (item.controls.isNotEmpty)
          _ControlsBar(
            controls: item.controls,
            props: props,
            onChanged: onPropChanged,
          ),
      ],
    );
  }
}

class _ComponentHeader extends StatelessWidget {
  const _ComponentHeader({
    required this.item,
    this.onToggleTheme,
    this.themeIcon,
    this.themeTooltip,
  });

  final ComponentItem item;
  final VoidCallback? onToggleTheme;
  final IconData? themeIcon;
  final String? themeTooltip;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                item.name,
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.accent.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  item.category,
                  style: const TextStyle(
                    color: AppTheme.accent,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              if (onToggleTheme != null)
                IconButton(
                  icon: Icon(themeIcon, size: 18),
                  tooltip: themeTooltip,
                  onPressed: onToggleTheme,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            item.description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _ControlsBar extends StatelessWidget {
  const _ControlsBar({
    required this.controls,
    required this.props,
    required this.onChanged,
  });

  final List<ComponentControl> controls;
  final Map<String, dynamic> props;
  final void Function(String, dynamic) onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: colors.border)),
      ),
      child: Wrap(
        spacing: 20,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            'Controls',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 1.1),
          ),
          for (final control in controls)
            if (control.type == ControlType.toggle)
              _ToggleControl(
                control: control,
                value: props[control.propKey] as bool,
                onChanged: (v) => onChanged(control.propKey, v),
              )
            else if (control.type == ControlType.select)
              _SelectControl(
                control: control,
                value: props[control.propKey] as String,
                onChanged: (v) => onChanged(control.propKey, v),
              ),
        ],
      ),
    );
  }
}

class _ToggleControl extends StatelessWidget {
  const _ToggleControl({
    required this.control,
    required this.value,
    required this.onChanged,
  });

  final ComponentControl control;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(control.label, style: const TextStyle(fontSize: 13)),
        const SizedBox(width: 8),
        Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeColor: AppTheme.accent,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ],
    );
  }
}

class _SelectControl extends StatelessWidget {
  const _SelectControl({
    required this.control,
    required this.value,
    required this.onChanged,
  });

  final ComponentControl control;
  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(control.label, style: const TextStyle(fontSize: 13)),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: colors.card,
            border: Border.all(color: colors.border),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<String>(
            value: value,
            isDense: true,
            underline: const SizedBox.shrink(),
            style: const TextStyle(fontSize: 13),
            dropdownColor: colors.card,
            items: control.options!
                .map((o) => DropdownMenuItem(value: o, child: Text(o)))
                .toList(),
            onChanged: (v) {
              if (v != null) onChanged(v);
            },
          ),
        ),
      ],
    );
  }
}
