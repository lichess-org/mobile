import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/analysis/opening_service.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/study/study.dart';
import 'package:lichess_mobile/src/model/study/study_controller.dart';
import 'package:lichess_mobile/src/model/study/study_repository.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/view/study/study_screen.dart';
import 'package:mocktail/mocktail.dart';

import '../../model/analysis/fake_opening_service.dart';
import '../../test_provider_scope.dart';

class MockStudyRepository extends Mock implements StudyRepository {}

const _testId = StudyId('test-id');

String _epd(Position pos) => pos.fen.split(' ').take(4).join(' ');

const _kingsPawnGame = FullOpening(
  eco: 'C20',
  name: "King's Pawn Game",
  fen: 'rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3',
  pgnMoves: 'e4',
  uciMoves: 'e2e4',
);

const _openGame = FullOpening(
  eco: 'C20',
  name: 'Open Game',
  fen: 'rnbqkbnr/pppp1ppp/8/4p3/4P3/8/PPPP1PPP/RNBQKBNR w KQkq e6',
  pgnMoves: 'e4 e5',
  uciMoves: 'e2e4 e7e5',
);

Study _makeStudy() {
  const chapter = StudyChapter(
    id: StudyChapterId('1'),
    setup: StudyChapterSetup(
      id: null,
      orientation: Side.white,
      variant: Variant.standard,
      fromFen: null,
    ),
    conceal: null,
    features: (computer: true, explorer: true),
    gamebook: false,
    practise: false,
  );
  return Study(
    id: _testId,
    name: '',
    liked: false,
    likes: 0,
    ownerId: null,
    features: (cloneable: false, chat: false, sticky: false),
    topics: const IList.empty(),
    chapters: IList(const [StudyChapterMeta(id: StudyChapterId('1'), name: '', fen: null)]),
    chapter: chapter,
    members: IMap(const {
      UserId(''): StudyMember(
        user: LightUser(id: UserId(''), name: ''),
        role: '',
      ),
    }),
    hints: const IList.empty(),
    deviationComments: const IList.empty(),
  );
}

void main() {
  final afterE4Epd = _epd(Chess.initial.playUnchecked(Move.parse('e2e4')!));
  final afterE5Epd = _epd(
    Chess.initial.playUnchecked(Move.parse('e2e4')!).playUnchecked(Move.parse('e7e5')!),
  );

  const options = (id: _testId, initialChapter: null);

  StudyState readState(WidgetTester tester) {
    final container = ProviderScope.containerOf(tester.element(find.byType(StudyScreen)));
    return container.read(studyControllerProvider(options)).requireValue;
  }

  group('Study opening detection', () {
    testWidgets('opening is set when navigating to a mainline position', (tester) async {
      final mockRepository = MockStudyRepository();
      when(
        () => mockRepository.getStudy(id: _testId),
      ).thenAnswer((_) async => (_makeStudy(), null, '1. e4 e5 2. Nf3'));

      final app = await makeTestProviderScopeApp(
        tester,
        home: const StudyScreen(options: options),
        overrides: {
          studyRepositoryProvider: studyRepositoryProvider.overrideWith((ref) => mockRepository),
          openingServiceProvider: openingServiceProvider.overrideWithValue(
            FakeOpeningService(openings: {afterE4Epd: _kingsPawnGame, afterE5Epd: _openGame}),
          ),
        },
      );

      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      // Starts at the start of the chapter. Navigate forward to e4 then e5.
      await tester.tap(find.byKey(const Key('goto-next')));
      await tester.pumpAndSettle();
      expect(readState(tester).currentBranchOpening?.name, "King's Pawn Game");

      await tester.tap(find.byKey(const Key('goto-next')));
      await tester.pumpAndSettle();
      expect(readState(tester).currentBranchOpening?.name, 'Open Game');
    });

    testWidgets('ancestor opening is used when current node has no direct opening', (tester) async {
      final mockRepository = MockStudyRepository();
      when(
        () => mockRepository.getStudy(id: _testId),
      ).thenAnswer((_) async => (_makeStudy(), null, '1. e4 e5 2. Nf3'));

      final app = await makeTestProviderScopeApp(
        tester,
        home: const StudyScreen(options: options),
        overrides: {
          studyRepositoryProvider: studyRepositoryProvider.overrideWith((ref) => mockRepository),
          openingServiceProvider: openingServiceProvider.overrideWithValue(
            FakeOpeningService(
              openings: {
                afterE4Epd: _kingsPawnGame,
                afterE5Epd: _openGame,
                // No opening for the Nf3 position — intentionally omitted.
              },
            ),
          ),
        },
      );

      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      // Navigate to the last mainline move (Nf3): no direct opening, but the e5
      // ancestor has 'Open Game'.
      await tester.tap(find.byKey(const Key('goto-next')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('goto-next')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('goto-next')));
      await tester.pumpAndSettle();

      expect(readState(tester).currentBranchOpening?.name, 'Open Game');
    });
  });
}
