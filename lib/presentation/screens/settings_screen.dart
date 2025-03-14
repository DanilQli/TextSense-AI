import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../app.dart';
import '../../config/app_config.dart';
import '../../core/utils/translation_utils.dart';
import '../bloc/theme/theme_bloc.dart';
import '../bloc/language/language_bloc.dart';
import '../widgets/settings_section.dart';
import '../../core/services/translation_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Получаем текущий язык
    final languageState = context.watch<LanguageBloc>().state;
    final languageCode = languageState is LanguageLoaded
        ? languageState.languageCode
        : 'en';

    // Получаем текущую тему
    final themeState = context.watch<ThemeBloc>().state;
    final customThemeMode = themeState is ThemeLoaded
        ? themeState.customThemeMode
        : CustomThemeMode.system;
    final TranslationServiceImpl translationService = TranslationServiceImpl();

    return Scaffold(
      appBar: AppBar(
        title: Text(Tr.get(TranslationKeys.settings)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Секция настроек темы
          SettingsSection(
            title: Tr.get(TranslationKeys.appearance),
            children: [
              ListTile(
                title: Text(Tr.get(TranslationKeys.theme)),
                trailing: DropdownButton<CustomThemeMode>(
                  value: customThemeMode,
                  items: [
                    DropdownMenuItem(
                      value: CustomThemeMode.system,
                      child: Text(Tr.get(TranslationKeys.systemTheme)),
                    ),
                    DropdownMenuItem(
                      value: CustomThemeMode.light,
                      child: Text(Tr.get(TranslationKeys.lightTheme)),
                    ),
                    DropdownMenuItem(
                      value: CustomThemeMode.blue,
                      child: Text(Tr.get(TranslationKeys.blueTheme)),
                    ),
                    DropdownMenuItem(
                      value: CustomThemeMode.green,
                      child: Text(Tr.get(TranslationKeys.greenTheme)),
                    ),
                    DropdownMenuItem(
                      value: CustomThemeMode.orange,
                      child: Text(Tr.get(TranslationKeys.orangeTheme)),
                    ),
                    DropdownMenuItem(
                      value: CustomThemeMode.royalPurple,
                      child: Text(Tr.get(TranslationKeys.royalPurpleTheme)),
                    ),
                    DropdownMenuItem(
                      value: CustomThemeMode.amethystDark,
                      child: Text(Tr.get(TranslationKeys.amethystDarkTheme)),
                    ),
                    DropdownMenuItem(
                      value: CustomThemeMode.coffee,
                      child: Text(Tr.get(TranslationKeys.coffeeTheme)),
                    ),
                    DropdownMenuItem(
                      value: CustomThemeMode.dark,
                      child: Text(Tr.get(TranslationKeys.darkTheme)),
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
            title: Tr.get(TranslationKeys.language),
            children: [
              ...translationService.supportedLanguageCodes.map((code) {
                return RadioListTile<String>(
                  title: Text(translationService.getLanguageName(code)),
                  value: code,
                  groupValue: languageCode,
                  onChanged: (value) {
                    if (value != null) {
                      context.read<LanguageBloc>().add(ChangeLanguageEvent(value));
                    }
                  },
                );
              }),],
          ),

          const SizedBox(height: 16),

          // Секция информации о приложении
          SettingsSection(
            title: Tr.get(TranslationKeys.about),
            children: [
              ListTile(
                title: Text(Tr.get(TranslationKeys.version)),
                trailing: Text(AppConfig().appVersionName),
                onTap: () => _showAboutDialog(context, languageCode),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context, String languageCode) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(Tr.get(TranslationKeys.about)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(Tr.get(TranslationKeys.appTitle)),
              const SizedBox(height: 8),
              Text('${Tr.get(TranslationKeys.version)}: ${AppConfig().appVersionName}'),
              const SizedBox(height: 16),
              Text(Tr.get(TranslationKeys.applicationDescription),
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 8),
              Text(Tr.get(TranslationKeys.rightsReserved),
                style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(Tr.get(TranslationKeys.cancel)),
            ),
          ],
        );
      },
    );
  }
}