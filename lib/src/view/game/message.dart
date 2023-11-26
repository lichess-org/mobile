import 'package:meta/meta.dart';

enum Sender {
  player,
  opponent,
  server,
}

@immutable
class Message {
  final Sender sender;
  final String message;

  const Message({required this.sender, required this.message});
}
