import 'package:dartchess/dartchess.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/study/study_controller.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/view/study/save_to_study_bottom_sheet.dart';
import 'package:material_ui/material_ui.dart';

import '../../model/auth/fake_auth_storage.dart';
import '../../network/fake_http_client_factory.dart';
import '../../test_helpers.dart';
import '../../test_provider_scope.dart';

/// Opens a [SaveToStudyBottomSheet] and reports what it pops with.
class SheetOpener extends StatelessWidget {
  const SheetOpener({required this.onClosed});

  final void Function(StudyOptions? result) onClosed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) => Center(
          child: ElevatedButton(
            onPressed: () async {
              onClosed(
                await showModalBottomSheet<StudyOptions>(
                  context: context,
                  isScrollControlled: true,
                  useRootNavigator: true,
                  builder: (_) =>
                      const SaveToStudyBottomSheet(pgn: '1. e4 *', orientation: Side.black),
                ),
              );
            },
            child: const Text('Open'),
          ),
        ),
      ),
    );
  }
}

const kMyStudiesResponse = '''
{
  "paginator": {
    "currentPage": 1,
    "maxPerPage": 16,
    "currentPageResults": [
      {
        "id": "abcd1234",
        "name": "My analysis",
        "liked": false,
        "likes": 1,
        "updatedAt": 1723817543350,
        "owner": { "name": "testUser", "id": "testuser" },
        "chapters": ["Chapter 1", "Chapter 2"],
        "topics": [],
        "members": [{ "user": { "name": "testUser", "id": "testuser" }, "role": "w" }]
      }
    ],
    "nextPage": null
  }
}
''';

const kNoStudiesResponse = '''
{
  "paginator": {
    "currentPage": 1,
    "maxPerPage": 16,
    "currentPageResults": [],
    "nextPage": null
  }
}
''';

void main() {
  Future<void> openSheet(
    WidgetTester tester, {
    required MockClient mockClient,
    required void Function(StudyOptions? result) onClosed,
  }) async {
    final app = await makeTestProviderScopeApp(
      tester,
      home: SheetOpener(onClosed: onClosed),
      overrides: {
        httpClientFactoryProvider: httpClientFactoryProvider.overrideWith(
          (ref) => FakeHttpClientFactory(() => mockClient),
        ),
      },
      authUser: fakeAuthUser,
    );
    await tester.pumpWidget(app);
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
  }

  group('SaveToStudyBottomSheet', () {
    testWidgets('lists the user studies and saves the chapter to the picked one', (tester) async {
      StudyOptions? result;
      final mockClient = MockClient((request) {
        if (request.url.path == '/study/mine/updated') {
          return mockResponse(kMyStudiesResponse, 200);
        }
        if (request.url.path == '/study/member/updated') {
          return mockResponse(kNoStudiesResponse, 200);
        }
        if (request.method == 'POST' && request.url.path == '/api/study/abcd1234/import-pgn') {
          expect(request.bodyFields, containsPair('pgn', '1. e4 *'));
          expect(request.bodyFields, containsPair('orientation', 'black'));
          expect(request.bodyFields, containsPair('initial', 'false'));
          // the server derives the chapter name from the PGN tags
          expect(request.bodyFields, isNot(contains('name')));
          return mockResponse('{"chapters": [{"id": "chap1234"}]}', 200);
        }
        return mockResponse('', 404);
      });

      await openSheet(tester, mockClient: mockClient, onClosed: (r) => result = r);

      expect(find.text('My studies'), findsOneWidget);
      expect(find.text('2 Chapters'), findsOneWidget);
      // empty sections are not displayed
      expect(find.text('Studies I contribute to'), findsNothing);

      await tester.tap(find.text('My analysis'));
      await tester.pumpAndSettle();

      expect(find.byType(SaveToStudyBottomSheet), findsNothing);
      expect(result, (
        id: const StudyId('abcd1234'),
        initialChapter: const StudyChapterId('chap1234'),
      ));
    });

    testWidgets('creates a new study with the chapter as its first one', (tester) async {
      StudyOptions? result;
      final mockClient = MockClient((request) {
        if (request.url.path == '/study/mine/updated' ||
            request.url.path == '/study/member/updated') {
          return mockResponse(kNoStudiesResponse, 200);
        }
        if (request.method == 'POST' && request.url.path == '/api/study') {
          expect(request.bodyFields, containsPair('name', "testUser's Study"));
          expect(request.bodyFields, containsPair('visibility', 'unlisted'));
          return mockResponse('{"id": "newstudy"}', 200);
        }
        if (request.method == 'POST' && request.url.path == '/api/study/newstudy/import-pgn') {
          expect(request.bodyFields, containsPair('initial', 'true'));
          return mockResponse('{"chapters": [{"id": "chap1234"}]}', 200);
        }
        return mockResponse('', 404);
      });

      await openSheet(tester, mockClient: mockClient, onClosed: (r) => result = r);

      await tester.tap(find.text('Create study'));
      await tester.pumpAndSettle();

      expect(find.byType(SaveToStudyBottomSheet), findsNothing);
      expect(result, (
        id: const StudyId('newstudy'),
        initialChapter: const StudyChapterId('chap1234'),
      ));
    });

    testWidgets('stays open and reports the error when the chapter cannot be created', (
      tester,
    ) async {
      StudyOptions? result;
      final mockClient = MockClient((request) {
        if (request.url.path == '/study/mine/updated') {
          return mockResponse(kMyStudiesResponse, 200);
        }
        if (request.url.path == '/study/member/updated') {
          return mockResponse(kNoStudiesResponse, 200);
        }
        return mockResponse('', 500);
      });

      await openSheet(tester, mockClient: mockClient, onClosed: (r) => result = r);

      await tester.tap(find.text('My analysis'));
      await tester.pumpAndSettle();

      expect(find.byType(SaveToStudyBottomSheet), findsOneWidget);
      expect(find.textContaining('Could not create chapter'), findsOneWidget);
      expect(result, isNull);
    });

    testWidgets('loads more studies on demand', (tester) async {
      final mockClient = MockClient((request) {
        if (request.url.path == '/study/mine/updated') {
          return switch (request.url.queryParameters['page']) {
            '1' => mockResponse(
              kMyStudiesResponse.replaceFirst('"nextPage": null', '"nextPage": 2'),
              200,
            ),
            '2' => mockResponse(
              kMyStudiesResponse
                  .replaceFirst('abcd1234', 'efgh5678')
                  .replaceFirst('My analysis', 'Older analysis'),
              200,
            ),
            _ => mockResponse('', 404),
          };
        }
        if (request.url.path == '/study/member/updated') {
          return mockResponse(kNoStudiesResponse, 200);
        }
        return mockResponse('', 404);
      });

      await openSheet(tester, mockClient: mockClient, onClosed: (_) {});

      expect(find.text('My analysis'), findsOneWidget);
      expect(find.text('Older analysis'), findsNothing);

      await tester.tap(find.text('More'));
      await tester.pumpAndSettle();

      expect(find.text('My analysis'), findsOneWidget);
      expect(find.text('Older analysis'), findsOneWidget);
      // the last page was loaded
      expect(find.text('More'), findsNothing);
    });

    testWidgets('searches studies and only offers the ones the user can write to', (tester) async {
      final mockClient = MockClient((request) {
        if (request.url.path == '/study/mine/updated') {
          return mockResponse(kMyStudiesResponse, 200);
        }
        if (request.url.path == '/study/member/updated') {
          return mockResponse(kNoStudiesResponse, 200);
        }
        if (request.url.path == '/study/search' && request.url.queryParameters['q'] == 'Sicilian') {
          return mockResponse(kSearchResponse, 200);
        }
        return mockResponse('', 404);
      });

      await openSheet(tester, mockClient: mockClient, onClosed: (_) {});

      await tester.enterText(find.byType(TextField), 'Sicilian');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      expect(find.text('My studies'), findsNothing);
      expect(find.text('My Sicilian'), findsOneWidget);
      // the user is not a member of this one
      expect(find.text('Sicilian masterclass'), findsNothing);
      // the user can only read this one
      expect(find.text('Sicilian club'), findsNothing);
    });
  });
}

const kSearchResponse = '''
{
  "paginator": {
    "currentPage": 1,
    "maxPerPage": 16,
    "currentPageResults": [
      {
        "id": "abcd1234",
        "name": "My Sicilian",
        "liked": false,
        "likes": 1,
        "updatedAt": 1723817543350,
        "owner": { "name": "testUser", "id": "testuser" },
        "chapters": ["Chapter 1"],
        "topics": [],
        "members": [{ "user": { "name": "testUser", "id": "testuser" }, "role": "w" }]
      },
      {
        "id": "efgh5678",
        "name": "Sicilian masterclass",
        "liked": false,
        "likes": 1,
        "updatedAt": 1723817543350,
        "owner": { "name": "Someone", "id": "someone" },
        "chapters": ["Chapter 1"],
        "topics": [],
        "members": [{ "user": { "name": "Someone", "id": "someone" }, "role": "w" }]
      },
      {
        "id": "ijkl9012",
        "name": "Sicilian club",
        "liked": false,
        "likes": 1,
        "updatedAt": 1723817543350,
        "owner": { "name": "Someone", "id": "someone" },
        "chapters": ["Chapter 1"],
        "topics": [],
        "members": [
          { "user": { "name": "Someone", "id": "someone" }, "role": "w" },
          { "user": { "name": "testUser", "id": "testuser" }, "role": "r" }
        ]
      }
    ],
    "nextPage": null
  }
}
''';
