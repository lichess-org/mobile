import 'dart:async';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:lichess_mobile/src/model/message/message.dart';
import 'package:lichess_mobile/src/model/message/message_repository.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/network/socket.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'conversation_controller.g.dart';
part 'conversation_controller.freezed.dart';

const kMessagesPerPage = 100;

@riverpod
class ConversationController extends _$ConversationController {
  late SocketClient _client;
  StreamSubscription<SocketEvent>? _socketSubscription;
  Timer? _setReadTimer;

  LightUser? get _me => ref.read(authSessionProvider)?.user;

  @override
  Future<ConversationState> build(UserId userId) async {
    _connectSocket();

    ref.onDispose(() {
      _socketSubscription?.cancel();
      _setReadTimer?.cancel();
    });

    _setReadTimer?.cancel();
    _setReadTimer = Timer(const Duration(seconds: 1), markAsRead);

    final repo = ref.read(messageRepositoryProvider);
    final convoData = await repo.loadConvo(userId);

    final oldFirstMsg = convoData.convo.messages.length >= kMessagesPerPage
        ? convoData.convo.messages[kMessagesPerPage - 1]
        : null;

    return ConversationState(
      me: convoData.me,
      isBot: convoData.isBot,
      convo: convoData.convo,
      canGetMoreSince: oldFirstMsg?.date,
    );
  }

  Future<void> getMore() async {
    if (!state.hasValue || state.requireValue.canGetMoreSince == null) {
      return;
    }
    final convo = state.requireValue.convo;
    final before = state.requireValue.canGetMoreSince!;

    final repo = ref.read(messageRepositoryProvider);
    final newConvoData = await repo.getMore(userId, before);

    final newMessages = convo.messages.addAll(newConvoData.convo.messages);
    state = AsyncData(
      state.requireValue.copyWith(
        convo: convo.copyWith(messages: newMessages),
        canGetMoreSince: null,
      ),
    );
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
}

@freezed
sealed class ConversationState with _$ConversationState {
  const factory ConversationState({
    required LightUser me,
    required bool isBot,
    required Convo convo,
    DateTime? canGetMoreSince,
  }) = _ConversationState;
}
