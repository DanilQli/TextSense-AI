import 'package:get_it/get_it.dart';
import '../services/translation_service.dart';
import '../../config/app_config.dart';

class Tr {
  static String get(String key, [String? languageCode]) {
    final service = GetIt.instance<TranslationService>();
    final code = languageCode ?? _getCurrentLanguage();
    return service.translate(key, code);
  }

  static String _getCurrentLanguage() {
    // Используем AppConfig для получения текущего языка
    return AppConfig().currentLanguage;
  }
}