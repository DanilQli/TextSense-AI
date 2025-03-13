class StringUtils {
  // Проверяет, пустая ли строка, учитывая пробелы
  static bool isEmpty(String? str) {
    return str == null || str.trim().isEmpty;
  }

  // Обрезает строку до указанной длины
  static String truncate(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    }
    return '${text.substring(0, maxLength)}...';
  }

  // Капитализирует первую букву каждого слова
  static String capitalize(String text) {
    if (isEmpty(text)) return '';

    return text.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  // Удаляет HTML-теги из строки
  static String stripHtml(String text) {
    return text.replaceAll(RegExp(r'<[^>]*>'), '');
  }

  // Проверяет строку на соответствие регулярному выражению
  static bool matchesPattern(String text, String pattern) {
    final regExp = RegExp(pattern);
    return regExp.hasMatch(text);
  }

  // Форматирует число с разделителями
  static String formatNumber(int number) {
    final String numStr = number.toString();
    final StringBuffer result = StringBuffer();

    for (int i = 0; i < numStr.length; i++) {
      if (i > 0 && (numStr.length - i) % 3 == 0) {
        result.write(' ');
      }
      result.write(numStr[i]);
    }

    return result.toString();
  }

  // Удаляет лишние пробелы
  static String normalizeSpaces(String text) {
    return text.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  // Приватный конструктор для предотвращения инстанцирования
  StringUtils._();
}