import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import '../../app.dart';
import '../../core/errors/failure.dart';
import '../entities/user_settings.dart';

abstract class SettingsRepository {
  /// Получает настройки пользователя
  Future<Either<Failure, UserSettings>> getSettings();

  /// Получает режим темы
  Future<Either<Failure, CustomThemeMode>> getThemeMode();

  /// Сохраняет режим темы
  Future<Either<Failure, bool>> saveThemeMode(CustomThemeMode themeMode);

  /// Получает код языка
  Future<Either<Failure, String>> getLanguageCode();

  /// Сохраняет код языка
  Future<Either<Failure, bool>> saveLanguageCode(String languageCode);
}