import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/l10n/l10n_en.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/practice/practice_gamebook_controller.dart';
import 'package:lichess_mobile/src/model/practice/practice_progress.dart';
import 'package:lichess_mobile/src/model/practice/practice_repository.dart';
import 'package:lichess_mobile/src/model/practice/practice_structure.dart';
import 'package:lichess_mobile/src/view/practice/practice_chapter_screen.dart';
import 'package:lichess_mobile/src/view/practice/practice_screen.dart';

import '../../test_helpers.dart';
import '../../test_provider_scope.dart';

final l10n = AppLocalizationsEn();

const _fen = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1';

/// A small practice: one study with a gamebook and a lesson, and one with a mate in one.
final _structure = PracticeStructure.fromJson({
  'sections': [
    {
      'id': 'openings',
      'name': 'Openings',
      'studies': [
        {
          'id': 'study001',
          'slug': 'first-moves',
          'name': 'First moves',
          'chapters': [
            {
              'id': 'gamebk01',
              'name': 'Find e4',
              'kind': 'gamebook',
              'orientation': 'white',
              'fen': _fen,
              'pgn': '[FEN "$_fen"]\n[SetUp "1"]\n\n{ Take the centre } 1. e4 { Well done } *',
            },
            {
              'id': 'lesson01',
              'name': 'A short game',
              'kind': 'lesson',
              'orientation': 'white',
              'fen': _fen,
              'description': 'Watch how the game goes.',
              'pgn': '1. e4 { The king pawn } 1... e5 *',
            },
          ],
        },
      ],
    },
    {
      'id': 'checkmates',
      'name': 'Checkmates',
      'studies': [
        {
          'id': 'study002',
          'slug': 'mates',
          'name': 'Mates',
          'chapters': [
            {
              'id': 'engine01',
              'name': 'Queen mate',
              'kind': 'practice',
              'orientation': 'white',
              'fen': 'k7/8/1K6/8/8/8/7Q/8 w - - 0 1',
              'description': 'Deliver mate.',
              'goal': {'result': 'mateIn', 'moves': 1},
            },
          ],
        },
      ],
    },
  ],
});

final _overrides = {
  practiceStructureProvider: practiceStructureProvider.overrideWith((ref) => _structure),
};

PracticeChapter _chapter(String id) => _structure.chapter(PracticeChapterId(id))!;

ProviderContainer _container(WidgetTester tester, Type screen) =>
    ProviderScope.containerOf(tester.element(find.byType(screen)));

void main() {
  testWidgets('lists the studies, opens the chapter to play, and comes back to the list', (
    tester,
  ) async {
    final app = await makeTestProviderScopeApp(
      tester,
      home: const PracticeScreen(),
      overrides: _overrides,
    );
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    expect(find.text('Openings'), findsOneWidget);
    expect(find.text('Checkmates'), findsOneWidget);
    expect(find.text('0 / 2'), findsOneWidget);
    expect(find.text('0 / 1'), findsOneWidget);

    await tester.tap(find.text('First moves'));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(PracticeChapterScreen, 'Find e4'), findsOneWidget);
    expect(find.text('Take the centre'), findsOneWidget);

    // Another chapter of the study, from the chapter list.
    await tester.tap(find.byTooltip('Chapters'));
    await tester.pumpAndSettle();
    expect(find.text(l10n.studyInteractiveLesson), findsOneWidget);
    expect(find.text('Lesson'), findsOneWidget);
    await tester.tap(find.text('A short game'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(PracticeChapterScreen, 'A short game'), findsOneWidget);

    // Back goes straight to the practice menu, whatever chapters were visited.
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byType(PracticeChapterScreen), findsNothing);
    expect(find.text('Openings'), findsOneWidget);
  });

  testWidgets('a gamebook completes when its moves are found, and moves on', (tester) async {
    final app = await makeTestProviderScopeApp(
      tester,
      home: PracticeChapterScreen(chapter: _chapter('gamebk01')),
      overrides: _overrides,
    );
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    expect(find.text('Take the centre'), findsOneWidget);
    await playMove(tester, 'e2', 'e4');
    await tester.pumpAndSettle();

    expect(boardHasPiece(tester, Square.e4, Piece.whitePawn), isTrue);
    expect(find.text(l10n.studyYouCompletedThisLesson), findsOneWidget);
    expect(find.text('Well done'), findsOneWidget);

    final container = _container(tester, PracticeChapterScreen);
    expect(
      container.read(practiceProgressProvider).value!.isDone(const PracticeChapterId('gamebk01')),
      isTrue,
    );

    await tester.tap(find.text(l10n.studyNextChapter));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(PracticeChapterScreen, 'A short game'), findsOneWidget);
  });

  testWidgets('a wrong gamebook move is taken back', (tester) async {
    final app = await makeTestProviderScopeApp(
      tester,
      home: PracticeChapterScreen(chapter: _chapter('gamebk01')),
      overrides: _overrides,
    );
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    await playMove(tester, 'd2', 'd4');
    await tester.pump();
    expect(find.text(l10n.puzzleNotTheMove), findsOneWidget);
    expect(boardHasPiece(tester, Square.d4, Piece.whitePawn), isTrue);

    await tester.pump(kGamebookRetryDelay);
    await tester.pumpAndSettle();
    expect(boardHasPiece(tester, Square.d2, Piece.whitePawn), isTrue);
    expect(find.text(l10n.puzzleNotTheMove), findsNothing);
  });

  testWidgets('a lesson is browsed move by move, and is done once opened', (tester) async {
    final app = await makeTestProviderScopeApp(
      tester,
      home: PracticeChapterScreen(chapter: _chapter('lesson01')),
      overrides: _overrides,
    );
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    expect(find.text('Watch how the game goes.'), findsOneWidget);
    final container = _container(tester, PracticeChapterScreen);
    expect(
      container.read(practiceProgressProvider).value!.isDone(const PracticeChapterId('lesson01')),
      isTrue,
    );

    await tester.tap(find.byIcon(CupertinoIcons.chevron_forward));
    await tester.pumpAndSettle();
    expect(boardHasPiece(tester, Square.e4, Piece.whitePawn), isTrue);
    expect(find.text('The king pawn'), findsOneWidget);
  });

  testWidgets('an engine chapter shows its goal, and success once reached', (tester) async {
    final app = await makeTestProviderScopeApp(
      tester,
      home: PracticeChapterScreen(chapter: _chapter('engine01')),
      overrides: _overrides,
    );
    await tester.pumpWidget(app);
    await tester.pump();

    expect(find.text('Checkmate the opponent in 1 move'), findsOneWidget);
    expect(find.text('Deliver mate.'), findsOneWidget);

    await playMove(tester, 'h2', 'h8');
    await tester.pump();

    expect(find.text('Success!'), findsOneWidget);
    expect(find.text('Next exercise'), findsNothing, reason: 'the last chapter of its study');
    expect(find.text('Back to practice'), findsOneWidget);

    // Lets the engine the chapter started go.
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 10));
  });
}
