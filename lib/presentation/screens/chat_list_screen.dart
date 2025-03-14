//chat_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/utils/translation_utils.dart';
import '../bloc/chat/chat_bloc.dart';
import '../bloc/language/language_bloc.dart';
import '../widgets/dialogs/confirmation_dialog.dart';
import '../../core/services/translation_service.dart';
import '../../core/utils/datetime_utils.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  bool _isFirstLoad = true;

  @override
  void initState() {
    super.initState();
    // Загружаем чаты только если это первая загрузка
    if (_isFirstLoad) {
      _isFirstLoad = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<ChatBloc>().add(GetSavedChatsEvent());
      });
    }
  }

  void _showDeleteConfirmation(BuildContext context, String chatName) {
    // Получаем текущий язык
    final languageState = context.read<LanguageBloc>().state;
    final languageCode = languageState is LanguageLoaded
        ? languageState.languageCode
        : 'en';

    showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        titleKey: TranslationKeys.deleteChatConfirmationTitle,
        messageKey: TranslationKeys.deleteChatConfirmationMessage,
        message: '${Tr.get(TranslationKeys.deleteChatConfirmationMessage, languageCode)} "$chatName"?',
        confirmKey: TranslationKeys.delete,
        isDanger: true,
        onConfirm: () {
          context.read<ChatBloc>().add(DeleteChatEvent(chatName));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(Tr.get('savedChats')),
      ),
      body: BlocConsumer<ChatBloc, ChatState>(
        listenWhen: (previous, current) =>
        current is ChatDeleted || current is ChatError,
        listener: (context, state) {
          if (state is ChatDeleted) {
            // После удаления чата запрашиваем обновление списка
            context.read<ChatBloc>().add(GetSavedChatsEvent());
          } else if (state is ChatError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        buildWhen: (previous, current) =>
        current is ChatSavedChatsLoaded ||
            current is ChatLoading ||
            current is ChatError,
        builder: (context, state) {
          if (state is ChatLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ChatError) {
            return Center(child: Text(state.message));
          } else if (state is ChatSavedChatsLoaded) {
            final savedChats = state.savedChats;

            if (savedChats.isEmpty) {
              return Center(
                child: Text(Tr.get(TranslationKeys.noSavedChats)),
              );
            }

            // Сортируем чаты по дате изменения (от новых к старым)
            final sortedEntries = savedChats.entries.toList()
              ..sort((a, b) => b.value.compareTo(a.value));

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: sortedEntries.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final chatName = sortedEntries[index].key;
                final lastModified = sortedEntries[index].value;

                // Форматируем дату в более читаемый вид
                final formattedDate = DateTimeUtils.formatDateTime(lastModified);

                return ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: Theme.of(context).dividerColor,
                      width: 1,
                    ),
                  ),
                  leading: const CircleAvatar(
                    child: Icon(Icons.chat),
                  ),
                  title: Text(
                    chatName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${Tr.get(TranslationKeys.lastModified)}: $formattedDate',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _showDeleteConfirmation(context, chatName),
                  ),
                  onTap: () {
                    context.read<ChatBloc>().add(LoadChatEvent(chatName));
                    Navigator.pop(context);
                  },
                );
              },
            );
          }

          return Center(child: Text(Tr.get(TranslationKeys.errorNum19)));
        },
      ),
    );
  }
}