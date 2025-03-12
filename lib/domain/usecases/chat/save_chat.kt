import 'package:dartz/dartz.dart';
import '../../../core/errors/failure.dart';
import '../../entities/message.dart';
import '../../repositories/chat_repository.dart';

class SaveChat {
  final ChatRepository repository;

  SaveChat(this.repository);

  Future<Either<Failure, bool>> call(String chatName, List<Message> messages) async {
    // Проверяем имя чата
    if (chatName.trim().isEmpty) {
      return Left(ValidationFailure(
          message: 'Имя чата не может быть пустым'
      ));
    }

    // Проверяем наличие сообщений
    if (messages.isEmpty) {
      return Left(ValidationFailure(
          message: 'Список сообщений не может быть пустым'
      ));
    }

    // Делегируем работу репозиторию
    return repository.saveChat(chatName, messages);
  }
}