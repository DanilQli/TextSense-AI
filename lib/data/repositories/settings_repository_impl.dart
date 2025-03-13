import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../domain/entities/user_settings.dart';
import '../../core/errors/failure.dart';
import '../../core/errors/app_exception.dart';
import '../datasources/local/preferences_datasource.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final PreferencesDataSource dataSource;

  SettingsRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, UserSettings>> getSettings() async {
    try {
      final themeMode = await dataSource.getThemeMode();
      final languageCode = await dataSource.getLanguageCode();

      final settings = UserSettings(
        themeMode: themeMode,
        languageCode: languageCode,
      );

      return Right(settings);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: 'Ошибка при получении настроек: $e'));
    }
  }

  @override
  Future<Either<Failure, ThemeMode>> getThemeMode() async {
    try {
      final themeMode = await dataSource.getThemeMode();
      return Right(themeMode);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: 'Ошибка при получении темы: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> saveThemeMode(ThemeMode themeMode) async {
    try {
      final success = await dataSource.saveThemeMode(themeMode);
      return Right(success);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: 'Ошибка при сохранении темы: $e'));
    }
  }

  @override
  Future<Either<Failure, String>> getLanguageCode() async {
    try {
      final languageCode = await dataSource.getLanguageCode();
      return Right(languageCode);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: 'Ошибка при получении языка: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> saveLanguageCode(String languageCode) async {
    try {
      final success = await dataSource.saveLanguageCode(languageCode);
      return Right(success);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: 'Ошибка при сохранении языка: $e'));
    }
  }
}