import 'package:dartz/dartz.dart';
import '../../../core/errors/failure.dart';
import '../../repositories/classifier_repository.dart';

class ClassifyText {
  final ClassifierRepository repository;

  ClassifyText(this.repository);

  Future<Either<Failure, List<List<List<double>>>>> call(String text) async {
    // Предварительная проверка текста
    if (text.trim().isEmpty) {
      return Right([[[0.0]], [[0.0]]]); // Пустой текст не классифицируем
    }

    // Разбиваем текст на строки
    final lines = text.split('\n').where((line) => line.trim().isNotEmpty).toList();

    if (lines.isEmpty) {
      return Right([[[0.0]], [[0.0]]]); // Если нет непустых строк
    }

    try {
      // Создаем списки для результатов
      final categoryResults = <List<double>>[];
      final emotionResults = <List<double>>[];

      // Обрабатываем каждую строку последовательно
      for (final line in lines) {
        final result = await repository.classifyText(line);

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
      }

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