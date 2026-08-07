import 'dart:convert';

import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/view/study/create_study_chapter_bottom_sheet.dart';
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
  });
}
