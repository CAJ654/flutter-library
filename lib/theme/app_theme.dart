import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color accent = Color(0xFF6C63FF);
  static const Color accentLight = Color(0xFF9D97FF);
  static const Color success = Color(0xFF4CAF50);
  static const Color danger = Color(0xFFEF5350);

  static ThemeData get dark {
    const bg = Color(0xFF0D1117);
    const surface = Color(0xFF161B22);
    const card = Color(0xFF1C2128);
    const border = Color(0xFF30363D);
    const onSurface = Color(0xFFE6EDF3);
    const muted = Color(0xFF8B949E);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bg,
      colorScheme: const ColorScheme.dark(
        primary: accent,
        secondary: accentLight,
        surface: surface,
        onSurface: onSurface,
        outline: border,
      ),
      cardTheme: const CardTheme(color: card, elevation: 0),
      dividerTheme: const DividerThemeData(color: border),
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.dark().textTheme,
      ).copyWith(
        bodyMedium: GoogleFonts.inter(color: onSurface),
        bodySmall: GoogleFonts.inter(color: muted),
        labelSmall: GoogleFonts.inter(color: muted, fontSize: 11),
      ),
      extensions: const [AppColors(bg: bg, surface: surface, card: card, border: border, muted: muted)],
    );
  }

  static ThemeData get light {
    const bg = Color(0xFFF6F8FA);
    const surface = Color(0xFFFFFFFF);
    const card = Color(0xFFFFFFFF);
    const border = Color(0xFFD0D7DE);
    const onSurface = Color(0xFF24292F);
    const muted = Color(0xFF57606A);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: bg,
      colorScheme: const ColorScheme.light(
        primary: accent,
        secondary: accentLight,
        surface: surface,
        onSurface: onSurface,
        outline: border,
      ),
      cardTheme: const CardTheme(color: card, elevation: 0),
      dividerTheme: const DividerThemeData(color: border),
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.light().textTheme,
      ).copyWith(
        bodyMedium: GoogleFonts.inter(color: onSurface),
        bodySmall: GoogleFonts.inter(color: muted),
        labelSmall: GoogleFonts.inter(color: muted, fontSize: 11),
      ),
      extensions: const [AppColors(bg: bg, surface: surface, card: card, border: border, muted: muted)],
    );
  }
}

class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.bg,
    required this.surface,
    required this.card,
    required this.border,
    required this.muted,
  });

  final Color bg;
  final Color surface;
  final Color card;
  final Color border;
  final Color muted;

  @override
  AppColors copyWith({Color? bg, Color? surface, Color? card, Color? border, Color? muted}) {
    return AppColors(
      bg: bg ?? this.bg,
      surface: surface ?? this.surface,
      card: card ?? this.card,
      border: border ?? this.border,
      muted: muted ?? this.muted,
    );
  }

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other == null) return this;
    return AppColors(
      bg: Color.lerp(bg, other.bg, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      card: Color.lerp(card, other.card, t)!,
      border: Color.lerp(border, other.border, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
    );
  }
}

extension AppColorsExt on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
}
