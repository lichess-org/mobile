// Generates the opening book the Maia opponents play from, by crawling the Lichess opening
// explorer and writing a Polyglot `.bin`.
//
// The explorer answers "what did humans of this rating play here, and how often", which is the
// distribution Maia approximates but does not reproduce faithfully in the opening. The book sits
// in front of the engine and is consulted before it: see `MaiaOpponent.bookMove`.
//
// Requires a Lichess API token in the environment:
//
//   export LICHESS_TOKEN=lip_...
//   dart run scripts/gen_maia_book.dart --dry-run
//   dart run scripts/gen_maia_book.dart
//
// Every explorer response is cached under `--cache`, so re-running with a different threshold,
// depth or move cutoff costs no requests at all. Delete the cache to refresh the data.

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

// `File` is a chessboard file in dartchess, and this script wants `dart:io`'s.
import 'package:dartchess/dartchess.dart' hide File;

/// Rating buckets the explorer aggregates over, by raw game volume.
const _defaultRatings = [1000, 1200, 1400, 1600, 1800, 2000, 2200];

/// The low and high halves of [_defaultRatings], compared by `--dry-run`.
const _lowRatings = [1000, 1200, 1400];
const _highRatings = [1600, 1800, 2000, 2200];

const _defaultSpeeds = ['blitz', 'rapid'];

/// Positions the band comparison samples, as move lists from the initial position.
const _probeLines = [
  <String>[],
  ['e2e4'],
  ['d2d4'],
  ['e2e4', 'e7e5'],
  ['e2e4', 'c7c5'],
  ['e2e4', 'e7e6'],
  ['e2e4', 'c7c6'],
  ['d2d4', 'd7d5'],
  ['d2d4', 'g8f6'],
];

Future<void> main(List<String> args) async {
  final options = _Options.parse(args);
  final token = Platform.environment['LICHESS_TOKEN'];
  if (token == null || token.isEmpty) {
    stderr.writeln('Set LICHESS_TOKEN to a Lichess API token.');
    exit(2);
  }

  final explorer = _Explorer(
    token: token,
    cacheDir: Directory(options.cacheDir),
    speeds: options.speeds,
    minInterval: Duration(milliseconds: (1000 / options.rps).round()),
  );

  if (options.dryRun) {
    await _dryRun(explorer, options);
  } else {
    await _generate(explorer, options);
  }
  stdout.writeln('${explorer.fetched} fetched, ${explorer.cacheHits} from cache');
}

// ---------------------------------------------------------------------------------------------
// Dry run
// ---------------------------------------------------------------------------------------------

/// Reports whether the rating bands actually disagree, and how big the crawl is going to be.
///
/// Two questions, both cheap: does a single all-ratings book lose anything against one book per
/// tier, and how many positions does the configured threshold reach.
Future<void> _dryRun(_Explorer explorer, _Options options) async {
  stdout.writeln('== bands: $_lowRatings vs $_highRatings, against merged ${options.ratings}\n');

  var lowVsHigh = 0.0;
  var mergedVsLow = 0.0;
  var mergedVsHigh = 0.0;
  for (final line in _probeLines) {
    final position = _replay(line);
    final low = await explorer.moves(position, _lowRatings);
    final high = await explorer.moves(position, _highRatings);
    final merged = await explorer.moves(position, options.ratings);
    lowVsHigh += _totalVariationDistance(low, high);
    mergedVsLow += _totalVariationDistance(merged, low);
    mergedVsHigh += _totalVariationDistance(merged, high);

    final label = line.isEmpty ? 'initial position' : line.join(' ');
    stdout.writeln(
      '$label  (low/high ${_percent(_totalVariationDistance(low, high))}, '
      'merged off low by ${_percent(_totalVariationDistance(merged, low))}, '
      'off high by ${_percent(_totalVariationDistance(merged, high))})',
    );
    final moves = {...low.keys.take(6), ...high.keys.take(6)}.toList()
      ..sort((a, b) => ((high[b] ?? 0) + (low[b] ?? 0)).compareTo((high[a] ?? 0) + (low[a] ?? 0)));
    for (final uci in moves.take(6)) {
      stdout.writeln(
        '  ${_san(position, uci).padRight(8)} low ${_percent(low[uci] ?? 0).padLeft(6)}'
        '   merged ${_percent(merged[uci] ?? 0).padLeft(6)}'
        '   high ${_percent(high[uci] ?? 0).padLeft(6)}',
      );
    }
    stdout.writeln('');
  }

  final count = _probeLines.length;
  stdout.writeln('mean over $count positions:');
  stdout.writeln('  low vs high        ${_percent(lowVsHigh / count)}');
  stdout.writeln('  merged vs low      ${_percent(mergedVsLow / count)}');
  stdout.writeln('  merged vs high     ${_percent(mergedVsHigh / count)}');
  final worst = mergedVsLow > mergedVsHigh ? mergedVsLow : mergedVsHigh;
  stdout.writeln(
    worst / count < 0.05
        ? '-> one merged book is within 5% of both ends: no tiers needed.'
        : '-> a merged book misrepresents at least one end: tiers earn their keep.',
  );

  stdout.writeln(
    '\n== crawl shape at share >= ${_percent(options.shareThreshold, 2)}, '
    'probing to ply ${options.dryRunMaxPly} of ${options.maxPly}\n',
  );
  final probe = await _crawl(
    explorer,
    options.copyWith(maxPly: options.dryRunMaxPly),
    onDepth: (ply, positions) => stdout.writeln('  ply $ply: $positions positions'),
  );
  _reportProjection(probe, options);
}

/// Extrapolates the full crawl from the depth-limited probe.
///
/// The tree is still growing at the probed depth, so a single number would be a guess. The floor
/// assumes it stops growing right here; the upper estimate assumes the growth seen over the last
/// probed ply decays by half at each further ply.
void _reportProjection(_Crawl probe, _Options options) {
  final counts = probe.positionsPerPly;
  if (counts.length < 2) return;

  final ratio = counts.last / counts[counts.length - 2];
  var floor = probe.positions;
  var estimate = probe.positions;
  final floorLast = counts.last.toDouble();
  var estimateLast = counts.last.toDouble();
  var decaying = ratio;
  for (var ply = options.dryRunMaxPly + 1; ply <= options.maxPly; ply++) {
    estimateLast *= decaying;
    decaying = 1 + (decaying - 1) / 2;
    floor += floorLast.round();
    estimate += estimateLast.round();
  }
  final low = floor < estimate ? floor : estimate;
  final high = floor < estimate ? estimate : floor;
  stdout.writeln(
    '\n  $low-$high positions to ply ${options.maxPly} '
    '(${(low / options.rps / 60).toStringAsFixed(0)}-'
    '${(high / options.rps / 60).toStringAsFixed(0)} min at ${options.rps}/s), '
    '~${(low * 4 * 16 / 1024).round()}-${(high * 4 * 16 / 1024).round()} KB of book',
  );
  stdout.writeln(
    '  rough: growth was ${ratio.toStringAsFixed(1)}x over the last probed ply, and where it '
    'flattens is exactly what the probe cannot see.',
  );
}

// ---------------------------------------------------------------------------------------------
// Generation
// ---------------------------------------------------------------------------------------------

Future<void> _generate(_Explorer explorer, _Options options) async {
  final crawl = await _crawl(
    explorer,
    options,
    onDepth: (ply, positions) => stdout.writeln('  ply $ply: $positions positions'),
  );
  final bytes = _makePolyglot(crawl.entries);

  final out = File(options.out);
  await out.parent.create(recursive: true);
  await out.writeAsBytes(bytes);
  stdout.writeln(
    'Wrote ${options.out}: ${crawl.positions} positions, ${crawl.entries.length} entries, '
    '${(bytes.length / 1024).toStringAsFixed(1)} KB',
  );
}

/// Breadth-first walk of the human opening tree.
///
/// A position is expanded while its share of the games played at the root stays above
/// [_Options.shareThreshold] and it is within [_Options.maxPly]. Positions are keyed by Zobrist
/// hash, so transpositions merge into one entry and are crawled once.
Future<_Crawl> _crawl(
  _Explorer explorer,
  _Options options, {
  required void Function(int ply, int positions) onDepth,
}) async {
  final entries = <_Entry>[];
  final seen = <int>{};
  final positionsPerPly = <int>[];

  var frontier = <_Node>[const _Node(Chess.initial, 1.0)];
  for (var ply = 0; ply < options.maxPly && frontier.isNotEmpty; ply++) {
    final next = <_Node>[];
    for (final node in frontier) {
      final moves = await explorer.moves(node.position, options.ratings);
      if (moves.isEmpty) continue;

      final kept = moves.entries
          .where((move) => move.value >= options.moveCutoff)
          .take(options.maxMoves)
          .toList();
      if (kept.isEmpty) continue;

      final key = node.position.zobristHash();
      final total = kept.fold(0.0, (sum, move) => sum + move.value);
      for (final move in kept) {
        entries.add(
          _Entry(
            key: key,
            move: _polyglotMove(node.position, move.key),
            weight: (move.value / total * 1000).round().clamp(1, 0xffff),
          ),
        );

        final child = node.position.playUnchecked(Move.parse(move.key)!);
        final share = node.share * move.value;
        if (share < options.shareThreshold) continue;
        if (!seen.add(child.zobristHash())) continue;
        next.add(_Node(child, share));
      }
    }
    positionsPerPly.add(frontier.length);
    onDepth(ply, frontier.length);
    frontier = next;
  }

  return _Crawl(entries: entries, positionsPerPly: positionsPerPly);
}

class _Node {
  const _Node(this.position, this.share);

  final Position position;

  /// Fraction of the games played at the initial position that reached here.
  final double share;
}

class _Crawl {
  const _Crawl({required this.entries, required this.positionsPerPly});

  final List<_Entry> entries;
  final List<int> positionsPerPly;

  int get positions => positionsPerPly.fold(0, (sum, count) => sum + count);
}

// ---------------------------------------------------------------------------------------------
// Polyglot
// ---------------------------------------------------------------------------------------------

class _Entry {
  const _Entry({required this.key, required this.move, required this.weight});

  final int key;
  final int move;
  final int weight;
}

/// Serializes [entries] as a Polyglot book: 16 bytes each, sorted by key.
Uint8List _makePolyglot(List<_Entry> entries) {
  final sorted = [...entries]
    ..sort((a, b) {
      // Keys are compared unsigned: they are hashes, not numbers.
      final keys = (a.key ^ _signBit).compareTo(b.key ^ _signBit);
      return keys != 0 ? keys : b.weight.compareTo(a.weight);
    });

  final bytes = ByteData(sorted.length * 16);
  for (var i = 0; i < sorted.length; i++) {
    final offset = i * 16;
    bytes.setInt64(offset, sorted[i].key);
    bytes.setUint16(offset + 8, sorted[i].move);
    bytes.setUint16(offset + 10, sorted[i].weight);
    bytes.setUint32(offset + 12, 0); // learn, unused
  }
  return bytes.buffer.asUint8List();
}

const _signBit = 0x8000000000000000;

/// Packs a UCI move into Polyglot's 16 bit move field.
///
/// Castling is encoded king-to-rook, which is also how dartchess encodes it internally, so a
/// castling move only has to be recognised, not translated.
int _polyglotMove(Position position, String uci) {
  final move = Move.parse(uci)! as NormalMove;
  var to = move.to;
  if (position.board.kings.has(move.from) && (move.to - move.from).abs() == 2) {
    final side = move.to > move.from ? CastlingSide.king : CastlingSide.queen;
    to = position.castles.rookOf(position.turn, side)!;
  }
  final promotion = switch (move.promotion) {
    Role.knight => 1,
    Role.bishop => 2,
    Role.rook => 3,
    Role.queen => 4,
    _ => 0,
  };
  return to.file.value |
      to.rank.value << 3 |
      move.from.file.value << 6 |
      move.from.rank.value << 9 |
      promotion << 12;
}

// ---------------------------------------------------------------------------------------------
// Explorer
// ---------------------------------------------------------------------------------------------

/// The Lichess opening explorer, rate limited and cached on disk.
class _Explorer {
  _Explorer({
    required this.token,
    required this.cacheDir,
    required this.speeds,
    required this.minInterval,
  });

  final String token;
  final Directory cacheDir;
  final List<String> speeds;
  final Duration minInterval;

  final _client = HttpClient();
  DateTime _lastRequest = DateTime.fromMillisecondsSinceEpoch(0);

  int fetched = 0;
  int cacheHits = 0;

  /// The moves played in [position], as `uci -> share of the games in that position`, most
  /// played first.
  Future<Map<String, double>> moves(Position position, List<int> ratings) async {
    final fen = position.fen;
    final json = await _get(fen, ratings);
    final moves = (json['moves']! as List<dynamic>).cast<Map<String, dynamic>>();

    var total = 0;
    final games = <String, int>{};
    for (final move in moves) {
      final count = (move['white']! as int) + (move['draws']! as int) + (move['black']! as int);
      games[move['uci']! as String] = count;
      total += count;
    }
    if (total == 0) return const {};
    return {for (final game in games.entries) game.key: game.value / total};
  }

  Future<Map<String, dynamic>> _get(String fen, List<int> ratings) async {
    final cached = _cacheFile(fen, ratings);
    if (cached.existsSync()) {
      cacheHits++;
      return jsonDecode(cached.readAsStringSync()) as Map<String, dynamic>;
    }

    final wait = minInterval - DateTime.now().difference(_lastRequest);
    if (wait > Duration.zero) await Future<void>.delayed(wait);
    _lastRequest = DateTime.now();

    final uri = Uri.https('explorer.lichess.ovh', '/lichess', {
      'variant': 'standard',
      'fen': fen,
      'speeds': speeds.join(','),
      'ratings': ratings.join(','),
      'topGames': '0',
      'recentGames': '0',
      'source': 'mobile',
    });

    final body = await _fetch(uri);
    cached.parent.createSync(recursive: true);
    cached.writeAsStringSync(body);
    fetched++;
    return jsonDecode(body) as Map<String, dynamic>;
  }

  /// Fetches [uri], backing off on the rate limiter rather than giving up on the crawl.
  Future<String> _fetch(Uri uri) async {
    for (var attempt = 0; ; attempt++) {
      final request = await _client.getUrl(uri);
      request.headers.set(HttpHeaders.authorizationHeader, 'Bearer $token');
      final response = await request.close();
      final body = await response.transform(utf8.decoder).join();

      if (response.statusCode == 200) return body;
      if (response.statusCode != 429 || attempt >= 5) {
        throw HttpException('${response.statusCode} for $uri: $body');
      }
      final backoff = Duration(seconds: 60 * (attempt + 1));
      stderr.writeln('rate limited, waiting ${backoff.inSeconds}s');
      await Future<void>.delayed(backoff);
    }
  }

  File _cacheFile(String fen, List<int> ratings) {
    final name = '${fen.replaceAll(RegExp('[^a-zA-Z0-9]'), '_')}.json';
    return File('${cacheDir.path}/${speeds.join('-')}_${ratings.join('-')}/$name');
  }
}

// ---------------------------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------------------------

Position _replay(List<String> ucis) {
  var position = Chess.initial as Position;
  for (final uci in ucis) {
    position = position.playUnchecked(Move.parse(uci)!);
  }
  return position;
}

String _san(Position position, String uci) => position.makeSan(Move.parse(uci)!).$2;

/// Half the L1 distance between two move distributions: 0 when they agree, 1 when they share
/// nothing.
double _totalVariationDistance(Map<String, double> a, Map<String, double> b) {
  final moves = {...a.keys, ...b.keys};
  final distance = moves.fold(0.0, (sum, uci) => sum + ((a[uci] ?? 0) - (b[uci] ?? 0)).abs());
  return distance / 2;
}

String _percent(double value, [int decimals = 1]) => '${(value * 100).toStringAsFixed(decimals)}%';

// ---------------------------------------------------------------------------------------------
// Options
// ---------------------------------------------------------------------------------------------

class _Options {
  const _Options({
    required this.dryRun,
    required this.out,
    required this.cacheDir,
    required this.ratings,
    required this.speeds,
    required this.shareThreshold,
    required this.maxPly,
    required this.dryRunMaxPly,
    required this.moveCutoff,
    required this.maxMoves,
    required this.rps,
  });

  factory _Options.parse(List<String> args) {
    final values = <String, String>{};
    var dryRun = false;
    for (final arg in args) {
      if (arg == '--dry-run') {
        dryRun = true;
        continue;
      }
      final separator = arg.indexOf('=');
      if (!arg.startsWith('--') || separator < 0) {
        stderr.writeln('Unknown argument: $arg');
        exit(2);
      }
      values[arg.substring(2, separator)] = arg.substring(separator + 1);
    }
    return _Options(
      dryRun: dryRun,
      out: values['out'] ?? 'assets/maia/book.bin',
      cacheDir: values['cache'] ?? '.cache/explorer',
      ratings: _ints(values['ratings']) ?? _defaultRatings,
      speeds: values['speeds']?.split(',') ?? _defaultSpeeds,
      shareThreshold: double.parse(values['share'] ?? '0.0025'),
      maxPly: int.parse(values['max-ply'] ?? '10'),
      dryRunMaxPly: int.parse(values['dry-run-max-ply'] ?? '6'),
      moveCutoff: double.parse(values['move-cutoff'] ?? '0.02'),
      maxMoves: int.parse(values['max-moves'] ?? '6'),
      rps: double.parse(values['rps'] ?? '1'),
    );
  }

  final bool dryRun;
  final String out;
  final String cacheDir;

  /// Explorer rating buckets, aggregated by the explorer in one response.
  final List<int> ratings;
  final List<String> speeds;

  /// Least share of the games played at the initial position a position must hold to be expanded.
  final double shareThreshold;

  /// Hard cap on the depth of the book, in half-moves, so it stays an opening book.
  final int maxPly;

  /// Depth the `--dry-run` probe walks before extrapolating.
  final int dryRunMaxPly;

  /// Least share of the games played in a position a move must hold to be kept.
  final double moveCutoff;
  final int maxMoves;

  /// Explorer requests per second. The explorer starts returning 429 above ~1/s.
  final double rps;

  _Options copyWith({int? maxPly}) => _Options(
    dryRun: dryRun,
    out: out,
    cacheDir: cacheDir,
    ratings: ratings,
    speeds: speeds,
    shareThreshold: shareThreshold,
    maxPly: maxPly ?? this.maxPly,
    dryRunMaxPly: dryRunMaxPly,
    moveCutoff: moveCutoff,
    maxMoves: maxMoves,
    rps: rps,
  );

  static List<int>? _ints(String? value) =>
      value?.split(',').map(int.parse).toList(growable: false);
}
