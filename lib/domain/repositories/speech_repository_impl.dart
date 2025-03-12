import 'package:dartz/dartz.dart';
import '../../data/datasources/device/speech_datasource.dart';
import '../../domain/repositories/speech_repository.dart';
import '../../core/errors/failure.dart';
import '../../core/errors/app_exception.dart';
import '../../core/logger/app_logger.dart';

class SpeechRepositoryImpl implements SpeechRepository {
  final SpeechDataSource dataSource;

  SpeechRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, bool>> initialize() async {
    try {
      final result = await dataSource.initialize();
      return Right(result);
    } on PermissionException catch (e) {
      AppLogger.error('Ошибка доступа к микрофону', e);
      return Left(PermissionFailure(
        message: 'Нет доступа к микрофону: ${e.message}',
      ));
    } catch (e) {
      AppLogger.error('Ошибка инициализации распознавания речи', e);
      return Left(UnknownFailure(
        message: 'Не удалось инициализировать распознавание речи: $e',
      ));
    }
  }

  @override
  Future<Either<Failure, Stream<String>>> startListening() async {
    try {
      final result = await dataSource.startListening();
      return Right(result);
    } on PermissionException catch (e) {
      AppLogger.error('Ошибка доступа к микрофону', e);
      return Left(PermissionFailure(
        message: 'Нет доступа к микрофону: ${e.message}',
      ));
    } catch (e) {
      AppLogger.error('Ошибка при запуске распознавания речи', e);
      return Left(UnknownFailure(
        message: 'Не удалось запустить распознавание речи: $e',
      ));
    }
  }

  @override
  Future<Either<Failure, bool>> stopListening() async {
    try {
      final result = await dataSource.stopListening();
      return Right(result);
    } catch (e) {
      AppLogger.error('Ошибка при остановке распознавания речи', e);
      return Left(UnknownFailure(
        message: 'Не удалось остановить распознавание речи: $e',
      ));
    }
  }

  @override
  Future<Either<Failure, bool>> isAvailable() async {
    try {
      final result = await dataSource.isAvailable();
      return Right(result);
    } catch (e) {
      AppLogger.error('Ошибка при проверке доступности распознавания речи', e);
      return Left(UnknownFailure(
        message: 'Не удалось проверить доступность распознавания речи: $e',
      ));
    }
  }

  @override
  Future<Either<Failure, bool>> isListening() async {
    try {
      final result = await dataSource.isListening();
      return Right(result);
    } catch (e) {
      AppLogger.error('Ошибка при проверке статуса распознавания речи', e);
      return Left(UnknownFailure(
        message: 'Не удалось проверить статус распознавания речи: $e',
      ));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getAvailableLocales() async {
    try {
      final result = await dataSource.getAvailableLocales();
      return Right(result);
    } catch (e) {
      AppLogger.error('Ошибка при получении доступных локалей', e);
      return Left(UnknownFailure(
        message: 'Не удалось получить список доступных локалей: $e',
      ));
    }
  }
}