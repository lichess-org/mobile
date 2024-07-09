import 'dart:async';

import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/db/database.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:lichess_mobile/src/model/game/game_controller.dart';
import 'package:lichess_mobile/src/model/game/message_presets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';

part 'chat_controller.freezed.dart';
part 'chat_controller.g.dart';

const _tableName = 'chat_read_messages';
String _storeKey(GameFullId id) => 'game.$id';

@riverpod
class ChatController extends _$ChatController {
  static const Map<PresetMessageGroup, List<PresetMessage>> _presetMessages = {
    PresetMessageGroup.start: [
      (label: 'HI', value: 'Hello'),
      (label: 'GL', value: 'Good luck'),
      (label: 'HF', value: 'Have fun!'),
      (label: 'U2', value: 'You too!'),
    ],
    PresetMessageGroup.end: [
      (label: 'GG', value: 'Good game'),
      (label: 'WP', value: 'Well played'),
      (label: 'TY', value: 'Thank you'),
      (label: 'GTG', value: "I've got to go"),
      (label: 'BYE', value: 'Bye!'),
    ],
  };

  StreamSubscription<SocketEvent>? _subscription;

  late SocketClient _socketClient;

  @override
  Future<ChatState> build(GameFullId id) async {
    print("Testaroonie");

    _socketClient =
        ref.read(socketPoolProvider).open(GameController.gameSocketUri(id));

    _subscription?.cancel();
    _subscription = _socketClient.stream.listen(_handleSocketEvent);

    ref.onDispose(() {
      _subscription?.cancel();
    });

    final presetMessageGroup = await ref.watch(
      gameControllerProvider(id).selectAsync(
        (gameState) => PresetMessageGroup.fromGame(gameState.game),
      ),
    );

    print("Testaroonie2");
    print(presetMessageGroup);

    final messages = await _socketClient.stream
        .firstWhere((event) => event.topic == 'full')
        .then(
          (event) => pick(event.data, 'chat', 'lines')
              .asListOrNull(_messageFromPick)
              ?.toIList(),
        );

    final readMessagesCount = await _getReadMessagesCount();

    return ChatState(
      messages: messages ?? IList(),
      unreadMessages: (messages?.length ?? 0) - readMessagesCount,
      chatPresets: (
        presets: _presetMessages,
        alreadySaid: [],
        currentPresetMessageGroup: null
      ),
    );
  }

  /// Sends a message to the chat.
  void sendMessage(String message) {
    _socketClient.send(
      'talk',
      message,
    );
  }

  // Sends a chat preset to the chat and marks it as sent
  void sendPreset(PresetMessage message) {
    sendMessage(message.value);

    state = state.whenData((s) {
      final state = s.copyWith(
        chatPresets: (
          alreadySaid: [...s.chatPresets.alreadySaid, message],
          currentPresetMessageGroup: s.chatPresets.currentPresetMessageGroup,
          presets: s.chatPresets.presets
        ),
      );
      return state;
    });
  }

  /// Resets the unread messages count to 0 and saves the number of read messages.
  Future<void> markMessagesAsRead() async {
    if (state.hasValue) {
      await _setReadMessagesCount(state.requireValue.messages.length);
    }
    state = state.whenData(
      (s) => s.copyWith(unreadMessages: 0),
    );
  }

  Future<int> _getReadMessagesCount() async {
    final db = ref.read(databaseProvider);
    final result = await db.query(
      _tableName,
      columns: ['nbRead'],
      where: 'id = ?',
      whereArgs: [_storeKey(id)],
    );
    return result.firstOrNull?['nbRead'] as int? ?? 0;
  }

  Future<void> _setReadMessagesCount(int count) async {
    final db = ref.read(databaseProvider);
    await db.insert(
      _tableName,
      {
        'id': _storeKey(id),
        'lastModified': DateTime.now().toIso8601String(),
        'nbRead': count,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> _setMessages(IList<Message> messages) async {
    final readMessagesCount = await _getReadMessagesCount();

    state = state.whenData(
      (s) => s.copyWith(
        messages: messages,
        unreadMessages: messages.length - readMessagesCount,
      ),
    );
  }

  void _addMessage(Message message) {
    state = state.whenData(
      (s) => s.copyWith(
        messages: s.messages.add(message),
        unreadMessages: s.unreadMessages + 1,
      ),
    );
  }

  void _handleSocketEvent(SocketEvent event) {
    if (!state.hasValue) return;

    if (event.topic == 'full') {
      final messages = pick(event.data, 'chat', 'lines')
          .asListOrNull(_messageFromPick)
          ?.toIList();
      if (messages != null) {
        _setMessages(messages);
      }
    } else if (event.topic == 'message') {
      final data = event.data as Map<String, dynamic>;
      final message = data['t'] as String;
      final username = data['u'] as String?;
      final colour = data['c'] as String?;
      _addMessage(
        (message: message, username: username, colour: colour),
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
    required ChatPresets chatPresets,
  }) = _ChatState;
}

typedef ChatPresets = ({
  Map<PresetMessageGroup, List<PresetMessage>> presets,
  List<PresetMessage> alreadySaid,
  PresetMessageGroup? currentPresetMessageGroup
});

typedef Message = ({String? username, String? colour, String message});

Message _messageFromPick(RequiredPick pick) {
  return (
    message: pick('t').asStringOrThrow(),
    username: pick('u').asStringOrNull(),
    colour: pick('c').asStringOrNull(),
  );
}
