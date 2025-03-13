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
        return Left(ValidationFailure(
            message: 'Код языка не может быть пустым'
        ));
      }

      // Проверяем, доступен ли такой язык
      final supportedLanguages = ['en', 'ru']; // В реальном приложении это может быть динамический список

      if (!supportedLanguages.contains(languageCode)) {
        return Left(ValidationFailure(
            message: 'Язык не поддерживается: $languageCode'
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