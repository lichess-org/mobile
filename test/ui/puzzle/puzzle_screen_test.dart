import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:chessground/chessground.dart' as cg;
import 'package:lichess_mobile/src/model/puzzle/puzzle_storage.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/testing.dart';

import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/http_client.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_batch_storage.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_service.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';
import 'package:lichess_mobile/src/view/puzzle/puzzle_screen.dart';
import '../../test_app.dart';
import '../../test_utils.dart';

class MockPuzzleBatchStorage extends Mock implements PuzzleBatchStorage {}

class MockPuzzleStorage extends Mock implements PuzzleStorage {}

void main() {
  setUpAll(() {
    registerFallbackValue(
      PuzzleBatch(
        solved: IList(const []),
        unsolved: IList([puzzle]),
      ),
    );
    registerFallbackValue(puzzle);
  });

  final mockBatchStorage = MockPuzzleBatchStorage();
  final mockHistoryStorage = MockPuzzleStorage();

  group('PuzzleScreen', () {
    testWidgets(
      'meets accessibility guidelines',
      (WidgetTester tester) async {
        final SemanticsHandle handle = tester.ensureSemantics();

        final app = await buildTestApp(
          tester,
          home: PuzzleScreen(
            theme: PuzzleTheme.mix,
            initialPuzzleContext: PuzzleContext(
              puzzle: puzzle,
              theme: PuzzleTheme.mix,
              userId: null,
            ),
          ),
        );

        await tester.pumpWidget(app);

        await meetsTapTargetGuideline(tester);

        await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
        handle.dispose();
      },
      variant: kPlatformVariant,
    );

    testWidgets(
      'Loads puzzle directly by passing PuzzleContext',
      (tester) async {
        final app = await buildTestApp(
          tester,
          home: PuzzleScreen(
            theme: PuzzleTheme.mix,
            initialPuzzleContext: PuzzleContext(
              puzzle: puzzle,
              theme: PuzzleTheme.mix,
              userId: null,
            ),
          ),
        );

        await tester.pumpWidget(app);

        expect(find.byType(cg.Board), findsOneWidget);
        expect(find.text('Your turn'), findsOneWidget);
      },
      variant: kPlatformVariant,
    );

    testWidgets('Loads next puzzle when no initialPuzzleContext is passed',
        (tester) async {
      final app = await buildTestApp(
        tester,
        home: const PuzzleScreen(
          theme: PuzzleTheme.mix,
        ),
        overrides: [
          puzzleBatchStorageProvider.overrideWith((ref) {
            return mockBatchStorage;
          }),
          puzzleStorageProvider.overrideWith((ref) => mockHistoryStorage),
        ],
      );

      when(() => mockBatchStorage.fetch(userId: null, angle: PuzzleTheme.mix))
          .thenAnswer((_) async => batch);

      when(() => mockHistoryStorage.save(puzzle: any(named: 'puzzle')))
          .thenAnswer((_) async {});

      await tester.pumpWidget(app);

      expect(find.byType(cg.Board), findsNothing);
      expect(find.text('Your turn'), findsNothing);

      // wait for the puzzle to load
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.byType(cg.Board), findsOneWidget);
      expect(find.text('Your turn'), findsOneWidget);
    });

    testWidgets(
      'solves a puzzle and loads the next one',
      (tester) async {
        final mockClient = MockClient((request) {
          if (request.url.path == '/api/puzzle/batch/mix') {
            return mockResponse(batchOf1, 200);
          }
          return mockResponse('', 404);
        });

        final app = await buildTestApp(
          tester,
          home: PuzzleScreen(
            theme: PuzzleTheme.mix,
            initialPuzzleContext: PuzzleContext(
              puzzle: puzzle2,
              theme: PuzzleTheme.mix,
              userId: null,
            ),
          ),
          overrides: [
            httpClientProvider.overrideWith((ref) {
              return mockClient;
            }),
            puzzleBatchStorageProvider.overrideWith((ref) {
              return mockBatchStorage;
            }),
            puzzleStorageProvider.overrideWith((ref) => mockHistoryStorage),
          ],
        );

        Future<void> saveDBReq() => mockBatchStorage.save(
              userId: null,
              angle: PuzzleTheme.mix,
              data: any(named: 'data'),
            );
        when(saveDBReq).thenAnswer((_) async {});
        when(() => mockBatchStorage.fetch(userId: null, angle: PuzzleTheme.mix))
            .thenAnswer((_) async => batch);

        when(() => mockHistoryStorage.save(puzzle: any(named: 'puzzle')))
            .thenAnswer((_) async {});

        await tester.pumpWidget(app);

        expect(find.byType(cg.Board), findsOneWidget);
        expect(find.text('Your turn'), findsOneWidget);

        // before the first move is played, puzzle is not interactable
        expect(find.byKey(const Key('g4-blackRook')), findsOneWidget);
        await tester.tap(find.byKey(const Key('g4-blackRook')));
        await tester.pump();
        expect(find.byKey(const Key('g4-selected')), findsNothing);

        const orientation = cg.Side.black;

        // await for first move to be played
        await tester.pump(const Duration(milliseconds: 1500));

        // in play mode we don't see the continue button
        expect(find.byIcon(CupertinoIcons.play_arrow_solid), findsNothing);
        // in play mode we see the solution button
        expect(find.byIcon(Icons.help), findsOneWidget);

        expect(find.byKey(const Key('g4-blackRook')), findsOneWidget);
        expect(find.byKey(const Key('h8-whiteQueen')), findsOneWidget);

        final boardRect = tester.getRect(find.byType(cg.Board));

        await playMove(tester, boardRect, 'g4', 'h4', orientation: orientation);

        expect(find.byKey(const Key('h4-blackRook')), findsOneWidget);
        expect(find.text('Best move!'), findsOneWidget);

        // wait for line reply and move animation
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pumpAndSettle();

        expect(find.byKey(const Key('h4-whiteQueen')), findsOneWidget);

        await playMove(tester, boardRect, 'b4', 'h4', orientation: orientation);

        expect(find.byKey(const Key('h4-blackRook')), findsOneWidget);
        expect(find.text('Success!'), findsOneWidget);

        // wait for move animation
        await tester.pumpAndSettle();

        // called once to save solution and once after fetching a new puzzle
        verify(saveDBReq).called(2);

        expect(find.byIcon(CupertinoIcons.play_arrow_solid), findsOneWidget);
        expect(find.byIcon(Icons.help), findsNothing);

        await tester.tap(find.byIcon(CupertinoIcons.play_arrow_solid));

        // await for new puzzle load
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.text('Success!'), findsNothing);
        expect(find.text('Your turn'), findsOneWidget);

        // await for view solution timer
        await tester.pump(const Duration(seconds: 4));
      },
      variant: kPlatformVariant,
    );

    testWidgets(
      'fails a puzzle',
      (tester) async {
        final mockClient = MockClient((request) {
          if (request.url.path == '/api/puzzle/batch/mix') {
            return mockResponse(batchOf1, 200);
          }
          return mockResponse('', 404);
        });

        final app = await buildTestApp(
          tester,
          home: PuzzleScreen(
            theme: PuzzleTheme.mix,
            initialPuzzleContext: PuzzleContext(
              puzzle: puzzle2,
              theme: PuzzleTheme.mix,
              userId: null,
            ),
          ),
          overrides: [
            httpClientProvider.overrideWith((ref) {
              return mockClient;
            }),
            puzzleBatchStorageProvider.overrideWith((ref) {
              return mockBatchStorage;
            }),
            puzzleStorageProvider.overrideWith((ref) => mockHistoryStorage),
          ],
        );

        when(() => mockHistoryStorage.save(puzzle: any(named: 'puzzle')))
            .thenAnswer((_) async {});

        Future<void> saveDBReq() => mockBatchStorage.save(
              userId: null,
              angle: PuzzleTheme.mix,
              data: any(named: 'data'),
            );
        when(saveDBReq).thenAnswer((_) async {});
        when(() => mockBatchStorage.fetch(userId: null, angle: PuzzleTheme.mix))
            .thenAnswer((_) async => batch);

        await tester.pumpWidget(app);

        expect(find.byType(cg.Board), findsOneWidget);
        expect(find.text('Your turn'), findsOneWidget);

        const orientation = cg.Side.black;

        // await for first move to be played
        await tester.pump(const Duration(milliseconds: 1500));

        expect(find.byKey(const Key('g4-blackRook')), findsOneWidget);

        final boardRect = tester.getRect(find.byType(cg.Board));

        await playMove(tester, boardRect, 'g4', 'f4', orientation: orientation);

        expect(
          find.text("That's not the move!"),
          findsOneWidget,
        );

        // wait for move cancel and animation
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pumpAndSettle();

        // can still play the puzzle
        expect(find.byKey(const Key('g4-blackRook')), findsOneWidget);

        await playMove(tester, boardRect, 'g4', 'h4', orientation: orientation);

        expect(find.byKey(const Key('h4-blackRook')), findsOneWidget);
        expect(find.text('Best move!'), findsOneWidget);

        // wait for line reply and move animation
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pumpAndSettle();

        await playMove(tester, boardRect, 'b4', 'h4', orientation: orientation);

        expect(find.byKey(const Key('h4-blackRook')), findsOneWidget);
        expect(
          find.text('Puzzle complete!'),
          findsOneWidget,
        );

        // wait for move animation
        await tester.pumpAndSettle();

        // called once to save solution and once after fetching a new puzzle
        verify(saveDBReq).called(2);
      },
      variant: kPlatformVariant,
    );

    testWidgets(
      'view solution',
      (tester) async {
        final mockClient = MockClient((request) {
          if (request.url.path == '/api/puzzle/batch/mix') {
            return mockResponse(batchOf1, 200);
          }
          return mockResponse('', 404);
        });

        final app = await buildTestApp(
          tester,
          home: PuzzleScreen(
            theme: PuzzleTheme.mix,
            initialPuzzleContext: PuzzleContext(
              puzzle: puzzle2,
              theme: PuzzleTheme.mix,
              userId: null,
            ),
          ),
          overrides: [
            httpClientProvider.overrideWith((ref) {
              return mockClient;
            }),
            puzzleBatchStorageProvider.overrideWith((ref) {
              return mockBatchStorage;
            }),
            puzzleStorageProvider.overrideWith((ref) => mockHistoryStorage),
          ],
        );

        when(() => mockHistoryStorage.save(puzzle: any(named: 'puzzle')))
            .thenAnswer((_) async {});

        Future<void> saveDBReq() => mockBatchStorage.save(
              userId: null,
              angle: PuzzleTheme.mix,
              data: any(named: 'data'),
            );
        when(saveDBReq).thenAnswer((_) async {});
        when(() => mockBatchStorage.fetch(userId: null, angle: PuzzleTheme.mix))
            .thenAnswer((_) async => batch);

        await tester.pumpWidget(app);

        expect(find.byType(cg.Board), findsOneWidget);
        expect(find.text('Your turn'), findsOneWidget);

        // await for first move to be played and view solution button to appear
        await tester.pump(const Duration(seconds: 5));

        expect(find.byKey(const Key('g4-blackRook')), findsOneWidget);

        expect(find.byIcon(Icons.help), findsOneWidget);
        await tester.tap(find.byIcon(Icons.help));

        // wait for solution replay animation to finish
        await tester.pump(const Duration(seconds: 3));
        await tester.pumpAndSettle();

        expect(find.byKey(const Key('h4-blackRook')), findsOneWidget);
        expect(find.byKey(const Key('h8-whiteQueen')), findsNothing);
        expect(
          find.text('Puzzle complete!'),
          findsOneWidget,
        );

        expect(find.byIcon(CupertinoIcons.play_arrow_solid), findsOneWidget);

        // called once to save solution and once after fetching a new puzzle
        verify(saveDBReq).called(2);
      },
      variant: kPlatformVariant,
    );
  });
}

final puzzle = Puzzle(
  puzzle: PuzzleData(
    id: const PuzzleId('6Sz3s'),
    initialPly: 40,
    plays: 68176,
    rating: 1984,
    solution: IList(const [
      'h4h2',
      'h1h2',
      'e5f3',
      'h2h3',
      'b4h4',
    ]),
    themes: ISet(const [
      'middlegame',
      'attraction',
      'long',
      'mateIn3',
      'sacrifice',
      'doubleCheck',
    ]),
  ),
  game: const PuzzleGame(
    rated: true,
    id: GameId('zgBwsXLr'),
    perf: Perf.blitz,
    pgn:
        'e4 c5 Nf3 e6 c4 Nc6 d4 cxd4 Nxd4 Bc5 Nxc6 bxc6 Be2 Ne7 O-O Ng6 Nc3 Rb8 Kh1 Bb7 f4 d5 f5 Ne5 fxe6 fxe6 cxd5 cxd5 exd5 Bxd5 Qa4+ Bc6 Qf4 Bd6 Ne4 Bxe4 Qxe4 Rb4 Qe3 Qh4 Qxa7',
    black: PuzzleGamePlayer(
      side: Side.black,
      name: 'CAMBIADOR (2148)',
      userId: UserId('cambiador'),
    ),
    white: PuzzleGamePlayer(
      side: Side.white,
      name: 'arroyoM10 (2017)',
      userId: UserId('arroyom10'),
    ),
  ),
);

final batch = PuzzleBatch(
  solved: IList(const []),
  unsolved: IList([
    puzzle,
  ]),
);

final puzzle2 = Puzzle(
  puzzle: PuzzleData(
    id: const PuzzleId('2nNdI'),
    rating: 1090,
    plays: 23890,
    initialPly: 88,
    solution: IList(const ['g4h4', 'h8h4', 'b4h4']),
    themes: ISet(const {
      'endgame',
      'short',
      'crushing',
      'fork',
      'queenRookEndgame',
    }),
  ),
  game: const PuzzleGame(
    id: GameId('w32JTzEf'),
    perf: Perf.blitz,
    rated: true,
    white: PuzzleGamePlayer(
      side: Side.white,
      userId: UserId('li'),
      name: 'Li(1678)',
      title: null,
    ),
    black: PuzzleGamePlayer(
      side: Side.black,
      userId: UserId('gabriela'),
      name: 'Gabriela(1686)',
      title: null,
    ),
    pgn:
        'e4 e5 Nf3 Nc6 Bb5 a6 Ba4 b5 Bb3 Nf6 c3 Nxe4 d4 exd4 cxd4 Qe7 O-O Qd8 Bd5 Nf6 Bb3 Bd6 Nc3 O-O Bg5 h6 Bh4 g5 Nxg5 hxg5 Bxg5 Kg7 Ne4 Be7 Bxf6+ Bxf6 Qg4+ Kh8 Qh5+ Kg8 Qg6+ Kh8 Qxf6+ Qxf6 Nxf6 Nxd4 Rfd1 Ne2+ Kh1 d6 Rd5 Kg7 Nh5+ Kh6 Rad1 Be6 R5d2 Bxb3 axb3 Kxh5 Rxe2 Rfe8 Red2 Re5 h3 Rae8 Kh2 Re2 Rd5+ Kg6 f4 Rxb2 R1d3 Ree2 Rg3+ Kf6 h4 Re4 Rg4 Rxb3 h5 Rbb4 h6 Rxf4 h7 Rxg4 h8=Q+ Ke7 Rd3',
  ),
);

const batchOf1 = '''
{"puzzles":[{"game":{"id":"PrlkCqOv","perf":{"key":"rapid","name":"Rapid"},"rated":true,"players":[{"userId":"silverjo","name":"silverjo (1777)","color":"white"},{"userId":"robyarchitetto","name":"Robyarchitetto (1742)","color":"black"}],"pgn":"e4 Nc6 Bc4 e6 a3 g6 Nf3 Bg7 c3 Nge7 d3 O-O Be3 Na5 Ba2 b6 Qd2 Bb7 Bh6 d5 e5 d4 Bxg7 Kxg7 Qf4 Bxf3 Qxf3 dxc3 Nxc3 Nac6 Qf6+ Kg8 Rd1 Nd4 O-O c5 Ne4 Nef5 Rd2 Qxf6 Nxf6+ Kg7 Re1 h5 h3 Rad8 b4 Nh4 Re3 Nhf5 Re1 a5 bxc5 bxc5 Bc4 Ra8 Rb1 Nh4 Rdb2 Nc6 Rb7 Nxe5 Bxe6 Kxf6 Bd5 Nf5 R7b6+ Kg7 Bxa8 Rxa8 R6b3 Nd4 Rb7 Nxd3 Rd1 Ne2+ Kh2 Ndf4 Rdd7 Rf8 Ra7 c4 Rxa5 c3 Rc5 Ne6 Rc4 Ra8 a4 Rb8 a5 Rb2 a6 c2","clock":"5+8"},"puzzle":{"id":"20yWT","rating":1859,"plays":551,"initialPly":93,"solution":["a6a7","b2a2","c4c2","a2a7","d7a7"],"themes":["endgame","long","advantage","advancedPawn"]}}]}
''';
