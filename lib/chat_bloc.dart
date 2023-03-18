import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import 'chat_event.dart';

class ChatBloc extends Bloc<ChatEvent, List<String>> {
  late String _selectedUser;

  ChatBloc() : super([]) {
    on<InitUsers>(_onInitUsers);
    on<LoadMessages>(_onLoadMessages);
    on<AddMessage>(_onAddMessage);
    on<SelectUser>(_onSelectUser);
  }

  Future<void> _onInitUsers(InitUsers event, Emitter<List<String>> emit) async {
    await Hive.openBox<String>('messages_User1');
    await Hive.openBox<String>('messages_User2');
  }

  Future<void> _onLoadMessages(
      LoadMessages event, Emitter<List<String>> emit) async {
    _selectedUser = event.user;
    Box<String> messagesBox = Hive.box<String>('messages_$_selectedUser');
    emit(messagesBox.values.toList());
  }

  Future<void> _onAddMessage(
      AddMessage event, Emitter<List<String>> emit) async {
    Box<String> messagesBox = Hive.box<String>('messages_${event.user}');
    messagesBox.add(event.message);
    emit(messagesBox.values.toList());
  }

  void _onSelectUser(SelectUser event, Emitter<List<String>> emit) {
    add(LoadMessages(event.user));
  }
}
