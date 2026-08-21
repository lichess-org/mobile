import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/study/study.dart';
import 'package:lichess_mobile/src/model/study/study_repository.dart';
import 'package:lichess_mobile/src/view/study/study_screen.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';

import '../../model/auth/fake_auth_storage.dart';
import '../../test_helpers.dart';
import '../../test_provider_scope.dart';

class MockStudyRepository extends Mock implements StudyRepository {}

const _testId = StudyId('test-id');

const _originalSettings = StudySettings(
  computer: UserSelection.everyone,
  explorer: UserSelection.everyone,
  cloneable: UserSelection.everyone,
  shareable: UserSelection.everyone,
  chat: UserSelection.member,
  sticky: true,
  description: false,
);

Study _makeStudy({
  String name = 'Original name',
  StudyVisibility visibility = StudyVisibility.public,
  StudySettings settings = _originalSettings,
}) {
  const chapter = StudyChapter(
    id: StudyChapterId('1'),
    setup: StudyChapterSetup(
      id: null,
      orientation: Side.white,
      variant: Variant.standard,
      fromFen: null,
    ),
    conceal: null,
    features: (computer: false, explorer: false),
    gamebook: false,
    practise: false,
  );
  return Study(
    id: _testId,
    name: name,
    liked: false,
    likes: 0,
    ownerId: fakeAuthUser.user.id,
    features: (cloneable: true, chat: true, sticky: true),
    visibility: visibility,
    settings: settings,
    topics: const IList.empty(),
    chapters: IList(const [StudyChapterMeta(id: StudyChapterId('1'), name: '', fen: null)]),
    chapter: chapter,
    members: IMap({fakeAuthUser.user.id: StudyMember(user: fakeAuthUser.user, role: 'w')}),
    hints: const IList.empty(),
    deviationComments: const IList.empty(),
  );
}

/// Opens the study's overflow menu and taps "Edit study", exactly as a real owner would.
Future<void> _openEditStudyScreen(WidgetTester tester) async {
  await tester.tap(findByTooltip('Menu'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Edit study'));
  await tester.pumpAndSettle();
}

void main() {
  group('EditStudyScreen', () {
    testWidgets('Pre-fills the current study values', (tester) async {
      final mockRepository = MockStudyRepository();
      when(
        () => mockRepository.getStudy(
          id: _testId,
          chapterId: any(named: 'chapterId'),
        ),
      ).thenAnswer((_) async => (_makeStudy(), null, ''));

      final app = await makeTestProviderScopeApp(
        tester,
        home: const StudyScreen(options: (id: _testId, initialChapter: null)),
        overrides: {
          studyRepositoryProvider: studyRepositoryProvider.overrideWith((ref) => mockRepository),
        },
        authUser: fakeAuthUser,
      );
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      await _openEditStudyScreen(tester);

      expect(tester.widget<TextField>(find.byType(TextField)).controller!.text, 'Original name');
      expect(find.text('Public'), findsOneWidget);
    });

    testWidgets('Saves changes and pops once the server confirms them', (tester) async {
      final mockRepository = MockStudyRepository();
      var editApplied = false;
      when(
        () => mockRepository.getStudy(
          id: _testId,
          chapterId: any(named: 'chapterId'),
        ),
      ).thenAnswer(
        (_) async => (editApplied ? _makeStudy(name: 'New name') : _makeStudy(), null, ''),
      );

      final app = await makeTestProviderScopeApp(
        tester,
        home: const StudyScreen(options: (id: _testId, initialChapter: null)),
        overrides: {
          studyRepositoryProvider: studyRepositoryProvider.overrideWith((ref) => mockRepository),
        },
        authUser: fakeAuthUser,
      );
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      await _openEditStudyScreen(tester);

      await tester.enterText(find.byType(TextField), 'New name');
      editApplied = true;

      await tester.tap(findByTooltip('Save'));
      // The save flow polls the server (with growing delays) before confirming: pumpAndSettle
      // drives the fake clock through all of it in virtual, not real, time.
      await tester.pumpAndSettle();

      // The edit screen popped back to the study screen, confirming success.
      expect(find.text('Edit study'), findsNothing);
    });

    testWidgets('Shows an error and stays open when the server rejects the change', (tester) async {
      final mockRepository = MockStudyRepository();
      // The server never actually applies the edit, exactly like when the caller has lost
      // owner/admin permissions: no error is ever sent back, the message is simply dropped.
      when(
        () => mockRepository.getStudy(
          id: _testId,
          chapterId: any(named: 'chapterId'),
        ),
      ).thenAnswer((_) async => (_makeStudy(), null, ''));

      final app = await makeTestProviderScopeApp(
        tester,
        home: const StudyScreen(options: (id: _testId, initialChapter: null)),
        overrides: {
          studyRepositoryProvider: studyRepositoryProvider.overrideWith((ref) => mockRepository),
        },
        authUser: fakeAuthUser,
      );
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      await _openEditStudyScreen(tester);

      await tester.enterText(find.byType(TextField), 'New name');
      await tester.tap(findByTooltip('Save'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Could not save changes'), findsOneWidget);
      // The screen stays open so the user doesn't lose their edits.
      expect(find.text('Edit study'), findsOneWidget);
    });
  });
}
