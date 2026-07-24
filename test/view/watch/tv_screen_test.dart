import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/exported_game.dart';
import 'package:lichess_mobile/src/model/tv/tv_channel.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/network/socket.dart';
import 'package:lichess_mobile/src/view/watch/tv_screen.dart';

import '../../example_data.dart';
import '../../model/game/game_socket_example_data.dart';
import '../../network/fake_http_client_factory.dart';
import '../../network/fake_websocket_channel.dart';
import '../../test_helpers.dart';
import '../../test_provider_scope.dart';

void main() {
  const gameId = GameId('qVChCOTc');
  // The TV controller opens this socket route for the initial game.
  final tvSocketUri = Uri(path: '/watch/$gameId/white/v6');

  Uri watchSocketUri(GameId id, Side orientation) =>
      Uri(path: '/watch/${id.value}/${orientation.name}/v6');

  Future<void> loadGame(
    WidgetTester tester, {
    String pgn = '',
    Uri? socketUri,
    GameId? gameId,
    ExportedGame? game,
    String whiteUserName = 'Peter',
    String blackUserName = 'Steven',
  }) async {
    final uri = socketUri ?? tvSocketUri;
    final id = gameId ?? game?.id ?? const GameId('qVChCOTc');
    await tester.pump(kFakeWebSocketConnectionLag);
    sendServerSocketMessages(uri, [
      makeFullEvent(
        id,
        pgn,
        whiteUserName: game?.white.user?.name ?? whiteUserName,
        blackUserName: game?.black.user?.name ?? blackUserName,
      ),
    ]);
    await tester.pump();
  }

  group('TvScreen (readonly GameLayout board)', () {
    testWidgets('loads the game and displays a non-interactive board', (tester) async {
      final app = await makeTestProviderScopeApp(
        tester,
        home: const TvScreen(channel: TvChannel.best, initialGame: (gameId, Side.white)),
      );
      await tester.pumpWidget(app);

      // While loading, an empty board is shown.
      expect(find.byType(Chessboard), findsOneWidget);
      expect(getBoardPieces(tester), isEmpty);

      await loadGame(tester);

      // The full position is displayed once the game loads.
      expect(getBoardPieces(tester).length, 32);
      expect(find.text('Peter'), findsOneWidget);
      expect(find.text('Steven'), findsOneWidget);

      // The TV board is a spectator board: it must not be interactive.
      expect(tester.widget<Chessboard>(find.byType(Chessboard)).interactive, isFalse);
    });

    testWidgets('updates the board when a move event is received', (tester) async {
      final app = await makeTestProviderScopeApp(
        tester,
        home: const TvScreen(channel: TvChannel.best, initialGame: (gameId, Side.white)),
      );
      await tester.pumpWidget(app);
      await loadGame(tester);

      expect(boardHasPiece(tester, Square.e2, Piece.whitePawn), isTrue);

      // Server broadcasts the first move (e2-e4).
      sendServerSocketMessages(tvSocketUri, [
        '{"t": "move", "v": 1, "d": {"ply": 1, "uci": "e2e4", "san": "e4", "clock": {"white": 180, "black": 180}}}',
      ]);
      await tester.pump();

      // The board advances to the new position and stays non-interactive.
      expect(boardHasPiece(tester, Square.e4, Piece.whitePawn), isTrue);
      expect(getBoardPieces(tester).containsKey(Square.e2), isFalse);
      expect(getBoardLastMove(tester), const NormalMove(from: Square.e2, to: Square.e4));
      expect(tester.widget<Chessboard>(find.byType(Chessboard)).interactive, isFalse);
    });

    testWidgets('navigates to the previous move with the bottom bar', (tester) async {
      final app = await makeTestProviderScopeApp(
        tester,
        home: const TvScreen(channel: TvChannel.best, initialGame: (gameId, Side.white)),
      );
      await tester.pumpWidget(app);
      await loadGame(tester);

      sendServerSocketMessages(tvSocketUri, [
        '{"t": "move", "v": 1, "d": {"ply": 1, "uci": "e2e4", "san": "e4", "clock": {"white": 180, "black": 180}}}',
      ]);
      await tester.pump();
      expect(boardHasPiece(tester, Square.e4, Piece.whitePawn), isTrue);

      // Step back one move via the bottom bar.
      await tester.tap(find.byKey(const ValueKey('goto-previous')));
      await tester.pump();

      // The board shows the position before the move again.
      expect(boardHasPiece(tester, Square.e2, Piece.whitePawn), isTrue);
      expect(getBoardPieces(tester).containsKey(Square.e4), isFalse);
      expect(tester.widget<Chessboard>(find.byType(Chessboard)).interactive, isFalse);
    });

    testWidgets('user TV advances when the watched player starts a new game', (tester) async {
      final user = LightUser(id: UserId.fromUserName('nfchess13'), name: 'NFChess13');
      final games = generateExportedGames(count: 2, username: 'nfchess13');
      Uri? userTvWatch;

      await tester.pumpWidget(
        await makeTestProviderScopeApp(
          tester,
          home: TvScreen(user: user, initialGame: (games[0].id, Side.white)),
          overrides: {
            httpClientFactoryProvider: httpClientFactoryProvider.overrideWith(
              (_) => FakeHttpClientFactory(
                () => MockClient(
                  (r) => r.url.path == '/api/user/nfchess13/current-game'
                      ? mockResponse(_currentGameJson(games[1]), 200)
                      : mockResponse('', 404),
                ),
              ),
            ),
            webSocketChannelFactoryProvider: webSocketChannelFactoryProvider.overrideWith(
              (_) => FakeWebSocketChannelFactory((uri) {
                if (uri.queryParameters.containsKey('userTv')) {
                  userTvWatch = Uri(path: uri.path);
                }
                return createDefaultFakeWebSocketChannel(uri);
              }),
            ),
          },
        ),
      );
      // load first game, opponent is called "Black"
      await loadGame(tester, socketUri: watchSocketUri(games[0].id, Side.white), game: games[0]);
      expect(find.text('Black'), findsOneWidget);
      expect(
        userTvWatch,
        isNotNull,
        reason: 'The user TV socket should have been opened when loading the first game.',
      );
      // server sends a resync event, which should trigger a request to the current-game endpoint and load the new game
      sendServerSocketMessages(userTvWatch!, ['{"t": "resync"}']);
      await tester.pump();
      await tester.pump(kFakeWebSocketConnectionLag);
      await loadGame(
        tester,
        socketUri: watchSocketUri(games[1].id, games[1].youAre!),
        game: games[1],
      );
      // new game is loaded and opponent is called "White"
      expect(find.text('Black'), findsNothing);
      expect(find.text('White'), findsOneWidget);
    });
  });
}

String _currentGameJson(ExportedGame game) {
  final white = game.white.user!;
  final black = game.black.user!;
  return '''
{"id":"${game.id.value}","rated":true,"source":"lobby","variant":"standard","speed":"blitz","perf":"blitz","createdAt":0,"lastMoveAt":0,"status":"started","players":{"white":{"user":{"name":"${white.name}","id":"${white.id}"},"rating":1500},"black":{"user":{"name":"${black.name}","id":"${black.id}"},"rating":1500}},"moves":"","clock":{"initial":120,"increment":3,"totalTime":160},"lastFen":"rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"}
''';
}
