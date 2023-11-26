enum Sender {
  player,
  opponent,
  server,
}

class Message {
  final Sender sender;
  final String message;

  const Message({required this.sender, required this.message});
}
