import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/translation_utils.dart';
import '../../bloc/language/language_bloc.dart';
import '../../../core/services/translation_service.dart';

class LanguageSelectionDialog extends StatefulWidget {
  final String currentLanguageCode;
  final Map<String, String> availableLanguages;
  final Function(String)? onLanguageSelected;

  const LanguageSelectionDialog({
    Key? key,
    required this.currentLanguageCode,
    this.availableLanguages = const {'en': 'English', 'ru': 'Русский'},
    this.onLanguageSelected,
  }) : super(key: key);

  @override
  State<LanguageSelectionDialog> createState() => _LanguageSelectionDialogState();
}

class _LanguageSelectionDialogState extends State<LanguageSelectionDialog> {
  late String _selectedLanguageCode;

  @override
  void initState() {
    super.initState();
    _selectedLanguageCode = widget.currentLanguageCode;
  }

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      title: Text(Tr.get(TranslationKeys.changeLanguage, _selectedLanguageCode)),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.availableLanguages.entries.map((language) {
            return RadioListTile<String>(
              title: Text(language.value),
              value: language.key,
              groupValue: _selectedLanguageCode,
              onChanged: (value) {
                setState(() {
                  _selectedLanguageCode = value!;
                });
              },
            );
          }).toList(),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(Tr.get(TranslationKeys.cancel, _selectedLanguageCode)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: Text(Tr.get(TranslationKeys.save, _selectedLanguageCode)),
          onPressed: () {
            if (widget.onLanguageSelected != null) {
              widget.onLanguageSelected!(_selectedLanguageCode);
            } else {
              // Используем BLoC если не указан callback
              context.read<LanguageBloc>().add(ChangeLanguageEvent(_selectedLanguageCode));
            }
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}