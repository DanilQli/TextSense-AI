part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class InitializeChatEvent extends ChatEvent {}

class SendMessageEvent extends ChatEvent {
  final String messageContent;
  final bool isMultiline; // Добавляем параметр isMultiline

  const SendMessageEvent(this.messageContent, {this.isMultiline = false});
  @override
  List<Object?> get props => [messageContent, isMultiline];
}

class ClearChatEvent extends ChatEvent {}

class ExportChatEvent extends ChatEvent {}

class LoadChatEvent extends ChatEvent {
  final String chatName;

  const LoadChatEvent(this.chatName);

  @override
  List<Object?> get props => [chatName];
}

class GetSavedChatsEvent extends ChatEvent {}

class SaveChatEvent extends ChatEvent {
  final String chatName;

  const SaveChatEvent(this.chatName);

  @override
  List<Object?> get props => [chatName];
}

class DeleteChatEvent extends ChatEvent {
  final String chatName;

  const DeleteChatEvent(this.chatName);

  @override
  List<Object?> get props => [chatName];
}

class RenameChatEvent extends ChatEvent {
  final String newChatName;

  const RenameChatEvent(this.newChatName);

  @override
  List<Object?> get props => [newChatName];
}

class AddReactionEvent extends ChatEvent {
  final Message message;
  final String reaction;

  const AddReactionEvent(this.message, this.reaction);

  @override
  List<Object?> get props => [message, reaction];
}

class RemoveReactionEvent extends ChatEvent {
  final Message message;

  const RemoveReactionEvent(this.message);

  @override
  List<Object?> get props => [message];
}

class TranslateMessageEvent extends ChatEvent {
  final Message message;
  final String? targetLanguage; // Добавляем параметр целевого языка

  const TranslateMessageEvent(this.message, {this.targetLanguage});

  @override
  List<Object?> get props => [message, targetLanguage];
}

class CopyMessageEvent extends ChatEvent {
  final Message message;

  const CopyMessageEvent(this.message);

  @override
  List<Object?> get props => [message];
}

class DeleteMessageEvent extends ChatEvent {
  final Message message;

  const DeleteMessageEvent(this.message);

  @override
  List<Object?> get props => [message];
}

class RestoreStateEvent extends ChatEvent {
  final List<Message> messages;
  final String? currentChatName;

  const RestoreStateEvent({
    required this.messages,
    this.currentChatName,
  });

  @override
  List<Object?> get props => [messages, currentChatName];
}
