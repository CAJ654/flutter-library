import 'package:flutter/widgets.dart';

enum ControlType { toggle, select }

class ComponentControl {
  const ComponentControl({
    required this.label,
    required this.propKey,
    required this.type,
    required this.defaultValue,
    this.options,
  });

  final String label;
  final String propKey;
  final ControlType type;
  final dynamic defaultValue;
  final List<String>? options;
}

class ComponentItem {
  const ComponentItem({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.builder,
    required this.codeSnippet,
    this.controls = const [],
  });

  final String id;
  final String name;
  final String description;
  final String category;
  final Widget Function(Map<String, dynamic> props) builder;
  final String codeSnippet;
  final List<ComponentControl> controls;

  Map<String, dynamic> get defaultProps => {
        for (final c in controls) c.propKey: c.defaultValue,
      };
}
