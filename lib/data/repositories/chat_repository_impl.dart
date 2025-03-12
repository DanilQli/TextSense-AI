import 'package:dartz/dartz.dart';
import 'package:flutter_launcher_icons/custom_exceptions.dart';
import '../datasources/local/chat_local_datasource.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../domain/entities/message.dart';
import '../../core/errors/failure.dart';
import '../../core/errors/app_exception.dart';
import '../../core/logger/app_logger.dart';
import '../models/message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatLocalDataSource dataSource;
  final AppLogger logger;

  ChatRepositoryImpl({
    required this.dataSource,
    required this.logger,
  });

  @override
  Future<Either<Failure, Map<String, DateTime>>> getSavedChats() async {
    try {
      final result = await dataSource.getSavedChats();
      return Right(result);
    } on FileException catch (e) {
      logger.logError('Не удалось получить список сохраненных чатов', e);
      return Left(FileOperationFailure(
          message: 'Не удалось получить список сохраненных чатов: ${e.message}'
      ));
    } catch (e) {
      logger.logError('Неизвестная ошибка при получении списка чатов', e);
      return Left(UnknownFailure(
          message: 'Произошла ошибка при получении списка чатов'
      ));
    }
  }

  @override
  Future<Either<Failure, List<Message>>> loadChat(String chatName) async {
    try {
      final messagesData = await dataSource.loadChat(chatName);
      return Right(messagesData);
    } on FileNotFoundException catch (e) {
      logger.logError('Файл чата не найден', e);
      return Left(FileOperationFailure(
          message: 'Чат не найден: ${e}'
      ));
    } on FileException catch (e) {
      logger.logError('Ошибка при загрузке чата', e);
      return Left(FileOperationFailure(
          message: 'Не удалось загрузить чат: ${e.message}'
      ));
    } on FormatException catch (e) {
      logger.logError('Ошибка формата данных чата', e);
      return Left(ValidationFailure(
          message: 'Некорректный формат данных чата: ${e.message}'
      ));
    } catch (e) {
      logger.logError('Неизвестная ошибка при загрузке чата', e);
      return Left(UnknownFailure(
          message: 'Произошла ошибка при загрузке чата'
      ));
    }
  }

  @override
  Future<Either<Failure, bool>> saveChat(String chatName, List<Message> messages) async {
    try {
      // Конвертируем Message в MessageModel
      final messageModels = messages.map((m) =>
      m is MessageModel ? m : MessageModel.fromEntity(m)).toList();

      final success = await dataSource.saveChat(chatName, messageModels);
      return Right(success);
    } on SecurityException catch (e) {
      logger.logError('Ошибка безопасности при сохранении чата', e);
      return Left(ValidationFailure(
          message: 'Недопустимое имя чата: ${e.message}'
      ));
    } on FileException catch (e) {
      logger.logError('Ошибка файловой системы при сохранении чата', e);
      return Left(FileOperationFailure(
          message: 'Не удалось сохранить чат: ${e.message}'
      ));
    } catch (e) {
      logger.logError('Неизвестная ошибка при сохранении чата', e);
      return Left(UnknownFailure(
          message: 'Произошла ошибка при сохранении чата'
      ));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteChat(String chatName) async {
    try {
      final success = await dataSource.deleteChat(chatName);
      return Right(success);
    } on FileException catch (e) {
      logger.logError('Ошибка при удалении чата', e);
      return Left(FileOperationFailure(
          message: 'Не удалось удалить чат: ${e.message}'
      ));
    } catch (e) {
      logger.logError('Неизвестная ошибка при удалении чата', e);
      return Left(UnknownFailure(
          message: 'Произошла ошибка при удалении чата'
      ));
    }
  }

  @override
  Future<Either<Failure, String>> getUniqueDefaultChatName() async {
    try {
      final chatName = await dataSource.getUniqueDefaultChatName();
      return Right(chatName);
    } catch (e) {
      logger.logError('Ошибка при генерации имени чата', e);
      return Left(UnknownFailure(
          message: 'Не удалось создать имя для нового чата'
      ));
    }
  }

  @override
  Future<Either<Failure, bool>> chatExists(String chatName) async {
    try {
      final exists = await dataSource.chatExists(chatName);
      return Right(exists);
    } catch (e) {
      logger.logError('Ошибка при проверке существования чата', e);
      return Left(FileOperationFailure(
          message: 'Не удалось проверить существование чата'
      ));
    }
  }

  @override
  Future<Either<Failure, bool>> renameChat(String oldName, String newName) async {
    try {
      final success = await dataSource.renameChat(oldName, newName);
      return Right(success);
    } on SecurityException catch (e) {
      logger.logError('Ошибка безопасности при переименовании чата', e);
      return Left(ValidationFailure(
          message: 'Недопустимое имя чата: ${e.message}'
      ));
    } on FileException catch (e) {
      logger.logError('Ошибка файловой системы при переименовании чата', e);
      return Left(FileOperationFailure(
          message: 'Не удалось переименовать чат: ${e.message}'
      ));
    } catch (e) {
      logger.logError('Неизвестная ошибка при переименовании чата', e);
      return Left(UnknownFailure(
          message: 'Произошла ошибка при переименовании чата'
      ));
    }
  }
}