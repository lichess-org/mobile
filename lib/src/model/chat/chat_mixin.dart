import 'dart:async';
import 'dart:math' as math;

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/db/database.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/chat/chat.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/service/sound_service.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:lichess_mobile/src/model/game/game_controller.dart';
import 'package:lichess_mobile/src/model/study/study_controller.dart';
import 'package:lichess_mobile/src/model/tournament/tournament_controller.dart';
import 'package:lichess_mobile/src/model/tv/tv_game_controller.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/network/socket.dart';
import 'package:sqflite/sqflite.dart';

part 'chat_mixin.freezed.dart';

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
abstract class TvChatOptions extends ChatOptions with _$TvChatOptions {
  const TvChatOptions._();
  const factory TvChatOptions(TvGameControllerParams params, {required bool writeable}) =
      _TvChatOptions;

  @override
  GameId get id => params.gameId;

  @override
  LightUser? get opponent => null;

  @override
  bool get isPublic => true;
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

@freezed
abstract class StudyChatOptions extends ChatOptions with _$StudyChatOptions {
  const StudyChatOptions._();
  const factory StudyChatOptions({required StudyOptions options, required bool writeable}) =
      _StudyChatOptions;

  @override
  LightUser? get opponent => null;

  @override
  bool get isPublic => true;

  @override
  StringId get id => options.id;
}

@freezed
sealed class ChatState with _$ChatState {
  const ChatState._();

  const factory ChatState({
    required IList<ChatMessage> messages,
    required int unreadMessages,
    @Default('') String inputText,
  }) = _ChatState;
}

/// Interface for Notifiers's State that uses [ChatMixin].
mixin ChatMixinState {
  ChatState? get chatState;
  bool get chatEnabled;
}

/// A provider that gets the current chat state
final chatProvider = FutureProvider.autoDispose.family<ChatState?, ChatOptions>(
  (ref, options) => ref.watch(
    switch (options) {
      GameChatOptions(:final id) => gameControllerProvider(id),
      TournamentChatOptions(:final id) => tournamentControllerProvider(id),
      StudyChatOptions(:final options) => studyControllerProvider(options),
      TvChatOptions(:final params) => tvGameControllerProvider(params),
    }.selectAsync((state) => state.chatState),
  ),
  name: 'ChatProvider',
);

final chatNotifierProvider = Provider.autoDispose.family<ChatMixin, ChatOptions>(
  (ref, options) => ref.read(switch (options) {
    GameChatOptions(:final id) => gameControllerProvider(id).notifier,
    TournamentChatOptions(:final id) => tournamentControllerProvider(id).notifier,
    StudyChatOptions(:final options) => studyControllerProvider(options).notifier,
    TvChatOptions(:final params) => tvGameControllerProvider(params).notifier,
  }),
  name: 'ChatNotifierProvider',
);

/// A provider that gets the chat unread messages
final chatUnreadProvider = FutureProvider.autoDispose.family<int, ChatOptions>((
  Ref ref,
  ChatOptions options,
) async {
  return (await ref.watch(chatProvider(options).future))?.unreadMessages ?? 0;
}, name: 'ChatUnreadProvider');

mixin ChatMixin<T extends ChatMixinState> on AnyNotifier<AsyncValue<T>, T> {
  @protected
  StringId get chatId;

  @protected
  String get chatReportResource;

  @protected
  bool get chatIsPublic;

  LightUser? get _me => ref.read(authControllerProvider)?.user;

  @protected
  Future<ChatState?> initChat(ChatData? initialData) async {
    if (initialData == null) {
      return null;
    }

    final filteredMessages = _selectMessages(initialData.lines);
    final readMessagesCount = await _getReadMessagesCount();
    return ChatState(
      messages: filteredMessages,
      unreadMessages: math.max(0, filteredMessages.length - readMessagesCount),
    );
  }

  void updateChatState(ChatState newState);

  void onFocusRegained() {}
  void onForegroundLost() {}

  /// Sends a message to the chat.
  void postMessage(String message) {
    ref.read(socketPoolProvider).currentClient.send('talk', message);
  }

  Future<void> reportMessage(ChatMessage message) async {
    final username = message.username;
    if (username == null) {
      throw ArgumentError('Cannot report a message without a username');
    }
    final uri = Uri(path: '/report/flag');

    await ref
        .read(lichessClientProvider)
        .postRead(
          uri,
          headers: {'Accept': 'application/json'},
          body: {'username': username, 'resource': chatReportResource, 'text': message.message},
        );
  }

  /// Resets the unread messages count to 0 and saves the number of read messages.
  Future<void> markMessagesAsRead() async {
    final chatState = state.value?.chatState;
    if (chatState == null) return;
    await _setReadMessagesCount(chatState.messages.length);
    if (!ref.mounted) return;
    updateChatState(chatState.copyWith(unreadMessages: 0));
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
      whereArgs: [_storeKey(chatId)],
    );
    return result.firstOrNull?['nbRead'] as int? ?? 0;
  }

  Future<void> _setReadMessagesCount(int count) async {
    final db = await ref.read(databaseProvider.future);
    await db.insert(_tableName, {
      'id': _storeKey(chatId),
      'lastModified': DateTime.now().toIso8601String(),
      'nbRead': count,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @protected
  @mustCallSuper
  void handleSocketEvent(SocketEvent event) {
    final currentState = state.value;
    final chatState = currentState?.chatState;
    if (currentState?.chatEnabled != true || chatState == null) return;
    if (ref.read(kidModeProvider).value != false) return;

    if (event.topic == 'message') {
      final data = event.data as Map<String, dynamic>;
      final message = ChatMessage.fromJson(data);

      final oldMessages = chatState.messages;
      final newMessages = _selectMessages(oldMessages.add(message));
      final newUnread = newMessages.length - oldMessages.length;
      if (chatIsPublic == false && newUnread > 0) {
        ref.read(soundServiceProvider).play(Sound.confirmation, volume: 0.5);
      }
      updateChatState(
        chatState.copyWith(
          messages: newMessages,
          unreadMessages: chatState.unreadMessages + newUnread,
        ),
      );
    }
  }

  void setInputText(String text) {
    final chatState = state.value?.chatState;
    if (chatState == null) return;
    updateChatState(chatState.copyWith(inputText: text));
  }
}
