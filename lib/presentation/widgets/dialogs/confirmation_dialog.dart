import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/translation_utils.dart';
import '../../bloc/language/language_bloc.dart';
import '../../../core/services/translation_service.dart';

class ConfirmationDialog extends StatelessWidget {
  final String titleKey;
  final String messageKey;
  final String? message;
  final String confirmKey;
  final String cancelKey;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final bool isDanger;

  const ConfirmationDialog({
    Key? key,
    required this.titleKey,
    required this.messageKey,
    this.message,
    this.confirmKey = TranslationKeys.save,
    this.cancelKey = TranslationKeys.cancel,
    this.onConfirm,
    this.onCancel,
    this.isDanger = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Получаем текущий язык
    final languageState = context.read<LanguageBloc>().state;
    final languageCode = languageState is LanguageLoaded
        ? languageState.languageCode
        : 'en';


    return AlertDialog(
      title: Text(Tr.get(titleKey, languageCode)),
      content: Text(
          message ?? Tr.get(messageKey, languageCode)
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
            if (onCancel != null) {
              onCancel!();
            }
          },
          child: Text(Tr.get(cancelKey, languageCode)),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
            if (onConfirm != null) {
              onConfirm!();
            }
          },
          style: isDanger ? ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Colors.red),
          ) : null,
          child: Text(Tr.get(confirmKey, languageCode)),
        ),
      ],
    );
  }
}