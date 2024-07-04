import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/chat_controller.dart';
import 'package:lichess_mobile/src/model/game/game_controller.dart';
import 'package:lichess_mobile/src/model/game/message_presets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_presets_controller.freezed.dart';
part 'chat_presets_controller.g.dart';

@riverpod
class ChatPresetsController extends _$ChatPresetsController {
  late GameFullId _gameId;

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

  @override
  Future<ChatPresetsState> build(GameFullId id) async {
    _gameId = id;

    final gameState = ref.read(gameControllerProvider(_gameId)).value;

    ref.listen(gameControllerProvider(_gameId), _handleGameStateChange);

    if (gameState != null) {
      final presetMessageGroup = PresetMessageGroup.fromGame(gameState.game);

      const List<PresetMessage> alreadySaid = [];

      final initialState = ChatPresetsState(
        presets: _presetMessages,
        gameId: _gameId,
        alreadySaid: alreadySaid,
        currentPresetMessageGroup: presetMessageGroup,
      );

      return initialState;
    } else {
      return ChatPresetsState(
        presets: _presetMessages,
        gameId: _gameId,
        alreadySaid: [],
        currentPresetMessageGroup: null,
      );
    }
  }

  void _handleGameStateChange(
    AsyncValue<GameState>? previousGame,
    AsyncValue<GameState> currentGame,
  ) {
    final newGameState = currentGame.value;

    if (newGameState != null) {
      final newMessageGroup = PresetMessageGroup.fromGame(newGameState.game);

      final currentMessageGroup = state.value?.currentPresetMessageGroup;

      if (newMessageGroup != currentMessageGroup) {
        state = state.whenData((s) {
          final newState = s.copyWith(
            currentPresetMessageGroup: newMessageGroup,
            alreadySaid: [],
          );

          return newState;
        });
      }
    }
  }

  void sendPreset(PresetMessage message) {
    final chatController = ref.read(chatControllerProvider(_gameId).notifier);
    chatController.sendMessage(message.value);

    state = state.whenData((s) {
      final state = s.copyWith(alreadySaid: [...s.alreadySaid, message]);
      return state;
    });
  }
}

@freezed
class ChatPresetsState with _$ChatPresetsState {
  const ChatPresetsState._();

  const factory ChatPresetsState({
    required Map<PresetMessageGroup, List<PresetMessage>> presets,
    required GameFullId gameId,
    required List<PresetMessage> alreadySaid,
    required PresetMessageGroup? currentPresetMessageGroup,
  }) = _ChatPresetsState;
}
