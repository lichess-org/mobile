import 'dart:convert';
import 'dart:math';

import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/game/game_board_params.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/model/settings/preferences_storage.dart';
import 'package:lichess_mobile/src/widgets/board.dart';
import 'package:lichess_mobile/src/widgets/game_layout.dart';
import 'package:lichess_mobile/src/widgets/move_list.dart';
import 'package:lichess_mobile/src/widgets/pockets.dart';

import '../test_helpers.dart';
import '../test_provider_scope.dart';

void main() {
  testWidgets('board background size should match board size on all surfaces', (
    WidgetTester tester,
  ) async {
    for (final surface in kTestSurfaces) {
      final app = await makeTestProviderScope(
        key: ValueKey(surface),
        tester,
        child: const MaterialApp(
          home: GameLayout(
            orientation: Side.white,
            boardParams: GameBoardParams.readonly(
              fen: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR',
              variant: Variant.standard,
              pockets: null,
            ),
            topTable: Row(
              mainAxisSize: MainAxisSize.max,
              key: ValueKey('top_table'),
              children: [Text('Top table')],
            ),
            bottomTable: Row(
              mainAxisSize: MainAxisSize.max,
              key: ValueKey('bottom_table'),
              children: [Text('Bottom table')],
            ),
          ),
        ),
        surfaceSize: surface,
      );
      await tester.pumpWidget(app);

      final backgroundSize = tester.getSize(find.byType(SolidColorChessboardBackground));

      expect(
        backgroundSize.width,
        backgroundSize.height,
        reason: 'Board background size is square on $surface',
      );

      final boardSize = tester.getSize(find.byType(Chessboard));

      expect(boardSize.width, boardSize.height, reason: 'Board size is square on $surface');

      expect(
        boardSize,
        backgroundSize,
        reason: 'Board size should match background size on $surface',
      );
    }
  }, variant: kPlatformVariant);

  testWidgets('Landscape board position', (WidgetTester tester) async {
    for (final boardPosition in LandscapeBoardPosition.values) {
      const tabletSurface = Size(1280, 800);
      final app = await makeTestProviderScope(
        key: ValueKey(boardPosition),
        tester,
        child: const MaterialApp(
          home: GameLayout(
            orientation: Side.white,
            boardParams: GameBoardParams.readonly(
              fen: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR',
              variant: Variant.standard,
              pockets: null,
            ),
            moves: ['e4', 'e5'],
            topTable: Row(
              mainAxisSize: MainAxisSize.max,
              key: ValueKey('top_table'),
              children: [Text('Top table')],
            ),
            bottomTable: Row(
              mainAxisSize: MainAxisSize.max,
              key: ValueKey('bottom_table'),
              children: [Text('Bottom table')],
            ),
          ),
        ),
        defaultPreferences: {
          PrefCategory.board.storageKey: jsonEncode(
            BoardPrefs.defaults.copyWith(landscapeBoardPosition: boardPosition).toJson(),
          ),
        },
        surfaceSize: tabletSurface,
      );
      await tester.pumpWidget(app);

      final boardTopLeft = tester.getTopLeft(find.byType(Chessboard));
      final moveListTopLeft = tester.getTopLeft(find.byType(MoveList));

      expect(
        moveListTopLeft.dx,
        boardPosition == LandscapeBoardPosition.left
            ? greaterThan(boardTopLeft.dx)
            : lessThan(boardTopLeft.dx),
      );
    }
  }, variant: kPlatformVariant);

  testWidgets('board size and table side size should be harmonious on all surfaces', (
    WidgetTester tester,
  ) async {
    for (final surface in kTestSurfaces) {
      final app = await makeTestProviderScope(
        key: ValueKey(surface),
        tester,
        child: const MaterialApp(
          home: GameLayout(
            orientation: Side.white,
            boardParams: GameBoardParams.readonly(
              fen: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR',
              variant: Variant.standard,
              pockets: null,
            ),
            topTable: Row(
              mainAxisSize: MainAxisSize.max,
              key: ValueKey('top_table'),
              children: [Text('Top table')],
            ),
            bottomTable: Row(
              mainAxisSize: MainAxisSize.max,
              key: ValueKey('bottom_table'),
              children: [Text('Bottom table')],
            ),
          ),
        ),
        surfaceSize: surface,
      );
      await tester.pumpWidget(app);

      final isPortrait = surface.aspectRatio < 1.0;
      final isTablet = surface.shortestSide > 600;
      final boardSize = tester.getSize(find.byType(Chessboard));

      if (isPortrait) {
        // isShortVerticalScreen uses viewPadding=0 in tests, kToolbarHeight=56, kBottomBarHeight=56
        final isShortScreen =
            surface.height - surface.width - kToolbarHeight - kBottomBarHeight <
            kSmallHeightMinusBoard;
        final baseBoardSize = isTablet ? surface.width - 32.0 : surface.width;
        final expectedBoardSize = isShortScreen ? baseBoardSize - 16.0 : baseBoardSize;
        expect(
          boardSize,
          Size(expectedBoardSize, expectedBoardSize),
          reason: 'Board size should be $expectedBoardSize on $surface',
        );
      } else {
        final topTableSize = tester.getSize(find.byKey(const ValueKey('top_table')));
        final bottomTableSize = tester.getSize(find.byKey(const ValueKey('bottom_table')));
        final goldenBoardSize = (surface.longestSide / kGoldenRatio) - 32.0;
        final defaultBoardSize = surface.shortestSide - 32.0;
        final minBoardSize = min(goldenBoardSize, defaultBoardSize);
        final maxBoardSize = max(goldenBoardSize, defaultBoardSize);
        final minSideWidth = min(surface.longestSide - goldenBoardSize - 16.0 * 3, 250.0);
        expect(
          boardSize.width,
          greaterThanOrEqualTo(minBoardSize),
          reason: 'Board size should be at least $minBoardSize on $surface',
        );
        expect(
          boardSize.width,
          lessThanOrEqualTo(maxBoardSize),
          reason: 'Board size should be at most $maxBoardSize on $surface',
        );
        expect(
          bottomTableSize.width,
          greaterThanOrEqualTo(minSideWidth),
          reason: 'Bottom table width should be at least $minSideWidth on $surface',
        );
        expect(
          topTableSize.width,
          greaterThanOrEqualTo(minSideWidth),
          reason: 'Top table width should be at least $minSideWidth on $surface',
        );
      }
    }
  }, variant: kPlatformVariant);

  test('variantBoardOrientation', () {
    for (final variant in Variant.values.where((v) => v != Variant.racingKings)) {
      expect(
        variantBoardOrientation(variant: variant, youAre: Side.white, isBoardTurned: false),
        Side.white,
      );
      expect(
        variantBoardOrientation(variant: variant, youAre: Side.black, isBoardTurned: false),
        Side.black,
      );
      expect(
        variantBoardOrientation(variant: variant, youAre: Side.white, isBoardTurned: true),
        Side.black,
      );
      expect(
        variantBoardOrientation(variant: variant, youAre: Side.black, isBoardTurned: true),
        Side.white,
      );
    }

    expect(
      variantBoardOrientation(
        variant: Variant.racingKings,
        youAre: Side.white,
        isBoardTurned: false,
      ),
      Side.white,
    );
    expect(
      variantBoardOrientation(
        variant: Variant.racingKings,
        youAre: Side.black,
        isBoardTurned: false,
      ),
      Side.white,
    );
    expect(
      variantBoardOrientation(
        variant: Variant.racingKings,
        youAre: Side.white,
        isBoardTurned: true,
      ),
      Side.black,
    );
    expect(
      variantBoardOrientation(
        variant: Variant.racingKings,
        youAre: Side.black,
        isBoardTurned: true,
      ),
      Side.black,
    );
  });

  testWidgets(
    'owned board becomes interactive when boardParams transitions from readonly',
    (WidgetTester tester) async {
      final paramsNotifier = ValueNotifier<GameBoardParams>(GameBoardParams.emptyBoard);
      addTearDown(paramsNotifier.dispose);
      final playedMoves = <Move>[];

      final app = await makeTestProviderScope(
        tester,
        child: MaterialApp(
          home: ValueListenableBuilder<GameBoardParams>(
            valueListenable: paramsNotifier,
            builder: (context, params, _) =>
                GameLayout(orientation: Side.white, boardParams: params),
          ),
        ),
      );
      await tester.pumpWidget(app);

      // Readonly boards are controller-backed but non-interactive (PlayerSide.none).
      expect(tester.widget<Chessboard>(find.byType(Chessboard)).interactive, isFalse);

      // Transition the same GameLayout to interactive params (triggers didUpdateWidget).
      paramsNotifier.value = GameBoardParams.interactive(
        variant: Variant.standard,
        position: Chess.initial,
        playerSide: PlayerSide.white,
        onMove: (move, {viaDragAndDrop}) {
          playedMoves.add(move);
        },
      );
      await tester.pump();

      // The same board is now interactive.
      expect(tester.widget<Chessboard>(find.byType(Chessboard)).interactive, isTrue);

      // And user interaction reaches the onMove callback.
      await playMove(tester, 'e2', 'e4');
      expect(playedMoves, [const NormalMove(from: Square.e2, to: Square.e4)]);
    },
    variant: kPlatformVariant,
  );

  testWidgets('Crazyhouse displays pockets and supports drop moves', (WidgetTester tester) async {
    final playedMoves = <Move>[];
    final app = await makeTestProviderScope(
      tester,
      child: MaterialApp(
        home: GameLayout(
          orientation: Side.white,
          boardParams: GameBoardParams.interactive(
            variant: Variant.crazyhouse,
            position: Crazyhouse.fromSetup(
              Setup.parseFen('rnb1kbnr/ppp1pppp/8/3q4/8/8/PPPP1PPP/RNBQKBNR[Pp] w KQkq - 0 3'),
            ),
            playerSide: PlayerSide.white,
            onMove: (move, {viaDragAndDrop}) {
              playedMoves.add(move);
            },
          ),
        ),
      ),
    );
    await tester.pumpWidget(app);

    expect(find.byType(PocketsMenu), findsNWidgets(2));

    // Only the pockets of the player side should be interactive.
    await playDropMove(tester, Side.white, Role.pawn, 'a4');
    await playDropMove(tester, Side.black, Role.pawn, 'a3');

    expect(playedMoves, [const DropMove(to: Square.a4, role: Role.pawn)]);
  });

  testWidgets('readonly board animates to a new position and highlights the last move', (
    tester,
  ) async {
    final after1e4 = Chess.initial.play(const NormalMove(from: Square.e2, to: Square.e4));
    final boardNotifier = ValueNotifier<({String fen, Move? lastMove})>((
      fen: kInitialFEN,
      lastMove: null,
    ));
    addTearDown(boardNotifier.dispose);

    final app = await makeTestProviderScope(
      tester,
      child: MaterialApp(
        home: ValueListenableBuilder<({String fen, Move? lastMove})>(
          valueListenable: boardNotifier,
          builder: (context, value, _) => GameLayout(
            orientation: Side.white,
            boardParams: GameBoardParams.readonly(
              fen: value.fen,
              variant: Variant.standard,
              pockets: null,
              lastMove: value.lastMove,
            ),
          ),
        ),
      ),
    );
    await tester.pumpWidget(app);

    expect(boardHasPiece(tester, Square.e2, Piece.whitePawn), isTrue);
    expect(tester.widget<Chessboard>(find.byType(Chessboard)).interactive, isFalse);

    // Advance the readonly board to the position after 1.e4.
    boardNotifier.value = (
      fen: after1e4.fen,
      lastMove: const NormalMove(from: Square.e2, to: Square.e4),
    );
    await tester.pumpAndSettle();

    expect(boardHasPiece(tester, Square.e4, Piece.whitePawn), isTrue);
    expect(getBoardPieces(tester).containsKey(Square.e2), isFalse);
    expect(getBoardLastMove(tester), const NormalMove(from: Square.e2, to: Square.e4));
    // It must remain non-interactive throughout.
    expect(tester.widget<Chessboard>(find.byType(Chessboard)).interactive, isFalse);
  });

  testWidgets('interactive board can be disabled via a metadata-only update (PlayerSide.none)', (
    tester,
  ) async {
    void noopOnMove(Move move, {bool? viaDragAndDrop}) {}

    final sideNotifier = ValueNotifier<PlayerSide>(PlayerSide.white);
    addTearDown(sideNotifier.dispose);

    final app = await makeTestProviderScope(
      tester,
      child: MaterialApp(
        home: ValueListenableBuilder<PlayerSide>(
          valueListenable: sideNotifier,
          builder: (context, playerSide, _) => GameLayout(
            orientation: Side.white,
            boardParams: GameBoardParams.interactive(
              variant: Variant.standard,
              position: Chess.initial,
              playerSide: playerSide,
              onMove: noopOnMove,
            ),
          ),
        ),
      ),
    );
    await tester.pumpWidget(app);

    expect(tester.widget<Chessboard>(find.byType(Chessboard)).interactive, isTrue);

    // Same position, only the playerSide changes (e.g. game over) — the board
    // should become non-interactive without a position change.
    sideNotifier.value = PlayerSide.none;
    await tester.pump();

    expect(tester.widget<Chessboard>(find.byType(Chessboard)).interactive, isFalse);
    expect(getBoardPieces(tester).length, 32);
  });

  testWidgets('controllerParams path renders the external controller and does not dispose it', (
    tester,
  ) async {
    final playedMoves = <Move>[];
    final controller = ChessboardController(
      game: buildGameData(
        fen: kInitialFEN,
        variant: Variant.standard,
        position: Chess.initial,
        playerSide: PlayerSide.white,
        castlingMethod: CastlingMethod.kingTwoSquares,
        boardHighlights: true,
      ),
    );
    addTearDown(controller.dispose);

    final showBoard = ValueNotifier<bool>(true);
    addTearDown(showBoard.dispose);

    final app = await makeTestProviderScope(
      tester,
      child: MaterialApp(
        home: ValueListenableBuilder<bool>(
          valueListenable: showBoard,
          builder: (context, show, _) => show
              ? GameLayout(
                  orientation: Side.white,
                  controllerParams: ControllerBoardParams(
                    controller: controller,
                    variant: Variant.standard,
                    onMove: (move, {viaDragAndDrop}) => playedMoves.add(move),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ),
    );
    await tester.pumpWidget(app);

    expect(tester.widget<Chessboard>(find.byType(Chessboard)).interactive, isTrue);

    await playMove(tester, 'e2', 'e4');
    expect(playedMoves, [const NormalMove(from: Square.e2, to: Square.e4)]);

    // Removing the GameLayout must not dispose the externally-owned controller.
    showBoard.value = false;
    await tester.pumpAndSettle();
    expect(
      () => controller.updatePosition(
        buildGameData(
          fen: kInitialFEN,
          variant: Variant.standard,
          position: Chess.initial,
          playerSide: PlayerSide.white,
          castlingMethod: CastlingMethod.kingTwoSquares,
          boardHighlights: true,
        ),
      ),
      returnsNormally,
    );
  });
}
