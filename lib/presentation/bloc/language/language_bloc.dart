import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/usecases/settings/change_language.dart';
import '../../../domain/usecases/settings/get_settings.dart';
import '../../../core/logger/app_logger.dart';

part 'language_event.dart';
part 'language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  final ChangeLanguage changeLanguage;
  final GetSettings getSettings;

  LanguageBloc({
    required this.changeLanguage,
    required this.getSettings,
  }) : super(LanguageInitial()) {
    on<InitializeLanguage>(_onInitializeLanguage);
    on<ChangeLanguageEvent>(_onChangeLanguage);
  }

  Future<void> _onInitializeLanguage(
      InitializeLanguage event,
      Emitter<LanguageState> emit,
      ) async {
    try {
      AppLogger.debug('Инициализация языка');
      emit(LanguageLoading());

      final settings = await getSettings();
      final languageCode = settings.fold(
            (failure) => 'en',
            (settings) => settings.languageCode,
      );

      emit(LanguageLoaded(languageCode: languageCode));
      AppLogger.debug('Язык инициализирован: $languageCode');
    } catch (e) {
      AppLogger.error('Ошибка при инициализации языка', e);
      emit(LanguageError('Ошибка при загрузке языка'));
      emit(const LanguageLoaded(languageCode: 'en'));
    }
  }

  Future<void> _onChangeLanguage(
      ChangeLanguageEvent event,
      Emitter<LanguageState> emit,
      ) async {
    try {
      AppLogger.debug('Изменение языка на: ${event.languageCode}');
      emit(LanguageLoading());

      final result = await changeLanguage(event.languageCode);

      result.fold(
              (failure) {
            AppLogger.error('Ошибка при изменении языка: ${failure.message}');
            emit(LanguageError(failure.message));
            if (state is LanguageLoaded) {
              emit(state); // Возвращаем предыдущее состояние
            } else {
              emit(const LanguageLoaded(languageCode: 'en'));
            }
          },
              (success) {
            AppLogger.debug('Язык успешно изменен на: ${event.languageCode}');
            emit(LanguageLoaded(languageCode: event.languageCode));
          }
      );
    } catch (e) {
      AppLogger.error('Необработанная ошибка при изменении языка', e);
      emit(LanguageError('Произошла ошибка при изменении языка'));
      if (state is LanguageLoaded) {
        emit(state); // Возвращаем предыдущее состояние
      } else {
        emit(const LanguageLoaded(languageCode: 'en'));
      }
    }
  }
}