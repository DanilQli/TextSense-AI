//message_bubble.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/message.dart';
import '../bloc/chat/chat_bloc.dart';
import 'confidence_indicator.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/datetime_utils.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final Function() onTap;
  final TextStyle? textStyle;

  const MessageBubble({
    super.key,
    required this.message,
    required this.onTap,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Align(
        alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!message.isUser)
                Center(
                  child: Icon(
                    AppConstants.botIcon,
                    color: isDarkMode ? Colors.white : Colors.indigo,
                  ),
                ),
              if (message.isTranslating)
                const Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                ),
              Text(
                message.text,
                style: textStyle ?? TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                DateTimeUtils.formatMessageTime(message.timestamp),
                style: TextStyle(
                  fontSize: 10,
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                ),
              ),
              if (message.reaction != null)
                GestureDetector(
                  onTap: () {
                    context.read<ChatBloc>().add(RemoveReactionEvent(message));
                  },
                  child: Text(
                    message.reaction!,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              if (!message.isUser && message.classificationResult != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ConfidenceIndicator(
                    classificationResult: message.classificationResult!,
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}