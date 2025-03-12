part of 'theme_bloc.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

class InitializeTheme extends ThemeEvent {}

class ToggleThemeEvent extends ThemeEvent {}

class SetSpecificTheme extends ThemeEvent {
  final ThemeMode themeMode;

  const SetSpecificTheme(this.themeMode);

  @override
  List<Object> get props => [themeMode];
}