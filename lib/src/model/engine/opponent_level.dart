import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/engine/engine_spec.dart';
import 'package:lichess_mobile/src/model/engine/engine_utils.dart';

/// Stockfish strength levels. Level 1 is the easiest, level 12 is the hardest.
enum StockfishLevel {
  level1(skill: -12, multiPv: 10, searchTime: Duration(milliseconds: 500), threads: 1),
  level2(skill: -6, multiPv: 8, searchTime: Duration(milliseconds: 500), threads: 1),
  level3(skill: 0, multiPv: 6, searchTime: Duration(milliseconds: 610), threads: 1),
  level4(skill: 4, multiPv: 5, searchTime: Duration(milliseconds: 765), threads: 1),
  level5(skill: 7, multiPv: 5, searchTime: Duration(milliseconds: 920), threads: 1),
  level6(skill: 9, multiPv: 4, searchTime: Duration(milliseconds: 1075), threads: 2),
  level7(skill: 11, multiPv: 4, searchTime: Duration(milliseconds: 1225), threads: 2),
  level8(skill: 13, multiPv: 4, searchTime: Duration(milliseconds: 1380), threads: 2),
  level9(skill: 15, multiPv: 4, searchTime: Duration(milliseconds: 1535), threads: 2),
  level10(skill: 17, multiPv: 4, searchTime: Duration(milliseconds: 1690), threads: 2),
  level11(skill: 19, multiPv: 4, searchTime: Duration(milliseconds: 1845), threads: 2),
  level12(skill: 20, multiPv: 4, searchTime: Duration(milliseconds: 2000), threads: 2);

  const StockfishLevel({
    required this.skill,
    required this.multiPv,
    required this.searchTime,
    required this.threads,
  });

  /// The internal Stockfish skill level (from -20 to 20).
  ///
  /// Since we are using negative skill levels for the easier levels, this should only be used with
  /// Fairy-Stockfish, which supports negative skill levels. For regular Stockfish, the minimum skill level is 0.
  final int skill;

  /// Number of principal variations to compute for move selection.
  ///
  /// Stockfish's strength limiting works by applying a randomized bias to scores
  /// of slightly worse moves among at least 4 candidates. MultiPV increases
  /// this candidate pool, giving more suboptimal moves to choose from at lower Elos.
  final int multiPv;

  /// Search time for this level.
  final Duration searchTime;

  /// Number of threads to use for move computation.
  final int threads;

  /// The display level number (1-12).
  int get level => index + 1;

  /// The default level for new games.
  static const defaultLevel = StockfishLevel.level4;

  static StockfishLevel? fromLevel(int level) =>
      level >= 1 && level <= values.length ? values[level - 1] : null;
}

/// The Maia networks the app can play against.
///
/// Each one is a policy network trained on human games in a rating band, so the rating is not a
/// strength dial the way [StockfishLevel] is: it is *which* humans the network learned from, and
/// what it plays is the move players of that strength would most often play.
///
/// Only [defaultRating] ships with the app; the others are downloaded on demand. See
/// `MaiaWeightsService`.
enum MaiaRating {
  maia1100(rating: 1100, sha256Prefix: 'e1cf1cd0c96b', expectedSize: 1313193),
  maia1200(rating: 1200, sha256Prefix: 'ead4ba953f23', expectedSize: 1249692),
  maia1300(rating: 1300, sha256Prefix: '36195f87bf47', expectedSize: 1244431),
  maia1400(rating: 1400, sha256Prefix: 'd5353ea67663', expectedSize: 1328977),
  maia1500(rating: 1500, sha256Prefix: '35ab6f20421d', expectedSize: 1258199),
  maia1600(rating: 1600, sha256Prefix: 'd2c9e5948581', expectedSize: 1313870),
  maia1700(rating: 1700, sha256Prefix: 'd277eacd792d', expectedSize: 1313415),
  maia1800(rating: 1800, sha256Prefix: '0031ad7c4256', expectedSize: 1289431),
  maia1900(rating: 1900, sha256Prefix: 'e2f565f42d7c', expectedSize: 1262607);

  const MaiaRating({required this.rating, required this.sha256Prefix, required this.expectedSize});

  /// The rating band the network was trained on.
  final int rating;

  /// The first 12 digits of the network's SHA-256, checked after a download.
  final String sha256Prefix;

  /// The size of the network in bytes, for progress reporting.
  final int expectedSize;

  /// The name the network is stored under, both in the asset bundle and on disk.
  String get fileName => 'maia-$rating.pb.gz';

  /// Whether this network ships with the app rather than being downloaded.
  ///
  /// One of them has to: a computer opponent that cannot play until a download succeeds is a dead
  /// end, and this is the network everything falls back to.
  bool get isBundled => this == defaultRating;

  /// The network that ships with the app, and the one a new game plays by default.
  static const defaultRating = MaiaRating.maia1500;

  static MaiaRating? fromRating(int rating) => values.where((r) => r.rating == rating).firstOrNull;
}

/// What the computer opponent should be.
///
/// A value type, because it is the identity of an [EngineOpponent]: two screens asking for the
/// same opponent get the same one, and with it the same engine.
sealed class OpponentSpec {
  const OpponentSpec();

  /// Reads a spec back from its [toJson].
  ///
  /// Falls back to the default Stockfish opponent rather than throwing: this is read from a saved
  /// game and from the preferences, and neither is worth losing over an opponent the app no longer
  /// knows about.
  factory OpponentSpec.fromJson(Map<String, dynamic> json) {
    switch (json['type']) {
      case 'stockfish':
        final level = StockfishLevel.values.asNameMap()[json['level']];
        if (level != null) return StockfishOpponentSpec(level);
      case 'maia':
        final rating = MaiaRating.values.asNameMap()[json['rating']];
        if (rating != null) return MaiaOpponentSpec(rating);
    }
    return const StockfishOpponentSpec(StockfishLevel.defaultLevel);
  }

  /// The engine this opponent plays on.
  EngineSpec get engineSpec;

  /// A short label for the UI.
  String get displayName;

  /// Whether this opponent can play [variant] at all.
  bool supportsVariant(Variant variant);

  Map<String, dynamic> toJson();
}

/// Stockfish at one of its twelve levels.
final class StockfishOpponentSpec extends OpponentSpec {
  const StockfishOpponentSpec(this.level);

  final StockfishLevel level;

  /// Always Fairy-Stockfish: the weakest levels need negative skill levels, which only Fairy
  /// supports, and it is the only engine that can play every variant.
  @override
  EngineSpec get engineSpec => const StockfishSpec.fairy();

  @override
  String get displayName => 'Stockfish level ${level.level}';

  @override
  bool supportsVariant(Variant variant) => true;

  @override
  Map<String, dynamic> toJson() => {'type': 'stockfish', 'level': level.name};

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is StockfishOpponentSpec && other.level == level;

  @override
  int get hashCode => level.hashCode;

  @override
  String toString() => 'StockfishOpponentSpec(${level.name})';
}

/// Maia at one of its rating bands.
final class MaiaOpponentSpec extends OpponentSpec {
  const MaiaOpponentSpec(this.rating);

  final MaiaRating rating;

  /// Maia is LC0 with a Maia network, and the network is a per-search option — so every rating is
  /// the same spec, and they all share one engine.
  @override
  EngineSpec get engineSpec => const Lc0Spec();

  @override
  String get displayName => 'Maia ${rating.rating}';

  /// The networks were trained on standard human games, so Maia plays the variants that are
  /// standard chess under another name and nothing else.
  @override
  bool supportsVariant(Variant variant) => officialStockfishVariants.contains(variant);

  @override
  Map<String, dynamic> toJson() => {'type': 'maia', 'rating': rating.name};

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is MaiaOpponentSpec && other.rating == rating;

  @override
  int get hashCode => rating.hashCode;

  @override
  String toString() => 'MaiaOpponentSpec(${rating.name})';
}
