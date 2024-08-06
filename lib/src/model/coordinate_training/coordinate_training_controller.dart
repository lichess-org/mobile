import 'dart:async';
import 'dart:math';

import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'coordinate_training_controller.freezed.dart';
part 'coordinate_training_controller.g.dart';

enum SideChoice {
  white,
  random,
  black,
}

String sideChoiceL10n(BuildContext context, SideChoice side) {
  switch (side) {
    case SideChoice.white:
      return context.l10n.white;
    case SideChoice.black:
      return context.l10n.black;
    case SideChoice.random:
      // TODO l10n
      return 'Random';
  }
}

enum TimeChoice {
  thirtySeconds(Duration(seconds: 30)),
  unlimited(null);

  const TimeChoice(this.duration);

  final Duration? duration;
}

// TODO l10n
Widget timeChoiceL10n(BuildContext context, TimeChoice time) {
  switch (time) {
    case TimeChoice.thirtySeconds:
      return const Text('30s');
    case TimeChoice.unlimited:
      return const Icon(Icons.all_inclusive);
  }
}

enum TrainingState {
  configuring,
  countdown,
  training,
}

@riverpod
class CoordinateTrainingController extends _$CoordinateTrainingController {
  final _random = Random(DateTime.now().millisecondsSinceEpoch);

  final _stopwatch = Stopwatch();
  Timer? _updateTimer;

  @override
  CoordinateTrainingState build() {
    return const CoordinateTrainingState(
      orientation: Side.white,
      nextCoords: IList.empty(),
      countdown: IList.empty(),
      score: 0,
      recentMistakeTimer: null,
      lastGuessWasMistake: false,
      timeLimit: null,
      elapsed: Duration.zero,
      showCoordinates: false,
      showPieces: true,
      trainingState: TrainingState.configuring,
    );
  }

  void setSideChoice(SideChoice sideChoice) {
    state = state.copyWith(
      orientation: switch (sideChoice) {
        SideChoice.white => Side.white,
        SideChoice.black => Side.black,
        SideChoice.random => _random.nextBool() ? Side.white : Side.black,
      },
    );
  }

  void startTraining(Duration? timeLimit) {
    state = state.copyWith(
      nextCoords: List<Square>.generate(3, (_) => randomCoord()).toIList(),
      score: 0,
      recentMistakeTimer: null,
      lastGuessWasMistake: false,
      timeLimit: timeLimit,
      elapsed: Duration.zero,
      countdown: ['3 ', '2 ', '1 '].lock,
      trainingState: TrainingState.countdown,
    );

    _startCountdown();
  }

  void _startTraining() {
    _updateTimer?.cancel();
    _stopwatch.reset();
    _stopwatch.start();
    _updateTimer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (state.timeLimit != null && _stopwatch.elapsed > state.timeLimit!) {
        stopTraining();
      } else {
        state = state.copyWith(
          elapsed: _stopwatch.elapsed,
        );
      }
    });

    state = state.copyWith(
      trainingState: TrainingState.training,
    );
  }

  void _startCountdown() {
    _updateTimer?.cancel();
    _updateTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      state = state.copyWith(
        countdown: state.countdown.skip(1).toIList(),
      );
      if (state.countdown.isEmpty) {
        _startTraining();
      }
    });
  }

  void setShowPieces(bool show) {
    state = state.copyWith(showPieces: show);
  }

  void setShowCoordinates(bool show) {
    state = state.copyWith(showCoordinates: show);
  }

  void stopTraining() {
    _updateTimer?.cancel();
    state = state.copyWith(
      trainingState: TrainingState.configuring,
    );
  }

  Square randomCoord() {
    while (true) {
      final square = Square.values[_random.nextInt(Square.values.length)];
      // Do not return the same square twice in a row
      if (square != state.nextCoords.firstOrNull) {
        return square;
      }
    }
  }

  void onTappedCoord(Square coord) {
    if (state.trainingState == TrainingState.training) {
      if (coord == state.nextCoords.firstOrNull) {
        state = state.copyWith(
          nextCoords:
              state.nextCoords.skip(1).followedBy([randomCoord()]).toIList(),
          score: state.score + 1,
          recentMistakeTimer: null,
          lastGuessWasMistake: false,
        );
      } else {
        state = state.copyWith(
          recentMistakeTimer: Timer(const Duration(milliseconds: 350), () {
            state = state.copyWith(recentMistakeTimer: null);
          }),
          lastGuessWasMistake: true,
        );
      }
    }
  }
}

@freezed
class CoordinateTrainingState with _$CoordinateTrainingState {
  const CoordinateTrainingState._();

  const factory CoordinateTrainingState({
    required Side orientation,
    // Empty if training is not active
    required IList<Square> nextCoords,
    required IList<String> countdown,
    required int score,
    required Timer? recentMistakeTimer,
    required bool lastGuessWasMistake,
    required Duration? timeLimit,
    required Duration elapsed,
    required bool showCoordinates,
    required bool showPieces,
    required TrainingState trainingState,
  }) = _CoordinateTrainingState;

  double? get timePercentageElapsed =>
      trainingState == TrainingState.training && timeLimit != null
          ? elapsed.inMilliseconds / timeLimit!.inMilliseconds
          : null;

  bool get recentMistake => recentMistakeTimer != null;
}
