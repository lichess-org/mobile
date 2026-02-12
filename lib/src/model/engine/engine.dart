import 'package:lichess_mobile/src/constants.dart';
import 'package:multistockfish/multistockfish.dart';

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

final _sfVersionPattern = RegExp(r'Stockfish\s+(\d+)');

/// Extracts a short label like "SF 16" from a UCI engine name like "Stockfish 16.1".
///
/// Returns null if the engine name is null or doesn't match the expected pattern.
String? engineShortLabel(String? engineName) {
  if (engineName == null) return null;
  final match = _sfVersionPattern.firstMatch(engineName);
  if (match == null) return null;
  return 'SF ${match.group(1)}';
}

/// Extracts the major version like "16" from a UCI engine name like "Stockfish 16.1".
///
/// Returns null if the engine name is null or doesn't match the expected pattern.
String? engineVersion(String? engineName) {
  if (engineName == null) return null;
  final match = _sfVersionPattern.firstMatch(engineName);
  return match?.group(1);
}
