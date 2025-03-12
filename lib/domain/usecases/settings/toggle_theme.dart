import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import '../../../core/errors/failure.dart';
import '../../repositories/settings_repository.dart';

class ToggleTheme {
  final SettingsRepository repository;

  ToggleTheme(this.repository);

  Future<Either<Failure, ThemeMode>> call() async {
    try {
      // Получаем текущую тему
      final currentThemeResult = await repository.getThemeMode();

      return currentThemeResult.fold(
            (failure) => Left(failure),
            (currentTheme) async {
          // Определяем новую тему
          final newTheme = currentTheme == ThemeMode.light
              ? ThemeMode.dark
              : ThemeMode.light;

          // Сохраняем новую тему
          final saveResult = await repository.saveThemeMode(newTheme);

          return saveResult.fold(
                (failure) => Left(failure),
                (_) => Right(newTheme),
          );
        },
      );
    } catch (e) {
      return Left(UnknownFailure(
          message: 'Произошла ошибка при переключении темы: $e'
      ));
    }
  }
}