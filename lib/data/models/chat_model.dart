
// data/models/chat_model.dart
import 'dart:convert';
import 'package:uuid/uuid.dart';
import '../../domain/entities/chat.dart';
import '../../domain/entities/message.dart';
import 'message_model.dart';

class ChatModel extends Chat {
  const ChatModel({
    required String id,
    required String name,
    required DateTime createdAt,
    required DateTime lastModified,
    required List<Message> messages,
  }) : super(
    id: id,
    name: name,
    createdAt: createdAt,
    lastModified: lastModified,
    messages: messages,
  );

  factory ChatModel.fromEntity(Chat chat) {
    return ChatModel(
      id: chat.id,
      name: chat.name,
      createdAt: chat.createdAt,
      lastModified: chat.lastModified,
      messages: chat.messages,
    );
  }

  factory ChatModel.create({
    required String name,
    List<Message>? messages,
  }) {
    final now = DateTime.now();
    return ChatModel(
      id: const Uuid().v4(),
      name: name,
      createdAt: now,
      lastModified: now,
      messages: messages ?? [],
    );
  }

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    if (!json.containsKey('id') ||
        !json.containsKey('name') ||
        !json.containsKey('createdAt') ||
        !json.containsKey('lastModified') ||
        !json.containsKey('messages')) {
      throw FormatException('Некорректный формат JSON для Chat');
    }

    final List<Message> messages = (json['messages'] as List)
        .map((msgJson) => MessageModel.fromJson(msgJson))
        .toList();

    return ChatModel(
      id: json['id'] as String,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastModified: DateTime.parse(json['lastModified'] as String),
      messages: messages,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'createdAt': createdAt.toIso8601String(),
    'lastModified': lastModified.toIso8601String(),
    'messages': messages.map((msg) =>
    msg is MessageModel ? msg.toJson() : MessageModel.fromEntity(msg).toJson()
    ).toList(),
  };

  ChatModel copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
    DateTime? lastModified,
    List<Message>? messages,
  }) {
    return ChatModel(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      lastModified: lastModified ?? this.lastModified,
      messages: messages ?? this.messages,
    );
  }

  ChatModel addMessage(Message message) {
    final newMessages = List<Message>.from(messages)..add(message);
    return copyWith(
      messages: newMessages,
      lastModified: DateTime.now(),
    );
  }

  static String toJsonString(ChatModel chat) {
    return json.encode(chat.toJson());
  }

  static ChatModel fromJsonString(String jsonString) {
    return ChatModel.fromJson(json.decode(jsonString));
  }
}