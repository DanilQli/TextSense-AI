import 'package:dartz/dartz.dart';
import '../../core/errors/failure.dart';

abstract class SpeechRepository {
  /// Инициализирует систему распознавания речи
  Future<Either<Failure, bool>> initialize();

  /// Начинает прослушивание
  Future<Either<Failure, Stream<String>>> startListening();

  /// Останавливает прослушивание
  Future<Either<Failure, bool>> stopListening();

  /// Проверяет, доступно ли распознавание речи
  Future<Either<Failure, bool>> isAvailable();

  /// Проверяет, слушает ли система в данный момент
  Future<Either<Failure, bool>> isListening();

  /// Возвращает список доступных локалей для распознавания
  Future<Either<Failure, List<String>>> getAvailableLocales();
}