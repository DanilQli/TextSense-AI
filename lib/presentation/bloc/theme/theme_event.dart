part of 'theme_bloc.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

class InitializeTheme extends ThemeEvent {}

class ToggleThemeEvent extends ThemeEvent {}

class SetSpecificTheme extends ThemeEvent {
  final CustomThemeMode customThemeMode;

  const SetSpecificTheme(this.customThemeMode);

  @override
  List<Object> get props => [customThemeMode];
}

class ChangeTheme extends ThemeEvent {
  final String themeName;

  const ChangeTheme(this.themeName);
}