//chat_input.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/chat/chat_bloc.dart';
import '../bloc/language/language_bloc.dart';
import '../../core/services/translation_service.dart';
import '../../core/constants/app_constants.dart';

class ChatInput extends StatefulWidget {
  const ChatInput({Key? key}) : super(key: key);

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final TextEditingController _controller = TextEditingController();
  bool _isListening = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      context.read<ChatBloc>().add(SendMessageEvent(text));
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Получаем текущий язык
    String languageCode = 'en';
    if (context.read<LanguageBloc>().state is LanguageLoaded) {
      languageCode = (context.read<LanguageBloc>().state as LanguageLoaded).languageCode;
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              buildWhen: (previous, current) =>
              current is ChatProcessing ||
                  (previous is ChatProcessing && current is ChatLoaded),
              builder: (context, state) {
                final isProcessing = state is ChatProcessing;

                return TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: TranslationService().translate(TranslationKeys.enterText, languageCode),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(AppConstants.defaultBorderRadius),
                      ),
                    ),
                  ),
                  onSubmitted: (_) => _sendMessage(),
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  enabled: !isProcessing,
                );
              },
            ),
          ),
          IconButton(
            icon: Icon(
              _isListening ? Icons.mic : Icons.mic_none,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () {
              // Обработка голосового ввода - требуется реализация
              setState(() {
                _isListening = !_isListening;
              });
            },
          ),
          IconButton(
            icon: Icon(
              Icons.send,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}