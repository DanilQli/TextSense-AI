import 'package:get_it/get_it.dart';
import '../../presentation/bloc/language/language_bloc.dart';
import '../logger/app_logger.dart';
import '../services/translation_service.dart';

class Tr {
  static String get(String key, [String? languageCode]) {
    final service = GetIt.instance<TranslationService>();
    final code = languageCode ?? _getCurrentLanguage();
    return service.translate(key, code);
  }

  static String _getCurrentLanguage() {
    final languageBloc = GetIt.instance<LanguageBloc>();
    if (languageBloc.state is LanguageLoaded) {
      return (languageBloc.state as LanguageLoaded).languageCode;
    }
    return 'en';
  }

  static String t(String key) {
    final service = GetIt.instance<TranslationService>();
    String languageCode = 'en';

    try {
      if (GetIt.instance.isRegistered<LanguageBloc>()) {
        final languageBloc = GetIt.instance<LanguageBloc>();
        if (languageBloc.state is LanguageLoaded) {
          languageCode = (languageBloc.state as LanguageLoaded).languageCode;
          AppLogger.debug('Текущий язык из LanguageBloc: $languageCode');
        }
      }
    } catch (e) {
      AppLogger.error('Ошибка при получении текущего языка', e);
    }

    return service.translate(key, languageCode);
  }
  }