import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import '../logger/app_logger.dart';
import '../errors/app_exception.dart';

class TranslationKeys {
  static const String settings = 'settings';
  static const String appearance = 'appearance';
  static const String theme = 'theme';
  static const String systemTheme = 'systemTheme';
  static const String lightTheme = 'lightTheme';
  static const String darkTheme = 'darkTheme';
  static const String language = 'language';
  static const String about = 'about';
  static const String version = 'version';
  static const String noMessages = 'noMessages';
  static const String startChat = 'startChat';
  static const String processingError = 'processingError';
  static const String recordVoice = 'recordVoice';
  static const String stopRecording = 'stopRecording';
  static const String classificationFailed = 'classificationFailed';
  static const String category = 'category';
  static const String confidence = 'confidence';
  static const String emotionalTone = 'emotionalTone';
  static const String switchToDarkTheme = 'switchToDarkTheme';
  static const String switchToLightTheme = 'switchToLightTheme';
  static const String savedChats = 'savedChats';
  static const String errorLoadingChats = 'errorLoadingChats';
  static const String appTitle = 'appTitle';
  static const String enterText = 'enterText';
  static const String emotionalColoring = 'emotionalColoring';
  static const String exportChat = 'exportChat';
  static const String chatHistory = 'chatHistory';
  static const String date = 'date';
  static const String user = 'user';
  static const String bot = 'bot';
  static const String errorProcessing = 'errorProcessing';
  static const String changeLanguage = 'changeLanguage';
  static const String newChat = 'newChat';
  static const String saveChat = 'saveChat';
  static const String renameChat = 'renameChat';
  static const String uploadChat = 'uploadChat';
  static const String exit = 'exit';
  static const String reaction = 'reaction';
  static const String translate = 'translate';
  static const String copy = 'copy';
  static const String delete = 'delete';
  static const String copied = 'copied';
  static const String deleteChatConfirmationTitle = 'deleteChatConfirmationTitle';
  static const String deleteChatConfirmationMessage = 'deleteChatConfirmationMessage';
  static const String cancel = 'cancel';
  static const String save = 'save';
  static const String rename = 'rename';
  static const String overwrite = 'overwrite';
  static const String chatNameLabel = 'chatNameLabel';
  static const String chatNameHint = 'chatNameHint';
  static const String chatNameEmptyError = 'chatNameEmptyError';
  static const String invalidFileName = 'invalidFileName';
  static const String chatExistsConfirmation = 'chatExistsConfirmation';
  static const String renameChatInfo = 'renameChatInfo';
  static const String chatSaved = 'chatSaved';
  static const String chatRenamed = 'chatRenamed';
  static const String overwriteChat = 'overwriteChat';
  static const String errorDeletingFile = 'errorDeletingFile';
  static const String noSavedChats = 'noSavedChats';
  static const String lastModified = 'lastModified';
  static const String newChatConfirmation = 'newChatConfirmation';
  static const String saveCurrentChatQuestion = 'saveCurrentChatQuestion';
  static const String dontSave = 'dontSave';
  static const String saveAndCreate = 'saveAndCreate';
  static const String defaultChatNameError = 'defaultChatNameError';
}

abstract class TranslationService {
  Future<void> loadTranslations();
  Map<String, dynamic> getTranslations(String languageCode);
  String translate(String key, String languageCode);
}

class TranslationServiceImpl implements TranslationService {
  Map<String, Map<String, dynamic>> _translations = {};

  static const List<String> _supportedLanguages = ['en', 'ru'];
  static const String _defaultLanguage = 'en';
  static const String _translationsPath = 'assets/localization/translations.json';

  @override
  Future<void> loadTranslations() async {
    try {
      AppLogger.debug('Загрузка переводов');
      final jsonString = await rootBundle.loadString(_translationsPath);
      final Map<String, dynamic> jsonMap = json.decode(jsonString);

      _translations = {};

      for (final language in _supportedLanguages) {
        if (jsonMap.containsKey(language)) {
          _translations[language] = Map<String, dynamic>.from(jsonMap[language]);
        }
      }

      AppLogger.debug('Переводы успешно загружены для языков: ${_translations.keys.join(", ")}');
    } catch (e) {
      AppLogger.error('Ошибка при загрузке переводов', e);
      throw FormatException('Не удалось загрузить переводы: $e');
    }
  }

  @override
  Map<String, dynamic> getTranslations(String languageCode) {
    if (_translations.isEmpty) {
      AppLogger.warning('Переводы не были загружены. Возвращаем пустой словарь.');
      return {};
    }

    if (_translations.containsKey(languageCode)) {
      return _translations[languageCode]!;
    }

    AppLogger.warning('Перевод для языка $languageCode не найден. Используем язык по умолчанию: $_defaultLanguage');
    return _translations[_defaultLanguage] ?? {};
  }

  @override
  String translate(String key, String languageCode) {
    final translations = getTranslations(languageCode);
    return translations[key] ?? key;
  }
}
TranslationService getTranslationService() {
  return GetIt.instance<TranslationService>();
}