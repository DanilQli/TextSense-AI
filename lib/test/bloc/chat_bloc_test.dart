import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';

import '../../core/errors/failure.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../domain/usecases/chat/delete_chat.dart';
import '../../domain/usecases/chat/get_message_history.dart';
import '../../domain/usecases/chat/save_chat.dart';
import '../../domain/usecases/chat/send_message.dart';
import '../../presentation/bloc/chat/chat_bloc.dart'; // Обновите путь импорта

// Мок классов
class MockChatRepository extends Mock implements ChatRepository {}

class MockSendMessage extends Mock implements SendMessage {}
class MockGetMessageHistory extends Mock implements GetMessageHistory {}
class MockSaveChat extends Mock implements SaveChat {}
class MockDeleteChat extends Mock implements DeleteChat {}

void main() {
  late ChatBloc chatBloc;
  late MockChatRepository mockChatRepository;
  late MockSendMessage mockSendMessage;
  late MockGetMessageHistory mockGetMessageHistory;

  setUp(() {
    mockChatRepository = MockChatRepository();
    mockSendMessage = MockSendMessage();
    mockGetMessageHistory = MockGetMessageHistory();

    chatBloc = ChatBloc(
      chatRepository: mockChatRepository,
      sendMessage: mockSendMessage,
      getMessageHistory: mockGetMessageHistory,
      saveChat: MockSaveChat(), // Добавьте мок для SaveChat
      deleteChat: MockDeleteChat(), // Добавьте мок для DeleteChat
    );
  });

  tearDown(() {
    chatBloc.close();
  });

  test('initial state is ChatInitial', () {
    expect(chatBloc.state, ChatInitial());
  });

  group('LoadChatEvent', () {
    test('emits [ChatLoading, ChatLoaded] when chat is loaded successfully', () async {
      final messages = [
      Message(text: 'Hello', isUser:  true, timestamp: DateTime(2023, 1, 1, 12, 0)),
      ];
      const chatName = 'TestChat';

      // Настройка мока для метода loadChat
      when(() => mockChatRepository.loadChat(chatName))
          .thenAnswer((_) async => Right<List<Message>, Failure>(messages)); // Здесь мы указываем только один тип

      chatBloc.add(LoadChatEvent(chatName));

      await expectLater(
      chatBloc.stream,
      emitsInOrder([
      ChatLoading(),
      ChatLoaded(messages: messages, currentChatName: chatName),
      ]),
      );
    });

    test('emits [ChatLoading, ChatError] when loading chat fails', () async {
      const chatName = 'TestChat';
      final failure = ServerFailure(message: 'Error loading chat');

      // Настройка мока для метода loadChat
      when(() => mockChatRepository.loadChat(chatName))
          .thenAnswer((_) async => Left<Failure, List<Message>>(failure));

      chatBloc.add(LoadChatEvent(chatName));

      await expectLater(
        chatBloc.stream,
        emitsInOrder([
          ChatLoading(),
          ChatError(message: failure.message),
        ]),
      );
    });
  });

  // Добавьте другие группы тестов для других событий, таких как SaveChatEvent, DeleteChatEvent и т.д.
}
