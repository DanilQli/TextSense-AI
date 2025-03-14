//chat_app_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../app.dart';
import '../../config/routes.dart';
import '../../core/utils/translation_utils.dart';
import '../bloc/chat/chat_bloc.dart';
import '../bloc/theme/theme_bloc.dart';
import '../bloc/language/language_bloc.dart';
import 'dialogs/save_chat_dialog.dart';
import 'dialogs/new_chat_dialog.dart';
import 'dialogs/load_chat_dialog.dart';
import '../../core/constants/app_constants.dart';
import '../../core/services/translation_service.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    // Используем BlocBuilder для реагирования на изменения состояния чата
    return BlocBuilder<ChatBloc, ChatState>(
      buildWhen: (previous, current) =>
      (previous is ChatLoaded && current is ChatLoaded &&
          previous.currentChatName != current.currentChatName) ||
          (previous is! ChatLoaded && current is ChatLoaded) ||
          (previous is ChatLoaded && current is! ChatLoaded),
      builder: (context, chatState) {
        // Получаем текущее имя чата из состояния
        final String? currentChatName = chatState is ChatLoaded
            ? chatState.currentChatName
            : null;

        // Получаем текущую тему
        final themeState = context.watch<ThemeBloc>().state;
        final isDarkMode = themeState is ThemeLoaded
            ? themeState.customThemeMode == CustomThemeMode.dark
            : false;

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
                  currentChatName ?? Tr.get(TranslationKeys.appTitle),
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
              tooltip: Tr.get(TranslationKeys.exportChat),
            ),
            IconButton(
              icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
              onPressed: () => context.read<ThemeBloc>().add(ToggleThemeEvent()),
            ),
            PopupMenuButton<String>(
              itemBuilder: (BuildContext context) => [
                PopupMenuItem<String>(
                  value: 'new_chat',
                  child: Text(Tr.get(TranslationKeys.newChat)),
                  onTap: () => Future.delayed(
                    Duration.zero,
                        () => showDialog(
                      context: context,
                      builder: (dialogContext) => BlocProvider.value(
                        value: context.read<ChatBloc>(),
                        child: const NewChatDialog(),
                      ),
                    ),
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'save_chat',
                  child: Text(Tr.get(TranslationKeys.saveChat)),
                  onTap: () => Future.delayed(
                    Duration.zero,
                        () => showDialog(
                      context: context,
                      builder: (dialogContext) => BlocProvider.value(
                        value: context.read<ChatBloc>(),
                        child: SaveChatDialog(
                          initialName: currentChatName, // Передаем текущее имя чата
                        ),
                      ),
                    ),
                  ),
                ),
                // Показываем пункт "Переименовать" только если есть текущий чат
                if (currentChatName != null)
                  PopupMenuItem<String>(
                    value: 'rename_chat',
                    child: Text(Tr.get(TranslationKeys.renameChat)),
                    onTap: () => Future.delayed(
                      Duration.zero,
                          () => showDialog(
                        context: context,
                        builder: (dialogContext) => BlocProvider.value(
                          value: context.read<ChatBloc>(),
                          child: SaveChatDialog(
                            initialName: currentChatName,
                            isRename: true,
                          ),
                        ),
                      ),
                    ),
                  ),
                PopupMenuItem<String>(
                  value: 'load_chat',
                  child: Text(Tr.get(TranslationKeys.uploadChat)),
                  onTap: () => Future.delayed(
                    Duration.zero,
                        () => showDialog(
                      context: context,
                      builder: (dialogContext) => BlocProvider.value(
                        value: context.read<ChatBloc>(),
                        child: const LoadChatDialog(),
                      ),
                    ),
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'settings',
                  child: Text(Tr.get(TranslationKeys.settings)),
                  onTap: () => Navigator.pushNamed(context, AppRoutes.settings),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

}