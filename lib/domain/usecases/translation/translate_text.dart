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