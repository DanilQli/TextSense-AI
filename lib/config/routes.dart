import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../presentation/screens/chat_screen.dart';
import '../presentation/screens/settings_screen.dart';
import '../presentation/screens/chat_list_screen.dart';
import '../presentation/bloc/chat/chat_bloc.dart';
import 'dependency_injection.dart';

class AppRoutes {
  static const String chat = '/';
  static const String settings = '/settings';
  static const String chatList = '/chats';
}

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.chat:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<ChatBloc>()..add(InitializeChatEvent()),
            child: const ChatScreen(),
          ),
        );

      case AppRoutes.settings:
        return MaterialPageRoute(
          builder: (_) => const SettingsScreen(),
        );

      case AppRoutes.chatList:
      // Используем BlocProvider.value, чтобы передать существующий экземпляр блока
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: BlocProvider.of<ChatBloc>(context)..add(GetSavedChatsEvent()),
            child: const ChatListScreen(),
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Маршрут не найден: ${settings.name}'),
            ),
          ),
        );
    }
  }
}