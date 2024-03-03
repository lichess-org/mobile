import 'dart:async';

import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_controller.freezed.dart';
part 'chat_controller.g.dart';

@riverpod
class ChatController extends _$ChatController {
  SocketPool get _socketPool => ref.read(socketPoolProvider);

  StreamSubscription<SocketEvent>? _subscription;

  bool _firstLoad = true;

  @override
  ChatState build(Uri socketRoute) {
    // The socket should be connected in the game controller
    _subscription = _socketPool.subscribe(
      socketRoute,
      onData: (event) {
        if (event.topic == 'full') {
          final messages = pick(event.data, 'chat', 'lines')
              .asListOrNull(_messageFromPick)
              ?.toIList();
          if (messages != null) {
            _setMessages(messages);
          }
          _firstLoad = false;
        } else if (event.topic == 'message') {
          final data = event.data as Map<String, dynamic>;
          final message = data['t'] as String;
          final username = data['u'] as String?;
          _addMessage(
            (
              message: message,
              username: username,
            ),
          );
        }
      },
    );

    ref.onDispose(() {
      _subscription?.cancel();
    });

    return ChatState(
      messages: IList(),
      unreadMessages: 0,
    );
  }

  /// Sends a message to the chat.
  void sendMessage(String message) {
    _socketPool.currentClient.send(
      'talk',
      message,
    );
  }

  /// Resets the unread messages count to 0.
  void resetUnreadMessages() {
    state = state.copyWith(unreadMessages: 0);
  }

  void _setMessages(IList<Message> messages) {
    state = ChatState(
      messages: messages,
      unreadMessages: _firstLoad ? messages.length : state.unreadMessages,
    );
  }

  void _addMessage(Message message) {
    state = state.copyWith(
      messages: state.messages.add(message),
      unreadMessages: state.unreadMessages + 1,
    );
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

typedef Message = ({String? username, String message});

Message _messageFromPick(RequiredPick pick) {
  return (
    message: pick('t').asStringOrThrow(),
    username: pick('u').asStringOrThrow(),
  );
}
