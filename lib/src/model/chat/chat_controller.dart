import 'dart:async';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/db/database.dart';
import 'package:lichess_mobile/src/model/chat/chat.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/network/socket.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';

part 'chat_controller.freezed.dart';
part 'chat_controller.g.dart';

const _tableName = 'chat_read_messages';
String _storeKey(StringId id) => 'chat.$id';

typedef ChatOptions = ({StringId id, LightUser? me, LightUser? opponent, bool isPublic});

@riverpod
class ChatController extends _$ChatController {
  StreamSubscription<SocketEvent>? _subscription;

  @override
  Future<ChatState> build(ChatOptions options) async {
    _subscription?.cancel();
    _subscription = socketGlobalStream.listen(_handleSocketEvent);

    ref.onDispose(() {
      _subscription?.cancel();
    });

    return ChatState(messages: IList(), unreadMessages: 0);
  }

  /// Loads the chat messages from the server.
  void onMessagesLoad(IList<ChatMessage> messages) {
    _setMessages(messages);
  }

  /// Sends a message to the chat.
  void sendMessage(String message) {
    ref.read(socketPoolProvider).currentClient.send('talk', message);
  }

  /// Resets the unread messages count to 0 and saves the number of read messages.
  Future<void> markMessagesAsRead() async {
    if (state.hasValue) {
      await _setReadMessagesCount(state.requireValue.messages.length);
    }
    state = state.whenData((s) => s.copyWith(unreadMessages: 0));
  }

  IList<ChatMessage> _selectMessages(IList<ChatMessage> all) {
    return all
        .where(
          (m) =>
              !m.deleted &&
              (!m.troll || m.username?.toLowerCase() == options.me?.id.value) &&
              !m.isSpam,
        )
        .toIList();
  }

  Future<int> _getReadMessagesCount() async {
    final db = await ref.read(databaseProvider.future);
    final result = await db.query(
      _tableName,
      columns: ['nbRead'],
      where: 'id = ?',
      whereArgs: [_storeKey(options.id)],
    );
    return result.firstOrNull?['nbRead'] as int? ?? 0;
  }

  Future<void> _setReadMessagesCount(int count) async {
    final db = await ref.read(databaseProvider.future);
    await db.insert(_tableName, {
      'id': _storeKey(options.id),
      'lastModified': DateTime.now().toIso8601String(),
      'nbRead': count,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> _setMessages(IList<ChatMessage> messages) async {
    final readMessagesCount = await _getReadMessagesCount();

    final newMessages = _selectMessages(messages);

    state = state.whenData(
      (s) =>
          s.copyWith(messages: newMessages, unreadMessages: newMessages.length - readMessagesCount),
    );
  }

  void _addMessage(ChatMessage message) {
    state = state.whenData((s) {
      final oldMessages = s.messages;
      final newMessages = _selectMessages(oldMessages.add(message));
      return s.copyWith(
        messages: newMessages,
        unreadMessages: newMessages.length - oldMessages.length,
      );
    });
  }

  void _handleSocketEvent(SocketEvent event) {
    if (!state.hasValue) return;

    if (event.topic == 'message') {
      final data = event.data as Map<String, dynamic>;
      final message = ChatMessage.fromJson(data);
      _addMessage(message);
    }
  }
}

@freezed
class ChatState with _$ChatState {
  const ChatState._();

  const factory ChatState({required IList<ChatMessage> messages, required int unreadMessages}) =
      _ChatState;
}
