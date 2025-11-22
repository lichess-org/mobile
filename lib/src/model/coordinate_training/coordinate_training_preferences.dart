import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/model/common/game.dart';
import 'package:lichess_mobile/src/model/settings/preferences_storage.dart';

part 'coordinate_training_preferences.freezed.dart';
part 'coordinate_training_preferences.g.dart';

final coordinateTrainingPreferencesProvider =
    NotifierProvider<CoordinateTrainingPreferences, CoordinateTrainingPrefs>(
      CoordinateTrainingPreferences.new,
      name: 'CoordinateTrainingPreferencesProvider',
    );

class CoordinateTrainingPreferences extends Notifier<CoordinateTrainingPrefs>
    with PreferencesStorage<CoordinateTrainingPrefs> {
  @override
  @protected
  final prefCategory = PrefCategory.coordinateTraining;

  @override
  @protected
  CoordinateTrainingPrefs get defaults => CoordinateTrainingPrefs.defaults;

  @override
  CoordinateTrainingPrefs fromJson(Map<String, dynamic> json) {
    return CoordinateTrainingPrefs.fromJson(json);
  }

  @override
  CoordinateTrainingPrefs build() {
    return fetch();
  }

  Future<void> setShowCoordinates(bool showCoordinates) {
    return save(state.copyWith(showCoordinates: showCoordinates));
  }

  Future<void> setShowPieces(bool showPieces) {
    return save(state.copyWith(showPieces: showPieces));
  }

  Future<void> setMode(TrainingMode mode) {
    return save(state.copyWith(mode: mode));
  }

  Future<void> setTimeChoice(TimeChoice timeChoice) {
    return save(state.copyWith(timeChoice: timeChoice));
  }

  Future<void> setSideChoice(SideChoice sideChoice) {
    return save(state.copyWith(sideChoice: sideChoice));
  }
}

enum TimeChoice {
  thirtySeconds(Duration(seconds: 30)),
  unlimited(null);

  const TimeChoice(this.duration);

  final Duration? duration;

  // TODO l10n
  Widget label(AppLocalizations l10n) {
    switch (this) {
      case TimeChoice.thirtySeconds:
        return const Text('30s');
      case TimeChoice.unlimited:
        return const Icon(Icons.all_inclusive);
    }
  }
}

enum TrainingMode {
  findSquare,
  nameSquare;

  String label(AppLocalizations l10n) {
    switch (this) {
      case TrainingMode.findSquare:
        return l10n.coordinatesFindSquare;
      case TrainingMode.nameSquare:
        return l10n.coordinatesNameSquare;
    }
  }
}

@Freezed(fromJson: true, toJson: true)
sealed class CoordinateTrainingPrefs with _$CoordinateTrainingPrefs implements Serializable {
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
    return _$CoordinateTrainingPrefsFromJson(json);
  }
}
