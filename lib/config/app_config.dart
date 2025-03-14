import 'package:flutter/material.dart';

class AppConfig {
  // Приватный статический экземпляр для паттерна Singleton
  static final AppConfig _instance = AppConfig._internal();

  // Фабричный конструктор, возвращающий экземпляр Singleton
  factory AppConfig() {
    return _instance;
  }

  // Приватный конструктор для Singleton
  AppConfig._internal();

  // Настройки по умолчанию
  String apiUrl = 'http://localhost:5000/';
  bool isDevelopment = true;
  int apiTimeout = 30;
  String appVersionName = '1.0.0';
  int appVersionCode = 1;
  bool isDebugLoggingEnabled = true;

  // Метод для инициализации конфигурации разработки
  void setupDevelopment() {
    apiUrl = 'http://localhost:5000/';
    isDevelopment = true;
    apiTimeout = 30;
    appVersionName = '1.0.0';
    appVersionCode = 1;
    isDebugLoggingEnabled = true;
  }

  // Метод для инициализации продакшн-конфигурации
  void setupProduction() {
    apiUrl = 'http://lobste.pythonanywhere.com';
    isDevelopment = false;
    apiTimeout = 60;
    appVersionName = '1.0.0';
    appVersionCode = 1;
    isDebugLoggingEnabled = false;
  }

  // Дополнительные настройки приложения
  String currentLanguage = 'en';
  ThemeMode themeMode = ThemeMode.system;

  // Метод для обновления языка
  void updateLanguage(String languageCode) {
    currentLanguage = languageCode;
  }

  // Метод для обновления темы
  void updateThemeMode(ThemeMode newThemeMode) {
    themeMode = newThemeMode;
  }
}