import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/model/common/game.dart';
import 'package:lichess_mobile/src/model/settings/preferences_storage.dart';
import 'package:material_ui/material_ui.dart';

part 'coordinate_training_preferences.freezed.dart';
part 'coordinate_training_preferences.g.dart';

final coordinateTrainingPreferencesProvider =
    NotifierProvider<CoordinateTrainingPreferences, CoordinateTrainingPrefs>(
      CoordinateTrainingPreferences.new,
      name: 'CoordinateTrainingPreferencesProvider',
    );

class CoordinateTrainingPreferences()
    extends Notifier<CoordinateTrainingPrefs>
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

  Future<void> addScore({required Side side, required int score}) {
    final updated = state.addScore(side: side, score: score);
    state = updated;
    return save(updated);
  }
}

enum TimeChoice(final Duration? duration) {
  thirtySeconds(Duration(seconds: 30)),
  unlimited(null);

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

enum TrainingMode() {
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

const int kMaxCoordinateScoresCount = 20;

@Freezed(fromJson: true, toJson: true)
sealed class const CoordinateScores._() with _$CoordinateScores {
  const factory({
    @Default(IListConst<int>([])) @_IntIListConverter() IList<int> white,
    @Default(IListConst<int>([])) @_IntIListConverter() IList<int> black,
  }) = _CoordinateScores;

  static const defaults = CoordinateScores();

  factory fromJson(Map<String, dynamic> json) {
    return _$CoordinateScoresFromJson(json);
  }

  double? get averageWhite => white.isEmpty ? null : white.reduce((a, b) => a + b) / white.length;

  double? get averageBlack => black.isEmpty ? null : black.reduce((a, b) => a + b) / black.length;

  CoordinateScores addScore({required Side side, required int score}) {
    final list = side == Side.white ? white : black;
    final updatedList =
        (list.length >= kMaxCoordinateScoresCount
                ? list.sublist(list.length - kMaxCoordinateScoresCount + 1)
                : list)
            .add(score);

    return side == Side.white ? copyWith(white: updatedList) : copyWith(black: updatedList);
  }
}

@Freezed(fromJson: true, toJson: true)
sealed class const CoordinateTrainingPrefs._()
    with _$CoordinateTrainingPrefs
    implements Serializable {
  const factory({
    required bool showCoordinates,
    required bool showPieces,
    required TrainingMode mode,
    required TimeChoice timeChoice,
    required SideChoice sideChoice,
    @Default(CoordinateScores.defaults) @_CoordinateScoresConverter() CoordinateScores scores,
  }) = _CoordinateTrainingPrefs;

  static const defaults = CoordinateTrainingPrefs(
    showCoordinates: false,
    showPieces: true,
    mode: TrainingMode.findSquare,
    timeChoice: TimeChoice.thirtySeconds,
    sideChoice: SideChoice.random,
    scores: CoordinateScores.defaults,
  );

  factory fromJson(Map<String, dynamic> json) {
    return _$CoordinateTrainingPrefsFromJson(json);
  }

  CoordinateTrainingPrefs addScore({required Side side, required int score}) {
    return copyWith(
      scores: scores.addScore(side: side, score: score),
    );
  }
}

class const _CoordinateScoresConverter()
    implements JsonConverter<CoordinateScores, Map<String, dynamic>> {
  @override
  CoordinateScores fromJson(Map<String, dynamic> json) {
    return CoordinateScores.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(CoordinateScores object) {
    return object.toJson();
  }
}

class const _IntIListConverter() implements JsonConverter<IList<int>, List<dynamic>> {
  @override
  IList<int> fromJson(List<dynamic> json) {
    return IList(json.whereType<int>());
  }

  @override
  List<dynamic> toJson(IList<int> object) {
    return object.toList();
  }
}
