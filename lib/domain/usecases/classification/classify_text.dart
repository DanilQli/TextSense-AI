import 'package:dartz/dartz.dart';
import '../../../core/errors/failure.dart';
import '../../repositories/classifier_repository.dart';

class ClassifyText {
  final ClassifierRepository repository;

  ClassifyText(this.repository);

  Future<Either<Failure, List<List<List<double>>>>> call(String text) async {
    // Разбиваем текст на строки

    try {
      // Создаем списки для результатов
      final categoryResults = <List<double>>[];
      final emotionResults = <List<double>>[];

      final result = await repository.classifyText(text);

      result.fold(
              (failure) {
            // В случае ошибки добавляем дефолтные значения
            categoryResults.add([0.0]);
            emotionResults.add([0.0]);
          },
              (classification) {
            categoryResults.add(classification[0]);
            emotionResults.add(classification[1]);
          }
      );

      // Если не удалось получить результаты, возвращаем ошибку
      if (categoryResults.isEmpty) {
        return const Left(ClassificationFailure(
            message: 'Не удалось классифицировать текст'
        ));
      }

      // Возвращаем результаты в правильном формате
      return Right([categoryResults, emotionResults]);
    } catch (e) {
      return Left(ClassificationFailure(
          message: 'Ошибка при классификации текста: $e'
      ));
    }
  }
}