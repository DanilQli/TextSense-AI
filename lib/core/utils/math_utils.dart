import 'dart:math' as math;

class MathUtils {
  /// Применяет функцию softmax к массиву чисел
  static List<double> softmax(List<double> scores) {
    final maxScore = scores.reduce(math.max);

    // Создаем список один раз и модифицируем его
    final result = List<double>.filled(scores.length, 0.0);
    double sumExp = 0.0;

    // Первый проход: вычисляем exp(score - maxScore)
    for (int i = 0; i < scores.length; i++) {
      result[i] = math.exp(scores[i] - maxScore);
      sumExp += result[i];
    }

    // Второй проход: нормализуем
    for (int i = 0; i < scores.length; i++) {
      result[i] /= sumExp;
    }

    return result;
  }

  /// Вычисляет уровень уверенности (максимальное значение после softmax)
  static double getConfidence(List<double> scores) {
    final normalizedScores = softmax(scores);
    return normalizedScores.reduce(math.max);
  }

  /// Находит индекс максимального элемента в массиве
  static int argmax(List<double> scores) {
    int maxIndex = 0;
    double maxValue = scores[0];

    for (int i = 1; i < scores.length; i++) {
      if (scores[i] > maxValue) {
        maxValue = scores[i];
        maxIndex = i;
      }
    }

    return maxIndex;
  }

  /// Линейно нормализует значение из одного диапазона в другой
  static double normalize(
      double value,
      double fromMin,
      double fromMax,
      double toMin,
      double toMax
      ) {
    if (fromMax - fromMin == 0) return toMin;

    final scaled = (value - fromMin) / (fromMax - fromMin);
    return toMin + scaled * (toMax - toMin);
  }

  /// Сигмоидальная функция
  static double sigmoid(double x) {
    return 1.0 / (1.0 + math.exp(-x));
  }

  // Приватный конструктор для предотвращения инстанцирования
  MathUtils._();
}