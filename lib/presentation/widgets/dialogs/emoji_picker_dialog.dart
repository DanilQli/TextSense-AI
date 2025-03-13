import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/chat/chat_bloc.dart';
import '../../../domain/entities/message.dart';
import '../../../core/constants/app_constants.dart';

class EmojiPickerDialog extends StatelessWidget {
  final Message message;

  const EmojiPickerDialog({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  @override
  Widget build(BuildContext context) {
    final chatBloc = context.read<ChatBloc>();

    return GridView.count(
      crossAxisCount: 8,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      padding: const EdgeInsets.all(4),
      shrinkWrap: true,
      children: List.generate(AppConstants.defaultReactions.length, (index) {
        final emoji = AppConstants.defaultReactions[index];
        return GestureDetector(
          onTap: () {
            chatBloc.add(AddReactionEvent(message, emoji));
            Navigator.pop(context);
          },
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.grey[200]
                  : Colors.grey[800],
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              emoji,
              style: const TextStyle(fontSize: 24),
            ),
          ),
        );
      }),
    );
  }
}