import 'package:translator/translator.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/logger/app_logger.dart';

class TranslationException extends AppException {
  TranslationException(String message, [dynamic originalError])
      : super(message, originalError);
}

abstract class TranslatorDataSource {
  Future<String> translate(String text, String targetLanguage);
  Future<String> detectLanguage(String text);
  Future<List<String>> getSupportedLanguages();
}

class TranslatorDataSourceImpl implements TranslatorDataSource {
  final GoogleTranslator translator;

  TranslatorDataSourceImpl({GoogleTranslator? translator})
      : translator = translator ?? GoogleTranslator();

  @override
  Future<String> translate(String text, String targetLanguage) async {
    try {
      if (text.trim().isEmpty) {
        return text;
      }

      AppLogger.debug('Перевод текста на язык: $targetLanguage');
      final result = await translator.translate(
        text,
        to: targetLanguage,
      );

      AppLogger.debug('Перевод выполнен успешно');
      return result.text;
    } catch (e) {
      AppLogger.error('Ошибка при переводе текста', e);
      throw TranslationException('Не удалось перевести текст: $e');
    }
  }

  @override
  Future<String> detectLanguage(String text) async {
    try {
      if (text.trim().isEmpty) {
        return 'en';
      }

      final result = await translator.translate(text);
      return result.sourceLanguage.code;
    } catch (e) {
      AppLogger.error('Ошибка при определении языка', e);
      throw TranslationException('Не удалось определить язык текста: $e');
    }
  }

  @override
  Future<List<String>> getSupportedLanguages() async {
    try {
      // В Google Translator нет прямого API для получения поддерживаемых языков,
      // поэтому мы используем заранее известный список
      return [
        'en', 'ru', 'es', 'fr', 'de', 'it', 'pt', 'nl', 'pl', 'zh-cn',
        'ja', 'ko', 'ar', 'hi', 'tr', 'cs', 'sv', 'da', 'fi', 'el',
      ];
    } catch (e) {
      AppLogger.error('Ошибка при получении списка языков', e);
      throw TranslationException('Не удалось получить список поддерживаемых языков: $e');
    }
  }
}