//main.dart
import 'package:flutter/material.dart';
import 'config/dependency_injection.dart';
import 'app.dart';
import 'core/logger/app_logger.dart';
import 'core/services/translation_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализация логирования
  await AppLogger.init();

  try {
    // Инициализация зависимостей
    await initDependencies();

    // Загрузка переводов и других ресурсов
    await preloadResources();

    runApp(const ChatApp());
  } catch (e, stackTrace) {
    AppLogger.fatal('Ошибка при запуске приложения', e, stackTrace);
    runApp(const ErrorApp()); // Запасное приложение с информацией об ошибке
  }
}

Future<void> preloadResources() async {
  // Загрузка переводов, шрифтов и других ресурсов
  await getIt<TranslationService>().loadTranslations();
}

class ErrorApp extends StatelessWidget {
  const ErrorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Ошибка при запуске приложения. Пожалуйста, перезапустите'),
        ),
      ),
    );
  }
}