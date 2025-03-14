class StringUtils {
  // Проверяет, пустая ли строка, учитывая пробелы
  static bool isEmpty(String? str) {
    return str == null || str.trim().isEmpty;
  }
  // Приватный конструктор для предотвращения инстанцирования
  StringUtils._();
}