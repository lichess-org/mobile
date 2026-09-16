import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/practice/practice_gamebook_controller.dart';
import 'package:lichess_mobile/src/model/practice/practice_progress.dart';
import 'package:lichess_mobile/src/model/practice/practice_repository.dart';
import 'package:lichess_mobile/src/model/practice/practice_structure.dart';

import '../../binding.dart';
import '../../test_container.dart';

const _initialFen = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1';

/// White plays 1. e4 e5 2. Nf3 Nc6 3. Bc4, with a wrong black move and a wrong white move
/// anticipated by the author.
const _openingPgn =
    '''
[FEN "$_initialFen"]
[SetUp "1"]

{ Open with the king pawn } { [%cal Ge2e4] } 1. e4 1... e5 { Find the knight } (1... c5) 2. Nf3 { Develop } (2. Qh5 { Too early for the queen }) 2... Nc6 3. Bc4 *
''';

PracticeGamebookChapter _gamebook(
  String pgn, {
  String fen = _initialFen,
  List<String?> hints = const [],
  List<String?> deviations = const [],
}) => PracticeChapter.gamebook(
  id: const PracticeChapterId('gamebook'),
  name: 'Gamebook',
  fen: fen,
  orientation: Side.white,
  pgn: pgn,
  hints: hints.lock,
  deviations: deviations.lock,
) as PracticeGamebookChapter;

final _opening = _gamebook(
  _openingPgn,
  hints: ['Push a centre pawn', null, 'Develop a piece'],
  deviations: [null, 'Not that pawn'],
);

NormalMove _move(String uci) => Move.parse(uci)! as NormalMove;

/// Long enough for an uncommented opponent move to have been played.
final _afterOpponentMove = kGamebookOpponentMoveDelay + const Duration(milliseconds: 100);

void main() {
  TestLichessBinding.ensureInitialized();

  Future<(ProviderContainer, PracticeGamebookController Function())> start(
    PracticeGamebookChapter chapter,
  ) async {
    final container = await makeContainer();
    final provider = practiceGamebookControllerProvider(chapter);
    container.listen(provider, (_, _) {});
    await container.read(practiceProgressProvider.future);
    return (container, () => container.read(provider.notifier));
  }

  /// Waits for the chapter's progress to reach the database, which it does after the move.
  Future<int> savedNbMoves(ProviderContainer container, PracticeChapterId chapterId) async {
    final storage = await container.read(practiceProgressStorageProvider.future);
    final stopwatch = Stopwatch()..start();
    while (true) {
      if ((await storage.fetch()).nbMoves(chapterId) case final nbMoves?) return nbMoves;
      if (stopwatch.elapsed > const Duration(seconds: 5)) fail('The progress was not saved');
      await Future<void>.delayed(const Duration(milliseconds: 20));
    }
  }

  PracticeGamebookState stateOf(ProviderContainer container, PracticeGamebookChapter chapter) =>
      container.read(practiceGamebookControllerProvider(chapter));

  test('starts on the move to find, with the author comment, shapes and hint', () async {
    final (container, controller) = await start(_opening);
    final state = stateOf(container, _opening);

    expect(state.feedback, PracticeGamebookFeedback.play);
    expect(state.comment, 'Open with the king pawn');
    expect(state.shapes, [
      const PgnCommentShape(color: CommentShapeColor.green, from: Square.e2, to: Square.e4),
    ]);
    expect(state.hint, 'Push a centre pawn');
    expect(state.isHintShown, isFalse);

    controller().toggleHint();
    expect(stateOf(container, _opening).isHintShown, isTrue);
  });

  test('an uncommented opponent answer plays itself', () async {
    final (container, controller) = await start(_opening);

    controller().onUserMove(_move('e2e4'));
    expect(stateOf(container, _opening).feedback, PracticeGamebookFeedback.good);

    await Future<void>.delayed(_afterOpponentMove);
    final state = stateOf(container, _opening);
    expect(state.ply, 2);
    expect(state.lastMove, _move('e7e5'));
    expect(state.feedback, PracticeGamebookFeedback.play);
    expect(state.comment, 'Find the knight');
    expect(state.hint, 'Develop a piece');
  });

  test('a commented move waits for the player to move on', () async {
    final (container, controller) = await start(_opening);
    controller().onUserMove(_move('e2e4'));
    await Future<void>.delayed(_afterOpponentMove);

    controller().onUserMove(_move('g1f3'));
    await Future<void>.delayed(_afterOpponentMove);
    expect(stateOf(container, _opening).feedback, PracticeGamebookFeedback.good);
    expect(stateOf(container, _opening).comment, 'Develop');

    controller().next();
    expect(stateOf(container, _opening).ply, 4);
    expect(stateOf(container, _opening).feedback, PracticeGamebookFeedback.play);
  });

  test('a wrong move shows the deviation comment and waits for a retry', () async {
    final (container, controller) = await start(_opening);

    controller().onUserMove(_move('d2d4'));
    var state = stateOf(container, _opening);
    expect(state.feedback, PracticeGamebookFeedback.bad);
    expect(state.lastMove, _move('d2d4'));
    expect(state.comment, 'Not that pawn');

    await Future<void>.delayed(kGamebookRetryDelay + const Duration(milliseconds: 100));
    expect(stateOf(container, _opening).feedback, PracticeGamebookFeedback.bad);

    controller().retry();
    state = stateOf(container, _opening);
    expect(state.feedback, PracticeGamebookFeedback.play);
    expect(state.ply, 0);
    expect(state.wrongMove, isNull);
  });

  test('a wrong move the author anticipated shows its own comment', () async {
    final (container, controller) = await start(_opening);
    controller().onUserMove(_move('e2e4'));
    await Future<void>.delayed(_afterOpponentMove);

    controller().onUserMove(_move('d1h5'));
    final state = stateOf(container, _opening);
    expect(state.feedback, PracticeGamebookFeedback.bad);
    expect(state.comment, 'Too early for the queen');
  });

  test('an uncommented wrong move is taken back on its own', () async {
    final (container, controller) = await start(_opening);
    controller().onUserMove(_move('e2e4'));
    await Future<void>.delayed(_afterOpponentMove);

    controller().onUserMove(_move('b1c3'));
    expect(stateOf(container, _opening).feedback, PracticeGamebookFeedback.bad);
    expect(stateOf(container, _opening).comment, isNull);

    await Future<void>.delayed(kGamebookRetryDelay + const Duration(milliseconds: 100));
    expect(stateOf(container, _opening).feedback, PracticeGamebookFeedback.play);
    expect(stateOf(container, _opening).ply, 2);
  });

  test('the solution is shown for the move to find, and hidden once played', () async {
    final (container, controller) = await start(_opening);

    controller().toggleSolution();
    expect(stateOf(container, _opening).solution, _move('e2e4'));

    controller().onUserMove(_move('e2e4'));
    expect(stateOf(container, _opening).solution, isNull);
    expect(stateOf(container, _opening).isSolutionShown, isFalse);
  });

  test('reaching the end of the mainline completes the chapter', () async {
    final (container, controller) = await start(_opening);
    controller().onUserMove(_move('e2e4'));
    await Future<void>.delayed(_afterOpponentMove);
    controller().onUserMove(_move('g1f3'));
    controller().next();
    controller().onUserMove(_move('f1c4'));

    final state = stateOf(container, _opening);
    expect(state.feedback, PracticeGamebookFeedback.end);
    expect(state.nbMoves, 3);
    expect(await savedNbMoves(container, _opening.id), 3);
    expect(container.read(practiceProgressProvider).value!.nbMoves(_opening.id), 3);
  });

  test('the opponent plays first when the chapter starts with its move', () async {
    const fen = 'rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq - 0 1';
    final chapter = _gamebook('[FEN "$fen"]\n[SetUp "1"]\n\n1... e5 2. Nf3 *', fen: fen);
    final (container, _) = await start(chapter);

    expect(stateOf(container, chapter).feedback, PracticeGamebookFeedback.good);
    await Future<void>.delayed(kGamebookFirstMoveDelay + const Duration(milliseconds: 100));
    expect(stateOf(container, chapter).ply, 1);
    expect(stateOf(container, chapter).feedback, PracticeGamebookFeedback.play);
  });

  test('castling is recognised whichever way the king is moved', () async {
    const fen = 'r3k2r/8/8/8/8/8/8/R3K2R w KQkq - 0 1';
    final chapter = _gamebook('[FEN "$fen"]\n[SetUp "1"]\n\n1. O-O *', fen: fen);

    for (final uci in ['e1g1', 'e1h1']) {
      final (container, controller) = await start(chapter);
      controller().onUserMove(_move(uci));
      expect(stateOf(container, chapter).feedback, PracticeGamebookFeedback.end, reason: uci);
      expect(await savedNbMoves(container, chapter.id), 1);
      container.dispose();
    }
  });

  test('plays a real gamebook chapter from the asset', () async {
    final structure = await PracticeRepository(rootBundle).getStructure();
    final chapter =
        structure.chapter(const PracticeChapterId('mXNCYwCt'))! as PracticeGamebookChapter;
    final (container, controller) = await start(chapter);

    var state = stateOf(container, chapter);
    expect(state.feedback, PracticeGamebookFeedback.play);
    expect(state.comment, startsWith('In the previous chapter'));
    expect(state.hint, isNotNull);

    // Bd5 is anticipated by the author: it also wins, but it is not the move.
    controller().onUserMove(_move('c4d5'));
    state = stateOf(container, chapter);
    expect(state.feedback, PracticeGamebookFeedback.bad);
    expect(state.comment, contains('not the move I was looking for'));

    controller().retry();
    controller().onUserMove(_move('f6g6'));
    expect(stateOf(container, chapter).feedback, PracticeGamebookFeedback.end);
    expect(await savedNbMoves(container, chapter.id), 1);
  });
}
