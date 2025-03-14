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