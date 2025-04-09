import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../config/dependency_injection.dart';
import '../../../core/utils/translation_utils.dart';
import '../../../domain/repositories/chat_repository.dart';
import '../../../domain/usecases/chat/export_chat.dart';
import '../../../domain/usecases/chat/send_message.dart';
import '../../../domain/usecases/chat/get_message_history.dart';
import '../../../domain/usecases/chat/save_chat.dart';
import '../../../domain/usecases/chat/delete_chat.dart';
import '../../../domain/entities/message.dart';
import '../../../core/logger/app_logger.dart';
import '../../../core/services/translation_service.dart';
import '../language/language_bloc.dart';

part 'chat_event.dart';
part 'chat_state.dart';


// ChatBloc
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepository;
  final SendMessage sendMessage;
  final GetMessageHistory getMessageHistory;
  final SaveChat saveChat;
  final DeleteChat deleteChat;

  List<Message> _messages = [];
  String? _currentChatName;

  List<Message> get messages => _messages;

  String? get currentChatName => _currentChatName;

  ChatBloc({
    required this.chatRepository,
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
    on<RestoreStateEvent>(_onRestoreState);
  }

  Future<void> _onInitializeChat(
      InitializeChatEvent event,
      Emitter<ChatState> emit,
      ) async {
    emit(ChatLoading());

    try {
      // Загружаем сообщения (если чата нет, получим пустой список)
      final messagesResult = await getMessageHistory('current');

      messagesResult.fold(
            (failure) {
          AppLogger.error('Ошибка при инициализации чата', failure);
          _messages = [];
          emit(ChatError(message: Tr.get(TranslationKeys.errorNum2)));
          emit(ChatLoaded(messages: _messages, currentChatName: null));
        },
            (messages) {
          _messages = messages;
          _currentChatName = messages.isEmpty ? null : 'current';
          emit(ChatLoaded(messages: _messages, currentChatName: _currentChatName));
        },
      );
    } catch (e) {
      AppLogger.error('Необработанная ошибка при инициализации чата', e);
      emit(ChatError(message: Tr.get(TranslationKeys.errorNum3)));
      emit(const ChatLoaded(messages: [], currentChatName: null));
    }
  }

  String getCurrentLanguage() {
    final languageState = getIt<LanguageBloc>().state;
    return languageState is LanguageLoaded ? languageState.languageCode : 'en';
  }

  Future<void> _onSendMessage(
      SendMessageEvent event,
      Emitter<ChatState> emit,
      ) async {
    try {
      // Проверяем, не является ли сообщение пустым
      if (event.messageContent.trim().isEmpty) {
        AppLogger.warning('Попытка отправить пустое сообщение');
        return;
      }

      // Если имя чата не указано, создаем новый чат
      if (_currentChatName == null) {
        final newChatNameResult = await chatRepository.getUniqueDefaultChatName();
        newChatNameResult.fold(
                (failure) {
              emit(ChatError(message: 'Не удалось создать новый чат: ${failure.message}'));
              return;
            },
                (newChatName) {
              _currentChatName = newChatName;
              AppLogger.debug('Создан новый чат с именем: $_currentChatName');
            }
        );
      }

      emit(ChatProcessing(
        messages: _messages,
        currentChatName: _currentChatName,
        progress: 0.0, // Начальный прогресс
      ));

      // Используем ваш класс SendMessage для отправки сообщения
      final result = await sendMessage(
        event.messageContent,
        _currentChatName!,
        isMultiline: event.isMultiline,
        onProgress: (progress) {
          emit(ChatProcessing(
            messages: _messages,
            currentChatName: _currentChatName,
            progress: progress, // Обновляем прогресс в состоянии
          ));
        },
      );

      // Обработка результата отправки сообщения
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
          _messages = messages; // Обновляем список сообщений
          AppLogger.debug('Сообщение успешно отправлено. Текущее количество сообщений: ${_messages.length}');
          emit(ChatLoaded(
            messages: _messages,
            currentChatName: _currentChatName,
          ));
        },
      );
    } catch (e) {
      AppLogger.error('Необработанная ошибка при отправке сообщения', e);
      emit(ChatError(message: Tr.get(TranslationKeys.errorNum4)));
      emit(ChatLoaded(
        messages: _messages,
        currentChatName: _currentChatName,
      ));
    }
  }


  Future<void> _onClearChat(ClearChatEvent event,
      Emitter<ChatState> emit,) async {
    _messages = [];
    _currentChatName = null;
    emit(ChatLoaded(messages: _messages, currentChatName: _currentChatName));
  }

  Future<void> _onExportChat(
      ExportChatEvent event,
      Emitter<ChatState> emit,
      ) async {
    try {
      if (_messages.isEmpty || _currentChatName == null) {
        emit(ChatError(message: Tr.get(TranslationKeys.errorNum5)));
        emit(ChatLoaded(messages: _messages, currentChatName: _currentChatName));
        return;
      }

      // Используем UseCase для экспорта
      final exportChat = getIt<ExportChat>();

      // Получаем переводы для текущего языка
      final languageState = getIt<LanguageBloc>().state;
      final languageCode = languageState is LanguageLoaded ? languageState.languageCode : 'en';
      final translations = getIt<TranslationService>().getTranslations(languageCode);

      final result = await exportChat(_currentChatName!, translations, languageCode);

      result.fold(
            (failure) {
          AppLogger.error('Ошибка при экспорте чата: ${failure.message}');
          emit(ChatError(message: failure.message));
          emit(ChatLoaded(messages: _messages, currentChatName: _currentChatName));
        },
            (filePath) {
          AppLogger.debug('Чат успешно экспортирован в: $filePath');
          emit(ChatLoaded(messages: _messages, currentChatName: _currentChatName));
          // Показываем уведомление об успешном экспорте
          // Это нужно делать через другой механизм, например, через StreamController
        },
      );
    } catch (e) {
      AppLogger.error('Необработанная ошибка при экспорте чата', e);
      emit(ChatError(message: Tr.get(TranslationKeys.errorNum6)));
      emit(ChatLoaded(messages: _messages, currentChatName: _currentChatName));
    }
  }

  Future<void> _onLoadChat(
      LoadChatEvent event,
      Emitter<ChatState> emit,
      ) async {
    try {
      emit(ChatLoading());
      AppLogger.debug('Начинаем загрузку чата: ${event.chatName}');

      // Сохраняем текущие сообщения и имя чата на случай ошибки
      final previousMessages = _messages;
      final previousChatName = _currentChatName;

      AppLogger.debug('Текущие сообщения: ${previousMessages.length}, текущее имя чата: $previousChatName');

      final result = await getMessageHistory(event.chatName);

      result.fold(
            (failure) {
          AppLogger.error('Ошибка при загрузке чата: ${failure.message}');
          emit(ChatError(message: failure.message));

          // Восстанавливаем предыдущее состояние
          emit(ChatLoaded(
            messages: previousMessages,
            currentChatName: previousChatName,
          ));
        },
            (messages) {
          if (messages.isEmpty) {
            AppLogger.warning('Загружен пустой чат: ${event.chatName}');
            _messages = [];
            _currentChatName = event.chatName; // Устанавливаем имя загруженного чата
            emit(ChatLoaded(
              messages: _messages,
              currentChatName: _currentChatName,
            ));
          } else {
            _messages = messages;
            _currentChatName = event.chatName; // Устанавливаем имя загруженного чата
            AppLogger.debug('Чат успешно загружен: $_currentChatName с ${_messages.length} сообщениями');
            emit(ChatLoaded(
              messages: _messages,
              currentChatName: _currentChatName,
            ));
          }
        },
      );
    } catch (e) {
      AppLogger.error('Необработанная ошибка при загрузке чата', e);
      emit(ChatError(message: Tr.get(TranslationKeys.errorNum2)));
      emit(ChatLoaded(
        messages: _messages,
        currentChatName: _currentChatName,
      ));
    }
  }

  Future<void> _onRestoreState(
      RestoreStateEvent event,
      Emitter<ChatState> emit,
      ) async {
    _messages = event.messages;
    _currentChatName = event.currentChatName;
    emit(ChatLoaded(
      messages: _messages,
      currentChatName: _currentChatName,
    ));
  }

  Future<void> _onGetSavedChats(
      GetSavedChatsEvent event,
      Emitter<ChatState> emit,
      ) async {
    try {
      // Сохраняем текущее состояние
      ChatState? previousState;
      if (state is ChatLoaded) {
        previousState = state;
      }

      // Показываем индикатор загрузки только в диалоге
      emit(ChatLoading());

      final result = await deleteChat.repository.getSavedChats();

      result.fold(
            (failure) {
          AppLogger.error('Ошибка при получении списка чатов: ${failure.message}');
          emit(ChatError(message: failure.message));

          // Восстанавливаем предыдущее состояние, если оно было
          if (previousState != null) {
            emit(previousState);
          }
        },
            (chats) {
          emit(ChatSavedChatsLoaded(savedChats: chats));

          // Восстанавливаем предыдущее состояние после загрузки списка
          if (previousState != null) {
            emit(previousState);
          }
        },
      );
    } catch (e) {
      AppLogger.error('Необработанная ошибка при получении списка чатов', e);
      emit(ChatError(message: Tr.get(TranslationKeys.errorNum1)));

      // Восстанавливаем предыдущее состояние, если оно было
      if (state is ChatLoaded) {
        emit(state);
      }
    }
  }

  Future<void> _onSaveChat(SaveChatEvent event,
      Emitter<ChatState> emit,) async {
    try {
      emit(ChatSaving());

      if (_messages.isEmpty) {
        emit(ChatError(message: Tr.get(TranslationKeys.recordVoice)));
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
      },      );
    } catch (e) {
      AppLogger.error('Необработанная ошибка при сохранении чата', e);
      emit(ChatError(message: Tr.get(TranslationKeys.errorNum7)));
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
          // Возвращаем предыдущее состояние
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

          // Просто сообщаем об успешном удалении
          emit(ChatDeleted());

          // И сразу возвращаемся к нормальному состоянию
          emit(ChatLoaded(
            messages: _messages,
            currentChatName: _currentChatName,
          ));
        },
      );
    } catch (e) {
      AppLogger.error('Необработанная ошибка при удалении чата', e);
      emit(ChatError(message: Tr.get(TranslationKeys.errorNum8)));
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
        emit(ChatError(message: Tr.get(TranslationKeys.errorNum9)));
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
        },
      );
    } catch (e) {
      AppLogger.error('Необработанная ошибка при переименовании чата', e);
      emit(ChatError(message: Tr.get(TranslationKeys.errorNum10)));
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

      // Обновляем список сообщений без создания нового списка для каждого элемента
      final newMessages = List<Message>.from(_messages);
      newMessages[index] = updatedMessage;
      _messages = newMessages;

      emit(ChatLoaded(
        messages: _messages,
        currentChatName: _currentChatName,
      ));
    } catch (e) {
      AppLogger.error('Ошибка при добавлении реакции', e);
      emit(ChatError(message: Tr.get(TranslationKeys.errorNum11)));
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
      emit(ChatError(message: Tr.get(TranslationKeys.errorNum11)));
      emit(ChatLoaded(
        messages: _messages,
        currentChatName: _currentChatName,
      ));
    }
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
      emit(ChatError(message: Tr.get(TranslationKeys.errorNum12)));
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
      _messages = List.from(_messages)
        ..remove(event.message);
      emit(ChatLoaded(
        messages: _messages,
        currentChatName: _currentChatName,
      ));
    } catch (e) {
      AppLogger.error('Ошибка при удалении сообщения', e);
      emit(ChatError(message: Tr.get(TranslationKeys.errorNum13)));
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
    try {
      final index = _messages.indexOf(event.message);
      if (index == -1) return;

      // Обновляем сообщение, показывая индикатор перевода
      final translatingMessage = event.message.copyWith(isTranslating: true);
      _messages = List.from(_messages)
        ..removeAt(index)
        ..insert(index, translatingMessage);

      emit(ChatLoaded(
        messages: _messages,
        currentChatName: _currentChatName,
      ));

      // Используем UseCase для перевода
      final result = await sendMessage.translatorRepository.translate(
          event.message.text,
          event.targetLanguage ?? 'en'
      );

      if (emit.isDone) return; // Проверяем, не завершился ли уже emit

      result.fold(
            (failure) {
          // В случае ошибки возвращаем сообщение без перевода
          final originalMessage = event.message.copyWith(isTranslating: false);
          _messages = List.from(_messages)
            ..removeAt(index)
            ..insert(index, originalMessage);

          emit(ChatError(message: failure.message));
          emit(ChatLoaded(
            messages: _messages,
            currentChatName: _currentChatName,
          ));
        },
            (translatedText) {
          // Обновляем сообщение с переведенным текстом
          final translatedMessage = event.message.copyWith(
            text: translatedText,
            isTranslating: false,
          );

          _messages = List.from(_messages)
            ..removeAt(index)
            ..insert(index, translatedMessage);

          emit(ChatLoaded(
            messages: _messages,
            currentChatName: _currentChatName,
          ));
        },
      );
    } catch (e) {
      if (emit.isDone) return; // Проверяем, не завершился ли уже emit
      AppLogger.error('Ошибка при переводе сообщения', e);
      emit(ChatError(message: Tr.get(TranslationKeys.errorNum14)));
      emit(ChatLoaded(
        messages: _messages,
        currentChatName: _currentChatName,
      ));
    }
  }
}