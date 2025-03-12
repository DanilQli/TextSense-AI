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
  Future<List<String>> getAvailableLocales();
}

class SpeechDataSourceImpl implements SpeechDataSource {
  final stt.SpeechToText _speech;
  final _textController = StreamController<String>.broadcast();

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

      // Запускаем распознавание
      await _speech.listen(
        onResult: (result) {
          if (result.finalResult) {
            _textController.add(result.recognizedWords);
          }
        },
        listenFor: const Duration(seconds: 30), // Максимальное время слушания
        pauseFor: const Duration(seconds: 3), // Время паузы перед остановкой
        partialResults: true, // Для получения промежуточных результатов
        localeId: 'ru_RU', // Можно сделать параметром
      );

      AppLogger.debug('Распознавание речи запущено');
      return _textController.stream;
    } catch (e) {
      AppLogger.error('Ошибка при запуске распознавания речи', e);
      throw Exception('Не удалось запустить распознавание речи: $e');
    }
  }

  @override
  Future<bool> stopListening() async {
    try {
      if (_speech.isListening) {
        _speech.stop();
        AppLogger.debug('Распознавание речи остановлено');
      }
      return true;
    } catch (e) {
      AppLogger.error('Ошибка при остановке распознавания речи', e);
      throw Exception('Не удалось остановить распознавание речи: $e');
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

  @override
  Future<List<String>> getAvailableLocales() async {
    try {
      if (!await isAvailable()) {
        await initialize();
      }

      final locales = await _speech.locales();
      return locales.map((locale) => locale.localeId).toList();
    } catch (e) {
      AppLogger.error('Ошибка при получении доступных локалей', e);
      throw Exception('Не удалось получить список доступных локалей: $e');
    }
  }
}