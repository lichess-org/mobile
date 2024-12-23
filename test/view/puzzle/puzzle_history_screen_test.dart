import 'dart:math' as math;
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:intl/intl.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/view/puzzle/puzzle_history_screen.dart';
import 'package:lichess_mobile/src/view/puzzle/puzzle_screen.dart';
import 'package:lichess_mobile/src/widgets/board_thumbnail.dart';

import '../../model/auth/fake_session_storage.dart';
import '../../model/puzzle/mock_server_responses.dart';
import '../../test_helpers.dart';
import '../../test_provider_scope.dart';

void main() {
  final Map<String?, int> mockActivityRequestsCount = {};

  tearDown(() {
    mockActivityRequestsCount.clear();
  });

  MockClient makeClient(int totalNumberOfPuzzles) => MockClient((request) {
    if (request.url.path == '/api/puzzle/activity') {
      final query = request.url.queryParameters;
      final max = int.parse(query['max']!);
      final beforeDateParam = query['before'];
      final beforeDate =
          beforeDateParam != null
              ? DateTime.fromMillisecondsSinceEpoch(int.parse(beforeDateParam))
              : null;
      final totalAlreadyRequested = mockActivityRequestsCount.values.fold(0, (p, e) => p + e);

      if (totalAlreadyRequested >= totalNumberOfPuzzles) {
        return mockResponse('', 200);
      }

      final key = beforeDate != null ? DateFormat.yMd().format(beforeDate) : null;

      final nbPuzzles = math.min(max, totalNumberOfPuzzles);
      mockActivityRequestsCount[key] = (mockActivityRequestsCount[key] ?? 0) + nbPuzzles;
      return mockResponse(generateHistory(nbPuzzles, beforeDate), 200);
    } else if (request.url.path == '/api/puzzle/batch/mix') {
      return mockResponse(mockMixBatchResponse, 200);
    } else if (request.url.path.startsWith('/api/puzzle')) {
      return mockResponse('''
{"game":{"id":"MNMYnEjm","perf":{"key":"classical","name":"Classical"},"rated":true,"players":[{"name":"Igor76","id":"igor76","color":"white","rating":2211},{"name":"dmitriy_duyun","id":"dmitriy_duyun","color":"black","rating":2180}],"pgn":"e4 c6 d4 d5 Nc3 g6 Nf3 Bg7 h3 dxe4 Nxe4 Nf6 Bd3 Nxe4 Bxe4 Nd7 O-O Nf6 Bd3 O-O Re1 Bf5 Bxf5 gxf5 c3 e6 Bg5 Qb6 Qc2 Rac8 Ne5 Qc7 Rad1 Nd7 Bf4 Nxe5 Bxe5 Bxe5 Rxe5 Rcd8 Qd2 Kh8 Rde1 Rg8 Qf4","clock":"20+15"},"puzzle":{"id":"0XqV2","rating":1929,"plays":93270,"solution":["f7f6","e5f5","c7g7","g2g3","e6f5"],"themes":["clearance","endgame","advantage","intermezzo","long"],"initialPly":44}}
''', 200);
    }
    return mockResponse('', 404);
  });

  testWidgets('Displays an initial list of puzzles', (WidgetTester tester) async {
    final app = await makeTestProviderScopeApp(
      tester,
      home: const PuzzleHistoryScreen(),
      userSession: fakeSession,
      overrides: [
        lichessClientProvider.overrideWith((ref) {
          return LichessClient(makeClient(4), ref);
        }),
      ],
    );

    await tester.pumpWidget(app);

    expect(find.byType(PuzzleHistoryScreen), findsOneWidget);

    // wait for puzzles to load
    await tester.pump(const Duration(milliseconds: 20));

    expect(mockActivityRequestsCount, equals({null: 4}));

    expect(find.byType(BoardThumbnail), findsNWidgets(4));

    expect(find.text(DateFormat.yMMMd().format(firstPageDate)), findsOneWidget);
  });

  testWidgets('Scrolling down loads next page', (WidgetTester tester) async {
    final app = await makeTestProviderScopeApp(
      tester,
      home: const PuzzleHistoryScreen(),
      userSession: fakeSession,
      overrides: [
        lichessClientProvider.overrideWith((ref) {
          return LichessClient(makeClient(80), ref);
        }),
      ],
    );

    await tester.pumpWidget(app);

    expect(find.byType(PuzzleHistoryScreen), findsOneWidget);

    // wait for puzzles to load
    await tester.pump(const Duration(milliseconds: 20));

    // first page has 20 puzzles
    expect(mockActivityRequestsCount, equals({null: 20}));

    // not everything will be displayed but we should see at least first 2 rows
    expect(find.byType(BoardThumbnail), findsAtLeastNWidgets(4));

    await tester.scrollUntilVisible(
      find.byWidgetPredicate(
        (widget) => widget is PuzzleHistoryBoard && widget.puzzle.id.value == 'Bnull20',
        description: 'last item of 1st page',
      ),
      400,
    );

    // next pages have 50 puzzles
    expect(mockActivityRequestsCount, equals({null: 20, '1/31/2024': 50}));

    // by the time we've scrolled to the end the next puzzles are already here
    await tester.scrollUntilVisible(
      find.byWidgetPredicate(
        (widget) => widget is PuzzleHistoryBoard && widget.puzzle.id.value == 'B3150',
        description: 'last item of 2nd page',
      ),
      1000,
    );

    // one more page
    expect(mockActivityRequestsCount, equals({null: 20, '1/31/2024': 50, '1/30/2024': 50}));

    await tester.scrollUntilVisible(
      find.byWidgetPredicate(
        (widget) => widget is PuzzleHistoryBoard && widget.puzzle.id.value == 'B3010',
        description: 'last item of 3rd page',
      ),
      400,
    );

    // no more items
    expect(mockActivityRequestsCount.length, 3);

    // wait for the scroll to finish
    await tester.pumpAndSettle();

    await tester.tap(
      find.byWidgetPredicate(
        (widget) => widget is PuzzleHistoryBoard && widget.puzzle.id.value == 'B3010',
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byType(PuzzleScreen), findsOneWidget);

    // go back, should be on the same page and history still loaded
    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(find.byType(PuzzleHistoryScreen), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) => widget is PuzzleHistoryBoard && widget.puzzle.id.value == 'B3010',
      ),
      findsOneWidget,
    );
  });
}

// a date to use for the first page; all the puzzle with have the same date per
// page for simplification
final firstPageDate = DateTime.parse('2024-01-31 10:00:00');

String generateHistory(int count, DateTime? maybeDate) {
  final buffer = StringBuffer();
  for (int i = 0; i < count; i++) {
    final date = maybeDate?.subtract(const Duration(days: 1)) ?? firstPageDate;
    final id = 'B${maybeDate?.day}${i + 1}';
    buffer.writeln('''
{ "date": ${date.millisecondsSinceEpoch}, "puzzle": { "fen": "6k1/3rqpp1/5b1p/p1p1pP1Q/1pB4P/1P1R1PP1/P7/6K1 w - - 1 1", "id": "$id", "lastMove": "c7d7", "plays": 14703, "rating": 2018, "solution": [ "h5f7", "e7f7", "d3d7", "f7c4", "b3c4" ], "themes": [ "endgame", "crushing", "long", "sacrifice", "pin" ] }, "win": true }
''');
  }
  return buffer.toString();
}
