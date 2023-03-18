abstract class ChatEvent {}

class InitUsers extends ChatEvent {}

class LoadMessages extends ChatEvent {
  final String user;
  LoadMessages(this.user);
}

class AddMessage extends ChatEvent {
  final String user;
  final String message;
  AddMessage(this.user, this.message);
}

class SelectUser extends ChatEvent {
  final String user;
  SelectUser(this.user);
}
