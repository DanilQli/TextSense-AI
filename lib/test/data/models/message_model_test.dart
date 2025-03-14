// test/data/models/message_model_test.dart
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:coursework/data/models/message_model.dart';
import 'package:coursework/domain/entities/message.dart';

void main() {
  final tMessageModel = MessageModel(
    text: 'Test message',
    isUser: true,
    timestamp: DateTime(2023, 5, 15, 10, 30),
    reaction: '😊',
    classificationResult: [
      [0.1, 0.2, 0.7]
    ],
    classificationEmotionsResult: [
      [0.8]
    ],
    id: '123',
  );

  final tMessageJson = {
    'text': 'Test message',
    'isUser': true,
    'timestamp': '2023-05-15T10:30:00.000',
    'reaction': '😊',
    'classificationResult': [
      [0.1, 0.2, 0.7]
    ],
    'classificationEmotionsResult': [
      [0.8]
    ],
    'isTranslating': false,
    'id': '123',
  };

  group('MessageModel', () {
    test('should be a subclass of Message entity', () {
      // Assert
      expect(tMessageModel, isA<Message>());
    });

    test('fromJson should return a valid model', () {
      // Act
      final result = MessageModel.fromJson(tMessageJson);

      // Assert
      expect(result, tMessageModel);
    });

    test('toJson should return a JSON map containing proper data', () {
      // Act
      final result = tMessageModel.toJson();

      // Assert
      expect(result, tMessageJson);
    });

    test('copyWith should return a new instance with updated values', () {
      // Act
      final result = tMessageModel.copyWith(
        text: 'Updated message',
        isUser: false,
      );

      // Assert
      expect(result.text, 'Updated message');
      expect(result.isUser, false);
      expect(result.timestamp, tMessageModel.timestamp);
      expect(result.reaction, tMessageModel.reaction);
    });

    test('fromJsonList should parse a list of messages correctly', () {
      // Arrange
      final jsonList = json.encode([tMessageJson]);

      // Act
      final result = MessageModel.fromJsonList(jsonList);

      // Assert
      expect(result.length, 1);
      expect(result.first, tMessageModel);
    });

    test('toJsonList should convert a list of messages to JSON correctly', () {
      // Arrange
      final messageList = [tMessageModel];

      // Act
      final result = MessageModel.toJsonList(messageList);
      final decoded = json.decode(result);

      // Assert
      expect(decoded.length, 1);
      expect(decoded.first, tMessageJson);
    });
  });
}