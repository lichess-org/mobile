// Replays every engine practice chapter against the engine the app plays them on, and judges each
// one with the app's own [PracticeGoal.judge], to find the chapters a player cannot solve however
// well they play.
//
// This is a measurement, not a test: it needs an engine binary, takes minutes, and what it reports
// is a fact about the content and the engine rather than about the code. It is run through
// `flutter test` all the same, because that is what lets it use the app's own judging code rather
// than a second copy of it that could drift — `PracticeGoal.judge` reaches package:flutter through
// `ClientEval`, so `dart run` cannot load it. Living here rather than under test/ keeps it out of
// the suite: CI runs `flutter test`, which only looks at test/.
//
//   scripts/practice_engine_check/build_engine.sh
//   flutter test scripts/practice_engine_check/goal_reachability_check.dart
//
// Two different searches, for two different questions. The player is assumed to *know the
// solution*, so its move comes from a deep search — a `mateIn` chapter asks the engine for the
// mate itself, since the fastest mate and the highest eval are not the same move, and an exercise
// that says "mate in 3" is not solved by a move that merely wins. The judging, and the opponent's
// answers, use the shallow eval the app itself has: that is the thing being measured. Why this is worth re-running — after an engine or network change,
// or a content refresh — and what it found on 2026-09-23 is in practice.md §13.
//
// The environment tunes it:
//
//   PRACTICE_ENGINE   the binary (default .cache/practice_engine/stockfish-light)
//   PRACTICE_DEPTH    the search depth, and so the eval every judgement is made on (default 15,
//                     which is kPracticeUsableDepth in release; debug builds of the app use 13).
//                     Below that constant — and this runs as a debug build, so below 13 — `judge`
//                     discards the eval as too shallow to rely on and every goal it decides by
//                     eval stays ongoing, which is worth knowing before reading such a run
//   PRACTICE_PLAYER_DEPTH  the depth the player's own moves are chosen at (default 24): how well
//                     the exercise is assumed to be solved, not what the app judges on
//   PRACTICE_MAX_MOVES     player moves allowed to a goal with no budget of its own (default 50)
//   PRACTICE_PROBE_DEPTH   how deep to look for the mate a `mateIn` judgement missed (default 30),
//                     which is what turns "the app failed this" into "the app needed depth 19"
//   PRACTICE_JOBS     engines running at once (default 6)
//   PRACTICE_REPORT   where the JSON report goes (default .cache/practice_engine/report.json)
//   PRACTICE_CHAPTER  a single chapter id, to look at one in isolation

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';

// dartchess has a `File` of its own — the board file — and this needs `dart:io`'s.
import 'package:dartchess/dartchess.dart' hide File;
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/practice/practice_goal.dart';
import 'package:lichess_mobile/src/model/practice/practice_structure.dart';

String _env(String name, String fallback) => Platform.environment[name]?.trim().isNotEmpty == true
    ? Platform.environment[name]!.trim()
    : fallback;

final _enginePath = _env('PRACTICE_ENGINE', '.cache/practice_engine/stockfish-light');
final _depth = int.parse(_env('PRACTICE_DEPTH', '15'));
final _playerDepth = int.parse(_env('PRACTICE_PLAYER_DEPTH', '24'));
final _probeDepth = int.parse(_env('PRACTICE_PROBE_DEPTH', '30'));
final _jobs = int.parse(_env('PRACTICE_JOBS', '6'));
final _reportPath = _env('PRACTICE_REPORT', '.cache/practice_engine/report.json');
final _onlyChapter = _env('PRACTICE_CHAPTER', '');

/// How many player moves a goal with no move budget of its own is given before it is called stuck.
///
/// A bare king can be mated with bishop and knight in 33 moves from the worst square, so anything
/// under that reports the technique's own length as a failure.
final _maxPlayerMoves = int.parse(_env('PRACTICE_MAX_MOVES', '50'));

void main() {
  test('every engine chapter can be solved by perfect play', () async {
    if (!File(_enginePath).existsSync()) {
      fail(
        'No engine at $_enginePath.\n'
        'Build it with scripts/practice_engine_check/build_engine.sh, or point PRACTICE_ENGINE at '
        'another UCI binary.',
      );
    }

    final structure = PracticeStructure.fromJson(
      jsonDecode(File('assets/practice.json').readAsStringSync()) as Map<String, dynamic>,
    );
    final chapters = [
      for (final section in structure.sections)
        for (final study in section.studies)
          for (final chapter in study.chapters)
            if (chapter is PracticeEngineChapter)
              if (_onlyChapter.isEmpty || chapter.id.value == _onlyChapter) (study, chapter),
    ];
    expect(chapters, isNotEmpty, reason: 'no engine chapter to check');

    final started = DateTime.now();
    final results = <_Result>[];
    // One engine per job, each working through its own slice: every chapter is independent, and
    // the engines are single-threaded, so this is the whole of the parallelism needed.
    await Future.wait([
      for (var job = 0; job < _jobs; job++)
        () async {
          final engine = await _Engine.start(_enginePath);
          try {
            for (var i = job; i < chapters.length; i += _jobs) {
              final (study, chapter) = chapters[i];
              final result = await _play(engine, study.name, chapter);
              results.add(result);
              // ignore: avoid_print
              print(result);
            }
          } finally {
            await engine.quit();
          }
        }(),
    ]);

    results.sort((a, b) => a.chapter.compareTo(b.chapter));
    final unsolved = results.where((r) => r.status != PracticeStatus.solved).toList();
    final report = const JsonEncoder.withIndent(' ').convert({
      'depth': _depth,
      'engine': _enginePath,
      'chapters': results.map((r) => r.toJson()).toList(),
    });
    File(_reportPath)
      ..createSync(recursive: true)
      ..writeAsStringSync('$report\n');

    // ignore: avoid_print
    print(
      '\n${results.length} chapters at depth $_depth in '
      '${DateTime.now().difference(started).inSeconds}s, ${unsolved.length} unsolved '
      '(report: $_reportPath)',
    );
    for (final result in unsolved) {
      // ignore: avoid_print
      print('  $result');
    }

    // Reported rather than asserted: the chapters that cannot be solved are known (practice.md
    // §13), and this run is how that list is kept up to date, not a gate.
  }, timeout: const Timeout(Duration(hours: 1)));
}

/// Plays [chapter] out, judging after every move exactly as `PracticeEngineController` does.
Future<_Result> _play(_Engine engine, String study, PracticeEngineChapter chapter) async {
  final initial = Chess.fromSetup(Setup.parseFen(chapter.fen));
  final budget = switch (chapter.goal) {
    PracticeGoalMateIn(:final moves) ||
    PracticeGoalDrawIn(:final moves) ||
    PracticeGoalEqualIn(:final moves) ||
    PracticeGoalEvalIn(:final moves) => moves,
    PracticeGoalMate() || PracticeGoalPromotion() => _maxPlayerMoves,
  };

  await engine.newGame();
  Position position = initial;
  final moves = <String>[];
  final positions = <Position>[initial];
  var nbMoves = 0;
  var status = PracticeStatus.ongoing;
  _Score? last;
  _MateGap? gap;
  // The app's own eval of the position on the board: what the last move was judged on, and what
  // the opponent picks its answer from. Null before anything has been searched.
  _SearchResult? onBoard;

  // One move past the budget, so that a goal which only fails by running out of moves is seen to
  // fail rather than left ongoing.
  while (status == PracticeStatus.ongoing && nbMoves <= budget && !position.isGameOver) {
    final isPlayerMove = position.turn == chapter.orientation;
    final move = isPlayerMove
        ? await engine.solve(chapter.fen, moves, position, chapter.goal, nbMoves, budget)
        : (onBoard ??= await engine.search(chapter.fen, moves, position)).best;
    if (move == null) break;
    position = position.play(move);
    moves.add(move.uci);
    positions.add(position);
    if (isPlayerMove) nbMoves++;

    // The eval of the position the move led to, which is what the controller judges on — and, for
    // the engine's own answer, what it would move with next.
    final after = await engine.search(chapter.fen, moves, position);
    onBoard = after;
    last = after.score;
    status = chapter.goal.judge(
      playerSide: chapter.orientation,
      position: position,
      lastMove: move,
      // The player plays the engine's best move, which is never a mistake or a blunder, so the
      // verdict path of `judge` is deliberately left out of this measurement.
      eval: after.score?.toEval(position, _depth),
      verdict: null,
      nbMoves: nbMoves,
      threefold: _isThreefold(positions),
    );
    // `PracticeEngineController._judge`: a game over the goal does not decide is a failure, since
    // nothing more can be played to reach it.
    if (status == PracticeStatus.ongoing && position.isGameOver) {
      status = PracticeStatus.failed;
    }

    // The player played the solution, so a `mateIn` chapter that is not on track here was failed
    // by the eval rather than by the move: either it reports no mate, or one too long for the
    // budget, which a deeper search shortens. How much deeper is the question this answers.
    if (chapter.goal case PracticeGoalMateIn(moves: final allowed) when isPlayerMove) {
      final left = allowed - nbMoves;
      final seen = after.score?.mateFor(chapter.orientation);
      if (!position.isGameOver && (seen == null || seen <= 0 || seen > left)) {
        gap = _MateGap(
          nbMoves: nbMoves,
          left: left,
          judged: after.score,
          probe: await engine.mateVisibleFrom(
            chapter.fen,
            moves,
            position,
            chapter.orientation,
            left,
          ),
        );
      }
    }
  }

  return _Result(
    study: study,
    chapter: chapter.name,
    id: chapter.id.value,
    goal: chapter.goal,
    playerSide: chapter.orientation,
    status: status,
    nbMoves: nbMoves,
    budget: budget,
    score: last,
    mateGap: gap,
    line: moves.join(' '),
  );
}

/// A `mateIn` judgement the app's own eval could not support, and the depth that would have.
class const _MateGap({
  /// The player moves played when the judgement was made.
  required final int nbMoves,

  /// The mate length still allowed by the goal at that point.
  required final int left,

  /// What the app had to judge on.
  required final _Score? judged,

  /// What a deeper search made of the same position.
  required final _Probe probe,
}) {
  @override
  String toString() {
    final found = probe.found;
    final deeper = found == null
        ? 'no mate in $left by depth $_probeDepth'
        : '#${found.mate} from depth ${found.depth}'
              '${found.depth <= _depth ? ' — which the judging search missed, so the reading is '
                        'unrepeatable rather than too shallow' : ' (${found.depth - _depth} plies deeper)'}';
    return 'after move $nbMoves, needing a mate in $left: judged on ${judged ?? '--'}, '
        'same search at depth $_depth said ${probe.atJudgingDepth ?? '--'}; $deeper';
  }
}

/// Whether the position now on the board has occurred three times, as the controller counts it.
bool _isThreefold(List<Position> positions) {
  String key(Position position) => position.fen.split(' ').take(4).join(' ');
  final current = key(positions.last);
  return positions.where((p) => key(p) == current).length >= 3;
}

/// A score from White's point of view, as the app stores evals.
class const _Score({final int? cp, final int? mate}) {
  /// The eval as `PracticeGoal.judge` reads it: only [depth] and the score are ever looked at.
  ClientEval toEval(Position position, int depth) => LocalEval(
    position: position,
    depth: depth,
    nodes: 0,
    millis: 0,
    searchTime: Duration.zero,
    threatMode: false,
    cp: cp,
    mate: mate,
    pvs: IList([PvData(moves: const IListConst([]), cp: cp, mate: mate)]),
  );

  /// The mate length from [side]'s point of view: positive when [side] mates.
  int? mateFor(Side side) => mate == null ? null : (side == Side.white ? mate! : -mate!);

  @override
  String toString() => mate != null ? '#${mate! > 0 ? '+' : ''}$mate' : '${cp ?? 0}cp';
}

typedef _SearchResult = ({_Score? score, NormalMove? best});

/// What a deeper look at a position the app misjudged found: the mate and the depth it needed,
/// and what that same search had at the judging depth.
typedef _Probe = ({({int depth, int mate})? found, _Score? atJudgingDepth});

/// A UCI engine driven one search at a time.
class _Engine(final Process _process, final StreamQueue<String> _lines) {
  static Future<_Engine> start(String path) async {
    final process = await Process.start(path, const []);
    unawaited(process.stderr.drain<void>());
    final engine = _Engine(
      process,
      StreamQueue(process.stdout.transform(utf8.decoder).transform(const LineSplitter())),
    );
    engine._send('uci');
    await engine._until((line) => line == 'uciok');
    // What `PracticeEngineController` asks of its evaluator: one line, one thread.
    engine._send('setoption name Threads value 1');
    engine._send('setoption name Hash value 128');
    engine._send('setoption name MultiPV value 1');
    await engine._ready();
    return engine;
  }

  void _send(String command) => _process.stdin.writeln(command);

  Future<String> _until(bool Function(String line) predicate) async {
    while (await _lines.hasNext) {
      final line = await _lines.next;
      if (predicate(line)) return line;
    }
    throw StateError('the engine stopped talking');
  }

  /// Waits for the engine to have taken in everything sent so far.
  ///
  /// Not optional: a `go` that arrives while the engine is still booting, or still setting up the
  /// position, is answered for whatever position it had, which looks like a search that found
  /// nothing at all.
  Future<void> _ready() async {
    _send('isready');
    await _until((line) => line == 'readyok');
  }

  Future<void> newGame() async {
    _send('ucinewgame');
    await _ready();
  }

  /// Searches the position [moves] leads to from [fen], to the depth the app judges at.
  Future<_SearchResult> search(String fen, List<String> moves, Position position) =>
      _search(fen, moves, position, 'go depth $_depth');

  /// The move the player is assumed to find, from a search deeper than the app's own.
  ///
  /// A `mateIn` chapter asks the engine for the mate of that length, because the move that mates
  /// fastest and the move with the best evaluation are often different — Attraction #7 is won by
  /// `Nc7+` at +12.96 and solved by `Qd8+`, which is mate in 3 — and the exercise is to find the
  /// mate. When no such mate is found, or for any other goal, the deep search's best move stands
  /// in for the solution.
  Future<NormalMove?> solve(
    String fen,
    List<String> moves,
    Position position,
    PracticeGoal goal,
    int nbMoves,
    int budget,
  ) async {
    if (goal is PracticeGoalMateIn) {
      final left = goal.moves - nbMoves;
      if (left > 0) {
        final mate = await _search(fen, moves, position, 'go mate $left depth $_playerDepth');
        if (mate.score?.mate != null && mate.best != null) return mate.best;
      }
    }
    return (await _search(fen, moves, position, 'go depth $_playerDepth')).best;
  }

  /// How deep this position has to be searched before a mate for [side] within [maxMate] moves
  /// shows up — the app's own question, `PracticeGoal.judge` reading the mate straight off the
  /// eval, asked of every depth in turn.
  ///
  /// Both numbers come from one search: what it had at the judging depth, and the first depth that
  /// sees the mate. Measuring them in separate searches would compare a cold reading with a warm
  /// one, since the engine keeps its table between searches — and when they disagree, that is the
  /// answer: the judgement is not deep enough to be repeatable, rather than wrong by a fixed
  /// number of plies.
  Future<_Probe> mateVisibleFrom(
    String fen,
    List<String> moves,
    Position position,
    Side side,
    int maxMate,
  ) async {
    if (position.isGameOver) return const (found: null, atJudgingDepth: null);
    _send('position fen $fen${moves.isEmpty ? '' : ' moves ${moves.join(' ')}'}');
    await _ready();
    _send('go depth $_probeDepth');
    ({int depth, int mate})? found;
    _Score? atJudgingDepth;
    var passedJudgingDepth = false;
    await _until((line) {
      if (line.startsWith('bestmove')) return true;
      if (!line.startsWith('info ') || !line.contains(' score ') || !line.contains(' pv ')) {
        return false;
      }
      final tokens = line.split(' ');
      final depth = int.parse(tokens[tokens.indexOf('depth') + 1]);
      final score = _parseInfo(line, position.turn);
      if (depth <= _depth) {
        atJudgingDepth = score;
      } else {
        passedJudgingDepth = true;
      }
      final mate = score?.mateFor(side);
      if (found == null && mate != null && mate > 0 && mate <= maxMate) {
        found = (depth: depth, mate: mate);
      }
      // Nothing deeper is wanted once both readings are in.
      if (found != null && (passedJudgingDepth || depth >= _depth)) _send('stop');
      return false;
    });
    return (found: found, atJudgingDepth: atJudgingDepth);
  }

  Future<_SearchResult> _search(
    String fen,
    List<String> moves,
    Position position,
    String go,
  ) async {
    if (position.isGameOver) return (score: null, best: null);
    _send('position fen $fen${moves.isEmpty ? '' : ' moves ${moves.join(' ')}'}');
    await _ready();
    _send(go);
    _Score? score;
    NormalMove? best;
    await _until((line) {
      if (line.startsWith('info ') && line.contains(' score ') && line.contains(' pv ')) {
        final parsed = _parseInfo(line, position.turn);
        if (parsed != null) score = parsed;
      } else if (line.startsWith('bestmove')) {
        final uci = line.split(' ')[1];
        best = uci == '(none)' ? null : Move.parse(uci) as NormalMove?;
        return true;
      }
      return false;
    });
    return (score: score, best: best);
  }

  /// The score of an `info` line, from White's point of view.
  _Score? _parseInfo(String line, Side turn) {
    final tokens = line.split(' ');
    final index = tokens.indexOf('score');
    // UCI scores are from the side to move; the app normalises them to White.
    final sign = turn == Side.white ? 1 : -1;
    final value = int.parse(tokens[index + 2]) * sign;
    return tokens[index + 1] == 'cp' ? _Score(cp: value) : _Score(mate: value);
  }

  Future<void> quit() async {
    _send('quit');
    await _process.exitCode.timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        _process.kill();
        return 0;
      },
    );
  }
}

class const _Result({
  required final String study,
  required final String chapter,
  required final String id,
  required final PracticeGoal goal,
  required final Side playerSide,
  required final PracticeStatus status,
  required final int nbMoves,
  required final int budget,
  required final _Score? score,

  /// Set on a `mateIn` chapter the eval could not keep on track, see [_MateGap].
  required final _MateGap? mateGap,
  required final String line,
}) {
  Map<String, dynamic> toJson() => {
    'study': study,
    'chapter': chapter,
    'id': id,
    'goal': goal.toString(),
    'player': playerSide.name,
    'status': status.name,
    'nbMoves': nbMoves,
    'budget': budget,
    'score': score?.toString(),
    'mateGap': mateGap?.toString(),
    'line': line,
  };

  @override
  String toString() =>
      '${status.name.padRight(7)} ${'$study / $chapter'.padRight(52)} '
      '${goal.toString().replaceFirst('PracticeGoal.', '').padRight(28)} '
      'reached ${score ?? '--'} in $nbMoves/$budget moves'
      '${mateGap == null ? '' : '\n          $mateGap'}';
}
