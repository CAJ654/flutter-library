import '../models/component_item.dart';
import '../components/buttons/morphing_button.dart';
import '../components/buttons/neo_brutalist_button.dart';
import '../components/cards/parallax_card.dart';
import '../components/cards/glassmorphic_card.dart';
import '../components/inputs/animated_text_field.dart';
import '../components/inputs/otp_input.dart';
import '../components/loaders/liquid_loader.dart';

final List<ComponentItem> allComponents = [
  ComponentItem(
    id: 'morphing_button',
    name: 'Morphing Button',
    description: 'Transforms from idle → loading spinner → success checkmark.',
    category: 'Buttons',
    controls: const [
      ComponentControl(
        label: 'Dark mode',
        propKey: 'darkMode',
        type: ControlType.toggle,
        defaultValue: false,
      ),
    ],
    builder: (props) => MorphingButton(darkMode: props['darkMode'] as bool),
    codeSnippet: morphingButtonCode,
  ),
  ComponentItem(
    id: 'neo_brutalist_button',
    name: 'Neo-Brutalist Button',
    description: 'Hard drop-shadow shifts on press. Bold, tactile, impossible to ignore.',
    category: 'Buttons',
    controls: const [
      ComponentControl(
        label: 'Disabled',
        propKey: 'disabled',
        type: ControlType.toggle,
        defaultValue: false,
      ),
      ComponentControl(
        label: 'Dark mode',
        propKey: 'darkMode',
        type: ControlType.toggle,
        defaultValue: false,
      ),
    ],
    builder: (props) => NeoBrutalistButton(
      disabled: props['disabled'] as bool,
      darkMode: props['darkMode'] as bool,
    ),
    codeSnippet: neoBrutalistButtonCode,
  ),
  ComponentItem(
    id: 'parallax_card',
    name: 'Parallax Product Card',
    description: 'MouseRegion hover drives a real-time 3D tilt using perspective transforms.',
    category: 'Cards',
    controls: const [
      ComponentControl(
        label: 'Dark mode',
        propKey: 'darkMode',
        type: ControlType.toggle,
        defaultValue: false,
      ),
    ],
    builder: (props) => ParallaxProductCard(darkMode: props['darkMode'] as bool),
    codeSnippet: parallaxCardCode,
  ),
  ComponentItem(
    id: 'glassmorphic_card',
    name: 'Glassmorphic Profile Card',
    description: 'BackdropFilter blur with animated expand/collapse. Tap to expand stats.',
    category: 'Cards',
    controls: const [
      ComponentControl(
        label: 'Dark mode',
        propKey: 'darkMode',
        type: ControlType.toggle,
        defaultValue: false,
      ),
    ],
    builder: (props) => GlassmorphicProfileCard(darkMode: props['darkMode'] as bool),
    codeSnippet: glassmorphicCardCode,
  ),
  ComponentItem(
    id: 'animated_text_field',
    name: 'Animated Text Field',
    description: 'Floating label animates out on focus. Border glows with a shadow pulse.',
    category: 'Inputs',
    controls: const [
      ComponentControl(
        label: 'Dark mode',
        propKey: 'darkMode',
        type: ControlType.toggle,
        defaultValue: false,
      ),
    ],
    builder: (props) => AnimatedTextField(darkMode: props['darkMode'] as bool),
    codeSnippet: animatedTextFieldCode,
  ),
  ComponentItem(
    id: 'otp_input',
    name: 'OTP Code Input',
    description: 'Auto-advances focus box-to-box. Backspace retreats. Confirms on fill.',
    category: 'Inputs',
    controls: const [
      ComponentControl(
        label: 'Dark mode',
        propKey: 'darkMode',
        type: ControlType.toggle,
        defaultValue: false,
      ),
    ],
    builder: (props) => OtpInput(darkMode: props['darkMode'] as bool),
    codeSnippet: otpInputCode,
  ),
  ComponentItem(
    id: 'liquid_loader',
    name: 'Liquid Circle Loader',
    description: 'CustomPainter-drawn wave animation, no Material progress bars.',
    category: 'Loaders',
    controls: const [
      ComponentControl(
        label: 'Dark mode',
        propKey: 'darkMode',
        type: ControlType.toggle,
        defaultValue: false,
      ),
      ComponentControl(
        label: 'Progress',
        propKey: 'progress',
        type: ControlType.select,
        defaultValue: '65%',
        options: ['25%', '50%', '65%', '80%', '100%'],
      ),
    ],
    builder: (props) {
      final pct = int.parse((props['progress'] as String).replaceAll('%', ''));
      return LiquidCircleLoader(
        darkMode: props['darkMode'] as bool,
        progressValue: pct / 100,
      );
    },
    codeSnippet: liquidLoaderCode,
  ),
];

Map<String, List<ComponentItem>> get componentsByCategory {
  final map = <String, List<ComponentItem>>{};
  for (final item in allComponents) {
    map.putIfAbsent(item.category, () => []).add(item);
  }
  return map;
}
