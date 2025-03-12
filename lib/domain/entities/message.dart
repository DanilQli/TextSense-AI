import 'package:equatable/equatable.dart';

class Message extends Equatable {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final String? reaction;
  final List<List<double>>? classificationResult;
  final List<List<double>>? classificationEmotionsResult;
  final bool isTranslating;
  final String? id;

  const Message({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.reaction,
    this.classificationResult,
    this.classificationEmotionsResult,
    this.isTranslating = false,
    this.id,
  });

  Message copyWith({
    String? text,
    bool? isUser,
    DateTime? timestamp,
    Object? reaction = _unchanged,
    Object? classificationResult = _unchanged,
    Object? classificationEmotionsResult = _unchanged,
    bool? isTranslating,
    String? id,
  }) {
    return Message(
      text: text ?? this.text,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
      reaction: reaction == _unchanged ? this.reaction : reaction as String?,
      classificationResult: classificationResult == _unchanged
          ? this.classificationResult
          : classificationResult as List<List<double>>?,
      classificationEmotionsResult: classificationEmotionsResult == _unchanged
          ? this.classificationEmotionsResult
          : classificationEmotionsResult as List<List<double>>?,
      isTranslating: isTranslating ?? this.isTranslating,
      id: id ?? this.id,
    );
  }

// Добавляем константу в область видимости класса
  static const _unchanged = Object();

  @override
  List<Object?> get props => [
    id,
    text,
    isUser,
    timestamp,
    reaction,
    // Используем toString() для коллекций, чтобы корректно сравнивать в Equatable
    classificationResult?.toString(),
    classificationEmotionsResult?.toString(),
    isTranslating,
  ];
}