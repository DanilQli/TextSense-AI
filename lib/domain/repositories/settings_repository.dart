import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import '../../core/errors/failure.dart';
import '../entities/user_settings.dart';

abstract class SettingsRepository {
  /// Получает настройки пользователя
  Future<Either<Failure, UserSettings>> getSettings();

  /// Получает режим темы
  Future<Either<Failure, ThemeMode>> getThemeMode();

  /// Сохраняет режим темы
  Future<Either<Failure, bool>> saveThemeMode(ThemeMode themeMode);

  /// Получает код языка
  Future<Either<Failure, String>> getLanguageCode();

  /// Сохраняет код языка
  Future<Either<Failure, bool>> saveLanguageCode(String languageCode);
}