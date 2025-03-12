import 'dart:math' as math;

class MathUtils {
  /// Применяет функцию softmax к массиву чисел
  static List<double> softmax(List<double> scores) {
    final maxScore = scores.reduce(math.max);
    final expScores = scores.map((score) => math.exp(score - maxScore))
        .toList();
    final sumExpScores = expScores.reduce((a, b) => a + b);
    return expScores.map((score) => score / sumExpScores).toList();
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

  /// Вычисляет среднее значение в массиве
  static double mean(List<double> values) {
    if (values.isEmpty) return 0.0;
    final sum = values.reduce((a, b) => a + b);
    return sum / values.length;
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