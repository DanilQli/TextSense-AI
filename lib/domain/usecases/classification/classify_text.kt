import 'package:dartz/dartz.dart';
import '../../../core/errors/failure.dart';
import '../../repositories/classifier_repository.dart';

class ClassifyText {
  final ClassifierRepository repository;

  ClassifyText(this.repository);

  Future<Either<Failure, List<List<double>>>> call(String text) async {
    // Предварительная проверка текста
    if (text.trim().isEmpty) {
      return const Right([[0.0], [0.0]]); // Пустой текст не классифицируем
    }

    // Разбиваем текст на строки
    final lines = text.split('\n');
    final results = <List<double>>[];
    final emotionResults = <List<double>>[];

    // Классифицируем каждую непустую строку
    for (final line in lines) {
      if (line.trim().isNotEmpty) {
        final result = await repository.classifyText(line);

        await result.fold(
              (failure) {
            // В случае ошибки, возвращаем дефолтные значения для строки
            results.add([0.0]);
            emotionResults.add([0.0]);
          },
              (classification) {
            results.add(classification[0]);
            emotionResults.add(classification[1]);
          },
        );
      }
    }

    // Если не удалось классифицировать ни одной строки, возвращаем ошибку
    if (results.isEmpty) {
      return Left(ClassificationFailure(
          message: 'Не удалось классифицировать текст'
      ));
    }
    final combined = [...results.expand((e) => e), ...emotionResults.expand((e) => e)];
    return Right(combined.cast<List<double>>());
  }
}