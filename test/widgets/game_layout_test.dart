import 'dart:convert';
import 'dart:math';

import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
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
import 'package:material_ui/material_ui.dart';

import '../test_helpers.dart';
import '../test_provider_scope.dart';

const _safeAreaContentKey = ValueKey('safe-area-content');
const _iPhone16Surface = Size(393.0, 852.0);
const _iPhone16ViewPadding = EdgeInsets.only(top: 59.0, bottom: 34.0);
const _iPhone16ZoomedSurface = Size(320.0, 693.0);
const _iPhone16ZoomedViewPadding = EdgeInsets.only(top: 47.0, bottom: 34.0);

Future<void> _pumpGameLayoutWithSafeArea(
  WidgetTester tester, {
  required Size surface,
  required EdgeInsets viewPadding,
  bool showBorder = false,
  GameBoardParams? boardParams,
}) async {
  final flutterTestOnError = FlutterError.onError!;
  final app = await makeTestProviderScope(
    tester,
    child: MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(size: surface, padding: viewPadding, viewPadding: viewPadding),
        child: SafeArea(
          maintainBottomViewPadding: true,
          child: SizedBox.expand(
            key: _safeAreaContentKey,
            child: GameLayout(
              orientation: Side.white,
              boardParams:
                  boardParams ??
                  const GameBoardParams.readonly(
                    variant: Variant.standard,
                    position: Chess.initial,
                  ),
            ),
          ),
        ),
      ),
    ),
    defaultPreferences: showBorder
        ? {
            PrefCategory.board.storageKey: jsonEncode(
              BoardPrefs.defaults.copyWith(pieceAnimation: false, showBorder: true).toJson(),
            ),
          }
        : null,
    surfaceSize: surface,
    devicePixelRatio: 1.0,
    physicalViewPadding: viewPadding,
  );
  FlutterError.onError = flutterTestOnError;
  addTearDown(() => FlutterError.onError = flutterTestOnError);
  await tester.pumpWidget(app);
}

void _expectHorizontalInset(Rect inner, Rect outer, double inset) {
  expect(inner.left, moreOrLessEquals(outer.left + inset));
  expect(inner.right, moreOrLessEquals(outer.right - inset));
  expect(inner.width, moreOrLessEquals(outer.width - inset * 2));
}

void main() {
  for (final showMoves in [false, true]) {
    for (final boardPosition in LandscapeBoardPosition.values) {
      testWidgets('compact post-startup landscape controls scroll without moving the board '
          'moves=$showMoves board=${boardPosition.name}', (tester) async {
        await prepareLayoutGolden(tester, loadFonts: true);
        final tableHeights = ValueNotifier<(double, double)>((32, 32));
        addTearDown(tableHeights.dispose);
        const topKey = ValueKey('landscape-top-player');
        const bottomKey = ValueKey('landscape-bottom-player');
        var taps = 0;
        final flutterTestOnError = FlutterError.onError!;
        final app = await makeTestProviderScope(
          tester,
          surfaceSize: const Size(700, 320),
          devicePixelRatio: 1.0,
          defaultPreferences: {
            PrefCategory.board.storageKey: jsonEncode(
              BoardPrefs.defaults
                  .copyWith(moveListDisplay: showMoves, landscapeBoardPosition: boardPosition)
                  .toJson(),
            ),
          },
          child: MaterialApp(
            home: Material(
              child: GameLayout(
                orientation: Side.white,
                boardParams: const GameBoardParams.readonly(
                  variant: Variant.standard,
                  position: Chess.initial,
                ),
                moves: const ['e4', 'e5'],
                topTable: ValueListenableBuilder(
                  valueListenable: tableHeights,
                  builder: (_, value, _) => SizedBox(
                    key: topKey,
                    height: value.$1,
                    child: TextButton(onPressed: () => taps++, child: const Text('Top player')),
                  ),
                ),
                bottomTable: ValueListenableBuilder(
                  valueListenable: tableHeights,
                  builder: (_, value, _) => SizedBox(
                    key: bottomKey,
                    height: value.$2,
                    child: TextButton(onPressed: () => taps++, child: const Text('Bottom player')),
                  ),
                ),
                userActionsBar: const SizedBox(height: 56, child: Center(child: Text('Actions'))),
              ),
            ),
          ),
        );
        FlutterError.onError = flutterTestOnError;
        addTearDown(() => FlutterError.onError = flutterTestOnError);
        await tester.pumpWidget(app);
        await tester.pumpAndSettle();
        final panel = find
            .descendant(of: find.byType(GameLayout), matching: find.byType(SingleChildScrollView))
            .first;
        final scrollable = find.descendant(of: panel, matching: find.byType(Scrollable)).first;
        final scroll = tester.state<ScrollableState>(scrollable).position;
        final board = tester.getRect(find.byType(Chessboard));
        final capturePath =
            '../../build/compact-layout/landscape-panel-$showMoves-${boardPosition.name}';
        expect(scroll.maxScrollExtent, 0);
        expect(find.text('Top player').hitTestable(), findsOneWidget);
        expect(find.text('Bottom player').hitTestable(), findsOneWidget);
        await expectLayoutGolden(find.byType(GameLayout), '$capturePath-fitting');

        tableHeights.value = (80, 80);
        await tester.pumpAndSettle();
        expect(scroll.maxScrollExtent, 0);
        if (showMoves) {
          await tester.ensureVisible(find.text('e4'));
          await tester.pumpAndSettle();
          expect(find.text('e4').hitTestable(), findsOneWidget);
        }
        expect(find.text('Top player').hitTestable(), findsOneWidget);
        expect(find.text('Bottom player').hitTestable(), findsOneWidget);
        expect(tester.getRect(find.byType(Chessboard)), board);
        expect(tester.takeException(), isNull);
        await expectLayoutGolden(find.byType(GameLayout), '$capturePath-tight');

        tableHeights.value = (100, 240);
        await tester.pumpAndSettle();
        expect(scroll.maxScrollExtent, greaterThan(0));
        expect(tester.getRect(find.byType(Chessboard)), board);
        expect(tester.takeException(), isNull);
        await expectLayoutGolden(find.byType(GameLayout), '$capturePath-expanded');

        final viewport = tester.getRect(panel);
        await tester.dragFrom(Offset(viewport.center.dx, viewport.top + 24), const Offset(0, -600));
        await tester.pumpAndSettle();
        expect(scroll.pixels, scroll.maxScrollExtent);
        expect(find.text('Bottom player').hitTestable(), findsOneWidget);
        await tester.tap(find.text('Bottom player'));
        expect(taps, 1);
        expect(tester.getRect(find.byType(Chessboard)), board);
        await expectLayoutGolden(find.byType(GameLayout), '$capturePath-scrolled');

        await tester.dragFrom(
          Offset(viewport.center.dx, viewport.bottom - 24),
          const Offset(0, 600),
        );
        await tester.pumpAndSettle();
        expect(scroll.pixels, 0);
        await tester.tap(find.text('Top player'));
        expect(taps, 2);
        if (showMoves) {
          await tester.ensureVisible(find.byType(MoveList));
          await tester.pumpAndSettle();
          expect(tester.getSize(find.byType(MoveList)).height, greaterThan(0));
          expect(find.text('e4').hitTestable(), findsOneWidget);
        }
        tableHeights.value = (32, 32);
        await tester.pumpAndSettle();
        expect(scroll.maxScrollExtent, 0);
        expect(tester.getRect(find.byType(Chessboard)), board);
        expect(tester.takeException(), isNull);
      }, variant: kPlatformVariant);
    }
  }

  for (final profile in [
    (
      name: 'phone',
      surface: const Size(360, 560),
      factor: 1.0,
      expandedHeights: (110.0, 150.0),
      initialBoardWidth: 290.0,
      landscapeBoardWidth: 305.2307692307692,
    ),
    (
      name: 'tablet',
      surface: const Size(720, 960),
      factor: 0.7,
      expandedHeights: (210.0, 250.0),
      initialBoardWidth: 618.0,
      landscapeBoardWidth: 623.304347826087,
    ),
  ]) {
    for (final upsideDown in [false, true]) {
      testWidgets(
        'adaptive crazyhouse pockets follow the resized board ${profile.name} flipped=$upsideDown',
        (tester) async {
          await prepareLayoutGolden(tester);
          final heights = ValueNotifier<(double, double)>((30, 40));
          addTearDown(heights.dispose);
          final playedMoves = <Move>[];
          const topKey = ValueKey('adaptive-pocket-top');
          const bottomKey = ValueKey('adaptive-pocket-bottom');
          const actionsKey = ValueKey('adaptive-pocket-actions');
          final flutterTestOnError = FlutterError.onError!;
          final app = await makeTestProviderScope(
            tester,
            surfaceSize: profile.surface,
            devicePixelRatio: 1.0,
            child: MaterialApp(
              home: Material(
                child: GameLayout(
                  orientation: Side.white,
                  boardParams: GameBoardParams.interactive(
                    variant: Variant.crazyhouse,
                    position: Crazyhouse.fromSetup(
                      Setup.parseFen(
                        'rnb1kbnr/ppp1pppp/8/3q4/8/8/PPPP1PPP/RNBQKBNR[Pp] w KQkq - 0 3',
                      ),
                    ),
                    playerSide: PlayerSide.white,
                    onMove: (move, {viaDragAndDrop}) => playedMoves.add(move),
                  ),
                  topTableUpsideDown: upsideDown,
                  bottomTableUpsideDown: upsideDown,
                  topTable: ValueListenableBuilder(
                    valueListenable: heights,
                    builder: (context, value, _) => SizedBox(
                      key: topKey,
                      height: value.$1,
                      child: const Center(child: Text('Black')),
                    ),
                  ),
                  bottomTable: ValueListenableBuilder(
                    valueListenable: heights,
                    builder: (context, value, _) => SizedBox(
                      key: bottomKey,
                      height: value.$2,
                      child: const Center(child: Text('White')),
                    ),
                  ),
                  userActionsBar: const SizedBox(key: actionsKey, height: 56),
                ),
              ),
            ),
          );
          FlutterError.onError = flutterTestOnError;
          addTearDown(() => FlutterError.onError = flutterTestOnError);
          await tester.pumpWidget(app);
          final state = tester.state(find.byType(GameLayout));
          final controller = tester.widget<BoardWidget>(find.byType(BoardWidget)).controller;
          final capturePath = '../../build/compact-layout/crazyhouse-${profile.name}-$upsideDown';

          void checkLayout({bool portrait = true}) {
            expect(tester.state(find.byType(GameLayout)), same(state));
            expect(
              tester.widget<BoardWidget>(find.byType(BoardWidget)).controller,
              same(controller),
            );
            final board = tester.getRect(find.byType(Chessboard));
            expect(board.width, greaterThan(0));
            expect(board.width, moreOrLessEquals(board.height));
            final menus = find.byType(PocketsMenu);
            expect(menus, findsNWidgets(2));
            final squareSize = board.width / 8 * profile.factor;
            for (final menu in tester.widgetList<PocketsMenu>(menus)) {
              expect(menu.squareSize, moreOrLessEquals(squareSize));
              expect(menu.isUpsideDown, upsideDown);
              expect(
                tester.getSize(find.byWidget(menu)).width,
                moreOrLessEquals(5 * squareSize + 16),
              );
              if (portrait) {
                expect(tester.getCenter(find.byWidget(menu)).dx, moreOrLessEquals(board.center.dx));
              }
            }
            final pieces = find.descendant(of: menus, matching: find.byType(PieceWidget));
            expect(pieces, findsNWidgets(10));
            for (final element in pieces.evaluate()) {
              final size = tester.getSize(find.byWidget(element.widget));
              expect(size.width, moreOrLessEquals(squareSize));
              expect(size.height, moreOrLessEquals(squareSize));
              final rect = tester.getRect(find.byWidget(element.widget));
              final menu = tester.getRect(
                find.ancestor(of: find.byWidget(element.widget), matching: menus),
              );
              expect(rect.left, greaterThanOrEqualTo(menu.left - 0.001));
              expect(rect.right, lessThanOrEqualTo(menu.right + 0.001));
            }
            if (portrait) {
              final topPockets = tester.getRect(menus.at(0));
              final bottomPockets = tester.getRect(menus.at(1));
              final topPlayer = tester.getRect(find.byKey(topKey));
              final bottomPlayer = tester.getRect(find.byKey(bottomKey));
              expect(topPockets.bottom, moreOrLessEquals(topPlayer.top));
              expect(topPlayer.bottom, lessThanOrEqualTo(board.top + 0.001));
              expect(bottomPlayer.top, greaterThanOrEqualTo(board.bottom - 0.001));
              expect(bottomPlayer.bottom, moreOrLessEquals(bottomPockets.top));
              expect(topPockets.top, greaterThanOrEqualTo(0));
              expect(
                bottomPockets.bottom,
                lessThanOrEqualTo(tester.getRect(find.byKey(actionsKey)).top + 0.001),
              );
            }
            expect(tester.takeException(), isNull);
          }

          checkLayout();
          expect(tester.getSize(find.byType(Chessboard)).width, profile.initialBoardWidth);
          await expectLayoutGolden(find.byType(GameLayout), '$capturePath-initial');

          heights.value = profile.expandedHeights;
          await tester.pump();
          checkLayout();
          final boardWidth = tester.getSize(find.byType(Chessboard)).width;
          expect(boardWidth, lessThan(profile.initialBoardWidth));
          expect(
            boardWidth +
                2 * (boardWidth / 8 * profile.factor + 16) +
                heights.value.$1 +
                heights.value.$2 +
                56,
            moreOrLessEquals(profile.surface.height),
          );
          await expectLayoutGolden(find.byType(GameLayout), '$capturePath-shrunk');

          final gesture = await tester.startGesture(
            tester.getCenter(find.byKey(const ValueKey('pocket-whitepawn'))),
          );
          await gesture.moveBy(const Offset(0, -30));
          await tester.pump();
          expect(find.byType(PieceDragFeedback), findsOneWidget);
          final feedback = tester.widget<PieceDragFeedback>(find.byType(PieceDragFeedback));
          expect(feedback.squareSize, moreOrLessEquals(boardWidth / 8 * profile.factor));
          expect(
            tester.getSize(find.byType(PieceDragFeedback)).width,
            moreOrLessEquals(feedback.squareSize * feedback.scale),
          );
          expect(
            tester
                .widget<RotatedBox>(
                  find
                      .ancestor(
                        of: find.byType(PieceDragFeedback),
                        matching: find.byType(RotatedBox),
                      )
                      .first,
                )
                .quarterTurns,
            upsideDown ? 2 : 0,
          );
          await expectLayoutGolden(find.byType(Overlay).first, '$capturePath-drag');
          await gesture.moveTo(squareOffset(Square.a4, tester.getRect(find.byType(Chessboard))));
          await gesture.up();
          await tester.pump();
          expect(playedMoves, [const DropMove(to: Square.a4, role: Role.pawn)]);
          expect(find.byType(PieceDragFeedback), findsNothing);
          checkLayout();

          heights.value = (30, 40);
          await tester.pump();
          checkLayout();
          expect(tester.getSize(find.byType(Chessboard)).width, profile.initialBoardWidth);

          await resizeTestSurface(
            tester,
            Size(profile.surface.height, profile.surface.width),
            physicalViewPadding: EdgeInsets.zero,
          );
          checkLayout(portrait: false);
          expect(
            tester.getSize(find.byType(Chessboard)).width,
            moreOrLessEquals(profile.landscapeBoardWidth),
          );
          await expectLayoutGolden(find.byType(GameLayout), '$capturePath-landscape');
          await resizeTestSurface(tester, profile.surface, physicalViewPadding: EdgeInsets.zero);
          checkLayout();
          expect(tester.getSize(find.byType(Chessboard)).width, profile.initialBoardWidth);
          await expectLayoutGolden(find.byType(GameLayout), '$capturePath-returned');
        },
        variant: kPlatformVariant,
      );
    }
  }

  testWidgets('portrait board yields only the space needed by changing player tables', (
    tester,
  ) async {
    final heights = ValueNotifier<(double, double)>((30, 40));
    addTearDown(heights.dispose);
    const topKey = ValueKey('adaptive-top');
    const bottomKey = ValueKey('adaptive-bottom');
    const actionsKey = ValueKey('adaptive-actions');
    final flutterTestOnError = FlutterError.onError!;
    final app = await makeTestProviderScope(
      tester,
      surfaceSize: const Size(360, 456),
      child: MaterialApp(
        home: GameLayout(
          orientation: Side.white,
          boardParams: const GameBoardParams.readonly(
            variant: Variant.standard,
            position: Chess.initial,
          ),
          topTable: ValueListenableBuilder(
            valueListenable: heights,
            builder: (context, value, _) => SizedBox(key: topKey, width: 96, height: value.$1),
          ),
          bottomTable: ValueListenableBuilder(
            valueListenable: heights,
            builder: (context, value, _) => SizedBox(key: bottomKey, width: 144, height: value.$2),
          ),
          userActionsBar: const SizedBox(key: actionsKey, height: 56),
        ),
      ),
    );
    FlutterError.onError = flutterTestOnError;
    addTearDown(() => FlutterError.onError = flutterTestOnError);
    await tester.pumpWidget(app);
    final state = tester.state(find.byType(GameLayout));
    expect(tester.getSize(find.byType(Chessboard)), const Size.square(276));
    expect(tester.getSize(find.byKey(topKey)).width, 96);
    expect(tester.getSize(find.byKey(bottomKey)).width, 144);
    expect(tester.getCenter(find.byKey(topKey)).dx, 180);
    expect(tester.getCenter(find.byKey(bottomKey)).dx, 180);

    heights.value = (110, 150);
    await tester.pump();
    expect(tester.state(find.byType(GameLayout)), same(state));
    final board = tester.getRect(find.byType(Chessboard));
    expect(board.size, const Size.square(140));
    expect(tester.getSize(find.byKey(topKey)).width, 96);
    expect(tester.getSize(find.byKey(bottomKey)).width, 144);
    expect(tester.getCenter(find.byKey(topKey)).dx, board.center.dx);
    expect(tester.getCenter(find.byKey(bottomKey)).dx, board.center.dx);
    expect(tester.getRect(find.byKey(topKey)).bottom, board.top);
    expect(tester.getRect(find.byKey(bottomKey)).top, board.bottom);
    expect(
      tester.getRect(find.byKey(bottomKey)).bottom,
      tester.getRect(find.byKey(actionsKey)).top,
    );
    expect(tester.takeException(), isNull);

    heights.value = (30, 40);
    await tester.pump();
    expect(tester.getSize(find.byType(Chessboard)), const Size.square(276));
    expect(tester.takeException(), isNull);
  }, variant: kPlatformVariant);

  testWidgets('portrait iPhone board fills the safe area width when the border is hidden', (
    WidgetTester tester,
  ) async {
    await _pumpGameLayoutWithSafeArea(
      tester,
      surface: _iPhone16Surface,
      viewPadding: _iPhone16ViewPadding,
    );

    final safeAreaRect = tester.getRect(find.byKey(_safeAreaContentKey));
    final boardRect = tester.getRect(find.byType(Chessboard));
    final playableGridRect = tester.getRect(find.byType(SolidColorChessboardBackground));

    _expectHorizontalInset(boardRect, safeAreaRect, 0.0);
    _expectHorizontalInset(playableGridRect, safeAreaRect, 0.0);
  }, variant: const TargetPlatformVariant({TargetPlatform.iOS}));

  for (final scenario in [
    (name: 'below', height: 587.0, boardSize: 359.0),
    (name: 'at', height: 588.0, boardSize: 360.0),
    (name: 'above', height: 589.0, boardSize: 360.0),
    (name: 'well below', height: 548.0, boardSize: 320.0),
  ]) {
    testWidgets('compact board ${scenario.name} the height-cap boundary', (tester) async {
      // 360 board + 180 reserved + 24 top and 24 bottom safe-area insets.
      await _pumpGameLayoutWithSafeArea(
        tester,
        surface: Size(360.0, scenario.height),
        viewPadding: const EdgeInsets.symmetric(vertical: 24.0),
      );

      final safeAreaRect = tester.getRect(find.byKey(_safeAreaContentKey));
      final boardRect = tester.getRect(find.byType(Chessboard));
      expect(boardRect.size, Size.square(scenario.boardSize));
      expect(boardRect.center.dx, moreOrLessEquals(safeAreaRect.center.dx));
      expect(boardRect.top, greaterThanOrEqualTo(safeAreaRect.top));
      expect(boardRect.bottom, lessThanOrEqualTo(safeAreaRect.bottom));
      expect(tester.getRect(find.byType(SolidColorChessboardBackground)), boardRect);
      expect(tester.takeException(), isNull);
    }, variant: kPlatformVariant);
  }

  testWidgets('portrait board adds no margin beyond horizontal safe area insets', (
    WidgetTester tester,
  ) async {
    const viewPadding = EdgeInsets.fromLTRB(6.0, 59.0, 10.0, 34.0);
    await _pumpGameLayoutWithSafeArea(tester, surface: _iPhone16Surface, viewPadding: viewPadding);

    final safeAreaRect = tester.getRect(find.byKey(_safeAreaContentKey));
    final boardRect = tester.getRect(find.byType(Chessboard));
    final playableGridRect = tester.getRect(find.byType(SolidColorChessboardBackground));

    expect(safeAreaRect.left, viewPadding.left);
    expect(safeAreaRect.right, _iPhone16Surface.width - viewPadding.right);
    _expectHorizontalInset(boardRect, safeAreaRect, 0.0);
    _expectHorizontalInset(playableGridRect, safeAreaRect, 0.0);
  }, variant: const TargetPlatformVariant({TargetPlatform.iOS}));

  testWidgets('compact portrait boards fill the safe area width', (WidgetTester tester) async {
    const compactProfiles = [
      (surface: _iPhone16ZoomedSurface, viewPadding: _iPhone16ZoomedViewPadding),
      (surface: Size(375.0, 667.0), viewPadding: EdgeInsets.only(top: 20.0)),
    ];

    for (final profile in compactProfiles) {
      await _pumpGameLayoutWithSafeArea(
        tester,
        surface: profile.surface,
        viewPadding: profile.viewPadding,
      );

      final safeAreaRect = tester.getRect(find.byKey(_safeAreaContentKey));
      final boardRect = tester.getRect(find.byType(Chessboard));
      final playableGridRect = tester.getRect(find.byType(SolidColorChessboardBackground));

      _expectHorizontalInset(boardRect, safeAreaRect, 0.0);
      expect(playableGridRect, boardRect);
    }
  }, variant: const TargetPlatformVariant({TargetPlatform.iOS}));

  testWidgets('board border insets the playable grid without shrinking the outer board', (
    WidgetTester tester,
  ) async {
    await _pumpGameLayoutWithSafeArea(
      tester,
      surface: _iPhone16Surface,
      viewPadding: _iPhone16ViewPadding,
      showBorder: true,
    );

    final safeAreaRect = tester.getRect(find.byKey(_safeAreaContentKey));
    final boardRect = tester.getRect(find.byType(Chessboard));
    final playableGridRect = tester.getRect(find.byType(SolidColorChessboardBackground));

    _expectHorizontalInset(boardRect, safeAreaRect, 0.0);
    _expectHorizontalInset(playableGridRect, boardRect, 16.0);
  }, variant: const TargetPlatformVariant({TargetPlatform.iOS}));

  testWidgets('compact crazyhouse board keeps the pocket spacing exception', (
    WidgetTester tester,
  ) async {
    await _pumpGameLayoutWithSafeArea(
      tester,
      surface: _iPhone16ZoomedSurface,
      viewPadding: _iPhone16ZoomedViewPadding,
      boardParams: const GameBoardParams.readonly(
        variant: Variant.crazyhouse,
        position: Crazyhouse.initial,
      ),
    );

    final safeAreaRect = tester.getRect(find.byKey(_safeAreaContentKey));
    final boardRect = tester.getRect(find.byType(Chessboard));

    expect(find.byType(PocketsMenu), findsNWidgets(2));
    expect(boardRect.width, lessThan(safeAreaRect.width));
    expect(boardRect.center.dx, moreOrLessEquals(safeAreaRect.center.dx));
  }, variant: const TargetPlatformVariant({TargetPlatform.iOS}));

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
              variant: Variant.standard,
              position: Chess.initial,
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
              variant: Variant.standard,
              position: Chess.initial,
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
              variant: Variant.standard,
              position: Chess.initial,
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
        double expectedBoardSize = isTablet ? surface.width - 32.0 : surface.width;

        final maxAllowedBoardSize = surface.height - 180.0;
        if (expectedBoardSize > maxAllowedBoardSize) {
          expectedBoardSize = maxAllowedBoardSize;
        }
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

  testWidgets('owned board becomes interactive when boardParams transitions from readonly', (
    WidgetTester tester,
  ) async {
    final paramsNotifier = ValueNotifier<GameBoardParams>(GameBoardParams.emptyBoard);
    addTearDown(paramsNotifier.dispose);
    final playedMoves = <Move>[];

    final app = await makeTestProviderScope(
      tester,
      child: MaterialApp(
        home: ValueListenableBuilder<GameBoardParams>(
          valueListenable: paramsNotifier,
          builder: (context, params, _) => GameLayout(orientation: Side.white, boardParams: params),
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
  }, variant: kPlatformVariant);

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
    final boardNotifier = ValueNotifier<({Position position, Move? lastMove})>((
      position: Chess.initial,
      lastMove: null,
    ));
    addTearDown(boardNotifier.dispose);

    final app = await makeTestProviderScope(
      tester,
      child: MaterialApp(
        home: ValueListenableBuilder<({Position position, Move? lastMove})>(
          valueListenable: boardNotifier,
          builder: (context, value, _) => GameLayout(
            orientation: Side.white,
            boardParams: GameBoardParams.readonly(
              variant: Variant.standard,
              position: value.position,
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
      position: after1e4,
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
