//save_chat_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/translation_utils.dart';
import '../../bloc/chat/chat_bloc.dart';
import '../../bloc/language/language_bloc.dart';
import '../../../core/utils/file_utils.dart';
import '../../../core/services/translation_service.dart';
import '../../../core/logger/app_logger.dart';

class SaveChatDialog extends StatefulWidget {
  final String? initialName;
  final bool isRename;
  final VoidCallback? onSaveComplete;

  const SaveChatDialog({
    Key? key,
    this.initialName,
    this.isRename = false,
    this.onSaveComplete,
  }) : super(key: key);

  @override
  State<SaveChatDialog> createState() => _SaveChatDialogState();
}

class _SaveChatDialogState extends State<SaveChatDialog> {
  late TextEditingController _chatNameController;
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _chatNameController = TextEditingController(text: widget.initialName ?? '');

    if (widget.initialName == null && !widget.isRename) {
      _loadDefaultChatName();
    }
  }

  @override
  void dispose() {
    _chatNameController.dispose();
    super.dispose();
  }

  Future<void> _loadDefaultChatName() async {
    setState(() => _isLoading = true);

    try {
      final chatBloc = context.read<ChatBloc>();
      // Запрашиваем уникальное имя чата из репозитория
      final result = await chatBloc.getMessageHistory.repository.getUniqueDefaultChatName();

      result.fold(
              (failure) {
            AppLogger.error('Ошибка при получении имени чата: ${failure.message}');
            setState(() {
              _errorMessage = failure.message;
              _isLoading = false;
            });
          },
              (chatName) {
            setState(() {
              _chatNameController.text = chatName;
              _isLoading = false;
            });
          }
      );
    } catch (e) {
      AppLogger.error('Неизвестная ошибка при получении имени чата', e);
      setState(() {
        _errorMessage = Tr.get(TranslationKeys.defaultChatNameError);
        _isLoading = false;
      });
    }
  }

  Future<void> _saveChat() async {
    final name = _chatNameController.text.trim();

    if (name.isEmpty) {
      setState(() {
        _errorMessage = Tr.get(TranslationKeys.chatNameEmptyError);
      });
      return;
    }

    // Проверяем корректность имени файла
    if (!FileUtils.isValidFileName(name)) {
      setState(() {
        _errorMessage = Tr.get(TranslationKeys.invalidFileName);
      });
      return;
    }

    // Проверяем существование чата с таким именем (если это не переименование)
    if (!widget.isRename && widget.initialName != name) {
      final chatBloc = context.read<ChatBloc>();
      final result = await chatBloc.saveChat.repository.chatExists(name);

      final exists = result.fold(
            (failure) => false,
            (exists) => exists,
      );

      if (exists) {
        // Показываем диалог подтверждения перезаписи
        final confirm = await _showOverwriteConfirmation(name);
        if (!confirm) return;
      }
    }

    // Сохраняем или переименовываем чат
    if (widget.isRename) {
      context.read<ChatBloc>().add(RenameChatEvent(name));
    } else {
      context.read<ChatBloc>().add(SaveChatEvent(name));
    }

    Navigator.of(context).pop();

    // Показываем уведомление об успешном сохранении
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                widget.isRename
                    ? '${Tr.get(TranslationKeys.chatRenamed)}: $name'
                    : '${Tr.get(TranslationKeys.chatSaved)}: $name'
            )
        )
    );

    // Вызываем callback после сохранения, если он предоставлен
    if (widget.onSaveComplete != null) {
      widget.onSaveComplete!();
    }
  }

  Future<bool> _showOverwriteConfirmation(String chatName) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(Tr.get(TranslationKeys.overwriteChat)),
          content: Text(
              '${Tr.get(TranslationKeys.chatExistsConfirmation)} "$chatName"?'
          ),
          actions: [
            TextButton(
              child: Text(Tr.get(TranslationKeys.cancel)),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text(Tr.get(TranslationKeys.overwrite)),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      title: Text(
          widget.isRename
              ? Tr.get(TranslationKeys.renameChat)
              : Tr.get(TranslationKeys.saveChat)
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.isRename)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(Tr.get(TranslationKeys.renameChatInfo)),
              ),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else
              TextField(
                controller: _chatNameController,
                decoration: InputDecoration(
                  labelText: Tr.get(TranslationKeys.chatNameLabel),
                  hintText: Tr.get(TranslationKeys.chatNameHint),
                  border: const OutlineInputBorder(),
                  errorText: _errorMessage,
                ),
                autofocus: true,
                onChanged: (_) {
                  if (_errorMessage != null) {
                    setState(() => _errorMessage = null);
                  }
                },
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: Text(Tr.get(TranslationKeys.cancel)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          onPressed: _saveChat,
          child: Text(
              widget.isRename
                  ? Tr.get(TranslationKeys.rename)
                  : Tr.get(TranslationKeys.save)
          ),
        ),
      ],
    );
  }
}