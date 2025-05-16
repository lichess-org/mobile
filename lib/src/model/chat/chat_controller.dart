import 'dart:async';
import 'dart:math' as math;

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/db/database.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/chat/chat.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/service/sound_service.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:lichess_mobile/src/model/game/game_controller.dart';
import 'package:lichess_mobile/src/model/tournament/tournament_controller.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/network/socket.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';

part 'chat_controller.freezed.dart';
part 'chat_controller.g.dart';

const _tableName = 'chat_read_messages';
String _storeKey(StringId id) => 'chat.$id';

@immutable
sealed class ChatOptions {
  const ChatOptions();

  StringId get id;
  LightUser? get opponent;
  bool get isPublic;
  bool get writeable;

  @override
  String toString() =>
      'ChatOptions(id: $id, opponent: $opponent, isPublic: $isPublic, writeable: $writeable)';
}

@freezed
abstract class GameChatOptions extends ChatOptions with _$GameChatOptions {
  const GameChatOptions._();
  const factory GameChatOptions({required GameFullId id, required LightUser? opponent}) =
      _GameChatOptions;

  @override
  bool get isPublic => false;

  @override
  bool get writeable => true;
}

@freezed
abstract class TournamentChatOptions extends ChatOptions with _$TournamentChatOptions {
  const TournamentChatOptions._();
  const factory TournamentChatOptions({required TournamentId id, required bool writeable}) =
      _TournamentChatOptions;

  @override
  LightUser? get opponent => null;

  @override
  bool get isPublic => true;
}

/// A provider that gets the chat unread messages
@riverpod
Future<int> chatUnread(Ref ref, ChatOptions options) async {
  return ref.watch(chatControllerProvider(options).selectAsync((s) => s.unreadMessages));
}

const IList<ChatMessage> _kEmptyMessages = IListConst([]);

@riverpod
class ChatController extends _$ChatController {
  StreamSubscription<SocketEvent>? _subscription;

  LightUser? get _me => ref.read(authSessionProvider)?.user;

  @override
  Future<ChatState> build(ChatOptions options) async {
    _subscription?.cancel();
    _subscription = socketGlobalStream.listen(_handleSocketEvent);

    ref.onDispose(() {
      _subscription?.cancel();
    });

    final initialMessages = await switch (options) {
      GameChatOptions(:final id) => ref.watch(
        gameControllerProvider(id).selectAsync((s) => s.game.chat?.lines),
      ),
      TournamentChatOptions(:final id) => ref.watch(
        tournamentControllerProvider(id).selectAsync((s) => s.tournament.chat?.lines),
      ),
    };

    final filteredMessages = _selectMessages(initialMessages ?? _kEmptyMessages);
    final readMessagesCount = await _getReadMessagesCount();

    return ChatState(
      messages: filteredMessages,
      unreadMessages: math.max(0, filteredMessages.length - readMessagesCount),
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
              !m.deleted && (!m.troll || m.username?.toLowerCase() == _me?.id.value) && !m.isSpam,
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
        final newUnread = newMessages.length - oldMessages.length;
        if (options.isPublic == false && newUnread > 0) {
          ref.read(soundServiceProvider).play(Sound.confirmation, volume: 0.5);
        }
        return s.copyWith(messages: newMessages, unreadMessages: s.unreadMessages + newUnread);
      });
    }
  }
}

@freezed
sealed class ChatState with _$ChatState {
  const ChatState._();

  const factory ChatState({required IList<ChatMessage> messages, required int unreadMessages}) =
      _ChatState;
}
