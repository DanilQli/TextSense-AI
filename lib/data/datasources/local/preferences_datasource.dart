import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../app.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/logger/app_logger.dart';

abstract class PreferencesDataSource {
  Future<CustomThemeMode> getThemeMode();
  Future<bool> saveThemeMode(CustomThemeMode customThemeMode);
  Future<String> getLanguageCode();
  Future<bool> saveLanguageCode(String languageCode);
}

class PreferencesDataSourceImpl implements PreferencesDataSource {
  final SharedPreferences prefs;

  static const String _themeKey = 'theme_mode';
  static const String _languageKey = 'language_code';

  PreferencesDataSourceImpl({required this.prefs});

  @override
  Future<CustomThemeMode> getThemeMode() async {
    try {
      final themeIndex = prefs.getInt(_themeKey);

      if (themeIndex == null) {
        return CustomThemeMode.system;
      }

      // Безопасное получение значения из enum
      if (themeIndex >= 0 && themeIndex < CustomThemeMode.values.length) {
        return CustomThemeMode.values[themeIndex];
      }

      return CustomThemeMode.system;
    } catch (e) {
      AppLogger.error('Ошибка при получении настройки темы', e);
      throw CacheException('Не удалось получить настройку темы: $e');
    }
  }

  @override
  Future<bool> saveThemeMode(CustomThemeMode customThemeMode) async {
    try {
      final result = await prefs.setInt(_themeKey, customThemeMode.index);
      return result;
    } catch (e) {
      AppLogger.error('Ошибка при сохранении настройки темы', e);
      throw CacheException('Не удалось сохранить настройку темы: $e');
    }
  }

  @override
  Future<String> getLanguageCode() async {
    try {
      final languageCode = prefs.getString(_languageKey);

      if (languageCode == null || languageCode.isEmpty) {
        return 'en';
      }

      return languageCode;
    } catch (e) {
      AppLogger.error('Ошибка при получении настройки языка', e);
      throw CacheException('Не удалось получить настройку языка: $e');
    }
  }

  @override
  Future<bool> saveLanguageCode(String languageCode) async {
    try {
      // Валидируем код языка
      if (languageCode.isEmpty || languageCode.length > 10) {
        throw CacheException('Недопустимый код языка');
      }

      final result = await prefs.setString(_languageKey, languageCode);
      return result;
    } catch (e) {
      AppLogger.error('Ошибка при сохранении настройки языка', e);
      throw CacheException('Не удалось сохранить настройку языка: $e');
    }
  }
}