import 'dart:io';
import 'dart:math';

import 'package:dartchess/dartchess.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:multistockfish/multistockfish.dart';

/// Maximum number of CPU cores available for engine use.
final maxEngineCores = max(Platform.numberOfProcessors - 1, 1);

/// The most memory the app will ever hand out for transposition tables, in MB.
///
/// A hard cap, not a share, because the risk does not scale with the device. `Hash` is allocated
/// and zeroed the moment the option is set, on the thread running the UCI loop, so a large table
/// buys three bad things: Stockfish calls `exit(EXIT_FAILURE)` — killing the app, not the engine —
/// when the allocation fails; the loop cannot read `quit` while the table is being cleared, which
/// is how an engine misses the plugin's quit timeout and is abandoned still holding its native
/// slot; and a variant offline game resizes it on every hand-off between the opponent and the
/// evaluator, which share one engine.
///
/// What it costs is nothing much: a mobile analysis search runs for one to three seconds, and a
/// table this size is already far more than such a search can fill.
const kMaxEngineMemoryInMb = 192;

/// How much of a device's RAM engines may hold, in MB, given its [physicalMemoryInMb].
///
/// A sixteenth of the device, capped by [kMaxEngineMemoryInMb]. The fraction is what keeps small
/// devices from being asked for more than they have; the cap is what keeps large ones from being
/// given more than is safe to allocate in one go.
int engineMaxMemoryFor(int physicalMemoryInMb) =>
    min(kMaxEngineMemoryInMb, (physicalMemoryInMb / 16).ceil());

const _nnueDownloadUrl = '$kLichessCDNHost/assets/lifat/nnue/';

/// URL to download the latest big NNUE network.
final bigNetUrl = Uri.parse('$_nnueDownloadUrl${Stockfish.latestBigNNUE}');

/// SHA256 hash (first 12 digits) of the latest big NNUE network.
final bigNetHash = Stockfish.latestBigNNUE.substring(3, 15);

/// URL to download the latest small NNUE network.
final smallNetUrl = Uri.parse('$_nnueDownloadUrl${Stockfish.latestSmallNNUE}');

/// SHA256 hash (first 12 digits) of the latest small NNUE network.
final smallNetHash = Stockfish.latestSmallNNUE.substring(3, 15);

/// Approximate size in bytes of the big NNUE file (~109MB).
///
/// Used as fallback for progress reporting when the server omits Content-Length.
const bigNetExpectedSize = 109 * 1024 * 1024;

/// Approximate size in bytes of the small NNUE file (~3.5MB).
///
/// Used as fallback for progress reporting when the server omits Content-Length.
const smallNetExpectedSize = 7 * 512 * 1024;

/// Total expected NNUE download size formatted as a human-readable string (e.g. "113MB").
const nnueTotalSizeMB = '${(bigNetExpectedSize + smallNetExpectedSize) ~/ (1024 * 1024)}MB';

/// Where the Maia networks that do not ship with the app are downloaded from.
///
/// The upstream research repository, because lichess does not host these yet. Moving them onto
/// the CDN alongside the NNUE networks is a one-line change here.
const _maiaDownloadUrl = 'https://raw.githubusercontent.com/CSSLab/maia-chess/master/maia_weights/';

/// The directory, under the app support directory, that Maia networks are kept in.
const kMaiaWeightsDirName = 'maia';

/// The asset the bundled Maia network is read from. See [MaiaRating.isBundled].
const kBundledMaiaAsset = 'assets/maia/maia-1500.pb.gz';

/// URL to download the Maia network for [fileName].
Uri maiaWeightsUrl(String fileName) => Uri.parse('$_maiaDownloadUrl$fileName');

final _sfVersionPattern = RegExp(r'Stockfish\s+(\d+)');

/// Extracts a short label like "SF 16" from a UCI engine name like "Stockfish 16.1".
///
/// Returns null if the engine name is null or doesn't match the expected pattern.
String? engineShortLabel(String? engineName) {
  if (engineName == null) return null;
  if (engineName.startsWith('Fairy-Stockfish')) {
    return 'Fairy SF';
  }
  final match = _sfVersionPattern.firstMatch(engineName);
  if (match == null) return null;
  return 'SF ${match.group(1)}';
}

/// The (fake) position to use in threat mode searches.
Position threatModePosition(Position position) => position.copyWith(
  turn: position.turn.opposite,
  halfmoves: position.halfmoves + 1,
  fullmoves: position.turn == Side.black ? position.fullmoves + 1 : position.fullmoves,
);

/// Variants supported by the official Stockfish engine. Every other variant needs Fairy-Stockfish.
const officialStockfishVariants = {Variant.standard, Variant.chess960, Variant.fromPosition};

extension FairyVariantExtension on Variant {
  /// The Fairy-Stockfish variant name, for the `UCI_Variant` option.
  String get fairy => switch (this) {
    Variant.standard => 'chess',
    Variant.chess960 => 'chess',
    Variant.fromPosition => 'chess',
    Variant.antichess => 'antichess',
    Variant.kingOfTheHill => 'kingofthehill',
    Variant.threeCheck => '3check',
    Variant.atomic => 'atomic',
    Variant.horde => 'horde',
    Variant.racingKings => 'racingkings',
    Variant.crazyhouse => 'crazyhouse',
  };
}
