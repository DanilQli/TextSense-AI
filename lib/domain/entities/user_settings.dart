import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../app.dart';

class UserSettings extends Equatable {
  final CustomThemeMode customThemeMode;
  final String languageCode;

  const UserSettings({
    this.customThemeMode = CustomThemeMode.system,
    this.languageCode = 'en',
  });

  UserSettings copyWith({
    CustomThemeMode? customThemeMode,
    String? languageCode,
  }) {
    return UserSettings(
      customThemeMode: customThemeMode ?? this.customThemeMode,
      languageCode: languageCode ?? this.languageCode,
    );
  }

  @override
  List<Object> get props => [customThemeMode, languageCode];
}