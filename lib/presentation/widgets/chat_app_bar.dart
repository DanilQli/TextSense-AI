//chat_app_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/chat/chat_bloc.dart';
import '../bloc/theme/theme_bloc.dart';
import '../bloc/language/language_bloc.dart';
import 'dialogs/save_chat_dialog.dart';
import 'dialogs/new_chat_dialog.dart';
import 'dialogs/load_chat_dialog.dart';
import '../../core/constants/app_constants.dart';
import '../../core/services/translation_service.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final chatBloc = context.read<ChatBloc>();
    final languageBloc = context.read<LanguageBloc>();
    final themeBloc = context.read<ThemeBloc>();

    // Получаем текущий язык
    String languageCode = 'en';
    if (languageBloc.state is LanguageLoaded) {
      languageCode = (languageBloc.state as LanguageLoaded).languageCode;
    }

    // Получаем текущую тему
    bool isDarkMode = false;
    if (themeBloc.state is ThemeLoaded) {
      isDarkMode = (themeBloc.state as ThemeLoaded).themeMode == ThemeMode.dark;
    }

    // Получаем текущее имя чата
    String? currentChatName;
    if (chatBloc.state is ChatLoaded) {
      currentChatName = (chatBloc.state as ChatLoaded).currentChatName;
    }

    return AppBar(
      title: Row(
        children: [
          Icon(
            AppConstants.botIcon,
            color: Theme.of(context).appBarTheme.titleTextStyle?.color,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              currentChatName ?? TranslationService().translate(TranslationKeys.appTitle, languageCode),
              style: const TextStyle(fontSize: 18),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.download),
          onPressed: () => context.read<ChatBloc>().add(ExportChatEvent()),
          tooltip: TranslationService().translate(TranslationKeys.exportChat, languageCode),
        ),
        IconButton(
          icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
          onPressed: () => context.read<ThemeBloc>().add(ToggleThemeEvent()),
        ),
        PopupMenuButton<String>(
          itemBuilder: (BuildContext context) => [
            PopupMenuItem<String>(
              value: 'new_chat',
              child: Text(TranslationService().translate(TranslationKeys.newChat, languageCode)),
              onTap: () => Future.delayed(
                Duration.zero,
                    () => showDialog(
                  context: context,
                  builder: (context) => const NewChatDialog(),
                ),
              ),
            ),
            PopupMenuItem<String>(
              value: 'save_chat',
              child: Text(TranslationService().translate(TranslationKeys.saveChat, languageCode)),
              onTap: () => Future.delayed(
                Duration.zero,
                    () => showDialog(
                  context: context,
                  builder: (context) => const SaveChatDialog(),
                ),
              ),
            ),
            if (currentChatName != null)
              PopupMenuItem<String>(
                value: 'rename_chat',
                child: Text(TranslationService().translate(TranslationKeys.renameChat, languageCode)),
                onTap: () => Future.delayed(
                  Duration.zero,
                      () => showDialog(
                    context: context,
                    builder: (context) => SaveChatDialog(
                      initialName: currentChatName,
                      isRename: true,
                    ),
                  ),
                ),
              ),
            PopupMenuItem<String>(
              value: 'load_chat',
              child: Text(TranslationService().translate(TranslationKeys.uploadChat, languageCode)),
              onTap: () => Future.delayed(
                Duration.zero,
                    () => showDialog(
                  context: context,
                  builder: (context) => const LoadChatDialog(),
                ),
              ),
            ),
            PopupMenuItem<String>(
              value: 'language',
              child: Text(TranslationService().translate(TranslationKeys.changeLanguage, languageCode)),
              onTap: () => Future.delayed(
                Duration.zero,
                    () => _showLanguageMenu(context, languageCode),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showLanguageMenu(BuildContext context, String currentLanguageCode) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(TranslationService().translate(TranslationKeys.changeLanguage, currentLanguageCode)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                value: 'en',
                groupValue: currentLanguageCode,
                onChanged: (value) {
                  context.read<LanguageBloc>().add(ChangeLanguageEvent(value!));
                  Navigator.pop(context);
                },
                title: const Text('English'),
              ),
              RadioListTile<String>(
                value: 'ru',
                groupValue: currentLanguageCode,
                onChanged: (value) {
                  context.read<LanguageBloc>().add(ChangeLanguageEvent(value!));
                  Navigator.pop(context);
                },
                title: const Text('Русский'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(TranslationService().translate(TranslationKeys.cancel, currentLanguageCode)),
            ),
          ],
        );
      },
    );
  }
}