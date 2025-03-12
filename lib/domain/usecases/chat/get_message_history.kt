import 'package:dartz/dartz.dart';
import '../../../core/errors/failure.dart';
import '../../entities/message.dart';
import '../../repositories/chat_repository.dart';

class GetMessageHistory {
  final ChatRepository repository;

  GetMessageHistory(this.repository);

  Future<Either<Failure, List<Message>>> call([String? chatName]) async {
    // Если имя чата не указано, используем текущий (временный) чат
    final name = chatName ?? 'current';

    try {
      final result = await repository.loadChat(name);

      return result.fold(
            (failure) {
          // Если чат не найден, возвращаем пустой список сообщений без ошибки
          if (failure is FileOperationFailure &&
              failure.message.contains('не найден')) {
            return const Right([]);
          }

          // Иначе прокидываем ошибку
          return Left(failure);
        },
            (messages) => Right(messages),
      );
    } catch (e) {
      return Left(UnknownFailure(
          message: 'Произошла ошибка при загрузке истории сообщений: $e'
      ));
    }
  }
}