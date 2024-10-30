import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/study/study.dart';
import 'package:lichess_mobile/src/model/study/study_repository.dart';
import 'package:lichess_mobile/src/view/study/study_screen.dart';
import 'package:mocktail/mocktail.dart';

import '../../test_helpers.dart';
import '../../test_provider_scope.dart';

class MockStudyRepository extends Mock implements StudyRepository {}

const testId = StudyId('test-id');

StudyChapter makeChapter({
  required StudyChapterId id,
  Side orientation = Side.white,
  bool gamebook = false,
}) {
  return StudyChapter(
    id: id,
    setup: StudyChapterSetup(
      id: null,
      orientation: orientation,
      variant: Variant.standard,
      fromFen: null,
    ),
    conceal: null,
    features: (computer: false, explorer: false),
    gamebook: gamebook,
    practise: false,
  );
}

Study makeStudy({
  StudyChapter? chapter,
  IList<StudyChapterMeta>? chapters,
  IList<String?> hints = const IList.empty(),
  IList<String?> deviationComments = const IList.empty(),
}) {
  chapter = chapter ?? makeChapter(id: const StudyChapterId('1'));
  return Study(
    id: testId,
    name: '',
    liked: false,
    likes: 0,
    ownerId: null,
    features: (cloneable: false, chat: false, sticky: false),
    topics: const IList.empty(),
    chapters: chapters ??
        IList([StudyChapterMeta(id: chapter.id, name: '', fen: null)]),
    chapter: chapter,
    hints: hints,
    deviationComments: deviationComments,
  );
}

void main() {
  group('Study screen', () {
    testWidgets('Displays PGN moves and comments', (WidgetTester tester) async {
      final mockRepository = MockStudyRepository();

      when(() => mockRepository.getStudy(id: testId)).thenAnswer(
        (_) async =>
            (makeStudy(), '{root comment} 1. e4 {wow} e5 {such chess}'),
      );

      final app = await makeTestProviderScopeApp(
        tester,
        home: const StudyScreen(id: testId),
        overrides: [
          studyRepositoryProvider.overrideWith(
            (ref) => mockRepository,
          ),
        ],
      );
      await tester.pumpWidget(app);

      // Wait for study to load
      await tester.pumpAndSettle();

      expect(find.text('root comment'), findsOneWidget);
      expect(find.text('1. e4'), findsOneWidget);
      expect(find.textContaining('wow'), findsOneWidget);
      expect(find.textContaining('e5'), findsOneWidget);
      expect(find.textContaining('such chess'), findsOneWidget);
    });

    testWidgets('Switch between chapters', (WidgetTester tester) async {
      final mockRepository = MockStudyRepository();

      final studyChapter1 = makeStudy(
        chapter: makeChapter(id: const StudyChapterId('1')),
        chapters: IList(const [
          StudyChapterMeta(
            id: StudyChapterId('1'),
            name: 'Chapter 1',
            fen: null,
          ),
          StudyChapterMeta(
            id: StudyChapterId('2'),
            name: 'Chapter 2',
            fen: null,
          ),
        ]),
      );

      final studyChapter2 = studyChapter1.copyWith(
        chapter: makeChapter(id: const StudyChapterId('2')),
      );

      when(() => mockRepository.getStudy(id: testId)).thenAnswer(
        (_) async => (studyChapter1, '{pgn 1}'),
      );
      when(
        () => mockRepository.getStudy(
          id: testId,
          chapterId: const StudyChapterId('1'),
        ),
      ).thenAnswer(
        (_) async => (studyChapter1, '{pgn 1}'),
      );
      when(
        () => mockRepository.getStudy(
          id: testId,
          chapterId: const StudyChapterId('2'),
        ),
      ).thenAnswer(
        (_) async => (studyChapter2, '{pgn 2}'),
      );

      final app = await makeTestProviderScopeApp(
        tester,
        home: const StudyScreen(id: testId),
        overrides: [
          studyRepositoryProvider.overrideWith(
            (ref) => mockRepository,
          ),
        ],
      );
      await tester.pumpWidget(app);
      // Wait for study to load
      await tester.pumpAndSettle();

      expect(find.text('Chapter 1'), findsOneWidget);
      expect(find.text('Chapter 2'), findsNothing);

      expect(find.text('pgn 1'), findsOneWidget);
      expect(find.text('pgn 2'), findsNothing);

      // 2nd press should not have any effect, we're already at the last chapter
      await tester.tap(find.text('Next chapter'));
      // Wait for next chapter to load
      await tester.pumpAndSettle();
      await tester.tap(find.text('Next chapter'));
      // Wait for next chapter to load (even though it shouldn't)
      await tester.pumpAndSettle();

      expect(find.text('Chapter 1'), findsNothing);
      expect(find.text('Chapter 2'), findsOneWidget);

      expect(find.text('pgn 1'), findsNothing);
      expect(find.text('pgn 2'), findsOneWidget);

      // Open chapter selection dialog
      await tester.tap(find.byTooltip('Chapters'));
      // Wait for dialog to open
      await tester.pumpAndSettle();

      expect(
        find.descendant(
          of: find.byType(ListView),
          matching: find.text('Chapter 1'),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byType(ListView),
          matching: find.text('Chapter 2'),
        ),
        findsOneWidget,
      );

      await tester.tap(find.text('Chapter 1'));
      // Wait for chapter to load
      await tester.pumpAndSettle();

      expect(find.text('Chapter 1'), findsOneWidget);
      expect(find.text('Chapter 2'), findsNothing);

      expect(find.text('pgn 1'), findsOneWidget);
      expect(find.text('pgn 2'), findsNothing);
    });

    testWidgets('Can play moves for both sides', (WidgetTester tester) async {
      final mockRepository = MockStudyRepository();
      when(() => mockRepository.getStudy(id: testId)).thenAnswer(
        (_) async => (
          makeStudy(
            chapter: makeChapter(
              id: const StudyChapterId('1'),
              orientation: Side.black,
            ),
          ),
          ''
        ),
      );

      final app = await makeTestProviderScopeApp(
        tester,
        home: const StudyScreen(id: testId),
        overrides: [
          studyRepositoryProvider.overrideWith(
            (ref) => mockRepository,
          ),
        ],
      );
      await tester.pumpWidget(app);
      // Wait for study to load
      await tester.pumpAndSettle();

      final boardRect = tester.getRect(find.byType(Chessboard));
      await playMove(tester, boardRect, 'e2', 'e4', orientation: Side.black);

      expect(find.byKey(const Key('e2-whitepawn')), findsNothing);
      expect(find.byKey(const Key('e4-whitepawn')), findsOneWidget);

      await playMove(tester, boardRect, 'e7', 'e5', orientation: Side.black);

      expect(find.byKey(const Key('e5-blackpawn')), findsOneWidget);
      expect(find.byKey(const Key('e7-blackpawn')), findsNothing);

      expect(find.text('1. e4'), findsOneWidget);
      expect(find.text('e5'), findsOneWidget);
    });
  });
}
