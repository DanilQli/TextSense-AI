//theme_toggle_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/services/translation_service.dart';
import '../../core/utils/translation_utils.dart';
import '../bloc/theme/theme_bloc.dart';

class ThemeToggleButton extends StatelessWidget {
  final bool isDarkMode;
  final Function()? onPressed;
  final double size;
  final Color? color;
  final String? tooltip;

  const ThemeToggleButton({
    super.key,
    required this.isDarkMode,
    this.onPressed,
    this.size = 24.0,
    this.color,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final customOnPressed = onPressed ?? () {
      context.read<ThemeBloc>().add(ToggleThemeEvent());
    };

    return IconButton(
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return RotationTransition(
            turns: animation,
            child: ScaleTransition(
              scale: animation,
              child: child,
            ),
          );
        },
        child: Icon(
          isDarkMode ? Icons.light_mode : Icons.dark_mode,
          key: ValueKey<bool>(isDarkMode),
          size: size,
          color: color ?? Theme.of(context).iconTheme.color,
        ),
      ),
      onPressed: customOnPressed,
      tooltip: tooltip ?? (isDarkMode ? Tr.get(TranslationKeys.switchToLightTheme) : Tr.get(TranslationKeys.switchToDarkTheme)),
    );
  }
}