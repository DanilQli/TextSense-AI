// test/core/utils/datetime_utils_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:coursework/core/utils/datetime_utils.dart';

void main() {
  group('DateTimeUtils', () {
    test('formatDateTime should format date and time correctly', () {
      // Arrange
      final dateTime = DateTime(2023, 5, 15, 10, 30, 45);

      // Act
      final result = DateTimeUtils.formatDateTime(dateTime);

      // Assert
      expect(result, '15.05.2023 10:30');
    });

    test('formatDate should format only date correctly', () {
      // Arrange
      final dateTime = DateTime(2023, 5, 15, 10, 30, 45);

      // Act
      final result = DateTimeUtils.formatDate(dateTime);

      // Assert
      expect(result, '15.05.2023');
    });

    test('formatTime should format only time correctly', () {
      // Arrange
      final dateTime = DateTime(2023, 5, 15, 10, 30, 45);

      // Act
      final result = DateTimeUtils.formatTime(dateTime);

      // Assert
      expect(result, '10:30');
    });

    test('formatMessageTime should return "Сегодня" for today\'s date', () {
      // Arrange
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day, 14, 30);

      // Act
      final result = DateTimeUtils.formatMessageTime(today);

      // Assert
      expect(result.startsWith('Сегодня'), true);
    });

    test('formatMessageTime should return "Вчера" for yesterday\'s date', () {
      // Arrange
      final now = DateTime.now();
      final yesterday = DateTime(now.year, now.month, now.day - 1, 14, 30);

      // Act
      final result = DateTimeUtils.formatMessageTime(yesterday);

      // Assert
      expect(result.startsWith('Вчера'), true);
    });

    test('getRelativeTime should return "только что" for recent times', () {
      // Arrange
      final now = DateTime.now();
      final recent = now.subtract(const Duration(seconds: 30));

      // Act
      final result = DateTimeUtils.getRelativeTime(recent);

      // Assert
      expect(result, 'только что');
    });
  });
}