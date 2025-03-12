import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/theme/theme_bloc.dart';
import '../bloc/language/language_bloc.dart';
import '../widgets/settings_section.dart';
import '../../core/services/translation_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Получаем текущий язык
    final languageState = context.watch<LanguageBloc>().state;
    final languageCode = languageState is LanguageLoaded
        ? languageState.languageCode
        : 'en';

    // Получаем текущую тему
    final themeState = context.watch<ThemeBloc>().state;
    final themeMode = themeState is ThemeLoaded
        ? themeState.themeMode
        : ThemeMode.system;


    return Scaffold(
      appBar: AppBar(
        title: Text("settings"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Секция настроек темы
          SettingsSection(
            title: "appearance",
            children: [
              ListTile(
                title: Text("theme"),
                trailing: DropdownButton<ThemeMode>(
                  value: themeMode,
                  items: [
                    DropdownMenuItem(
                      value: ThemeMode.system,
                      child: Text("systemTheme"),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.light,
                      child: Text("systemTheme"),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.dark,
                      child: Text("darkTheme"),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      context.read<ThemeBloc>().add(SetSpecificTheme(value));
                    }
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Секция настроек языка
          SettingsSection(
            title: "language",
            children: [
              RadioListTile<String>(
                title: const Text('English'),
                value: 'en',
                groupValue: languageCode,
                onChanged: (value) {
                  if (value != null) {
                    context.read<LanguageBloc>().add(ChangeLanguageEvent(value));
                  }
                },
              ),
              RadioListTile<String>(
                title: const Text('Русский'),
                value: 'ru',
                groupValue: languageCode,
                onChanged: (value) {
                  if (value != null) {
                    context.read<LanguageBloc>().add(ChangeLanguageEvent(value));
                  }
                },
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Секция информации о приложении
          SettingsSection(
            title: "about",
            children: [
              ListTile(
                title: Text("version"),
                trailing: const Text('1.0.0'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}