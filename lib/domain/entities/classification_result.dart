import 'package:equatable/equatable.dart';

class ClassificationResult extends Equatable {
  final List<double> categoryScores;
  final double emotionalScore;
  final String predictedCategory;
  final double confidence;

  const ClassificationResult({
    required this.categoryScores,
    required this.emotionalScore,
    required this.predictedCategory,
    required this.confidence,
  });

  /// Уровень позитивности текста от 0 до 100%
  double get positivityPercentage => ((emotionalScore + 1) / 2) * 100;

  /// Уровень уверенности от 0 до 100%
  double get confidencePercentage => confidence * 100;

  @override
  List<Object> get props => [
    categoryScores,
    emotionalScore,
    predictedCategory,
    confidence
  ];

  ClassificationResult copyWith({
    List<double>? categoryScores,
    double? emotionalScore,
    String? predictedCategory,
    double? confidence,
  }) {
    return ClassificationResult(
      categoryScores: categoryScores ?? this.categoryScores,
      emotionalScore: emotionalScore ?? this.emotionalScore,
      predictedCategory: predictedCategory ?? this.predictedCategory,
      confidence: confidence ?? this.confidence,
    );
  }
}