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