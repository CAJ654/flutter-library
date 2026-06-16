import 'dart:ui';
import 'package:flutter/material.dart';

const glassmorphicCardCode = r'''
class GlassmorphicProfileCard extends StatefulWidget {
  const GlassmorphicProfileCard({super.key});

  @override
  State<GlassmorphicProfileCard> createState() =>
      _GlassmorphicProfileCardState();
}

class _GlassmorphicProfileCardState extends State<GlassmorphicProfileCard>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 400),
  );
  late final Animation<double> _expand =
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOutCubic);

  void _toggle() {
    _expanded ? _ctrl.reverse() : _ctrl.forward();
    setState(() => _expanded = !_expanded);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggle,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOutCubic,
            width: 280,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.25)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ... card content
              ],
            ),
          ),
        ),
      ),
    );
  }
}
''';

class GlassmorphicProfileCard extends StatefulWidget {
  const GlassmorphicProfileCard({super.key, this.darkMode = false});

  final bool darkMode;

  @override
  State<GlassmorphicProfileCard> createState() => _GlassmorphicProfileCardState();
}

class _GlassmorphicProfileCardState extends State<GlassmorphicProfileCard>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;

  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 400),
  );
  late final Animation<double> _expandAnim =
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOutCubic);

  void _toggle() {
    if (_expanded) {
      _ctrl.reverse();
    } else {
      _ctrl.forward();
    }
    setState(() => _expanded = !_expanded);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: widget.darkMode
              ? [const Color(0xFF1A1A2E), const Color(0xFF16213E)]
              : [const Color(0xFF667EEA), const Color(0xFF764BA2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.all(40),
      child: GestureDetector(
        onTap: _toggle,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOutCubic,
              width: 280,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.22), width: 1.5),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xFF6C63FF), Color(0xFFFF6584)],
                            ),
                            border: Border.all(color: Colors.white.withOpacity(0.4), width: 2),
                          ),
                          child: const Center(
                            child: Text('AJ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18)),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Alex Johnson',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Senior Flutter Dev',
                                style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        AnimatedRotation(
                          turns: _expanded ? 0.5 : 0,
                          duration: const Duration(milliseconds: 400),
                          child: Icon(Icons.keyboard_arrow_down_rounded,
                              color: Colors.white.withOpacity(0.7)),
                        ),
                      ],
                    ),
                  ),
                  SizeTransition(
                    sizeFactor: _expandAnim,
                    child: Column(
                      children: [
                        Divider(color: Colors.white.withOpacity(0.15), height: 1),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              _statRow('Projects', '47', Icons.folder_outlined),
                              const SizedBox(height: 10),
                              _statRow('Stars', '1.2k', Icons.star_outline_rounded),
                              const SizedBox(height: 10),
                              _statRow('Followers', '340', Icons.people_outline_rounded),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF6C63FF),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'View Profile',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _statRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.white.withOpacity(0.6), size: 18),
        const SizedBox(width: 10),
        Text(label, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13)),
        const Spacer(),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
      ],
    );
  }
}
