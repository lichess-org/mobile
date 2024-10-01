import 'package:lichess_mobile/src/model/settings/preferences.dart' as pref;
import 'package:lichess_mobile/src/model/settings/preferences_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'over_the_board_preferences.g.dart';

@riverpod
class OverTheBoardPreferences extends _$OverTheBoardPreferences
    with PreferencesStorage<pref.OverTheBoard> {
  // ignore: avoid_public_notifier_properties
  @override
  pref.Category<pref.OverTheBoard> get categoryKey =>
      pref.Category.overTheBoard;

  @override
  pref.OverTheBoard build() {
    return fetch();
  }

  Future<void> toggleFlipPiecesAfterMove() {
    return save(
      state.copyWith(flipPiecesAfterMove: !state.flipPiecesAfterMove),
    );
  }

  Future<void> toggleSymmetricPieces() {
    return save(
      state.copyWith(symmetricPieces: !state.symmetricPieces),
    );
  }
}
