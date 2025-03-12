import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class UserSettings extends Equatable {
  final ThemeMode themeMode;
  final String languageCode;

  const UserSettings({
    this.themeMode = ThemeMode.system,
    this.languageCode = 'en',
  });

  UserSettings copyWith({
    ThemeMode? themeMode,
    String? languageCode,
  }) {
    return UserSettings(
      themeMode: themeMode ?? this.themeMode,
      languageCode: languageCode ?? this.languageCode,
    );
  }

  @override
  List<Object> get props => [themeMode, languageCode];
}