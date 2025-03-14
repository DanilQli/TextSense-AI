import 'package:dartz/dartz.dart';
import '../../data/datasources/remote/translator_datasource.dart';
import '../../domain/repositories/translator_repository.dart';
import '../../core/errors/failure.dart';
import '../../core/errors/app_exception.dart';
import '../../core/logger/app_logger.dart';

class TranslatorRepositoryImpl implements TranslatorRepository {
  final TranslatorDataSource dataSource;

  TranslatorRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, String>> translate(String text, String targetLanguage) async {
    try {
      // Если текст пустой, возвращаем его без перевода
      if (text.trim().isEmpty) {
        return Right(text);
      }

      final result = await dataSource.translate(text, targetLanguage);
      return Right(result);
    } on NetworkException catch (e) {
      AppLogger.error('Ошибка сети при переводе текста', e);
      return Left(NetworkFailure(
        message: 'Ошибка сети при переводе текста: ${e.message}',
      ));
    } on ServerException catch (e) {
      AppLogger.error('Ошибка сервера при переводе текста', e);
      return Left(ServerFailure(
        message: 'Ошибка сервера при переводе текста: ${e.message}',
        code: e.statusCode,
      ));
    } on TranslationException catch (e) {
      AppLogger.error('Ошибка перевода', e);
      return Left(TranslationFailure(
        message: 'Ошибка перевода: ${e.message}',
      ));
    } catch (e) {
      AppLogger.error('Неизвестная ошибка при переводе текста', e);
      return const Left(UnknownFailure(
        message: 'Произошла ошибка при переводе текста',
      ));
    }
  }

  @override
  Future<Either<Failure, String>> detectLanguage(String text) async {
    try {
      if (text.trim().isEmpty) {
        return const Right('en'); // По умолчанию - английский
      }

      final result = await dataSource.detectLanguage(text);
      return Right(result);
    } catch (e) {
      AppLogger.error('Ошибка при определении языка', e);
      return const Left(UnknownFailure(
        message: 'Произошла ошибка при определении языка текста',
      ));
    }
  }

}