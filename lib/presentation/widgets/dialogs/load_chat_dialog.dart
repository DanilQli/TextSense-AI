import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/translation_utils.dart';
import '../../../domain/entities/message.dart';
import '../../bloc/chat/chat_bloc.dart';
import '../../bloc/language/language_bloc.dart';
import '../../../core/services/translation_service.dart';
import '../../../core/utils/datetime_utils.dart';


class LoadChatDialog extends StatefulWidget {
  const LoadChatDialog({Key? key}) : super(key: key);

  @override
  State<LoadChatDialog> createState() => _LoadChatDialogState();
}

class _LoadChatDialogState extends State<LoadChatDialog> {
  // Сохраняем текущее состояние при инициализации
  List<Message>? _savedMessages;
  String? _savedChatName;
  bool _isStateRestored = false;

  @override
  void initState() {
    super.initState();

    // Сохраняем текущее состояние чата
    final chatBloc = context.read<ChatBloc>();
    if (chatBloc.state is ChatLoaded) {
      final loadedState = chatBloc.state as ChatLoaded;
      _savedMessages = List<Message>.from(loadedState.messages);
      _savedChatName = loadedState.currentChatName;
    }

    // Запрашиваем список сохраненных чатов при открытии диалога
    context.read<ChatBloc>().add(GetSavedChatsEvent());
  }

  @override
  void dispose() {
    // Восстанавливаем состояние при закрытии диалога, если не было выбрано другого чата
    if (!_isStateRestored && _savedMessages != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<ChatBloc>().add(RestoreStateEvent(
            messages: _savedMessages!,
            currentChatName: _savedChatName,
          ));
        }
      });
    }
    super.dispose();
  }

  Future<void> _showDeleteConfirmation(BuildContext context, String chatName) async {
    // Получаем текущий язык
    final languageState = context.read<LanguageBloc>().state;
    final languageCode = languageState is LanguageLoaded
        ? languageState.languageCode
        : 'en';

    final chatBloc = context.read<ChatBloc>();

    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(Tr.get(
              TranslationKeys.deleteChatConfirmationTitle,
              languageCode
          )),
          content: SingleChildScrollView(
            child: Text(
                '${Tr.get(TranslationKeys.deleteChatConfirmationMessage, languageCode)} "$chatName"?'
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(Tr.get(TranslationKeys.cancel, languageCode)),
              onPressed: () => Navigator.of(dialogContext).pop(false),
            ),
            TextButton(
              child: Text(Tr.get(TranslationKeys.delete, languageCode)),
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
    String languageCode = 'en';
    if (context.read<LanguageBloc>().state is LanguageLoaded) {
      languageCode = (context.read<LanguageBloc>().state as LanguageLoaded).languageCode;
    }

    // Получаем текущую тему
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

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
              title: Text(Tr.get(TranslationKeys.uploadChat, languageCode)),
              content: Text(state.message),
              actions: [
                TextButton(
                  child: Text(Tr.get(TranslationKeys.cancel, languageCode)),
                  onPressed: () {
                    Navigator.pop(context);

                    // Восстанавливаем предыдущее состояние
                    if (_savedMessages != null) {
                      _isStateRestored = true;
                      context.read<ChatBloc>().add(RestoreStateEvent(
                        messages: _savedMessages!,
                        currentChatName: _savedChatName,
                      ));
                    }
                  },
                ),
              ],
            );
          }

          return AlertDialog(
            title: Text(Tr.get(TranslationKeys.uploadChat, languageCode)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            content: SizedBox(
              width: double.maxFinite,
              height: 300,
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _buildChatList(context, savedChats, languageCode),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(Tr.get(TranslationKeys.cancel, languageCode)),
                onPressed: () {
                  Navigator.pop(context);

                  // Восстанавливаем предыдущее состояние
                  if (_savedMessages != null) {
                    _isStateRestored = true;
                    context.read<ChatBloc>().add(RestoreStateEvent(
                      messages: _savedMessages!,
                      currentChatName: _savedChatName,
                    ));
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildChatList(
      BuildContext context,
      Map<String, DateTime> savedChats,
      String languageCode) {

    if (savedChats.isEmpty) {
      return Center(
        child: Text(Tr.get(TranslationKeys.noSavedChats, languageCode)),
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
            '${Tr.get(TranslationKeys.lastModified, languageCode)}: $formattedDate',
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
            final chatBloc = context.read<ChatBloc>();
            // Отмечаем, что мы выбрали новый чат, так что не нужно восстанавливать старое состояние
            _isStateRestored = true;
            chatBloc.add(LoadChatEvent(chatName));
            Navigator.pop(context);
          },
        );
      },
    );
  }
}