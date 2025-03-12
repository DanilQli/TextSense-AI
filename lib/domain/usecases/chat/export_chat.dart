import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/errors/failure.dart';
import '../../entities/message.dart';
import '../../repositories/chat_repository.dart';
import '../../../core/logger/app_logger.dart';
import '../../../core/utils/datetime_utils.dart';

class ExportChat {
  final ChatRepository repository;

  ExportChat(this.repository);

  Future<Either<Failure, String>> call(
      String chatName,
      Map<String, String> translations,
      String currentLanguage
      ) async {
    try {
      // Загружаем чат
      final messagesResult = await repository.loadChat(chatName);

      return messagesResult.fold(
              (failure) => Left(failure),
              (messages) async {
            if (messages.isEmpty) {
              return Left(ValidationFailure(
                  message: 'Чат пуст'
              ));
            }

            final filePath = await _exportToFile(messages, translations.cast<String, Map<String, String>>(), currentLanguage);
            return Right(filePath);
          }
      );
    } catch (e) {
      AppLogger.error('Ошибка при экспорте чата', e);
      return Left(UnknownFailure(
          message: 'Произошла ошибка при экспорте чата: $e'
      ));
    }
  }

  Future<String> _exportToFile(
      List<Message> messages,
      Map<String, Map<String, String>> translations,
      String currentLanguage
      ) async {
    final texts = translations[currentLanguage] ?? {};

    final StringBuffer buffer = StringBuffer();
    buffer.writeln("${texts['chatHistory']}");
    buffer.writeln("${texts['date']}: ${DateTimeUtils.formatDateTime(DateTime.now())}");
    buffer.writeln("------------------------");

    for (final msg in messages) {
      final sender = msg.isUser ? texts['user'] : texts['bot'];
      final time = DateTimeUtils.formatTime(msg.timestamp);

      buffer.writeln("$sender ($time):");
      buffer.writeln(msg.text);
      buffer.writeln("------------------------");
    }

    // Сохраняем в файл
    final directory = await getTemporaryDirectory();
    final fileName = 'chat_export_${DateTime.now().millisecondsSinceEpoch}.txt';
    final filePath = '${directory.path}/$fileName';
    final file = File(filePath);

    await file.writeAsString(buffer.toString());

    // Отправляем на шаринг
    await Share.shareXFiles([XFile(filePath)], text: texts['exportChat']);

    return filePath;
  }
}