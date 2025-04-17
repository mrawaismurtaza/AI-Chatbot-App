import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chatbot/features/blocs/chat/chat-bloc.dart';
import 'package:chatbot/features/blocs/chat/chat_event.dart';

class ChatInputfield extends StatefulWidget {
  final String userId;
  const ChatInputfield({super.key, required this.userId});

  @override
  State<ChatInputfield> createState() => _ChatInputfieldState();
}

class _ChatInputfieldState extends State<ChatInputfield> {
  final _controller = TextEditingController();

  void _send() {
    if (_controller.text.trim().isNotEmpty) {
      context.read<ChatBloc>().add(SendChatMessage(
        userId: widget.userId, 
        message: _controller.text.trim()
      ));
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(hintText: 'Type...'),
            ),
          ),
          IconButton(
            onPressed: _send, 
            icon: const Icon(Icons.send)
          ),
        ],
      ),
    );
  }
}