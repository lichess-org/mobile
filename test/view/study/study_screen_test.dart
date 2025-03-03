import 'dart:convert';

import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_preferences.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_preferences.dart';
import 'package:lichess_mobile/src/model/settings/preferences_storage.dart';
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
    chapters: chapters ?? IList([StudyChapterMeta(id: chapter.id, name: '', fen: null)]),
    chapter: chapter,
    hints: hints,
    deviationComments: deviationComments,
  );
}

void main() {
  group('Study screen', () {
    testWidgets('Displays PGN moves and comments', (WidgetTester tester) async {
      final mockRepository = MockStudyRepository();

      when(
        () => mockRepository.getStudy(id: testId),
      ).thenAnswer((_) async => (makeStudy(), '{root comment} 1. e4 {wow} e5 {such chess}'));

      final app = await makeTestProviderScopeApp(
        tester,
        home: const StudyScreen(id: testId),
        overrides: [studyRepositoryProvider.overrideWith((ref) => mockRepository)],
        defaultPreferences: {
          PrefCategory.analysis.storageKey: jsonEncode(
            AnalysisPrefs.defaults.copyWith(inlineNotation: true).toJson(),
          ),
          PrefCategory.engineEvaluation.storageKey: jsonEncode(
            EngineEvaluationPrefState.defaults.copyWith(isEnabled: false).toJson(),
          ),
        },
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
          StudyChapterMeta(id: StudyChapterId('1'), name: 'Chapter 1', fen: null),
          StudyChapterMeta(id: StudyChapterId('2'), name: 'Chapter 2', fen: null),
        ]),
      );

      final studyChapter2 = studyChapter1.copyWith(
        chapter: makeChapter(id: const StudyChapterId('2')),
      );

      when(
        () => mockRepository.getStudy(id: testId),
      ).thenAnswer((_) async => (studyChapter1, '{pgn 1}'));
      when(
        () => mockRepository.getStudy(id: testId, chapterId: const StudyChapterId('1')),
      ).thenAnswer((_) async => (studyChapter1, '{pgn 1}'));
      when(
        () => mockRepository.getStudy(id: testId, chapterId: const StudyChapterId('2')),
      ).thenAnswer((_) async => (studyChapter2, '{pgn 2}'));

      final app = await makeTestProviderScopeApp(
        tester,
        home: const StudyScreen(id: testId),
        overrides: [studyRepositoryProvider.overrideWith((ref) => mockRepository)],
      );
      await tester.pumpWidget(app);
      // Wait for study to load
      await tester.pumpAndSettle();

      expect(find.text('1. Chapter 1'), findsOneWidget);
      expect(find.text('2. Chapter 2'), findsNothing);

      expect(find.text('pgn 1'), findsOneWidget);
      expect(find.text('pgn 2'), findsNothing);

      // 2nd press should not have any effect, we're already at the last chapter
      await tester.tap(find.text('Next chapter'));
      // Wait for next chapter to load
      await tester.pumpAndSettle();
      await tester.tap(find.text('Next chapter'));
      // Wait for next chapter to load (even though it shouldn't)
      await tester.pumpAndSettle();

      expect(find.text('1. Chapter 1'), findsNothing);
      expect(find.text('2. Chapter 2'), findsOneWidget);

      expect(find.text('pgn 1'), findsNothing);
      expect(find.text('pgn 2'), findsOneWidget);

      // Open chapter selection dialog
      await tester.tap(find.byTooltip('2 Chapters'));
      // Wait for dialog to open
      await tester.pumpAndSettle();

      expect(
        find.descendant(of: find.byType(Scrollable), matching: find.text('1. Chapter 1')),
        findsOneWidget,
      );
      expect(
        find.descendant(of: find.byType(Scrollable), matching: find.text('2. Chapter 2')),
        findsOneWidget,
      );

      await tester.tap(find.text('1. Chapter 1'));
      // Wait for chapter to load
      await tester.pumpAndSettle();

      expect(find.text('1. Chapter 1'), findsOneWidget);
      expect(find.text('2. Chapter 2'), findsNothing);

      expect(find.text('pgn 1'), findsOneWidget);
      expect(find.text('pgn 2'), findsNothing);
    });

    testWidgets('Can play moves for both sides', (WidgetTester tester) async {
      final mockRepository = MockStudyRepository();
      when(() => mockRepository.getStudy(id: testId)).thenAnswer(
        (_) async => (
          makeStudy(chapter: makeChapter(id: const StudyChapterId('1'), orientation: Side.black)),
          '',
        ),
      );

      final app = await makeTestProviderScopeApp(
        tester,
        home: const StudyScreen(id: testId),
        overrides: [studyRepositoryProvider.overrideWith((ref) => mockRepository)],
        defaultPreferences: {
          PrefCategory.analysis.storageKey: jsonEncode(
            AnalysisPrefs.defaults.copyWith(inlineNotation: true).toJson(),
          ),
          PrefCategory.engineEvaluation.storageKey: jsonEncode(
            EngineEvaluationPrefState.defaults.copyWith(isEnabled: false).toJson(),
          ),
        },
      );
      await tester.pumpWidget(app);
      // Wait for study to load
      await tester.pumpAndSettle();

      await playMove(tester, 'e2', 'e4', orientation: Side.black);

      expect(find.byKey(const Key('e2-whitepawn')), findsNothing);
      expect(find.byKey(const Key('e4-whitepawn')), findsOneWidget);

      await playMove(tester, 'e7', 'e5', orientation: Side.black);

      expect(find.byKey(const Key('e5-blackpawn')), findsOneWidget);
      expect(find.byKey(const Key('e7-blackpawn')), findsNothing);

      expect(find.text('1. e4'), findsOneWidget);
      expect(find.text('e5'), findsOneWidget);
    });

    testWidgets('Interactive study', (WidgetTester tester) async {
      final mockRepository = MockStudyRepository();
      when(() => mockRepository.getStudy(id: testId)).thenAnswer(
        (_) async => (
          makeStudy(
            chapter: makeChapter(
              id: const StudyChapterId('1'),
              orientation: Side.white,
              gamebook: true,
            ),
          ),
          '''
[Event "Improve Your Chess Calculation: Candidates| Ex 1: Hard"]
[Site "https://lichess.org/study/xgZOEizT/OfF4eLmN"]
[Result "*"]
[Variant "Standard"]
[ECO "?"]
[Opening "?"]
[Annotator "https://lichess.org/@/RushConnectedPawns"]
[FEN "r1b2rk1/3pbppp/p3p3/1p6/2qBPP2/P1N2R2/1PPQ2PP/R6K w - - 0 1"]
[SetUp "1"]
[UTCDate "2024.10.23"]
[UTCTime "02:04:11"]
[ChapterMode "gamebook"]

{ We begin our lecture with an 'easy but not easy' example. White to play and win. }
1. Nd5!! { Brilliant! You noticed that the queen on c4 was kinda smothered. } (1. Ne2? { Not much to say after ...Qc7. }) 1... exd5 2. Rc3 Qa4 3. Rg3! { A fork, threatening Rg7 & b3. } { [%csl Gg7][%cal Gg3g7,Gd4g7,Gb2b3] } (3. Rxc8?? { Uh-oh! After Rc8, b3, there is the counter-sac Rxc2, which is winning for black!! } 3... Raxc8 4. b3 Rxc2!! 5. Qxc2 Qxd4 \$19) 3... g6 4. b3 \$18 { ...and the queen is trapped. GGs. If this was too hard for you, don't worry, there will be easier examples. } *
          ''',
        ),
      );

      final app = await makeTestProviderScopeApp(
        tester,
        home: const StudyScreen(id: testId),
        overrides: [studyRepositoryProvider.overrideWith((ref) => mockRepository)],
      );
      await tester.pumpWidget(app);
      // Wait for study to load
      await tester.pumpAndSettle();

      const introText =
          "We begin our lecture with an 'easy but not easy' example. White to play and win.";

      expect(find.text(introText), findsOneWidget);

      expect(
        find.text('Brilliant! You noticed that the queen on c4 was kinda smothered.'),
        findsNothing,
      );

      // Play a wrong move
      await playMove(tester, 'c3', 'a2');
      expect(find.text("That's not the move!"), findsOneWidget);
      expect(find.text(introText), findsNothing);

      // Wrong move will be taken back automatically after a short delay
      await tester.pump(const Duration(seconds: 1));
      expect(find.text("That's not move!"), findsNothing);
      expect(find.text(introText), findsOneWidget);

      // Play another wrong move, but this one has an explicit comment
      await playMove(tester, 'c3', 'e2');

      // If there's an explicit comment, the move is not taken back automatically
      // Verify this by waiting the same duration as above
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Not much to say after ...Qc7.'), findsOneWidget);
      expect(find.text(introText), findsNothing);

      await tester.tap(find.byTooltip('Retry'));
      await tester.pump(); // Wait for move to be taken back

      expect(find.text(introText), findsOneWidget);

      // Play the correct move
      await playMove(tester, 'c3', 'd5');

      expect(
        find.text('Brilliant! You noticed that the queen on c4 was kinda smothered.'),
        findsOneWidget,
      );

      // The move has an explicit feedback comment, so opponent move should not be played automatically
      await tester.pump(const Duration(seconds: 1));

      expect(
        find.text('Brilliant! You noticed that the queen on c4 was kinda smothered.'),
        findsOneWidget,
      );

      await tester.tap(find.byTooltip('Next'));
      await tester.pump(); // Wait for opponent move to be played

      expect(find.text('What would you play in this position?'), findsOneWidget);

      await playMove(tester, 'f3', 'c3');
      expect(find.text('Good move'), findsOneWidget);

      // No explicit feedback, so opponent move should be played automatically after delay
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('What would you play in this position?'), findsOneWidget);

      await playMove(tester, 'c3', 'g3');
      expect(find.text('A fork, threatening Rg7 & b3.'), findsOneWidget);

      await tester.tap(find.byTooltip('Next'));
      await tester.pump(); // Wait for opponent move to be played

      expect(find.text('What would you play in this position?'), findsOneWidget);

      await playMove(tester, 'b2', 'b3');

      expect(
        find.text(
          "...and the queen is trapped. GGs. If this was too hard for you, don't worry, there will be easier examples.",
        ),
        findsOneWidget,
      );

      expect(find.byTooltip('Play again'), findsOneWidget);
      expect(find.byTooltip('Next chapter'), findsOneWidget);
      expect(find.byTooltip('Analysis board'), findsOneWidget);
    });

    testWidgets('Interactive study hints and deviation comments', (WidgetTester tester) async {
      final mockRepository = MockStudyRepository();
      when(() => mockRepository.getStudy(id: testId)).thenAnswer(
        (_) async => (
          makeStudy(
            chapter: makeChapter(
              id: const StudyChapterId('1'),
              orientation: Side.white,
              gamebook: true,
            ),
            hints: ['Hint 1', null, null, null].lock,
            deviationComments: [null, 'Shown if any move other than d4 is played', null, null].lock,
          ),
          '1. e4 (1. d4 {Shown if d4 is played}) e5 2. Nf3',
        ),
      );

      final app = await makeTestProviderScopeApp(
        tester,
        home: const StudyScreen(id: testId),
        overrides: [studyRepositoryProvider.overrideWith((ref) => mockRepository)],
      );
      await tester.pumpWidget(app);
      // Wait for study to load
      await tester.pumpAndSettle();

      expect(find.text('Get a hint'), findsOneWidget);
      expect(find.text('Hint 1'), findsNothing);

      await tester.tap(find.text('Get a hint'));
      await tester.pump(); // Wait for hint to be shown
      expect(find.text('Hint 1'), findsOneWidget);
      expect(find.text('Get a hint'), findsNothing);

      await playMove(tester, 'e2', 'e3');
      expect(find.text('Shown if any move other than d4 is played'), findsOneWidget);
      await tester.tap(find.byTooltip('Retry'));
      await tester.pump(); // Wait for move to be taken back

      await playMove(tester, 'd2', 'd4');
      expect(find.text('Shown if d4 is played'), findsOneWidget);
      await tester.tap(find.byTooltip('Retry'));
      await tester.pump(); // Wait for move to be taken back

      expect(find.text('View the solution'), findsOneWidget);
      await tester.tap(find.byTooltip('View the solution'));
      // Wait for correct move and opponent's response to be played
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Get a hint'), findsNothing);

      // Play a wrong move again - generic feedback should be shown
      await playMove(tester, 'a2', 'a3');
      expect(find.text("That's not the move!"), findsOneWidget);
      // Wait for wrong move to be taken back
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('What would you play in this position?'), findsOneWidget);
      expect(find.text("That's not the move!"), findsNothing);
    });
  });
}
