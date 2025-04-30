import 'dart:async';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/db/database.dart';
import 'package:lichess_mobile/src/model/chat/chat.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/service/sound_service.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/network/socket.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';

part 'chat_controller.freezed.dart';
part 'chat_controller.g.dart';

const _tableName = 'chat_read_messages';
String _storeKey(StringId id) => 'chat.$id';

typedef ChatOptions =
    ({StringId id, LightUser? me, LightUser? opponent, bool isPublic, bool writeable});

/// Global chat data storage.
Map<StringId, ChatData> _chatData = {};

/// Loads the chat data from the server, before the [ChatController] is built.
void setChatData(StringId id, ChatData data) {
  // delete all data since we only want to keep the last one
  _chatData.clear();
  _chatData[id] = data;
}

/// A provider that gets the chat unread messages label if there are any unread messages.
@riverpod
Future<String?> chatUnreadLabel(Ref ref, ChatOptions options) async {
  return ref.watch(
    chatControllerProvider(options).selectAsync(
      (s) =>
          s.unreadMessages > 0
              ? (s.unreadMessages < 10)
                  ? s.unreadMessages.toString()
                  : '9+'
              : null,
    ),
  );
}

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

    final readMessagesCount = await _getReadMessagesCount();

    final messages = _selectMessages(_chatData[options.id]?.lines ?? IList());

    return ChatState(messages: messages, unreadMessages: messages.length - readMessagesCount);
  }

  /// Reloads the chat messages from the server.
  Future<void> onReloadMessages(IList<ChatMessage> messages) async {
    final readMessagesCount = await _getReadMessagesCount();
    final newMessages = _selectMessages(messages);

    state = state.whenData(
      (s) =>
          s.copyWith(messages: newMessages, unreadMessages: newMessages.length - readMessagesCount),
    );
  }

  /// Sends a message to the chat.
  void postMessage(String message) {
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

  void _handleSocketEvent(SocketEvent event) {
    if (!state.hasValue) return;

    if (event.topic == 'message') {
      final data = event.data as Map<String, dynamic>;
      final message = ChatMessage.fromJson(data);
      state = state.whenData((s) {
        final oldMessages = s.messages;
        final newMessages = _selectMessages(oldMessages.add(message));
        final unreadMessages = newMessages.length - oldMessages.length;
        if (options.isPublic == false && unreadMessages > s.unreadMessages) {
          ref.read(soundServiceProvider).play(Sound.confirmation, volume: 0.5);
        }
        return s.copyWith(messages: newMessages, unreadMessages: unreadMessages);
      });
    }
  }
}

@freezed
class ChatState with _$ChatState {
  const ChatState._();

  const factory ChatState({required IList<ChatMessage> messages, required int unreadMessages}) =
      _ChatState;
}
