import 'dart:async';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/logger/app_logger.dart';

abstract class SpeechDataSource {
  Future<bool> initialize();
  Future<Stream<String>> startListening();
  Future<bool> stopListening();
  Future<bool> isAvailable();
  Future<bool> isListening();
  Future<void> dispose();
}

class SpeechDataSourceImpl implements SpeechDataSource {
  final stt.SpeechToText _speech;
  late var _textController = StreamController<String>.broadcast();

  SpeechDataSourceImpl({stt.SpeechToText? speech})
      : _speech = speech ?? stt.SpeechToText();

  @override
  Future<bool> initialize() async {
    try {
      // Проверяем разрешение на доступ к микрофону
      final status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw PermissionException('Доступ к микрофону не предоставлен');
      }

      // Инициализируем распознавание речи
      final available = await _speech.initialize(
        onStatus: _onStatusChange,
        onError: _onError,
      );

      AppLogger.debug('Инициализация речи: $available');
      return available;
    } catch (e) {
      if (e is PermissionException) rethrow;

      AppLogger.error('Ошибка при инициализации речи', e);
      throw Exception('Не удалось инициализировать распознавание речи: $e');
    }
  }

  void _onStatusChange(String status) {
    AppLogger.debug('Статус распознавания речи: $status');
  }

  void _onError(dynamic error) {
    AppLogger.error('Ошибка распознавания речи', error);
    _textController.addError(error);
  }

  @override
  Future<Stream<String>> startListening() async {
    try {
      // Проверяем, инициализирован ли движок распознавания
      if (!await isAvailable()) {
        await initialize();
      }

      // Проверяем, не слушаем ли уже
      if (await isListening()) {
        await stopListening();
      }

      // Переиспользуем существующий контроллер или создаем новый
      if (_textController.isClosed) {
        _textController = StreamController<String>.broadcast();
      }

      // Запускаем распознавание
      await _speech.listen(
        onResult: (result) {
          AppLogger.debug('Получен результат распознавания: ${result.recognizedWords} (финальный: ${result.finalResult})');

          // Добавляем результат в поток, даже если он не финальный
          if (result.recognizedWords.isNotEmpty) {
            _textController.add(result.recognizedWords);
          }

          // Если результат финальный, останавливаем распознавание
          if (result.finalResult) {
            AppLogger.debug('Получен финальный результат: ${result.recognizedWords}');
            // НЕ закрываем поток здесь, только добавляем результат
          }
        },
        listenFor: const Duration(seconds: 30), // Максимальное время слушания
        pauseFor: const Duration(seconds: 3), // Время паузы перед остановкой
        listenOptions: stt.SpeechListenOptions(
          partialResults: true,
        ), // Для получения промежуточных результатов
        localeId: 'ru_RU', // Можно сделать параметром
      );

      // Добавляем обработчик статуса
      _speech.statusListener = (status) {
        AppLogger.debug('Статус распознавания речи: $status');

        // Если статус "done" или "notListening", закрываем поток
        if (status == 'done' || status == 'notListening') {
          // Важно! НЕ закрываем поток сразу, даем время на обработку результатов
          Future.delayed(const Duration(milliseconds: 500), () {
            if (!_textController.isClosed) {
              _textController.close();
            }
          });
        }
      };

      AppLogger.debug('Распознавание речи запущено');
      return _textController.stream;
    } catch (e) {
      AppLogger.error('Ошибка при запуске распознавания речи', e);
      throw Exception('Не удалось запустить распознавание речи: $e');
    }
  }

  @override
  Future<bool> isAvailable() async {
    return _speech.isAvailable;
  }

  @override
  Future<bool> isListening() async {
    return _speech.isListening;
  }

  // Добавить метод
  Future<void> dispose() async {
    await stopListening();
    if (!_textController.isClosed) {
      _textController.close();
    }
  }

  @override
  Future<bool> stopListening() async {
    try {
      if (_speech.isListening) {
        _speech.stop();
        AppLogger.debug('Распознавание речи остановлено');
      }

      // Не закрываем контроллер здесь, чтобы можно было получить последние результаты
      // Это будет делаться в dispose или при необходимости

      return true;
    } catch (e) {
      AppLogger.error('Ошибка при остановке распознавания речи', e);
      throw Exception('Не удалось остановить распознавание речи: $e');
    }
  }


}