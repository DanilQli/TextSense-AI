//app.dart
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