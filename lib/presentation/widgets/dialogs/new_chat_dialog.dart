import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/translation_utils.dart';
import '../../bloc/chat/chat_bloc.dart';
import '../../bloc/language/language_bloc.dart';
import 'save_chat_dialog.dart';
import '../../../core/services/translation_service.dart';

class NewChatDialog extends StatelessWidget {
  const NewChatDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Получаем текущий язык
    final languageState = context.read<LanguageBloc>().state;
    final languageCode = languageState is LanguageLoaded
        ? languageState.languageCode
        : 'en';

    final chatBloc = context.read<ChatBloc>();

    // Проверяем, есть ли сообщения в текущем чате
    final hasMessages = chatBloc.messages.isNotEmpty;

    // Если нет сообщений, просто создаем новый чат без диалога
    if (!hasMessages) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pop();
        chatBloc.add(ClearChatEvent());
      });
      return const SizedBox.shrink();
    }

    // Если есть сообщения, спрашиваем о сохранении текущего чата
    return AlertDialog(
      title: Text(Tr.get(TranslationKeys.newChatConfirmation, languageCode)),
      content: Text(Tr.get(TranslationKeys.saveCurrentChatQuestion, languageCode)),
      actions: [
        TextButton(
          child: Text(Tr.get(TranslationKeys.dontSave, languageCode)),
          onPressed: () {
            Navigator.pop(context);
            chatBloc.add(ClearChatEvent());
          },
        ),
        TextButton(
          child: Text(Tr.get(TranslationKeys.cancel, languageCode)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: Text(Tr.get(TranslationKeys.saveAndCreate, languageCode)),
          onPressed: () {
            Navigator.pop(context);

            // Показываем диалог сохранения чата с колбэком создания нового чата
            showDialog(
              context: context,
              builder: (context) => SaveChatDialog(
                onSaveComplete: () {
                  // Даем время для завершения сохранения перед созданием нового чата
                  Future.delayed(const Duration(milliseconds: 500), () {
                    chatBloc.add(ClearChatEvent());
                  });
                },
              ),
            );
          },
        ),
      ],
    );
  }
}