// core/utils/file_utils.dart
import 'dart:io';
import 'package:flutter_launcher_icons/custom_exceptions.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import '../errors/app_exception.dart';
import '../logger/app_logger.dart';

class FileUtils {


  /// Проверяет, является ли имя файла безопасным
  static bool isValidFileName(String fileName) {
    // Усиленная проверка имени файла
    final RegExp validChars = RegExp(r'^[a-zA-Zа-яА-Я0-9 _\-]+$');
    return validChars.hasMatch(fileName) &&
        !fileName.contains('..') &&
        fileName.length <= 255 &&
        fileName.trim().isNotEmpty;
  }

  /// Возвращает безопасный путь к файлу
  static Future<String> getSafePath(String fileName, {String? extension}) async {
    if (!isValidFileName(fileName)) {
      throw SecurityException('Недопустимое имя файла: $fileName');
    }

    final ext = extension ?? 'json';
    final basePath = await getApplicationDocumentsDirectory();

    // Нормализация пути для предотвращения path traversal атак
    final normalizedPath = path.normalize(
        path.join(basePath.path, '$fileName.$ext')
    );

    // Проверка, что путь находится внутри basePath
    if (!normalizedPath.startsWith(basePath.path)) {
      throw SecurityException('Недопустимый путь к файлу');
    }

    return normalizedPath;
  }

  /// Проверяет наличие доступа к файлу
  static Future<bool> hasFileAccess(String filePath) async {
    try {
      final file = File(filePath);
      // Проверка доступа к файлу
      final dirExists = await Directory(path.dirname(filePath)).exists();

      if (!dirExists) {
        return false;
      }

      if (await file.exists()) {
        // Проверяем права на чтение/запись существующего файла
        try {
          await file.readAsString();
          return true;
        } catch (e) {
          AppLogger.error('Нет доступа к файлу $filePath', e);
          return false;
        }
      }

      // Если файл не существует, проверяем, можем ли мы создать его
      try {
        await file.create();
        await file.delete();
        return true;
      } catch (e) {
        AppLogger.error('Не удалось создать тестовый файл в $filePath', e);
        return false;
      }
    } catch (e) {
      AppLogger.error('Ошибка при проверке доступа к файлу', e);
      return false;
    }
  }

  /// Создает уникальное имя файла
  static Future<String> getUniqueFileName(String baseName, {String? extension}) async {
    final ext = extension ?? 'json';
    final directory = await getApplicationDocumentsDirectory();
    int counter = 1;
    String fileName = baseName;

    while (true) {
      final filePath = path.join(directory.path, '$fileName.$ext');
      final exists = await File(filePath).exists();

      if (!exists) {
        return fileName;
      }

      fileName = '$baseName $counter';
      counter++;

      // Защита от бесконечного цикла
      if (counter > 10000) {
        throw Exception('Не удалось создать уникальное имя файла');
      }
    }
  }

  /// Безопасно сохраняет данные в файл
  static Future<void> saveDataToFile(String fileName, String data) async {
    try {

      final filePath = await getSafePath(fileName);
      final file = File(filePath);

      // Сначала записываем во временный файл
      final tempFile = File('$filePath.tmp');
      await tempFile.writeAsString(data);

      // Если временный файл успешно создан, заменяем оригинальный
      if (await file.exists()) {
        await file.delete();
      }

      await tempFile.rename(filePath);

      AppLogger.debug('Файл успешно сохранен: $filePath');
    } catch (e, stackTrace) {
      AppLogger.error('Ошибка при сохранении файла', e, stackTrace);
      rethrow;
    }
  }

  /// Безопасно загружает данные из файла
  static Future<String> loadDataFromFile(String fileName) async {
    try {
      final filePath = await getSafePath(fileName);
      final file = File(filePath);

      if (!await file.exists()) {
        throw FileNotFoundException('Файл не найден: $fileName');
      }

      final data = await file.readAsString();
      return data;
    } catch (e, stackTrace) {
      AppLogger.error('Ошибка при загрузке файла', e, stackTrace);
      rethrow;
    }
  }

  /// Безопасно удаляет файл
  static Future<bool> deleteFile(String fileName) async {
    try {
      final filePath = await getSafePath(fileName);
      final file = File(filePath);

      if (await file.exists()) {
        await file.delete();
        AppLogger.debug('Файл успешно удален: $filePath');
        return true;
      }

      return false;
    } catch (e, stackTrace) {
      AppLogger.error('Ошибка при удалении файла', e, stackTrace);
      rethrow;
    }
  }
}
