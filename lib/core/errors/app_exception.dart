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