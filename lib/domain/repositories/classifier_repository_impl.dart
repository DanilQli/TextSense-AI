import 'package:dartz/dartz.dart';
import '../../data/datasources/remote/classifier_datasource.dart';
import '../../domain/repositories/classifier_repository.dart';
import '../../core/errors/failure.dart';
import '../../core/errors/app_exception.dart';
import '../../core/logger/app_logger.dart';

class ClassifierRepositoryImpl implements ClassifierRepository {
  final ClassifierDataSource dataSource;

  ClassifierRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, List<List<double>>>> classifyText(String text) async {
    try {
      final result = await dataSource.classifyText(text);
      return Right(result);
    } on ServerException catch (e) {
      AppLogger.error('Ошибка сервера при классификации текста', e);
      return Left(ServerFailure(
        message: 'Ошибка сервера при классификации текста: ${e.message}',
        code: e.statusCode,
      ));
    } on NetworkException catch (e) {
      AppLogger.error('Ошибка сети при классификации текста', e);
      return Left(NetworkFailure(
        message: 'Ошибка сети при классификации текста: ${e.message}',
      ));
    } on FormatException catch (e) {
      AppLogger.error('Ошибка формата данных при классификации текста', e);
      return Left(ClassificationFailure(
        message: 'Некорректный формат данных: ${e.message}',
      ));
    } catch (e) {
      AppLogger.error('Неизвестная ошибка при классификации текста', e);
      return const Left(UnknownFailure(
        message: 'Произошла ошибка при классификации текста',
      ));
    }
  }
}