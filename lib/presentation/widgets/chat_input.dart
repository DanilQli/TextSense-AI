//chat_input.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../config/dependency_injection.dart';
import '../../core/logger/app_logger.dart';
import '../../core/utils/translation_utils.dart';
import '../../domain/repositories/speech_repository.dart';
import '../../domain/usecases/speech/listen_to_speech.dart';
import '../bloc/chat/chat_bloc.dart';
import '../../core/services/translation_service.dart';
import '../../core/constants/app_constants.dart';
import '../bloc/language/language_bloc.dart';

class ChatInput extends StatefulWidget {
  const ChatInput({super.key});

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final TextEditingController _controller = TextEditingController();
  bool _isListening = false;
  StreamSubscription<String>? _subscription;

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
      child: Column(
        children: [
          // 🔹 Bloc для управления языком
          BlocBuilder<LanguageBloc, LanguageState>(
            builder: (context, state) {
              return BlocListener<LanguageBloc, LanguageState>(
              listener: (context, state) {
                // UI обновляется при смене языка
              },
                child: BlocBuilder<LanguageBloc, LanguageState>(
                  builder: (context, state) {

                    return Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            onChanged: (value) => _controller.text = value,
                            decoration: InputDecoration(
                              hintText: Tr.get(TranslationKeys.enterText),
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                            onSubmitted: (_) => _sendMessage(),
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            _isListening ? Icons.mic : Icons.mic_none,
                            color: _isListening ? Colors.red : Theme.of(context).primaryColor,
                          ),
                          onPressed: _isListening ? _stopListening : _startListening,
                        ),
                        IconButton(
                          icon: Icon(Icons.send, color: Theme.of(context).primaryColor),
                          onPressed: _sendMessage,
                        ),
                      ],
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
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
          // Подписываемся на события
          final subscription = stream.listen(
                (text) {
              AppLogger.debug('Получен текст из потока: $text');
              if (text.isNotEmpty && mounted) {
                setState(() {
                  _controller.text = text;
                });
              }
            },
            onError: (e) {
              AppLogger.error('Ошибка распознавания речи', e);
              if (mounted) {
                setState(() {
                  _isListening = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${Tr.get(TranslationKeys.errorNum20)} $e'))
                );
              }
            },
            onDone: () {
              AppLogger.debug('Поток распознавания речи завершен');
              if (mounted) {
                setState(() {
                  _isListening = false;
                });

                // Важно! Проверяем, есть ли текст для отправки
                if (_controller.text.isNotEmpty) {
                  AppLogger.debug('Отправка распознанного текста: ${_controller.text}');
                  // Можно автоматически отправить сообщение
                  // _sendMessage();
                }
              }
            },
          );

          // Сохраняем подписку
          _subscription = subscription;
        },
      );
    } catch (e) {
      AppLogger.error('Ошибка при запуске распознавания речи', e);
      if (mounted) {
        setState(() {
          _isListening = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${Tr.get(TranslationKeys.errorNum21)} $e'))
        );
      }
    }
  }

  void _stopListening() async {
    if (!_isListening) return;

    setState(() {
      _isListening = false;
    });

    try {
      final speechRepository = getIt<SpeechRepository>();
      await speechRepository.stopListening();

      // Отменяем подписку
      _subscription?.cancel();
      _subscription = null;
    } catch (e) {
      AppLogger.error('Ошибка при остановке распознавания речи', e);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${Tr.get(TranslationKeys.errorNum22)} $e'))
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _subscription?.cancel();
    super.dispose();
  }

}