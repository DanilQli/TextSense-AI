import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../app.dart';
import '../../../domain/usecases/settings/toggle_theme.dart';
import '../../../domain/usecases/settings/get_settings.dart';
import '../../../core/logger/app_logger.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final ToggleTheme toggleTheme;
  final GetSettings getSettings;

  ThemeBloc({
    required this.toggleTheme,
    required this.getSettings,
  }) : super(ThemeInitial()) {
    on<InitializeTheme>(_onInitializeTheme);
    on<ToggleThemeEvent>(_onToggleTheme);
    on<SetSpecificTheme>(_onSetSpecificTheme);
  }

  Future<void> _onInitializeTheme(
      InitializeTheme event,
      Emitter<ThemeState> emit,
      ) async {
    try {
      AppLogger.debug('Инициализация темы');
      emit(ThemeLoading());

      final settings = await getSettings();
      final customThemeMode = settings.fold(
            (failure) => CustomThemeMode.system,
            (settings) => settings.customThemeMode,
      );

      emit(ThemeLoaded(customThemeMode: customThemeMode));
      AppLogger.debug('Тема инициализирована: $customThemeMode');
    } catch (e) {
      AppLogger.error('Ошибка при инициализации темы', e);
      emit(const ThemeError('Ошибка при загрузке темы'));
      emit(const ThemeLoaded(customThemeMode: CustomThemeMode.system));
    }
  }

  Future<void> _onToggleTheme(
      ToggleThemeEvent event,
      Emitter<ThemeState> emit,
      ) async {
    try {
      if (state is ThemeLoaded) {
        final currentTheme = (state as ThemeLoaded).customThemeMode;
        AppLogger.debug('Переключение темы с $currentTheme');

        final newThemeMode = await toggleTheme();

        newThemeMode.fold(
                (failure) {
              AppLogger.error('Ошибка при переключении темы: ${failure.message}');
              emit(ThemeError(failure.message));
              emit(state); // Возвращаем предыдущее состояние
            },
                (themeMode) {
              AppLogger.debug('Тема переключена на $themeMode');
              emit(ThemeLoaded(customThemeMode: themeMode));
            }
        );
      }
    } catch (e) {
      AppLogger.error('Необработанная ошибка при переключении темы', e);
      emit(ThemeError('Произошла ошибка при изменении темы'));
      emit(state); // Возвращаем предыдущее состояние
    }
  }

  Future<void> _onSetSpecificTheme(
      SetSpecificTheme event,
      Emitter<ThemeState> emit,
      ) async {
    try {
      AppLogger.debug('Установка конкретной темы: ${event.customThemeMode}');

      // Используем usecase для сохранения темы (можно создать отдельный usecase SetTheme)
      final result = await toggleTheme.repository.saveThemeMode(event.customThemeMode);

      result.fold(
              (failure) {
            AppLogger.error('Ошибка при установке темы: ${failure.message}');
            emit(ThemeError(failure.message));
            emit(state); // Возвращаем предыдущее состояние
          },
              (success) {
            AppLogger.debug('Тема успешно установлена: ${event.customThemeMode}');
            emit(ThemeLoaded(customThemeMode: event.customThemeMode));
          }
      );
    } catch (e) {
      AppLogger.error('Необработанная ошибка при установке темы', e);
      emit(ThemeError('Произошла ошибка при изменении темы'));
      emit(state); // Возвращаем предыдущее состояние
    }
  }
}