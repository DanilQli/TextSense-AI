import 'dart:async';
import 'package:dartz/dartz.dart';
import '../../../core/errors/failure.dart';
import '../../repositories/speech_repository.dart';

class ListenToSpeech {
  final SpeechRepository repository;

  ListenToSpeech(this.repository);

  Future<Either<Failure, Stream<String>>> call() async {
    try {
      // Проверяем доступность распознавания
      final availableResult = await repository.isAvailable();

      final available = availableResult.fold(
            (failure) => false,
            (available) => available,
      );

      if (!available) {
        // Инициализируем, если недоступно
        final initResult = await repository.initialize();

        final initialized = initResult.fold(
              (failure) => false,
              (initialized) => initialized,
        );

        if (!initialized) {
          return const Left(UnknownFailure(
              message: 'Не удалось инициализировать распознавание речи'
          ));
        }
      }

      // Останавливаем текущее прослушивание, если оно активно
      final listeningResult = await repository.isListening();

      final isListening = listeningResult.fold(
            (failure) => false,
            (isListening) => isListening,
      );

      if (isListening) {
        await repository.stopListening();
      }

      // Запускаем прослушивание
      return repository.startListening();
    } catch (e) {
      return Left(UnknownFailure(
          message: 'Произошла ошибка при запуске распознавания речи: $e'
      ));
    }
  }
}