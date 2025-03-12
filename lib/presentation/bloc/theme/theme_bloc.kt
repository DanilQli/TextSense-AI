import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
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
      final themeMode = settings.fold(
            (failure) => ThemeMode.system,
            (settings) => settings.themeMode,
      );

      emit(ThemeLoaded(themeMode: themeMode));
      AppLogger.debug('Тема инициализирована: $themeMode');
    } catch (e) {
      AppLogger.error('Ошибка при инициализации темы', e);
      emit(ThemeError('Ошибка при загрузке темы'));
      emit(ThemeLoaded(themeMode: ThemeMode.system));
    }
  }

  Future<void> _onToggleTheme(
      ToggleThemeEvent event,
      Emitter<ThemeState> emit,
      ) async {
    try {
      if (state is ThemeLoaded) {
        final currentTheme = (state as ThemeLoaded).themeMode;
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
              emit(ThemeLoaded(themeMode: themeMode));
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
      AppLogger.debug('Установка конкретной темы: ${event.themeMode}');

      // Используем usecase для сохранения темы (можно создать отдельный usecase SetTheme)
      final result = await toggleTheme.repository.saveThemeMode(event.themeMode);

      result.fold(
              (failure) {
            AppLogger.error('Ошибка при установке темы: ${failure.message}');
            emit(ThemeError(failure.message));
            emit(state); // Возвращаем предыдущее состояние
          },
              (success) {
            AppLogger.debug('Тема успешно установлена: ${event.themeMode}');
            emit(ThemeLoaded(themeMode: event.themeMode));
          }
      );
    } catch (e) {
      AppLogger.error('Необработанная ошибка при установке темы', e);
      emit(ThemeError('Произошла ошибка при изменении темы'));
      emit(state); // Возвращаем предыдущее состояние
    }
  }
}