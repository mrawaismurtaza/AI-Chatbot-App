import 'package:chatbot/features/blocs/chat/chat-bloc.dart';
import 'package:chatbot/features/blocs/chat/chat_event.dart';
import 'package:chatbot/features/blocs/chat/chat_state.dart';
import 'package:chatbot/features/presentation/widgets/chat_inputField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId != null) {
      context.read<ChatBloc>().add(LoadChatHistory(userId));
    }

    return Scaffold(
      appBar: AppBar(title: Text("AI Chatbot")),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                if (state is ChatLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ChatLoaded) {
                  return ListView.builder(
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      final msg = state.messages[index];
                      final isUser = msg['role'] == 'user';
                      return Align(
                        alignment:
                            isUser
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color:
                                isUser
                                    ? Colors.blue
                                    : theme.colorScheme.tertiary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: MarkdownBody(
                            data: msg['text']!,
                            styleSheet: MarkdownStyleSheet(
                              h1: const TextStyle(
                                fontSize: 24,
                                color: Colors.blue,
                              ),
                              code: TextStyle(
                                fontSize: 14,
                                color: theme.colorScheme.onPrimary,
                                
                                // backgroundColor: theme.colorScheme.tertiary,
                              ),
                              codeblockPadding: EdgeInsets.all(8),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(child: Text("Start a conversation"));
                }
              },
            ),
          ),
          ChatInputfield(userId: userId!),
        ],
      ),
    );
  }
}
