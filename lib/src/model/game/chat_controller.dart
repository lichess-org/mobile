import 'dart:async';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/auth/auth_socket.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_controller.freezed.dart';
part 'chat_controller.g.dart';

@riverpod
class ChatController extends _$ChatController {
  StreamSubscription<SocketEvent>? _socketSubscription;

  AuthSocket get _socket => ref.read(authSocketProvider);

  @override
  ChatState build() {
    final stream = _socket.stream;
    _socketSubscription = stream.listen(_handleSocketTopic);

    ref.onDispose(() {
      _socketSubscription?.cancel();
    });

    return state;
  }

  void setMessages(IList<Message> messages) {
    state = ChatState(
      messages: messages,
      unreadMessages: 0,
    );
  }

  void onUserMessage(String message) {
    _socket.send(
      'talk',
      message,
    );
  }

  void resetUnreadMessages() {
    state = state.copyWith(unreadMessages: 0);
  }

  void _handleSocketTopic(SocketEvent event) {
    switch (event.topic) {
      // Called when a message is received
      case 'message':
        final data = event.data as Map<String, dynamic>;
        final message = data["t"] as String;
        final username = data["u"] as String;
        state = state.copyWith(
          messages: state.messages.add(
            Message(
              message: message,
              username: username,
            ),
          ),
          unreadMessages: state.unreadMessages + 1,
        );
    }
  }
}

@freezed
class ChatState with _$ChatState {
  const ChatState._();

  const factory ChatState({
    required IList<Message> messages,
    required int unreadMessages,
  }) = _ChatState;
}

@immutable
class Message {
  final String username;
  final String message;

  const Message({required this.username, required this.message});
}
