import 'package:dartz/dartz.dart';
import '../../core/errors/failure.dart';

abstract class TranslatorRepository {
  /// Переводит текст на указанный язык
  Future<Either<Failure, String>> translate(String text, String targetLanguage);

  /// Определяет язык текста
  Future<Either<Failure, String>> detectLanguage(String text);
}