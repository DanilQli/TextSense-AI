//speech_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/chat/chat_bloc.dart';
import '../../core/constants/app_constants.dart';

class SpeechButton extends StatefulWidget {
  final bool isListening;
  final bool isDisabled;
  final Function()? onListenStart;
  final Function()? onListenStop;

  const SpeechButton({
    Key? key,
    this.isListening = false,
    this.isDisabled = false,
    this.onListenStart,
    this.onListenStop,
  }) : super(key: key);

  @override
  State<SpeechButton> createState() => _SpeechButtonState();
}

class _SpeechButtonState extends State<SpeechButton> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    if (widget.isListening) {
      _animationController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(SpeechButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isListening != oldWidget.isListening) {
      if (widget.isListening) {
        _animationController.repeat(reverse: true);
      } else {
        _animationController.stop();
        _animationController.reset();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.isListening ? _animation.value : 1.0,
          child: IconButton(
            icon: Icon(
              widget.isListening ? Icons.mic : Icons.mic_none,
              color: widget.isDisabled
                  ? Theme.of(context).disabledColor
                  : Theme.of(context).primaryColor,
            ),
            onPressed: widget.isDisabled
                ? null
                : () {
              if (widget.isListening) {
                if (widget.onListenStop != null) {
                  widget.onListenStop!();
                }
              } else {
                if (widget.onListenStart != null) {
                  widget.onListenStart!();
                }
              }
            },
            tooltip: widget.isListening ? 'Остановить запись' : 'Записать голос',
          ),
        );
      },
    );
  }
}