import 'dart:convert';

import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/study/study.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/view/study/create_study_chapter_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:mocktail/mocktail.dart';

import '../../model/auth/fake_auth_storage.dart';
import '../../network/fake_http_client_factory.dart';
import '../../test_bottom_sheet_opener.dart';
import '../../test_helpers.dart';
import '../../test_provider_scope.dart';

class OnChaptersCreatedCallback extends Mock {
  void call(StudyId studyId, IList<StudyChapterId> chapterIds);
}

void main() {
  group('CreateStudyChapterBottomSheet', () {
    testWidgets('Create empty chapter of existing study', (tester) async {
      final callback = OnChaptersCreatedCallback();

      final app = await makeTestProviderScopeApp(
        tester,
        home: TestBottomSheetOpener(
          builder: (_) => CreateStudyChapterBottomSheet(
            params: CreateChapterOfExistingStudy(const StudyId('test-id')),
            chapterNumber: 1,
            onChaptersCreated: callback.call,
          ),
        ),
        overrides: {
          httpClientFactoryProvider: httpClientFactoryProvider.overrideWith(
            (ref) => FakeHttpClientFactory(
              () => MockClient((request) {
                if (request.url.path == '/api/study/test-id/import-pgn' &&
                    request.method == 'POST') {
                  expect(request.bodyFields, containsPair('name', 'Chapter 1'));
                  expect(request.bodyFields, containsPair('orientation', 'black'));
                  expect(request.bodyFields, containsPair('variant', 'chess960'));
                  expect(request.bodyFields, containsPair('initial', 'false'));

                  final pgn = PgnGame.parsePgn(request.bodyFields['pgn']!);
                  expect(
                    pgn,
                    isA<PgnGame>().having((p) => p.moves.children.isEmpty, 'empty moves', isTrue),
                  );

                  return mockResponse(
                    jsonEncode({
                      'chapters': [
                        {'id': 'new-chapter'},
                      ],
                    }),
                    200,
                  );
                }
                return mockResponse('', 404);
              }),
            ),
          ),
        },
        authUser: fakeAuthUser,
      );

      await tester.pumpWidget(app);

      await TestBottomSheetOpener.openBottomSheet(tester);

      expect(find.byType(CreateStudyChapterBottomSheet), findsOneWidget);

      // Default chapter text
      expect(find.text('Chapter 1'), findsOneWidget);

      // Change orientation
      await tester.tap(find.text('White'));
      await tester.pumpAndSettle(); // wait for the dialog to open
      await tester.tap(find.text('Black'));
      await tester.pumpAndSettle(); // wait for the dialog to close

      // Change variant
      await tester.tap(find.text('Standard'));
      await tester.pumpAndSettle(); // wait for the dialog to open
      await tester.tap(find.text('Chess960'));
      await tester.pumpAndSettle(); // wait for the dialog to close

      await tester.tap(find.text('Create chapter'));
      await tester.pumpAndSettle();

      verify(
        () => callback.call(const StudyId('test-id'), [const StudyChapterId('new-chapter')].lock),
      );
    });

    testWidgets('Create empty chapter of a new study', (tester) async {
      final callback = OnChaptersCreatedCallback();
      final app = await makeTestProviderScopeApp(
        tester,
        home: TestBottomSheetOpener(
          builder: (_) => CreateStudyChapterBottomSheet(
            params: CreateFirstChapterOfNewStudy(
              const CreateStudyPayload(
                name: 'study name',
                chat: StudyFeatureAccess.member,
                cloneable: StudyFeatureAccess.everyone,
                computer: StudyFeatureAccess.everyone,
                explorer: StudyFeatureAccess.everyone,
                shareable: StudyFeatureAccess.everyone,
                visibility: StudyVisibility.unlisted,
                sticky: true,
              ),
            ),
            chapterNumber: 1,
            onChaptersCreated: callback.call,
          ),
        ),
        overrides: {
          httpClientFactoryProvider: httpClientFactoryProvider.overrideWith(
            (ref) => FakeHttpClientFactory(
              () => MockClient((request) {
                if (request.url.path == '/api/study' && request.method == 'POST') {
                  expect(request.bodyFields, containsPair('name', 'study name'));
                  expect(request.bodyFields, containsPair('chat', 'member'));
                  expect(request.bodyFields, containsPair('cloneable', 'everyone'));
                  expect(request.bodyFields, containsPair('computer', 'everyone'));
                  expect(request.bodyFields, containsPair('explorer', 'everyone'));
                  expect(request.bodyFields, containsPair('shareable', 'everyone'));
                  expect(request.bodyFields, containsPair('visibility', 'unlisted'));
                  expect(request.bodyFields, containsPair('sticky', 'true'));

                  return mockResponse(jsonEncode({'id': 'test-id'}), 200);
                }

                if (request.url.path == '/api/study/test-id/import-pgn' &&
                    request.method == 'POST') {
                  expect(request.bodyFields, containsPair('name', 'Chapter 1'));
                  expect(request.bodyFields, containsPair('orientation', 'white'));
                  expect(request.bodyFields, containsPair('variant', 'standard'));
                  expect(request.bodyFields, containsPair('initial', 'true'));

                  final pgn = PgnGame.parsePgn(request.bodyFields['pgn']!);
                  expect(pgn.moves.children.isEmpty, isTrue);

                  return mockResponse(
                    jsonEncode({
                      'chapters': [
                        {'id': 'new-chapter'},
                      ],
                    }),
                    200,
                  );
                }

                return mockResponse('', 404);
              }),
            ),
          ),
        },
        authUser: fakeAuthUser,
      );

      await tester.pumpWidget(app);

      await TestBottomSheetOpener.openBottomSheet(tester);

      expect(find.byType(CreateStudyChapterBottomSheet), findsOneWidget);

      await tester.tap(find.text('Create chapter'));
      await tester.pumpAndSettle();

      verify(
        () => callback.call(const StudyId('test-id'), [const StudyChapterId('new-chapter')].lock),
      );
    });

    testWidgets('Create chapter from FEN', (tester) async {
      final callback = OnChaptersCreatedCallback();

      const fen = 'r1bqkbnr/pppp1ppp/2n5/4p3/4P3/5N2/PPPP1PPP/RNBQKB1R w KQkq - 2 3';

      final app = await makeTestProviderScopeApp(
        tester,
        home: TestBottomSheetOpener(
          builder: (_) => CreateStudyChapterBottomSheet(
            params: CreateChapterOfExistingStudy(const StudyId('test-id')),
            chapterNumber: 1,
            onChaptersCreated: callback.call,
          ),
        ),
        overrides: {
          httpClientFactoryProvider: httpClientFactoryProvider.overrideWith(
            (ref) => FakeHttpClientFactory(
              () => MockClient((request) {
                if (request.url.path == '/api/study/test-id/import-pgn' &&
                    request.method == 'POST') {
                  expect(request.bodyFields, containsPair('name', 'Chapter 1'));
                  expect(request.bodyFields, containsPair('orientation', 'black'));
                  expect(request.bodyFields, containsPair('variant', 'chess960'));
                  expect(request.bodyFields, containsPair('initial', 'false'));

                  final pgn = PgnGame.parsePgn(request.bodyFields['pgn']!);
                  expect(
                    pgn,
                    isA<PgnGame>().having((p) => p.moves.children.isEmpty, 'empty moves', isTrue),
                  );

                  return mockResponse(
                    jsonEncode({
                      'chapters': [
                        {'id': 'new-chapter'},
                      ],
                    }),
                    200,
                  );
                }
                return mockResponse('', 404);
              }),
            ),
          ),
        },
        authUser: fakeAuthUser,
      );

      await tester.pumpWidget(app);

      await TestBottomSheetOpener.openBottomSheet(tester);

      expect(find.byType(CreateStudyChapterBottomSheet), findsOneWidget);

      await tester.tap(find.text('FEN'));
      await tester.pumpAndSettle(); // wait for content to switch to FEN input

      mockClipboard(fen);
      await tester.tap(find.byIcon(Icons.paste));
      await tester.pump();
      expect(find.textContaining('Invalid FEN'), findsNothing);

      // Change orientation
      await tester.tap(find.text('White'));
      await tester.pumpAndSettle(); // wait for the dialog to open
      await tester.tap(find.text('Black'));
      await tester.pumpAndSettle(); // wait for the dialog to close

      // Change variant
      await tester.tap(find.text('Standard'));
      await tester.pumpAndSettle(); // wait for the dialog to open
      await tester.tap(find.text('Chess960'));
      await tester.pumpAndSettle(); // wait for the dialog to close

      await tester.tap(find.text('Create chapter'));
      await tester.pumpAndSettle();

      verify(
        () => callback.call(const StudyId('test-id'), [const StudyChapterId('new-chapter')].lock),
      );
    });

    testWidgets('Create chapter from PGN', (tester) async {
      final callback = OnChaptersCreatedCallback();

      const pgn = '1. e4 e5';

      final app = await makeTestProviderScopeApp(
        tester,
        home: TestBottomSheetOpener(
          builder: (_) => CreateStudyChapterBottomSheet(
            params: CreateChapterOfExistingStudy(const StudyId('test-id')),
            chapterNumber: 1,
            onChaptersCreated: callback.call,
          ),
        ),
        overrides: {
          httpClientFactoryProvider: httpClientFactoryProvider.overrideWith(
            (ref) => FakeHttpClientFactory(
              () => MockClient((request) {
                if (request.url.path == '/api/study/test-id/import-pgn' &&
                    request.method == 'POST') {
                  expect(request.bodyFields, containsPair('name', 'Chapter 1'));
                  expect(request.bodyFields, containsPair('orientation', 'black'));
                  expect(request.bodyFields, containsPair('initial', 'false'));

                  // Should not send variant here, server will infer it from the PGN.
                  expect(request.bodyFields, isNot(containsPair('variant', anything)));

                  expect(request.bodyFields['pgn'], equals(pgn));

                  return mockResponse(
                    jsonEncode({
                      'chapters': [
                        {'id': 'new-chapter'},
                      ],
                    }),
                    200,
                  );
                }
                return mockResponse('', 404);
              }),
            ),
          ),
        },
        authUser: fakeAuthUser,
      );

      await tester.pumpWidget(app);

      await TestBottomSheetOpener.openBottomSheet(tester);

      expect(find.byType(CreateStudyChapterBottomSheet), findsOneWidget);

      await tester.tap(find.text('PGN'));
      await tester.pumpAndSettle(); // wait for content to switch to PGN input

      mockClipboard(pgn);
      await tester.tap(find.byIcon(Icons.paste));
      await tester.pump();

      // Change orientation
      await tester.tap(find.text('White'));
      await tester.pumpAndSettle(); // wait for the dialog to open
      await tester.tap(find.text('Black'));
      await tester.pumpAndSettle(); // wait for the dialog to close

      // Server infers variant from PGN, so there should be no manual selector here.
      expect(find.text('Standard'), findsNothing);

      await tester.tap(find.text('Create chapter'));
      await tester.pumpAndSettle();

      verify(
        () => callback.call(const StudyId('test-id'), [const StudyChapterId('new-chapter')].lock),
      );
    });

    testWidgets('Invalid FEN', (tester) async {
      final callback = OnChaptersCreatedCallback();

      final app = await makeTestProviderScopeApp(
        tester,
        home: TestBottomSheetOpener(
          builder: (_) => CreateStudyChapterBottomSheet(
            params: CreateChapterOfExistingStudy(const StudyId('test-id')),
            chapterNumber: 1,
            onChaptersCreated: callback.call,
          ),
        ),
        authUser: fakeAuthUser,
      );

      await tester.pumpWidget(app);

      await TestBottomSheetOpener.openBottomSheet(tester);

      expect(find.byType(CreateStudyChapterBottomSheet), findsOneWidget);

      await tester.tap(find.text('FEN'));
      await tester.pumpAndSettle(); // wait for content to switch to FEN input

      mockClipboard('not a valid FEN');
      await tester.tap(find.byIcon(Icons.paste));
      await tester.pump();
      expect(find.textContaining('Invalid FEN'), findsOneWidget);
    });

    testWidgets('FEN is re-validated when the variant changes', (tester) async {
      final callback = OnChaptersCreatedCallback();

      final app = await makeTestProviderScopeApp(
        tester,
        home: TestBottomSheetOpener(
          builder: (_) => CreateStudyChapterBottomSheet(
            params: CreateChapterOfExistingStudy(const StudyId('test-id')),
            chapterNumber: 1,
            onChaptersCreated: callback.call,
          ),
        ),
        authUser: fakeAuthUser,
      );

      await tester.pumpWidget(app);

      await TestBottomSheetOpener.openBottomSheet(tester);

      await tester.tap(find.text('FEN'));
      await tester.pumpAndSettle(); // wait for content to switch to FEN input

      // a standard position, valid under the default Standard variant
      mockClipboard('r1bqkbnr/pppp1ppp/2n5/4p3/4P3/5N2/PPPP1PPP/RNBQKB1R w KQkq - 2 3');
      await tester.tap(find.byIcon(Icons.paste));
      await tester.pump();
      expect(find.textContaining('Invalid FEN'), findsNothing);

      // Horde rejects it: it expects a pawn horde in place of White's pieces, so a setup with two
      // kings fails `Horde.fromSetup`
      await tester.tap(find.text('Standard'));
      await tester.pumpAndSettle(); // wait for the dialog to open
      await tester.tap(find.text('Horde'));
      await tester.pumpAndSettle(); // wait for the dialog to close

      expect(find.textContaining('Invalid FEN'), findsOneWidget);
    });

    testWidgets('Sheet content is padded by the keyboard height', (tester) async {
      final callback = OnChaptersCreatedCallback();

      const keyboardHeight = 300.0;

      // The sheet is rendered directly, rather than through `showModalBottomSheet`, so that the
      // simulated keyboard inset reaches it: `TestSurface` wraps the whole app in a `MediaQuery`
      // holding a fresh `MediaQueryData`, which zeroes out `tester.view.viewInsets`.
      final app = await makeTestProviderScopeApp(
        tester,
        home: Builder(
          builder: (context) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(viewInsets: const EdgeInsets.only(bottom: keyboardHeight)),
            child: CreateStudyChapterBottomSheet(
              params: CreateChapterOfExistingStudy(const StudyId('test-id')),
              chapterNumber: 1,
              onChaptersCreated: callback.call,
            ),
          ),
        ),
        authUser: fakeAuthUser,
      );

      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      // The sheet grows upwards from the bottom of the screen, so padding its content by the
      // keyboard height is what lifts the submit button clear of the keyboard.
      final scrollView = tester.widget<SingleChildScrollView>(
        find.descendant(
          of: find.byType(CreateStudyChapterBottomSheet),
          matching: find.byType(SingleChildScrollView),
        ),
      );
      expect(
        scrollView.padding!.resolve(TextDirection.ltr).bottom,
        greaterThanOrEqualTo(keyboardHeight),
      );
    });

    testWidgets('Invalid PGN', (tester) async {
      final callback = OnChaptersCreatedCallback();

      final app = await makeTestProviderScopeApp(
        tester,
        home: TestBottomSheetOpener(
          builder: (_) => CreateStudyChapterBottomSheet(
            params: CreateChapterOfExistingStudy(const StudyId('test-id')),
            chapterNumber: 1,
            onChaptersCreated: callback.call,
          ),
        ),
        authUser: fakeAuthUser,
      );

      await tester.pumpWidget(app);

      await TestBottomSheetOpener.openBottomSheet(tester);

      await tester.tap(find.text('PGN'));
      await tester.pumpAndSettle(); // wait for content to switch to PGN input

      // `PgnGame.parseMultiGameLazy` parses arbitrary text into a single game with no moves, so
      // this only shows an error if the moves are actually looked at.
      mockClipboard('this is not a pgn at all');
      await tester.tap(find.byIcon(Icons.paste));
      await tester.pump();
      expect(find.textContaining('Invalid PGN'), findsOneWidget);

      // a bare FEN header and no moves is a legitimate chapter: a starting position
      mockClipboard('[FEN "8/8/8/8/8/8/8/K6k w - - 0 1"]\n\n*');
      await tester.tap(find.byIcon(Icons.paste));
      await tester.pump();
      expect(find.textContaining('Invalid PGN'), findsNothing);
    });

    testWidgets('Chapter creation failure keeps the sheet open and shows an error', (tester) async {
      final callback = OnChaptersCreatedCallback();

      var requestCount = 0;

      final app = await makeTestProviderScopeApp(
        tester,
        home: TestBottomSheetOpener(
          builder: (_) => CreateStudyChapterBottomSheet(
            params: CreateChapterOfExistingStudy(const StudyId('test-id')),
            chapterNumber: 1,
            onChaptersCreated: callback.call,
          ),
        ),
        overrides: {
          httpClientFactoryProvider: httpClientFactoryProvider.overrideWith(
            (ref) => FakeHttpClientFactory(
              () => MockClient((request) {
                if (request.url.path == '/api/study/test-id/import-pgn' &&
                    request.method == 'POST') {
                  requestCount++;
                  // delayed so that the in-flight state lasts long enough to be rendered
                  return Future.delayed(
                    const Duration(milliseconds: 50),
                    () => mockResponse('', 400),
                  );
                }
                return mockResponse('', 404);
              }),
            ),
          ),
        },
        authUser: fakeAuthUser,
      );

      await tester.pumpWidget(app);

      await TestBottomSheetOpener.openBottomSheet(tester);

      await tester.tap(find.text('Create chapter'));
      await tester.pump(); // start the request, button goes into its submitting state

      // a second tap while the request is in flight must not send another one: the button is
      // disabled and shows a spinner in place of its label
      expect(find.byType(ButtonLoadingIndicator), findsOneWidget);
      await tester.tap(find.byType(ButtonLoadingIndicator));

      await tester.pump(const Duration(milliseconds: 100)); // let the request fail
      await tester.pumpAndSettle();

      expect(requestCount, 1);

      // the sheet stays open so the user can retry, and the failure is reported
      expect(find.byType(CreateStudyChapterBottomSheet), findsOneWidget);
      expect(find.textContaining('Could not create chapter'), findsOneWidget);
      verifyZeroInteractions(callback);
    });
  });
}
