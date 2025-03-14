part of 'theme_bloc.dart';

abstract class ThemeState extends Equatable {
  const ThemeState();

  @override
  List<Object> get props => [];
}


class ThemeInitial extends ThemeState {}

class ThemeLoading extends ThemeState {}

class ThemeLoaded extends ThemeState {
  final CustomThemeMode customThemeMode;

  const ThemeLoaded({required this.customThemeMode});

  @override
  List<Object> get props => [customThemeMode];
}

class ThemeError extends ThemeState {
  final String message;

  const ThemeError(this.message);

  @override
  List<Object> get props => [message];
}