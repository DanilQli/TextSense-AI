//confidence_indicator.dart
import 'package:flutter/material.dart';
import 'dart:math' as math;

class ConfidenceIndicator extends StatelessWidget {
  final List<List<double>> classificationResult;
  final List<List<double>> emotionResult;

  const ConfidenceIndicator({
    Key? key,
    required this.classificationResult,
    required this.emotionResult,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Получаем уровни уверенности для каждой классификации
    final List<double> classificationConfidenceLevels = classificationResult
        .map((result) => _getConfidence(result))
        .toList();
    final List<double> emotionConfidenceLevels = emotionResult.map((emotion) {
      final double rawValue = emotion[0];
      final double transformedValue = (rawValue + 1) / 2;
      return double.parse(transformedValue.toStringAsFixed(2));
    }).toList();
      return Column(
      children: [
        // Линия уверенности в классификации
        SizedBox(
          width: 200,
          height: 5,
          child: Row(
            children: classificationConfidenceLevels.map((confidence) =>
                Expanded(
                    child: Container(
                      color: _getConfidenceColor(confidence),
                    )
                )
            ).toList(),
          ),
        ),
        SizedBox(height: 4), // Отступ между линиями
        // Линия уверенности в эмоциональной окраске
        SizedBox(
          width: 200,
          height: 5,
          child: Row(
            children: emotionConfidenceLevels.map((confidence) =>
                Expanded(
                    child: Container(
                      color: _getConfidenceColor(confidence),
                    )
                )
            ).toList(),
          ),
        ),
      ],
    );
  }

  /// Получает уровень уверенности из результата
  double _getConfidence(List<double> scores) {
    if (scores.isEmpty) {
      return 0.0; // или любое другое значение по умолчанию
    }
    final normalizedScores = _softmax(scores);
    return normalizedScores.reduce((a, b) => a > b ? a : b);
  }

  /// Применяет softmax к результатам для нормализации
  List<double> _softmax(List<double> scores) {
    final maxScore = scores.reduce(math.max);
    final expScores = scores.map((score) => math.exp(score - maxScore)).toList();
    final sumExpScores = expScores.reduce((a, b) => a + b);
    return expScores.map((score) => score / sumExpScores).toList();
  }

  /// Возвращает цвет в зависимости от уровня уверенности
  Color _getConfidenceColor(double confidence) {
    if (confidence > 0.7) {
      return Colors.green;
    } else if (confidence > 0.5) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }
}