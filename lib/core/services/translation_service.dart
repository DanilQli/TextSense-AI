import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import '../logger/app_logger.dart';
import '../errors/app_exception.dart';

class TranslationKeys {
  static const String couldNotClassifyText = "couldNotClassifyText";
  static const String back = "back";
  static const String day1 = "day1";
  static const String day2 = "day2";
  static const String day3 = "day3";
  static const String hour1 = "hour1";
  static const String hour2 = "hour2";
  static const String hour3 = "hour3";
  static const String minute1 = "minute1";
  static const String minute2 = "minute2";
  static const String minute3 = "minute3";
  static const String routeNotFound = "routeNotFound";
  static const String errorNum1 = "errorNum1";
  static const String errorNum2 = "errorNum2";
  static const String errorNum3 = "errorNum3";
  static const String errorNum4 = "errorNum4";
  static const String errorNum5 = "errorNum5";
  static const String errorNum6 = "errorNum6";
  static const String errorNum7 = "errorNum7";
  static const String errorNum8 = "errorNum8";
  static const String errorNum9 = "errorNum9";
  static const String errorNum10 = "errorNum10";
  static const String errorNum11 = "errorNum11";
  static const String errorNum12 = "errorNum12";
  static const String errorNum13 = "errorNum13";
  static const String errorNum14 = "errorNum14";
  static const String errorNum15 = "errorNum15";
  static const String errorNum16 = "errorNum16";
  static const String errorNum17 = "errorNum17";
  static const String errorNum18 = "errorNum18";
  static const String errorNum19 = "errorNum19";
  static const String errorNum20 = "errorNum20";
  static const String errorNum21 = "errorNum21";
  static const String errorNum22 = "errorNum22";
  static const String errorNum23 = "errorNum23";
  static const String applicationDescription = "applicationDescription";
  static const String rightsReserved = "rightsReserved";
  static const String settings = 'settings';
  static const String appearance = 'appearance';
  static const String theme = 'theme';
  static const String systemTheme = 'systemTheme';
  static const String lightTheme = 'lightTheme';
  static const String darkTheme = 'darkTheme';
  static const String blueTheme = 'blueTheme';
  static const String greenTheme = 'greenTheme';
  static const String orangeTheme = 'orangeTheme';
  static const String royalPurpleTheme = "royalPurpleTheme";
  static const String amethystDarkTheme = "amethystDarkTheme";
  static const String coffeeTheme = "coffeeTheme";
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
  List<String> get supportedLanguageCodes;
  String getLanguageName(String code);
}

class TranslationServiceImpl implements TranslationService {
  Map<String, Map<String, dynamic>> _translations = {};
  static late List<Map<String, dynamic>> _supportedLanguages;

  static const String _defaultLanguage = 'en';
  static const String _translationsPath = 'assets/localization/translations.json';
  final Map<String, String> _translationCache = {};  // Кэш для переводов

  static Future<void> loadSupportedLanguages() async {
    try {
      String jsonString = await rootBundle.loadString('assets/localization/supported_languages.json');
      Map<String, dynamic> jsonData = json.decode(jsonString);
      _supportedLanguages = (jsonData['supportedLanguages'] as List)
          .map((lang) => {"code": lang['code'], "name": lang['name']})
          .toList();
    } catch (e) {
      throw Exception("Ошибка загрузки списка языков: $e");
    }
  }

  @override
  List<String> get supportedLanguageCodes => _supportedLanguages.map((lang) => lang['code'] as String).toList();

  @override
  String getLanguageName(String code) => _supportedLanguages.firstWhere((lang) => lang['code'] == code, orElse: () => {"name": "Unknown"})["name"] as String;


  @override
  String translate(String key, String languageCode) {
  // Создаем составной ключ для кэша
  final cacheKey = '$languageCode:$key';

  // Проверяем кэш
  if (_translationCache.containsKey(cacheKey)) {
  return _translationCache[cacheKey]!;
  }

  // Получаем перевод
  final translations = getTranslations(languageCode);
  final translation = translations[key] ?? key;

  // Кэшируем результат
  _translationCache[cacheKey] = translation;

  return translation;
  }

  // Метод для очистки кэша при смене языка
  void clearCache() {
  _translationCache.clear();
  }

  @override
  Future<void> loadTranslations() async {
    try {
      AppLogger.debug('Загрузка переводов');
      final jsonString = await rootBundle.loadString(_translationsPath);
      final Map<String, dynamic> jsonMap = json.decode(jsonString);

      _translations = {};

      for (final language in _supportedLanguages) {
        final langCode = language['code'] as String; // Извлекаем код языка
        if (jsonMap.containsKey(langCode)) {
          _translations[langCode] = Map<String, dynamic>.from(jsonMap[langCode]);
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
}
TranslationService getTranslationService() {
  return GetIt.instance<TranslationService>();
}