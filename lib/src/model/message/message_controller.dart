import 'dart:async';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:lichess_mobile/src/model/message/message.dart';
import 'package:lichess_mobile/src/model/message/message_repository.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/network/socket.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'message_controller.g.dart';

@riverpod
class MessageController extends _$MessageController {
  late SocketClient _client;
  StreamSubscription<SocketEvent>? _socketSubscription;
  Timer? _setReadTimer;

  LightUser? get _me => ref.read(authSessionProvider)?.user;

  @override
  Future<ConversationData> build(UserId userId) async {
    _connectSocket();

    ref.onDispose(() {
      _socketSubscription?.cancel();
      _setReadTimer?.cancel();
    });

    _setReadTimer?.cancel();
    _setReadTimer = Timer(const Duration(seconds: 1), markAsRead);

    final repo = ref.read(messageRepositoryProvider);
    final convoData = await repo.loadConvo(userId);
    return convoData;
  }

  void _connectSocket() {
    final pool = ref.read(socketPoolProvider);
    _client = pool.open(Uri(path: kDefaultSocketRoute));

    _socketSubscription = _client.stream.listen(_onSocketEvent);
  }

  void _onSocketEvent(SocketEvent event) {
    if (!state.hasValue) {
      return;
    }
    switch (event.topic) {
      case 'msgNew':
        _handleIncomingMessage(event.data as Map<String, dynamic>);
      case 'msgType':
        // TODO handle typing event
        break;
    }
  }

  void _handleIncomingMessage(Map<String, dynamic> data) {
    final message = Message.fromServerJson(data);
    final convo = state.requireValue.convo;
    final newMessages = convo.messages.insert(0, message);
    if (message.userId == userId) {
      markAsRead();
    }
    state = AsyncData(state.requireValue.copyWith(convo: convo.copyWith(messages: newMessages)));
  }

  void sendMessage(UserId destUserId, String text) {
    if (text.isEmpty || _me == null) {
      return;
    }
    _client.send('msgSend', {'dest': '$destUserId', 'text': text});
    final message = Message(userId: _me!.id, text: text, date: DateTime.now());
    final convo = state.requireValue.convo;
    final newMessages = convo.messages.insert(0, message);
    state = AsyncData(state.requireValue.copyWith(convo: convo.copyWith(messages: newMessages)));
  }

  void markAsRead() {
    _client.send('msgRead', userId.toString());
  }

  void typing(String destUserId) {
    _client.send('msgType', destUserId);
  }
}
