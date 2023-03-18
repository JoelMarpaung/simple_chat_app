import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'chat_bloc.dart';
import 'chat_event.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox<String>('messages');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) {
          final chatBloc = ChatBloc();
          chatBloc.add(InitUsers());
          return chatBloc;
        },
        child: const ChatScreen(),
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  late String _selectedUser;

  Widget _buildUserList(BuildContext context) {
    return ListView.builder(
      itemCount: 2,
      itemBuilder: (context, index) {
        String user = 'User${index + 1}';
        return ListTile(
          title: Text(user),
          onTap: () {
            setState(() {
              _selectedUser = user;
            });
            context.read<ChatBloc>().add(SelectUser(user));
          },
        );
      },
    );
  }

  void _sendMessage(BuildContext context) {
    if (_messageController.text.isNotEmpty) {
      context.read<ChatBloc>().add(AddMessage(
            _selectedUser,
            _messageController.text,
          ));
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Simple Chat App - Codigiri')),
      body: Row(
        children: [
          SizedBox(
            width: 150,
            child: _buildUserList(context),
          ),
          const VerticalDivider(thickness: 1),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: BlocBuilder<ChatBloc, List<String>>(
                    builder: (context, messages) {
                      return ListView.builder(
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          return ListTile(title: Text(messages[index]));
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration:
                              const InputDecoration(hintText: 'Type a message'),
                          onSubmitted: (text) => _sendMessage(context),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () => _sendMessage(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
