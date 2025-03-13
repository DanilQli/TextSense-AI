//chat_input.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../config/dependency_injection.dart';
import '../../core/utils/translation_utils.dart';
import '../../domain/repositories/speech_repository.dart';
import '../../domain/usecases/speech/listen_to_speech.dart';
import '../bloc/chat/chat_bloc.dart';
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
                    hintText: Tr.get(TranslationKeys.enterText),
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
              color: _isListening
                  ? Colors.red
                  : Theme.of(context).primaryColor,
            ),
            onPressed: _isListening ? _stopListening : _startListening,
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

  void _stopListening() async {
    if (!_isListening) return;

    final speechRepository = getIt<SpeechRepository>();
    final result = await speechRepository.stopListening();

    result.fold(
          (failure) {
        // Даже при ошибке останавливаем индикатор прослушивания
        setState(() {
          _isListening = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ошибка при остановке распознавания: ${failure.message}'))
        );
      },
          (success) {
        setState(() {
          _isListening = false;
        });
      },
    );
  }

  void _startListening() async {
    setState(() {
      _isListening = true;
    });

    try {
      // Используем UseCase для прослушивания речи
      final speechUseCase = getIt<ListenToSpeech>();
      final result = await speechUseCase();

      result.fold(
            (failure) {
          setState(() {
            _isListening = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(failure.message))
          );
        },
            (stream) {
          stream.listen(
                (text) {
              if (text.isNotEmpty) {
                setState(() {
                  _controller.text = text;
                });
              }
            },
            onError: (e) {
              setState(() {
                _isListening = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Ошибка распознавания речи: $e'))
              );
            },
            onDone: () {
              setState(() {
                _isListening = false;
              });
            },
          );
        },
      );
    } catch (e) {
      setState(() {
        _isListening = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: $e'))
      );
    }
  }
}