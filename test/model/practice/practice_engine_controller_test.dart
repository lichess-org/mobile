import 'package:dartchess/dartchess.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/engine/engine_spec.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_preferences.dart';
import 'package:lichess_mobile/src/model/engine/work.dart';
import 'package:lichess_mobile/src/model/offline_computer/practice_analyser.dart';
import 'package:lichess_mobile/src/model/offline_computer/practice_comment.dart';
import 'package:lichess_mobile/src/model/practice/practice_engine_controller.dart';
import 'package:lichess_mobile/src/model/practice/practice_goal.dart';
import 'package:lichess_mobile/src/model/practice/practice_progress.dart';
import 'package:lichess_mobile/src/model/practice/practice_structure.dart';

import '../../binding.dart';
import '../../test_container.dart';
import '../engine/fake_engine.dart';

/// The position part of a FEN, which is what the engine is scripted by.
String _epd(String fen) => fen.split(' ').take(4).join(' ');

/// An engine that answers every search at once, at the target depth, with a scripted line.
///
/// Scores are from White's point of view. A position with no script gets an equal score and the
/// first legal move.
class _ScriptedEngine() extends FakeEngine {
  final Map<String, ({int? cp, int? mate, String best})> lines = {};

  /// The positions searched, in order.
  final List<String> searched = [];

  void script(String fen, {int? cp, int? mate, required String best}) =>
      lines[_epd(fen)] = (cp: cp, mate: mate, best: best);

  @override
  void onGo(FakeEngineSession session, List<String> parts) {
    final position = session.position;
    if (position == null) return;
    final key = _epd(position.fen);
    searched.add(key);

    final line = lines[key];
    final legal = makeLegalMoves(position);
    final best =
        line?.best ??
        (legal.isEmpty
            ? null
            : NormalMove(from: legal.keys.first, to: legal.values.first.first).uci);
    if (best == null) return;

    final sign = position.turn == Side.white ? 1 : -1;
    final score = line?.mate != null
        ? 'mate ${line!.mate! * sign}'
        : 'cp ${(line?.cp ?? 0) * sign}';
    session.emit(
      'info depth $kPracticeTargetDepth seldepth $kPracticeTargetDepth multipv 1 score $score '
      'nodes 100000 nps 100000 hashfull 0 tbhits 0 time 1000 pv $best',
    );
    session.emit('bestmove $best');
  }
}

PracticeEngineChapter _chapter(String fen, PracticeGoal goal, {Side orientation = Side.white}) =>
    PracticeChapter.engine(
      id: const PracticeChapterId('chapter1'),
      name: 'Chapter',
      fen: fen,
      orientation: orientation,
      goal: goal,
    ) as PracticeEngineChapter;

/// White: Ke3, Qa1, Rh1. Black: Kd6.
const _queenAndRook = '8/8/3k4/8/8/4K3/8/Q6R w - - 0 1';
const _afterRh6 = '8/8/3k3R/8/8/4K3/8/Q7 b - - 1 1';

Future<void> _waitFor(bool Function() condition) async {
  final stopwatch = Stopwatch()..start();
  while (!condition()) {
    if (stopwatch.elapsed > const Duration(seconds: 5)) fail('Timed out waiting for a condition');
    await Future<void>.delayed(const Duration(milliseconds: 20));
  }
}

void main() {
  TestLichessBinding.ensureInitialized();

  late _ScriptedEngine engine;

  setUp(() {
    engine = _ScriptedEngine();
    fakeEngine = engine;
  });

  Future<(ProviderContainer, PracticeEngineController Function())> start(
    PracticeEngineChapter chapter,
  ) async {
    final container = await makeContainer();
    final provider = practiceEngineControllerProvider(chapter);
    container.listen(provider, (_, _) {});
    await container.read(practiceProgressProvider.future);
    return (container, () => container.read(provider.notifier));
  }

  PracticeEngineState stateOf(ProviderContainer container, PracticeEngineChapter chapter) =>
      container.read(practiceEngineControllerProvider(chapter));

  group('PracticeEngineController', () {
    final chapter = _chapter(_queenAndRook, const PracticeGoal.mate());

    test('analyses the initial position with the small-net Stockfish', () async {
      final container = await makeContainer();
      await container
          .read(engineEvaluationPreferencesProvider.notifier)
          .setEvaluationFunction(ChessEnginePref.sfLatest);
      container.listen(practiceEngineControllerProvider(chapter), (_, _) {});

      await _waitFor(() => stateOf(container, chapter).eval != null);
      expect(engine.searched.first, _epd(_queenAndRook));
      expect(engine.spec, const StockfishSpec.light());
    });

    test('the engine answers a good move with its best move', () async {
      engine.script(_queenAndRook, mate: 5, best: 'h1h6');
      engine.script(_afterRh6, mate: 5, best: 'd6c5');
      final (container, controller) = await start(chapter);
      await _waitFor(() => stateOf(container, chapter).eval != null);

      controller().onUserMove(const NormalMove(from: Square.h1, to: Square.h6));
      await _waitFor(() => stateOf(container, chapter).steps.length == 2);

      final state = stateOf(container, chapter);
      expect(state.steps.last.sanMove.move.uci, 'd6c5');
      expect(state.feedback?.verdict, MoveVerdict.goodMove);
      expect(state.status, PracticeStatus.ongoing);
      expect(state.nbMoves, 1);
      expect(state.isPlayerTurn, isTrue);
      expect(state.canPlay, isTrue);
    });

    test('a blunder fails the chapter, shows the better move, and gets no answer', () async {
      engine.script(_queenAndRook, mate: 5, best: 'h1h6');
      engine.script('8/8/3k4/8/8/4K3/Q7/7R b - - 1 1', cp: 0, best: 'd6c5');
      final (container, controller) = await start(chapter);
      await _waitFor(() => stateOf(container, chapter).eval != null);

      controller().onUserMove(const NormalMove(from: Square.a1, to: Square.a2));
      await _waitFor(() => stateOf(container, chapter).status != PracticeStatus.ongoing);

      final state = stateOf(container, chapter);
      expect(state.status, PracticeStatus.failed);
      expect(state.feedback?.verdict, MoveVerdict.blunder);
      expect(state.feedback?.bestMove?.san, 'Rh6+');
      expect(state.steps, hasLength(1));
      expect(state.isEngineThinking, isFalse);
      expect(state.canPlay, isFalse);
    });

    test('solving records the progress with the moves played', () async {
      final mateInOne = _chapter(
        'k7/8/1K6/8/8/8/7Q/8 w - - 0 1',
        const PracticeGoal.mateIn(moves: 1),
      );
      final (container, controller) = await start(mateInOne);

      controller().onUserMove(const NormalMove(from: Square.h2, to: Square.h8));
      await _waitFor(() => stateOf(container, mateInOne).status != PracticeStatus.ongoing);

      expect(stateOf(container, mateInOne).status, PracticeStatus.solved);
      expect(container.read(practiceProgressProvider).value!.nbMoves(mateInOne.id), 1);

      // And it is persisted, not only in memory.
      final storage = await container.read(practiceProgressStorageProvider.future);
      final stopwatch = Stopwatch()..start();
      while ((await storage.fetch()).nbMoves(mateInOne.id) == null) {
        if (stopwatch.elapsed > const Duration(seconds: 5)) fail('The progress was not saved');
        await Future<void>.delayed(const Duration(milliseconds: 20));
      }
    });

    test('a game over the goal does not decide is a failure', () async {
      // The king takes the last piece: a dead draw, in a chapter that asks for mate.
      final deadDraw = _chapter('k7/8/8/8/8/8/1q6/K7 w - - 0 1', const PracticeGoal.mate());
      final (container, controller) = await start(deadDraw);

      controller().onUserMove(const NormalMove(from: Square.a1, to: Square.b2));
      await _waitFor(() => stateOf(container, deadDraw).status != PracticeStatus.ongoing);

      expect(stateOf(container, deadDraw).status, PracticeStatus.failed);
      expect(container.read(practiceProgressProvider).value!.isDone(deadDraw.id), isFalse);
    });

    test('the engine moves first when the chapter starts with the opponent to move', () async {
      const fen = '8/8/3k4/8/8/4K3/8/Q6R b - - 0 1';
      engine.script(fen, cp: 0, best: 'd6c5');
      final opponentFirst = _chapter(fen, const PracticeGoal.mate());
      final (container, _) = await start(opponentFirst);

      await _waitFor(() => stateOf(container, opponentFirst).steps.length == 1);

      final state = stateOf(container, opponentFirst);
      expect(state.steps.single.sanMove.move.uci, 'd6c5');
      expect(state.nbMoves, 0, reason: "the engine's first move is not the player's");
      expect(state.canPlay, isTrue);
    });

    test('the hint shows the piece, then the move, then nothing', () async {
      engine.script(_queenAndRook, mate: 5, best: 'h1h6');
      final (container, controller) = await start(chapter);
      await _waitFor(() => stateOf(container, chapter).eval != null);

      controller().hint();
      expect(stateOf(container, chapter).hint, const PracticeHint.piece(Square.h1));
      controller().hint();
      expect(
        stateOf(container, chapter).hint,
        const PracticeHint.move(NormalMove(from: Square.h1, to: Square.h6)),
      );
      controller().hint();
      expect(stateOf(container, chapter).hint, isNull);
    });

    test('retry starts over and drops the answer still coming', () async {
      engine.script(_queenAndRook, mate: 5, best: 'h1h6');
      engine.script(_afterRh6, mate: 5, best: 'd6c5');
      final (container, controller) = await start(chapter);
      await _waitFor(() => stateOf(container, chapter).eval != null);

      controller().onUserMove(const NormalMove(from: Square.h1, to: Square.h6));
      controller().retry();

      var state = stateOf(container, chapter);
      expect(state.steps, isEmpty);
      expect(state.status, PracticeStatus.ongoing);
      expect(state.feedback, isNull);

      // Long enough for the answer to the abandoned move to have come and gone.
      await Future<void>.delayed(const Duration(milliseconds: 600));
      state = stateOf(container, chapter);
      expect(state.steps, isEmpty);
      expect(state.canPlay, isTrue);
    });
  });

  group('PracticeEngineState', () {
    test('detects a threefold repetition, counting the initial position', () {
      final chapter = _chapter(_queenAndRook, const PracticeGoal.drawIn(moves: 10));
      var state = PracticeEngineState.initial(
        chapter,
        Chess.fromSetup(Setup.parseFen(_queenAndRook)),
      );
      void play(String uci) {
        final move = Move.parse(uci)!;
        final (position, san) = state.position.makeSan(move);
        state = state.copyWith(
          steps: state.steps.add(Step(position: position, sanMove: SanMove(san, move))),
        );
      }

      for (final uci in ['e3f3', 'd6d7', 'f3e3', 'd7d6', 'e3f3', 'd6d7', 'f3e3']) {
        play(uci);
        expect(state.isThreefoldRepetition, isFalse, reason: uci);
      }
      play('d7d6');
      expect(state.isThreefoldRepetition, isTrue);
      expect(state.nbMoves, 4);
    });
  });
}
