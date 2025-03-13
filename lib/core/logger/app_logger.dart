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

  void logDebug(String message, [dynamic error, StackTrace? stackTrace]);
  void logInfo(String message, [dynamic error, StackTrace? stackTrace]);
  void logWarning(String message, [dynamic error, StackTrace? stackTrace]);
  void logError(String message, [dynamic error, StackTrace? stackTrace]);
  void logFatal(String message, [dynamic error, StackTrace? stackTrace]);
}

class AppLoggerImpl implements AppLogger {
  // Инициализируем логгер с базовой конфигурацией, чтобы избежать ошибок до полной инициализации
  Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      printTime: true,
    ),
  );

  @override
  Future<void> initialize() async {
    final logsDirectory = await _getLogsDirectory();

    _logger = Logger(
      filter: ProductionFilter(),
      printer: PrettyPrinter(
          methodCount: 2,
          errorMethodCount: 8,
          lineLength: 120,
          colors: true,
          printEmojis: true,
          printTime: true
      ),
      output: MultiOutput([
        ConsoleOutput(),
        FileOutput(file: File('$logsDirectory/app.log'))
      ]),
    );

    logInfo('Система логирования инициализирована');
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
}