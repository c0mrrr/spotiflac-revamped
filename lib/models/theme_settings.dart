import 'package:flutter/material.dart';

const String kThemeModeKey = 'theme_mode';
const String kUseDynamicColorKey = 'use_dynamic_color';
const String kSeedColorKey = 'seed_color';
const String kUseAmoledKey = 'use_amoled';
const String kUseArtworkBackgroundKey = 'use_artwork_background';
const String kEnableBlurKey = 'enable_blur';

/// Default Spotify green color for fallback
const int kDefaultSeedColor = 0xFF1DB954;

class ThemeSettings {
  final ThemeMode themeMode;
  final bool useDynamicColor;
  final int seedColorValue;
  final bool useAmoled;
  final bool useArtworkBackground;
  final double artworkAnimationSpeed;
  final bool enableBlur;

  const ThemeSettings({
    this.themeMode = ThemeMode.system,
    this.useDynamicColor = true,
    this.seedColorValue = kDefaultSeedColor,
    this.useAmoled = false,
    this.useArtworkBackground = false,
    this.artworkAnimationSpeed = 1.0,
    this.enableBlur = true,
  });

  Color get seedColor => Color(seedColorValue);

  ThemeSettings copyWith({
    ThemeMode? themeMode,
    bool? useDynamicColor,
    int? seedColorValue,
    bool? useAmoled,
    bool? useArtworkBackground,
    double? artworkAnimationSpeed,
    bool? enableBlur,
  }) {
    return ThemeSettings(
      themeMode: themeMode ?? this.themeMode,
      useDynamicColor: useDynamicColor ?? this.useDynamicColor,
      seedColorValue: seedColorValue ?? this.seedColorValue,
      useAmoled: useAmoled ?? this.useAmoled,
      useArtworkBackground: useArtworkBackground ?? this.useArtworkBackground,
      artworkAnimationSpeed: artworkAnimationSpeed ?? this.artworkAnimationSpeed,
      enableBlur: enableBlur ?? this.enableBlur,
    );
  }

  Map<String, dynamic> toJson() => {
        kThemeModeKey: themeMode.name,
        kUseDynamicColorKey: useDynamicColor,
        kSeedColorKey: seedColorValue,
        kUseAmoledKey: useAmoled,
        kUseArtworkBackgroundKey: useArtworkBackground,
        'artwork_animation_speed': artworkAnimationSpeed,
        kEnableBlurKey: enableBlur,
      };

  factory ThemeSettings.fromJson(Map<String, dynamic> json) {
    return ThemeSettings(
      themeMode: themeModeFromString(json[kThemeModeKey] as String?),
      useDynamicColor: json[kUseDynamicColorKey] as bool? ?? true,
      seedColorValue: json[kSeedColorKey] as int? ?? kDefaultSeedColor,
      useAmoled: json[kUseAmoledKey] as bool? ?? false,
      useArtworkBackground: json[kUseArtworkBackgroundKey] as bool? ?? false,
      artworkAnimationSpeed: (json['artwork_animation_speed'] as num?)?.toDouble() ?? 1.0,
      enableBlur: json[kEnableBlurKey] as bool? ?? true,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ThemeSettings &&
        other.themeMode == themeMode &&
        other.useDynamicColor == useDynamicColor &&
        other.seedColorValue == seedColorValue &&
        other.useAmoled == useAmoled &&
        other.useArtworkBackground == useArtworkBackground &&
        other.artworkAnimationSpeed == artworkAnimationSpeed &&
        other.enableBlur == enableBlur;
  }

  @override
  int get hashCode =>
      themeMode.hashCode ^ 
      useDynamicColor.hashCode ^ 
      seedColorValue.hashCode ^ 
      useAmoled.hashCode ^ 
      useArtworkBackground.hashCode ^
      artworkAnimationSpeed.hashCode ^
      enableBlur.hashCode;
}

ThemeMode themeModeFromString(String? value) {
  if (value == null) return ThemeMode.system;
  return ThemeMode.values.firstWhere(
    (e) => e.name == value,
    orElse: () => ThemeMode.system,
  );
}
