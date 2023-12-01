import 'dart:async';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/auth/auth_socket.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:lichess_mobile/src/model/game/game_socket_events.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_controller.freezed.dart';
part 'chat_controller.g.dart';

@riverpod
class ChatController extends _$ChatController {
  StreamSubscription<SocketEvent>? _socketSubscription;

  int? _socketEventVersion;

  AuthSocket get _socket => ref.read(authSocketProvider);

  @override
  Future<ChatState> build() {
    _socketEventVersion = 0;
    final stream = _socket.stream;
    stream.listen(_handleSocketTopic);

    ref.onDispose(() {
      _socketSubscription?.cancel();
    });

    return stream.firstWhere((e) => e.topic == 'full').then(
      (event) {
        final fullEvent =
            GameFullEvent.fromJson(event.data as Map<String, dynamic>);

        _socketEventVersion = fullEvent.socketEventVersion;

        return ChatState(
          messages: fullEvent.game.messages,
          unreadMessages: 0,
        );
      },
    );
  }

  void onUserMessage(String message) {
    _socket.send(
      'talk',
      message,
    );
  }

  void resetUnreadMessages() {
    final curState = state.requireValue;
    state = AsyncValue.data(curState.copyWith(unreadMessages: 0));
  }

  void _handleSocketTopic(SocketEvent event) {
    if (!state.hasValue) return;

    switch (event.topic) {
      // Full game data, received after a (re)connection to game socket
      case 'full':
        final fullEvent =
            GameFullEvent.fromJson(event.data as Map<String, dynamic>);

        if (_socketEventVersion != null &&
            fullEvent.socketEventVersion < _socketEventVersion!) {
          return;
        }

        _socketEventVersion = fullEvent.socketEventVersion;

        state = AsyncValue.data(
          ChatState(
            messages: fullEvent.game.messages,
            unreadMessages: state.requireValue.unreadMessages,
          ),
        );

      // Received when opponent send a message
      case 'message':
        final data = event.data as Map<String, dynamic>;
        final message = data["t"] as String;
        final username = data["u"] as String;
        final curState = state.requireValue;
        state = AsyncValue.data(
          curState.copyWith(
            messages: curState.messages.add(
              Message(
                message: message,
                username: username,
              ),
            ),
            unreadMessages: curState.unreadMessages + 1,
          ),
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
