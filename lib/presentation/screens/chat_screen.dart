import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/services/translation_service.dart';
import '../../core/utils/translation_utils.dart';
import '../bloc/chat/chat_bloc.dart';
import '../bloc/language/language_bloc.dart';
import '../widgets/chat_input.dart';
import '../widgets/message_bubble.dart';
import '../widgets/chat_app_bar.dart';
import '../widgets/message_actions_menu.dart';
import '../../domain/entities/message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Прокрутка вниз при входе в приложение
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ChatAppBar(),
      body: BlocConsumer<ChatBloc, ChatState>(
        listenWhen: (previous, current) =>
        current is ChatLoaded && previous is ChatProcessing,
        listener: (context, state) {
          if (state is ChatLoaded) {
            // Прокрутка вниз при загрузке новых сообщений
            WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
          }
        },
        buildWhen: (previous, current) =>
        current is ChatLoaded ||
            current is ChatProcessing ||
            current is ChatLoading,
        builder: (context, state) {
          if (state is ChatLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final messages = state is ChatLoaded
              ? state.messages
              : state is ChatProcessing
              ? state.messages
              : [];

          final isProcessing = state is ChatProcessing;

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(12),
                  itemCount: messages.length,
                  itemBuilder: (context, i) {
                    final msg = messages[i];
                    return MessageBubble(
                      message: msg,
                      onTap: () => _showMessageActions(context, msg),
                    );
                  },
                ),
              ),
              if (isProcessing)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      LinearProgressIndicator(value: state.progress), // Индикатор прогресса
                      SizedBox(height: 8),
                      Text('${(state.progress * 100).toStringAsFixed(0)}% обработано'), // Текст с процентом
                    ],
                  ),
                ),
              const ChatInput(), // Ваш виджет ввода сообщений
            ],
          );
        },
      ),
    );
  }

  void _showMessageActions(BuildContext context, Message message) {
    final chatBloc = context.read<ChatBloc>();

    showModalBottomSheet(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: chatBloc,
        child: MessageActionsMenu(message: message),
      ),
    );
  }
}