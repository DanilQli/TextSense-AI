import 'dart:io';
import 'dart:convert';
import 'package:flutter_launcher_icons/custom_exceptions.dart';
import 'package:path_provider/path_provider.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/logger/app_logger.dart';
import '../../../core/utils/file_utils.dart';
import '../../models/message_model.dart';

abstract class ChatLocalDataSource {
  Future<Map<String, DateTime>> getSavedChats();
  Future<List<MessageModel>> loadChat(String chatName);
  Future<bool> saveChat(String chatName, List<MessageModel> messages);
  Future<bool> deleteChat(String chatName);
  Future<bool> chatExists(String chatName);
  Future<String> getUniqueDefaultChatName();
  Future<bool> renameChat(String oldName, String newName);
  ensureCurrentChatExists() {}

}

class ChatLocalDataSourceImpl implements ChatLocalDataSource {
  final AppLogger logger;
  final String fileExtension = 'json';

  ChatLocalDataSourceImpl({required this.logger});

  Future<void> ensureCurrentChatExists() async {
    try {
      final exists = await chatExists('current');
      if (!exists) {
        await saveChat('current', []);
      }
    } catch (e) {
      logger.logWarning('Не удалось создать пустой чат', e);
    }
  }

  @override
  Future<Map<String, DateTime>> getSavedChats() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final files = await directory.list().toList();
      Map<String, DateTime> savedChats = {};

      for (var file in files) {
        if (file is File && file.path.endsWith('.$fileExtension')) {
          try {
            // Извлекаем имя файла без пути и расширения
            final fileName = file.uri.pathSegments.last
                .replaceAll('.$fileExtension', '');

            // Проверяем, что это действительно файл чата
            if (await _isValidChatFile(file)) {
              final lastModified = await file.lastModified();
              savedChats[fileName] = lastModified;
            }
          } catch (e) {
            logger.logWarning('Пропускаем некорректный файл: ${file.path}', e);
          }
        }
      }

      logger.logDebug('Найдено ${savedChats.length} сохраненных чатов');
      return savedChats;
    } catch (e) {
      logger.logError('Ошибка при получении списка сохраненных чатов', e);
      throw FileException('Не удалось загрузить список чатов: $e');
    }
  }

  Future<bool> _isValidChatFile(File file) async {
    try {
      if (await file.exists()) {
        final fileContent = await file.readAsString();
        final jsonData = jsonDecode(fileContent);

        // Проверяем, что это массив сообщений
        return jsonData is List;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<MessageModel>> loadChat(String chatName) async {
    try {
      if (!await chatExists(chatName)) {
        throw FileNotFoundException('Чат не найден: $chatName');
      }

      final filePath = await FileUtils.getSafePath(chatName, extension: fileExtension);
      final file = File(filePath);

      final jsonData = await file.readAsString();
      logger.logDebug('Загружен чат: $chatName (${jsonData.length} байт)');

      return MessageModel.fromJsonList(jsonData);
    } catch (e) {
      if (e is FileNotFoundException) rethrow;
      logger.logError('Ошибка при загрузке чата: $chatName', e);
      throw FileException('Не удалось загрузить чат: $e');
    }
  }

  @override
  Future<bool> saveChat(String chatName, List<MessageModel> messages) async {
    try {
      // Проверяем безопасность имени файла
      if (!FileUtils.isValidFileName(chatName)) {
        throw SecurityException('Недопустимое имя чата: $chatName');
      }

      final filePath = await FileUtils.getSafePath(chatName, extension: fileExtension);

      // Проверяем доступ к файловой системе
      if (!await FileUtils.hasFileAccess(filePath)) {
        throw FileException('Нет доступа к файлу: $filePath');
      }

      // Конвертируем сообщения в JSON
      final jsonString = MessageModel.toJsonList(messages);

      // Используем безопасное сохранение
      await FileUtils.saveDataToFile(chatName, jsonString);

      logger.logDebug('Чат успешно сохранен: $chatName (${messages.length} сообщений)');
      return true;
    } catch (e) {
      if (e is SecurityException) rethrow;
      logger.logError('Ошибка сохранения чата: $chatName', e);
      throw FileException('Не удалось сохранить чат: $e');
    }
  }

  @override
  Future<bool> deleteChat(String chatName) async {
    try {
      // Проверяем существование чата
      if (!await chatExists(chatName)) {
        logger.logWarning('Попытка удалить несуществующий чат: $chatName');
        return false;
      }

      final success = await FileUtils.deleteFile(chatName);
      if (success) {
        logger.logDebug('Чат успешно удален: $chatName');
      }
      return success;
    } catch (e) {
      logger.logError('Ошибка при удалении чата: $chatName', e);
      throw FileException('Не удалось удалить чат: $e');
    }
  }

  @override
  Future<bool> chatExists(String chatName) async {
    try {
      if (!FileUtils.isValidFileName(chatName)) {
        throw SecurityException('Недопустимое имя чата при проверке: $chatName');
      }

      final filePath = await FileUtils.getSafePath(chatName, extension: fileExtension);
      final exists = await File(filePath).exists();
      return exists;
    } catch (e) {
      if (e is SecurityException) {
        logger.logWarning('Небезопасное имя чата при проверке: $chatName', e);
        return false;
      }
      logger.logError('Ошибка при проверке существования чата', e);
      return false;
    }
  }

  @override
  Future<String> getUniqueDefaultChatName() async {
    try {
      String baseName = "New chat";

      // Получаем список существующих чатов
      final savedChats = await getSavedChats();

      // Начинаем с "New Chat"
      if (!savedChats.containsKey(baseName)) {
        return baseName;
      }

      // Если "New Chat" уже существует, ищем "New Chat 1", "New Chat 2", и т.д.
      int counter = 1;
      while (true) {
        String candidateName = "$baseName $counter";
        if (!savedChats.containsKey(candidateName)) {
          return candidateName;
        }
        counter++;

        // Защита от бесконечного цикла
        if (counter > 10000) {
          throw Exception('Не удалось создать уникальное имя чата');
        }
      }
    } catch (e) {
      logger.logError('Ошибка при генерации имени чата', e);
      throw FileException('Не удалось создать имя для нового чата: $e');
    }
  }

  @override
  Future<bool> renameChat(String oldName, String newName) async {
    try {
      // Проверяем существование исходного чата
      if (!await chatExists(oldName)) {
        throw FileNotFoundException('Исходный чат не найден: $oldName');
      }

      // Проверяем, не существует ли уже новое имя
      if (await chatExists(newName)) {
        throw FileException('Чат с именем "$newName" уже существует');
      }

      // Загружаем сообщения из старого чата
      final messages = await loadChat(oldName);

      // Сохраняем их с новым именем
      await saveChat(newName, messages);

      // Удаляем старый чат
      await deleteChat(oldName);

      logger.logDebug('Чат успешно переименован: $oldName -> $newName');
      return true;
    } catch (e) {
      logger.logError('Ошибка при переименовании чата', e);
      if (e is FileNotFoundException || e is SecurityException || e is FileException) {
        rethrow;
      }
      throw FileException('Не удалось переименовать чат: $e');
    }
  }
}