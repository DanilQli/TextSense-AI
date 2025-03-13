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
  late String _languageCode;

  @override
  void initState() {
    super.initState();
    _chatNameController = TextEditingController(text: widget.initialName ?? '');

    if (widget.initialName == null && !widget.isRename) {
      _loadDefaultChatName();
    }

    // Получаем текущий язык
    final languageState = context.read<LanguageBloc>().state;
    _languageCode = languageState is LanguageLoaded
        ? languageState.languageCode
        : 'en';
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
        _errorMessage = Tr.get(
            TranslationKeys.defaultChatNameError,
            _languageCode
        );
        _isLoading = false;
      });
    }
  }

  Future<void> _saveChat() async {
    final name = _chatNameController.text.trim();

    if (name.isEmpty) {
      setState(() {
        _errorMessage = Tr.get(
            TranslationKeys.chatNameEmptyError,
            _languageCode
        );
      });
      return;
    }

    // Проверяем корректность имени файла
    if (!FileUtils.isValidFileName(name)) {
      setState(() {
        _errorMessage = Tr.get(
            TranslationKeys.invalidFileName,
            _languageCode
        );
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
                    ? '${Tr.get(TranslationKeys.chatRenamed, _languageCode)}: $name'
                    : '${Tr.get(TranslationKeys.chatSaved, _languageCode)}: $name'
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
          title: Text(Tr.get(
              TranslationKeys.overwriteChat,
              _languageCode
          )),
          content: Text(
              '${Tr.get(TranslationKeys.chatExistsConfirmation, _languageCode)} "$chatName"?'
          ),
          actions: [
            TextButton(
              child: Text(Tr.get(
                  TranslationKeys.cancel,
                  _languageCode
              )),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text(Tr.get(
                  TranslationKeys.overwrite,
                  _languageCode
              )),
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
              ? Tr.get(TranslationKeys.renameChat, _languageCode)
              : Tr.get(TranslationKeys.saveChat, _languageCode)
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.isRename)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(Tr.get(TranslationKeys.renameChatInfo, _languageCode)),
              ),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else
              TextField(
                controller: _chatNameController,
                decoration: InputDecoration(
                  labelText: Tr.get(TranslationKeys.chatNameLabel, _languageCode),
                  hintText: Tr.get(TranslationKeys.chatNameHint, _languageCode),
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
          child: Text(Tr.get(TranslationKeys.cancel, _languageCode)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          onPressed: _saveChat,
          child: Text(
              widget.isRename
                  ? Tr.get(TranslationKeys.rename, _languageCode)
                  : Tr.get(TranslationKeys.save, _languageCode)
          ),
        ),
      ],
    );
  }
}