import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotiflac_android/models/theme_settings.dart';

final themeProvider = NotifierProvider<ThemeNotifier, ThemeSettings>(() {
  return ThemeNotifier();
});

class ThemeNotifier extends Notifier<ThemeSettings> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  ThemeSettings build() {
    _loadFromStorage();
    return const ThemeSettings();
  }

  Future<void> _loadFromStorage() async {
    try {
      final prefs = await _prefs;
      final modeString = prefs.getString(kThemeModeKey);
      final useDynamic = prefs.getBool(kUseDynamicColorKey);
      final seedColor = prefs.getInt(kSeedColorKey);
      final useAmoled = prefs.getBool(kUseAmoledKey);
      final useArtworkBg = prefs.getBool(kUseArtworkBackgroundKey);
      final artworkSpeed = prefs.getDouble('artwork_animation_speed');
      final enableBlur = prefs.getBool(kEnableBlurKey);

      state = ThemeSettings(
        themeMode: themeModeFromString(modeString),
        useDynamicColor: useDynamic ?? true,
        seedColorValue: seedColor ?? kDefaultSeedColor,
        useAmoled: useAmoled ?? false,
        useArtworkBackground: useArtworkBg ?? false,
        artworkAnimationSpeed: artworkSpeed ?? 1.0,
        enableBlur: enableBlur ?? true,
      );
    } catch (e) {
      debugPrint('Error loading theme settings: $e');
    }
  }

  Future<void> _saveToStorage() async {
    try {
      final prefs = await _prefs;
      await prefs.setString(kThemeModeKey, state.themeMode.name);
      await prefs.setBool(kUseDynamicColorKey, state.useDynamicColor);
      await prefs.setInt(kSeedColorKey, state.seedColorValue);
      await prefs.setBool(kUseAmoledKey, state.useAmoled);
      await prefs.setBool(kUseArtworkBackgroundKey, state.useArtworkBackground);
      await prefs.setDouble('artwork_animation_speed', state.artworkAnimationSpeed);
      await prefs.setBool(kEnableBlurKey, state.enableBlur);
    } catch (e) {
      debugPrint('Error saving theme settings: $e');
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    await _saveToStorage();
  }

  Future<void> setUseDynamicColor(bool value) async {
    state = state.copyWith(useDynamicColor: value);
    await _saveToStorage();
  }

  Future<void> setEnableBlur(bool value) async {
    state = state.copyWith(enableBlur: value);
    await _saveToStorage();
  }

  Future<void> setSeedColor(Color color) async {
    state = state.copyWith(seedColorValue: color.toARGB32());
    await _saveToStorage();
  }

  Future<void> setSeedColorValue(int colorValue) async {
    state = state.copyWith(seedColorValue: colorValue);
    await _saveToStorage();
  }

  Future<void> setUseAmoled(bool value) async {
    state = state.copyWith(useAmoled: value);
    await _saveToStorage();
  }
  
  Future<void> setUseArtworkBackground(bool value) async {
    state = state.copyWith(useArtworkBackground: value);
    await _saveToStorage();
  }

  Future<void> setArtworkAnimationSpeed(double value) async {
    state = state.copyWith(artworkAnimationSpeed: value);
    await _saveToStorage();
  }
}
