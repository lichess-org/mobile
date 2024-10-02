import 'package:lichess_mobile/src/model/common/game.dart';
import 'package:lichess_mobile/src/model/settings/preferences.dart';
import 'package:lichess_mobile/src/model/settings/preferences_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'coordinate_training_preferences.g.dart';

@riverpod
class CoordinateTrainingPreferences extends _$CoordinateTrainingPreferences
    with PreferencesStorage<CoordinateTraining> {
  // ignore: avoid_public_notifier_properties
  @override
  final Category<CoordinateTraining> prefCategory = Category.coordinateTraining;

  @override
  CoordinateTraining build() {
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
