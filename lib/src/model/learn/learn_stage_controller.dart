import 'dart:async';
import 'dart:math';

import 'package:dartchess/dartchess.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/service/sound_service.dart';
import 'package:lichess_mobile/src/model/learn/learn_level.dart';
import 'package:lichess_mobile/src/model/learn/learn_level_state.dart';
import 'package:lichess_mobile/src/model/learn/learn_progress.dart';

part 'learn_stage_controller.freezed.dart';

/// Delay before a scripted opponent move.
const kLearnOpponentMoveDelay = Duration(milliseconds: 1000);

/// Delay before the opponent shows why a failed move was wrong.
const kLearnFailureFollowUpDelay = Duration(milliseconds: 600);

/// Delay between a completed level and the next one.
const kLearnNextLevelDelay = Duration(milliseconds: 1450);

/// The learn stage being played, identified by the stage.
///
/// [learnProgressProvider] must be loaded before reading this provider.
final learnStageControllerProvider = NotifierProvider.autoDispose
    .family<LearnStageController, LearnStageState, LearnStage>(
      LearnStageController.new,
      name: 'LearnStageControllerProvider',
    );

/// Plays the levels of a stage in order, as `ui/learn/src/run/runCtrl.ts` does on lichess.org.
class LearnStageController(final LearnStage _stage) extends Notifier<LearnStageState> {
  final _random = Random();
  final List<Timer> _timers = [];

  @override
  LearnStageState build() {
    ref.onDispose(_cancelTimers);

    final progress = ref.read(learnProgressProvider).value ?? LearnProgress.empty;
    final levelIndex = progress.nextLevelIndex(_stage);
    final starting = levelIndex == 0 && progress.stageScore(_stage) == 0;

    scheduleMicrotask(() {
      if (!ref.mounted) return;
      if (starting) {
        _play(Sound.learnStageStart);
      } else {
        _startLevel();
      }
    });

    return LearnStageState(
      stage: _stage,
      levelIndex: levelIndex,
      level: LearnLevelState.initial(_stage.levels[levelIndex]),
      starting: starting,
    );
  }

  /// Dismisses the stage introduction and starts the first level.
  void hideIntro() {
    if (!state.starting) return;
    state = state.copyWith(starting: false);
    _startLevel();
  }

  /// Plays the player's [move].
  void onUserMove(NormalMove move) {
    if (state.starting || !state.level.isPlayerTurn) return;

    final result = state.level.playerMove(move);
    state = state.copyWith(level: result.state);
    for (final sound in result.sounds) {
      _play(sound);
    }

    if (result.state.completed) {
      _onLevelCompleted();
      return;
    }

    switch (result.followUp) {
      case LearnFollowUp.none:
        break;
      case LearnFollowUp.opponentScenarioMove:
        _schedule(kLearnOpponentMoveDelay, _opponentScenarioMove);
      case LearnFollowUp.randomOpponentMove:
        _schedule(kLearnFailureFollowUpDelay, () {
          state = state.copyWith(level: state.level.randomOpponentMove(_random));
          _play(Sound.move);
        });
      case LearnFollowUp.opponentCapture:
        _schedule(kLearnFailureFollowUpDelay, () {
          state = state.copyWith(level: state.level.opponentCapture());
          _play(Sound.capture);
        });
    }
  }

  /// Restarts the current level.
  void retry() => goToLevel(state.levelIndex);

  /// Goes to the level at [index], or to the stage completion if it is past the last level.
  void goToLevel(int index) {
    _cancelTimers();
    if (index >= _stage.levels.length) {
      if (!state.stageCompleted) {
        state = state.copyWith(stageCompleted: true);
        _play(Sound.learnStageEnd);
      }
      return;
    }
    state = LearnStageState(
      stage: _stage,
      levelIndex: index,
      level: LearnLevelState.initial(_stage.levels[index]),
    );
    _startLevel();
  }

  /// Goes to the next level, or to the stage completion after the last one.
  void next() => goToLevel(state.levelIndex + 1);

  void _startLevel() {
    _play(Sound.learnLevelStart);
    if (state.level.isOpponentScenarioTurn) {
      _schedule(kLearnOpponentMoveDelay, _opponentScenarioMove);
    }
  }

  void _opponentScenarioMove() {
    final level = state.level;
    if (!level.isOpponentScenarioTurn) return;
    state = state.copyWith(level: level.opponentScenarioMove());
    _play(Sound.move);
  }

  void _onLevelCompleted() {
    final levelIndex = state.levelIndex;
    ref.read(learnProgressProvider.notifier).saveScore(_stage, levelIndex, state.level.score);
    _schedule(const Duration(milliseconds: 250), () => _play(Sound.learnLevelEnd));
    if (!state.level.level.nextButton) {
      _schedule(kLearnNextLevelDelay, next);
    }
  }

  void _schedule(Duration delay, void Function() callback) {
    _timers.add(
      Timer(delay, () {
        if (ref.mounted) callback();
      }),
    );
  }

  void _cancelTimers() {
    for (final timer in _timers) {
      timer.cancel();
    }
    _timers.clear();
  }

  void _play(Sound sound) {
    ref.read(soundServiceProvider).play(sound, volume: sound == Sound.learnTake ? 0.4 : 1.0);
  }
}

@freezed
sealed class const LearnStageState._() with _$LearnStageState {
  const factory({
    required LearnStage stage,
    required int levelIndex,
    required LearnLevelState level,

    /// Whether the stage introduction is shown.
    @Default(false) bool starting,

    /// Whether the last level of the stage was completed.
    @Default(false) bool stageCompleted,
  }) = _LearnStageState;

  bool get isLastLevel => levelIndex == stage.levels.length - 1;
}
