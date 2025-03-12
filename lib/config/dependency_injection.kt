import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:translator/translator.dart';

import '../core/logger/app_logger.dart';
import '../data/datasources/local/chat_local_datasource.dart';
import '../data/datasources/local/preferences_datasource.dart';
import '../data/datasources/remote/classifier_datasource.dart';
import '../data/datasources/remote/translator_datasource.dart';
import '../data/repositories/chat_repository_impl.dart';
import '../data/repositories/settings_repository_impl.dart';
import '../domain/repositories/chat_repository.dart';
import '../domain/repositories/classifier_repository_impl.dart';
import '../domain/repositories/settings_repository.dart';
import '../domain/repositories/classifier_repository.dart';
import '../domain/repositories/translator_repository.dart';
import '../domain/repositories/translator_repository_impl.dart';
import '../domain/usecases/chat/send_message.dart';
import '../domain/usecases/chat/get_message_history.dart';
import '../domain/usecases/chat/save_chat.dart';
import '../domain/usecases/chat/delete_chat.dart';
import '../domain/usecases/settings/get_settings.dart';
import '../domain/usecases/settings/toggle_theme.dart';
import '../domain/usecases/settings/change_language.dart';
import '../domain/usecases/classification/classify_text.dart';
import '../presentation/bloc/theme/theme_bloc.dart';
import '../presentation/bloc/language/language_bloc.dart';
import '../presentation/bloc/chat/chat_bloc.dart';
import '../core/services/translation_service.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  // Core
  getIt.registerSingleton<AppLogger>(AppLoggerImpl());

  // Внешние зависимости
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);
  getIt.registerLazySingleton<SpeechToText>(() => SpeechToText());
  getIt.registerLazySingleton<GoogleTranslator>(() => GoogleTranslator());

  // Сервисы
  getIt.registerLazySingleton<TranslationService>(
          () => TranslationServiceImpl()
  );

  // Источники данных
  getIt.registerLazySingleton<PreferencesDataSource>(
          () => PreferencesDataSourceImpl(prefs: getIt())
  );
  getIt.registerLazySingleton<ChatLocalDataSource>(
          () => ChatLocalDataSourceImpl(logger: getIt())
  );
  getIt.registerLazySingleton<ClassifierDataSource>(
          () => ClassifierDataSourceImpl()
  );
  getIt.registerLazySingleton<TranslatorDataSource>(
          () => TranslatorDataSourceImpl(translator: getIt())
  );

  // Репозитории
  getIt.registerLazySingleton<SettingsRepository>(
          () => SettingsRepositoryImpl(dataSource: getIt())
  );
  getIt.registerLazySingleton<ChatRepository>(
          () => ChatRepositoryImpl(dataSource: getIt(), logger: getIt())
  );
  getIt.registerLazySingleton<ClassifierRepository>(
          () => ClassifierRepositoryImpl(dataSource: getIt())
  );
  getIt.registerLazySingleton<TranslatorRepository>(
          () => TranslatorRepositoryImpl(dataSource: getIt())
  );

  // Сценарии использования
  getIt.registerLazySingleton(() => GetSettings(getIt()));
  getIt.registerLazySingleton(() => ToggleTheme(getIt()));
  getIt.registerLazySingleton(() => ChangeLanguage(getIt()));
  getIt.registerLazySingleton(() => GetMessageHistory(getIt()));
  getIt.registerLazySingleton(() => SendMessage(getIt(), getIt(), getIt()));
  getIt.registerLazySingleton(() => SaveChat(getIt()));
  getIt.registerLazySingleton(() => DeleteChat(getIt()));
  getIt.registerLazySingleton(() => ClassifyText(getIt()));

  // BLoCs
  getIt.registerFactory(() => ThemeBloc(toggleTheme: getIt(), getSettings: getIt()));
  getIt.registerFactory(() => LanguageBloc(changeLanguage: getIt(), getSettings: getIt()));
  getIt.registerFactory(() => ChatBloc(
      sendMessage: getIt(),
      getMessageHistory: getIt(),
      saveChat: getIt(),
      deleteChat: getIt()
  ));
}