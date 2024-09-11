import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/db/shared_preferences.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'coordinate_training_preferences.freezed.dart';
part 'coordinate_training_preferences.g.dart';

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

enum TrainingMode {
  findSquare,
  nameSquare,
}

// TODO l10n
String trainingModeL10n(BuildContext context, TrainingMode mode) {
  switch (mode) {
    case TrainingMode.findSquare:
      return 'Find Square';
    case TrainingMode.nameSquare:
      return 'Name Square';
  }
}

@Riverpod(keepAlive: true)
class CoordinateTrainingPreferences extends _$CoordinateTrainingPreferences {
  static const String prefKey = 'preferences.coordinate_training';

  @override
  CoordinateTrainingPrefs build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final stored = prefs.getString(prefKey);
    return stored != null
        ? CoordinateTrainingPrefs.fromJson(
            jsonDecode(stored) as Map<String, dynamic>,
          )
        : CoordinateTrainingPrefs.defaults;
  }

  Future<void> setShowCoordinates(bool showCoordinates) {
    return _save(state.copyWith(showCoordinates: showCoordinates));
  }

  Future<void> setShowPieces(bool showPieces) {
    return _save(state.copyWith(showPieces: showPieces));
  }

  Future<void> setMode(TrainingMode mode) {
    return _save(state.copyWith(mode: mode));
  }

  Future<void> setTimeChoice(TimeChoice timeChoice) {
    return _save(state.copyWith(timeChoice: timeChoice));
  }

  Future<void> setSideChoice(SideChoice sideChoice) {
    return _save(state.copyWith(sideChoice: sideChoice));
  }

  Future<void> _save(CoordinateTrainingPrefs newState) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(
      prefKey,
      jsonEncode(newState.toJson()),
    );
    state = newState;
  }
}

@Freezed(fromJson: true, toJson: true)
class CoordinateTrainingPrefs with _$CoordinateTrainingPrefs {
  const CoordinateTrainingPrefs._();

  const factory CoordinateTrainingPrefs({
    required bool showCoordinates,
    required bool showPieces,
    required TrainingMode mode,
    required TimeChoice timeChoice,
    required SideChoice sideChoice,
  }) = _CoordinateTrainingPrefs;

  static const defaults = CoordinateTrainingPrefs(
    showCoordinates: false,
    showPieces: true,
    mode: TrainingMode.findSquare,
    timeChoice: TimeChoice.thirtySeconds,
    sideChoice: SideChoice.random,
  );

  factory CoordinateTrainingPrefs.fromJson(Map<String, dynamic> json) {
    try {
      return _$CoordinateTrainingPrefsFromJson(json);
    } catch (_) {
      return defaults;
    }
  }
}
