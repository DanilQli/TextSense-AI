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
        AppLogger.error('Ошибка при очистке ресурсов: $e');
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