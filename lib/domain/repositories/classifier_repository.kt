import 'package:dartz/dartz.dart';
import '../../core/errors/failure.dart';

abstract class ClassifierRepository {
  /// Выполняет классификацию текста
  Future<Either<Failure, List<List<double>>>> classifyText(String text);
}