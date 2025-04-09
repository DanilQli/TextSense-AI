/// Базовый класс для всех исключений приложения
class AppException implements Exception {
  final String message;
  final dynamic originalError;

  AppException(this.message, [this.originalError]);

  @override
  String toString() {
    return '$runtimeType: $message${originalError != null ? ' (Ошибка: $originalError)' : ''}';
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
  CacheException(super.message, [super.originalError]);
}

/// Ошибка форматирования данных
class FormatException extends AppException {
  FormatException(super.message, [super.originalError]);
}

/// Ошибка операций с файлами
class FileException extends AppException {
  FileException(super.message, [super.originalError]);
}

/// Ошибка безопасности
class SecurityException extends AppException {
  SecurityException(super.message, [super.originalError]);
}

/// Ошибка бизнес-логики
class BusinessException extends AppException {
  BusinessException(super.message, [super.originalError]);
}

/// Ошибка доступа к функциональности
class PermissionException extends AppException {
  PermissionException(super.message, [super.originalError]);
}

/// Необработанная ошибка
class UnknownException extends AppException {
  UnknownException(super.message, [super.originalError]);

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