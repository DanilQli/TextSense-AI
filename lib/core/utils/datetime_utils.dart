import 'package:coursework/core/utils/translation_utils.dart';
import 'package:intl/intl.dart';
import '../constants/app_constants.dart';
import '../services/translation_service.dart';

class DateTimeUtils {
  /// Форматирует дату и время по указанному формату
  static String formatDateTime(DateTime dateTime, [String? format]) {
    final formatter = DateFormat(format ?? AppConstants.dateTimeFormat);
    return formatter.format(dateTime);
  }

  /// Форматирует только дату
  static String formatDate(DateTime dateTime, [String? format]) {
    final formatter = DateFormat(format ?? AppConstants.dateFormat);
    return formatter.format(dateTime);
  }

  /// Форматирует только время
  static String formatTime(DateTime dateTime, [String? format]) {
    final formatter = DateFormat(format ?? AppConstants.timeFormat);
    return formatter.format(dateTime);
  }

  /// Форматирует время для отображения в сообщениях чата
  static String formatMessageTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    // Определяем, отображать ли "Сегодня", "Вчера" или полную дату
    if (messageDate == today) {
      return 'Сегодня, ${DateFormat(AppConstants.timeFormat).format(dateTime)}';
    } else if (messageDate == yesterday) {
      return 'Вчера, ${DateFormat(AppConstants.timeFormat).format(dateTime)}';
    } else {
      return formatDateTime(dateTime);
    }
  }

  /// Возвращает относительное время (например, "5 минут назад")
  static String getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'только что';
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return '$minutes ${_getPluralForm(minutes, Tr.get(TranslationKeys.minute1), Tr.get(TranslationKeys.minute2), Tr.get(TranslationKeys.minute3))} ${Tr.get(TranslationKeys.back)}';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return '$hours ${_getPluralForm(hours, Tr.get(TranslationKeys.hour1), Tr.get(TranslationKeys.hour2), Tr.get(TranslationKeys.hour3))} ${Tr.get(TranslationKeys.back)}';
    } else if (difference.inDays < 7) {
      final days = difference.inDays;
      return '$days ${_getPluralForm(days, Tr.get(TranslationKeys.day1), Tr.get(TranslationKeys.day2), Tr.get(TranslationKeys.day3))} ${Tr.get(TranslationKeys.back)}';
    } else {
      return formatDateTime(dateTime);
    }
  }

  /// Вспомогательный метод для выбора правильной формы слова в зависимости от числа
  static String _getPluralForm(int number, String form1, String form2, String form5) {
    final mod10 = number % 10;
    final mod100 = number % 100;

    if (mod100 >= 11 && mod100 <= 20) {
      return form5;
    }

    if (mod10 == 1) {
      return form1;
    }

    if (mod10 >= 2 && mod10 <= 4) {
      return form2;
    }

    return form5;
  }

  // Приватный конструктор для предотвращения инстанцирования
  DateTimeUtils._();
}