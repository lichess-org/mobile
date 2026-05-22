import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/account/account_preferences.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';
import 'package:lichess_mobile/src/model/game/game.dart';
import 'package:lichess_mobile/src/model/game/game_controller.dart';
import 'package:lichess_mobile/src/model/game/game_status.dart';
import 'package:lichess_mobile/src/model/game/playable_game.dart';
import 'package:lichess_mobile/src/model/game/player.dart';

void main() {
  group('GameState.isZenModeEnabled', () {
    test('Zen.no returns false', () {
      final state = _makeGameState(zenMode: Zen.no);
      expect(state.isZenModeEnabled, isFalse);
    });

    test('Zen.yes returns true', () {
      final state = _makeGameState(zenMode: Zen.yes);
      expect(state.isZenModeEnabled, isTrue);
    });

    test('Zen.gameAuto returns true', () {
      final state = _makeGameState(zenMode: Zen.gameAuto);
      expect(state.isZenModeEnabled, isTrue);
    });

    test('null prefs returns false', () {
      final state = _makeGameStateWithNullPrefs();
      expect(state.isZenModeEnabled, isFalse);
    });
  });

  group('GameState.isZenModeActive', () {
    test('playable game with Zen.no is not active', () {
      final state = _makeGameState(zenMode: Zen.no);
      expect(state.isZenModeActive, isFalse);
    });

    test('playable game with Zen.yes is active', () {
      final state = _makeGameState(zenMode: Zen.yes);
      expect(state.isZenModeActive, isTrue);
    });

    test('playable game with Zen.gameAuto is active', () {
      final state = _makeGameState(zenMode: Zen.gameAuto);
      expect(state.isZenModeActive, isTrue);
    });

    test('finished game with Zen.yes is still active', () {
      final state = _makeFinishedGameState(zenMode: Zen.yes);
      expect(state.isZenModeActive, isTrue);
    });

    test('finished game with Zen.gameAuto is not active', () {
      final state = _makeFinishedGameState(zenMode: Zen.gameAuto);
      expect(state.isZenModeActive, isFalse);
    });

    test('finished game with Zen.no is not active', () {
      final state = _makeFinishedGameState(zenMode: Zen.no);
      expect(state.isZenModeActive, isFalse);
    });
  });
}

IList<GameStep> get _initialSteps => IList(const [GameStep(position: Chess.initial)]);

GameMeta _makeGameMeta() {
  return GameMeta(
    createdAt: DateTime.now(),
    variant: Variant.standard,
    speed: Speed.bullet,
    rated: false,
    perf: Perf.bullet,
  );
}

ServerGamePrefs _makePrefs({required Zen zenMode}) {
  return ServerGamePrefs(
    zenMode: zenMode,
    showRatings: true,
    enablePremove: true,
    autoQueen: AutoQueen.never,
    confirmResign: true,
    submitMove: false,
  );
}

const _testGameFullId = GameFullId('test12345678');
const _testGameId = GameId('test1234');

GameState _makeGameState({required Zen zenMode}) {
  return GameState(
    gameFullId: _testGameFullId,
    game: PlayableGame(
      id: _testGameId,
      meta: _makeGameMeta(),
      source: GameSource.lobby,
      steps: _initialSteps,
      status: GameStatus.started,
      white: const Player(),
      black: const Player(),
      moretimeable: false,
      takebackable: false,
      youAre: Side.white,
      prefs: _makePrefs(zenMode: zenMode),
    ),
    stepCursor: 0,
    liveClock: null,
  );
}

GameState _makeFinishedGameState({required Zen zenMode}) {
  return GameState(
    gameFullId: _testGameFullId,
    game: PlayableGame(
      id: _testGameId,
      meta: _makeGameMeta(),
      source: GameSource.lobby,
      steps: _initialSteps,
      status: GameStatus.mate,
      white: const Player(),
      black: const Player(),
      moretimeable: false,
      takebackable: false,
      youAre: Side.white,
      prefs: _makePrefs(zenMode: zenMode),
    ),
    stepCursor: 0,
    liveClock: null,
  );
}

GameState _makeGameStateWithNullPrefs() {
  return GameState(
    gameFullId: _testGameFullId,
    game: PlayableGame(
      id: _testGameId,
      meta: _makeGameMeta(),
      source: GameSource.lobby,
      steps: _initialSteps,
      status: GameStatus.started,
      white: const Player(),
      black: const Player(),
      moretimeable: false,
      takebackable: false,
      youAre: Side.white,
      prefs: null,
    ),
    stepCursor: 0,
    liveClock: null,
  );
}
