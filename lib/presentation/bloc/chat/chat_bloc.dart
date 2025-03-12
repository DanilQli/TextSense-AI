import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';
import '../../../domain/usecases/chat/send_message.dart';
import '../../../domain/usecases/chat/get_message_history.dart';
import '../../../domain/usecases/chat/save_chat.dart';
import '../../../domain/usecases/chat/delete_chat.dart';
import '../../../domain/entities/message.dart';
import '../../../core/logger/app_logger.dart';
import '../../../core/errors/failure.dart';
import '../../../core/services/translation_service.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final SendMessage sendMessage;
  final GetMessageHistory getMessageHistory;
  final SaveChat saveChat;
  final DeleteChat deleteChat;

  List<Message> _messages = [];
  String? _currentChatName;

  List<Message> get messages => _messages;
  String? get currentChatName => _currentChatName;

  ChatBloc({
    required this.sendMessage,
    required this.getMessageHistory,
    required this.saveChat,
    required this.deleteChat,
  }) : super(ChatInitial()) {
    on<InitializeChatEvent>(_onInitializeChat);
    on<SendMessageEvent>(_onSendMessage);
    on<ClearChatEvent>(_onClearChat);
    on<ExportChatEvent>(_onExportChat);
    on<LoadChatEvent>(_onLoadChat);
    on<GetSavedChatsEvent>(_onGetSavedChats);
    on<SaveChatEvent>(_onSaveChat);
    on<DeleteChatEvent>(_onDeleteChat);
    on<RenameChatEvent>(_onRenameChat);
    on<AddReactionEvent>(_onAddReaction);
    on<RemoveReactionEvent>(_onRemoveReaction);
    on<TranslateMessageEvent>(_onTranslateMessage);
    on<CopyMessageEvent>(_onCopyMessage);
    on<DeleteMessageEvent>(_onDeleteMessage);
  }

  Future<void> _onInitializeChat(
      InitializeChatEvent event,
      Emitter<ChatState> emit,
      ) async {
    emit(ChatLoaded(messages: _messages, currentChatName: _currentChatName));
  }

  Future<void> _onSendMessage(
      SendMessageEvent event,
      Emitter<ChatState> emit,
      ) async {
    try {
      // Проверка на пустое сообщение
      if (event.text.trim().isEmpty) {
        return;
      }

      emit(ChatProcessing(
        messages: _messages,
        currentChatName: _currentChatName,
      ));

      // Отправка сообщения через use case
      final result = await sendMessage(event.text);

      result.fold(
              (failure) {
            AppLogger.error('Ошибка при отправке сообщения: ${failure.message}');
            emit(ChatError(message: failure.message));
            emit(ChatLoaded(
              messages: _messages,
              currentChatName: _currentChatName,
            ));
          },
              (messages) {
            _messages = messages;
            emit(ChatLoaded(
              messages: _messages,
              currentChatName: _currentChatName,
            ));
          }
      );
    } catch (e) {
      AppLogger.error('Необработанная ошибка при отправке сообщения', e);
      emit(ChatError(message: 'Произошла ошибка при обработке сообщения'));
      emit(ChatLoaded(
        messages: _messages,
        currentChatName: _currentChatName,
      ));
    }
  }

  Future<void> _onClearChat(
      ClearChatEvent event,
      Emitter<ChatState> emit,
      ) async {
    _messages = [];
    _currentChatName = null;
    emit(ChatLoaded(messages: _messages, currentChatName: _currentChatName));
  }

  Future<void> _onExportChat(
      ExportChatEvent event,
      Emitter<ChatState> emit,
      ) async {
    // Реализация экспорта чата
  }

  Future<void> _onLoadChat(
      LoadChatEvent event,
      Emitter<ChatState> emit,
      ) async {
    try {
      emit(ChatLoading());

      final result = await getMessageHistory(event.chatName);

      result.fold(
              (failure) {
            AppLogger.error('Ошибка при загрузке чата: ${failure.message}');
            emit(ChatError(message: failure.message));
            emit(ChatLoaded(
              messages: _messages,
              currentChatName: _currentChatName,
            ));
          },
              (messages) {
            _messages = messages;
            _currentChatName = event.chatName;
            emit(ChatLoaded(
              messages: _messages,
              currentChatName: _currentChatName,
            ));
          }
      );
    } catch (e) {
      AppLogger.error('Необработанная ошибка при загрузке чата', e);
      emit(ChatError(message: 'Произошла ошибка при загрузке чата'));
      emit(ChatLoaded(
        messages: _messages,
        currentChatName: _currentChatName,
      ));
    }
  }

  Future<void> _onGetSavedChats(
      GetSavedChatsEvent event,
      Emitter<ChatState> emit,
      ) async {
    try {
      emit(ChatLoading());

      final result = await deleteChat.repository.getSavedChats();

      result.fold(
              (failure) {
            AppLogger.error('Ошибка при получении списка чатов: ${failure.message}');
            emit(ChatError(message: failure.message));
          },
              (chats) {
            emit(ChatSavedChatsLoaded(savedChats: chats));
          }
      );
    } catch (e) {
      AppLogger.error('Необработанная ошибка при получении списка чатов', e);
      emit(ChatError(message: 'Произошла ошибка при получении списка чатов'));
    }
  }

  Future<void> _onSaveChat(
      SaveChatEvent event,
      Emitter<ChatState> emit,
      ) async {
    try {
      emit(ChatSaving());

      if (_messages.isEmpty) {
        emit(ChatError(message: 'Нет сообщений для сохранения'));
        emit(ChatLoaded(
          messages: _messages,
          currentChatName: _currentChatName,
        ));
        return;
      }

      final result = await saveChat(event.chatName, _messages);

      result.fold(
              (failure) {
            AppLogger.error('Ошибка при сохранении чата: ${failure.message}');
            emit(ChatError(message: failure.message));
            emit(ChatLoaded(
              messages: _messages,
              currentChatName: _currentChatName,
            ));
          },
              (success) {
            _currentChatName = event.chatName;
            AppLogger.debug('Чат успешно сохранен: ${event.chatName}');
            emit(ChatSaved());
            emit(ChatLoaded(
              messages: _messages,
              currentChatName: _currentChatName,
            ));
          }
      );
    } catch (e) {
      AppLogger.error('Необработанная ошибка при сохранении чата', e);
      emit(ChatError(message: 'Произошла ошибка при сохранении чата'));
      emit(ChatLoaded(
        messages: _messages,
        currentChatName: _currentChatName,
      ));
    }
  }

  Future<void> _onDeleteChat(
      DeleteChatEvent event,
      Emitter<ChatState> emit,
      ) async {
    try {
      emit(ChatLoading());

      final result = await deleteChat(event.chatName);

      result.fold(
              (failure) {
            AppLogger.error('Ошибка при удалении чата: ${failure.message}');
            emit(ChatError(message: failure.message));
            emit(ChatLoaded(
              messages: _messages,
              currentChatName: _currentChatName,
            ));
          },
              (success) {
            // Если удалили текущий чат, очищаем его
            if (_currentChatName == event.chatName) {
              _messages = [];
              _currentChatName = null;
            }

            AppLogger.debug('Чат успешно удален: ${event.chatName}');
            emit(ChatDeleted());
            add(GetSavedChatsEvent()); // Обновляем список чатов

            emit(ChatLoaded(
              messages: _messages,
              currentChatName: _currentChatName,
            ));
          }
      );
    } catch (e) {
      AppLogger.error('Необработанная ошибка при удалении чата', e);
      emit(ChatError(message: 'Произошла ошибка при удалении чата'));
      emit(ChatLoaded(
        messages: _messages,
        currentChatName: _currentChatName,
      ));
    }
  }

  Future<void> _onRenameChat(
      RenameChatEvent event,
      Emitter<ChatState> emit,
      ) async {
    try {
      if (_currentChatName == null) {
        emit(ChatError(message: 'Нет загруженного чата для переименования'));
        return;
      }

      emit(ChatSaving());

      final result = await deleteChat.repository.renameChat(
        _currentChatName!,
        event.newChatName,
      );

      result.fold(
              (failure) {
            AppLogger.error('Ошибка при переименовании чата: ${failure.message}');
            emit(ChatError(message: failure.message));
            emit(ChatLoaded(
              messages: _messages,
              currentChatName: _currentChatName,
            ));
          },
              (success) {
            _currentChatName = event.newChatName;
            AppLogger.debug('Чат успешно переименован: ${event.newChatName}');
            emit(ChatRenamed());
            emit(ChatLoaded(
              messages: _messages,
              currentChatName: _currentChatName,
            ));
          }
      );
    } catch (e) {
      AppLogger.error('Необработанная ошибка при переименовании чата', e);
      emit(ChatError(message: 'Произошла ошибка при переименовании чата'));
      emit(ChatLoaded(
        messages: _messages,
        currentChatName: _currentChatName,
      ));
    }
  }

  Future<void> _onAddReaction(
      AddReactionEvent event,
      Emitter<ChatState> emit,
      ) async {
    try {
      final index = _messages.indexOf(event.message);
      if (index == -1) return;

      // Создаем копию сообщения с реакцией
      final updatedMessage = event.message.copyWith(reaction: event.reaction);

      // Обновляем список сообщений
      _messages = List.from(_messages)
        ..removeAt(index)
        ..insert(index, updatedMessage);

      emit(ChatLoaded(
        messages: _messages,
        currentChatName: _currentChatName,
      ));
    } catch (e) {
      AppLogger.error('Ошибка при добавлении реакции', e);
      emit(ChatError(message: 'Не удалось добавить реакцию'));
      emit(ChatLoaded(
        messages: _messages,
        currentChatName: _currentChatName,
      ));
    }
  }

  Future<void> _onRemoveReaction(
      RemoveReactionEvent event,
      Emitter<ChatState> emit,
      ) async {
    try {
      final index = _messages.indexOf(event.message);
      if (index == -1) return;

      // Создаем копию сообщения без реакции
      final updatedMessage = event.message.copyWith(reaction: null);

      // Обновляем список сообщений
      _messages = List.from(_messages)
        ..removeAt(index)
        ..insert(index, updatedMessage);

      emit(ChatLoaded(
        messages: _messages,
        currentChatName: _currentChatName,
      ));
    } catch (e) {
      AppLogger.error('Ошибка при удалении реакции', e);
      emit(ChatError(message: 'Не удалось удалить реакцию'));
      emit(ChatLoaded(
        messages: _messages,
        currentChatName: _currentChatName,
      ));
    }
  }

  Future<void> _onTranslateMessage(
      TranslateMessageEvent event,
      Emitter<ChatState> emit,
      ) async {
    // Реализация перевода сообщения
  }

  Future<void> _onCopyMessage(
      CopyMessageEvent event,
      Emitter<ChatState> emit,
      ) async {
    try {
      await Clipboard.setData(ClipboardData(text: event.message.text));
      emit(ChatMessageCopied());
      emit(ChatLoaded(
        messages: _messages,
        currentChatName: _currentChatName,
      ));
    } catch (e) {
      AppLogger.error('Ошибка при копировании сообщения', e);
      emit(ChatError(message: 'Не удалось скопировать сообщение'));
      emit(ChatLoaded(
        messages: _messages,
        currentChatName: _currentChatName,
      ));
    }
  }

  Future<void> _onDeleteMessage(
      DeleteMessageEvent event,
      Emitter<ChatState> emit,
      ) async {
    try {
      _messages = List.from(_messages)..remove(event.message);
      emit(ChatLoaded(
        messages: _messages,
        currentChatName: _currentChatName,
      ));
    } catch (e) {
      AppLogger.error('Ошибка при удалении сообщения', e);
      emit(ChatError(message: 'Не удалось удалить сообщение'));
      emit(ChatLoaded(
        messages: _messages,
        currentChatName: _currentChatName,
      ));
    }
  }
}