//confidence_indicator.dart
import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../core/constants/classification_constants.dart';

class ConfidenceIndicator extends StatelessWidget {
  final List<List<double>> classificationResult;

  const ConfidenceIndicator({
    Key? key,
    required this.classificationResult,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Получаем уровни уверенности для каждой классификации
    final List<double> confidenceLevels = classificationResult
        .map((result) => _getConfidence(result))
        .toList();

    return SizedBox(
      width: 200,
      height: 5,
      child: Row(
        children: confidenceLevels.map((confidence) =>
            Expanded(
                child: Container(
                  color: _getConfidenceColor(confidence),
                )
            )
        ).toList(),
      ),
    );
  }

  /// Получает уровень уверенности из результата
  double _getConfidence(List<double> scores) {
    final normalizedScores = _softmax(scores);
    return normalizedScores.reduce((a, b) => math.max(a, b));
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
    if (confidence > 0.8) {
      return Colors.green;
    } else if (confidence > 0.5) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }

  /// Возвращает метку предсказания для результата
  String _getPredictedLabel(List<double> scores) {
    int maxIndex = 0;
    double maxValue = scores[0];

    for (int i = 1; i < scores.length; i++) {
      if (scores[i] > maxValue) {
        maxValue = scores[i];
        maxIndex = i;
      }
    }

    if (maxIndex < ClassificationConstants.labels.length) {
      return ClassificationConstants.labels[maxIndex];
    }

    return 'UNKNOWN';
  }
}