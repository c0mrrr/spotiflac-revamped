import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotiflac_android/providers/theme_provider.dart';
import 'dart:ui' as dart_ui;

class FrostedGlassBackground extends ConsumerWidget {
  const FrostedGlassBackground({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enableBlur = ref.watch(themeProvider).enableBlur;
    final colorScheme = Theme.of(context).colorScheme;

    if (!enableBlur) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: colorScheme.surface,
      );
    }

    return ClipRect(
      child: BackdropFilter(
        filter: dart_ui.ImageFilter.blur(sigmaX: 18.0, sigmaY: 18.0),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: colorScheme.surface.withAlpha(178), // 0.7 opacity
        ),
      ),
    );
  }
}
