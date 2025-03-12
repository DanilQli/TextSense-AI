import 'package:dartz/dartz.dart';
import '../entities/message.dart';
import '../../core/errors/failure.dart';

abstract class ChatRepository {
  /// Получает список сохраненных чатов и времени их изменения
  Future<Either<Failure, Map<String, DateTime>>> getSavedChats();

  /// Загружает сообщения из чата с указанным именем
  Future<Either<Failure, List<Message>>> loadChat(String chatName);

  /// Сохраняет чат с указанным именем
  Future<Either<Failure, bool>> saveChat(String chatName, List<Message> messages);

  /// Удаляет чат с указанным именем
  Future<Either<Failure, bool>> deleteChat(String chatName);

  /// Генерирует уникальное имя для нового чата
  Future<Either<Failure, String>> getUniqueDefaultChatName();

  /// Проверяет существование чата с указанным именем
  Future<Either<Failure, bool>> chatExists(String chatName);

  /// Переименовывает чат
  Future<Either<Failure, bool>> renameChat(String oldName, String newName);
}