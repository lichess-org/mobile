import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'analysis_player.freezed.dart';

/// A simple player representation for analysis from PGN headers.
///
/// Unlike `Player` from `package:lichess_mobile/src/model/game/player.dart`,
/// this doesn't require user accounts or full game context.
@freezed
sealed class AnalysisPlayer with _$AnalysisPlayer {
  const AnalysisPlayer._();

  const factory AnalysisPlayer({required String name, String? title, int? rating}) =
      _AnalysisPlayer;

  /// Creates an AnalysisPlayer from PGN headers for the given side.
  ///
  /// Returns null if the player name is not available or is just a placeholder.
  static AnalysisPlayer? fromPgnHeaders(IMap<String, String> pgnHeaders, Side side) {
    final nameKey = side == .white ? 'White' : 'Black';
    final titleKey = side == .white ? 'WhiteTitle' : 'BlackTitle';
    final eloKey = side == .white ? 'WhiteElo' : 'BlackElo';

    final name = pgnHeaders.get(nameKey);
    if (name == null || name == '?') return null;

    final title = pgnHeaders.get(titleKey);
    final eloStr = pgnHeaders.get(eloKey);
    final rating = eloStr != null ? int.tryParse(eloStr) : null;

    return AnalysisPlayer(name: name, title: title, rating: rating);
  }
}
