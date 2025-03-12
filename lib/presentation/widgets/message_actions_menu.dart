//message_action.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/chat/chat_bloc.dart';
import '../bloc/language/language_bloc.dart';
import 'dialogs/emoji_picker_dialog.dart';
import '../../domain/entities/message.dart';
import '../../core/services/translation_service.dart';

class MessageActionsMenu extends StatelessWidget {
  final Message message;

  const MessageActionsMenu({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Получаем текущий язык
    String languageCode = 'en';
    final languageState = context.read<LanguageBloc>().state;
    if (languageState is LanguageLoaded) {
      languageCode = languageState.languageCode;
    }

    final translations = TranslationService();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: const Icon(Icons.emoji_emotions),
          title: Text(translations.translate(TranslationKeys.reaction, languageCode)),
          onTap: () {
            Navigator.pop(context);
            _showEmojiPicker(context, message);
          },
        ),
        ListTile(
          leading: const Icon(Icons.translate),
          title: Text(translations.translate(TranslationKeys.translate, languageCode)),
          onTap: () {
            context.read<ChatBloc>().add(TranslateMessageEvent(message));
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.copy),
          title: Text(translations.translate(TranslationKeys.copy, languageCode)),
          onTap: () {
            context.read<ChatBloc>().add(CopyMessageEvent(message));
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(translations.translate(TranslationKeys.copied, languageCode))),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.delete),
          title: Text(translations.translate(TranslationKeys.delete, languageCode)),
          onTap: () {
            context.read<ChatBloc>().add(DeleteMessageEvent(message));
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  void _showEmojiPicker(BuildContext context, Message message) {
    showModalBottomSheet(
      context: context,
      builder: (context) => EmojiPickerDialog(message: message),
    );
  }
}