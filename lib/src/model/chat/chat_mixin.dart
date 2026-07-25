import 'dart:async';
import 'dart:math' as math;

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/db/database.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/chat/chat_message.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/service/sound_service.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/network/socket.dart';
import 'package:sqflite/sqflite.dart';

part 'chat_mixin.freezed.dart';

const _tableName = 'chat_read_messages';
String _storeKey(StringId id) => 'chat.$id';

@freezed
sealed class ChatState with _$ChatState {
  const ChatState._();

  const factory ChatState({required IList<ChatMessage> messages, required int unreadMessages}) =
      _ChatState;
}

/// Interface for a Notifier's State that uses [ChatMixin].
mixin ChatMixinState {
  /// The current chat state, or `null` when the entity has no chat (e.g. a game
  /// or study without a chat room).
  ChatState? get chatState;

  /// Whether chat is currently enabled for the entity.
  ///
  /// Must imply [chatState] is non-null when `true`.
  bool get chatEnabled;
}

/// A mixin to provide chat functionality to an [AsyncNotifier].
///
/// The parent must implement the following:
/// - [chatId] to identify the chat for read-state persistence.
/// - [chatReportResource] to identify the resource when reporting a message.
/// - [chatIsPublic] to tell whether the chat is public (no message notification sound).
/// - [updateChatState] to write a new [ChatState] back into the notifier's state.
///
/// The notifier's state must expose its [ChatState] via [ChatMixinState], and
/// the parent is responsible for calling [handleSocketEvent] with incoming
/// socket events.
mixin ChatMixin<T extends ChatMixinState> on AnyNotifier<AsyncValue<T>, T> {
  /// Identifies the chat, used as the key for persisting the read-messages count.
  @protected
  StringId get chatId;

  /// The resource reported alongside a flagged message (see [reportMessage]).
  @protected
  String get chatReportResource;

  /// Whether the chat is public.
  ///
  /// Private chats play a notification sound on incoming messages; public chats
  /// do not.
  @protected
  bool get chatIsPublic;

  LightUser? get _me => ref.read(authControllerProvider)?.user;

  /// The current draft of the chat input field (unsent text).
  ///
  /// This is intentionally kept out of the observable [ChatState] so that
  /// updating it on every keystroke does not rebuild widgets watching the chat
  /// state.
  String chatInputDraft = '';

  /// Builds the initial [ChatState] from [initialData].
  ///
  /// Returns `null` when [initialData] is `null` (the entity has no chat).
  /// Filters out messages that should not be displayed and computes the unread
  /// count from the persisted read-messages count.
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

  /// Writes [newState] back into the notifier's state.
  void updateChatState(ChatState newState);

  /// Called when the screen regains focus.
  void onFocusRegained() {}

  /// Called when the app goes to the background.
  void onForegroundLost() {}

  /// Sends a message to the chat.
  void postMessage(String message) {
    ref.read(socketPoolProvider).currentClient.send('talk', message);
  }

  /// Reports [message] to moderation.
  ///
  /// Throws an [ArgumentError] if the message has no username.
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

  /// Handles an incoming chat socket [event].
  ///
  /// Appends new messages to the chat state and updates the unread count. Does
  /// nothing when chat is disabled, not initialized, or in kid mode.
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
}
