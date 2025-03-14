part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatProcessing extends ChatState {
  final List<Message> messages;
  final String? currentChatName;

  const ChatProcessing({
    required this.messages,
    this.currentChatName,
  });

  @override
  List<Object?> get props => [messages, currentChatName];
}

class ChatLoaded extends ChatState {
  final List<Message> messages;
  final String? currentChatName;

  const ChatLoaded({
    required this.messages,
    this.currentChatName,
  });

  @override
  List<Object?> get props => [messages, currentChatName];
}

class ChatSaving extends ChatState {}

class ChatSaved extends ChatState {}

class ChatDeleted extends ChatState {}

class ChatRenamed extends ChatState {}

class ChatMessageCopied extends ChatState {}

class ChatSavedChatsLoaded extends ChatState {
  final Map<String, DateTime> savedChats;

  const ChatSavedChatsLoaded({
    required this.savedChats,
  });

  @override
  List<Object> get props => [savedChats];
}

class ChatError extends ChatState {
  final String message;

  const ChatError({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
