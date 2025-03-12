import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/chat/chat_bloc.dart';
import '../../bloc/language/language_bloc.dart';
import '../../bloc/theme/theme_bloc.dart';
import '../../../core/services/translation_service.dart';
import '../../../core/utils/datetime_utils.dart';

class LoadChatDialog extends StatefulWidget {
  const LoadChatDialog({Key? key}) : super(key: key);

  @override
  State<LoadChatDialog> createState() => _LoadChatDialogState();
}

class _LoadChatDialogState extends State<LoadChatDialog> {
  @override
  void initState() {
    super.initState();
    // Запрашиваем список сохраненных чатов при открытии диалога
    context.read<ChatBloc>().add(GetSavedChatsEvent());
  }

  Future<void> _showDeleteConfirmation(BuildContext context, String chatName) async {
    // Получаем текущий язык
    final languageState = context.read<LanguageBloc>().state;
    final languageCode = languageState is LanguageLoaded
        ? languageState.languageCode
        : 'en';

    final translations = TranslationService();
    final chatBloc = context.read<ChatBloc>();

    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(translations.translate(
              TranslationKeys.deleteChatConfirmationTitle,
              languageCode
          )),
          content: SingleChildScrollView(
            child: Text(
                '${translations.translate(TranslationKeys.deleteChatConfirmationMessage, languageCode)} "$chatName"?'
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(translations.translate(TranslationKeys.cancel, languageCode)),
              onPressed: () => Navigator.of(dialogContext).pop(false),
            ),
            TextButton(
              child: Text(translations.translate(TranslationKeys.delete, languageCode)),
              onPressed: () => Navigator.of(dialogContext).pop(true),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      // Удаляем чат и обновляем список
      chatBloc.add(DeleteChatEvent(chatName));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Получаем текущий язык
    final languageState = context.read<LanguageBloc>().state;
    final languageCode = languageState is LanguageLoaded
        ? languageState.languageCode
        : 'en';

    // Получаем текущую тему
    final themeState = context.read<ThemeBloc>().state;
    final isDarkMode = themeState is ThemeLoaded
        ? themeState.themeMode == ThemeMode.dark
        : false;

    final translations = TranslationService();

    // Применяем тему в соответствии с текущей темой приложения
    return Theme(
      data: isDarkMode
          ? ThemeData.dark().copyWith(
        dialogBackgroundColor: Colors.grey[850],
        colorScheme: const ColorScheme.dark(
          primary: Colors.blue,
          onPrimary: Colors.white,
          secondary: Colors.blueAccent,
        ),
      )
          : ThemeData.light().copyWith(
        dialogBackgroundColor: Colors.white,
        colorScheme: const ColorScheme.light(
          primary: Colors.blue,
          onPrimary: Colors.white,
          secondary: Colors.blueAccent,
        ),
      ),
      child: BlocBuilder<ChatBloc, ChatState>(
        buildWhen: (previous, current) =>
        current is ChatSavedChatsLoaded ||
            current is ChatLoading ||
            current is ChatError,
        builder: (context, state) {
          bool isLoading = true;
          Map<String, DateTime> savedChats = {};

          if (state is ChatSavedChatsLoaded) {
            savedChats = state.savedChats;
            isLoading = false;
          } else if (state is ChatError) {
            // Показываем ошибку загрузки
            return AlertDialog(
              title: Text(translations.translate(TranslationKeys.uploadChat, languageCode)),
              content: Text(state.message),
              actions: [
                TextButton(
                  child: Text(translations.translate(TranslationKeys.cancel, languageCode)),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            );
          }

          return AlertDialog(
            title: Text(translations.translate(TranslationKeys.uploadChat, languageCode)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            content: SizedBox(
              width: double.maxFinite,
              height: 300,
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _buildSavedChatsList(context, savedChats, languageCode),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(translations.translate(TranslationKeys.cancel, languageCode)),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSavedChatsList(BuildContext context, Map<String, DateTime> savedChats, String languageCode) {
    final translations = TranslationService();

    if (savedChats.isEmpty) {
      return Center(
        child: Text(translations.translate(TranslationKeys.noSavedChats, languageCode)),
      );
    }

    // Сортируем чаты по дате изменения (от новых к старым)
    final sortedEntries = savedChats.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: sortedEntries.length,
      itemBuilder: (context, index) {
        final chatName = sortedEntries[index].key;
        final lastModified = sortedEntries[index].value;

        // Форматируем дату в более читаемый вид
        final formattedDate = DateTimeUtils.formatDateTime(lastModified);

        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
          dense: true,
          title: Text(
            chatName,
            style: const TextStyle(fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            '${translations.translate(TranslationKeys.lastModified, languageCode)}: $formattedDate',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
            ),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            iconSize: 20,
            onPressed: () {
              Navigator.pop(context);
              _showDeleteConfirmation(context, chatName);
            },
          ),
          onTap: () {
            Navigator.pop(context);
            context.read<ChatBloc>().add(LoadChatEvent(chatName));
          },
        );
      },
    );
  }
}