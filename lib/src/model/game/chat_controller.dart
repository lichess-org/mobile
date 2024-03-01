import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_controller.freezed.dart';
part 'chat_controller.g.dart';

@riverpod
class ChatController extends _$ChatController {
  SocketPool get _socketPool => ref.read(socketPoolProvider);

  @override
  ChatState build(StringId chatContext) {
    return ChatState(
      messages: IList(),
      unreadMessages: 0,
    );
  }

  void setMessages(IList<Message> messages) {
    state = ChatState(
      messages: messages,
      unreadMessages: 0,
    );
  }

  void addMessage(Message message) {
    state = state.copyWith(
      messages: state.messages.add(message),
      unreadMessages: state.unreadMessages + 1,
    );
  }

  void sendMessage(String message) {
    _socketPool.currentClient.send(
      'talk',
      message,
    );
  }

  void resetUnreadMessages() {
    state = state.copyWith(unreadMessages: 0);
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
