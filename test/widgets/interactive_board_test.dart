import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/widgets/interactive_board.dart';
import '../test_helpers.dart';
import '../test_provider_scope.dart';

void main() {
  final setup = Setup.parseFen('r3k2r/8/8/8/8/8/8/R3K2R w KQkq - 0 1');
  Position<Chess> pos = Chess.fromSetup(setup);

  final gameData = GameData(
    playerSide: PlayerSide.white,
    sideToMove: Side.white,
    validMoves: makeLegalMoves(pos),
    promotionMove: null,
    onMove: (NormalMove move, {bool? isDrop}) {
      //This doesn't work because the position is not updated in the UI
      pos = pos.play(move);
    },
    onPromotionSelection: (Role? unused) {},
    premovable: null,
  );

  testWidgets(
    'Should only castle by moving the king over the rook when that preference is selected',

    (WidgetTester tester) async {
      const CastlingMethod castlingMethodToTest = CastlingMethod.kingOverRook;

      final app = await makeTestProviderScope(
        tester,
        child: InteractiveBoardWidget(
          size: kTestSurfaceSize.width,
          boardPrefs: BoardPrefs.defaults.copyWith(castlingMethod: castlingMethodToTest),
          fen: pos.fen,
          orientation: Side.white,
          gameData: gameData,
          settings: const ChessboardSettings(
            showValidMoves: true,
            colorScheme: ChessboardColorScheme.blue,
          ),
        ),
      );
      await tester.pumpWidget(app);

      await tester.tap(find.byKey(const Key('e1-whiteking')));

      await tester.pump();

      //Normal king moves
      expect(find.byKey(const Key('d1-dest')), findsOneWidget);
      expect(find.byKey(const Key('d2-dest')), findsOneWidget);
      expect(find.byKey(const Key('e2-dest')), findsOneWidget);
      expect(find.byKey(const Key('f2-dest')), findsOneWidget);
      expect(find.byKey(const Key('f1-dest')), findsOneWidget);

      //King over rook
      expect(find.byKey(const Key('a1-dest')), findsOneWidget);
      expect(find.byKey(const Key('h1-dest')), findsOneWidget);

      //King two squares
      expect(find.byKey(const Key('c1-dest')), findsNothing);
      expect(find.byKey(const Key('g1-dest')), findsNothing);
    },
  );

  testWidgets(
    'Should only castle by moving the king two squares when that preference is selected',

    (WidgetTester tester) async {
      const CastlingMethod castlingMethodToTest = CastlingMethod.kingTwoSquares;

      final app = await makeTestProviderScope(
        tester,
        child: InteractiveBoardWidget(
          size: kTestSurfaceSize.width,
          boardPrefs: BoardPrefs.defaults.copyWith(castlingMethod: castlingMethodToTest),
          fen: pos.fen,
          orientation: Side.white,
          gameData: gameData,
          settings: const ChessboardSettings(showValidMoves: true),
        ),
      );
      await tester.pumpWidget(app);

      await tester.tap(find.byKey(const Key('e1-whiteking')));

      await tester.pump();

      //Normal king moves
      expect(find.byKey(const Key('d1-dest')), findsOneWidget);
      expect(find.byKey(const Key('d2-dest')), findsOneWidget);
      expect(find.byKey(const Key('e2-dest')), findsOneWidget);
      expect(find.byKey(const Key('f2-dest')), findsOneWidget);
      expect(find.byKey(const Key('f1-dest')), findsOneWidget);

      //King over rook
      expect(find.byKey(const Key('a1-dest')), findsNothing);
      expect(find.byKey(const Key('h1-dest')), findsNothing);

      //King two squares
      expect(find.byKey(const Key('c1-dest')), findsOneWidget);
      expect(find.byKey(const Key('g1-dest')), findsOneWidget);
    },
  );

  testWidgets(
    "Should only castle by moving the king two squares or over the rook when 'either' preference is selected",

    (WidgetTester tester) async {
      const CastlingMethod castlingMethodToTest = CastlingMethod.either;

      final app = await makeTestProviderScope(
        tester,
        child: InteractiveBoardWidget(
          size: kTestSurfaceSize.width,
          boardPrefs: BoardPrefs.defaults.copyWith(castlingMethod: castlingMethodToTest),
          fen: pos.fen,
          orientation: Side.white,
          gameData: gameData,
          settings: const ChessboardSettings(showValidMoves: true),
        ),
      );
      await tester.pumpWidget(app);

      await tester.tap(find.byKey(const Key('e1-whiteking')));

      await tester.pump();

      //Normal king moves
      expect(find.byKey(const Key('d1-dest')), findsOneWidget);
      expect(find.byKey(const Key('d2-dest')), findsOneWidget);
      expect(find.byKey(const Key('e2-dest')), findsOneWidget);
      expect(find.byKey(const Key('f2-dest')), findsOneWidget);
      expect(find.byKey(const Key('f1-dest')), findsOneWidget);

      //King over rook
      expect(find.byKey(const Key('a1-dest')), findsOneWidget);
      expect(find.byKey(const Key('h1-dest')), findsOneWidget);

      //King two squares
      expect(find.byKey(const Key('c1-dest')), findsOneWidget);
      expect(find.byKey(const Key('g1-dest')), findsOneWidget);
    },
  );
}
