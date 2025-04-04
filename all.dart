// app.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'config/dependency_injection.dart';
import 'config/routes.dart';
import 'presentation/bloc/theme/theme_bloc.dart';
import 'presentation/bloc/language/language_bloc.dart';
class ChatApp extends StatelessWidget {
  const ChatApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeBloc>(
          create: (_) => getIt<ThemeBloc>()..add(InitializeTheme()),
        ),
        BlocProvider<LanguageBloc>(
          create: (_) => getIt<LanguageBloc>()..add(InitializeLanguage()),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          final customThemeMode = themeState is ThemeLoaded
              ? themeState.customThemeMode
              : ThemeMode.system;
          return BlocBuilder<LanguageBloc, LanguageState>(
            builder: (context, languageState) {
              final locale = languageState is LanguageLoaded
                  ? Locale(languageState.languageCode)
                  : const Locale('en');
              return MaterialApp(
                title: 'TextSense AI',
                theme:  _getTheme(customThemeMode as CustomThemeMode),
                locale: locale,
                localizationsDelegates: const [
                // Добавляем стандартные делегаты локализации Flutter
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
                initialRoute: AppRoutes.chat,
                onGenerateRoute: AppRouter.onGenerateRoute,
                debugShowCheckedModeBanner: false,
              );
            },
          );
        },
      ),
    );
  }
}
enum CustomThemeMode {
  light,
  dark,
  blue,
  green,
  orange,
  royalPurple,
  amethystDark,
  coffee,
  system,
}
ThemeData _getTheme(CustomThemeMode themeMode) {
  switch (themeMode) {
    case CustomThemeMode.light:
      return AppThemes.lightTheme;
    case CustomThemeMode.dark:
      return AppThemes.darkTheme;
    case CustomThemeMode.blue:
      return AppThemes.blueTheme;
    case CustomThemeMode.green:
      return AppThemes.greenTheme;
    case CustomThemeMode.orange:
      return AppThemes.orangeTheme;
    case CustomThemeMode.royalPurple:
      return AppThemes.royalPurpleTheme;
    case CustomThemeMode.amethystDark:
      return AppThemes.amethystDarkTheme;
    case CustomThemeMode.coffee:
      return AppThemes.coffeeTheme;
    default:
      return AppThemes.lightTheme;
  }
}
// Темы приложения
class AppThemes {
  static final lightTheme = ThemeData(
    primarySwatch: Colors.indigo,
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0, // Убрали тень для более плоского дизайна
      iconTheme: IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.black87), // Немного мягче черного
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.indigo).copyWith(secondary: Colors.amber), // Добавили акцентный цвет
  );
  static final darkTheme = ThemeData(
    primarySwatch: Colors.indigo,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF121212), // Стандартный Material Design темный фон
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF1F1F1F), // Чуть светлее фона для выделения
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.white),
      titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.white70), // Немного мягче белого
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.indigo, brightness: Brightness.dark).copyWith(secondary: Colors.tealAccent), // Акцентный цвет для темной темы
  );
  // Более глубокий синий с акцентами
  static final blueTheme = ThemeData(
    primaryColor: const Color(0xFF1E88E5), // Более насыщенный синий
    primarySwatch: Colors.blue, // Оставляем для совместимости
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF0F4F8), // Очень светло-серый фон
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E88E5),
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold), // Жирный шрифт для заголовка
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Color(0xFF263238)), // Темно-серый текст
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFFFFC107), // Янтарный FAB
      foregroundColor: Colors.black,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1E88E5),
          foregroundColor: Colors.white,
        )
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue).copyWith(secondary: const Color(0xFFFFC107)),
  );
  // Зеленая тема с природными оттенками
  static final greenTheme = ThemeData(
    primarySwatch: Colors.green,
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFE8F5E9), // Очень светло-зеленый фон
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF4CAF50), // Классический зеленый
      iconTheme: IconThemeData(color: Color(0xFF1B5E20)), // Темно-зеленые иконки
      titleTextStyle: TextStyle(color: Color(0xFF1B5E20), fontSize: 20, fontWeight: FontWeight.w600),
    ),
    textTheme: TextTheme(
      bodyMedium: TextStyle(color: Colors.green[900]), // Очень темный зеленый текст
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green).copyWith(secondary: Colors.orangeAccent),
  );
  // Теплая оранжевая тема
  static final orangeTheme = ThemeData(
    primarySwatch: Colors.deepOrange, // Более глубокий оранжевый
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFFFF3E0), // Светло-оранжевый/персиковый фон
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFFF7043), // Яркий оранжевый
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Color(0xFF4E342E)), // Коричневатый текст
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF4511E),
          foregroundColor: Colors.white,
        )
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepOrange).copyWith(secondary: Colors.cyan),
  );
  // Фиолетовая тема
  static final royalPurpleTheme = ThemeData(
    primarySwatch: Colors.purple,
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF3E5F5), // Светло-фиолетовый фон
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.purple[700],
      iconTheme: const IconThemeData(color: Colors.white),
      titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
    ),
    textTheme: TextTheme(
      bodyMedium: TextStyle(color: Colors.purple[900]),
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple).copyWith(secondary: Colors.lime),
  );
  // Темная аметистовая тема
  static final amethystDarkTheme = ThemeData(
    primarySwatch: Colors.deepPurple,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF211A37), // Глубокий фиолетово-синий фон
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF392B69), // Более светлый фиолетовый для аппбара
      elevation: 0,
      iconTheme: const IconThemeData(color: Color(0xFFD1C4E9)), // Светло-лавандовые иконки
      titleTextStyle: const TextStyle(color: Color(0xFFD1C4E9), fontSize: 20, fontWeight: FontWeight.w500),
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Color(0xFFD1C4E9)),
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple, brightness: Brightness.dark).copyWith(secondary: Colors.yellowAccent),
  );
  // Тема в стиле "кофе"
  static final coffeeTheme = ThemeData(
    primarySwatch: Colors.brown,
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFEFEBE9), // Бежевый фон
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.brown[600],
      iconTheme: const IconThemeData(color: Colors.white),
      titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
    ),
    textTheme: TextTheme(
      bodyMedium: TextStyle(color: Colors.brown[900]),
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.brown).copyWith(secondary: const Color(0xFF80CBC4)), // Мятный акцент
  );
}
// main.dart
//main.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'config/dependency_injection.dart';
import 'app.dart';
import 'core/logger/app_logger.dart';
import 'core/services/translation_service.dart';
import 'core/utils/translation_utils.dart';
import 'data/datasources/device/speech_datasource.dart';
import 'data/datasources/local/chat_local_datasource.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await TranslationServiceImpl.loadSupportedLanguages();
  // Инициализация логирования
  await AppLogger.init();
  try {
    // Инициализация зависимостей
    await initDependencies();
    // Создаем пустой чат, если его нет
    await getIt<ChatLocalDataSource>().ensureCurrentChatExists();
    // Загрузка переводов и других ресурсов
    await preloadResources();
    // Создаем и регистрируем обработчик жизненного цикла
    final lifecycleObserver = AppLifecycleObserver();
    WidgetsBinding.instance.addObserver(lifecycleObserver);
    // Сохраняем ссылку на обработчик в GetIt для возможного доступа из других частей приложения
    getIt.registerSingleton<AppLifecycleObserver>(lifecycleObserver);
    runApp(const ChatApp());
  } catch (e, stackTrace) {
    AppLogger.fatal('Ошибка при запуске приложения', e, stackTrace);
    runApp(const ErrorApp()); // Запасное приложение с информацией об ошибке
  }
}
// Класс для отслеживания жизненного цикла приложения
class AppLifecycleObserver extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      // Очистка ресурсов при завершении приложения
      _cleanupResources();
    }
  }
  Future<void> _cleanupResources() async {
    try {
      // Закрываем логгер
      await AppLogger.dispose();
      // Освобождаем другие ресурсы
      if (getIt.isRegistered<SpeechDataSource>()) {
        final speechDataSource = getIt<SpeechDataSource>();
        await speechDataSource.dispose();
      }
      // Закрываем другие ресурсы по необходимости
    } catch (e) {
      if (kDebugMode) {
        print('Ошибка при очистке ресурсов: $e');
      }
    }
  }
}
Future<void> preloadResources() async {
  // Загрузка переводов
  try {
    await getIt<TranslationService>().loadTranslations();
    AppLogger.debug('Переводы успешно загружены');
  } catch (e) {
    AppLogger.error('Ошибка при загрузке переводов', e);
  }
}
class ErrorApp extends StatelessWidget {
  const ErrorApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(child: Text(Tr.get(TranslationKeys.errorNum23))),
      ),
    );
  }
}
// config-app_config.dart
import 'package:flutter/material.dart';
class AppConfig {
  // Приватный статический экземпляр для паттерна Singleton
  static final AppConfig _instance = AppConfig._internal();
  // Фабричный конструктор, возвращающий экземпляр Singleton
  factory AppConfig() {
    return _instance;
  }
  // Приватный конструктор для Singleton
  AppConfig._internal();
  // Настройки по умолчанию
  String apiUrl = 'http://localhost:5000/';
  bool isDevelopment = true;
  int apiTimeout = 30;
  String appVersionName = '1.0.0';
  int appVersionCode = 1;
  bool isDebugLoggingEnabled = true;
  // Метод для инициализации конфигурации разработки
  void setupDevelopment() {
    apiUrl = 'http://localhost:5000/';
    isDevelopment = true;
    apiTimeout = 30;
    appVersionName = '1.0.0';
    appVersionCode = 1;
    isDebugLoggingEnabled = true;
  }
  // Метод для инициализации продакшн-конфигурации
  void setupProduction() {
    apiUrl = 'http://lobste.pythonanywhere.com';
    isDevelopment = false;
    apiTimeout = 60;
    appVersionName = '1.0.0';
    appVersionCode = 1;
    isDebugLoggingEnabled = false;
  }
  // Дополнительные настройки приложения
  String currentLanguage = 'en';
  ThemeMode themeMode = ThemeMode.system;
  // Метод для обновления языка
  void updateLanguage(String languageCode) {
    currentLanguage = languageCode;
  }
  // Метод для обновления темы
  void updateThemeMode(ThemeMode newThemeMode) {
    themeMode = newThemeMode;
  }
}
// config-dependency_injection.dart
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:translator/translator.dart';
import '../core/logger/app_logger.dart';
import '../data/datasources/device/speech_datasource.dart';
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
import '../domain/repositories/speech_repository.dart';
import '../domain/repositories/speech_repository_impl.dart';
import '../domain/repositories/translator_repository.dart';
import '../domain/repositories/translator_repository_impl.dart';
import '../domain/usecases/chat/export_chat.dart';
import '../domain/usecases/chat/send_message.dart';
import '../domain/usecases/chat/get_message_history.dart';
import '../domain/usecases/chat/save_chat.dart';
import '../domain/usecases/chat/delete_chat.dart';
import '../domain/usecases/settings/get_settings.dart';
import '../domain/usecases/settings/toggle_theme.dart';
import '../domain/usecases/settings/change_language.dart';
import '../domain/usecases/classification/classify_text.dart';
import '../domain/usecases/speech/listen_to_speech.dart';
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
  getIt.registerLazySingleton(() => ExportChat(getIt()));
  // Регистрируем SpeechDataSource, если он еще не зарегистрирован
  if (!getIt.isRegistered<SpeechDataSource>()) {
    getIt.registerLazySingleton<SpeechDataSource>(
            () => SpeechDataSourceImpl(speech: getIt<SpeechToText>())
    );
  }
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
  // Регистрируем SpeechRepository, если он еще не зарегистрирован
  if (!getIt.isRegistered<SpeechRepository>()) {
    getIt.registerLazySingleton<SpeechRepository>(
            () => SpeechRepositoryImpl(dataSource: getIt<SpeechDataSource>())
    );
  }
  // Сценарии использования
  getIt.registerLazySingleton(() => GetSettings(getIt()));
  getIt.registerLazySingleton(() => ToggleTheme(getIt()));
  getIt.registerLazySingleton(() => ChangeLanguage(getIt()));
  getIt.registerLazySingleton(() => GetMessageHistory(getIt()));
  getIt.registerLazySingleton(() => SendMessage(getIt(), getIt(), getIt()));
  getIt.registerLazySingleton(() => SaveChat(getIt()));
  getIt.registerLazySingleton(() => DeleteChat(getIt()));
  getIt.registerLazySingleton(() => ClassifyText(getIt()));
  // Регистрируем ListenToSpeech, если он еще не зарегистрирован
  if (!getIt.isRegistered<ListenToSpeech>()) {
    getIt.registerLazySingleton(() => ListenToSpeech(getIt<SpeechRepository>()));
  }
  // BLoCs
  getIt.registerFactory(() => ThemeBloc(toggleTheme: getIt(), getSettings: getIt()));
  getIt.registerFactory(() => LanguageBloc(changeLanguage: getIt(), getSettings: getIt()));
  getIt.registerFactory(() => ChatBloc(
      chatRepository: getIt<ChatRepository>(),
      sendMessage: getIt(),
      getMessageHistory: getIt(),
      saveChat: getIt(),
      deleteChat: getIt()
  ));
}
// config-routes.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/services/translation_service.dart';
import '../core/utils/translation_utils.dart';
import '../presentation/screens/chat_screen.dart';
import '../presentation/screens/settings_screen.dart';
import '../presentation/screens/chat_list_screen.dart';
import '../presentation/bloc/chat/chat_bloc.dart';
import 'dependency_injection.dart';
class AppRoutes {
  static const String chat = '/';
  static const String settings = '/settings';
  static const String chatList = '/chats';
}
class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.chat:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<ChatBloc>()..add(InitializeChatEvent()),
            child: const ChatScreen(),
          ),
        );
      case AppRoutes.settings:
        return MaterialPageRoute(
          builder: (_) => const SettingsScreen(),
        );
      case AppRoutes.chatList:
      // Используем BlocProvider.value, чтобы передать существующий экземпляр блока
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: BlocProvider.of<ChatBloc>(context)..add(GetSavedChatsEvent()),
            child: const ChatListScreen(),
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('${Tr.get(TranslationKeys.routeNotFound)}${settings.name}'),
            ),
          ),
        );
    }
  }
}
// core-constants-app_constants.dart
import 'package:flutter/material.dart';
class AppConstants {
  // Основные константы приложения
  static const String appName = 'TextSense AI';
  static const String appVersion = '1.0.0';
  // Иконки
  static const IconData botIcon = Icons.smart_toy;
  static const IconData userIcon = Icons.person;
  // Настройки анимаций
  static const Duration fadeAnimationDuration = Duration(milliseconds: 200);
  static const Duration slideAnimationDuration = Duration(milliseconds: 300);
  // Размеры и отступы
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double defaultBorderRadius = 12.0;
  static const double smallBorderRadius = 8.0;
  static const double largeBorderRadius = 16.0;
  // Лимиты
  static const int maxTextLength = 100000;
  static const int maxDisplayedChats = 100;
  // Форматы дат
  static const String dateFormat = 'dd.MM.yyyy';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'dd.MM.yyyy HH:mm';
  // Интервалы обновления
  static const Duration autosaveInterval = Duration(minutes: 5);
  // Пути к ресурсам
  static const String translationsPath = 'assets/localization/translations.json';
  // API endpoints
  static const String classifierEndpoint = 'http://lobste.pythonanywhere.com';
  // Эмодзи для реакций
  static const List<String> defaultReactions = [
    '😀', '😁', '😂', '🤣', '😃', '😄', '😅', '😆', '😉', '😊', '😋', '😎',
    '😍', '😘', '🥰', '😗', '😙', '😚', '🙂', '🤗', '🤩', '🤔', '🤨', '😐',
    '😑', '😶', '🙄', '😏', '😣', '😥', '😮', '🤐', '😯', '😪', '😫', '🥱',
    '😴', '😌', '😛', '😜', '😝', '😒', '😓', '😔', '😕', '🙃', '🤑', '😲',
    '☹️', '🙁', '😖', '😞', '😟', '😤', '😢', '😭', '😦', '😧', '😨', '😩',
    '🤯', '😬', '😰', '😱', '🥵', '🥶', '😳', '🤪', '😵', '😡', '😠', '🤬',
    '😷', '🤒', '🤕', '🤢', '🤮', '🤧', '😇', '🥳', '🥺', '🤠', '🤡', '🤥',
    '🤫', '🤭', '🧐', '🤓', '😈', '👿', '👹', '👺', '💀', '☠️', '👻', '👽',
    '👾', '🤖', '🎃', '😺', '😸', '😹', '😻', '😼', '😽', '🙀', '😿', '😾',
    '🙈', '🙉', '🙊', '💋', '💌', '💘', '💝', '💖', '💗', '💓', '💞', '💕',
    '💟', '❣️', '💔', '❤️', '🧡', '💛', '💚', '💙', '💜', '🤎', '🖤', '🤍',
    '💯', '💢', '💥', '💫', '💦', '💨', '🕳️', '💣', '💬', '👁️‍🗨️', '🗨️', '🗯️',
    '💭', '💤', '👍', '👎', '👌', '👏', '🙌', '👐', '🤝', '🤲', '🙏', '✊',
    '👊', '✋', '🤛', '🤜', '🤞', '🤟', '🖐️', '🖖', '💪', '🙏', '🤚', '🖖',
    '🙅', '🙅‍♂️', '🙅‍♀️', '🙆', '🙆‍♂️', '🙆‍♀️', '💁', '💁‍♂️', '💁‍♀️', '🙋', '🙋‍♂️', '🙋‍♀️',
    '🤴', '👸', '🤵', '🤵‍♂️', '🤵‍♀️', '🤶', '🤶‍♂️', '🤶‍♀️', '🚶‍♂️', '🚶‍♀️', '🏃‍♂️', '🏃‍♀️',
    '🏋️‍♂️', '🏋️‍♀️', '🤸‍♂️', '🤸‍♀️', '🤹‍♂️', '🤹‍♀️', '🎤', '🎸', '🕺', '💃', '🕴', '🚣',
    '🏊‍♂️', '🏊‍♀️', '🚫', '💔', '🚪', '🏠', '🏡', '🏢', '🏣', '🏥', '🏦', '🏧',
    '🏨', '🏩', '🏪', '🏫', '🏬', '🏭', '🏮', '🏯', '🏰', '🏱', '🏲', '🏳',
    '👨‍⚕️', '👩‍⚕️', '🧑‍⚕️', '👨‍🎓', '👩‍🎓', '🧑‍🎓', '👨‍🏫', '👩‍🏫', '🧑‍🏫', '👨‍⚖️', '👩‍⚖️', '🧑‍⚖️',
    '👨‍🌾', '👩‍🌾', '🧑‍🌾', '👨‍🍳', '👩‍🍳', '🧑‍🍳', '👨‍🔧', '👩‍🔧', '🧑‍🔧', '👨‍🏭', '👩‍🏭', '🧑‍🏭',
    '👨‍💼', '👩‍💼', '🧑‍💼', '👨‍🔬', '👩‍🔬', '🧑‍🔬', '👨‍💻', '👩‍💻', '🧑‍💻', '👨‍🎤', '👩‍🎤', '🧑‍🎤',
    '👨‍🎨', '👩‍🎨', '🧑‍🎨', '👨‍✈️', '👩‍✈️', '🧑‍✈️', '👨‍🚀', '👩‍🚀', '🧑‍🚀', '👨‍🚒', '👩‍🚒', '🧑‍🚒',
    '👮', '👮‍♂️', '👮‍♀️', '🕵️', '🕵️‍♂️', '🕵️‍♀️', '🦸‍♂️', '🦸‍♀️', '🦹', '🦹‍♂️', '🦹‍♀️', '🧙',
    '🧙‍♂️', '🧙‍♀️', '🧚', '🧚‍♂️', '🧚‍♀️', '🧛', '💂', '💂‍♂️', '💂‍♀️', '🥷', '🧝', '🧝‍♂️',
    '🧝‍♀️', '🧞', '🧞‍♂️', '🧞‍♀️', '🧟', '🧟‍♂️', '🧟‍♀️', '💆', '💆‍♂️', '💆‍♀️', '💇', '💇‍♂️',
    '💇‍♀️', '🚶', '🚶‍♂️', '🚶‍♀️', '🏃', '🏃‍♂️', '🏃‍♀️', '💃', '🕺', '🕴️', '👩', '👵',
    '👨‍🦱', '👩‍🦱', '🧑‍🦱', '👨‍🦰', '👩‍🦰', '🧑‍🦰', '👨‍🦳', '👩‍🦳', '🧑‍🦳', '👨‍👩‍👧‍👧', '👨‍👨‍👧‍👧', '👩‍👩‍👧‍👧',
    '🙌🏻', '🙌🏼', '🙌🏽', '🙌🏾', '🙌🏿', '👏🏻', '👏🏼', '👏🏽', '👏🏾', '👏🏿', '👍🏻', '👍🏼',
    '👍🏽', '👍🏾', '👍🏿', '👎🏻', '👎🏼', '👎🏽', '👎🏾', '👎🏿', '✊🏻', '✊🏼', '✊🏽', '✊🏾',
    '✊🏿', '🤛🏻', '🤛🏼', '🤛🏽', '🤛🏾', '🤛🏿', '🤜🏻', '🤜🏼', '🤜🏽', '🤜🏾', '🤜🏿', '🙏🏻',
    '🙏🏼', '🙏🏽', '🙏🏾', '🙏🏿', '🖖🏻', '🖖🏼', '🖖🏽', '🖖🏾', '🖖🏿', '💪🏻', '💪🏼', '💪🏽',
    '💪🏾', '💪🏿', '🫶🏻', '🫶🏼', '🫶🏽', '🫶🏾', '🫶🏿', '👈🏼', '👈🏽', '👈🏾', '👈🏿', '👉🏻',
    '👉🏼', '👉🏽', '👉🏾', '👉🏿', '👆🏻', '👆🏼', '👆🏽', '👆🏾', '👆🏿', '👇🏻', '👇🏼', '👇🏽',
    '👇🏾', '👇🏿',  '✋🏻', '✋🏼', '✋🏽', '✋🏾', '✋🏿', '💅🏻',
    '💅🏽', '💅🏾', '💅🏿', '🤳🏻', '🤳🏼', '🤳🏽', '🤳🏾', '🤳🏿', '🧠', '🫀', '🫁', '🦷',
    '🦴', '👀', '👁️', '👅', '👄',  '👶🏼', '👶🏽', '👶🏾', '👶🏿', '🧒🏻', '🧒🏼', '🧒🏽',
    '🧒🏾', '🧒🏿', '👦🏻', '👦🏼', '👦🏽', '👦🏾', '👦🏿', '👧🏻', '👧🏼', '👧🏽', '👧🏾', '👧🏿',
    '🧑🏻', '🧑🏼', '🧑🏽', '🧑🏾', '🧑🏿', '👨🏻', '👨🏼', '👨🏽', '👨🏾', '👨🏿', '👩🏻', '👩🏼',
    '👩🏽', '👩🏾', '👩🏿',
    '🏴', '🏵', '🏶', '🏷', '🏸', '🏹', '🏺', '🏻', '🏼', '🏽', '🏾', '🏿',
    '🐵', '🐶', '🐷', '🐸', '🐹', '🐺', '🐻', '🐼', '🐽', '🐾', '🐿', '🦀',
    '🦁', '🦂', '🦃', '🦄', '🦅', '🦆', '🦇', '🦈', '🦉', '🦊', '🦋', '🦌',
    '🦍', '🦎', '🦏', '🦐', '🦑', '🦒', '🦓', '🦔', '🦕', '🦖', '🦗', '🦘',
    '🦙', '🦚', '🦛', '🦜', '🦝', '🦞', '🦟', '🦠', '🦡', '🦢', '🦣', '🦤',
    '🦥', '🦦', '🦧', '🦨', '🦩', '🦪', '🦫', '🦬', '🦭', '🦮', '🦯', '🦰',
    '🦱', '🦲', '🦳', '🦴', '🦵', '🦶', '🦷', '🦸', '🦹', '🦺', '🦻', '🦼',
    '🦽', '🦾', '🦿', '🧀', '🧁', '🧂', '🧃', '🧄', '🧅', '🧆', '🧇', '🧈',
    '🧉', '🧊', '🧋', '🧌', '🧍', '🧎', '🧏', '🧐', '🧑', '🧒', '🧓', '🧔',
    '🧕', '🧖', '🧗', '🧘', '🧙', '🧚', '🧛', '🧜', '🧝', '🧞', '🧟', '🧠',
    '🧡', '🧢', '🧣', '🧤', '🧥', '🧦', '🧧', '🧨', '🧩', '🧪', '🧫', '🧬',
    '🧭', '🧮', '🧯', '🧰', '🧱', '🧲', '🧳', '🧴', '🧵', '🧶', '🧷', '🧸',
    '🧹', '🧺', '🧻', '🧼', '🧽', '🧾', '🧿', '🩰',
    '🩱', '🩲', '🩳', '🩴', '🩵', '🩶', '🩷', '🩸', '🩹', '🩺', '🩻', '🩼'
  ];
  // Приватный конструктор для предотвращения инстанцирования
  AppConstants._();
}
// core-constants-classification_constants.dart
class ClassificationConstants {
  static const List<String> labels = [
    'ARTS & CULTURE', 'BUSINESS & FINANCES', 'COMEDY', 'CRIME',
    'DIVORCE', 'EDUCATION', 'ENTERTAINMENT', 'ENVIRONMENT',
    'FOOD & DRINK', 'GROUPS VOICES', 'HOME & LIVING', 'IMPACT',
    'MEDIA', 'OTHER', 'PARENTING', 'POLITICS', 'RELIGION',
    'SCIENCE & TECH', 'SPORTS', 'STYLE & BEAUTY', 'TRAVEL',
    'U.S. NEWS', 'WEDDINGS', 'WEIRD NEWS', 'WELLNESS',
    'WOMEN', 'WORLD NEWS'
  ];
  static const double highConfidenceThreshold = 0.8;
  static const double mediumConfidenceThreshold = 0.5;
  // Приватный конструктор для предотвращения инстанцирования
  ClassificationConstants._();
}
// core-errors-app_exception.dart
/// Базовый класс для всех исключений приложения
abstract class AppException implements Exception {
  final String message;
  final dynamic originalError;
  AppException(this.message, [this.originalError]);
  @override
  String toString() {
    if (originalError != null) {
      return '$runtimeType: $message (Ошибка: $originalError)';
    }
    return '$runtimeType: $message';
  }
}
/// Ошибка сетевого взаимодействия
class NetworkException extends AppException {
  NetworkException(super.message, [super.originalError]);
}
/// Ошибка сервера
class ServerException extends AppException {
  final int? statusCode;
  ServerException(String message, {this.statusCode, dynamic originalError})
      : super(message, originalError);
  @override
  String toString() {
    if (statusCode != null) {
      return 'ServerException: $message (Статус кода: $statusCode)';
    }
    return super.toString();
  }
}
/// Ошибка кэша
class CacheException extends AppException {
  CacheException(String message, [dynamic originalError])
      : super(message, originalError);
}
/// Ошибка форматирования данных
class FormatException extends AppException {
  FormatException(String message, [dynamic originalError])
      : super(message, originalError);
}
/// Ошибка операций с файлами
class FileException extends AppException {
  FileException(String message, [dynamic originalError])
      : super(message, originalError);
}
/// Ошибка безопасности
class SecurityException extends AppException {
  SecurityException(String message, [dynamic originalError])
      : super(message, originalError);
}
/// Ошибка бизнес-логики
class BusinessException extends AppException {
  BusinessException(String message, [dynamic originalError])
      : super(message, originalError);
}
/// Ошибка доступа к функциональности
class PermissionException extends AppException {
  PermissionException(String message, [dynamic originalError])
      : super(message, originalError);
}
/// Необработанная ошибка
class UnknownException extends AppException {
  UnknownException(String message, [dynamic originalError])
      : super(message, originalError);
  factory UnknownException.fromError(dynamic error) {
    if (error is Exception || error is Error) {
      return UnknownException(
          'Произошла необработанная ошибка',
          error
      );
    }
    return UnknownException('Произошла необработанная ошибка: $error');
  }
}
// core-errors-error_handler.dart
import 'package:flutter/material.dart';
import '../logger/app_logger.dart';
import 'app_exception.dart';
import 'failure.dart';
class ErrorHandler {
  // Показывает SnackBar с сообщением об ошибке
  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message))
    );
  }
  // Обрабатывает исключение и возвращает соответствующий Failure
  static Failure handleException(dynamic exception) {
    AppLogger.error('Обработка исключения', exception);
    if (exception is NetworkException) {
      return NetworkFailure(message: exception.message);
    } else if (exception is ServerException) {
      return ServerFailure(
        message: exception.message,
        code: exception.statusCode,
      );
    } else if (exception is CacheException) {
      return CacheFailure(message: exception.message);
    } else if (exception is FileException) {
      return FileOperationFailure(message: exception.message);
    } else if (exception is SecurityException) {
      return ValidationFailure(message: exception.message);
    } else if (exception is FormatException) {
      return ValidationFailure(message: exception.message);
    } else if (exception is PermissionException) {
      return PermissionFailure(message: exception.message);
    } else {
      return UnknownFailure(
          message: 'Необработанная ошибка: ${exception.toString()}'
      );
    }
  }
  // Преобразует Failure в удобное для пользователя сообщение
  static String getErrorMessage(Failure failure) {
    switch (failure) {
      case NetworkFailure:
        return 'Ошибка сети. Проверьте подключение к интернету.';
      case ServerFailure:
        return 'Ошибка сервера. Попробуйте позже.';
      case CacheFailure:
        return 'Ошибка локального хранилища.';
      case FileOperationFailure:
        return 'Ошибка при работе с файлом: ${failure.message}';
      case ValidationFailure:
        return failure.message;
      case ClassificationFailure:
        return 'Не удалось классифицировать текст: ${failure.message}';
      case TranslationFailure:
        return 'Не удалось перевести текст: ${failure.message}';
      case PermissionFailure:
        return 'Отсутствуют необходимые разрешения: ${failure.message}';
      default:
        return 'Произошла ошибка: ${failure.message}';
    }
  }
}
// core-errors-failure.dart
import 'package:equatable/equatable.dart';
abstract class Failure extends Equatable {
  final String message;
  final int? code;
  const Failure({required this.message, this.code});
  @override
  List<Object?> get props => [message, code];
}
class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.code});
}
class NetworkFailure extends Failure {
  const NetworkFailure({required super.message});
}
class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}
class FileOperationFailure extends Failure {
  const FileOperationFailure({required super.message});
}
class ValidationFailure extends Failure {
  const ValidationFailure({required super.message});
}
class ClassificationFailure extends Failure {
  const ClassificationFailure({required super.message});
}
class TranslationFailure extends Failure {
  const TranslationFailure({required super.message});
}
class PermissionFailure extends Failure {
  const PermissionFailure({required super.message});
}
class UnknownFailure extends Failure {
  const UnknownFailure({required super.message});
}
// core-logger-app_logger.dart
import 'dart:io';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
abstract class AppLogger {
  static late AppLogger _instance;
  static Future<void> init() async {
    _instance = AppLoggerImpl();
    await _instance.initialize();
  }
  Future<void> initialize();
  static void debug(String message, [dynamic error, StackTrace? stackTrace]) =>
      _instance.logDebug(message, error, stackTrace);
  static void info(String message, [dynamic error, StackTrace? stackTrace]) =>
      _instance.logInfo(message, error, stackTrace);
  static void warning(String message, [dynamic error, StackTrace? stackTrace]) =>
      _instance.logWarning(message, error, stackTrace);
  static void error(String message, [dynamic error, StackTrace? stackTrace]) =>
      _instance.logError(message, error, stackTrace);
  static void fatal(String message, [dynamic error, StackTrace? stackTrace]) =>
      _instance.logFatal(message, error, stackTrace);
  // Добавляем статический метод для вызова dispose
  static Future<void> dispose() async {
    await _instance.disposeLogger();
  }
  // Добавляем метод в интерфейс
  Future<void> disposeLogger();
  void logDebug(String message, [dynamic error, StackTrace? stackTrace]);
  void logInfo(String message, [dynamic error, StackTrace? stackTrace]);
  void logWarning(String message, [dynamic error, StackTrace? stackTrace]);
  void logError(String message, [dynamic error, StackTrace? stackTrace]);
  void logFatal(String message, [dynamic error, StackTrace? stackTrace]);
}
class AppLoggerImpl implements AppLogger {
  Logger _logger = Logger();
  File? _logFile;
  @override
  Future<void> initialize() async {
    final logsDirectory = await _getLogsDirectory();
    _logFile = File('$logsDirectory/app.log');
    _logger = Logger(
      filter: ProductionFilter(),
      printer: PrettyPrinter(
          methodCount: 2,
          errorMethodCount: 8,
          lineLength: 120,
          colors: true,
          printEmojis: true,
          dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart
      ),
      output: MultiOutput([
        ConsoleOutput(),
        FileOutput(file: _logFile!)
      ]),
    );
    logInfo('Система логирования инициализирована');
  }
  Future<void> dispose() async {
    // Закрываем логгер и освобождаем ресурсы
    _logger.close();
  }
  Future<String> _getLogsDirectory() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final logsDir = Directory('${appDocDir.path}/logs');
    if (!await logsDir.exists()) {
      await logsDir.create(recursive: true);
    }
    return logsDir.path;
  }
  @override
  void logDebug(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }
  @override
  void logInfo(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }
  @override
  void logWarning(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }
  @override
  void logError(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }
  @override
  void logFatal(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.f(message, error: error, stackTrace: stackTrace);
  }
  @override
  Future<void> disposeLogger() async {
    try {
      // Закрываем логгер и освобождаем ресурсы
      // В библиотеке logger может не быть метода close,
      // в этом случае просто логируем завершение работы
      logInfo('Система логирования завершает работу');
    } catch (e) {
      print('Ошибка при закрытии логгера: $e');
    }
  }
}
// core-logger-log_level.dart
enum LogLevel {
  debug,
  info,
  warning,
  error,
  fatal
}
extension LogLevelExtension on LogLevel {
  String get name {
    switch (this) {
      case LogLevel.debug:
        return 'DEBUG';
      case LogLevel.info:
        return 'INFO';
      case LogLevel.warning:
        return 'WARNING';
      case LogLevel.error:
        return 'ERROR';
      case LogLevel.fatal:
        return 'FATAL';
    }
  }
  int get value {
    switch (this) {
      case LogLevel.debug:
        return 0;
      case LogLevel.info:
        return 1;
      case LogLevel.warning:
        return 2;
      case LogLevel.error:
        return 3;
      case LogLevel.fatal:
        return 4;
    }
  }
  bool shouldLog(LogLevel minimumLevel) {
    return value >= minimumLevel.value;
  }
}
// core-services-translation_service.dart
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import '../logger/app_logger.dart';
import '../errors/app_exception.dart';
class TranslationKeys {
  static const String couldNotClassifyText = "couldNotClassifyText";
  static const String back = "back";
  static const String day1 = "day1";
  static const String day2 = "day2";
  static const String day3 = "day3";
  static const String hour1 = "hour1";
  static const String hour2 = "hour2";
  static const String hour3 = "hour3";
  static const String minute1 = "minute1";
  static const String minute2 = "minute2";
  static const String minute3 = "minute3";
  static const String routeNotFound = "routeNotFound";
  static const String errorNum1 = "errorNum1";
  static const String errorNum2 = "errorNum2";
  static const String errorNum3 = "errorNum3";
  static const String errorNum4 = "errorNum4";
  static const String errorNum5 = "errorNum5";
  static const String errorNum6 = "errorNum6";
  static const String errorNum7 = "errorNum7";
  static const String errorNum8 = "errorNum8";
  static const String errorNum9 = "errorNum9";
  static const String errorNum10 = "errorNum10";
  static const String errorNum11 = "errorNum11";
  static const String errorNum12 = "errorNum12";
  static const String errorNum13 = "errorNum13";
  static const String errorNum14 = "errorNum14";
  static const String errorNum15 = "errorNum15";
  static const String errorNum16 = "errorNum16";
  static const String errorNum17 = "errorNum17";
  static const String errorNum18 = "errorNum18";
  static const String errorNum19 = "errorNum19";
  static const String errorNum20 = "errorNum20";
  static const String errorNum21 = "errorNum21";
  static const String errorNum22 = "errorNum22";
  static const String errorNum23 = "errorNum23";
  static const String applicationDescription = "applicationDescription";
  static const String rightsReserved = "rightsReserved";
  static const String settings = 'settings';
  static const String appearance = 'appearance';
  static const String theme = 'theme';
  static const String systemTheme = 'systemTheme';
  static const String lightTheme = 'lightTheme';
  static const String darkTheme = 'darkTheme';
  static const String blueTheme = 'blueTheme';
  static const String greenTheme = 'greenTheme';
  static const String orangeTheme = 'orangeTheme';
  static const String royalPurpleTheme = "royalPurpleTheme";
  static const String amethystDarkTheme = "amethystDarkTheme";
  static const String coffeeTheme = "coffeeTheme";
  static const String language = 'language';
  static const String about = 'about';
  static const String version = 'version';
  static const String noMessages = 'noMessages';
  static const String startChat = 'startChat';
  static const String processingError = 'processingError';
  static const String recordVoice = 'recordVoice';
  static const String stopRecording = 'stopRecording';
  static const String classificationFailed = 'classificationFailed';
  static const String category = 'category';
  static const String confidence = 'confidence';
  static const String emotionalTone = 'emotionalTone';
  static const String switchToDarkTheme = 'switchToDarkTheme';
  static const String switchToLightTheme = 'switchToLightTheme';
  static const String savedChats = 'savedChats';
  static const String errorLoadingChats = 'errorLoadingChats';
  static const String appTitle = 'appTitle';
  static const String enterText = 'enterText';
  static const String emotionalColoring = 'emotionalColoring';
  static const String exportChat = 'exportChat';
  static const String chatHistory = 'chatHistory';
  static const String date = 'date';
  static const String user = 'user';
  static const String bot = 'bot';
  static const String errorProcessing = 'errorProcessing';
  static const String changeLanguage = 'changeLanguage';
  static const String newChat = 'newChat';
  static const String saveChat = 'saveChat';
  static const String renameChat = 'renameChat';
  static const String uploadChat = 'uploadChat';
  static const String exit = 'exit';
  static const String reaction = 'reaction';
  static const String translate = 'translate';
  static const String copy = 'copy';
  static const String delete = 'delete';
  static const String copied = 'copied';
  static const String deleteChatConfirmationTitle = 'deleteChatConfirmationTitle';
  static const String deleteChatConfirmationMessage = 'deleteChatConfirmationMessage';
  static const String cancel = 'cancel';
  static const String save = 'save';
  static const String rename = 'rename';
  static const String overwrite = 'overwrite';
  static const String chatNameLabel = 'chatNameLabel';
  static const String chatNameHint = 'chatNameHint';
  static const String chatNameEmptyError = 'chatNameEmptyError';
  static const String invalidFileName = 'invalidFileName';
  static const String chatExistsConfirmation = 'chatExistsConfirmation';
  static const String renameChatInfo = 'renameChatInfo';
  static const String chatSaved = 'chatSaved';
  static const String chatRenamed = 'chatRenamed';
  static const String overwriteChat = 'overwriteChat';
  static const String errorDeletingFile = 'errorDeletingFile';
  static const String noSavedChats = 'noSavedChats';
  static const String lastModified = 'lastModified';
  static const String newChatConfirmation = 'newChatConfirmation';
  static const String saveCurrentChatQuestion = 'saveCurrentChatQuestion';
  static const String dontSave = 'dontSave';
  static const String saveAndCreate = 'saveAndCreate';
  static const String defaultChatNameError = 'defaultChatNameError';
}
abstract class TranslationService {
  Future<void> loadTranslations();
  Map<String, dynamic> getTranslations(String languageCode);
  String translate(String key, String languageCode);
  List<String> get supportedLanguageCodes;
  String getLanguageName(String code);
}
class TranslationServiceImpl implements TranslationService {
  Map<String, Map<String, dynamic>> _translations = {};
  static late List<Map<String, dynamic>> _supportedLanguages;
  static const String _defaultLanguage = 'en';
  static const String _translationsPath = 'assets/localization/translations.json';
  final Map<String, String> _translationCache = {};  // Кэш для переводов
  static Future<void> loadSupportedLanguages() async {
    try {
      String jsonString = await rootBundle.loadString('assets/localization/supported_languages.json');
      Map<String, dynamic> jsonData = json.decode(jsonString);
      _supportedLanguages = (jsonData['supportedLanguages'] as List)
          .map((lang) => {"code": lang['code'], "name": lang['name']})
          .toList();
    } catch (e) {
      throw Exception("Ошибка загрузки списка языков: $e");
    }
  }
  @override
  List<String> get supportedLanguageCodes => _supportedLanguages.map((lang) => lang['code'] as String).toList();
  @override
  String getLanguageName(String code) => _supportedLanguages.firstWhere((lang) => lang['code'] == code, orElse: () => {"name": "Unknown"})["name"] as String;
  @override
  String translate(String key, String languageCode) {
  // Создаем составной ключ для кэша
  final cacheKey = '$languageCode:$key';
  // Проверяем кэш
  if (_translationCache.containsKey(cacheKey)) {
  return _translationCache[cacheKey]!;
  }
  // Получаем перевод
  final translations = getTranslations(languageCode);
  final translation = translations[key] ?? key;
  // Кэшируем результат
  _translationCache[cacheKey] = translation;
  return translation;
  }
  // Метод для очистки кэша при смене языка
  void clearCache() {
  _translationCache.clear();
  }
  @override
  Future<void> loadTranslations() async {
    try {
      AppLogger.debug('Загрузка переводов');
      final jsonString = await rootBundle.loadString(_translationsPath);
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      _translations = {};
      for (final language in _supportedLanguages) {
        final langCode = language['code'] as String; // Извлекаем код языка
        if (jsonMap.containsKey(langCode)) {
          _translations[langCode] = Map<String, dynamic>.from(jsonMap[langCode]);
        }
      }
      AppLogger.debug('Переводы успешно загружены для языков: ${_translations.keys.join(", ")}');
    } catch (e) {
      AppLogger.error('Ошибка при загрузке переводов', e);
      throw FormatException('Не удалось загрузить переводы: $e');
    }
  }
  @override
  Map<String, dynamic> getTranslations(String languageCode) {
    if (_translations.isEmpty) {
      AppLogger.warning('Переводы не были загружены. Возвращаем пустой словарь.');
      return {};
    }
    if (_translations.containsKey(languageCode)) {
      return _translations[languageCode]!;
    }
    AppLogger.warning('Перевод для языка $languageCode не найден. Используем язык по умолчанию: $_defaultLanguage');
    return _translations[_defaultLanguage] ?? {};
  }
}
TranslationService getTranslationService() {
  return GetIt.instance<TranslationService>();
}
// core-utils-datetime_utils.dart
import 'package:coursework/core/utils/translation_utils.dart';
import 'package:intl/intl.dart';
import '../constants/app_constants.dart';
import '../services/translation_service.dart';
class DateTimeUtils {
  /// Форматирует дату и время по указанному формату
  static String formatDateTime(DateTime dateTime, [String? format]) {
    final formatter = DateFormat(format ?? AppConstants.dateTimeFormat);
    return formatter.format(dateTime);
  }
  /// Форматирует только дату
  static String formatDate(DateTime dateTime, [String? format]) {
    final formatter = DateFormat(format ?? AppConstants.dateFormat);
    return formatter.format(dateTime);
  }
  /// Форматирует только время
  static String formatTime(DateTime dateTime, [String? format]) {
    final formatter = DateFormat(format ?? AppConstants.timeFormat);
    return formatter.format(dateTime);
  }
  /// Форматирует время для отображения в сообщениях чата
  static String formatMessageTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    // Определяем, отображать ли "Сегодня", "Вчера" или полную дату
    if (messageDate == today) {
      return 'Сегодня, ${DateFormat(AppConstants.timeFormat).format(dateTime)}';
    } else if (messageDate == yesterday) {
      return 'Вчера, ${DateFormat(AppConstants.timeFormat).format(dateTime)}';
    } else {
      return formatDateTime(dateTime);
    }
  }
  /// Возвращает относительное время (например, "5 минут назад")
  static String getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    if (difference.inSeconds < 60) {
      return 'только что';
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return '$minutes ${_getPluralForm(minutes, Tr.get(TranslationKeys.minute1), Tr.get(TranslationKeys.minute2), Tr.get(TranslationKeys.minute3))} ${Tr.get(TranslationKeys.back)}';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return '$hours ${_getPluralForm(hours, Tr.get(TranslationKeys.hour1), Tr.get(TranslationKeys.hour2), Tr.get(TranslationKeys.hour3))} ${Tr.get(TranslationKeys.back)}';
    } else if (difference.inDays < 7) {
      final days = difference.inDays;
      return '$days ${_getPluralForm(days, Tr.get(TranslationKeys.day1), Tr.get(TranslationKeys.day2), Tr.get(TranslationKeys.day3))} ${Tr.get(TranslationKeys.back)}';
    } else {
      return formatDateTime(dateTime);
    }
  }
  /// Вспомогательный метод для выбора правильной формы слова в зависимости от числа
  static String _getPluralForm(int number, String form1, String form2, String form5) {
    final mod10 = number % 10;
    final mod100 = number % 100;
    if (mod100 >= 11 && mod100 <= 20) {
      return form5;
    }
    if (mod10 == 1) {
      return form1;
    }
    if (mod10 >= 2 && mod10 <= 4) {
      return form2;
    }
    return form5;
  }
  // Приватный конструктор для предотвращения инстанцирования
  DateTimeUtils._();
}
// core-utils-file_utils.dart
// core/utils/file_utils.dart
import 'dart:io';
import 'package:flutter_launcher_icons/custom_exceptions.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import '../errors/app_exception.dart';
import '../logger/app_logger.dart';
class FileUtils {
  /// Проверяет, является ли имя файла безопасным
  static bool isValidFileName(String fileName) {
    // Усиленная проверка имени файла
    final RegExp validChars = RegExp(r'^[a-zA-Zа-яА-Я0-9 _\-]+$');
    return validChars.hasMatch(fileName) &&
        !fileName.contains('..') &&
        fileName.length <= 255 &&
        fileName.trim().isNotEmpty;
  }
  /// Возвращает безопасный путь к файлу
  static Future<String> getSafePath(String fileName, {String? extension}) async {
    if (!isValidFileName(fileName)) {
      throw SecurityException('Недопустимое имя файла: $fileName');
    }
    final ext = extension ?? 'json';
    final basePath = await getApplicationDocumentsDirectory();
    // Нормализация пути для предотвращения path traversal атак
    final normalizedPath = path.normalize(
        path.join(basePath.path, '$fileName.$ext')
    );
    // Проверка, что путь находится внутри basePath
    if (!normalizedPath.startsWith(basePath.path)) {
      throw SecurityException('Недопустимый путь к файлу');
    }
    return normalizedPath;
  }
  /// Проверяет наличие доступа к файлу
  static Future<bool> hasFileAccess(String filePath) async {
    try {
      final file = File(filePath);
      // Проверка доступа к файлу
      final dirExists = await Directory(path.dirname(filePath)).exists();
      if (!dirExists) {
        return false;
      }
      if (await file.exists()) {
        // Проверяем права на чтение/запись существующего файла
        try {
          await file.readAsString();
          return true;
        } catch (e) {
          AppLogger.error('Нет доступа к файлу $filePath', e);
          return false;
        }
      }
      // Если файл не существует, проверяем, можем ли мы создать его
      try {
        await file.create();
        await file.delete();
        return true;
      } catch (e) {
        AppLogger.error('Не удалось создать тестовый файл в $filePath', e);
        return false;
      }
    } catch (e) {
      AppLogger.error('Ошибка при проверке доступа к файлу', e);
      return false;
    }
  }
  /// Создает уникальное имя файла
  static Future<String> getUniqueFileName(String baseName, {String? extension}) async {
    final ext = extension ?? 'json';
    final directory = await getApplicationDocumentsDirectory();
    int counter = 1;
    String fileName = baseName;
    while (true) {
      final filePath = path.join(directory.path, '$fileName.$ext');
      final exists = await File(filePath).exists();
      if (!exists) {
        return fileName;
      }
      fileName = '$baseName $counter';
      counter++;
      // Защита от бесконечного цикла
      if (counter > 10000) {
        throw Exception('Не удалось создать уникальное имя файла');
      }
    }
  }
  /// Безопасно сохраняет данные в файл
  static Future<void> saveDataToFile(String fileName, String data) async {
    try {
      final filePath = await getSafePath(fileName);
      final file = File(filePath);
      // Сначала записываем во временный файл
      final tempFile = File('$filePath.tmp');
      await tempFile.writeAsString(data);
      // Если временный файл успешно создан, заменяем оригинальный
      if (await file.exists()) {
        await file.delete();
      }
      await tempFile.rename(filePath);
      AppLogger.debug('Файл успешно сохранен: $filePath');
    } catch (e, stackTrace) {
      AppLogger.error('Ошибка при сохранении файла', e, stackTrace);
      rethrow;
    }
  }
  /// Безопасно загружает данные из файла
  static Future<String> loadDataFromFile(String fileName) async {
    try {
      final filePath = await getSafePath(fileName);
      final file = File(filePath);
      if (!await file.exists()) {
        throw FileNotFoundException('Файл не найден: $fileName');
      }
      final data = await file.readAsString();
      return data;
    } catch (e, stackTrace) {
      AppLogger.error('Ошибка при загрузке файла', e, stackTrace);
      rethrow;
    }
  }
  /// Безопасно удаляет файл
  static Future<bool> deleteFile(String fileName) async {
    try {
      final filePath = await getSafePath(fileName);
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        AppLogger.debug('Файл успешно удален: $filePath');
        return true;
      }
      return false;
    } catch (e, stackTrace) {
      AppLogger.error('Ошибка при удалении файла', e, stackTrace);
      rethrow;
    }
  }
}

// core-utils-math_utils.dart
import 'dart:math' as math;
class MathUtils {
  /// Применяет функцию softmax к массиву чисел
  static List<double> softmax(List<double> scores) {
    final maxScore = scores.reduce(math.max);
    // Создаем список один раз и модифицируем его
    final result = List<double>.filled(scores.length, 0.0);
    double sumExp = 0.0;
    // Первый проход: вычисляем exp(score - maxScore)
    for (int i = 0; i < scores.length; i++) {
      result[i] = math.exp(scores[i] - maxScore);
      sumExp += result[i];
    }
    // Второй проход: нормализуем
    for (int i = 0; i < scores.length; i++) {
      result[i] /= sumExp;
    }
    return result;
  }
  /// Вычисляет уровень уверенности (максимальное значение после softmax)
  static double getConfidence(List<double> scores) {
    final normalizedScores = softmax(scores);
    return normalizedScores.reduce(math.max);
  }
  /// Находит индекс максимального элемента в массиве
  static int argmax(List<double> scores) {
    int maxIndex = 0;
    double maxValue = scores[0];
    for (int i = 1; i < scores.length; i++) {
      if (scores[i] > maxValue) {
        maxValue = scores[i];
        maxIndex = i;
      }
    }
    return maxIndex;
  }
  /// Линейно нормализует значение из одного диапазона в другой
  static double normalize(
      double value,
      double fromMin,
      double fromMax,
      double toMin,
      double toMax
      ) {
    if (fromMax - fromMin == 0) return toMin;
    final scaled = (value - fromMin) / (fromMax - fromMin);
    return toMin + scaled * (toMax - toMin);
  }
  /// Сигмоидальная функция
  static double sigmoid(double x) {
    return 1.0 / (1.0 + math.exp(-x));
  }
  // Приватный конструктор для предотвращения инстанцирования
  MathUtils._();
}
// core-utils-string_utils.dart
class StringUtils {
  // Проверяет, пустая ли строка, учитывая пробелы
  static bool isEmpty(String? str) {
    return str == null || str.trim().isEmpty;
  }
  // Приватный конструктор для предотвращения инстанцирования
  StringUtils._();
}
// core-utils-translation_utils.dart
import 'package:get_it/get_it.dart';
import '../services/translation_service.dart';
import '../../config/app_config.dart';
class Tr {
  static String get(String key, [String? languageCode]) {
    final service = GetIt.instance<TranslationService>();
    final code = languageCode ?? _getCurrentLanguage();
    return service.translate(key, code);
  }
  static String _getCurrentLanguage() {
    // Используем AppConfig для получения текущего языка
    return AppConfig().currentLanguage;
  }
}
// data-datasources-device-speech_datasource.dart
import 'dart:async';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/logger/app_logger.dart';
abstract class SpeechDataSource {
  Future<bool> initialize();
  Future<Stream<String>> startListening();
  Future<bool> stopListening();
  Future<bool> isAvailable();
  Future<bool> isListening();
  Future<void> dispose();
}
class SpeechDataSourceImpl implements SpeechDataSource {
  final stt.SpeechToText _speech;
  late var _textController = StreamController<String>.broadcast();
  SpeechDataSourceImpl({stt.SpeechToText? speech})
      : _speech = speech ?? stt.SpeechToText();
  @override
  Future<bool> initialize() async {
    try {
      // Проверяем разрешение на доступ к микрофону
      final status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw PermissionException('Доступ к микрофону не предоставлен');
      }
      // Инициализируем распознавание речи
      final available = await _speech.initialize(
        onStatus: _onStatusChange,
        onError: _onError,
      );
      AppLogger.debug('Инициализация речи: $available');
      return available;
    } catch (e) {
      if (e is PermissionException) rethrow;
      AppLogger.error('Ошибка при инициализации речи', e);
      throw Exception('Не удалось инициализировать распознавание речи: $e');
    }
  }
  void _onStatusChange(String status) {
    AppLogger.debug('Статус распознавания речи: $status');
  }
  void _onError(dynamic error) {
    AppLogger.error('Ошибка распознавания речи', error);
    _textController.addError(error);
  }
  @override
  Future<Stream<String>> startListening() async {
    try {
      // Проверяем, инициализирован ли движок распознавания
      if (!await isAvailable()) {
        await initialize();
      }
      // Проверяем, не слушаем ли уже
      if (await isListening()) {
        await stopListening();
      }
      // Переиспользуем существующий контроллер или создаем новый
      if (_textController.isClosed) {
        _textController = StreamController<String>.broadcast();
      }
      // Запускаем распознавание
      await _speech.listen(
        onResult: (result) {
          AppLogger.debug('Получен результат распознавания: ${result.recognizedWords} (финальный: ${result.finalResult})');
          // Добавляем результат в поток, даже если он не финальный
          if (result.recognizedWords.isNotEmpty) {
            _textController.add(result.recognizedWords);
          }
          // Если результат финальный, останавливаем распознавание
          if (result.finalResult) {
            AppLogger.debug('Получен финальный результат: ${result.recognizedWords}');
            // НЕ закрываем поток здесь, только добавляем результат
          }
        },
        listenFor: const Duration(seconds: 30), // Максимальное время слушания
        pauseFor: const Duration(seconds: 3), // Время паузы перед остановкой
        listenOptions: stt.SpeechListenOptions(
          partialResults: true,
        ), // Для получения промежуточных результатов
        localeId: 'ru_RU', // Можно сделать параметром
      );
      // Добавляем обработчик статуса
      _speech.statusListener = (status) {
        AppLogger.debug('Статус распознавания речи: $status');
        // Если статус "done" или "notListening", закрываем поток
        if (status == 'done' || status == 'notListening') {
          // Важно! НЕ закрываем поток сразу, даем время на обработку результатов
          Future.delayed(const Duration(milliseconds: 500), () {
            if (!_textController.isClosed) {
              _textController.close();
            }
          });
        }
      };
      AppLogger.debug('Распознавание речи запущено');
      return _textController.stream;
    } catch (e) {
      AppLogger.error('Ошибка при запуске распознавания речи', e);
      throw Exception('Не удалось запустить распознавание речи: $e');
    }
  }
  @override
  Future<bool> isAvailable() async {
    return _speech.isAvailable;
  }
  @override
  Future<bool> isListening() async {
    return _speech.isListening;
  }
  // Добавить метод
  Future<void> dispose() async {
    await stopListening();
    if (!_textController.isClosed) {
      _textController.close();
    }
  }
  @override
  Future<bool> stopListening() async {
    try {
      if (_speech.isListening) {
        _speech.stop();
        AppLogger.debug('Распознавание речи остановлено');
      }
      // Не закрываем контроллер здесь, чтобы можно было получить последние результаты
      // Это будет делаться в dispose или при необходимости
      return true;
    } catch (e) {
      AppLogger.error('Ошибка при остановке распознавания речи', e);
      throw Exception('Не удалось остановить распознавание речи: $e');
    }
  }
}
// data-datasources-local-chat_local_datasource.dart
import 'dart:io';
import 'dart:convert';
import 'package:flutter_launcher_icons/custom_exceptions.dart';
import 'package:path_provider/path_provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/logger/app_logger.dart';
import '../../../core/utils/file_utils.dart';
import '../../models/message_model.dart';
abstract class ChatLocalDataSource {
  Future<Map<String, DateTime>> getSavedChats();
  Future<List<MessageModel>> loadChat(String chatName);
  Future<bool> saveChat(String chatName, List<MessageModel> messages);
  Future<bool> deleteChat(String chatName);
  Future<bool> chatExists(String chatName);
  Future<String> getUniqueDefaultChatName();
  Future<bool> renameChat(String oldName, String newName);
  ensureCurrentChatExists() {}
}
class ChatLocalDataSourceImpl implements ChatLocalDataSource {
  final AppLogger logger;
  final String fileExtension = 'json';
  ChatLocalDataSourceImpl({required this.logger});
  @override
  Future<void> ensureCurrentChatExists() async {
    try {
      final exists = await chatExists('current');
      if (!exists) {
        await saveChat('current', []);
      }
    } catch (e) {
      logger.logWarning('Не удалось создать пустой чат', e);
    }
  }
  @override
  Future<Map<String, DateTime>> getSavedChats() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final files = await directory.list().toList();
      Map<String, DateTime> savedChats = {};
      for (var file in files) {
        if (file is File && file.path.endsWith('.$fileExtension')) {
          try {
            // Извлекаем имя файла без пути и расширения
            final fileName = file.uri.pathSegments.last
                .replaceAll('.$fileExtension', '');
            // Проверяем, что это действительно файл чата
            if (await _isValidChatFile(file)) {
              final lastModified = await file.lastModified();
              savedChats[fileName] = lastModified;
            }
          } catch (e) {
            logger.logWarning('Пропускаем некорректный файл: ${file.path}', e);
          }
        }
      }
      logger.logDebug('Найдено ${savedChats.length} сохраненных чатов');
      return savedChats;
    } catch (e) {
      logger.logError('Ошибка при получении списка сохраненных чатов', e);
      throw FileException('Не удалось загрузить список чатов: $e');
    }
  }
  Future<bool> _isValidChatFile(File file) async {
    try {
      if (await file.exists()) {
        final fileContent = await file.readAsString();
        final jsonData = jsonDecode(fileContent);
        // Проверяем, что это массив сообщений
        return jsonData is List;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
  @override
  Future<List<MessageModel>> loadChat(String chatName) async {
    try {
      if (!await chatExists(chatName)) {
        throw FileNotFoundException('Чат не найден: $chatName');
      }
      final filePath = await FileUtils.getSafePath(chatName, extension: fileExtension);
      final file = File(filePath);
      final jsonData = await file.readAsString();
      logger.logDebug('Загружен чат: $chatName (${jsonData.length} байт)');
      return MessageModel.fromJsonList(jsonData);
    } catch (e) {
      if (e is FileNotFoundException) rethrow;
      logger.logError('Ошибка при загрузке чата: $chatName', e);
      throw FileException('Не удалось загрузить чат: $e');
    }
  }
  @override
  Future<bool> saveChat(String chatName, List<MessageModel> messages) async {
    try {
      // Проверяем безопасность имени файла
      if (!FileUtils.isValidFileName(chatName)) {
        throw SecurityException('Недопустимое имя чата: $chatName');
      }
      final filePath = await FileUtils.getSafePath(chatName, extension: fileExtension);
      // Проверка длины имени
      if (chatName.length > 100) {
        throw SecurityException('Имя чата слишком длинное');
      }
      // Проверяем безопасность имени файла
      if (!FileUtils.isValidFileName(chatName)) {
        throw SecurityException('Недопустимое имя чата: $chatName');
      }
      // Проверяем сообщения
      if (messages.any((msg) => msg.text.length > AppConstants.maxTextLength)) {
        throw SecurityException('Одно или несколько сообщений превышают максимальную длину');
      }
      // Конвертируем сообщения в JSON
      final jsonString = MessageModel.toJsonList(messages);
      // Используем безопасное сохранение
      await FileUtils.saveDataToFile(chatName, jsonString);
      logger.logDebug('Чат успешно сохранен: $chatName (${messages.length} сообщений)');
      return true;
    } catch (e) {
      if (e is SecurityException) rethrow;
      logger.logError('Ошибка сохранения чата: $chatName', e);
      throw FileException('Не удалось сохранить чат: $e');
    }
  }
  @override
  Future<bool> deleteChat(String chatName) async {
    try {
      // Проверяем существование чата
      if (!await chatExists(chatName)) {
        logger.logWarning('Попытка удалить несуществующий чат: $chatName');
        return false;
      }
      final success = await FileUtils.deleteFile(chatName);
      if (success) {
        logger.logDebug('Чат успешно удален: $chatName');
      }
      return success;
    } catch (e) {
      logger.logError('Ошибка при удалении чата: $chatName', e);
      throw FileException('Не удалось удалить чат: $e');
    }
  }
  @override
  Future<bool> chatExists(String chatName) async {
    try {
      if (!FileUtils.isValidFileName(chatName)) {
        throw SecurityException('Недопустимое имя чата при проверке: $chatName');
      }
      final filePath = await FileUtils.getSafePath(chatName, extension: fileExtension);
      final exists = await File(filePath).exists();
      return exists;
    } catch (e) {
      if (e is SecurityException) {
        logger.logWarning('Небезопасное имя чата при проверке: $chatName', e);
        return false;
      }
      logger.logError('Ошибка при проверке существования чата', e);
      return false;
    }
  }
  @override
  Future<String> getUniqueDefaultChatName() async {
    try {
      String baseName = "New chat";
      // Получаем список существующих чатов
      final savedChats = await getSavedChats();
      // Начинаем с "New Chat"
      if (!savedChats.containsKey(baseName)) {
        return baseName;
      }
      // Если "New Chat" уже существует, ищем "New Chat 1", "New Chat 2", и т.д.
      int counter = 1;
      while (true) {
        String candidateName = "$baseName $counter";
        if (!savedChats.containsKey(candidateName)) {
          return candidateName;
        }
        counter++;
        // Защита от бесконечного цикла
        if (counter > 10000) {
          throw Exception('Не удалось создать уникальное имя чата');
        }
      }
    } catch (e) {
      logger.logError('Ошибка при генерации имени чата', e);
      throw FileException('Не удалось создать имя для нового чата: $e');
    }
  }
  @override
  Future<bool> renameChat(String oldName, String newName) async {
    try {
      // Проверяем существование исходного чата
      if (!await chatExists(oldName)) {
        throw FileNotFoundException('Исходный чат не найден: $oldName');
      }
      // Проверяем, не существует ли уже новое имя
      if (await chatExists(newName)) {
        throw FileException('Чат с именем "$newName" уже существует');
      }
      // Загружаем сообщения из старого чата
      final messages = await loadChat(oldName);
      // Сохраняем их с новым именем
      await saveChat(newName, messages);
      // Удаляем старый чат
      await deleteChat(oldName);
      logger.logDebug('Чат успешно переименован: $oldName -> $newName');
      return true;
    } catch (e) {
      logger.logError('Ошибка при переименовании чата', e);
      if (e is FileNotFoundException || e is SecurityException || e is FileException) {
        rethrow;
      }
      throw FileException('Не удалось переименовать чат: $e');
    }
  }
}
// data-datasources-local-preferences_datasource.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../app.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/logger/app_logger.dart';
abstract class PreferencesDataSource {
  Future<CustomThemeMode> getThemeMode();
  Future<bool> saveThemeMode(CustomThemeMode customThemeMode);
  Future<String> getLanguageCode();
  Future<bool> saveLanguageCode(String languageCode);
}
class PreferencesDataSourceImpl implements PreferencesDataSource {
  final SharedPreferences prefs;
  static const String _themeKey = 'theme_mode';
  static const String _languageKey = 'language_code';
  PreferencesDataSourceImpl({required this.prefs});
  @override
  Future<CustomThemeMode> getThemeMode() async {
    try {
      final themeIndex = prefs.getInt(_themeKey);
      if (themeIndex == null) {
        return CustomThemeMode.system;
      }
      // Безопасное получение значения из enum
      if (themeIndex >= 0 && themeIndex < CustomThemeMode.values.length) {
        return CustomThemeMode.values[themeIndex];
      }
      return CustomThemeMode.system;
    } catch (e) {
      AppLogger.error('Ошибка при получении настройки темы', e);
      throw CacheException('Не удалось получить настройку темы: $e');
    }
  }
  @override
  Future<bool> saveThemeMode(CustomThemeMode customThemeMode) async {
    try {
      final result = await prefs.setInt(_themeKey, customThemeMode.index);
      return result;
    } catch (e) {
      AppLogger.error('Ошибка при сохранении настройки темы', e);
      throw CacheException('Не удалось сохранить настройку темы: $e');
    }
  }
  @override
  Future<String> getLanguageCode() async {
    try {
      final languageCode = prefs.getString(_languageKey);
      if (languageCode == null || languageCode.isEmpty) {
        return 'en';
      }
      return languageCode;
    } catch (e) {
      AppLogger.error('Ошибка при получении настройки языка', e);
      throw CacheException('Не удалось получить настройку языка: $e');
    }
  }
  @override
  Future<bool> saveLanguageCode(String languageCode) async {
    try {
      // Валидируем код языка
      if (languageCode.isEmpty || languageCode.length > 10) {
        throw CacheException('Недопустимый код языка');
      }
      final result = await prefs.setString(_languageKey, languageCode);
      return result;
    } catch (e) {
      AppLogger.error('Ошибка при сохранении настройки языка', e);
      throw CacheException('Не удалось сохранить настройку языка: $e');
    }
  }
}
// data-datasources-remote-classifier_datasource.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/constants/app_constants.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/logger/app_logger.dart';
abstract class ClassifierDataSource {
  /// Выполняет классификацию текста с помощью внешнего API
  Future<List<List<double>>> classifyText(String text);
}
class ClassifierDataSourceImpl implements ClassifierDataSource {
  final http.Client httpClient;
  ClassifierDataSourceImpl({http.Client? httpClient})
      : httpClient = httpClient ?? http.Client();
  @override
  Future<List<List<double>>> classifyText(String text) async {
    try {
      if (text.trim().isEmpty) {
        return [[0.0], [0.0]];
      }
      final url = Uri.parse(AppConstants.classifierEndpoint);
      final response = await httpClient.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'text': text}),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw NetworkException('Тайм-аут запроса классификации'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Улучшенная валидация ответа
        if (!data.containsKey('output') || !data.containsKey('outputEmotions')) {
          throw FormatException('Неверный формат ответа API: отсутствуют обязательные поля');
        }
        if (!(data['output'] is List) || data['output'].isEmpty) {
          throw FormatException('Неверный формат поля output: ожидался непустой список');
        }
        if (!(data['outputEmotions'] is List) || data['outputEmotions'].isEmpty) {
          throw FormatException('Неверный формат поля outputEmotions: ожидался непустой список');
        }
        try {
          final output = (data['output'][0] as List<dynamic>)
              .map((e) => (e as num).toDouble())
              .toList();
          final outputEmotions = [(data['outputEmotions'][0] as num).toDouble()];
          AppLogger.debug('Классификация успешно выполнена');
          return [output, outputEmotions];
        } catch (e) {
          throw FormatException('Ошибка при преобразовании данных: $e');
        }
      } else {
        AppLogger.error('Ошибка API классификации: ${response.statusCode}');
        throw ServerException('Ошибка API классификации',statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException || e is FormatException) {
        rethrow;
      }
      AppLogger.error('Ошибка во время классификации текста', e);
      throw NetworkException('Не удалось выполнить классификацию: $e');
    }
  }
}
// data-datasources-remote-translator_datasource.dart
import 'package:translator/translator.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/logger/app_logger.dart';
class TranslationException extends AppException {
  TranslationException(super.message, [super.originalError]);
}
abstract class TranslatorDataSource {
  Future<String> translate(String text, String targetLanguage);
  Future<String> detectLanguage(String text);
}
class TranslatorDataSourceImpl implements TranslatorDataSource {
  final GoogleTranslator translator;
  TranslatorDataSourceImpl({GoogleTranslator? translator})
      : translator = translator ?? GoogleTranslator();
  @override
  Future<String> translate(String text, String targetLanguage) async {
    try {
      if (text.trim().isEmpty) {
        return text;
      }
      AppLogger.debug('Перевод текста на язык: $targetLanguage');
      final result = await translator.translate(
        text,
        to: targetLanguage,
      );
      AppLogger.debug('Перевод выполнен успешно');
      return result.text;
    } catch (e) {
      AppLogger.error('Ошибка при переводе текста', e);
      throw TranslationException('Не удалось перевести текст: $e');
    }
  }
  @override
  Future<String> detectLanguage(String text) async {
    try {
      if (text.trim().isEmpty) {
        return 'en';
      }
      final result = await translator.translate(text);
      return result.sourceLanguage.code;
    } catch (e) {
      AppLogger.error('Ошибка при определении языка', e);
      throw TranslationException('Не удалось определить язык текста: $e');
    }
  }
}
// data-models-chat_model.dart
// data/models/chat_model.dart
import 'dart:convert';
import 'package:uuid/uuid.dart';
import '../../domain/entities/chat.dart';
import '../../domain/entities/message.dart';
import 'message_model.dart';
class ChatModel extends Chat {
  const ChatModel({
    required String id,
    required String name,
    required DateTime createdAt,
    required DateTime lastModified,
    required List<Message> messages,
  }) : super(
    id: id,
    name: name,
    createdAt: createdAt,
    lastModified: lastModified,
    messages: messages,
  );
  factory ChatModel.fromEntity(Chat chat) {
    return ChatModel(
      id: chat.id,
      name: chat.name,
      createdAt: chat.createdAt,
      lastModified: chat.lastModified,
      messages: chat.messages,
    );
  }
  factory ChatModel.create({
    required String name,
    List<Message>? messages,
  }) {
    final now = DateTime.now();
    return ChatModel(
      id: const Uuid().v4(),
      name: name,
      createdAt: now,
      lastModified: now,
      messages: messages ?? [],
    );
  }
  factory ChatModel.fromJson(Map<String, dynamic> json) {
    if (!json.containsKey('id') ||
        !json.containsKey('name') ||
        !json.containsKey('createdAt') ||
        !json.containsKey('lastModified') ||
        !json.containsKey('messages')) {
      throw const FormatException('Некорректный формат JSON для Chat');
    }
    final List<Message> messages = (json['messages'] as List)
        .map((msgJson) => MessageModel.fromJson(msgJson))
        .toList();
    return ChatModel(
      id: json['id'] as String,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastModified: DateTime.parse(json['lastModified'] as String),
      messages: messages,
    );
  }
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'createdAt': createdAt.toIso8601String(),
    'lastModified': lastModified.toIso8601String(),
    'messages': messages.map((msg) =>
    msg is MessageModel ? msg.toJson() : MessageModel.fromEntity(msg).toJson()
    ).toList(),
  };
  ChatModel copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
    DateTime? lastModified,
    List<Message>? messages,
  }) {
    return ChatModel(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      lastModified: lastModified ?? this.lastModified,
      messages: messages ?? this.messages,
    );
  }
  ChatModel addMessage(Message message) {
    final newMessages = List<Message>.from(messages)..add(message);
    return copyWith(
      messages: newMessages,
      lastModified: DateTime.now(),
    );
  }
  static ChatModel fromJsonString(String jsonString) {
    return ChatModel.fromJson(json.decode(jsonString));
  }
}
// data-models-message_model.dart
import 'dart:convert';
import 'package:uuid/uuid.dart';
import '../../domain/entities/message.dart';
class MessageModel extends Message {
  const MessageModel({
    required String text,
    required bool isUser,
    required DateTime timestamp,
    String? reaction,
    List<List<double>>? classificationResult,
    List<List<double>>? classificationEmotionsResult,
    bool isTranslating = false,
    String? id,
  }) : super(
    text: text,
    isUser: isUser,
    timestamp: timestamp,
    reaction: reaction,
    classificationResult: classificationResult,
    classificationEmotionsResult: classificationEmotionsResult,
    isTranslating: isTranslating,
    id: id,
  );
  factory MessageModel.fromEntity(Message message) {
    return MessageModel(
      text: message.text,
      isUser: message.isUser,
      timestamp: message.timestamp,
      reaction: message.reaction,
      classificationResult: message.classificationResult,
      classificationEmotionsResult: message.classificationEmotionsResult,
      isTranslating: message.isTranslating,
      id: message.id ?? const Uuid().v4(),
    );
  }
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    // Проверяем наличие необходимых полей
    if (!json.containsKey('text') ||
        !json.containsKey('isUser') ||
        !json.containsKey('timestamp')) {
      throw const FormatException('Некорректный формат JSON для Message');
    }
    // Обрабатываем classificationResult
    List<List<double>>? classificationResult;
    if (json['classificationResult'] != null) {
      classificationResult = [];
      for (var result in json['classificationResult']) {
        if (result is List) {
          classificationResult.add(
              List<double>.from(result.map((x) => x is num ? x.toDouble() : 0.0))
          );
        }
      }
    }
    // Обрабатываем classificationEmotionsResult
    List<List<double>>? classificationEmotionsResult;
    if (json['classificationEmotionsResult'] != null) {
      classificationEmotionsResult = [];
      for (var result in json['classificationEmotionsResult']) {
        if (result is List) {
          classificationEmotionsResult.add(
              List<double>.from(result.map((x) => x is num ? x.toDouble() : 0.0))
          );
        }
      }
    }
    return MessageModel(
      text: json['text'] as String,
      isUser: json['isUser'] as bool,
      timestamp: DateTime.parse(json['timestamp'] as String),
      reaction: json['reaction'] as String?,
      classificationResult: classificationResult,
      classificationEmotionsResult: classificationEmotionsResult,
      isTranslating: json['isTranslating'] as bool? ?? false,
      id: json['id'] as String? ?? const Uuid().v4(),
    );
  }
  Map<String, dynamic> toJson() => {
    'text': text,
    'isUser': isUser,
    'timestamp': timestamp.toIso8601String(),
    'reaction': reaction,
    'classificationResult': classificationResult,
    'classificationEmotionsResult': classificationEmotionsResult,
    'isTranslating': isTranslating,
    'id': id,
  };
  @override
  MessageModel copyWith({
    String? text,
    bool? isUser,
    DateTime? timestamp,
    Object? reaction = _unchanged,
    Object? classificationResult = _unchanged,
    Object? classificationEmotionsResult = _unchanged,
    bool? isTranslating,
    String? id,
  }) {
    return MessageModel(
      text: text ?? this.text,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
      reaction: reaction == _unchanged ? this.reaction : reaction as String?,
      classificationResult: classificationResult == _unchanged
          ? this.classificationResult
          : classificationResult as List<List<double>>?,
      classificationEmotionsResult: classificationEmotionsResult == _unchanged
          ? this.classificationEmotionsResult
          : classificationEmotionsResult as List<List<double>>?,
      isTranslating: isTranslating ?? this.isTranslating,
      id: id ?? this.id,
    );
  }
// Добавляем константу в область видимости класса
  static const _unchanged = Object();
  static List<MessageModel> fromJsonList(String jsonString) {
    try {
      final List<dynamic> decodedList = json.decode(jsonString);
      return decodedList
          .map((item) => MessageModel.fromJson(item))
          .toList();
    } catch (e) {
      throw FormatException('Ошибка при разборе JSON списка сообщений: $e');
    }
  }
  static String toJsonList(List<MessageModel> messages) {
    final jsonList = messages.map((message) => message.toJson()).toList();
    return json.encode(jsonList);
  }
}
// data-repositories-chat_repository_impl.dart
import 'package:dartz/dartz.dart';
import 'package:flutter_launcher_icons/custom_exceptions.dart';
import '../../core/services/translation_service.dart';
import '../../core/utils/translation_utils.dart';
import '../datasources/local/chat_local_datasource.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../domain/entities/message.dart';
import '../../core/errors/failure.dart';
import '../../core/errors/app_exception.dart';
import '../../core/logger/app_logger.dart';
import '../models/message_model.dart';
class ChatRepositoryImpl implements ChatRepository {
  final ChatLocalDataSource dataSource;
  final AppLogger logger;
  ChatRepositoryImpl({
    required this.dataSource,
    required this.logger,
  });
  @override
  Future<Either<Failure, Map<String, DateTime>>> getSavedChats() async {
    try {
      final result = await dataSource.getSavedChats();
      return Right(result);
    } on FileException catch (e) {
      logger.logError('Не удалось получить список сохраненных чатов', e);
      return Left(FileOperationFailure(
          message: 'Не удалось получить список сохраненных чатов: ${e.message}'
      ));
    } catch (e) {
      logger.logError('Неизвестная ошибка при получении списка чатов', e);
      return Left(UnknownFailure(
          message: Tr.get(TranslationKeys.errorNum1)
      ));
    }
  }
  @override
  Future<Either<Failure, List<Message>>> loadChat(String chatName) async {
    try {
      final messagesData = await dataSource.loadChat(chatName);
      return Right(messagesData);
    } on FileNotFoundException catch (e) {
      logger.logError('Файл чата не найден', e);
      return Left(FileOperationFailure(
          message: 'Чат не найден: $e'
      ));
    } on FileException catch (e) {
      logger.logError('Ошибка при загрузке чата', e);
      return Left(FileOperationFailure(
          message: 'Не удалось загрузить чат: ${e.message}'
      ));
    } on FormatException catch (e) {
      logger.logError('Ошибка формата данных чата', e);
      return Left(ValidationFailure(
          message: 'Некорректный формат данных чата: ${e.message}'
      ));
    } catch (e) {
      logger.logError('Неизвестная ошибка при загрузке чата', e);
      return const Left(UnknownFailure(
          message: 'Произошла ошибка при загрузке чата'
      ));
    }
  }
  @override
  Future<Either<Failure, bool>> saveChat(String chatName, List<Message> messages) async {
    try {
      // Конвертируем Message в MessageModel
      final messageModels = messages.map((m) =>
      m is MessageModel ? m : MessageModel.fromEntity(m)).toList();
      final success = await dataSource.saveChat(chatName, messageModels);
      return Right(success);
    } on SecurityException catch (e) {
      logger.logError('Ошибка безопасности при сохранении чата', e);
      return Left(ValidationFailure(
          message: 'Недопустимое имя чата: ${e.message}'
      ));
    } on FileException catch (e) {
      logger.logError('Ошибка файловой системы при сохранении чата', e);
      return Left(FileOperationFailure(
          message: 'Не удалось сохранить чат: ${e.message}'
      ));
    } catch (e) {
      logger.logError('Неизвестная ошибка при сохранении чата', e);
      return const Left(UnknownFailure(
          message: 'Произошла ошибка при сохранении чата'
      ));
    }
  }
  @override
  Future<Either<Failure, bool>> deleteChat(String chatName) async {
    try {
      final success = await dataSource.deleteChat(chatName);
      return Right(success);
    } on FileException catch (e) {
      logger.logError('Ошибка при удалении чата', e);
      return Left(FileOperationFailure(
          message: 'Не удалось удалить чат: ${e.message}'
      ));
    } catch (e) {
      logger.logError('Неизвестная ошибка при удалении чата', e);
      return const Left(UnknownFailure(
          message: 'Произошла ошибка при удалении чата'
      ));
    }
  }
  @override
  Future<Either<Failure, String>> getUniqueDefaultChatName() async {
    try {
      final chatName = await dataSource.getUniqueDefaultChatName();
      return Right(chatName);
    } catch (e) {
      logger.logError('Ошибка при генерации имени чата', e);
      return const Left(UnknownFailure(
          message: 'Не удалось создать имя для нового чата'
      ));
    }
  }
  @override
  Future<Either<Failure, bool>> chatExists(String chatName) async {
    try {
      final exists = await dataSource.chatExists(chatName);
      return Right(exists);
    } catch (e) {
      logger.logError('Ошибка при проверке существования чата', e);
      return const Left(FileOperationFailure(
          message: 'Не удалось проверить существование чата'
      ));
    }
  }
  @override
  Future<Either<Failure, bool>> renameChat(String oldName, String newName) async {
    try {
      final success = await dataSource.renameChat(oldName, newName);
      return Right(success);
    } on SecurityException catch (e) {
      logger.logError('Ошибка безопасности при переименовании чата', e);
      return Left(ValidationFailure(
          message: 'Недопустимое имя чата: ${e.message}'
      ));
    } on FileException catch (e) {
      logger.logError('Ошибка файловой системы при переименовании чата', e);
      return Left(FileOperationFailure(
          message: 'Не удалось переименовать чат: ${e.message}'
      ));
    } catch (e) {
      logger.logError('Неизвестная ошибка при переименовании чата', e);
      return const Left(UnknownFailure(
          message: 'Произошла ошибка при переименовании чата'
      ));
    }
  }
}
// data-repositories-settings_repository_impl.dart
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import '../../app.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../domain/entities/user_settings.dart';
import '../../core/errors/failure.dart';
import '../../core/errors/app_exception.dart';
import '../datasources/local/preferences_datasource.dart';
class SettingsRepositoryImpl implements SettingsRepository {
  final PreferencesDataSource dataSource;
  SettingsRepositoryImpl({required this.dataSource});
  @override
  Future<Either<Failure, UserSettings>> getSettings() async {
    try {
      final customThemeMode = await dataSource.getThemeMode();
      final languageCode = await dataSource.getLanguageCode();
      final settings = UserSettings(
        customThemeMode: customThemeMode,
        languageCode: languageCode,
      );
      return Right(settings);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: 'Ошибка при получении настроек: $e'));
    }
  }
  @override
  Future<Either<Failure, CustomThemeMode>> getThemeMode() async {
    try {
      final customThemeMode = await dataSource.getThemeMode();
      return Right(customThemeMode);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: 'Ошибка при получении темы: $e'));
    }
  }
  @override
  Future<Either<Failure, bool>> saveThemeMode(CustomThemeMode customThemeMode) async {
    try {
      final success = await dataSource.saveThemeMode(customThemeMode);
      return Right(success);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: 'Ошибка при сохранении темы: $e'));
    }
  }
  @override
  Future<Either<Failure, String>> getLanguageCode() async {
    try {
      final languageCode = await dataSource.getLanguageCode();
      return Right(languageCode);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: 'Ошибка при получении языка: $e'));
    }
  }
  @override
  Future<Either<Failure, bool>> saveLanguageCode(String languageCode) async {
    try {
      final success = await dataSource.saveLanguageCode(languageCode);
      return Right(success);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: 'Ошибка при сохранении языка: $e'));
    }
  }
}
// domain-entities-chat.dart
// domain/entities/chat.dart
import 'package:equatable/equatable.dart';
import 'message.dart';
class Chat extends Equatable {
  final String id;
  final String name;
  final DateTime createdAt;
  final DateTime lastModified;
  final List<Message> messages;
  const Chat({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.lastModified,
    required this.messages,
  });
  @override
  List<Object> get props => [id, name, createdAt, lastModified, messages];
}
// domain-entities-classification_result.dart
import 'package:equatable/equatable.dart';
class ClassificationResult extends Equatable {
  final List<double> categoryScores;
  final double emotionalScore;
  final String predictedCategory;
  final double confidence;
  const ClassificationResult({
    required this.categoryScores,
    required this.emotionalScore,
    required this.predictedCategory,
    required this.confidence,
  });
  /// Уровень позитивности текста от 0 до 100%
  double get positivityPercentage => ((emotionalScore + 1) / 2) * 100;
  /// Уровень уверенности от 0 до 100%
  double get confidencePercentage => confidence * 100;
  @override
  List<Object> get props => [
    categoryScores,
    emotionalScore,
    predictedCategory,
    confidence
  ];
  ClassificationResult copyWith({
    List<double>? categoryScores,
    double? emotionalScore,
    String? predictedCategory,
    double? confidence,
  }) {
    return ClassificationResult(
      categoryScores: categoryScores ?? this.categoryScores,
      emotionalScore: emotionalScore ?? this.emotionalScore,
      predictedCategory: predictedCategory ?? this.predictedCategory,
      confidence: confidence ?? this.confidence,
    );
  }
}
// domain-entities-message.dart
import 'package:equatable/equatable.dart';
class Message extends Equatable {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final String? reaction;
  final List<List<double>>? classificationResult;
  final List<List<double>>? classificationEmotionsResult;
  final bool isTranslating;
  final String? id;
  const Message({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.reaction,
    this.classificationResult,
    this.classificationEmotionsResult,
    this.isTranslating = false,
    this.id,
  });
  Message copyWith({
    String? text,
    bool? isUser,
    DateTime? timestamp,
    Object? reaction = _unchanged,
    Object? classificationResult = _unchanged,
    Object? classificationEmotionsResult = _unchanged,
    bool? isTranslating,
    String? id,
  }) {
    return Message(
      text: text ?? this.text,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
      reaction: reaction == _unchanged ? this.reaction : reaction as String?,
      classificationResult: classificationResult == _unchanged
          ? this.classificationResult
          : classificationResult as List<List<double>>?,
      classificationEmotionsResult: classificationEmotionsResult == _unchanged
          ? this.classificationEmotionsResult
          : classificationEmotionsResult as List<List<double>>?,
      isTranslating: isTranslating ?? this.isTranslating,
      id: id ?? this.id,
    );
  }
// Добавляем константу в область видимости класса
  static const _unchanged = Object();
  @override
  List<Object?> get props => [
    id,
    text,
    isUser,
    timestamp,
    reaction,
    // Используем toString() для коллекций, чтобы корректно сравнивать в Equatable
    classificationResult?.toString(),
    classificationEmotionsResult?.toString(),
    isTranslating,
  ];
}
// domain-entities-user_settings.dart
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../app.dart';
class UserSettings extends Equatable {
  final CustomThemeMode customThemeMode;
  final String languageCode;
  const UserSettings({
    this.customThemeMode = CustomThemeMode.system,
    this.languageCode = 'en',
  });
  UserSettings copyWith({
    CustomThemeMode? customThemeMode,
    String? languageCode,
  }) {
    return UserSettings(
      customThemeMode: customThemeMode ?? this.customThemeMode,
      languageCode: languageCode ?? this.languageCode,
    );
  }
  @override
  List<Object> get props => [customThemeMode, languageCode];
}
// domain-repositories-chat_repository.dart
import 'package:dartz/dartz.dart';
import '../entities/message.dart';
import '../../core/errors/failure.dart';
abstract class ChatRepository {
  /// Получает список сохраненных чатов и времени их изменения
  Future<Either<Failure, Map<String, DateTime>>> getSavedChats();
  /// Загружает сообщения из чата с указанным именем
  Future<Either<Failure, List<Message>>> loadChat(String chatName);
  /// Сохраняет чат с указанным именем
  Future<Either<Failure, bool>> saveChat(String chatName, List<Message> messages);
  /// Удаляет чат с указанным именем
  Future<Either<Failure, bool>> deleteChat(String chatName);
  /// Генерирует уникальное имя для нового чата
  Future<Either<Failure, String>> getUniqueDefaultChatName();
  /// Проверяет существование чата с указанным именем
  Future<Either<Failure, bool>> chatExists(String chatName);
  /// Переименовывает чат
  Future<Either<Failure, bool>> renameChat(String oldName, String newName);
}
// domain-repositories-classifier_repository.dart
import 'package:dartz/dartz.dart';
import '../../core/errors/failure.dart';
abstract class ClassifierRepository {
  /// Выполняет классификацию текста
  Future<Either<Failure, List<List<double>>>> classifyText(String text);
}
// domain-repositories-classifier_repository_impl.dart
import 'package:dartz/dartz.dart';
import '../../data/datasources/remote/classifier_datasource.dart';
import '../../domain/repositories/classifier_repository.dart';
import '../../core/errors/failure.dart';
import '../../core/errors/app_exception.dart';
import '../../core/logger/app_logger.dart';
class ClassifierRepositoryImpl implements ClassifierRepository {
  final ClassifierDataSource dataSource;
  ClassifierRepositoryImpl({required this.dataSource});
  @override
  Future<Either<Failure, List<List<double>>>> classifyText(String text) async {
    try {
      final result = await dataSource.classifyText(text);
      return Right(result);
    } on ServerException catch (e) {
      AppLogger.error('Ошибка сервера при классификации текста', e);
      return Left(ServerFailure(
        message: 'Ошибка сервера при классификации текста: ${e.message}',
        code: e.statusCode,
      ));
    } on NetworkException catch (e) {
      AppLogger.error('Ошибка сети при классификации текста', e);
      return Left(NetworkFailure(
        message: 'Ошибка сети при классификации текста: ${e.message}',
      ));
    } on FormatException catch (e) {
      AppLogger.error('Ошибка формата данных при классификации текста', e);
      return Left(ClassificationFailure(
        message: 'Некорректный формат данных: ${e.message}',
      ));
    } catch (e) {
      AppLogger.error('Неизвестная ошибка при классификации текста', e);
      return const Left(UnknownFailure(
        message: 'Произошла ошибка при классификации текста',
      ));
    }
  }
}
// domain-repositories-settings_repository.dart
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import '../../app.dart';
import '../../core/errors/failure.dart';
import '../entities/user_settings.dart';
abstract class SettingsRepository {
  /// Получает настройки пользователя
  Future<Either<Failure, UserSettings>> getSettings();
  /// Получает режим темы
  Future<Either<Failure, CustomThemeMode>> getThemeMode();
  /// Сохраняет режим темы
  Future<Either<Failure, bool>> saveThemeMode(CustomThemeMode themeMode);
  /// Получает код языка
  Future<Either<Failure, String>> getLanguageCode();
  /// Сохраняет код языка
  Future<Either<Failure, bool>> saveLanguageCode(String languageCode);
}
// domain-repositories-speech_repository.dart
import 'package:dartz/dartz.dart';
import '../../core/errors/failure.dart';
abstract class SpeechRepository {
  /// Инициализирует систему распознавания речи
  Future<Either<Failure, bool>> initialize();
  /// Начинает прослушивание
  Future<Either<Failure, Stream<String>>> startListening();
  /// Останавливает прослушивание
  Future<Either<Failure, bool>> stopListening();
  /// Проверяет, доступно ли распознавание речи
  Future<Either<Failure, bool>> isAvailable();
  /// Проверяет, слушает ли система в данный момент
  Future<Either<Failure, bool>> isListening();
}
// domain-repositories-speech_repository_impl.dart
import 'package:dartz/dartz.dart';
import '../../data/datasources/device/speech_datasource.dart';
import '../../domain/repositories/speech_repository.dart';
import '../../core/errors/failure.dart';
import '../../core/errors/app_exception.dart';
import '../../core/logger/app_logger.dart';
class SpeechRepositoryImpl implements SpeechRepository {
  final SpeechDataSource dataSource;
  SpeechRepositoryImpl({required this.dataSource});
  @override
  Future<Either<Failure, bool>> initialize() async {
    try {
      final result = await dataSource.initialize();
      return Right(result);
    } on PermissionException catch (e) {
      AppLogger.error('Ошибка доступа к микрофону', e);
      return Left(PermissionFailure(
        message: 'Нет доступа к микрофону: ${e.message}',
      ));
    } catch (e) {
      AppLogger.error('Ошибка инициализации распознавания речи', e);
      return Left(UnknownFailure(
        message: 'Не удалось инициализировать распознавание речи: $e',
      ));
    }
  }
  @override
  Future<Either<Failure, Stream<String>>> startListening() async {
    try {
      final result = await dataSource.startListening();
      return Right(result);
    } on PermissionException catch (e) {
      AppLogger.error('Ошибка доступа к микрофону', e);
      return Left(PermissionFailure(
        message: 'Нет доступа к микрофону: ${e.message}',
      ));
    } catch (e) {
      AppLogger.error('Ошибка при запуске распознавания речи', e);
      return Left(UnknownFailure(
        message: 'Не удалось запустить распознавание речи: $e',
      ));
    }
  }
  @override
  Future<Either<Failure, bool>> stopListening() async {
    try {
      final result = await dataSource.stopListening();
      return Right(result);
    } catch (e) {
      AppLogger.error('Ошибка при остановке распознавания речи', e);
      return Left(UnknownFailure(
        message: 'Не удалось остановить распознавание речи: $e',
      ));
    }
  }
  @override
  Future<Either<Failure, bool>> isAvailable() async {
    try {
      final result = await dataSource.isAvailable();
      return Right(result);
    } catch (e) {
      AppLogger.error('Ошибка при проверке доступности распознавания речи', e);
      return Left(UnknownFailure(
        message: 'Не удалось проверить доступность распознавания речи: $e',
      ));
    }
  }
  @override
  Future<Either<Failure, bool>> isListening() async {
    try {
      final result = await dataSource.isListening();
      return Right(result);
    } catch (e) {
      AppLogger.error('Ошибка при проверке статуса распознавания речи', e);
      return Left(UnknownFailure(
        message: 'Не удалось проверить статус распознавания речи: $e',
      ));
    }
  }
}
// domain-repositories-translator_repository.dart
import 'package:dartz/dartz.dart';
import '../../core/errors/failure.dart';
abstract class TranslatorRepository {
  /// Переводит текст на указанный язык
  Future<Either<Failure, String>> translate(String text, String targetLanguage);
  /// Определяет язык текста
  Future<Either<Failure, String>> detectLanguage(String text);
}
// domain-repositories-translator_repository_impl.dart
import 'package:dartz/dartz.dart';
import '../../data/datasources/remote/translator_datasource.dart';
import '../../domain/repositories/translator_repository.dart';
import '../../core/errors/failure.dart';
import '../../core/errors/app_exception.dart';
import '../../core/logger/app_logger.dart';
class TranslatorRepositoryImpl implements TranslatorRepository {
  final TranslatorDataSource dataSource;
  TranslatorRepositoryImpl({required this.dataSource});
  @override
  Future<Either<Failure, String>> translate(String text, String targetLanguage) async {
    try {
      // Если текст пустой, возвращаем его без перевода
      if (text.trim().isEmpty) {
        return Right(text);
      }
      final result = await dataSource.translate(text, targetLanguage);
      return Right(result);
    } on NetworkException catch (e) {
      AppLogger.error('Ошибка сети при переводе текста', e);
      return Left(NetworkFailure(
        message: 'Ошибка сети при переводе текста: ${e.message}',
      ));
    } on ServerException catch (e) {
      AppLogger.error('Ошибка сервера при переводе текста', e);
      return Left(ServerFailure(
        message: 'Ошибка сервера при переводе текста: ${e.message}',
        code: e.statusCode,
      ));
    } on TranslationException catch (e) {
      AppLogger.error('Ошибка перевода', e);
      return Left(TranslationFailure(
        message: 'Ошибка перевода: ${e.message}',
      ));
    } catch (e) {
      AppLogger.error('Неизвестная ошибка при переводе текста', e);
      return const Left(UnknownFailure(
        message: 'Произошла ошибка при переводе текста',
      ));
    }
  }
  @override
  Future<Either<Failure, String>> detectLanguage(String text) async {
    try {
      if (text.trim().isEmpty) {
        return const Right('en'); // По умолчанию - английский
      }
      final result = await dataSource.detectLanguage(text);
      return Right(result);
    } catch (e) {
      AppLogger.error('Ошибка при определении языка', e);
      return const Left(UnknownFailure(
        message: 'Произошла ошибка при определении языка текста',
      ));
    }
  }
}
// domain-usecases-chat-delete_chat.dart
import 'package:dartz/dartz.dart';
import '../../../core/errors/failure.dart';
import '../../repositories/chat_repository.dart';
class DeleteChat {
  final ChatRepository repository;
  DeleteChat(this.repository);
  Future<Either<Failure, bool>> call(String chatName) async {
    // Проверяем имя чата
    if (chatName.trim().isEmpty) {
      return const Left(ValidationFailure(
          message: 'Имя чата не может быть пустым'
      ));
    }
    // Делегируем работу репозиторию
    return repository.deleteChat(chatName);
  }
}
// domain-usecases-chat-export_chat.dart
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/errors/failure.dart';
import '../../../core/services/translation_service.dart';
import '../../../core/utils/translation_utils.dart';
import '../../entities/message.dart';
import '../../repositories/chat_repository.dart';
import '../../../core/logger/app_logger.dart';
import '../../../core/utils/datetime_utils.dart';
class ExportChat {
  final ChatRepository repository;
  ExportChat(this.repository);
  Future<Either<Failure, String>> call(
      String chatName,
      Map<String, dynamic> translations,
      String currentLanguage
      ) async {
    try {
      // Загружаем чат
      final messagesResult = await repository.loadChat(chatName);
      return messagesResult.fold(
              (failure) => Left(failure),
              (messages) async {
            if (messages.isEmpty) {
              return const Left(ValidationFailure(message: 'Чат пуст'));
            }
            final filePath = await _exportToFile(messages, translations, currentLanguage);
            return Right(filePath);
          }
      );
    } catch (e) {
      AppLogger.error('Ошибка при экспорте чата', e);
      return Left(UnknownFailure(
          message: 'Произошла ошибка при экспорте чата: $e'
      ));
    }
  }
  Future<String> _exportToFile(
      List<Message> messages,
      Map<String, dynamic> translations,
      String currentLanguage
      ) async {
    final StringBuffer buffer = StringBuffer();
    buffer.writeln(Tr.get(TranslationKeys.chatHistory));
    buffer.writeln("${Tr.get(TranslationKeys.date)}: ${DateTimeUtils.formatDateTime(DateTime.now())}");
    buffer.writeln("------------------------");
    for (final msg in messages) {
      final sender = msg.isUser ? Tr.get(TranslationKeys.user) : Tr.get(TranslationKeys.bot);
      final time = DateTimeUtils.formatTime(msg.timestamp);
      buffer.writeln("$sender ($time):");
      buffer.writeln(msg.text);
      buffer.writeln("------------------------");
    }
    // Сохраняем в файл
    final directory = await getTemporaryDirectory();
    final fileName = 'chat_export_${DateTime.now().millisecondsSinceEpoch}.txt';
    final filePath = '${directory.path}/$fileName';
    final file = File(filePath);
    await file.writeAsString(buffer.toString());
    // Отправляем на шаринг
    await Share.shareXFiles([XFile(filePath)], text: "Экспорт чата");
    return filePath;
  }
}
// domain-usecases-chat-get_message_history.dart
import 'package:dartz/dartz.dart';
import '../../../core/errors/failure.dart';
import '../../entities/message.dart';
import '../../repositories/chat_repository.dart';
class GetMessageHistory {
  final ChatRepository repository;
  GetMessageHistory(this.repository);
  Future<Either<Failure, List<Message>>> call([String? chatName]) async {
    // Если имя чата не указано, используем текущий (временный) чат
    final name = chatName ?? 'current';
    try {
      final result = await repository.loadChat(name);
      return result.fold(
            (failure) {
          // Если чат не найден, возвращаем пустой список сообщений без ошибки
          if (failure is FileOperationFailure &&
              failure.message.contains('не найден')) {
            return const Right([]);
          }
          // Иначе прокидываем ошибку
          return Left(failure);
        },
            (messages) => Right(messages),
      );
    } catch (e) {
      return Left(UnknownFailure(
          message: 'Произошла ошибка при загрузке истории сообщений: $e'
      ));
    }
  }
}
// domain-usecases-chat-save_chat.dart
import 'package:dartz/dartz.dart';
import '../../../core/errors/failure.dart';
import '../../entities/message.dart';
import '../../repositories/chat_repository.dart';
class SaveChat {
  final ChatRepository repository;
  SaveChat(this.repository);
  Future<Either<Failure, bool>> call(String chatName, List<Message> messages) async {
    // Проверяем имя чата
    if (chatName.trim().isEmpty) {
      return const Left(ValidationFailure(
          message: 'Имя чата не может быть пустым'
      ));
    }
    // Проверяем наличие сообщений
    if (messages.isEmpty) {
      return const Left(ValidationFailure(
          message: 'Список сообщений не может быть пустым'
      ));
    }
    // Делегируем работу репозиторию
    return repository.saveChat(chatName, messages);
  }
}
// domain-usecases-chat-send_message.dart
import 'package:dartz/dartz.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/classification_constants.dart';
import '../../../core/errors/failure.dart';
import '../../../core/services/translation_service.dart';
import '../../../core/utils/translation_utils.dart';
import '../../../presentation/bloc/chat/chat_bloc.dart';
import '../../entities/message.dart';
import '../../repositories/chat_repository.dart';
import '../../repositories/classifier_repository.dart';
import '../../repositories/translator_repository.dart';
import '../classification/classify_text.dart';
import 'dart:math' as Math;
class SendMessage {
  final ChatRepository chatRepository;
  final ClassifierRepository classifierRepository;
  final TranslatorRepository translatorRepository;
  // Кэш для результатов softmax
  final Map<String, List<double>> _softmaxCache = {};
  SendMessage(this.chatRepository, this.classifierRepository, this.translatorRepository);
  Future<Either<Failure, List<Message>>> call(String text, String currentChatName, {bool isMultiline = false}) async {
    try {
      // Получаем текущие сообщения
      final messagesResult = await chatRepository.loadChat(currentChatName);
      List<Message> currentMessages = [];
      // Проверка на максимальную длину
      if (text.length > AppConstants.maxTextLength) {
        return const Left(ValidationFailure(message: 'Текст сообщения слишком длинный'));
      }
      // Проверка на наличие запрещенных символов или последовательностей
      if (text.contains(RegExp(r'[^\p{L}\p{N}\p{P}\p{Z}\n\r]', unicode: true))) {
        return const Left(ValidationFailure(message: 'Текст содержит недопустимые символы'));
      }
      messagesResult.fold(
              (failure) {
            currentMessages = [];
          },
              (messages) {
            currentMessages = messages;
          }
      );
      // Добавляем сообщение пользователя
      final userMessage = Message(
          text: text.trim(),
          isUser:  true,
      timestamp: DateTime.now(),
    );
    // Переводим текст на английский для классификации
    final translationResult = await translatorRepository.translate(text, 'en');
    final englishText = translationResult.fold(
    (failure) => text, // Если перевод не удался, используем оригинальный текст
    (translatedText) => translatedText,
    );
    // Классифицируем текст
    final classifyText = ClassifyText(classifierRepository);
    List<List<double>> categoryResults = [];
    List<List<double>> emotionResults = [];
    // Если многострочный режим, разбиваем текст на строки
    if (isMultiline) {
    final lines = englishText.split('\n');
    final totalLines = lines.length;
    for (int i = 0; i < totalLines; i++) {
    final line = lines[i];
    final classificationResult = await classifyText(line);
    classificationResult.fold(
    (failure) {
    // В случае ошибки добавляем дефолтные значения
    categoryResults.add([0.0]);
    emotionResults.add([0.0]);
    },
    (result) {
    // Извлекаем первый элемент, который является List<double>
    List<double> categoryScores = result[0][0];
    List<double> emotionScores = result[1][0];
    // Добавляем результаты
    categoryResults.add(categoryScores);
    emotionResults.add(emotionScores);
    }
    );
    // Обновляем прогресс
    final progress = (i + 1) / totalLines; // Прогресс от 0 до 1
    }
    } else {
    // Если однострочный режим, классифицируем весь текст как одну строку
    final classificationResult = await classifyText(englishText);
    classificationResult.fold(
    (failure) {
    // В случае ошибки добавляем дефолтные значения
    categoryResults.add([0.0]);
    emotionResults.add([0.0]);
    },
    (result) {
    // Извлекаем первый элемент, который является List<double>
    List<double> categoryScores = result[0][0];
    List<double> emotionScores = result[1][0];
    // Добавляем результаты
    categoryResults.add(categoryScores);
    emotionResults.add(emotionScores);
    }
    );
    }
    // Создаем сообщение с результатами
    final messageWithResults = userMessage.copyWith(
    classificationResult: categoryResults,
    classificationEmotionsResult: emotionResults,
    );
    // Сохраняем сообщение в текущем чате
    final saveResult = await chatRepository.saveChat('current', [...currentMessages, messageWithResults]);
    // Проверяем результат сохранения
    if (saveResult.isLeft()) {
    return Left(saveResult.fold((failure) => failure, (success) => null)!);
    }
    // Формируем текст результата классификации
    String resultText = Tr.get(TranslationKeys.couldNotClassifyText);
    if (categoryResults.isNotEmpty && emotionResults.isNotEmpty) {
    resultText = _formatClassificationResult(categoryResults, emotionResults);
    }final botMessage = Message(
    text: resultText,
    isUser:false, // Указываем, что это сообщение от бота
    timestamp: DateTime.now(),
    classificationResult: categoryResults,
    classificationEmotionsResult: emotionResults,
    );
    // Обновляем список сообщений
    final updatedMessages = [...currentMessages, userMessage, botMessage];
    // Сохраняем обновленный список сообщений
    final saveMessagesResult = await chatRepository.saveChat(currentChatName, updatedMessages);
    // Проверяем результат сохранения
    if (saveMessagesResult.isLeft()) {
    return Left(saveMessagesResult.fold((failure) => failure, (success) => null)!);
    }
    // Возвращаем обновленный список сообщений
    return Right(updatedMessages);
    } catch (e) {
    // Обработка исключений
    return Left(UnknownFailure(message: 'Произошла ошибка при отправке сообщения: $e'));
    }
  }
  String _formatClassificationResult(
      List<List<double>> classification,
      List<List<double>> emotionClassification
      ) {
    // Проверяем на null в начале метода
    if (classification.isEmpty || emotionClassification.isEmpty) {
      return Tr.get(TranslationKeys.couldNotClassifyText);
    }
    // Реализация форматирования результатов классификации
    final results = <String>[];
    // Обрабатываем каждую строку отдельно
    for (int i = 0; i < classification.length; i++) {
      final categoryScores = classification[i];
      final emotionScore = i < emotionClassification.length
          ? emotionClassification[i][0]
          : 0.0;
      // Получаем наиболее вероятную категорию
      final predictedLabel = _getPredictedLabel(categoryScores);
      // Получаем уровень уверенности
      final confidence = _getConfidence(categoryScores);
      // Нормализуем эмоциональную оценку от 0 до 100%
      final emotionPercent = ((emotionScore + 1) / 2 * 100).toStringAsFixed(2);
      results.add(
          "${Tr.get(TranslationKeys.category)}: $predictedLabel\n"
              "${Tr.get(TranslationKeys.confidence)}: ${(confidence * 100).toStringAsFixed(2)}%\n"
              "${Tr.get(TranslationKeys.emotionalTone)}: $emotionPercent%"
      );
    }
    // Соединяем результаты в одну строку, разделяя их пустой строкой
    return results.join('\n\n');
  }
  String _getPredictedLabel(List<double> scores) {
    // Получаем индекс максимального значения
    int maxIndex = 0;
    double maxValue = scores[0];
    for (int i = 1; i < scores.length; i++) {
      if (scores[i] > maxValue) {
        maxValue = scores[i];
        maxIndex = i;
      }
    }
    // Возвращаем соответствующую метку из констант
    if (maxIndex < ClassificationConstants.labels.length) {
      return ClassificationConstants.labels[maxIndex];
    }
    return 'UNKNOWN';
  }
  double _getConfidence(List<double> scores) {
    final normalizedScores = _softmax(scores);
    return normalizedScores.reduce((a, b) => a > b ? a : b);
  }
  List<double> _softmax(List<double> scores) {
    // Создаем ключ для кэша
    final key = scores.map((s) => s.toStringAsFixed(6)).join(':');
    // Проверяем кэш
    if (_softmaxCache.containsKey(key)) {
      return _softmaxCache[key]!;
    }
    // Находим максимальное значение для числовой стабильности
    final maxScore = scores.reduce((a, b) => a > b ? a : b);
    // Вычисляем e^(x - max) для каждого x
    final expScores = scores.map((score) => Math.exp(score - maxScore)).toList();
    // Находим сумму всех e^(x - max)
    final sumExpScores = expScores.reduce((a, b) => a + b);
    // Вычисляем softmax: e^(x - max) / sum(e^(x - max))
    final result = expScores.map((score) => score / sumExpScores).toList();
    // Сохраняем в кэш
    _softmaxCache[key] = result;
    return result;
  }
}
// domain-usecases-classification-classify_text.dart
import 'package:dartz/dartz.dart';
import '../../../core/errors/failure.dart';
import '../../repositories/classifier_repository.dart';
class ClassifyText {
  final ClassifierRepository repository;
  ClassifyText(this.repository);
  Future<Either<Failure, List<List<List<double>>>>> call(String text) async {
    // Предварительная проверка текста
    if (text.trim().isEmpty) {
      return Right([[[0.0]], [[0.0]]]); // Пустой текст не классифицируем
    }
    // Разбиваем текст на строки
    final lines = text.split('\n').where((line) => line.trim().isNotEmpty).toList();
    if (lines.isEmpty) {
      return Right([[[0.0]], [[0.0]]]); // Если нет непустых строк
    }
    try {
      // Создаем списки для результатов
      final categoryResults = <List<double>>[];
      final emotionResults = <List<double>>[];
      // Обрабатываем каждую строку последовательно
      for (final line in lines) {
        final result = await repository.classifyText(line);
        result.fold(
                (failure) {
              // В случае ошибки добавляем дефолтные значения
              categoryResults.add([0.0]);
              emotionResults.add([0.0]);
            },
                (classification) {
              categoryResults.add(classification[0]);
              emotionResults.add(classification[1]);
            }
        );
      }
      // Если не удалось получить результаты, возвращаем ошибку
      if (categoryResults.isEmpty) {
        return const Left(ClassificationFailure(
            message: 'Не удалось классифицировать текст'
        ));
      }
      // Возвращаем результаты в правильном формате
      return Right([categoryResults, emotionResults]);
    } catch (e) {
      return Left(ClassificationFailure(
          message: 'Ошибка при классификации текста: $e'
      ));
    }
  }
}
// domain-usecases-settings-change_language.dart
import 'package:dartz/dartz.dart';
import '../../../core/errors/failure.dart';
import '../../repositories/settings_repository.dart';
class ChangeLanguage {
  final SettingsRepository repository;
  ChangeLanguage(this.repository);
  Future<Either<Failure, bool>> call(String languageCode) async {
    try {
      // Валидация кода языка
      if (languageCode.trim().isEmpty) {
        return const Left(ValidationFailure(
            message: 'Код языка не может быть пустым'
        ));
      }
      // Сохраняем новый язык
      return repository.saveLanguageCode(languageCode);
    } catch (e) {
      return Left(UnknownFailure(
          message: 'Произошла ошибка при изменении языка: $e'
      ));
    }
  }
}
// domain-usecases-settings-get_settings.dart
import 'package:dartz/dartz.dart';
import '../../../core/errors/failure.dart';
import '../../entities/user_settings.dart';
import '../../repositories/settings_repository.dart';
class GetSettings {
  final SettingsRepository repository;
  GetSettings(this.repository);
  Future<Either<Failure, UserSettings>> call() async {
    try {
      return repository.getSettings();
    } catch (e) {
      return Left(UnknownFailure(
          message: 'Произошла ошибка при получении настроек: $e'
      ));
    }
  }
}
// domain-usecases-settings-toggle_theme.dart
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import '../../../app.dart';
import '../../../core/errors/failure.dart';
import '../../repositories/settings_repository.dart';
class ToggleTheme {
  final SettingsRepository repository;
  ToggleTheme(this.repository);
  Future<Either<Failure, CustomThemeMode>> call() async {
    try {
      // Получаем текущую тему
      final currentThemeResult = await repository.getThemeMode();
      return currentThemeResult.fold(
            (failure) => Left(failure),
            (currentTheme) async {
          // Определяем новую тему
          final newTheme = currentTheme == CustomThemeMode.light
              ? CustomThemeMode.dark
              : CustomThemeMode.light;
          // Сохраняем новую тему
          final saveResult = await repository.saveThemeMode(newTheme);
          return saveResult.fold(
                (failure) => Left(failure),
                (_) => Right(newTheme),
          );
        },
      );
    } catch (e) {
      return Left(UnknownFailure(
          message: 'Произошла ошибка при переключении темы: $e'
      ));
    }
  }
}
// domain-usecases-speech-listen_to_speech.dart
import 'dart:async';
import 'package:dartz/dartz.dart';
import '../../../core/errors/failure.dart';
import '../../repositories/speech_repository.dart';
class ListenToSpeech {
  final SpeechRepository repository;
  ListenToSpeech(this.repository);
  Future<Either<Failure, Stream<String>>> call() async {
    try {
      // Проверяем доступность распознавания
      final availableResult = await repository.isAvailable();
      final available = availableResult.fold(
            (failure) => false,
            (available) => available,
      );
      if (!available) {
        // Инициализируем, если недоступно
        final initResult = await repository.initialize();
        final initialized = initResult.fold(
              (failure) => false,
              (initialized) => initialized,
        );
        if (!initialized) {
          return const Left(UnknownFailure(
              message: 'Не удалось инициализировать распознавание речи'
          ));
        }
      }
      // Останавливаем текущее прослушивание, если оно активно
      final listeningResult = await repository.isListening();
      final isListening = listeningResult.fold(
            (failure) => false,
            (isListening) => isListening,
      );
      if (isListening) {
        await repository.stopListening();
      }
      // Запускаем прослушивание
      return repository.startListening();
    } catch (e) {
      return Left(UnknownFailure(
          message: 'Произошла ошибка при запуске распознавания речи: $e'
      ));
    }
  }
}
// domain-usecases-translation-translate_text.dart
import 'package:dartz/dartz.dart';
import '../../../core/errors/failure.dart';
import '../../repositories/translator_repository.dart';
class TranslateText {
  final TranslatorRepository repository;
  TranslateText(this.repository);
  Future<Either<Failure, String>> call(String text, String targetLanguage) async {
    // Проверка на пустой текст
    if (text.trim().isEmpty) {
      return Right(text);
    }
    // Если целевой язык не указан, используем английский
    final language = targetLanguage.isNotEmpty ? targetLanguage : 'en';
    // Делегируем работу репозиторию
    return repository.translate(text, language);
  }
}
// presentation-bloc-chat-chat_bloc.dart
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../config/dependency_injection.dart';
import '../../../core/utils/translation_utils.dart';
import '../../../domain/repositories/chat_repository.dart';
import '../../../domain/usecases/chat/export_chat.dart';
import '../../../domain/usecases/chat/send_message.dart';
import '../../../domain/usecases/chat/get_message_history.dart';
import '../../../domain/usecases/chat/save_chat.dart';
import '../../../domain/usecases/chat/delete_chat.dart';
import '../../../domain/entities/message.dart';
import '../../../core/logger/app_logger.dart';
import '../../../core/services/translation_service.dart';
import '../language/language_bloc.dart';
part 'chat_event.dart';
part 'chat_state.dart';
// ChatBloc
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepository;
  final SendMessage sendMessage;
  final GetMessageHistory getMessageHistory;
  final SaveChat saveChat;
  final DeleteChat deleteChat;
  List<Message> _messages = [];
  String? _currentChatName;
  List<Message> get messages => _messages;
  String? get currentChatName => _currentChatName;
  ChatBloc({
    required this.chatRepository,
    required this.sendMessage,
    required this.getMessageHistory,
    required this.saveChat,
    required this.deleteChat,
  }) : super(ChatInitial()) {
    on<InitializeChatEvent>(_onInitializeChat);
    on<SendMessageEvent>(_onSendMessage);
    on<ClearChatEvent>(_onClearChat);
    on<ExportChatEvent>(_onExportChat);
    on<LoadChatEvent>(_onLoadChat);
    on<GetSavedChatsEvent>(_onGetSavedChats);
    on<SaveChatEvent>(_onSaveChat);
    on<DeleteChatEvent>(_onDeleteChat);
    on<RenameChatEvent>(_onRenameChat);
    on<AddReactionEvent>(_onAddReaction);
    on<RemoveReactionEvent>(_onRemoveReaction);
    on<TranslateMessageEvent>(_onTranslateMessage);
    on<CopyMessageEvent>(_onCopyMessage);
    on<DeleteMessageEvent>(_onDeleteMessage);
    on<RestoreStateEvent>(_onRestoreState);
  }
  Future<void> _onInitializeChat(
      InitializeChatEvent event,
      Emitter<ChatState> emit,
      ) async {
    emit(ChatLoading());
    try {
      // Загружаем сообщения (если чата нет, получим пустой список)
      final messagesResult = await getMessageHistory('current');
      messagesResult.fold(
            (failure) {
          AppLogger.error('Ошибка при инициализации чата', failure);
          _messages = [];
          emit(ChatError(message: Tr.get(TranslationKeys.errorNum2)));
          emit(ChatLoaded(messages: _messages, currentChatName: null));
        },
            (messages) {
          _messages = messages;
          _currentChatName = messages.isEmpty ? null : 'current';
          emit(ChatLoaded(messages: _messages, currentChatName: _currentChatName));
        },
      );
    } catch (e) {
      AppLogger.error('Необработанная ошибка при инициализации чата', e);
      emit(ChatError(message: Tr.get(TranslationKeys.errorNum3)));
      emit(const ChatLoaded(messages: [], currentChatName: null));
    }
  }
  String getCurrentLanguage() {
    final languageState = getIt<LanguageBloc>().state;
    return languageState is LanguageLoaded ? languageState.languageCode : 'en';
  }
  Future<void> _onSendMessage(
      SendMessageEvent event,
      Emitter<ChatState> emit,
      ) async {
    try {
      // Проверяем, не является ли сообщение пустым
      if (event.messageContent.trim().isEmpty) {
        AppLogger.warning('Попытка отправить пустое сообщение');
        return;
      }
      // Если имя чата не указано, создаем новый чат
      if (_currentChatName == null) {
        // Получаем уникальное имя для нового чата
        final newChatNameResult = await chatRepository.getUniqueDefaultChatName();
        newChatNameResult.fold(
                (failure) {
              emit(ChatError(message: 'Не удалось создать новый чат: ${failure.message}'));
              return; // Выходим из метода, если не удалось получить имя
            },
                (newChatName) {
              _currentChatName = newChatName; // Устанавливаем имя нового чата
              AppLogger.debug('Создан новый чат с именем: $_currentChatName');
            }
        );
      }
      // Теперь можно отправить сообщение
      emit(ChatProcessing(
        messages: _messages,
        currentChatName: _currentChatName,
      ));
      // Логируем информацию о сообщении, которое отправляется
      print('Отправка сообщения: "${event.messageContent}" в чат: $_currentChatName');
      // Отправка сообщения через use case
      final result = await sendMessage(event.messageContent, _currentChatName!, isMultiline: event.isMultiline);
      // Обработка результата отправки сообщения
      result.fold(
            (failure) {
          AppLogger.error('Ошибка при отправке сообщения: ${failure.message}');
          emit(ChatError(message: failure.message));
          emit(ChatLoaded(
            messages: _messages,
            currentChatName: _currentChatName,
          ));
        },
            (messages) {
          _messages = messages; // Обновляем список сообщений
          AppLogger.debug('Сообщение успешно отправлено. Текущее количество сообщений: ${_messages.length}');
          emit(ChatLoaded(
            messages: _messages,
            currentChatName: _currentChatName,
          ));
        },
      );
    } catch (e) {
      AppLogger.error('Необработанная ошибка при отправке сообщения', e);
      emit(ChatError(message: Tr.get(TranslationKeys.errorNum4)));
      emit(ChatLoaded(
        messages: _messages,
        currentChatName: _currentChatName,
      ));
    }
  }
  Future<void> _onClearChat(ClearChatEvent event,
      Emitter<ChatState> emit,) async {
    _messages = [];
    _currentChatName = null;
    emit(ChatLoaded(messages: _messages, currentChatName: _currentChatName));
  }
  Future<void> _onExportChat(
      ExportChatEvent event,
      Emitter<ChatState> emit,
      ) async {
    try {
      if (_messages.isEmpty || _currentChatName == null) {
        emit(ChatError(message: Tr.get(TranslationKeys.errorNum5)));
        emit(ChatLoaded(messages: _messages, currentChatName: _currentChatName));
        return;
      }
      // Используем UseCase для экспорта
      final exportChat = getIt<ExportChat>();
      // Получаем переводы для текущего языка
      final languageState = getIt<LanguageBloc>().state;
      final languageCode = languageState is LanguageLoaded ? languageState.languageCode : 'en';
      final translations = getIt<TranslationService>().getTranslations(languageCode);
      final result = await exportChat(_currentChatName!, translations, languageCode);
      result.fold(
            (failure) {
          AppLogger.error('Ошибка при экспорте чата: ${failure.message}');
          emit(ChatError(message: failure.message));
          emit(ChatLoaded(messages: _messages, currentChatName: _currentChatName));
        },
            (filePath) {
          AppLogger.debug('Чат успешно экспортирован в: $filePath');
          emit(ChatLoaded(messages: _messages, currentChatName: _currentChatName));
          // Показываем уведомление об успешном экспорте
          // Это нужно делать через другой механизм, например, через StreamController
        },
      );
    } catch (e) {
      AppLogger.error('Необработанная ошибка при экспорте чата', e);
      emit(ChatError(message: Tr.get(TranslationKeys.errorNum6)));
      emit(ChatLoaded(messages: _messages, currentChatName: _currentChatName));
    }
  }
  Future<void> _onLoadChat(
      LoadChatEvent event,
      Emitter<ChatState> emit,
      ) async {
    try {
      emit(ChatLoading());
      AppLogger.debug('Начинаем загрузку чата: ${event.chatName}');
      // Сохраняем текущие сообщения и имя чата на случай ошибки
      final previousMessages = _messages;
      final previousChatName = _currentChatName;
      AppLogger.debug('Текущие сообщения: ${previousMessages.length}, текущее имя чата: $previousChatName');
      final result = await getMessageHistory(event.chatName);
      result.fold(
            (failure) {
          AppLogger.error('Ошибка при загрузке чата: ${failure.message}');
          emit(ChatError(message: failure.message));
          // Восстанавливаем предыдущее состояние
          emit(ChatLoaded(
            messages: previousMessages,
            currentChatName: previousChatName,
          ));
        },
            (messages) {
          if (messages.isEmpty) {
            AppLogger.warning('Загружен пустой чат: ${event.chatName}');
            _messages = [];
            _currentChatName = event.chatName; // Устанавливаем имя загруженного чата
            emit(ChatLoaded(
              messages: _messages,
              currentChatName: _currentChatName,
            ));
          } else {
            _messages = messages;
            _currentChatName = event.chatName; // Устанавливаем имя загруженного чата
            AppLogger.debug('Чат успешно загружен: $_currentChatName с ${_messages.length} сообщениями');
            emit(ChatLoaded(
              messages: _messages,
              currentChatName: _currentChatName,
            ));
          }
        },
      );
    } catch (e) {
      AppLogger.error('Необработанная ошибка при загрузке чата', e);
      emit(ChatError(message: Tr.get(TranslationKeys.errorNum2)));
      emit(ChatLoaded(
        messages: _messages,
        currentChatName: _currentChatName,
      ));
    }
  }
  Future<void> _onRestoreState(
      RestoreStateEvent event,
      Emitter<ChatState> emit,
      ) async {
    _messages = event.messages;
    _currentChatName = event.currentChatName;
    emit(ChatLoaded(
      messages: _messages,
      currentChatName: _currentChatName,
    ));
  }
  Future<void> _onGetSavedChats(
      GetSavedChatsEvent event,
      Emitter<ChatState> emit,
      ) async {
    try {
      // Сохраняем текущее состояние
      ChatState? previousState;
      if (state is ChatLoaded) {
        previousState = state;
      }
      // Показываем индикатор загрузки только в диалоге
      emit(ChatLoading());
      final result = await deleteChat.repository.getSavedChats();
      result.fold(
            (failure) {
          AppLogger.error('Ошибка при получении списка чатов: ${failure.message}');
          emit(ChatError(message: failure.message));
          // Восстанавливаем предыдущее состояние, если оно было
          if (previousState != null) {
            emit(previousState);
          }
        },
            (chats) {
          emit(ChatSavedChatsLoaded(savedChats: chats));
          // Восстанавливаем предыдущее состояние после загрузки списка
          if (previousState != null) {
            emit(previousState);
          }
        },
      );
    } catch (e) {
      AppLogger.error('Необработанная ошибка при получении списка чатов', e);
      emit(ChatError(message: Tr.get(TranslationKeys.errorNum1)));
      // Восстанавливаем предыдущее состояние, если оно было
      if (state is ChatLoaded) {
        emit(state);
      }
    }
  }
  Future<void> _onSaveChat(SaveChatEvent event,
      Emitter<ChatState> emit,) async {
    try {
      emit(ChatSaving());
      if (_messages.isEmpty) {
        emit(ChatError(message: Tr.get(TranslationKeys.recordVoice)));
        emit(ChatLoaded(
          messages: _messages,
          currentChatName: _currentChatName,
        ));
        return;
      }
      final result = await saveChat(event.chatName, _messages);
      result.fold(
              (failure) {
            AppLogger.error('Ошибка при сохранении чата: ${failure.message}');
            emit(ChatError(message: failure.message));
            emit(ChatLoaded(
              messages: _messages,
              currentChatName: _currentChatName,
            ));
          },
      (success) {
        _currentChatName = event.chatName;
        AppLogger.debug('Чат успешно сохранен: ${event.chatName}');
        emit(ChatSaved());
        emit(ChatLoaded(
          messages: _messages,
          currentChatName: _currentChatName,
        ));
      },      );
    } catch (e) {
      AppLogger.error('Необработанная ошибка при сохранении чата', e);
      emit(ChatError(message: Tr.get(TranslationKeys.errorNum7)));
      emit(ChatLoaded(
        messages: _messages,
        currentChatName: _currentChatName,
      ));
    }
  }
  Future<void> _onDeleteChat(
      DeleteChatEvent event,
      Emitter<ChatState> emit,
      ) async {
    try {
      emit(ChatLoading());
      final result = await deleteChat(event.chatName);
      result.fold(
            (failure) {
          AppLogger.error('Ошибка при удалении чата: ${failure.message}');
          emit(ChatError(message: failure.message));
          // Возвращаем предыдущее состояние
          emit(ChatLoaded(
            messages: _messages,
            currentChatName: _currentChatName,
          ));
        },
            (success) {
          // Если удалили текущий чат, очищаем его
          if (_currentChatName == event.chatName) {
            _messages = [];
            _currentChatName = null;
          }
          AppLogger.debug('Чат успешно удален: ${event.chatName}');
          // Просто сообщаем об успешном удалении
          emit(ChatDeleted());
          // И сразу возвращаемся к нормальному состоянию
          emit(ChatLoaded(
            messages: _messages,
            currentChatName: _currentChatName,
          ));
        },
      );
    } catch (e) {
      AppLogger.error('Необработанная ошибка при удалении чата', e);
      emit(ChatError(message: Tr.get(TranslationKeys.errorNum8)));
      emit(ChatLoaded(
        messages: _messages,
        currentChatName: _currentChatName,
      ));
    }
  }
  Future<void> _onRenameChat(
      RenameChatEvent event,
      Emitter<ChatState> emit,
      ) async {
    try {
      if (_currentChatName == null) {
        emit(ChatError(message: Tr.get(TranslationKeys.errorNum9)));
        return;
      }
      emit(ChatSaving());
      final result = await deleteChat.repository.renameChat(
        _currentChatName!,
        event.newChatName,
      );
      result.fold(
            (failure) {
          AppLogger.error('Ошибка при переименовании чата: ${failure.message}');
          emit(ChatError(message: failure.message));
          emit(ChatLoaded(
            messages: _messages,
            currentChatName: _currentChatName,
          ));
        },
            (success) {
          _currentChatName = event.newChatName;
          AppLogger.debug('Чат успешно переименован: ${event.newChatName}');
          emit(ChatRenamed());
          emit(ChatLoaded(
            messages: _messages,
            currentChatName: _currentChatName,
          ));
        },
      );
    } catch (e) {
      AppLogger.error('Необработанная ошибка при переименовании чата', e);
      emit(ChatError(message: Tr.get(TranslationKeys.errorNum10)));
      emit(ChatLoaded(
        messages: _messages,
        currentChatName: _currentChatName,
      ));
    }
  }
  Future<void> _onAddReaction(
      AddReactionEvent event,
      Emitter<ChatState> emit,
      ) async {
    try {
      final index = _messages.indexOf(event.message);
      if (index == -1) return;
      // Создаем копию сообщения с реакцией
      final updatedMessage = event.message.copyWith(reaction: event.reaction);
      // Обновляем список сообщений без создания нового списка для каждого элемента
      final newMessages = List<Message>.from(_messages);
      newMessages[index] = updatedMessage;
      _messages = newMessages;
      emit(ChatLoaded(
        messages: _messages,
        currentChatName: _currentChatName,
      ));
    } catch (e) {
      AppLogger.error('Ошибка при добавлении реакции', e);
      emit(ChatError(message: Tr.get(TranslationKeys.errorNum11)));
      emit(ChatLoaded(
        messages: _messages,
        currentChatName: _currentChatName,
      ));
    }
  }
  Future<void> _onRemoveReaction(
      RemoveReactionEvent event,
      Emitter<ChatState> emit,
      ) async {
    try {
      final index = _messages.indexOf(event.message);
      if (index == -1) return;
      // Создаем копию сообщения без реакции
      final updatedMessage = event.message.copyWith(reaction: null);
      // Обновляем список сообщений
      _messages = List.from(_messages)
        ..removeAt(index)
        ..insert(index, updatedMessage);
      emit(ChatLoaded(
        messages: _messages,
        currentChatName: _currentChatName,
      ));
    } catch (e) {
      AppLogger.error('Ошибка при удалении реакции', e);
      emit(ChatError(message: Tr.get(TranslationKeys.errorNum11)));
      emit(ChatLoaded(
        messages: _messages,
        currentChatName: _currentChatName,
      ));
    }
  }
  Future<void> _onCopyMessage(
      CopyMessageEvent event,
      Emitter<ChatState> emit,
      ) async {
    try {
      await Clipboard.setData(ClipboardData(text: event.message.text));
      emit(ChatMessageCopied());
      emit(ChatLoaded(
        messages: _messages,
        currentChatName: _currentChatName,
      ));
    } catch (e) {
      AppLogger.error('Ошибка при копировании сообщения', e);
      emit(ChatError(message: Tr.get(TranslationKeys.errorNum12)));
      emit(ChatLoaded(
        messages: _messages,
        currentChatName: _currentChatName,
      ));
    }
  }
  Future<void> _onDeleteMessage(
      DeleteMessageEvent event,
      Emitter<ChatState> emit,
      ) async {
    try {
      _messages = List.from(_messages)
        ..remove(event.message);
      emit(ChatLoaded(
        messages: _messages,
        currentChatName: _currentChatName,
      ));
    } catch (e) {
      AppLogger.error('Ошибка при удалении сообщения', e);
      emit(ChatError(message: Tr.get(TranslationKeys.errorNum13)));
      emit(ChatLoaded(
        messages: _messages,
        currentChatName: _currentChatName,
      ));
    }
  }
  Future<void> _onTranslateMessage(
      TranslateMessageEvent event,
      Emitter<ChatState> emit,
      ) async {
    try {
      final index = _messages.indexOf(event.message);
      if (index == -1) return;
      // Обновляем сообщение, показывая индикатор перевода
      final translatingMessage = event.message.copyWith(isTranslating: true);
      _messages = List.from(_messages)
        ..removeAt(index)
        ..insert(index, translatingMessage);
      emit(ChatLoaded(
        messages: _messages,
        currentChatName: _currentChatName,
      ));
      // Используем UseCase для перевода
      final result = await sendMessage.translatorRepository.translate(
          event.message.text,
          event.targetLanguage ?? 'en'
      );
      if (emit.isDone) return; // Проверяем, не завершился ли уже emit
      result.fold(
            (failure) {
          // В случае ошибки возвращаем сообщение без перевода
          final originalMessage = event.message.copyWith(isTranslating: false);
          _messages = List.from(_messages)
            ..removeAt(index)
            ..insert(index, originalMessage);
          emit(ChatError(message: failure.message));
          emit(ChatLoaded(
            messages: _messages,
            currentChatName: _currentChatName,
          ));
        },
            (translatedText) {
          // Обновляем сообщение с переведенным текстом
          final translatedMessage = event.message.copyWith(
            text: translatedText,
            isTranslating: false,
          );
          _messages = List.from(_messages)
            ..removeAt(index)
            ..insert(index, translatedMessage);
          emit(ChatLoaded(
            messages: _messages,
            currentChatName: _currentChatName,
          ));
        },
      );
    } catch (e) {
      if (emit.isDone) return; // Проверяем, не завершился ли уже emit
      AppLogger.error('Ошибка при переводе сообщения', e);
      emit(ChatError(message: Tr.get(TranslationKeys.errorNum14)));
      emit(ChatLoaded(
        messages: _messages,
        currentChatName: _currentChatName,
      ));
    }
  }
}
// presentation-bloc-chat-chat_event.dart
part of 'chat_bloc.dart';
abstract class ChatEvent extends Equatable {
  const ChatEvent();
  @override
  List<Object?> get props => [];
}
class InitializeChatEvent extends ChatEvent {}
class SendMessageEvent extends ChatEvent {
  final String messageContent;
  final bool isMultiline; // Добавляем параметр isMultiline
  const SendMessageEvent(this.messageContent, {this.isMultiline = false});
  @override
  List<Object?> get props => [messageContent, isMultiline];
}
class ClearChatEvent extends ChatEvent {}
class ExportChatEvent extends ChatEvent {}
class LoadChatEvent extends ChatEvent {
  final String chatName;
  const LoadChatEvent(this.chatName);
  @override
  List<Object?> get props => [chatName];
}
class GetSavedChatsEvent extends ChatEvent {}
class SaveChatEvent extends ChatEvent {
  final String chatName;
  const SaveChatEvent(this.chatName);
  @override
  List<Object?> get props => [chatName];
}
class DeleteChatEvent extends ChatEvent {
  final String chatName;
  const DeleteChatEvent(this.chatName);
  @override
  List<Object?> get props => [chatName];
}
class RenameChatEvent extends ChatEvent {
  final String newChatName;
  const RenameChatEvent(this.newChatName);
  @override
  List<Object?> get props => [newChatName];
}
class AddReactionEvent extends ChatEvent {
  final Message message;
  final String reaction;
  const AddReactionEvent(this.message, this.reaction);
  @override
  List<Object?> get props => [message, reaction];
}
class RemoveReactionEvent extends ChatEvent {
  final Message message;
  const RemoveReactionEvent(this.message);
  @override
  List<Object?> get props => [message];
}
class TranslateMessageEvent extends ChatEvent {
  final Message message;
  final String? targetLanguage; // Добавляем параметр целевого языка
  const TranslateMessageEvent(this.message, {this.targetLanguage});
  @override
  List<Object?> get props => [message, targetLanguage];
}
class CopyMessageEvent extends ChatEvent {
  final Message message;
  const CopyMessageEvent(this.message);
  @override
  List<Object?> get props => [message];
}
class DeleteMessageEvent extends ChatEvent {
  final Message message;
  const DeleteMessageEvent(this.message);
  @override
  List<Object?> get props => [message];
}
class RestoreStateEvent extends ChatEvent {
  final List<Message> messages;
  final String? currentChatName;
  const RestoreStateEvent({
    required this.messages,
    this.currentChatName,
  });
  @override
  List<Object?> get props => [messages, currentChatName];
}

// presentation-bloc-chat-chat_state.dart
part of 'chat_bloc.dart';
abstract class ChatState extends Equatable {
  const ChatState();
  @override
  List<Object?> get props => [];
}
class ChatInitial extends ChatState {}
class ChatLoading extends ChatState {}
class ChatProcessing extends ChatState {
  final List<Message> messages;
  final String? currentChatName;
  final double progress; // Поле для отслеживания прогресса
  const ChatProcessing({
    required this.messages,
    this.currentChatName,
    this.progress = 0.0, // Установите значение по умолчанию
  });
  @override
  List<Object?> get props => [messages, currentChatName, progress];
}
class ChatLoaded extends ChatState {
  final List<Message> messages;
  final String? currentChatName;
  const ChatLoaded({
    required this.messages,
    this.currentChatName,
  });
  @override
  List<Object?> get props => [messages, currentChatName];
}
class ChatSaving extends ChatState {}
class ChatSaved extends ChatState {}
class ChatDeleted extends ChatState {}
class ChatRenamed extends ChatState {}
class ChatMessageCopied extends ChatState {}
class ChatSavedChatsLoaded extends ChatState {
  final Map<String, DateTime> savedChats;
  const ChatSavedChatsLoaded({
    required this.savedChats,
  });
  @override
  List<Object> get props => [savedChats];
}
class ChatError extends ChatState {
  final String message;
  const ChatError({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

// presentation-bloc-language-language_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../config/app_config.dart';
import '../../../core/services/translation_service.dart';
import '../../../core/utils/translation_utils.dart';
import '../../../domain/usecases/settings/change_language.dart';
import '../../../domain/usecases/settings/get_settings.dart';
import '../../../core/logger/app_logger.dart';
part 'language_event.dart';
part 'language_state.dart';
class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  final ChangeLanguage changeLanguage;
  final GetSettings getSettings;
  final AppConfig appConfig = AppConfig(); // Используем Singleton
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
      // Обновляем конфигурацию
      appConfig.updateLanguage(languageCode);
      emit(LanguageLoaded(languageCode: languageCode));
      AppLogger.debug('Язык инициализирован: $languageCode');
    } catch (e) {
      AppLogger.error('Ошибка при инициализации языка', e);
      emit(LanguageError(Tr.get(TranslationKeys.errorNum15)));
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
            // Обновляем конфигурацию
            appConfig.updateLanguage(event.languageCode);
            AppLogger.debug('Язык успешно изменен на: ${event.languageCode}');
            emit(LanguageLoaded(languageCode: event.languageCode));
          }
      );
    } catch (e) {
      AppLogger.error('Необработанная ошибка при изменении языка', e);
      emit(LanguageError(Tr.get(TranslationKeys.errorNum16)));
      if (state is LanguageLoaded) {
        emit(state); // Возвращаем предыдущее состояние
      } else {
        emit(const LanguageLoaded(languageCode: 'en'));
      }
    }
  }
}
// presentation-bloc-language-language_event.dart
part of 'language_bloc.dart';
abstract class LanguageEvent extends Equatable {
  const LanguageEvent();
  @override
  List<Object> get props => [];
}
class InitializeLanguage extends LanguageEvent {}
class ChangeLanguageEvent extends LanguageEvent {
  final String languageCode;
  const ChangeLanguageEvent(this.languageCode);
  @override
  List<Object> get props => [languageCode];
}
// presentation-bloc-language-language_state.dart
part of 'language_bloc.dart';
abstract class LanguageState extends Equatable {
  const LanguageState();
  @override
  List<Object> get props => [];
}
class LanguageInitial extends LanguageState {}
class LanguageLoading extends LanguageState {}
class LanguageLoaded extends LanguageState {
  final String languageCode;
  const LanguageLoaded({required this.languageCode});
  @override
  List<Object> get props => [languageCode];
}
class LanguageError extends LanguageState {
  final String message;
  const LanguageError(this.message);
  @override
  List<Object> get props => [message];
}
// presentation-bloc-theme-theme_bloc.dart
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
// presentation-bloc-theme-theme_event.dart
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
// presentation-bloc-theme-theme_state.dart
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
// presentation-screens-chat_list_screen.dart
//chat_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/utils/translation_utils.dart';
import '../bloc/chat/chat_bloc.dart';
import '../bloc/language/language_bloc.dart';
import '../widgets/dialogs/confirmation_dialog.dart';
import '../../core/services/translation_service.dart';
import '../../core/utils/datetime_utils.dart';
class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);
  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}
class _ChatListScreenState extends State<ChatListScreen> {
  bool _isFirstLoad = true;
  @override
  void initState() {
    super.initState();
    // Загружаем чаты только если это первая загрузка
    if (_isFirstLoad) {
      _isFirstLoad = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<ChatBloc>().add(GetSavedChatsEvent());
      });
    }
  }
  void _showDeleteConfirmation(BuildContext context, String chatName) {
    // Получаем текущий язык
    final languageState = context.read<LanguageBloc>().state;
    final languageCode = languageState is LanguageLoaded
        ? languageState.languageCode
        : 'en';
    showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        titleKey: TranslationKeys.deleteChatConfirmationTitle,
        messageKey: TranslationKeys.deleteChatConfirmationMessage,
        message: '${Tr.get(TranslationKeys.deleteChatConfirmationMessage, languageCode)} "$chatName"?',
        confirmKey: TranslationKeys.delete,
        isDanger: true,
        onConfirm: () {
          context.read<ChatBloc>().add(DeleteChatEvent(chatName));
        },
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Tr.get('savedChats')),
      ),
      body: BlocConsumer<ChatBloc, ChatState>(
        listenWhen: (previous, current) =>
        current is ChatDeleted || current is ChatError,
        listener: (context, state) {
          if (state is ChatDeleted) {
            // После удаления чата запрашиваем обновление списка
            context.read<ChatBloc>().add(GetSavedChatsEvent());
          } else if (state is ChatError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        buildWhen: (previous, current) =>
        current is ChatSavedChatsLoaded ||
            current is ChatLoading ||
            current is ChatError,
        builder: (context, state) {
          if (state is ChatLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ChatError) {
            return Center(child: Text(state.message));
          } else if (state is ChatSavedChatsLoaded) {
            final savedChats = state.savedChats;
            if (savedChats.isEmpty) {
              return Center(
                child: Text(Tr.get(TranslationKeys.noSavedChats)),
              );
            }
            // Сортируем чаты по дате изменения (от новых к старым)
            final sortedEntries = savedChats.entries.toList()
              ..sort((a, b) => b.value.compareTo(a.value));
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: sortedEntries.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final chatName = sortedEntries[index].key;
                final lastModified = sortedEntries[index].value;
                // Форматируем дату в более читаемый вид
                final formattedDate = DateTimeUtils.formatDateTime(lastModified);
                return ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: Theme.of(context).dividerColor,
                      width: 1,
                    ),
                  ),
                  leading: const CircleAvatar(
                    child: Icon(Icons.chat),
                  ),
                  title: Text(
                    chatName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${Tr.get(TranslationKeys.lastModified)}: $formattedDate',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _showDeleteConfirmation(context, chatName),
                  ),
                  onTap: () {
                    context.read<ChatBloc>().add(LoadChatEvent(chatName));
                    Navigator.pop(context);
                  },
                );
              },
            );
          }
          return Center(child: Text(Tr.get(TranslationKeys.errorNum19)));
        },
      ),
    );
  }
}
// presentation-screens-chat_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/services/translation_service.dart';
import '../../core/utils/translation_utils.dart';
import '../bloc/chat/chat_bloc.dart';
import '../bloc/language/language_bloc.dart';
import '../widgets/chat_input.dart';
import '../widgets/message_bubble.dart';
import '../widgets/chat_app_bar.dart';
import '../widgets/message_actions_menu.dart';
import '../../domain/entities/message.dart';
class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}
class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    // Прокрутка вниз при входе в приложение
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ChatAppBar(),
      body: BlocConsumer<ChatBloc, ChatState>(
        listenWhen: (previous, current) =>
        current is ChatLoaded && previous is ChatProcessing,
        listener: (context, state) {
          if (state is ChatLoaded) {
            // Прокрутка вниз при загрузке новых сообщений
            WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
          }
        },
        buildWhen: (previous, current) =>
        current is ChatLoaded ||
            current is ChatProcessing ||
            current is ChatLoading,
        builder: (context, state) {
          if (state is ChatLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          final messages = state is ChatLoaded
              ? state.messages
              : state is ChatProcessing
              ? state.messages
              : [];
          final isProcessing = state is ChatProcessing;
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(12),
                  itemCount: messages.length,
                  itemBuilder: (context, i) {
                    final msg = messages[i];
                    return MessageBubble(
                      message: msg,
                      onTap: () => _showMessageActions(context, msg),
                    );
                  },
                ),
              ),
              if (isProcessing)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      LinearProgressIndicator(value: state.progress), // Индикатор прогресса
                      SizedBox(height: 8),
                      Text('${(state.progress * 100).toStringAsFixed(0)}% обработано'), // Текст с процентом
                    ],
                  ),
                ),
              const ChatInput(), // Ваш виджет ввода сообщений
            ],
          );
        },
      ),
    );
  }
  void _showMessageActions(BuildContext context, Message message) {
    final chatBloc = context.read<ChatBloc>();
    showModalBottomSheet(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: chatBloc,
        child: MessageActionsMenu(message: message),
      ),
    );
  }
}
// presentation-screens-settings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../app.dart';
import '../../config/app_config.dart';
import '../../core/utils/translation_utils.dart';
import '../bloc/theme/theme_bloc.dart';
import '../bloc/language/language_bloc.dart';
import '../widgets/settings_section.dart';
import '../../core/services/translation_service.dart';
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    // Получаем текущий язык
    final languageState = context.watch<LanguageBloc>().state;
    final languageCode = languageState is LanguageLoaded
        ? languageState.languageCode
        : 'en';
    // Получаем текущую тему
    final themeState = context.watch<ThemeBloc>().state;
    final customThemeMode = themeState is ThemeLoaded
        ? themeState.customThemeMode
        : CustomThemeMode.system;
    final TranslationServiceImpl translationService = TranslationServiceImpl();
    return Scaffold(
      appBar: AppBar(
        title: Text(Tr.get(TranslationKeys.settings)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Секция настроек темы
          SettingsSection(
            title: Tr.get(TranslationKeys.appearance),
            children: [
              ListTile(
                title: Text(Tr.get(TranslationKeys.theme)),
                trailing: DropdownButton<CustomThemeMode>(
                  value: customThemeMode,
                  items: [
                    DropdownMenuItem(
                      value: CustomThemeMode.system,
                      child: Text(Tr.get(TranslationKeys.systemTheme)),
                    ),
                    DropdownMenuItem(
                      value: CustomThemeMode.light,
                      child: Text(Tr.get(TranslationKeys.lightTheme)),
                    ),
                    DropdownMenuItem(
                      value: CustomThemeMode.blue,
                      child: Text(Tr.get(TranslationKeys.blueTheme)),
                    ),
                    DropdownMenuItem(
                      value: CustomThemeMode.green,
                      child: Text(Tr.get(TranslationKeys.greenTheme)),
                    ),
                    DropdownMenuItem(
                      value: CustomThemeMode.orange,
                      child: Text(Tr.get(TranslationKeys.orangeTheme)),
                    ),
                    DropdownMenuItem(
                      value: CustomThemeMode.royalPurple,
                      child: Text(Tr.get(TranslationKeys.royalPurpleTheme)),
                    ),
                    DropdownMenuItem(
                      value: CustomThemeMode.amethystDark,
                      child: Text(Tr.get(TranslationKeys.amethystDarkTheme)),
                    ),
                    DropdownMenuItem(
                      value: CustomThemeMode.coffee,
                      child: Text(Tr.get(TranslationKeys.coffeeTheme)),
                    ),
                    DropdownMenuItem(
                      value: CustomThemeMode.dark,
                      child: Text(Tr.get(TranslationKeys.darkTheme)),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      context.read<ThemeBloc>().add(SetSpecificTheme(value));
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Секция настроек языка
          SettingsSection(
            title: Tr.get(TranslationKeys.language),
            children: [
              ...translationService.supportedLanguageCodes.map((code) {
                return RadioListTile<String>(
                  title: Text(translationService.getLanguageName(code)),
                  value: code,
                  groupValue: languageCode,
                  onChanged: (value) {
                    if (value != null) {
                      context.read<LanguageBloc>().add(ChangeLanguageEvent(value));
                    }
                  },
                );
              }),],
          ),
          const SizedBox(height: 16),
          // Секция информации о приложении
          SettingsSection(
            title: Tr.get(TranslationKeys.about),
            children: [
              ListTile(
                title: Text(Tr.get(TranslationKeys.version)),
                trailing: Text(AppConfig().appVersionName),
                onTap: () => _showAboutDialog(context, languageCode),
              ),
            ],
          ),
        ],
      ),
    );
  }
  void _showAboutDialog(BuildContext context, String languageCode) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(Tr.get(TranslationKeys.about)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(Tr.get(TranslationKeys.appTitle)),
              const SizedBox(height: 8),
              Text('${Tr.get(TranslationKeys.version)}: ${AppConfig().appVersionName}'),
              const SizedBox(height: 16),
              Text(Tr.get(TranslationKeys.applicationDescription),
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 8),
              Text(Tr.get(TranslationKeys.rightsReserved),
                style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(Tr.get(TranslationKeys.cancel)),
            ),
          ],
        );
      },
    );
  }
}
// presentation-widgets-chat_app_bar.dart
//chat_app_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../app.dart';
import '../../config/routes.dart';
import '../../core/utils/translation_utils.dart';
import '../bloc/chat/chat_bloc.dart';
import '../bloc/theme/theme_bloc.dart';
import '../bloc/language/language_bloc.dart';
import 'dialogs/save_chat_dialog.dart';
import 'dialogs/new_chat_dialog.dart';
import 'dialogs/load_chat_dialog.dart';
import '../../core/constants/app_constants.dart';
import '../../core/services/translation_service.dart';
class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatAppBar({super.key});
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context) {
    // Используем BlocBuilder для реагирования на изменения состояния чата
    return BlocBuilder<ChatBloc, ChatState>(
      buildWhen: (previous, current) =>
      (previous is ChatLoaded && current is ChatLoaded &&
          previous.currentChatName != current.currentChatName) ||
          (previous is! ChatLoaded && current is ChatLoaded) ||
          (previous is ChatLoaded && current is! ChatLoaded),
      builder: (context, chatState) {
        // Получаем текущее имя чата из состояния
        final String? currentChatName = chatState is ChatLoaded
            ? chatState.currentChatName
            : null;
        // Получаем текущую тему
        final themeState = context.watch<ThemeBloc>().state;
        final isDarkMode = themeState is ThemeLoaded
            ? themeState.customThemeMode == CustomThemeMode.dark
            : false;
        return AppBar(
          title: Row(
            children: [
              Icon(
                AppConstants.botIcon,
                color: Theme.of(context).appBarTheme.titleTextStyle?.color,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  currentChatName ?? Tr.get(TranslationKeys.appTitle),
                  style: const TextStyle(fontSize: 18),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.download),
              onPressed: () => context.read<ChatBloc>().add(ExportChatEvent()),
              tooltip: Tr.get(TranslationKeys.exportChat),
            ),
            IconButton(
              icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
              onPressed: () => context.read<ThemeBloc>().add(ToggleThemeEvent()),
            ),
            PopupMenuButton<String>(
              itemBuilder: (BuildContext context) => [
                PopupMenuItem<String>(
                  value: 'new_chat',
                  child: Text(Tr.get(TranslationKeys.newChat)),
                  onTap: () => Future.delayed(
                    Duration.zero,
                        () => showDialog(
                      context: context,
                      builder: (dialogContext) => BlocProvider.value(
                        value: context.read<ChatBloc>(),
                        child: const NewChatDialog(),
                      ),
                    ),
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'save_chat',
                  child: Text(Tr.get(TranslationKeys.saveChat)),
                  onTap: () => Future.delayed(
                    Duration.zero,
                        () => showDialog(
                      context: context,
                      builder: (dialogContext) => BlocProvider.value(
                        value: context.read<ChatBloc>(),
                        child: SaveChatDialog(
                          initialName: currentChatName, // Передаем текущее имя чата
                        ),
                      ),
                    ),
                  ),
                ),
                // Показываем пункт "Переименовать" только если есть текущий чат
                if (currentChatName != null)
                  PopupMenuItem<String>(
                    value: 'rename_chat',
                    child: Text(Tr.get(TranslationKeys.renameChat)),
                    onTap: () => Future.delayed(
                      Duration.zero,
                          () => showDialog(
                        context: context,
                        builder: (dialogContext) => BlocProvider.value(
                          value: context.read<ChatBloc>(),
                          child: SaveChatDialog(
                            initialName: currentChatName,
                            isRename: true,
                          ),
                        ),
                      ),
                    ),
                  ),
                PopupMenuItem<String>(
                  value: 'load_chat',
                  child: Text(Tr.get(TranslationKeys.uploadChat)),
                  onTap: () => Future.delayed(
                    Duration.zero,
                        () => showDialog(
                      context: context,
                      builder: (dialogContext) => BlocProvider.value(
                        value: context.read<ChatBloc>(),
                        child: const LoadChatDialog(),
                      ),
                    ),
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'settings',
                  child: Text(Tr.get(TranslationKeys.settings)),
                  onTap: () => Navigator.pushNamed(context, AppRoutes.settings),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
// presentation-widgets-chat_input.dart
//chat_input.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../config/dependency_injection.dart';
import '../../core/logger/app_logger.dart';
import '../../core/utils/translation_utils.dart';
import '../../domain/repositories/speech_repository.dart';
import '../../domain/usecases/speech/listen_to_speech.dart';
import '../bloc/chat/chat_bloc.dart';
import '../../core/services/translation_service.dart';
import '../../core/constants/app_constants.dart';
import '../bloc/language/language_bloc.dart';
class ChatInput extends StatefulWidget {
  const ChatInput({super.key});
  @override
  State<ChatInput> createState() => _ChatInputState();
}
class _ChatInputState extends State<ChatInput> {
  final TextEditingController _controller = TextEditingController();
  bool _isListening = false;
  bool _isMultiline = false; // Переменная для отслеживания режима
  StreamSubscription<String>? _subscription;
  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      context.read<ChatBloc>().add(SendMessageEvent(text, isMultiline: _isMultiline)); // Передаем режим
      _controller.clear();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          // Слайдер для переключения между однострочной и многострочной классификацией
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Многострочная классификация"), // Текст для однострочного режима
              Switch(
                value: _isMultiline,
                onChanged: (value) {
                  setState(() {
                    _isMultiline = value; // Переключаем режим
                  });
                },
              ),// Текст для многострочного режима
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  constraints: const BoxConstraints(
                    maxHeight: 200, // Ограничиваем максимальную высоту
                  ),
                  child: SingleChildScrollView(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: Tr.get(TranslationKeys.enterText),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send, color: Theme.of(context).primaryColor),
                onPressed: _sendMessage,
              ),
            ],
          ),
        ],
      ),
    );
  }
  void _startListening() async {
    setState(() {
      _isListening = true;
    });
    try {
      // Используем UseCase для прослушивания речи
      final speechUseCase = getIt<ListenToSpeech>();
      final result = await speechUseCase();
      result.fold(
            (failure) {
          setState(() {
            _isListening = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(failure.message))
          );
        },
            (stream) {
          // Подписываемся на события
          final subscription = stream.listen(
                (text) {
              AppLogger.debug('Получен текст из потока: $text');
              if (text.isNotEmpty && mounted) {
                setState(() {
                  _controller.text = text;
                });
              }
            },
            onError: (e) {
              AppLogger.error('Ошибка распознавания речи', e);
              if (mounted) {
                setState(() {
                  _isListening = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${Tr.get(TranslationKeys.errorNum20)} $e'))
                );
              }
            },
            onDone: () {
              AppLogger.debug('Поток распознавания речи завершен');
              if (mounted) {
                setState(() {
                  _isListening = false;
                });
                // Важно! Проверяем, есть ли текст для отправки
                if (_controller.text.isNotEmpty) {
                  AppLogger.debug('Отправка распознанного текста: ${_controller.text}');
                  // Можно автоматически отправить сообщение
                  // _sendMessage();
                }
              }
            },
          );
          // Сохраняем подписку
          _subscription = subscription;
        },
      );
    } catch (e) {
      AppLogger.error('Ошибка при запуске распознавания речи', e);
      if (mounted) {
        setState(() {
          _isListening = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${Tr.get(TranslationKeys.errorNum21)} $e'))
        );
      }
    }
  }
  void _stopListening() async {
    if (!_isListening) return;
    setState(() {
      _isListening = false;
    });
    try {
      final speechRepository = getIt<SpeechRepository>();
      await speechRepository.stopListening();
      // Отменяем подписку
      _subscription?.cancel();
      _subscription = null;
    } catch (e) {
      AppLogger.error('Ошибка при остановке распознавания речи', e);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${Tr.get(TranslationKeys.errorNum22)} $e'))
      );
    }
  }
  @override
  void dispose() {
    _controller.dispose();
    _subscription?.cancel();
    super.dispose();
  }
}
// presentation-widgets-confidence_indicator.dart
//confidence_indicator.dart
import 'package:flutter/material.dart';
import 'dart:math' as math;
class ConfidenceIndicator extends StatelessWidget {
  final List<List<double>> classificationResult;
  final List<List<double>> emotionResult;
  const ConfidenceIndicator({
    Key? key,
    required this.classificationResult,
    required this.emotionResult,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // Получаем уровни уверенности для каждой классификации
    final List<double> classificationConfidenceLevels = classificationResult
        .map((result) => _getConfidence(result))
        .toList();
    final List<double> emotionConfidenceLevels = emotionResult
        .map((emotion) {
      return emotion[0]; // Предполагаем, что это первый элемент
    })
        .toList();
      return Column(
      children: [
        // Линия уверенности в классификации
        SizedBox(
          width: 200,
          height: 5,
          child: Row(
            children: classificationConfidenceLevels.map((confidence) =>
                Expanded(
                    child: Container(
                      color: _getConfidenceColor(confidence),
                    )
                )
            ).toList(),
          ),
        ),
        SizedBox(height: 4), // Отступ между линиями
        // Линия уверенности в эмоциональной окраске
        SizedBox(
          width: 200,
          height: 5,
          child: Row(
            children: emotionConfidenceLevels.map((confidence) =>
                Expanded(
                    child: Container(
                      color: _getConfidenceColor(confidence),
                    )
                )
            ).toList(),
          ),
        ),
      ],
    );
  }
  /// Получает уровень уверенности из результата
  double _getConfidence(List<double> scores) {
    if (scores.isEmpty) {
      return 0.0; // или любое другое значение по умолчанию
    }
    final normalizedScores = _softmax(scores);
    return normalizedScores.reduce((a, b) => a > b ? a : b);
  }
  /// Применяет softmax к результатам для нормализации
  List<double> _softmax(List<double> scores) {
    final maxScore = scores.reduce(math.max);
    final expScores = scores.map((score) => math.exp(score - maxScore)).toList();
    final sumExpScores = expScores.reduce((a, b) => a + b);
    return expScores.map((score) => score / sumExpScores).toList();
  }
  /// Возвращает цвет в зависимости от уровня уверенности
  Color _getConfidenceColor(double confidence) {
    if (confidence > 0.8) {
      return Colors.green;
    } else if (confidence > 0.5) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }
}
// presentation-widgets-message_actions_menu.dart
//message_action.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/utils/translation_utils.dart';
import '../bloc/chat/chat_bloc.dart';
import 'dialogs/emoji_picker_dialog.dart';
import '../../domain/entities/message.dart';
import '../../core/services/translation_service.dart';
class MessageActionsMenu extends StatelessWidget {
  final Message message;
  const MessageActionsMenu({
    super.key,
    required this.message,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: const Icon(Icons.emoji_emotions),
          title: Text(Tr.get(TranslationKeys.reaction)),
          onTap: () {
            Navigator.pop(context);
            _showEmojiPicker(context, message);
          },
        ),
        ListTile(
          leading: const Icon(Icons.translate),
          title: Text(Tr.get(TranslationKeys.translate)),
          onTap: () {
            context.read<ChatBloc>().add(TranslateMessageEvent(message));
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.copy),
          title: Text(Tr.get(TranslationKeys.copy)),
          onTap: () {
            context.read<ChatBloc>().add(CopyMessageEvent(message));
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(Tr.get(TranslationKeys.copied))),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.delete),
          title: Text(Tr.get(TranslationKeys.delete)),
          onTap: () {
            context.read<ChatBloc>().add(DeleteMessageEvent(message));
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
  void _showEmojiPicker(BuildContext context, Message message) {
    final chatBloc = context.read<ChatBloc>();
    showModalBottomSheet(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: chatBloc,
        child: EmojiPickerDialog(message: message),
      ),
    );
  }
}
// presentation-widgets-message_bubble.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/message.dart';
import '../bloc/chat/chat_bloc.dart';
import 'confidence_indicator.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/datetime_utils.dart';
class MessageBubble extends StatelessWidget {
  final Message message;
  final Function() onTap;
  final TextStyle? textStyle;
  const MessageBubble({
    Key? key,
    required this.message,
    required this.onTap,
    this.textStyle,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Align(
        alignment: message.isUser  ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!message.isUser )
                Center(
                  child: Icon(
                    AppConstants.botIcon,
                    color: isDarkMode ? Colors.white : Colors.indigo,
                  ),
                ),
              if (message.isTranslating)
                const Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                ),
              Text(
                message.text,
                style: textStyle ?? TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                DateTimeUtils.formatMessageTime(message.timestamp),
                style: TextStyle(
                  fontSize: 10,
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                ),
              ),
              if (message.reaction != null)
                GestureDetector(
                  onTap: () {
                    context.read<ChatBloc>().add(RemoveReactionEvent(message));
                  },
                  child: Text(
                    message.reaction!,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              if (!message.isUser  && message.classificationResult != null && message.classificationEmotionsResult != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ConfidenceIndicator(
                    classificationResult: message.classificationResult!,
                    emotionResult: message.classificationEmotionsResult!,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
// presentation-widgets-settings_section.dart
//settings_section.dart
import 'package:flutter/material.dart';
class SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const SettingsSection({
    super.key,
    required this.title,
    required this.children,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        Card(
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }
}
// presentation-widgets-speech_button.dart
//speech_button.dart
import 'package:flutter/material.dart';
import '../../core/services/translation_service.dart';
import '../../core/utils/translation_utils.dart';
class SpeechButton extends StatefulWidget {
  final bool isListening;
  final bool isDisabled;
  final Function()? onListenStart;
  final Function()? onListenStop;
  const SpeechButton({
    super.key,
    this.isListening = false,
    this.isDisabled = false,
    this.onListenStart,
    this.onListenStop,
  });
  @override
  State<SpeechButton> createState() => _SpeechButtonState();
}
class _SpeechButtonState extends State<SpeechButton> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    if (widget.isListening) {
      _animationController.repeat(reverse: true);
    }
  }
  @override
  @override
  void didUpdateWidget(SpeechButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isListening != oldWidget.isListening) {
      if (widget.isListening) {
        _animationController.repeat(reverse: true);
      } else {
        _animationController.stop();
        _animationController.reset();
      }
    }
  }
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.isListening ? _animation.value : 1.0,
          child: IconButton(
            icon: Icon(
              widget.isListening ? Icons.mic : Icons.mic_none,
              color: widget.isDisabled
                  ? Theme.of(context).disabledColor
                  : Theme.of(context).primaryColor,
            ),
            onPressed: widget.isDisabled
                ? null
                : () {
              if (widget.isListening) {
                if (widget.onListenStop != null) {
                  widget.onListenStop!();
                }
              } else {
                if (widget.onListenStart != null) {
                  widget.onListenStart!();
                }
              }
            },
            tooltip: widget.isListening ? Tr.get(TranslationKeys.stopRecording) : Tr.get(TranslationKeys.recordVoice),
          ),
        );
      },
    );
  }
}
// presentation-widgets-theme_toggle_button.dart
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
// presentation-widgets-dialogs-confirmation_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/translation_utils.dart';
import '../../bloc/language/language_bloc.dart';
import '../../../core/services/translation_service.dart';
class ConfirmationDialog extends StatelessWidget {
  final String titleKey;
  final String messageKey;
  final String? message;
  final String confirmKey;
  final String cancelKey;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final bool isDanger;
  const ConfirmationDialog({
    Key? key,
    required this.titleKey,
    required this.messageKey,
    this.message,
    this.confirmKey = TranslationKeys.save,
    this.cancelKey = TranslationKeys.cancel,
    this.onConfirm,
    this.onCancel,
    this.isDanger = false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(Tr.get(titleKey)),
      content: Text(
          message ?? Tr.get(messageKey)
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
            if (onCancel != null) {
              onCancel!();
            }
          },
          child: Text(Tr.get(cancelKey)),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
            if (onConfirm != null) {
              onConfirm!();
            }
          },
          style: isDanger ? ButtonStyle(
            foregroundColor: WidgetStateProperty.all(Colors.red),
          ) : null,
          child: Text(Tr.get(confirmKey)),
        ),
      ],
    );
  }
}
// presentation-widgets-dialogs-emoji_picker_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/chat/chat_bloc.dart';
import '../../../domain/entities/message.dart';
import '../../../core/constants/app_constants.dart';
class EmojiPickerDialog extends StatelessWidget {
  final Message message;
  const EmojiPickerDialog({
    Key? key,
    required this.message,
  }) : super(key: key);
  @override
  @override
  Widget build(BuildContext context) {
    final chatBloc = context.read<ChatBloc>();
    return GridView.count(
      crossAxisCount: 8,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      padding: const EdgeInsets.all(4),
      shrinkWrap: true,
      children: List.generate(AppConstants.defaultReactions.length, (index) {
        final emoji = AppConstants.defaultReactions[index];
        return GestureDetector(
          onTap: () {
            chatBloc.add(AddReactionEvent(message, emoji));
            Navigator.pop(context);
          },
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.grey[200]
                  : Colors.grey[800],
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              emoji,
              style: const TextStyle(fontSize: 24),
            ),
          ),
        );
      }),
    );
  }
}
// presentation-widgets-dialogs-language_selection_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/translation_utils.dart';
import '../../bloc/language/language_bloc.dart';
import '../../../core/services/translation_service.dart';
class LanguageSelectionDialog extends StatefulWidget {
  final String currentLanguageCode;
  final Map<String, String> availableLanguages;
  final Function(String)? onLanguageSelected;
  const LanguageSelectionDialog({
    Key? key,
    required this.currentLanguageCode,
    this.availableLanguages = const {'en': 'English', 'ru': 'Русский'},
    this.onLanguageSelected,
  }) : super(key: key);
  @override
  State<LanguageSelectionDialog> createState() => _LanguageSelectionDialogState();
}
class _LanguageSelectionDialogState extends State<LanguageSelectionDialog> {
  late String _selectedLanguageCode;
  @override
  void initState() {
    super.initState();
    _selectedLanguageCode = widget.currentLanguageCode;
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(Tr.get(TranslationKeys.changeLanguage, _selectedLanguageCode)),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.availableLanguages.entries.map((language) {
            return RadioListTile<String>(
              title: Text(language.value),
              value: language.key,
              groupValue: _selectedLanguageCode,
              onChanged: (value) {
                setState(() {
                  _selectedLanguageCode = value!;
                });
              },
            );
          }).toList(),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(Tr.get(TranslationKeys.cancel, _selectedLanguageCode)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: Text(Tr.get(TranslationKeys.save, _selectedLanguageCode)),
          onPressed: () {
            if (widget.onLanguageSelected != null) {
              widget.onLanguageSelected!(_selectedLanguageCode);
            } else {
              // Используем BLoC если не указан callback
              context.read<LanguageBloc>().add(ChangeLanguageEvent(_selectedLanguageCode));
            }
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
// presentation-widgets-dialogs-load_chat_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/translation_utils.dart';
import '../../../domain/entities/message.dart';
import '../../bloc/chat/chat_bloc.dart';
import '../../bloc/language/language_bloc.dart';
import '../../../core/services/translation_service.dart';
import '../../../core/utils/datetime_utils.dart';
class LoadChatDialog extends StatefulWidget {
  const LoadChatDialog({Key? key}) : super(key: key);
  @override
  State<LoadChatDialog> createState() => _LoadChatDialogState();
}
class _LoadChatDialogState extends State<LoadChatDialog> {
  // Сохраняем текущее состояние при инициализации
  List<Message>? _savedMessages;
  String? _savedChatName;
  bool _isStateRestored = false;
  @override
  void initState() {
    super.initState();
    // Сохраняем текущее состояние чата
    final chatBloc = context.read<ChatBloc>();
    if (chatBloc.state is ChatLoaded) {
      final loadedState = chatBloc.state as ChatLoaded;
      _savedMessages = List<Message>.from(loadedState.messages);
      _savedChatName = loadedState.currentChatName;
    }
    // Запрашиваем список сохраненных чатов при открытии диалога
    context.read<ChatBloc>().add(GetSavedChatsEvent());
  }
  @override
  void dispose() {
    // Восстанавливаем состояние при закрытии диалога, если не было выбрано другого чата
    if (!_isStateRestored && _savedMessages != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<ChatBloc>().add(RestoreStateEvent(
            messages: _savedMessages!,
            currentChatName: _savedChatName,
          ));
        }
      });
    }
    super.dispose();
  }
  Future<void> _showDeleteConfirmation(BuildContext context, String chatName) async {
    final chatBloc = context.read<ChatBloc>();
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(Tr.get(TranslationKeys.deleteChatConfirmationTitle)),
          content: SingleChildScrollView(
            child: Text(
                '${Tr.get(TranslationKeys.deleteChatConfirmationMessage)} "$chatName"?'
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(Tr.get(TranslationKeys.cancel)),
              onPressed: () => Navigator.of(dialogContext).pop(false),
            ),
            TextButton(
              child: Text(Tr.get(TranslationKeys.delete)),
              onPressed: () => Navigator.of(dialogContext).pop(true),
            ),
          ],
        );
      },
    );
    if (confirmed == true) {
      // Удаляем чат и обновляем список
      chatBloc.add(DeleteChatEvent(chatName));
    }
  }
  @override
  Widget build(BuildContext context) {
    // Получаем текущую тему
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Theme(
      data: isDarkMode
          ? ThemeData.dark().copyWith(
        colorScheme: const ColorScheme.dark(
          primary: Colors.blue,
          onPrimary: Colors.white,
          secondary: Colors.blueAccent,
        ), dialogTheme: DialogThemeData(backgroundColor: Colors.grey[850]),
      )
          : ThemeData.light().copyWith(
        colorScheme: const ColorScheme.light(
          primary: Colors.blue,
          onPrimary: Colors.white,
          secondary: Colors.blueAccent,
        ), dialogTheme: DialogThemeData(backgroundColor: Colors.white),
      ),
      child: BlocBuilder<ChatBloc, ChatState>(
        buildWhen: (previous, current) =>
        current is ChatSavedChatsLoaded ||
            current is ChatLoading ||
            current is ChatError,
        builder: (context, state) {
          bool isLoading = true;
          Map<String, DateTime> savedChats = {};
          if (state is ChatSavedChatsLoaded) {
            savedChats = state.savedChats;
            isLoading = false;
          } else if (state is ChatError) {
            // Показываем ошибку загрузки
            return AlertDialog(
              title: Text(Tr.get(TranslationKeys.uploadChat)),
              content: Text(state.message),
              actions: [
                TextButton(
                  child: Text(Tr.get(TranslationKeys.cancel)),
                  onPressed: () {
                    Navigator.pop(context);
                    // Восстанавливаем предыдущее состояние
                    if (_savedMessages != null) {
                      _isStateRestored = true;
                      context.read<ChatBloc>().add(RestoreStateEvent(
                        messages: _savedMessages!,
                        currentChatName: _savedChatName,
                      ));
                    }
                  },
                ),
              ],
            );
          }
          return AlertDialog(
            title: Text(Tr.get(TranslationKeys.uploadChat)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            content: SizedBox(
              width: double.maxFinite,
              height: 300,
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _buildChatList(context, savedChats),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(Tr.get(TranslationKeys.cancel)),
                onPressed: () {
                  Navigator.pop(context);
                  // Восстанавливаем предыдущее состояние
                  if (_savedMessages != null) {
                    _isStateRestored = true;
                    context.read<ChatBloc>().add(RestoreStateEvent(
                      messages: _savedMessages!,
                      currentChatName: _savedChatName,
                    ));
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
  Widget _buildChatList(
      BuildContext context,
      Map<String, DateTime> savedChats) {
    if (savedChats.isEmpty) {
      return Center(
        child: Text(Tr.get(TranslationKeys.noSavedChats)),
      );
    }
    // Сортируем чаты по дате изменения (от новых к старым)
    final sortedEntries = savedChats.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: sortedEntries.length,
      itemBuilder: (context, index) {
        final chatName = sortedEntries[index].key;
        final lastModified = sortedEntries[index].value;
        // Форматируем дату в более читаемый вид
        final formattedDate = DateTimeUtils.formatDateTime(lastModified);
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
          dense: true,
          title: Text(
            chatName,
            style: const TextStyle(fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            '${Tr.get(TranslationKeys.lastModified)}: $formattedDate',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
            ),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            iconSize: 20,
            onPressed: () {
              Navigator.pop(context);
              _showDeleteConfirmation(context, chatName);
            },
          ),
          onTap: () {
            final chatBloc = context.read<ChatBloc>();
            // Отмечаем, что мы выбрали новый чат, так что не нужно восстанавливать старое состояние
            _isStateRestored = true;
            chatBloc.add(LoadChatEvent(chatName));
            Navigator.pop(context);
          },
        );
      },
    );
  }
}
// presentation-widgets-dialogs-new_chat_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/translation_utils.dart';
import '../../bloc/chat/chat_bloc.dart';
import '../../bloc/language/language_bloc.dart';
import 'save_chat_dialog.dart';
import '../../../core/services/translation_service.dart';
class NewChatDialog extends StatelessWidget {
  const NewChatDialog({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final chatBloc = context.read<ChatBloc>();
    // Проверяем, есть ли сообщения в текущем чате
    final hasMessages = chatBloc.messages.isNotEmpty;
    // Если нет сообщений, просто создаем новый чат без диалога
    if (!hasMessages) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pop();
        chatBloc.add(ClearChatEvent());
      });
      return const SizedBox.shrink();
    }
    // Если есть сообщения, спрашиваем о сохранении текущего чата
    return AlertDialog(
      title: Text(Tr.get(TranslationKeys.newChatConfirmation)),
      content: Text(Tr.get(TranslationKeys.saveCurrentChatQuestion)),
      actions: [
        TextButton(
          child: Text(Tr.get(TranslationKeys.dontSave)),
          onPressed: () {
            Navigator.pop(context);
            chatBloc.add(ClearChatEvent());
          },
        ),
        TextButton(
          child: Text(Tr.get(TranslationKeys.cancel)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: Text(Tr.get(TranslationKeys.saveAndCreate)),
          onPressed: () {
            Navigator.pop(context);
            // Показываем диалог сохранения чата с колбэком создания нового чата
            showDialog(
              context: context,
              builder: (context) => SaveChatDialog(
                onSaveComplete: () {
                  // Даем время для завершения сохранения перед созданием нового чата
                  Future.delayed(const Duration(milliseconds: 500), () {
                    chatBloc.add(ClearChatEvent());
                  });
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
// presentation-widgets-dialogs-save_chat_dialog.dart
//save_chat_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/translation_utils.dart';
import '../../bloc/chat/chat_bloc.dart';
import '../../bloc/language/language_bloc.dart';
import '../../../core/utils/file_utils.dart';
import '../../../core/services/translation_service.dart';
import '../../../core/logger/app_logger.dart';
class SaveChatDialog extends StatefulWidget {
  final String? initialName;
  final bool isRename;
  final VoidCallback? onSaveComplete;
  const SaveChatDialog({
    Key? key,
    this.initialName,
    this.isRename = false,
    this.onSaveComplete,
  }) : super(key: key);
  @override
  State<SaveChatDialog> createState() => _SaveChatDialogState();
}
class _SaveChatDialogState extends State<SaveChatDialog> {
  late TextEditingController _chatNameController;
  String? _errorMessage;
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _chatNameController = TextEditingController(text: widget.initialName ?? '');
    if (widget.initialName == null && !widget.isRename) {
      _loadDefaultChatName();
    }
  }
  @override
  void dispose() {
    _chatNameController.dispose();
    super.dispose();
  }
  Future<void> _loadDefaultChatName() async {
    setState(() => _isLoading = true);
    try {
      final chatBloc = context.read<ChatBloc>();
      // Запрашиваем уникальное имя чата из репозитория
      final result = await chatBloc.getMessageHistory.repository.getUniqueDefaultChatName();
      result.fold(
              (failure) {
            AppLogger.error('Ошибка при получении имени чата: ${failure.message}');
            setState(() {
              _errorMessage = failure.message;
              _isLoading = false;
            });
          },
              (chatName) {
            setState(() {
              _chatNameController.text = chatName;
              _isLoading = false;
            });
          }
      );
    } catch (e) {
      AppLogger.error('Неизвестная ошибка при получении имени чата', e);
      setState(() {
        _errorMessage = Tr.get(TranslationKeys.defaultChatNameError);
        _isLoading = false;
      });
    }
  }
  Future<void> _saveChat() async {
    final name = _chatNameController.text.trim();
    if (name.isEmpty) {
      setState(() {
        _errorMessage = Tr.get(TranslationKeys.chatNameEmptyError);
      });
      return;
    }
    // Проверяем корректность имени файла
    if (!FileUtils.isValidFileName(name)) {
      setState(() {
        _errorMessage = Tr.get(TranslationKeys.invalidFileName);
      });
      return;
    }
    // Проверяем существование чата с таким именем (если это не переименование)
    if (!widget.isRename && widget.initialName != name) {
      final chatBloc = context.read<ChatBloc>();
      final result = await chatBloc.saveChat.repository.chatExists(name);
      final exists = result.fold(
            (failure) => false,
            (exists) => exists,
      );
      if (exists) {
        // Показываем диалог подтверждения перезаписи
        final confirm = await _showOverwriteConfirmation(name);
        if (!confirm) return;
      }
    }
    // Сохраняем или переименовываем чат
    if (widget.isRename) {
      context.read<ChatBloc>().add(RenameChatEvent(name));
    } else {
      context.read<ChatBloc>().add(SaveChatEvent(name));
    }
    Navigator.of(context).pop();
    // Показываем уведомление об успешном сохранении
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                widget.isRename
                    ? '${Tr.get(TranslationKeys.chatRenamed)}: $name'
                    : '${Tr.get(TranslationKeys.chatSaved)}: $name'
            )
        )
    );
    // Вызываем callback после сохранения, если он предоставлен
    if (widget.onSaveComplete != null) {
      widget.onSaveComplete!();
    }
  }
  Future<bool> _showOverwriteConfirmation(String chatName) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(Tr.get(TranslationKeys.overwriteChat)),
          content: Text(
              '${Tr.get(TranslationKeys.chatExistsConfirmation)} "$chatName"?'
          ),
          actions: [
            TextButton(
              child: Text(Tr.get(TranslationKeys.cancel)),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text(Tr.get(TranslationKeys.overwrite)),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
          widget.isRename
              ? Tr.get(TranslationKeys.renameChat)
              : Tr.get(TranslationKeys.saveChat)
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.isRename)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(Tr.get(TranslationKeys.renameChatInfo)),
              ),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else
              TextField(
                controller: _chatNameController,
                decoration: InputDecoration(
                  labelText: Tr.get(TranslationKeys.chatNameLabel),
                  hintText: Tr.get(TranslationKeys.chatNameHint),
                  border: const OutlineInputBorder(),
                  errorText: _errorMessage,
                ),
                autofocus: true,
                onChanged: (_) {
                  if (_errorMessage != null) {
                    setState(() => _errorMessage = null);
                  }
                },
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: Text(Tr.get(TranslationKeys.cancel)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          onPressed: _saveChat,
          child: Text(
              widget.isRename
                  ? Tr.get(TranslationKeys.rename)
                  : Tr.get(TranslationKeys.save)
          ),
        ),
      ],
    );
  }
}
// test-core-utils-datetime_utils_test.dart
// test/core/utils/datetime_utils_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:coursework/core/utils/datetime_utils.dart';
void main() {
  group('DateTimeUtils', () {
    test('formatDateTime should format date and time correctly', () {
      // Arrange
      final dateTime = DateTime(2023, 5, 15, 10, 30, 45);
      // Act
      final result = DateTimeUtils.formatDateTime(dateTime);
      // Assert
      expect(result, '15.05.2023 10:30');
    });
    test('formatDate should format only date correctly', () {
      // Arrange
      final dateTime = DateTime(2023, 5, 15, 10, 30, 45);
      // Act
      final result = DateTimeUtils.formatDate(dateTime);
      // Assert
      expect(result, '15.05.2023');
    });
    test('formatTime should format only time correctly', () {
      // Arrange
      final dateTime = DateTime(2023, 5, 15, 10, 30, 45);
      // Act
      final result = DateTimeUtils.formatTime(dateTime);
      // Assert
      expect(result, '10:30');
    });
    test('formatMessageTime should return "Сегодня" for today\'s date', () {
      // Arrange
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day, 14, 30);
      // Act
      final result = DateTimeUtils.formatMessageTime(today);
      // Assert
      expect(result.startsWith('Сегодня'), true);
    });
    test('formatMessageTime should return "Вчера" for yesterday\'s date', () {
      // Arrange
      final now = DateTime.now();
      final yesterday = DateTime(now.year, now.month, now.day - 1, 14, 30);
      // Act
      final result = DateTimeUtils.formatMessageTime(yesterday);
      // Assert
      expect(result.startsWith('Вчера'), true);
    });
    test('getRelativeTime should return "только что" for recent times', () {
      // Arrange
      final now = DateTime.now();
      final recent = now.subtract(const Duration(seconds: 30));
      // Act
      final result = DateTimeUtils.getRelativeTime(recent);
      // Assert
      expect(result, 'только что');
    });
  });
}
// test-data-datasources-chat_local_datasource_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'dart:convert';
import 'dart:io';
import 'package:coursework/data/datasources/local/chat_local_datasource.dart';
import 'package:coursework/data/models/message_model.dart';
import 'package:coursework/core/logger/app_logger.dart';
class MockLogger extends Mock implements AppLogger {}
class MockFile extends Mock implements File {}
class MockDirectory extends Mock implements Directory {}
void main() {
  late ChatLocalDataSourceImpl dataSource;
  late MockLogger mockLogger;
  setUp(() {
    mockLogger = MockLogger();
    dataSource = ChatLocalDataSourceImpl(logger: mockLogger);
  });
  group('ChatLocalDataSource', () {
    final testMessages = [
      MessageModel(
        text: 'Hello',
        isUser: true,
        timestamp: DateTime(2023, 1, 1, 12, 0),
      ),
      MessageModel(
        text: 'Hi there!',
        isUser: false,
        timestamp: DateTime(2023, 1, 1, 12, 1),
      ),
    ];
    final testMessagesJson = json.encode(
        testMessages.map((msg) => msg.toJson()).toList()
    );
    test('saveChat должен сохранять сообщения в файл', () async {
      // Здесь тестирование saveChat с мокированием файловой системы
    });
    test('loadChat должен загружать сообщения из файла', () async {
      // Здесь тестирование loadChat с мокированием файловой системы
    });
    test('deleteChat должен удалять файл чата', () async {
      // Здесь тестирование deleteChat с мокированием файловой системы
    });
    test('chatExists должен проверять существование файла', () async {
      // Здесь тестирование chatExists с мокированием файловой системы
    });
    test('getSavedChats должен возвращать список сохраненных чатов', () async {
      // Здесь тестирование getSavedChats с мокированием файловой системы
    });
  });
}
// test-data-models-message_model_test.dart
// test/data/models/message_model_test.dart
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:coursework/data/models/message_model.dart';
import 'package:coursework/domain/entities/message.dart';
void main() {
  final tMessageModel = MessageModel(
    text: 'Test message',
    isUser: true,
    timestamp: DateTime(2023, 5, 15, 10, 30),
    reaction: '😊',
    classificationResult: [
      [0.1, 0.2, 0.7]
    ],
    classificationEmotionsResult: [
      [0.8]
    ],
    id: '123',
  );
  final tMessageJson = {
    'text': 'Test message',
    'isUser': true,
    'timestamp': '2023-05-15T10:30:00.000',
    'reaction': '😊',
    'classificationResult': [
      [0.1, 0.2, 0.7]
    ],
    'classificationEmotionsResult': [
      [0.8]
    ],
    'isTranslating': false,
    'id': '123',
  };
  group('MessageModel', () {
    test('should be a subclass of Message entity', () {
      // Assert
      expect(tMessageModel, isA<Message>());
    });
    test('fromJson should return a valid model', () {
      // Act
      final result = MessageModel.fromJson(tMessageJson);
      // Assert
      expect(result, tMessageModel);
    });
    test('toJson should return a JSON map containing proper data', () {
      // Act
      final result = tMessageModel.toJson();
      // Assert
      expect(result, tMessageJson);
    });
    test('copyWith should return a new instance with updated values', () {
      // Act
      final result = tMessageModel.copyWith(
        text: 'Updated message',
        isUser: false,
      );
      // Assert
      expect(result.text, 'Updated message');
      expect(result.isUser, false);
      expect(result.timestamp, tMessageModel.timestamp);
      expect(result.reaction, tMessageModel.reaction);
    });
    test('fromJsonList should parse a list of messages correctly', () {
      // Arrange
      final jsonList = json.encode([tMessageJson]);
      // Act
      final result = MessageModel.fromJsonList(jsonList);
      // Assert
      expect(result.length, 1);
      expect(result.first, tMessageModel);
    });
    test('toJsonList should convert a list of messages to JSON correctly', () {
      // Arrange
      final messageList = [tMessageModel];
      // Act
      final result = MessageModel.toJsonList(messageList);
      final decoded = json.decode(result);
      // Assert
      expect(decoded.length, 1);
      expect(decoded.first, tMessageJson);
    });
  });
}
