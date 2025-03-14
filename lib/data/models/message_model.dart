import 'dart:convert';
import 'package:uuid/uuid.dart';
import '../../domain/entities/message.dart';

class MessageModel extends Message {
  const MessageModel({
    required String text,
    required bool isUser,
    required DateTime timestamp,
    String? reaction,
    List<List<double>>? classificationResult,
    List<List<double>>? classificationEmotionsResult,
    bool isTranslating = false,
    String? id,
  }) : super(
    text: text,
    isUser: isUser,
    timestamp: timestamp,
    reaction: reaction,
    classificationResult: classificationResult,
    classificationEmotionsResult: classificationEmotionsResult,
    isTranslating: isTranslating,
    id: id,
  );

  factory MessageModel.fromEntity(Message message) {
    return MessageModel(
      text: message.text,
      isUser: message.isUser,
      timestamp: message.timestamp,
      reaction: message.reaction,
      classificationResult: message.classificationResult,
      classificationEmotionsResult: message.classificationEmotionsResult,
      isTranslating: message.isTranslating,
      id: message.id ?? const Uuid().v4(),
    );
  }

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    // Проверяем наличие необходимых полей
    if (!json.containsKey('text') ||
        !json.containsKey('isUser') ||
        !json.containsKey('timestamp')) {
      throw const FormatException('Некорректный формат JSON для Message');
    }

    // Обрабатываем classificationResult
    List<List<double>>? classificationResult;
    if (json['classificationResult'] != null) {
      classificationResult = [];
      for (var result in json['classificationResult']) {
        if (result is List) {
          classificationResult.add(
              List<double>.from(result.map((x) => x is num ? x.toDouble() : 0.0))
          );
        }
      }
    }

    // Обрабатываем classificationEmotionsResult
    List<List<double>>? classificationEmotionsResult;
    if (json['classificationEmotionsResult'] != null) {
      classificationEmotionsResult = [];
      for (var result in json['classificationEmotionsResult']) {
        if (result is List) {
          classificationEmotionsResult.add(
              List<double>.from(result.map((x) => x is num ? x.toDouble() : 0.0))
          );
        }
      }
    }

    return MessageModel(
      text: json['text'] as String,
      isUser: json['isUser'] as bool,
      timestamp: DateTime.parse(json['timestamp'] as String),
      reaction: json['reaction'] as String?,
      classificationResult: classificationResult,
      classificationEmotionsResult: classificationEmotionsResult,
      isTranslating: json['isTranslating'] as bool? ?? false,
      id: json['id'] as String? ?? const Uuid().v4(),
    );
  }

  Map<String, dynamic> toJson() => {
    'text': text,
    'isUser': isUser,
    'timestamp': timestamp.toIso8601String(),
    'reaction': reaction,
    'classificationResult': classificationResult,
    'classificationEmotionsResult': classificationEmotionsResult,
    'isTranslating': isTranslating,
    'id': id,
  };

  @override
  MessageModel copyWith({
    String? text,
    bool? isUser,
    DateTime? timestamp,
    Object? reaction = _unchanged,
    Object? classificationResult = _unchanged,
    Object? classificationEmotionsResult = _unchanged,
    bool? isTranslating,
    String? id,
  }) {
    return MessageModel(
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

  static List<MessageModel> fromJsonList(String jsonString) {
    try {
      final List<dynamic> decodedList = json.decode(jsonString);
      return decodedList
          .map((item) => MessageModel.fromJson(item))
          .toList();
    } catch (e) {
      throw FormatException('Ошибка при разборе JSON списка сообщений: $e');
    }
  }

  static String toJsonList(List<MessageModel> messages) {
    final jsonList = messages.map((message) => message.toJson()).toList();
    return json.encode(jsonList);
  }
}