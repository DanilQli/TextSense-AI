// domain/entities/chat.dart
import 'package:equatable/equatable.dart';
import 'message.dart';

class Chat extends Equatable {
  final String id;
  final String name;
  final DateTime createdAt;
  final DateTime lastModified;
  final List<Message> messages;

  const Chat({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.lastModified,
    required this.messages,
  });

  @override
  List<Object> get props => [id, name, createdAt, lastModified, messages];
}