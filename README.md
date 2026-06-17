# Flutter Component Library

An interactive UI component library built with Flutter Web. Instead of a standard app, this project demonstrates production-ready, reusable components — the kind of tools you'd build *for* other developers.

**[Live Demo →](https://caj654.github.io/flutter-library)**

---

## What's Inside

A responsive 3-pane dashboard:

| Pane | Description |
|------|-------------|
| **Sidebar** | Category-grouped component navigation |
| **Sandbox Canvas** | Live preview with toggle controls (dark mode, disabled state, etc.) |
| **Code Inspector** | Syntax-highlighted source code with a one-click Copy button |

---

## Components

### Buttons
- **Morphing Button** — Transforms from idle → loading spinner → success checkmark using `AnimatedContainer` and `AnimationController`
- **Neo-Brutalist Button** — Hard drop-shadow shifts on press via `Matrix4` translation; supports disabled state

### Cards
- **Parallax Product Card** — `MouseRegion` hover drives real-time 3D tilt using perspective transforms (`Matrix4.setEntry(3,2,...)`)
- **Glassmorphic Profile Card** — `BackdropFilter` blur with `SizeTransition` expand/collapse animation; tap to reveal stats

### Inputs
- **Animated Text Field** — Floating label animates out of the way using `AnimatedPositioned` with custom easing; border glows on focus
- **OTP Code Input** — Auto-advances focus box-to-box on input, retreats on backspace via `FocusNode.onKeyEvent`; confirms on fill

### Loaders
- **Liquid Circle Loader** — Fully custom `CustomPainter` wave animation. Zero Material widgets — just math and canvas.

---

## Technical Highlights

### 1. Code-as-String Architecture
Every component file exports two things: the live executable `Widget` class, and a `const String` containing its own source code. The Code Inspector panel reads that string directly — no build-time code generation or reflection needed.

```dart
// morphing_button.dart
const morphingButtonCode = r'''
class MorphingButton extends StatefulWidget { ... }
''';

class MorphingButton extends StatefulWidget { ... }
```

### 2. Clipboard Integration on Web
Uses Flutter's cross-platform `Clipboard.setData` with a temporary "Copied!" state to give the user feedback:

```dart
Future<void> _copy() async {
  await Clipboard.setData(ClipboardData(text: widget.item.codeSnippet));
  setState(() => _copied = true);
  await Future.delayed(const Duration(seconds: 2));
  if (mounted) setState(() => _copied = false);
}
```

### 3. Responsive Layout
Three distinct layouts driven by `MediaQuery` breakpoints — no packages needed:

| Width | Layout |
|-------|--------|
| ≥ 960px | Fixed sidebar + sandbox + code panel side-by-side |
| 640–959px | Slide-out drawer + collapsible code panel toggle |
| < 640px | Drawer + Preview / Code tab switcher |

### 4. Controls System
Each component declares `ComponentControl` entries (toggle or select). These drive a `Map<String, dynamic>` of props that rebuilds only the sandbox — not the entire registry — so adding a new control to any component is a one-liner.

---

## Running Locally

```bash
# Requires Flutter 3.22+
flutter pub get
flutter run -d chrome
```

To build for production:

```bash
flutter build web --release --web-renderer canvaskit
```

---

## Adding a New Component

1. Create `lib/components/<category>/my_widget.dart`
2. Export a `const String myWidgetCode = r''' ... ''';` containing the source
3. Export the `Widget` class
4. Register it in `lib/data/components_registry.dart`:

```dart
ComponentItem(
  id: 'my_widget',
  name: 'My Widget',
  description: 'What it does.',
  category: 'Buttons', // or any category
  controls: const [
    ComponentControl(
      label: 'Dark mode',
      propKey: 'darkMode',
      type: ControlType.toggle,
      defaultValue: false,
    ),
  ],
  builder: (props) => MyWidget(darkMode: props['darkMode'] as bool),
  codeSnippet: myWidgetCode,
),
```

That's it — the sidebar, controls bar, and code inspector all wire up automatically.

---

## Deployment

A GitHub Actions workflow builds and deploys to GitHub Pages automatically on every push to `main`.

To enable it:
1. Go to **Settings → Pages**
2. Set Source to **GitHub Actions**
3. Push to `main` — the workflow handles the rest

---

## Stack

- **Flutter 3.22** / Dart 3.3
- `google_fonts` — Inter typeface
- `flutter_highlight` — Syntax highlighting in the Code Inspector
- GitHub Actions + GitHub Pages — CI/CD
