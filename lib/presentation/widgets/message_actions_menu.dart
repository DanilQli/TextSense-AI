//message_action.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/utils/translation_utils.dart';
import '../bloc/chat/chat_bloc.dart';
import 'dialogs/emoji_picker_dialog.dart';
import '../../domain/entities/message.dart';
import '../../core/services/translation_service.dart';

class MessageActionsMenu extends StatelessWidget {
  final Message message;

  const MessageActionsMenu({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: const Icon(Icons.emoji_emotions),
          title: Text(Tr.get(TranslationKeys.reaction)),
          onTap: () {
            Navigator.pop(context);
            _showEmojiPicker(context, message);
          },
        ),
        ListTile(
          leading: const Icon(Icons.translate),
          title: Text(Tr.get(TranslationKeys.translate)),
          onTap: () {
            context.read<ChatBloc>().add(TranslateMessageEvent(message));
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.copy),
          title: Text(Tr.get(TranslationKeys.copy)),
          onTap: () {
            context.read<ChatBloc>().add(CopyMessageEvent(message));
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(Tr.get(TranslationKeys.copied))),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.delete),
          title: Text(Tr.get(TranslationKeys.delete)),
          onTap: () {
            context.read<ChatBloc>().add(DeleteMessageEvent(message));
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  void _showEmojiPicker(BuildContext context, Message message) {
    final chatBloc = context.read<ChatBloc>();

    showModalBottomSheet(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: chatBloc,
        child: EmojiPickerDialog(message: message),
      ),
    );
  }
}