import 'package:dartz/dartz.dart';
import '../../../core/errors/failure.dart';
import '../../repositories/chat_repository.dart';

class DeleteChat {
  final ChatRepository repository;

  DeleteChat(this.repository);

  Future<Either<Failure, bool>> call(String chatName) async {
    // Проверяем имя чата
    if (chatName.trim().isEmpty) {
      return const Left(ValidationFailure(
          message: 'Имя чата не может быть пустым'
      ));
    }

    // Делегируем работу репозиторию
    return repository.deleteChat(chatName);
  }
}