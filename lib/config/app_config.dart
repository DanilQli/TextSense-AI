class AppConfig {
  final String apiUrl;
  final bool isDevelopment;
  final int apiTimeout;
  final String appVersionName;
  final int appVersionCode;
  final bool isDebugLoggingEnabled;

  const AppConfig({
    required this.apiUrl,
    required this.isDevelopment,
    required this.apiTimeout,
    required this.appVersionName,
    required this.appVersionCode,
    required this.isDebugLoggingEnabled,
  });

  // Конфигурация для режима разработки
  factory AppConfig.development() {
    return const AppConfig(
      apiUrl: 'http://localhost:5000/',
      isDevelopment: true,
      apiTimeout: 30,
      appVersionName: '1.0.0',
      appVersionCode: 1,
      isDebugLoggingEnabled: true,
    );
  }

  // Конфигурация для продакшн-режима
  factory AppConfig.production() {
    return const AppConfig(
      apiUrl: 'http://lobste.pythonanywhere.com',
      isDevelopment: false,
      apiTimeout: 60,
      appVersionName: '1.0.0',
      appVersionCode: 1,
      isDebugLoggingEnabled: false,
    );
  }
}