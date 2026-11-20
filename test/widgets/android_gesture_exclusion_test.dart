import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/game/game_board_params.dart';
import 'package:lichess_mobile/src/widgets/android_gesture_exclusion.dart';
import 'package:lichess_mobile/src/widgets/board.dart';
import 'package:lichess_mobile/src/widgets/game_layout.dart';
import 'package:material_ui/material_ui.dart';

import '../test_helpers.dart';
import '../test_provider_scope.dart';

const _channel = MethodChannel('mobile.lichess.org/gestures_exclusion');

final _interactiveParams = GameBoardParams.interactive(
  variant: Variant.standard,
  position: Chess.initial,
  playerSide: PlayerSide.white,
  onMove: (_, {viaDragAndDrop}) {},
);

void main() {
  /// The rects sent to the platform, in physical pixels, for each call.
  late List<List<Rect>> sentPhysicalRects;

  setUp(() {
    debugSetGesturesExclusionSupported(true);
    sentPhysicalRects = [];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      _channel,
      (call) async {
        sentPhysicalRects.add([
          for (final rect in (call.arguments as List<Object?>).cast<Map<Object?, Object?>>())
            Rect.fromLTRB(
              (rect['left']! as int).toDouble(),
              (rect['top']! as int).toDouble(),
              (rect['right']! as int).toDouble(),
              (rect['bottom']! as int).toDouble(),
            ),
        ]);
        return null;
      },
    );
  });

  /// The rects sent to the platform for each call, in logical pixels.
  List<List<Rect>> sentRects(WidgetTester tester) {
    final ratio = MediaQuery.devicePixelRatioOf(tester.element(find.byType(Chessboard)));
    return [
      for (final rects in sentPhysicalRects)
        [
          for (final r in rects)
            Rect.fromLTRB(r.left / ratio, r.top / ratio, r.right / ratio, r.bottom / ratio),
        ],
    ];
  }

  tearDown(() {
    debugSetGesturesExclusionSupported(null);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      _channel,
      null,
    );
  });

  Widget boardLayout(GameBoardParams boardParams) => GameLayout(
    orientation: Side.white,
    boardParams: boardParams,
    topTable: const SizedBox(height: 100, child: Text('Top table')),
    bottomTable: const SizedBox(height: 100, child: Text('Bottom table')),
  );

  Future<void> pumpBoard(
    WidgetTester tester, {
    required GameBoardParams boardParams,
    bool isImmersiveMode = false,
    double sideMargin = 0,
  }) async {
    final app = await makeTestProviderScope(
      tester,
      child: MaterialApp(
        home: Scaffold(
          body: AndroidImmersiveModeWidget(
            enabled: isImmersiveMode,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: sideMargin),
              child: boardLayout(boardParams),
            ),
          ),
        ),
      ),
    );
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();
  }

  /// The last rects sent to the platform, in logical pixels.
  List<Rect> lastSentRects(WidgetTester tester) => sentRects(tester).lastOrNull ?? const [];

  /// The rect of [square] on the board, rounded down like the rects sent to the platform.
  Rect squareRect(WidgetTester tester, Square square) {
    final boardRect = tester.getRect(find.byType(Chessboard));
    final squareSize = boardRect.width / 8;
    final center = squareOffset(square, boardRect);
    return Rect.fromCenter(center: center, width: squareSize, height: squareSize);
  }

  void expectRects(List<Rect> actual, List<Rect> expected) {
    expect(actual, hasLength(expected.length));
    for (final rect in expected) {
      expect(
        actual.any(
          (r) =>
              (r.left - rect.left).abs() < 1 &&
              (r.top - rect.top).abs() < 1 &&
              (r.right - rect.right).abs() < 1 &&
              (r.bottom - rect.bottom).abs() < 1,
        ),
        isTrue,
        reason: '$rect should be in $actual',
      );
    }
  }

  group('AndroidBoardGesturesExclusion', () {
    testWidgets('refreshes edge protection when only a player table relayouts', (tester) async {
      await prepareLayoutGolden(tester);
      final playerHeight = ValueNotifier(30.0);
      addTearDown(playerHeight.dispose);
      final app = await makeTestProviderScope(
        tester,
        surfaceSize: const Size(360, 456),
        devicePixelRatio: 1,
        child: MaterialApp(
          home: Scaffold(
            body: GameLayout(
              orientation: Side.white,
              boardParams: _interactiveParams,
              topTable: ValueListenableBuilder(
                valueListenable: playerHeight,
                builder: (_, height, _) => SizedBox(height: height),
              ),
              bottomTable: const SizedBox(height: 40),
              userActionsBar: const SizedBox(height: 56),
            ),
          ),
        ),
      );
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();
      final layoutState = tester.state(find.byType(GameLayout));
      final boardState = tester.state(find.byType(BoardWidget));
      final controller = tester.widget<Chessboard>(find.byType(Chessboard)).controller;
      var controllerNotifications = 0;
      void onControllerChanged() => controllerNotifications++;
      controller.addListener(onControllerChanged);
      addTearDown(() => controller.removeListener(onControllerChanged));
      var previousBoard = tester.getRect(find.byType(Chessboard));
      expect(previousBoard, const Rect.fromLTWH(42, 62, 276, 276));

      for (final height in [80.0, 30.0]) {
        final previousRects = lastSentRects(tester);
        playerHeight.value = height;
        await tester.pumpAndSettle();
        final board = tester.getRect(find.byType(Chessboard));
        expect(board.size, previousBoard.size);
        expect(board.top, height == 80 ? 80 : 62);
        expect(tester.state(find.byType(GameLayout)), same(layoutState));
        expect(tester.state(find.byType(BoardWidget)), same(boardState));
        expect(tester.widget<Chessboard>(find.byType(Chessboard)).controller, same(controller));
        expect(controllerNotifications, 0);
        expect(find.byType(SingleChildScrollView), findsNothing);
        expect(
          lastSentRects(tester),
          isNot(previousRects),
          reason: 'A position-only table relayout must refresh native rectangles.',
        );
        expectRects(lastSentRects(tester), [
          for (final square in [Square.a1, Square.a2])
            if (squareRect(tester, square) case final rect)
              Rect.fromLTRB(0, rect.top, rect.right, rect.bottom),
          for (final square in [Square.h1, Square.h2])
            if (squareRect(tester, square) case final rect)
              Rect.fromLTRB(rect.left, rect.top, 360, rect.bottom),
        ]);
        await expectLayoutGolden(
          find.byType(GameLayout),
          '../../build/compact-layout/position-only-relayout-$height',
        );
        previousBoard = board;
      }
      expect(tester.takeException(), isNull);
    }, variant: const TargetPlatformVariant({TargetPlatform.android}));

    testWidgets('restores edge protection when portrait controls stop overflowing', (tester) async {
      final playerHeight = ValueNotifier(100.0);
      addTearDown(playerHeight.dispose);
      final app = await makeTestProviderScope(
        tester,
        child: MaterialApp(
          home: Scaffold(
            body: ValueListenableBuilder(
              valueListenable: playerHeight,
              builder: (_, height, _) => GameLayout(
                orientation: Side.white,
                boardParams: _interactiveParams,
                topTable: SizedBox(height: height),
                bottomTable: SizedBox(height: height),
              ),
            ),
          ),
        ),
      );
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();
      final boardState = tester.state(find.byType(BoardWidget));
      expect(lastSentRects(tester), hasLength(4));

      playerHeight.value = 500;
      await tester.pumpAndSettle();
      expect(tester.state(find.byType(BoardWidget)), same(boardState));
      expect(lastSentRects(tester), isEmpty);

      playerHeight.value = 100;
      await tester.pumpAndSettle();
      expect(tester.state(find.byType(BoardWidget)), same(boardState));
      expectRects(lastSentRects(tester), [
        for (final square in [Square.a1, Square.a2, Square.h1, Square.h2])
          squareRect(tester, square),
      ]);
      expect(tester.takeException(), isNull);
    }, variant: const TargetPlatformVariant({TargetPlatform.android}));

    testWidgets('excludes the edge squares with a piece the player can drag', (tester) async {
      await pumpBoard(tester, boardParams: _interactiveParams);

      expectRects(lastSentRects(tester), [
        for (final square in [Square.a1, Square.a2, Square.h1, Square.h2])
          squareRect(tester, square),
      ]);
    }, variant: const TargetPlatformVariant({TargetPlatform.android}));

    testWidgets('extends the excluded edge squares to the screen edges', (tester) async {
      await pumpBoard(tester, boardParams: _interactiveParams, sideMargin: 12);

      final boardRect = tester.getRect(find.byType(Chessboard));
      expect(boardRect.left, greaterThanOrEqualTo(12));
      final screenWidth = tester.view.physicalSize.width / tester.view.devicePixelRatio;
      expectRects(lastSentRects(tester), [
        for (final square in [Square.a1, Square.a2])
          if (squareRect(tester, square) case final rect)
            Rect.fromLTRB(0, rect.top, rect.right, rect.bottom),
        for (final square in [Square.h1, Square.h2])
          if (squareRect(tester, square) case final rect)
            Rect.fromLTRB(rect.left, rect.top, screenWidth, rect.bottom),
      ]);
    }, variant: const TargetPlatformVariant({TargetPlatform.android}));

    testWidgets('updates the excluded squares when the position changes', (tester) async {
      await pumpBoard(tester, boardParams: _interactiveParams);

      await pumpBoard(
        tester,
        boardParams: GameBoardParams.interactive(
          variant: Variant.standard,
          position: Chess.initial.play(Move.parse('a2a4')!),
          playerSide: PlayerSide.white,
          onMove: (_, {viaDragAndDrop}) {},
        ),
      );

      expectRects(lastSentRects(tester), [
        for (final square in [Square.a1, Square.a4, Square.h1, Square.h2])
          squareRect(tester, square),
      ]);
    }, variant: const TargetPlatformVariant({TargetPlatform.android}));

    testWidgets('excludes nothing on a board that cannot be played on', (tester) async {
      await pumpBoard(
        tester,
        boardParams: const GameBoardParams.readonly(
          variant: Variant.standard,
          position: Chess.initial,
        ),
      );

      expect(lastSentRects(tester), isEmpty);
    }, variant: const TargetPlatformVariant({TargetPlatform.android}));

    testWidgets('excludes the whole edge columns in immersive mode', (tester) async {
      await pumpBoard(tester, boardParams: _interactiveParams, isImmersiveMode: true);

      final boardRect = tester.getRect(find.byType(Chessboard));
      final squareSize = boardRect.width / 8;
      expectRects(lastSentRects(tester), [
        Rect.fromLTRB(
          boardRect.left,
          boardRect.top - 10,
          boardRect.left + squareSize,
          boardRect.bottom,
        ),
        Rect.fromLTRB(
          boardRect.right - squareSize,
          boardRect.top - 10,
          boardRect.right,
          boardRect.bottom,
        ),
      ]);

      await pumpBoard(tester, boardParams: _interactiveParams);
      expect(lastSentRects(tester), hasLength(4), reason: 'back to the pieces squares');
    }, variant: const TargetPlatformVariant({TargetPlatform.android}));

    testWidgets('excludes nothing on a board in a vertical scroll view', (tester) async {
      final app = await makeTestProviderScope(
        tester,
        child: MaterialApp(
          home: Scaffold(
            body: ListView(
              children: [SizedBox(height: 700, child: boardLayout(_interactiveParams))],
            ),
          ),
        ),
      );
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      expect(find.byType(Chessboard), findsOneWidget);
      expect(sentPhysicalRects, isEmpty);
    }, variant: const TargetPlatformVariant({TargetPlatform.android}));

    testWidgets('clears the rects when the board screen is covered or popped', (tester) async {
      final app = await makeTestProviderScope(
        tester,
        child: MaterialApp(
          home: Builder(
            builder: (context) => TextButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => Scaffold(
                    appBar: AppBar(
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const Scaffold(body: Text('Covering screen')),
                            ),
                          ),
                          child: const Text('Cover'),
                        ),
                      ],
                    ),
                    body: boardLayout(_interactiveParams),
                  ),
                ),
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      );
      await tester.pumpWidget(app);
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      expect(lastSentRects(tester), hasLength(4));

      await tester.tap(find.text('Cover'));
      await tester.pumpAndSettle();
      expect(sentPhysicalRects.last, isEmpty, reason: 'covered screen');

      tester.state<NavigatorState>(find.byType(Navigator)).pop();
      await tester.pumpAndSettle();
      expect(lastSentRects(tester), hasLength(4), reason: 'visible again');

      tester.state<NavigatorState>(find.byType(Navigator)).pop();
      await tester.pumpAndSettle();
      expect(find.byType(Chessboard), findsNothing);
      expect(sentPhysicalRects.last, isEmpty, reason: 'popped screen');
    }, variant: const TargetPlatformVariant({TargetPlatform.android}));

    testWidgets('does nothing on iOS', (tester) async {
      await pumpBoard(tester, boardParams: _interactiveParams);

      expect(sentPhysicalRects, isEmpty);
    }, variant: const TargetPlatformVariant({TargetPlatform.iOS}));
  });
}
