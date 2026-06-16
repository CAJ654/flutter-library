import 'package:flutter/material.dart';
import '../data/components_registry.dart';
import '../models/component_item.dart';
import '../theme/app_theme.dart';
import '../widgets/sidebar.dart';
import '../widgets/sandbox_canvas.dart';
import '../widgets/code_inspector.dart';

class ShellScreen extends StatefulWidget {
  const ShellScreen({
    super.key,
    required this.isDark,
    required this.onToggleTheme,
  });

  final bool isDark;
  final VoidCallback onToggleTheme;

  @override
  State<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends State<ShellScreen> {
  ComponentItem _selected = allComponents.first;
  late Map<String, dynamic> _props = allComponents.first.defaultProps;
  bool _drawerOpen = false;
  bool _showCode = true;

  void _selectComponent(ComponentItem item) {
    setState(() {
      _selected = item;
      _props = item.defaultProps;
      _drawerOpen = false;
    });
  }

  void _onPropChanged(String key, dynamic value) {
    setState(() => _props = {..._props, key: value});
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isWide = width >= 960;
    final isMedium = width >= 640;

    final themeIcon = widget.isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded;
    final themeTooltip = widget.isDark ? 'Light mode' : 'Dark mode';

    if (isWide) {
      return _WideLayout(
        selected: _selected,
        props: _props,
        drawerOpen: _drawerOpen,
        themeIcon: themeIcon,
        themeTooltip: themeTooltip,
        onSelectComponent: _selectComponent,
        onPropChanged: _onPropChanged,
        onToggleTheme: widget.onToggleTheme,
      );
    }

    if (isMedium) {
      return _MediumLayout(
        selected: _selected,
        props: _props,
        drawerOpen: _drawerOpen,
        showCode: _showCode,
        themeIcon: themeIcon,
        themeTooltip: themeTooltip,
        onSelectComponent: _selectComponent,
        onPropChanged: _onPropChanged,
        onToggleTheme: widget.onToggleTheme,
        onToggleDrawer: () => setState(() => _drawerOpen = !_drawerOpen),
        onCloseDrawer: () => setState(() => _drawerOpen = false),
        onToggleCode: () => setState(() => _showCode = !_showCode),
      );
    }

    return _NarrowLayout(
      selected: _selected,
      props: _props,
      drawerOpen: _drawerOpen,
      themeIcon: themeIcon,
      themeTooltip: themeTooltip,
      onSelectComponent: _selectComponent,
      onPropChanged: _onPropChanged,
      onToggleTheme: widget.onToggleTheme,
      onToggleDrawer: () => setState(() => _drawerOpen = !_drawerOpen),
      onCloseDrawer: () => setState(() => _drawerOpen = false),
    );
  }
}

// ─── Wide (≥960px) ───────────────────────────────────────────────────────────

class _WideLayout extends StatelessWidget {
  const _WideLayout({
    required this.selected,
    required this.props,
    required this.drawerOpen,
    required this.themeIcon,
    required this.themeTooltip,
    required this.onSelectComponent,
    required this.onPropChanged,
    required this.onToggleTheme,
  });

  final ComponentItem selected;
  final Map<String, dynamic> props;
  final bool drawerOpen;
  final IconData themeIcon;
  final String themeTooltip;
  final ValueChanged<ComponentItem> onSelectComponent;
  final void Function(String, dynamic) onPropChanged;
  final VoidCallback onToggleTheme;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      body: Row(
        children: [
          SizedBox(
            width: 240,
            child: Sidebar(selected: selected, onSelect: onSelectComponent),
          ),
          VerticalDivider(width: 1, color: colors.border),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  flex: 6,
                  child: SandboxCanvas(
                    item: selected,
                    props: props,
                    onPropChanged: onPropChanged,
                    onToggleTheme: onToggleTheme,
                    themeIcon: themeIcon,
                    themeTooltip: themeTooltip,
                  ),
                ),
                SizedBox(
                  height: 280,
                  child: CodeInspector(item: selected),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Medium (640–959px) ──────────────────────────────────────────────────────

class _MediumLayout extends StatelessWidget {
  const _MediumLayout({
    required this.selected,
    required this.props,
    required this.drawerOpen,
    required this.showCode,
    required this.themeIcon,
    required this.themeTooltip,
    required this.onSelectComponent,
    required this.onPropChanged,
    required this.onToggleTheme,
    required this.onToggleDrawer,
    required this.onCloseDrawer,
    required this.onToggleCode,
  });

  final ComponentItem selected;
  final Map<String, dynamic> props;
  final bool drawerOpen;
  final bool showCode;
  final IconData themeIcon;
  final String themeTooltip;
  final ValueChanged<ComponentItem> onSelectComponent;
  final void Function(String, dynamic) onPropChanged;
  final VoidCallback onToggleTheme;
  final VoidCallback onToggleDrawer;
  final VoidCallback onCloseDrawer;
  final VoidCallback onToggleCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _SharedAppBar(
        onMenu: onToggleDrawer,
        themeIcon: themeIcon,
        themeTooltip: themeTooltip,
        onToggleTheme: onToggleTheme,
        trailing: IconButton(
          icon: Icon(showCode ? Icons.code_off_rounded : Icons.code_rounded),
          onPressed: onToggleCode,
          tooltip: showCode ? 'Hide code' : 'Show code',
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: SandboxCanvas(
                  item: selected,
                  props: props,
                  onPropChanged: onPropChanged,
                ),
              ),
              if (showCode)
                SizedBox(height: 260, child: CodeInspector(item: selected)),
            ],
          ),
          if (drawerOpen)
            _DrawerOverlay(
              onDismiss: onCloseDrawer,
              child: SizedBox(
                width: 260,
                child: Sidebar(
                  selected: selected,
                  onSelect: onSelectComponent,
                  onClose: onCloseDrawer,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Narrow (<640px) ─────────────────────────────────────────────────────────

class _NarrowLayout extends StatefulWidget {
  const _NarrowLayout({
    required this.selected,
    required this.props,
    required this.drawerOpen,
    required this.themeIcon,
    required this.themeTooltip,
    required this.onSelectComponent,
    required this.onPropChanged,
    required this.onToggleTheme,
    required this.onToggleDrawer,
    required this.onCloseDrawer,
  });

  final ComponentItem selected;
  final Map<String, dynamic> props;
  final bool drawerOpen;
  final IconData themeIcon;
  final String themeTooltip;
  final ValueChanged<ComponentItem> onSelectComponent;
  final void Function(String, dynamic) onPropChanged;
  final VoidCallback onToggleTheme;
  final VoidCallback onToggleDrawer;
  final VoidCallback onCloseDrawer;

  @override
  State<_NarrowLayout> createState() => _NarrowLayoutState();
}

class _NarrowLayoutState extends State<_NarrowLayout>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs = TabController(length: 2, vsync: this);

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _SharedAppBar(
        onMenu: widget.onToggleDrawer,
        themeIcon: widget.themeIcon,
        themeTooltip: widget.themeTooltip,
        onToggleTheme: widget.onToggleTheme,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              TabBar(
                controller: _tabs,
                tabs: const [Tab(text: 'Preview'), Tab(text: 'Code')],
                indicatorColor: AppTheme.accent,
                labelColor: AppTheme.accent,
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabs,
                  children: [
                    SandboxCanvas(
                      item: widget.selected,
                      props: widget.props,
                      onPropChanged: widget.onPropChanged,
                    ),
                    CodeInspector(item: widget.selected),
                  ],
                ),
              ),
            ],
          ),
          if (widget.drawerOpen)
            _DrawerOverlay(
              onDismiss: widget.onCloseDrawer,
              child: SizedBox(
                width: 260,
                child: Sidebar(
                  selected: widget.selected,
                  onSelect: widget.onSelectComponent,
                  onClose: widget.onCloseDrawer,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Shared sub-widgets ──────────────────────────────────────────────────────

class _SharedAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _SharedAppBar({
    required this.onMenu,
    required this.themeIcon,
    required this.themeTooltip,
    required this.onToggleTheme,
    this.trailing,
  });

  final VoidCallback onMenu;
  final IconData themeIcon;
  final String themeTooltip;
  final VoidCallback onToggleTheme;
  final Widget? trailing;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'Component Library',
        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
      ),
      leading: IconButton(
        icon: const Icon(Icons.menu_rounded),
        onPressed: onMenu,
      ),
      actions: [
        if (trailing != null) trailing!,
        IconButton(
          icon: Icon(themeIcon),
          tooltip: themeTooltip,
          onPressed: onToggleTheme,
        ),
        const SizedBox(width: 4),
      ],
    );
  }
}

class _DrawerOverlay extends StatelessWidget {
  const _DrawerOverlay({required this.child, required this.onDismiss});

  final Widget child;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: onDismiss,
          child: Container(color: Colors.black54),
        ),
        child,
      ],
    );
  }
}
