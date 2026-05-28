import 'dart:async';
import 'dart:convert';

import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show ProviderScope;
import 'package:flutter_riverpod/misc.dart' show Override, ProviderOrFamily;
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/account/account_preferences.dart' hide Challenge;
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/challenge/challenge.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/game.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/service/sound_service.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';
import 'package:lichess_mobile/src/model/game/game.dart';
import 'package:lichess_mobile/src/model/game/game_controller.dart';
import 'package:lichess_mobile/src/model/game/game_socket_events.dart';
import 'package:lichess_mobile/src/model/game/game_status.dart';
import 'package:lichess_mobile/src/model/lobby/create_game_service.dart';
import 'package:lichess_mobile/src/model/lobby/game_seek.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/model/settings/preferences_storage.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/network/socket.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/view/chat/chat_screen.dart';
import 'package:lichess_mobile/src/view/game/correspondence_clock_widget.dart';
import 'package:lichess_mobile/src/view/game/game_body.dart';
import 'package:lichess_mobile/src/view/game/game_player.dart';
import 'package:lichess_mobile/src/view/game/game_screen.dart';
import 'package:lichess_mobile/src/view/game/game_screen_providers.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar.dart';
import 'package:lichess_mobile/src/widgets/clock.dart';
import 'package:lichess_mobile/src/widgets/game_layout.dart';
import 'package:lichess_mobile/src/widgets/pockets.dart';
import 'package:mocktail/mocktail.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:wakelock_plus_platform_interface/messages.g.dart';

import '../../model/game/game_socket_example_data.dart';
import '../../network/fake_websocket_channel.dart';
import '../../test_helpers.dart';
import '../../test_provider_scope.dart';

final client = MockClient((request) {
  if (request.url.path == '/api/board/seek') {
    return mockResponse('ok', 200);
  } else if (request.url.path == '/game/export/CCW6EEru') {
    return mockResponse('''
{"id":"CCW6EEru","rated":true,"source":"lobby","variant":"standard","speed":"bullet","perf":"bullet","createdAt":1706185945680,"lastMoveAt":1706186170504,"status":"resign","players":{"white":{"user":{"name":"veloce","id":"veloce"},"rating":1789,"ratingDiff":9},"black":{"user":{"name":"chabrot","id":"chabrot"},"rating":1810,"ratingDiff":-9}},"winner":"white","opening":{"eco":"C52","name":"Italian Game: Evans Gambit, Main Line","ply":10},"moves":"e4 e5 Nf3 Nc6 Bc4 Bc5 b4 Bxb4 c3 Ba5 d4 Bb6 Ba3 Nf6 Qb3 d6 Bxf7+ Kf8 O-O Qe7 Nxe5 Nxe5 dxe5 Be6 Bxe6 Nxe4 Re1 Nc5 Bxc5 Bxc5 Qxb7 Re8 Bh3 dxe5 Qf3+ Kg8 Nd2 Rf8 Qd5+ Rf7 Be6 Qxe6 Qxe6","clocks":[12003,12003,11883,11811,11683,11379,11307,11163,11043,11043,10899,10707,10155,10483,10019,9995,9635,9923,8963,8603,7915,8283,7763,7459,7379,6083,6587,5819,6363,5651,6075,5507,5675,4803,5059,4515,4547,3555,3971,3411,3235,3123,3120,2742],"clock":{"initial":120,"increment":1,"totalTime":160}}
''', 200);
  } else if (request.url.path.startsWith('/api/account/preferences/')) {
    return mockResponse('ok', 200);
  }
  return mockResponse('', 404);
});

class MockSoundService extends Mock implements SoundService {}

class MockCreateGameService extends Mock implements CreateGameService {}

void main() {
  const testGameFullId = GameFullId('qVChCOTcHSeW');
  final testGameSocketUri = GameController.socketUri(testGameFullId);

  setUpAll(() {
    registerFallbackValue(Variant.standard);
    registerFallbackValue(Sound.error);
    registerFallbackValue(
      const GameSeek(clock: (Duration(minutes: 3), Duration(seconds: 2)), rated: false),
    );
    registerFallbackValue(
      const ChallengeRequest(
        variant: Variant.standard,
        timeControl: ChallengeTimeControlType.clock,
        rated: false,
        sideChoice: SideChoice.random,
      ),
    );
    registerFallbackValue(
      const Challenge(
        id: ChallengeId('challeng'),
        status: ChallengeStatus.created,
        variant: Variant.standard,
        speed: Speed.blitz,
        timeControl: ChallengeTimeControlType.clock,
        rated: false,
        sideChoice: SideChoice.random,
      ),
    );
  });

  group('Loading', () {
    testWidgets('a game directly with initialGameId', (WidgetTester tester) async {
      final app = await makeTestProviderScopeApp(
        tester,
        home: const GameScreen(source: ExistingGameSource(testGameFullId)),
        overrides: {
          lichessClientProvider: lichessClientProvider.overrideWith(
            (ref) => LichessClient(client, ref),
          ),
        },
      );
      await tester.pumpWidget(app);

      // while loading, displays an empty board
      expect(find.byType(Chessboard), findsOneWidget);
      expect(getBoardPieces(tester), isEmpty);

      final initialBoardPosition = tester.getTopLeft(find.byType(Chessboard));

      // now the game controller is loading and screen doesn't have changed yet
      await tester.pump(const Duration(milliseconds: 10));
      expect(find.byType(Chessboard), findsOneWidget);
      expect(getBoardPieces(tester), isEmpty);
      expect(
        tester.getTopLeft(find.byType(Chessboard)),
        initialBoardPosition,
        reason: 'board position should not change',
      );

      await tester.pump(kFakeWebSocketConnectionLag);

      sendServerSocketMessages(testGameSocketUri, [
        makeFullEvent(
          const GameId('qVChCOTc'),
          '',
          whiteUserName: 'Peter',
          blackUserName: 'Steven',
        ),
      ]);
      // wait for socket message handling
      await tester.pump();

      expect(getBoardPieces(tester).length, 32);
      expect(find.text('Peter'), findsOneWidget);
      expect(find.text('Steven'), findsOneWidget);
      expect(
        tester.getTopLeft(find.byType(Chessboard)),
        initialBoardPosition,
        reason: 'board position should not change',
      );
    });

    testWidgets('a game from the pool with a seek', (WidgetTester tester) async {
      final app = await makeTestProviderScopeApp(
        tester,
        home: const GameScreen(
          source: LobbySource(
            GameSeek(clock: (Duration(minutes: 3), Duration(seconds: 2)), rated: true),
          ),
        ),
        overrides: {
          lichessClientProvider: lichessClientProvider.overrideWith(
            (ref) => LichessClient(client, ref),
          ),
        },
      );
      await tester.pumpWidget(app);

      expect(find.byType(Chessboard), findsOneWidget);
      expect(getBoardPieces(tester), isEmpty);
      expect(find.text('Waiting for opponent to join...'), findsOneWidget);
      expect(find.text('3+2'), findsOneWidget);
      expect(find.widgetWithText(BottomBarButton, 'Cancel'), findsOneWidget);

      final initialBoardPosition = tester.getTopLeft(find.byType(Chessboard));

      // waiting for the game
      await tester.pump(const Duration(seconds: 2));

      // when a seek is accepted, server lobby sends a 'redirect' message with game id
      sendServerSocketMessages(Uri(path: '/lobby/socket/v5'), [
        '{"t": "redirect", "d": {"id": "qVChCOTcHSeW" }, "v": 1}',
      ]);
      // wait for socket message handling
      await tester.pump(const Duration(milliseconds: 1));

      // now the game controller is loading
      expect(find.byType(Chessboard), findsOneWidget);
      expect(getBoardPieces(tester), isEmpty);
      expect(find.text('Waiting for opponent to join...'), findsNothing);
      expect(find.text('3+2'), findsNothing);
      expect(find.widgetWithText(BottomBarButton, 'Cancel'), findsNothing);
      expect(
        tester.getTopLeft(find.byType(Chessboard)),
        initialBoardPosition,
        reason: 'board position should not change',
      );

      // wait for game socket to connect
      await tester.pump(kFakeWebSocketConnectionLag);

      sendServerSocketMessages(GameController.socketUri(testGameFullId), [
        makeFullEvent(
          const GameId('qVChCOTc'),
          '',
          whiteUserName: 'Peter',
          blackUserName: 'Steven',
        ),
      ]);
      // wait for socket message handling
      await tester.pump();

      expect(getBoardPieces(tester).length, 32);
      expect(find.text('Peter'), findsOneWidget);
      expect(find.text('Steven'), findsOneWidget);
      expect(find.text('Waiting for opponent to join...'), findsNothing);
      expect(find.text('3+2'), findsNothing);
      expect(
        tester.getTopLeft(find.byType(Chessboard)),
        initialBoardPosition,
        reason: 'board position should not change',
      );
    });

    for (final authUser in [
      null,
      AuthUser(
        user: LightUser(id: UserId.fromUserName('John'), name: 'John'),
        token: 'test-token',
      ),
    ]) {
      testWidgets('displays game link for open challenge, logged in: ${authUser != null}', (
        WidgetTester tester,
      ) async {
        const challengeRequest = ChallengeRequest(
          destUser: null,
          variant: Variant.standard,
          timeControl: ChallengeTimeControlType.clock,
          rated: true,
          sideChoice: SideChoice.white,
        );
        final challenge = Challenge(
          sideChoice: challengeRequest.sideChoice,
          id: const ChallengeId('challengeId'),
          variant: challengeRequest.variant,
          timeControl: challengeRequest.timeControl,
          rated: challengeRequest.rated,
          speed: Speed.blitz,
          status: ChallengeStatus.created,
        );

        final createGameService = MockCreateGameService();
        when(
          () => createGameService.newOpenOrRealTimeChallenge(challengeRequest),
        ).thenAnswer((_) async => challenge);
        when(
          () => createGameService.waitForChallengeResponse(challenge),
        ).thenAnswer((_) => Completer<ChallengeResponse>().future);

        final app = await makeTestProviderScopeApp(
          tester,
          home: const GameScreen(source: UserChallengeSource(challengeRequest)),
          authUser: authUser,
          overrides: {
            createGameServiceProvider: createGameServiceProvider.overrideWith(
              (_) => createGameService,
            ),
          },
        );
        await tester.pumpWidget(app);

        await tester.pumpAndSettle();

        expect(find.byType(Chessboard), findsOneWidget);
        expect(getBoardPieces(tester), isEmpty);
        expect(find.text('To invite someone to play, give this URL'), findsOneWidget);
        expect(find.text('Or let your opponent scan this QR code'), findsOneWidget);
        expect(find.byType(QrImageView), findsOneWidget);
        expect(find.textContaining('https://$kLichessHost/${challenge.id.value}'), findsOneWidget);
        expect(
          find.text('Or invite a Lichess user'),
          authUser == null ? findsNothing : findsOneWidget,
        );
      });
    }
  });

  group('Reconnecting title', () {
    testWidgets('shows Reconnecting when socket has no ping response during a real-time game', (
      WidgetTester tester,
    ) async {
      final noPongFactory = ListenableFakeWebSocketChannelFactory((route) {
        final channel = createDefaultFakeWebSocketChannel(route);
        channel.shouldSendPong = false;
        return channel;
      });

      await createTestGame(tester, socketFactory: noPongFactory);
      // Wait for _isRealTimePlayableGameProvider to resolve so monitorSocket becomes true.
      await tester.pump();

      // averageLag stays at Duration.zero (no pong ever received), so rating == 0.
      expect(find.text('Reconnecting'), findsOneWidget);
    });

    testWidgets('shows normal game title when socket ping is established', (
      WidgetTester tester,
    ) async {
      await createTestGame(tester);
      // Wait for _isRealTimePlayableGameProvider to resolve.
      await tester.pump();

      // createTestGame pumps 10ms, during which the immediate pong is received
      // (connectionLag = 5ms), so averageLag > 0 and rating > 0.
      expect(find.text('Reconnecting'), findsNothing);
    });
  });

  group('AppBar title', () {
    testWidgets('active real-time game shows time control and mode', (WidgetTester tester) async {
      await createTestGame(tester);
      // Wait for _isRealTimePlayableGameProvider to resolve.
      await tester.pump();

      expect(find.text('3+2 • Casual'), findsOneWidget);
    });

    testWidgets('lobby loading shows seek time control and mode', (WidgetTester tester) async {
      const seek = GameSeek(clock: (Duration(minutes: 3), Duration(seconds: 2)), rated: true);
      final createGameService = MockCreateGameService();
      when(
        () => createGameService.newLobbyGame(any()),
      ).thenAnswer((_) => Completer<GameSeekResponse>().future);

      final app = await makeTestProviderScopeApp(
        tester,
        home: const GameScreen(source: LobbySource(seek)),
        overrides: {
          createGameServiceProvider: createGameServiceProvider.overrideWith(
            (_) => createGameService,
          ),
        },
      );
      await tester.pumpWidget(app);
      await tester.pump(kFakeWebSocketConnectionLag);
      await tester.pump();

      expect(find.text('3+2 • Rated'), findsOneWidget);
    });

    testWidgets('seek cancelled shows seek time control and mode', (WidgetTester tester) async {
      const seek = GameSeek(clock: (Duration(minutes: 3), Duration(seconds: 2)), rated: true);
      final createGameService = MockCreateGameService();
      when(
        () => createGameService.newLobbyGame(any()),
      ).thenAnswer((_) async => const GameSeekCancelled());

      final app = await makeTestProviderScopeApp(
        tester,
        home: const GameScreen(source: LobbySource(seek)),
        overrides: {
          createGameServiceProvider: createGameServiceProvider.overrideWith(
            (_) => createGameService,
          ),
        },
      );
      await tester.pumpWidget(app);
      await tester.pump();

      expect(find.text('3+2 • Rated'), findsOneWidget);
    });

    testWidgets('challenge loading with destUser shows challenge time control and mode', (
      WidgetTester tester,
    ) async {
      final challengeRequest = ChallengeRequest(
        destUser: LightUser(id: UserId.fromUserName('bob'), name: 'Bob'),
        variant: Variant.standard,
        timeControl: ChallengeTimeControlType.clock,
        clock: (time: const Duration(minutes: 3), increment: const Duration(seconds: 2)),
        rated: true,
        sideChoice: .random,
      );
      final createGameService = MockCreateGameService();
      when(
        () => createGameService.newOpenOrRealTimeChallenge(any()),
      ).thenAnswer((_) => Completer<Challenge>().future);

      final app = await makeTestProviderScopeApp(
        tester,
        home: GameScreen(source: UserChallengeSource(challengeRequest)),
        overrides: {
          createGameServiceProvider: createGameServiceProvider.overrideWith(
            (_) => createGameService,
          ),
        },
      );
      await tester.pumpWidget(app);
      await tester.pump(kFakeWebSocketConnectionLag);
      await tester.pump();

      expect(find.text('3+2 • Rated'), findsOneWidget);
    });

    testWidgets('challenge cancelled shows challenge time control and mode', (
      WidgetTester tester,
    ) async {
      final challengeRequest = ChallengeRequest(
        destUser: LightUser(id: UserId.fromUserName('bob'), name: 'Bob'),
        variant: Variant.standard,
        timeControl: ChallengeTimeControlType.clock,
        clock: (time: const Duration(minutes: 3), increment: const Duration(seconds: 2)),
        rated: true,
        sideChoice: .random,
      );
      final challenge = Challenge(
        id: const ChallengeId('challeng'),
        status: ChallengeStatus.canceled,
        variant: Variant.standard,
        speed: Speed.blitz,
        timeControl: ChallengeTimeControlType.clock,
        clock: (time: const Duration(minutes: 3), increment: const Duration(seconds: 2)),
        rated: true,
        sideChoice: .random,
        destUser: (
          user: LightUser(id: UserId.fromUserName('bob'), name: 'Bob'),
          rating: null,
          provisionalRating: null,
          lagRating: null,
        ),
      );
      final createGameService = MockCreateGameService();
      when(
        () => createGameService.newOpenOrRealTimeChallenge(any()),
      ).thenAnswer((_) async => challenge);
      when(
        () => createGameService.waitForChallengeResponse(any()),
      ).thenAnswer((_) async => const ChallengeResponseCancelled());

      final app = await makeTestProviderScopeApp(
        tester,
        home: GameScreen(source: UserChallengeSource(challengeRequest)),
        overrides: {
          createGameServiceProvider: createGameServiceProvider.overrideWith(
            (_) => createGameService,
          ),
        },
      );
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      expect(find.text('3+2 • Rated'), findsOneWidget);
    });

    testWidgets('challenge declined shows challenge time control and mode', (
      WidgetTester tester,
    ) async {
      final challengeRequest = ChallengeRequest(
        destUser: LightUser(id: UserId.fromUserName('bob'), name: 'Bob'),
        variant: Variant.standard,
        timeControl: ChallengeTimeControlType.clock,
        clock: (time: const Duration(minutes: 3), increment: const Duration(seconds: 2)),
        rated: true,
        sideChoice: .random,
      );
      final challenge = Challenge(
        id: const ChallengeId('challeng'),
        status: ChallengeStatus.declined,
        variant: Variant.standard,
        speed: Speed.blitz,
        timeControl: ChallengeTimeControlType.clock,
        clock: (time: const Duration(minutes: 3), increment: const Duration(seconds: 2)),
        rated: true,
        sideChoice: .random,
        destUser: (
          user: LightUser(id: UserId.fromUserName('bob'), name: 'Bob'),
          rating: null,
          provisionalRating: null,
          lagRating: null,
        ),
      );
      final createGameService = MockCreateGameService();
      when(
        () => createGameService.newOpenOrRealTimeChallenge(any()),
      ).thenAnswer((_) async => challenge);
      when(() => createGameService.waitForChallengeResponse(any())).thenAnswer(
        (_) async => ChallengeResponseDeclined(challenge: challenge, declineReason: null),
      );

      final app = await makeTestProviderScopeApp(
        tester,
        home: GameScreen(source: UserChallengeSource(challengeRequest)),
        overrides: {
          createGameServiceProvider: createGameServiceProvider.overrideWith(
            (_) => createGameService,
          ),
        },
      );
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      expect(find.text('3+2 • Rated'), findsOneWidget);
    });

    testWidgets('open challenge shows challenge time control and mode', (
      WidgetTester tester,
    ) async {
      const challengeRequest = ChallengeRequest(
        variant: Variant.standard,
        timeControl: ChallengeTimeControlType.clock,
        clock: (time: Duration(minutes: 3), increment: Duration(seconds: 2)),
        rated: true,
        sideChoice: .random,
      );
      const challenge = Challenge(
        id: ChallengeId('challeng'),
        status: ChallengeStatus.created,
        variant: Variant.standard,
        speed: Speed.blitz,
        timeControl: ChallengeTimeControlType.clock,
        clock: (time: Duration(minutes: 3), increment: Duration(seconds: 2)),
        rated: true,
        sideChoice: .random,
      );
      final createGameService = MockCreateGameService();
      when(
        () => createGameService.newOpenOrRealTimeChallenge(any()),
      ).thenAnswer((_) async => challenge);
      when(
        () => createGameService.waitForChallengeResponse(any()),
      ).thenAnswer((_) => Completer<ChallengeResponse>().future);

      final app = await makeTestProviderScopeApp(
        tester,
        home: const GameScreen(source: UserChallengeSource(challengeRequest)),
        overrides: {
          createGameServiceProvider: createGameServiceProvider.overrideWith(
            (_) => createGameService,
          ),
        },
      );
      await tester.pumpWidget(app);
      await tester.pump(); // challenge created, state = OpenChallengeCreatedState
      await tester.pump(kFakeWebSocketConnectionLag); // wait for socket pong
      await tester.pump();

      expect(find.text('3+2 • Rated'), findsOneWidget);
    });

    testWidgets('finished game shows time control and mode', (WidgetTester tester) async {
      await loadFinishedTestGame(tester);
      // Pump 500ms to let the game-over popup timer fire and resolve _gameMetaProvider.
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('2+1 • Rated'), findsOneWidget);
    });
  });

  group('Plays sound for', () {
    testWidgets('move', (WidgetTester tester) async {
      final mockSoundService = MockSoundService();
      when(() => mockSoundService.play(any())).thenAnswer((_) async {});

      await createTestGame(
        tester,
        pgn: 'e4 e5',
        overrides: {
          soundServiceProvider: soundServiceProvider.overrideWith((_) => mockSoundService),
        },
      );

      await playMove(tester, 'd2', 'd4');
      await tester.pumpAndSettle();

      verify(() => mockSoundService.play(Sound.move));
    });

    testWidgets('captures', (WidgetTester tester) async {
      final mockSoundService = MockSoundService();
      when(() => mockSoundService.playCaptureSound(any())).thenAnswer((_) async {});

      await createTestGame(
        tester,
        pgn: 'e4 d5',
        overrides: {
          soundServiceProvider: soundServiceProvider.overrideWith((_) => mockSoundService),
        },
      );

      await playMove(tester, 'e4', 'd5');

      verify(() => mockSoundService.playCaptureSound(Variant.standard));
    });
  });

  group('Game actions', () {
    testWidgets('promotion with move confirmation closes promotion picker after piece selection', (
      WidgetTester tester,
    ) async {
      // White pawn on e7 ready to promote (king on g8 avoids pawn attack on d8/f8)
      await createTestGame(
        tester,
        variant: Variant.fromPosition,
        initialFen: '6k1/4P3/8/8/8/8/8/4K3 w - - 0 1',
        serverPrefs: const ServerGamePrefs(
          showRatings: true,
          enablePremove: true,
          autoQueen: AutoQueen.never,
          confirmResign: true,
          submitMove: true,
          zenMode: Zen.no,
        ),
      );

      expect(find.byType(Chessboard), findsOneWidget);

      await playMove(tester, 'e7', 'e8');

      final container = ProviderScope.containerOf(tester.element(find.byType(GameScreen)));
      final ctrlProvider = gameControllerProvider(const GameFullId('qVChCOTcHSeW'));

      expect(container.read(ctrlProvider).requireValue.moveToConfirm, isNull);

      final boardRect = tester.getRect(find.byType(Chessboard));
      await tester.tapAt(squareOffset(Square.fromName('e8'), boardRect));
      await tester.pump();

      expect(container.read(ctrlProvider).requireValue.moveToConfirm, isNotNull);
    });

    testWidgets('move confirmation', (WidgetTester tester) async {
      await createTestGame(
        tester,
        pgn: 'e4 e5',
        clock: const (
          running: true,
          initial: Duration(minutes: 1),
          increment: Duration.zero,
          white: Duration(seconds: 58),
          black: Duration(seconds: 54),
          emerg: Duration(seconds: 10),
        ),
        serverPrefs: const ServerGamePrefs(
          showRatings: true,
          enablePremove: true,
          autoQueen: AutoQueen.always,
          confirmResign: true,
          submitMove: true,
          zenMode: Zen.no,
        ),
      );
      expect(find.byType(Chessboard), findsOneWidget);
      expect(getBoardPieces(tester).length, 32);

      await playMove(tester, 'g1', 'f3');

      // see confirmation dialog
      expect(find.text('Confirm move'), findsOneWidget);
      // move is shown on board
      expect(boardHasPiece(tester, Square.f3, Piece.whiteKnight), isTrue);
      // move is not yet played so it doesn't appear in the move list
      expect(find.text('Nf3'), findsNothing);

      // confirm the move
      await tester.tap(find.byIcon(CupertinoIcons.checkmark_rectangle_fill));
      await tester.pump();

      // move still shown on board
      expect(boardHasPiece(tester, Square.f3, Piece.whiteKnight), isTrue);
      // move appears in move list
      expect(find.text('Nf3'), findsOneWidget);
    });

    group('Premoves', () {
      testWidgets('premove is applied after opponent move', (WidgetTester tester) async {
        const gameFullId = GameFullId('qVChCOTcHSeW');
        final gameSocketUri = GameController.socketUri(gameFullId);

        // After e4 it's black's turn, white can premove
        await createTestGame(
          tester,
          pgn: 'e4',
          clock: const (
            running: true,
            initial: Duration(minutes: 1),
            increment: Duration.zero,
            white: Duration(seconds: 58),
            black: Duration(seconds: 58),
            emerg: Duration(seconds: 10),
          ),
          serverPrefs: const ServerGamePrefs(
            showRatings: true,
            enablePremove: true,
            autoQueen: .always,
            confirmResign: true,
            submitMove: false,
            zenMode: .no,
          ),
        );

        expect(find.byType(Chessboard), findsOneWidget);

        // white premoves d2-d4
        await playMove(tester, 'd2', 'd4');

        // premove indicator should be visible
        expect(boardHasPremove(tester, const NormalMove(from: Square.d2, to: Square.d4)), isTrue);

        // opponent plays e7-e5 (ply 2)
        sendServerSocketMessages(gameSocketUri, [
          '{"t": "move", "v": 1, "d": {"ply": 2, "uci": "e7e5", "san": "e5", "clock": {"white": 58, "black": 56}}}',
        ]);
        await tester.pump();

        // let the premove microtask run
        await tester.pump(const Duration(milliseconds: 1));
        // let the board rebuild from userMove
        await tester.pump();

        // premove should have been played
        expect(boardHasPremove(tester, const NormalMove(from: Square.d2, to: Square.d4)), isFalse);
        expect(boardHasPiece(tester, Square.d4, Piece.whitePawn), isTrue);
      });

      testWidgets('illegal premove is cancelled after opponent move with move confirmation', (
        WidgetTester tester,
      ) async {
        const gameFullId = GameFullId('qVChCOTcHSeW');
        final gameSocketUri = GameController.socketUri(gameFullId);

        await createTestGame(
          tester,
          pgn: 'e4 e5',
          clock: const (
            running: true,
            initial: Duration(minutes: 1),
            increment: Duration.zero,
            white: Duration(seconds: 58),
            black: Duration(seconds: 54),
            emerg: Duration(seconds: 10),
          ),
          serverPrefs: const ServerGamePrefs(
            showRatings: true,
            enablePremove: true,
            autoQueen: .always,
            confirmResign: true,
            submitMove: true,
            zenMode: .no,
          ),
        );
        expect(find.byType(Chessboard), findsOneWidget);
        expect(getBoardPieces(tester).length, 32);

        // white plays d4 with confirmation
        await playMove(tester, 'd2', 'd4');
        expect(find.text('Confirm move'), findsOneWidget);
        expect(boardHasPiece(tester, Square.d4, Piece.whitePawn), isTrue);

        // white premoves d4-d5 (push the d-pawn, anticipating d5 stays free)
        await playMove(tester, 'd4', 'd5');
        await tester.pump();

        // premove indicators should be visible
        expect(boardHasPremove(tester, const NormalMove(from: Square.d4, to: Square.d5)), isTrue);

        // confirm the move
        await tester.tap(find.byIcon(CupertinoIcons.checkmark_rectangle_fill));
        await tester.pump();

        // premove indicators should still be visible after confirmation
        expect(boardHasPremove(tester, const NormalMove(from: Square.d4, to: Square.d5)), isTrue);

        // server acknowledges white's d4 move (ply 3)
        sendServerSocketMessages(gameSocketUri, [
          '{"t": "move", "v": 1, "d": {"ply": 3, "uci": "d2d4", "san": "d4", "clock": {"white": 57, "black": 54}}}',
        ]);
        await tester.pump();

        // opponent plays d7-d5 (ply 4), blocking the premove
        sendServerSocketMessages(gameSocketUri, [
          '{"t": "move", "v": 2, "d": {"ply": 4, "uci": "d7d5", "san": "d5", "clock": {"white": 57, "black": 52}}}',
        ]);
        await tester.pump();

        // let the premove microtask run
        await tester.pump(const Duration(milliseconds: 1));

        // premove should be cancelled since d4-d5 is now illegal (d5 is occupied)
        expect(boardHasPremove(tester, const NormalMove(from: Square.d4, to: Square.d5)), isFalse);

        // d5 should have black's pawn (opponent's move was applied)
        expect(boardHasPiece(tester, Square.d5, Piece.blackPawn), isTrue);
        // d4 should still have white's pawn
        expect(boardHasPiece(tester, Square.d4, Piece.whitePawn), isTrue);
      });

      testWidgets('can premove drop moves in Crazyhouse', (WidgetTester tester) async {
        const gameFullId = GameFullId('qVChCOTcHSeW');
        final gameSocketUri = GameController.socketUri(gameFullId);

        await createTestGame(
          tester,
          pgn: 'e4 d5 exd5',
          variant: Variant.crazyhouse,
          clock: const (
            running: true,
            initial: Duration(minutes: 1),
            increment: Duration.zero,
            white: Duration(seconds: 58),
            black: Duration(seconds: 54),
            emerg: Duration(seconds: 10),
          ),
          serverPrefs: const ServerGamePrefs(
            showRatings: true,
            enablePremove: true,
            autoQueen: .always,
            confirmResign: true,
            submitMove: false,
            zenMode: .no,
          ),
        );

        await playDropMove(tester, Side.white, Role.pawn, 'a4');

        // premove indicator should be visible
        expect(boardHasPremove(tester, const DropMove(to: Square.a4, role: Role.pawn)), isTrue);

        // opponent plays Qxd5
        sendServerSocketMessages(gameSocketUri, [
          '{"t": "move", "v": 1, "d": {"ply": 4, "uci": "d8d5", "san": "Qxd5", "clock": {"white": 57, "black": 52}}}',
        ]);
        await tester.pump();

        // let the premove microtask run
        await tester.pump(const Duration(milliseconds: 1));
        // let the board rebuild from userMove
        await tester.pump();

        // premove should have been played
        expect(boardHasPremove(tester, const DropMove(to: Square.a4, role: Role.pawn)), isFalse);
        expect(boardHasPiece(tester, Square.a4, Piece.whitePawn), isTrue);
      });

      testWidgets('premove is cleared, not played, after a takeback', (WidgetTester tester) async {
        const gameFullId = GameFullId('qVChCOTcHSeW');
        final gameSocketUri = GameController.socketUri(gameFullId);

        // After e4 it's black's turn, white can premove.
        await createTestGame(
          tester,
          pgn: 'e4',
          clock: const (
            running: true,
            initial: Duration(minutes: 1),
            increment: Duration.zero,
            white: Duration(seconds: 58),
            black: Duration(seconds: 58),
            emerg: Duration(seconds: 10),
          ),
          serverPrefs: const ServerGamePrefs(
            showRatings: true,
            enablePremove: true,
            autoQueen: .always,
            confirmResign: true,
            submitMove: false,
            zenMode: .no,
          ),
        );

        // white premoves d2-d4
        await playMove(tester, 'd2', 'd4');
        expect(boardHasPremove(tester, const NormalMove(from: Square.d2, to: Square.d4)), isTrue);

        // A takeback rolls e4 back: the socket reconnects and the server resends
        // the game state at the starting position — where d2-d4 would be legal.
        sendServerSocketMessages(gameSocketUri, [
          makeFullEvent(
            const GameId('qVChCOTc'),
            '',
            whiteUserName: 'Peter',
            blackUserName: 'Steven',
            youAre: Side.white,
            socketVersion: 1,
            clock: const (
              running: true,
              initial: Duration(minutes: 1),
              increment: Duration.zero,
              white: Duration(seconds: 58),
              black: Duration(seconds: 58),
              emerg: Duration(seconds: 10),
            ),
            serverPrefs: const ServerGamePrefs(
              showRatings: true,
              enablePremove: true,
              autoQueen: .always,
              confirmResign: true,
              submitMove: false,
              zenMode: .no,
            ),
          ),
        ]);
        await tester.pump();
        // give any (incorrectly) scheduled premove microtask a chance to run
        await tester.pump(const Duration(milliseconds: 1));
        await tester.pump();

        // the premove must NOT have been played
        expect(boardHasPiece(tester, Square.d4, Piece.whitePawn), isFalse);
        // the board is back to the starting position
        expect(boardHasPiece(tester, Square.d2, Piece.whitePawn), isTrue);
        expect(boardHasPiece(tester, Square.e2, Piece.whitePawn), isTrue);
        expect(boardHasPiece(tester, Square.e4, Piece.whitePawn), isFalse);
        expect(getBoardPieces(tester).length, 32);
      });

      testWidgets('premove is played after reconnect when the opponent has moved', (
        WidgetTester tester,
      ) async {
        const gameFullId = GameFullId('qVChCOTcHSeW');
        final gameSocketUri = GameController.socketUri(gameFullId);

        // After e4 it's black's turn, white can premove.
        await createTestGame(
          tester,
          pgn: 'e4',
          clock: const (
            running: true,
            initial: Duration(minutes: 1),
            increment: Duration.zero,
            white: Duration(seconds: 58),
            black: Duration(seconds: 58),
            emerg: Duration(seconds: 10),
          ),
          serverPrefs: const ServerGamePrefs(
            showRatings: true,
            enablePremove: true,
            autoQueen: .always,
            confirmResign: true,
            submitMove: false,
            zenMode: .no,
          ),
        );

        // white premoves d2-d4
        await playMove(tester, 'd2', 'd4');
        expect(boardHasPremove(tester, const NormalMove(from: Square.d2, to: Square.d4)), isTrue);

        // The socket reconnects and the server resends the game state with the
        // opponent's reply already played (e7-e5). The line has grown, so the
        // queued premove should now be played.
        sendServerSocketMessages(gameSocketUri, [
          makeFullEvent(
            const GameId('qVChCOTc'),
            'e4 e5',
            whiteUserName: 'Peter',
            blackUserName: 'Steven',
            youAre: Side.white,
            socketVersion: 1,
            clock: const (
              running: true,
              initial: Duration(minutes: 1),
              increment: Duration.zero,
              white: Duration(seconds: 58),
              black: Duration(seconds: 56),
              emerg: Duration(seconds: 10),
            ),
            serverPrefs: const ServerGamePrefs(
              showRatings: true,
              enablePremove: true,
              autoQueen: .always,
              confirmResign: true,
              submitMove: false,
              zenMode: .no,
            ),
          ),
        ]);
        await tester.pump();
        // let the premove microtask run, then the board rebuild from userMove
        await tester.pump(const Duration(milliseconds: 1));
        await tester.pump();

        // the premove has been played
        expect(boardHasPremove(tester, const NormalMove(from: Square.d2, to: Square.d4)), isFalse);
        expect(boardHasPiece(tester, Square.d4, Piece.whitePawn), isTrue);
        // the opponent's move is on the board
        expect(boardHasPiece(tester, Square.e5, Piece.blackPawn), isTrue);
        expect(boardHasPiece(tester, Square.d2, Piece.whitePawn), isFalse);
      });
    });

    testWidgets('takeback', (WidgetTester tester) async {
      await createTestGame(
        tester,
        pgn: 'e4 e5 Nf3',
        clock: const (
          running: true,
          initial: Duration(minutes: 1),
          increment: Duration.zero,
          white: Duration(seconds: 58),
          black: Duration(seconds: 54),
          emerg: Duration(seconds: 10),
        ),
      );
      expect(find.byType(Chessboard), findsOneWidget);
      expect(getBoardPieces(tester).length, 32);

      // black plays
      sendServerSocketMessages(testGameSocketUri, [
        '{"t": "move", "v": 1, "d": {"ply": 4, "uci": "b8c6", "san": "Nc6", "clock": {"white": 58, "black": 52}}}',
      ]);
      await tester.pump(const Duration(milliseconds: 500));
      expect(boardHasPiece(tester, Square.c6, Piece.blackKnight), isTrue);
      expect(
        tester.widgetList<Clock>(find.byType(Clock)).last.active,
        true,
        reason: 'white clock is active',
      );
      // white clock ticking
      await tester.pump(const Duration(seconds: 1));
      expect(findClockWithTime(Side.white, '0:56'), findsOneWidget);
      await tester.pump(const Duration(seconds: 1));
      expect(findClockWithTime(Side.white, '0:55'), findsOneWidget);

      // black asks for takeback
      sendServerSocketMessages(testGameSocketUri, [
        '{"t":"takebackOffers","v":2,"d":{"black":true}}',
      ]);
      await tester.pump(const Duration(milliseconds: 1));

      // see takeback button
      expect(find.byIcon(CupertinoIcons.arrowshape_turn_up_left), findsOneWidget);
      await tester.tap(find.byIcon(CupertinoIcons.arrowshape_turn_up_left));
      // wait for the popup to show (cannot use pumpAndSettle because of clocks)
      await tester.pump(const Duration(milliseconds: 100));
      await tester.tap(find.text('Accept'));
      await tester.pump(const Duration(milliseconds: 10));
      // server acknowledges the takeback and ask client to reload
      sendServerSocketMessages(testGameSocketUri, ['{"v": 3}', '{"t":"reload","v":4,"d":null}']);
      // wait for client to reconnect
      await tester.pump(const Duration(milliseconds: 1));
      // socket will reconnect, wait for connection
      await tester.pump(kFakeWebSocketConnectionLag);
      // server sends 'full' event immediately after reconnect
      sendServerSocketMessages(testGameSocketUri, [
        makeFullEvent(
          const GameId('qVChCOTc'),
          'e4 e5 Nf3',
          whiteUserName: 'Peter',
          blackUserName: 'Steven',
          youAre: Side.white,
          socketVersion: 5,
          clock: (
            running: true,
            initial: const Duration(minutes: 1),
            increment: Duration.zero,
            white: const Duration(seconds: 55),
            black: const Duration(seconds: 53),
            emerg: const Duration(seconds: 10),
          ),
        ),
      ]);
      await tester.pump(const Duration(milliseconds: 1));

      // black move is cancelled
      expect(boardHasPiece(tester, Square.c6, Piece.blackKnight), isFalse);
      expect(boardHasPiece(tester, Square.b8, Piece.blackKnight), isTrue);
      expect(tester.widget<Clock>(findClock(Side.black)).active, true);
      expect(tester.widget<Clock>(findClock(Side.white)).active, false);
      // black clock is ticking
      await tester.pump(const Duration(seconds: 1));
      expect(findClockWithTime(Side.black, '0:52'), findsOneWidget);
      expect(findClockWithTime(Side.white, '0:55'), findsOneWidget);
      await tester.pump(const Duration(seconds: 1));
      expect(findClockWithTime(Side.black, '0:51'), findsOneWidget);
      expect(findClockWithTime(Side.white, '0:55'), findsOneWidget);
    });
  });

  group('Castling', () {
    const String castlingSetupPgn = 'e4 e5 Nf3 Nf6 Bc4 Bc5 d3 d6 Bd2 Bd7 Nc3 Nc6 Qe2 Qe7';

    for (final castlingMethod in CastlingMethod.values) {
      testWidgets('respect castling preference ($castlingMethod)', (tester) async {
        await createTestGame(
          pgn: castlingSetupPgn,
          defaultPreferences: {
            PrefCategory.board.storageKey: jsonEncode(
              BoardPrefs.defaults.copyWith(castlingMethod: castlingMethod).toJson(),
            ),
          },
          tester,
        );

        expect(boardHasPiece(tester, Square.e1, Piece.whiteKing), isTrue);

        final boardRect = tester.getRect(find.byType(Chessboard));
        await tester.tapAt(squareOffset(Square.e1, boardRect));
        await tester.pump();

        final validMoves = getBoardValidMoves(tester);
        switch (castlingMethod) {
          case CastlingMethod.kingOverRook:
            // kingOverRook acts as either kingTwoSquares or kingOverRook
            expect(validMoves.contains(Square.f1), isTrue);
            expect(validMoves.contains(Square.g1), isTrue);
            expect(validMoves.contains(Square.h1), isTrue);
            expect(validMoves.contains(Square.c1), isTrue);
            expect(validMoves.contains(Square.d1), isTrue);
            expect(validMoves.contains(Square.a1), isTrue);
          case CastlingMethod.kingTwoSquares:
            expect(validMoves.contains(Square.f1), isTrue);
            expect(validMoves.contains(Square.g1), isTrue);
            expect(validMoves.contains(Square.h1), isFalse);
            expect(validMoves.contains(Square.c1), isTrue);
            expect(validMoves.contains(Square.d1), isTrue);
            expect(validMoves.contains(Square.a1), isFalse);
        }
      });
    }

    for (final castlingMethod in CastlingMethod.values) {
      testWidgets('chess960: $castlingMethod', (tester) async {
        await createTestGame(
          pgn: castlingSetupPgn,
          variant: Variant.chess960,
          initialFen: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1',
          defaultPreferences: {
            PrefCategory.board.storageKey: jsonEncode(
              BoardPrefs.defaults.copyWith(castlingMethod: castlingMethod).toJson(),
            ),
          },
          tester,
        );

        final boardRect = tester.getRect(find.byType(Chessboard));
        await tester.tapAt(squareOffset(Square.e1, boardRect));

        await tester.pump();

        // in chess960, castling is only king over rook, no matter the preference
        final validMoves = getBoardValidMoves(tester);
        expect(validMoves.contains(Square.f1), isTrue);
        expect(validMoves.contains(Square.g1), isFalse);
        expect(validMoves.contains(Square.h1), isTrue);
        expect(validMoves.contains(Square.c1), isFalse);
        expect(validMoves.contains(Square.d1), isTrue);
        expect(validMoves.contains(Square.a1), isTrue);
      });
    }
  });

  group('Tournament Game', () {
    final tournamentGameEvent = makeFullEvent(
      const GameId('qVChCOTc'),
      '',
      whiteUserName: 'Peter',
      blackUserName: 'Steven',
      youAre: Side.white,
      tournament: TournamentMeta(
        id: const TournamentId('id'),
        name: 'Test Tournament',
        clock: (timeLeft: const Duration(minutes: 10), at: DateTime.now()),
        berserkable: true,
        ranks: (white: 42, black: 24),
      ),
    );
    testWidgets('displays tournament info', (WidgetTester tester) async {
      final app = await makeTestProviderScopeApp(
        tester,
        home: const GameScreen(source: ExistingGameSource(GameFullId('qVChCOTcHSeW'))),
        overrides: {
          lichessClientProvider: lichessClientProvider.overrideWith(
            (ref) => LichessClient(client, ref),
          ),
        },
      );
      await tester.pumpWidget(app);
      // Wait for game screen to load
      await tester.pump(const Duration(milliseconds: 10));

      sendServerSocketMessages(GameController.socketUri(testGameFullId), [tournamentGameEvent]);
      // wait for socket message handling
      await tester.pump();

      // Should display tournament info
      expect(find.text('Peter'), findsOneWidget);
      expect(find.text('Steven'), findsOneWidget);
      expect(find.text('Test Tournament'), findsOneWidget);
      expect(find.textContaining('#42'), findsOneWidget);
      expect(find.textContaining('#24'), findsOneWidget);
    });

    testWidgets('supports berserking', (WidgetTester tester) async {
      final app = await makeTestProviderScopeApp(
        tester,
        home: const GameScreen(source: ExistingGameSource(GameFullId('qVChCOTcHSeW'))),
        overrides: {
          lichessClientProvider: lichessClientProvider.overrideWith(
            (ref) => LichessClient(client, ref),
          ),
        },
      );
      await tester.pumpWidget(app);
      // Wait for game screen to load
      await tester.pump(const Duration(milliseconds: 10));

      sendServerSocketMessages(GameController.socketUri(testGameFullId), [tournamentGameEvent]);
      // wait for socket message handling
      await tester.pump();

      // Nobody has berserked yet.
      // The widget we're finding is our own berserk button.
      expect(find.byIcon(LichessIcons.body_cut), findsOneWidget);

      // we berserk
      await tester.tap(find.byIcon(LichessIcons.body_cut));
      await tester.pump(const Duration(milliseconds: 10));

      // No server response yet, so should not yet show the berserk icon next to our name.
      expect(find.byIcon(LichessIcons.body_cut), findsOneWidget);

      sendServerSocketMessages(GameController.socketUri(testGameFullId), [
        '''{"t": "berserk", "d": "white"}''',
      ]);
      // wait for socket message handling
      await tester.pump();

      // We have berserked, which caused the berserk icon appear next to our name.
      // Also, the berserk button is still there (but disabled).
      expect(find.byIcon(LichessIcons.body_cut), findsNWidgets(2));

      // opponent berserks
      sendServerSocketMessages(GameController.socketUri(testGameFullId), [
        '''{"t": "berserk", "d": "black"}''',
      ]);
      // wait for socket message handling
      await tester.pump();

      expect(find.byIcon(LichessIcons.body_cut), findsNWidgets(3));
    });
  });

  group('Clock', () {
    testWidgets('loads on game start', (WidgetTester tester) async {
      await createTestGame(tester);
      expect(findClockWithTime(Side.white, '3:00'), findsOneWidget);
      expect(findClockWithTime(Side.black, '3:00'), findsOneWidget);
      expect(
        tester
            .widgetList<Clock>(find.byType(Clock))
            .where((widget) => widget.active == false)
            .length,
        2,
        reason: 'clocks are not active yet',
      );
    });

    testWidgets('ticks after the first full move', (WidgetTester tester) async {
      await createTestGame(tester);
      expect(findClockWithTime(Side.white, '3:00'), findsOneWidget);
      expect(findClockWithTime(Side.black, '3:00'), findsOneWidget);
      await playMove(tester, 'e2', 'e4');
      // at that point clock is not yet started
      expect(
        tester
            .widgetList<Clock>(find.byType(Clock))
            .where((widget) => widget.active == false)
            .length,
        2,
        reason: 'clocks are not active yet',
      );
      sendServerSocketMessages(testGameSocketUri, [
        '{"t": "move", "v": 1, "d": {"ply": 1, "uci": "e2e4", "san": "e4", "clock": {"white": 180, "black": 180}}}',
        '{"t": "move", "v": 2, "d": {"ply": 2, "uci": "e7e5", "san": "e5", "clock": {"white": 180, "black": 180}}}',
      ]);
      await tester.pump(const Duration(milliseconds: 10));
      expect(tester.widget<Clock>(findClock(Side.white)).active, true);
      await tester.pump(const Duration(seconds: 1));
      expect(findClockWithTime(Side.white, '2:59'), findsOneWidget);
      await tester.pump(const Duration(seconds: 1));
      expect(findClockWithTime(Side.white, '2:58'), findsOneWidget);
    });

    testWidgets('ticks immediately when resuming game', (WidgetTester tester) async {
      await createTestGame(
        tester,
        pgn: 'e4 e5 Nf3',
        clock: const (
          running: true,
          initial: Duration(minutes: 3),
          increment: Duration(seconds: 2),
          white: Duration(minutes: 2, seconds: 58),
          black: Duration(minutes: 2, seconds: 54),
          emerg: Duration(seconds: 30),
        ),
      );
      expect(tester.widget<Clock>(findClock(Side.black)).active, true);
      expect(findClockWithTime(Side.white, '2:58'), findsOneWidget);
      expect(findClockWithTime(Side.black, '2:54'), findsOneWidget);
      await tester.pump(const Duration(seconds: 1));
      expect(findClockWithTime(Side.black, '2:53'), findsOneWidget);
      await tester.pump(const Duration(seconds: 1));
      expect(findClockWithTime(Side.black, '2:52'), findsOneWidget);
    });

    testWidgets('switch timer side after a move', (WidgetTester tester) async {
      await createTestGame(
        tester,
        pgn: 'e4 e5',
        clock: const (
          running: true,
          initial: Duration(minutes: 3),
          increment: Duration(seconds: 2),
          white: Duration(minutes: 2, seconds: 58),
          black: Duration(minutes: 3),
          emerg: Duration(seconds: 30),
        ),
      );
      expect(tester.widget<Clock>(findClock(Side.white)).active, true);
      // simulates think time of 3s
      await tester.pump(const Duration(seconds: 3));
      await playMove(tester, 'g1', 'f3');
      expect(findClockWithTime(Side.white, '2:55'), findsOneWidget);
      expect(
        tester.widget<Clock>(findClock(Side.white)).active,
        false,
        reason: 'white clock is stopped while waiting for server ack',
      );
      expect(
        tester.widget<Clock>(findClock(Side.black)).active,
        true,
        reason: 'black clock is now active but not yet ticking',
      );
      expect(findClockWithTime(Side.black, '3:00'), findsOneWidget);
      // simulates a long lag just to show the clock is not running yet
      await tester.pump(const Duration(milliseconds: 200));
      expect(findClockWithTime(Side.black, '3:00'), findsOneWidget);
      // server ack having the white clock updated with the increment
      sendServerSocketMessages(testGameSocketUri, [
        '{"t": "move", "v": 1, "d": {"ply": 3, "uci": "g1f3", "san": "Nf3", "clock": {"white": 177, "black": 180}}}',
      ]);
      await tester.pump(const Duration(milliseconds: 10));
      // we see now the white clock has got its increment
      expect(findClockWithTime(Side.white, '2:57'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 100));
      // black clock is ticking
      expect(findClockWithTime(Side.black, '2:59'), findsOneWidget);
      await tester.pump(const Duration(seconds: 1));
      expect(findClockWithTime(Side.white, '2:57'), findsOneWidget);
      expect(findClockWithTime(Side.black, '2:58'), findsOneWidget);
      await tester.pump(const Duration(seconds: 1));
      expect(findClockWithTime(Side.white, '2:57'), findsOneWidget);
      expect(findClockWithTime(Side.black, '2:57'), findsOneWidget);
      await tester.pump(const Duration(seconds: 1));
      expect(findClockWithTime(Side.white, '2:57'), findsOneWidget);
      expect(findClockWithTime(Side.black, '2:56'), findsOneWidget);
    });

    testWidgets('compensates opponent lag', (WidgetTester tester) async {
      int socketVersion = 0;
      await createTestGame(
        tester,
        pgn: 'e4 e5 Nf3 Nc6',
        clock: const (
          running: true,
          initial: Duration(minutes: 1),
          increment: Duration.zero,
          white: Duration(seconds: 58),
          black: Duration(seconds: 54),
          emerg: Duration(seconds: 10),
        ),
        socketVersion: socketVersion,
      );
      await tester.pump(const Duration(seconds: 3));
      await playMoveWithServerAck(
        testGameFullId,
        tester,
        'f1',
        'c4',
        ply: 5,
        san: 'Bc4',
        clockAck: (
          white: const Duration(seconds: 55),
          black: const Duration(seconds: 54),
          lag: const Duration(milliseconds: 250),
        ),
        socketVersion: ++socketVersion,
      );
      // black clock is active
      expect(tester.widget<Clock>(findClock(Side.black)).active, true);
      expect(findClockWithTime(Side.black, '0:54'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 250));
      // lag is 250ms, so clock will only start after that delay
      expect(findClockWithTime(Side.black, '0:54'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 100));
      expect(findClockWithTime(Side.black, '0:53'), findsOneWidget);
      await tester.pump(const Duration(seconds: 1));
      expect(findClockWithTime(Side.black, '0:52'), findsOneWidget);
    });

    testWidgets('onEmergency', (WidgetTester tester) async {
      final mockSoundService = MockSoundService();
      when(() => mockSoundService.play(Sound.lowTime)).thenAnswer((_) async {});
      await createTestGame(
        tester,
        pgn: 'e4 e5',
        clock: const (
          running: true,
          initial: Duration(minutes: 3),
          increment: Duration(seconds: 2),
          white: Duration(seconds: 40),
          black: Duration(minutes: 3),
          emerg: Duration(seconds: 30),
        ),
        overrides: {
          soundServiceProvider: soundServiceProvider.overrideWith((_) => mockSoundService),
        },
      );
      expect(
        tester.widget<Clock>(findClockWithTime(Side.white, '0:40')).emergencyThreshold,
        const Duration(seconds: 30),
      );
      await tester.pump(const Duration(seconds: 10));
      expect(findClockWithTime(Side.white, '0:30'), findsOneWidget);
      verify(() => mockSoundService.play(Sound.lowTime)).called(1);
    });

    testWidgets('flags', (WidgetTester tester) async {
      final socketFactory = ListenableFakeWebSocketChannelFactory(
        createDefaultFakeWebSocketChannel,
      );
      await createTestGame(
        tester,
        socketFactory: socketFactory,
        pgn: 'e4 e5 Nf3',
        clock: const (
          running: true,
          initial: Duration(minutes: 3),
          increment: Duration(seconds: 2),
          white: Duration(minutes: 2, seconds: 58),
          black: Duration(minutes: 2, seconds: 54),
          emerg: Duration(seconds: 30),
        ),
      );
      expect(tester.widget<Clock>(findClock(Side.black)).active, true);

      expect(findClockWithTime(Side.white, '2:58'), findsOneWidget);
      expect(findClockWithTime(Side.black, '2:54'), findsOneWidget);
      await tester.pump(const Duration(seconds: 1));
      expect(findClockWithTime(Side.black, '2:53'), findsOneWidget);
      await tester.pump(const Duration(minutes: 2, seconds: 53));
      expect(findClockWithTime(Side.white, '2:58'), findsOneWidget);
      expect(findClockWithTime(Side.black, '0:00.0'), findsOneWidget);

      expect(
        tester.widgetList<Clock>(find.byType(Clock)).first.active,
        true,
        reason:
            'black clock is still active after flag (as long as we have not received server ack)',
      );

      // flag messages are throttled with 500ms delay
      // we'll simulate an anormally long server response of 1s to check 2
      // flag messages are sent
      expectLater(
        socketFactory.outgoingMessages(testGameSocketUri),
        emitsInOrder(['{"t":"flag","d":"black"}', '{"t":"flag","d":"black"}']),
      );
      await tester.pump(const Duration(seconds: 1));
      sendServerSocketMessages(testGameSocketUri, [
        '{"t":"endData","d":{"status":"outoftime","winner":"white","clock":{"wc":17800,"bc":0}}}',
      ]);
      await tester.pump(const Duration(milliseconds: 10));

      expect(
        tester
            .widgetList<Clock>(find.byType(Clock))
            .where((widget) => widget.active == false)
            .length,
        2,
        reason: 'both clocks are now inactive',
      );
      expect(findClockWithTime(Side.white, '2:58'), findsOneWidget);
      expect(findClockWithTime(Side.black, '0:00.00'), findsOneWidget);

      // wait for the dong
      await tester.pump(const Duration(seconds: 500));
    });
  });

  group('Correspondence Clock', () {
    // Retrieves the CorrespondenceClock widget that contains the given displayed time.
    CorrespondenceClock correspondenceClockWithTime(WidgetTester tester, String time) {
      return tester.widget<CorrespondenceClock>(
        find.ancestor(
          of: find.text(time, findRichText: true),
          matching: find.byType(CorrespondenceClock),
        ),
      );
    }

    testWidgets('shows correspondence clocks, not regular clocks', (tester) async {
      await createTestGame(
        tester,
        clock: null,
        pgn: 'e4 e5',
        correspondenceClock: (
          white: const Duration(hours: 20, minutes: 5),
          black: const Duration(days: 1),
          daysPerTurn: 1,
        ),
      );

      expect(find.byType(Clock), findsNothing);
      expect(find.byType(CorrespondenceClock), findsNWidgets(2));
      expect(find.text('One day', findRichText: true), findsOneWidget);
      expect(find.text('20:05', findRichText: true), findsOneWidget);
    });

    testWidgets("active clock is white's when it is white's turn", (tester) async {
      // pgn 'e4 e5': fullmoves = 2, white to move → white active
      await createTestGame(
        tester,
        clock: null,
        pgn: 'e4 e5',
        correspondenceClock: (
          white: const Duration(hours: 20, minutes: 5),
          black: const Duration(days: 1),
          daysPerTurn: 1,
        ),
      );

      expect(correspondenceClockWithTime(tester, '20:05').active, isTrue);
      expect(correspondenceClockWithTime(tester, 'One day').active, isFalse);

      await tester.pump(const Duration(minutes: 2));

      expect(find.text('20:05', findRichText: true), findsNothing);
      expect(find.text('20:03', findRichText: true), findsOneWidget);
      expect(find.text('One day', findRichText: true), findsOneWidget);
    });

    testWidgets("active clock is black's when it is black's turn", (tester) async {
      // pgn 'e4 e5 Nf3': black to move → black active
      await createTestGame(
        tester,
        clock: null,
        pgn: 'e4 e5 Nf3',
        correspondenceClock: (
          white: const Duration(days: 1),
          black: const Duration(hours: 19, minutes: 59),
          daysPerTurn: 1,
        ),
      );

      expect(correspondenceClockWithTime(tester, '19:59').active, isTrue);
      expect(correspondenceClockWithTime(tester, 'One day').active, isFalse);

      await tester.pump(const Duration(minutes: 5));

      expect(find.text('19:59', findRichText: true), findsNothing);
      expect(find.text('19:54', findRichText: true), findsOneWidget);
      expect(find.text('One day', findRichText: true), findsOneWidget);
    });

    testWidgets('clock values and active side update after opponent move', (tester) async {
      await createTestGame(
        tester,
        clock: null,
        pgn: 'e4 e5 Nf3', // black to move → black active
        correspondenceClock: (
          white: const Duration(days: 1),
          black: const Duration(hours: 10, minutes: 3),
          daysPerTurn: 1,
        ),
      );

      expect(correspondenceClockWithTime(tester, '10:03').active, isTrue);

      await tester.pump(const Duration(minutes: 3));
      expect(find.text('10:00', findRichText: true), findsOneWidget);

      // server sends black's move with updated clock values
      sendServerSocketMessages(testGameSocketUri, [
        '{"t": "move", "v": 1, "d": {"ply": 4, "uci": "g8f6", "san": "Nf6", "clock": {"white": 86400, "black": 86400}}}',
      ]);
      await tester.pump(const Duration(milliseconds: 10));

      // both clocks reset to server's authoritative values
      expect(find.text('One day', findRichText: true), findsNWidgets(2));

      await tester.pump(const Duration(seconds: 2));

      // white is now active
      expect(correspondenceClockWithTime(tester, '23:59').active, isTrue);
      expect(correspondenceClockWithTime(tester, 'One day').active, isFalse);
    });
  });

  group('Opening analysis', () {
    testWidgets('is not possible for an unfinished real time game', (WidgetTester tester) async {
      await createTestGame(
        tester,
        pgn: 'e4 e5 Nf3 Nc6 Bc4 Nf6 Ng5 d5 exd5 Na5 Bb5+ c6 dxc6 bxc6 Qf3 Rb8 Bd3',
        socketVersion: 0,
      );
      expect(find.byType(Chessboard), findsOneWidget);
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(Dialog), findsOneWidget);
      expect(find.text('Analysis board'), findsNothing);
    });

    testWidgets('for an unfinished correspondence game', (WidgetTester tester) async {
      const gameFullId = GameFullId('qVChCOTcHSeW');
      final fullEventString = makeFullEvent(
        gameFullId.gameId,
        'e4 e5 Nf3 Nc6 Bc4 Nf6 Ng5 d5 exd5 Na5 Bb5+ c6 dxc6 bxc6 Qf3 Rb8 Bd3',
        whiteUserName: 'Peter',
        blackUserName: 'Steven',
        socketVersion: 0,
        clock: null,
        correspondenceClock: (
          daysPerTurn: 3,
          white: const Duration(days: 3),
          black: const Duration(days: 2, hours: 22, minutes: 49, seconds: 59),
        ),
      );

      // AnalysisScreen uses this to get the game data
      final mockClient = MockClient((request) {
        if (request.url.path == '/$gameFullId/forecasts') {
          return mockResponse(
            jsonEncode(
              SocketEvent.fromJson(jsonDecode(fullEventString) as Map<String, dynamic>).data,
            ),
            200,
          );
        }
        return mockResponse('', 404);
      });

      final app = await makeTestProviderScopeApp(
        tester,
        home: const GameScreen(source: ExistingGameSource(gameFullId)),
        overrides: {
          lichessClientProvider: lichessClientProvider.overrideWith(
            (ref) => LichessClient(mockClient, ref),
          ),
        },
      );
      await tester.pumpWidget(app);
      await tester.pump(const Duration(milliseconds: 10));

      sendServerSocketMessages(GameController.socketUri(gameFullId), [fullEventString]);
      await tester.pump();

      expect(find.byType(Chessboard), findsOneWidget);
      expect(boardHasPiece(tester, Square.d3, Piece.whiteBishop), isTrue);
      expect(getBoardLastMove(tester)?.hasSquare(Square.b5), isTrue);
      expect(getBoardLastMove(tester)?.hasSquare(Square.d3), isTrue);
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(Dialog), findsOneWidget);
      await tester.tap(find.text('Analysis board'));
      await tester.pumpAndSettle(); // wait for analysis screen to open
      expect(
        find.widgetWithText(AppBar, 'Analysis board'),
        findsOneWidget,
      ); // analysis screen is now open
      expect(boardHasPiece(tester, Square.f3, Piece.whiteQueen), isTrue);
      expect(boardHasPiece(tester, Square.d3, Piece.whiteBishop), isTrue);
      expect(getBoardLastMove(tester)?.hasSquare(Square.b5), isTrue);
      expect(getBoardLastMove(tester)?.hasSquare(Square.d3), isTrue);
      expect(find.bySemanticsLabel(RegExp('Moves played')), findsOneWidget);
      // computer analysis is not available when game is not finished
      expect(find.bySemanticsLabel(RegExp('Computer analysis')), findsNothing);
    });

    testWidgets('for a finished game', (WidgetTester tester) async {
      await loadFinishedTestGame(tester);
      expect(find.byType(Chessboard), findsOneWidget);
      expect(boardHasPiece(tester, Square.e6, Piece.whiteQueen), isTrue);
      expect(getBoardLastMove(tester)?.hasSquare(Square.d5), isTrue);
      expect(getBoardLastMove(tester)?.hasSquare(Square.e6), isTrue);
      await tester.pump(const Duration(milliseconds: 500)); // wait for popup
      await tester.tap(find.text('Analysis board'));
      await tester.pumpAndSettle(); // wait for analysis screen to open
      expect(
        find.descendant(of: find.byType(AppBar), matching: find.textContaining('Rated')),
        findsOneWidget,
      ); // analysis screen is now open
      expect(find.byType(Chessboard), findsOneWidget);
      expect(boardHasPiece(tester, Square.e6, Piece.whiteQueen), isTrue);
      expect(getBoardLastMove(tester)?.hasSquare(Square.d5), isTrue);
      expect(getBoardLastMove(tester)?.hasSquare(Square.e6), isTrue);
      expect(find.bySemanticsLabel(RegExp('Moves played')), findsOneWidget);
      expect(
        find.bySemanticsLabel(RegExp('Computer analysis')),
        findsOneWidget,
      ); // computer analysis is available
    });
  });

  group('Chat', () {
    group('Enabled', () {
      testWidgets('onNewMessage', (WidgetTester tester) async {
        final mockSoundService = MockSoundService();
        when(
          () => mockSoundService.play(Sound.confirmation, volume: any(named: 'volume')),
        ).thenAnswer((_) async {});
        await createTestGame(
          tester,
          pgn: 'e4 e5',
          overrides: {
            soundServiceProvider: soundServiceProvider.overrideWith((_) => mockSoundService),
          },
        );
        sendServerSocketMessages(testGameSocketUri, [
          '{"t":"message","d":{"u":"Steven","t":"Hello!"}}',
        ]);
        await tester.pump();
        verify(
          () => mockSoundService.play(Sound.confirmation, volume: any(named: 'volume')),
        ).called(1);
      });

      testWidgets('chat messages do not disappear when game state changes', (
        WidgetTester tester,
      ) async {
        await createTestGame(tester, pgn: 'e4 e5');
        sendServerSocketMessages(testGameSocketUri, [
          '{"t":"message","d":{"u":"Steven","t":"Hello!"}}',
        ]);
        await tester.pump();

        // Play a move to update the GameController's state.
        // There used to be a bug where this would make chat messages disappear.
        await playMove(tester, 'g1', 'f3');

        await tester.tap(find.byType(ChatBottomBarButton));
        await tester.pumpAndSettle(); // wait for chat to open

        expect(find.text('Hello!'), findsOneWidget);
      });
    });

    group('Disabled', () {
      testWidgets('onNewMessage', (WidgetTester tester) async {
        final mockSoundService = MockSoundService();
        when(() => mockSoundService.play(Sound.confirmation)).thenAnswer((_) async {});
        await createTestGame(
          tester,
          pgn: 'e4 e5',
          defaultPreferences: {PrefCategory.game.storageKey: '{"enableChat": false}'},
          overrides: {
            soundServiceProvider: soundServiceProvider.overrideWith((_) => mockSoundService),
          },
        );
        sendServerSocketMessages(testGameSocketUri, [
          '{"t":"message","d":{"u":"Steven","t":"Hello!"}}',
        ]);
        await tester.pump();
        verifyNever(() => mockSoundService.play(Sound.confirmation));
      });
    });
  });

  group('Crazyhouse', () {
    testWidgets('displays pockets and handles player drop moves', (tester) async {
      final socketFactory = ListenableFakeWebSocketChannelFactory(
        createDefaultFakeWebSocketChannel,
      );
      // After 1.e4 d5 2.exd5 Qxd5, white has a pawn in pocket and it's white's turn
      await createTestGame(
        tester,
        variant: Variant.crazyhouse,
        pgn: 'e4 d5 exd5 Qxd5',
        youAre: Side.white,
        socketFactory: socketFactory,
      );

      final dropExpectation = expectLater(
        socketFactory.outgoingMessages(testGameSocketUri),
        emitsThrough('{"t":"drop","d":{"role":"pawn","pos":"c4","s":"0","a":1}}'),
      );

      expect(find.byType(Chessboard), findsOneWidget);
      expect(find.byType(PocketsMenu), findsNWidgets(2));

      // White drops a pawn to c4
      await playDropMove(tester, Side.white, Role.pawn, 'c4');
      await tester.pumpAndSettle();

      // Pawn should appear on c4 (transient move before server ack)
      expect(boardHasPiece(tester, Square.c4, Piece.whitePawn), isTrue);

      await dropExpectation;
    });

    testWidgets('pocket count display updates after a player drop move', (tester) async {
      // Regression test: the pocket counts are rendered by the GameLayout from
      // the board params. With the high-performance board, a move no longer
      // rebuilds the layout shell, so the displayed pocket count could go stale
      // (the dropped pawn would still show in the pocket after being played).

      // After 1.e4 d5 2.exd5 Qxd5, white has a pawn in pocket and it's white's turn.
      await createTestGame(
        tester,
        variant: Variant.crazyhouse,
        pgn: 'e4 d5 exd5 Qxd5',
        youAre: Side.white,
      );

      final whitePawnPocket = find.byKey(const ValueKey('pocket-whitepawn'));
      expect(whitePawnPocket, findsOneWidget);

      // The white pawn pocket initially shows a count badge of 1.
      expect(find.descendant(of: whitePawnPocket, matching: find.text('1')), findsOneWidget);

      // White drops the pawn to c4.
      await playDropMove(tester, Side.white, Role.pawn, 'c4');
      await tester.pumpAndSettle();

      // The pawn is on the board and the pocket count badge is gone (count 0).
      expect(boardHasPiece(tester, Square.c4, Piece.whitePawn), isTrue);
      expect(find.descendant(of: whitePawnPocket, matching: find.text('1')), findsNothing);
    });

    testWidgets("Cannot interact with the opponent's pockets", (tester) async {
      // After 1.e4 d5 2.exd5 Qxd5 Nf3, white and black both have a pawn in pocket and it's black's turn
      await createTestGame(
        tester,
        variant: Variant.crazyhouse,
        pgn: 'e4 d5 exd5 Qxd5 Nf3',
        youAre: Side.white,
      );

      expect(find.byType(Chessboard), findsOneWidget);
      expect(find.byType(PocketsMenu), findsNWidgets(2));

      // Regression test: it used to be possible to interact with the opponent's pockets and play a DropMove for them
      await playDropMove(tester, Side.black, Role.pawn, 'd6');
      await tester.pumpAndSettle();

      // Move should not be played since it's not our turn and the opponent's pockets should not be interactable
      expect(boardHasPiece(tester, Square.d6, Piece.blackPawn), isFalse);
    });

    testWidgets('correctly handles opponent drop move received from server', (tester) async {
      const gameFullId = GameFullId('qVChCOTcHSeW');
      final gameSocketUri = GameController.socketUri(gameFullId);

      // After 1.e4 d5 2.exd5 Qxd5, white has a pawn in pocket and it's white's turn
      await createTestGame(
        tester,
        variant: Variant.crazyhouse,
        pgn: 'e4 d5 exd5 Qxd5',
        youAre: Side.black,
      );

      expect(find.byType(Chessboard), findsOneWidget);
      expect(find.byType(PocketsMenu), findsNWidgets(2));

      // Server sends white's drop move P@c4 (ply 5 after the 4 pgn moves)
      sendServerSocketMessages(gameSocketUri, [
        '{"t": "drop", "v": 1, "d": {"role": "pawn", "ply": 5, "uci": "P@c4", "san": "P@c4", "clock": {"white": 176, "black": 180}}}',
      ]);
      await tester.pump();

      // White pawn should appear on c4
      expect(boardHasPiece(tester, Square.c4, Piece.whitePawn), isTrue);
    });
  });

  group('Widget rebuilds', () {
    // These tests guard the GameScreen performance optimization: a move must
    // update the board through the ChessboardController WITHOUT rebuilding the
    // expensive ancestors (GameScreen/GameBody, the GameLayout shell, the board).
    // Only the leaf widgets that depend on the move (e.g. the player tables) may
    // rebuild. The rebuild probe is widget-instance identity: if an ancestor does
    // not rebuild, the child widget instance found in the tree is unchanged.

    testWidgets('a local move does not rebuild GameBody, GameLayout or the board', (tester) async {
      await createTestGame(tester, pgn: 'e4 e5'); // white (us) to move
      // Flush the one-time load rebuilds (e.g. the real-time-playable future resolving).
      await tester.pump(const Duration(milliseconds: 50));

      final gameBodyBefore = tester.widget<GameBody>(find.byType(GameBody));
      final gameLayoutBefore = tester.widget<GameLayout>(find.byType(GameLayout));
      final boardBefore = tester.widget<Chessboard>(find.byType(Chessboard));
      final playerBefore = tester.widgetList<GamePlayer>(find.byType(GamePlayer)).first;
      final bottomBarBefore = tester.widget<BottomBar>(find.byType(BottomBar));

      await playMove(tester, 'g1', 'f3');
      await tester.pump();

      // The move reached the board (controller-driven repaint)…
      expect(boardHasPiece(tester, Square.f3, Piece.whiteKnight), isTrue);

      // …but the expensive ancestors were not rebuilt.
      expect(
        identical(tester.widget<GameBody>(find.byType(GameBody)), gameBodyBefore),
        isTrue,
        reason: 'GameScreen must not rebuild GameBody on a move',
      );
      expect(
        identical(tester.widget<GameLayout>(find.byType(GameLayout)), gameLayoutBefore),
        isTrue,
        reason: 'the GameLayout shell must not rebuild on a move',
      );
      expect(
        identical(tester.widget<Chessboard>(find.byType(Chessboard)), boardBefore),
        isTrue,
        reason: 'the board must not rebuild on a move (the controller drives the repaint)',
      );

      // The player table (material diff) is a contained, necessary rebuild.
      expect(
        identical(tester.widgetList<GamePlayer>(find.byType(GamePlayer)).first, playerBefore),
        isFalse,
        reason: 'the player table should rebuild on a move',
      );

      // The bottom bar (minus the isolated prev/next nav buttons) watches only
      // discrete flags that don't change on a plain move, so it must not rebuild.
      expect(
        identical(tester.widget<BottomBar>(find.byType(BottomBar)), bottomBarBefore),
        isTrue,
        reason: 'the bottom bar must not rebuild on a move',
      );
    });

    testWidgets('an opponent move does not rebuild GameBody, GameLayout or the board', (
      tester,
    ) async {
      await createTestGame(tester, pgn: 'e4 e5 Nf3'); // black (opponent) to move
      await tester.pump(const Duration(milliseconds: 50));

      final gameBodyBefore = tester.widget<GameBody>(find.byType(GameBody));
      final gameLayoutBefore = tester.widget<GameLayout>(find.byType(GameLayout));
      final boardBefore = tester.widget<Chessboard>(find.byType(Chessboard));
      final bottomBarBefore = tester.widget<BottomBar>(find.byType(BottomBar));

      // Opponent (black) plays Nf6, received from the server.
      sendServerSocketMessages(testGameSocketUri, [
        '{"t": "move", "v": 1, "d": {"ply": 4, "uci": "g8f6", "san": "Nf6", "clock": {"white": 180, "black": 180}}}',
      ]);
      await tester.pump(const Duration(milliseconds: 10));

      expect(boardHasPiece(tester, Square.f6, Piece.blackKnight), isTrue);

      expect(
        identical(tester.widget<GameBody>(find.byType(GameBody)), gameBodyBefore),
        isTrue,
        reason: 'GameScreen must not rebuild GameBody on an opponent move',
      );
      expect(
        identical(tester.widget<GameLayout>(find.byType(GameLayout)), gameLayoutBefore),
        isTrue,
        reason: 'the GameLayout shell must not rebuild on an opponent move',
      );
      expect(
        identical(tester.widget<Chessboard>(find.byType(Chessboard)), boardBefore),
        isTrue,
        reason: 'the board must not rebuild on an opponent move',
      );
      expect(
        identical(tester.widget<BottomBar>(find.byType(BottomBar)), bottomBarBefore),
        isTrue,
        reason: 'the bottom bar must not rebuild on an opponent move',
      );
    });
  });

  group('Wakelock', () {
    for (final gameStatus in GameStatus.values) {
      final gameIsFinished = gameStatus != GameStatus.started && gameStatus != GameStatus.created;
      testWidgets(
        '${gameIsFinished ? 'disables' : 'does not disable'} when game status is ${gameStatus.name}',
        (tester) async {
          final List<ToggleMessage> messages = <ToggleMessage>[];
          const pigeonCodec = _PigeonCodec();

          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMessageHandler(
            'dev.flutter.pigeon.wakelock_plus_platform_interface.WakelockPlusApi.toggle',
            (ByteData? data) async {
              final decodedMessages = (pigeonCodec.decodeMessage(data) as List)
                  .cast<ToggleMessage>();
              messages.add(decodedMessages.single);
              return data;
            },
          );

          addTearDown(() {
            TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMessageHandler(
              'dev.flutter.pigeon.wakelock_plus_platform_interface.WakelockPlusApi.toggle',
              null,
            );
          });

          await createTestGame(
            tester,
            pgn: 'e4 e5',
            defaultPreferences: {PrefCategory.game.storageKey: '{"enableChat": false}'},
          );

          sendServerSocketMessages(testGameSocketUri, [
            '{"t":"endData","d":{"status":"${gameStatus.name}","winner":"white","clock":{"wc":17800,"bc":0}}}',
          ]);

          await tester.pump();

          await tester.pump(const Duration(seconds: 500));
          expect(messages.last.enable, gameIsFinished ? isFalse : isTrue);
        },
      );
    }
  });

  group('Claim win', () {
    testWidgets('shows the countdown when the opponent leaves and claims victory', (
      WidgetTester tester,
    ) async {
      final socketFactory = ListenableFakeWebSocketChannelFactory(
        createDefaultFakeWebSocketChannel,
      );
      await createTestGame(
        tester,
        socketFactory: socketFactory,
        // fullmoves >= 2 so the game is resignable (not abortable), and it is the
        // opponent's turn so the claim-win countdown is allowed to show.
        pgn: 'e4 e5 Nf3',
        clock: const (
          running: true,
          initial: Duration(minutes: 3),
          increment: Duration(seconds: 2),
          white: Duration(minutes: 2, seconds: 58),
          black: Duration(minutes: 2, seconds: 54),
          emerg: Duration(seconds: 30),
        ),
      );

      // No countdown until the opponent leaves.
      expect(find.byType(CountdownClockBuilder), findsNothing);

      // 'goneIn' announces the opponent left and starts the claim-win countdown.
      sendServerSocketMessages(testGameSocketUri, ['{"t": "goneIn", "v": 1, "d": 30}']);
      await tester.pump();
      expect(find.textContaining('claim victory in 30 seconds'), findsOneWidget);

      final countdownButton = find.ancestor(
        of: find.textContaining('claim victory in 30 seconds'),
        matching: find.byType(InkWell),
      );

      // Victory is not claimable until the 'gone' threshold is reached, so the
      // countdown is not tappable yet (InkWell.onTap is null).
      await tester.tap(countdownButton, warnIfMissed: false);
      await tester.pump();
      expect(find.text('Claim victory'), findsNothing);

      // 'gone' confirms the opponent has been gone long enough to claim.
      sendServerSocketMessages(testGameSocketUri, ['{"t": "gone", "v": 2, "d": true}']);
      await tester.pump();

      // Tapping the countdown now opens the claim-win dialog. (warnIfMissed: the
      // tap reaches the InkWell's gesture listener, but layered widgets mean the
      // InkWell RenderBox isn't the topmost hit-test object at its center.)
      await tester.tap(countdownButton, warnIfMissed: false);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('Claim victory'), findsOneWidget);
      expect(find.text('Call draw'), findsOneWidget);

      // Claiming victory sends the force-resign message and closes the dialog.
      expectLater(socketFactory.outgoingMessages(testGameSocketUri), emits('{"t":"resign-force"}'));
      await tester.tap(find.text('Claim victory'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('Claim victory'), findsNothing);
    });
  });

  group('Zen mode', () {
    testWidgets('Zen.gameAuto activates zen during playable game', (tester) async {
      await createTestGame(
        tester,
        serverPrefs: const ServerGamePrefs(
          showRatings: true,
          enablePremove: true,
          autoQueen: AutoQueen.always,
          confirmResign: true,
          submitMove: false,
          zenMode: Zen.gameAuto,
        ),
      );

      final container = ProviderScope.containerOf(tester.element(find.byType(GameScreen)));
      final state = container.read(gameControllerProvider(testGameFullId)).requireValue;
      expect(state.isZenModeEnabled, isTrue);
      expect(state.isZenModeActive, isTrue);
    });

    testWidgets('Zen.no does not activate zen', (tester) async {
      await createTestGame(
        tester,
        serverPrefs: const ServerGamePrefs(
          showRatings: true,
          enablePremove: true,
          autoQueen: AutoQueen.always,
          confirmResign: true,
          submitMove: false,
          zenMode: Zen.no,
        ),
      );

      final container = ProviderScope.containerOf(tester.element(find.byType(GameScreen)));
      final state = container.read(gameControllerProvider(testGameFullId)).requireValue;
      expect(state.isZenModeEnabled, isFalse);
      expect(state.isZenModeActive, isFalse);
    });

    testWidgets('Zen.yes activates zen', (tester) async {
      await createTestGame(
        tester,
        serverPrefs: const ServerGamePrefs(
          showRatings: true,
          enablePremove: true,
          autoQueen: AutoQueen.always,
          confirmResign: true,
          submitMove: false,
          zenMode: Zen.yes,
        ),
      );

      final container = ProviderScope.containerOf(tester.element(find.byType(GameScreen)));
      final state = container.read(gameControllerProvider(testGameFullId)).requireValue;
      expect(state.isZenModeEnabled, isTrue);
      expect(state.isZenModeActive, isTrue);
    });

    testWidgets('Zen.gameAuto deactivates zen when game finishes', (tester) async {
      await createTestGame(
        tester,
        serverPrefs: const ServerGamePrefs(
          showRatings: true,
          enablePremove: true,
          autoQueen: AutoQueen.always,
          confirmResign: true,
          submitMove: false,
          zenMode: Zen.gameAuto,
        ),
      );

      final container = ProviderScope.containerOf(tester.element(find.byType(GameScreen)));
      expect(
        container.read(gameControllerProvider(testGameFullId)).requireValue.isZenModeActive,
        isTrue,
      );

      sendServerSocketMessages(testGameSocketUri, [
        '{"t":"endData","d":{"status":"mate","winner":"white","clock":{"wc":17800,"bc":0}}}',
      ]);
      await tester.pump(const Duration(milliseconds: 500));

      expect(
        container.read(gameControllerProvider(testGameFullId)).requireValue.isZenModeActive,
        isFalse,
      );
    });

    testWidgets('Zen.yes keeps zen active when game finishes', (tester) async {
      await createTestGame(
        tester,
        serverPrefs: const ServerGamePrefs(
          showRatings: true,
          enablePremove: true,
          autoQueen: AutoQueen.always,
          confirmResign: true,
          submitMove: false,
          zenMode: Zen.yes,
        ),
      );

      final container = ProviderScope.containerOf(tester.element(find.byType(GameScreen)));
      expect(
        container.read(gameControllerProvider(testGameFullId)).requireValue.isZenModeActive,
        isTrue,
      );

      sendServerSocketMessages(testGameSocketUri, [
        '{"t":"endData","d":{"status":"mate","winner":"white","clock":{"wc":17800,"bc":0}}}',
      ]);
      await tester.pump(const Duration(milliseconds: 500));

      expect(
        container.read(gameControllerProvider(testGameFullId)).requireValue.isZenModeActive,
        isTrue,
      );
    });

    testWidgets('toggleZenMode switches zen off and on', (tester) async {
      await createTestGame(
        tester,
        serverPrefs: const ServerGamePrefs(
          showRatings: true,
          enablePremove: true,
          autoQueen: AutoQueen.always,
          confirmResign: true,
          submitMove: false,
          zenMode: Zen.gameAuto,
        ),
      );

      final container = ProviderScope.containerOf(tester.element(find.byType(GameScreen)));
      final ctrlProvider = gameControllerProvider(testGameFullId);

      expect(container.read(ctrlProvider).requireValue.isZenModeEnabled, isTrue);
      expect(container.read(ctrlProvider).requireValue.isZenModeActive, isTrue);

      container.read(ctrlProvider.notifier).toggleZenMode();
      await tester.pump(const Duration(milliseconds: 300));

      expect(container.read(ctrlProvider).requireValue.isZenModeEnabled, isFalse);
      expect(container.read(ctrlProvider).requireValue.isZenModeActive, isFalse);

      container.read(ctrlProvider.notifier).toggleZenMode();
      await tester.pump(const Duration(milliseconds: 300));

      expect(container.read(ctrlProvider).requireValue.isZenModeEnabled, isTrue);
      expect(container.read(ctrlProvider).requireValue.isZenModeActive, isTrue);
    });
  });
}

/// Finds the clock on the specified [side].
Finder findClock(Side side, {bool skipOffstage = true}) {
  return find.byKey(ValueKey('${side.name}-clock'), skipOffstage: skipOffstage);
}

/// Finds the clock with the given [text] on the specified [side].
Finder findClockWithTime(Side side, String text, {bool skipOffstage = true}) {
  return find.ancestor(
    of: find.text(text, findRichText: true, skipOffstage: skipOffstage),
    matching: find.byKey(ValueKey('${side.name}-clock'), skipOffstage: skipOffstage),
  );
}

/// Simulates playing a move and getting the ack from the server after [elapsedTime].
Future<void> playMoveWithServerAck(
  GameFullId gameFullId,
  WidgetTester tester,
  String from,
  String to, {
  required String san,
  required ({Duration white, Duration black, Duration? lag}) clockAck,
  required int socketVersion,
  required int ply,
  Duration elapsedTime = const Duration(milliseconds: 10),
  Side orientation = Side.white,
}) async {
  await playMove(tester, from, to, orientation: orientation);
  final uci = '$from$to';
  final lagStr = clockAck.lag != null
      ? ', "lag": ${(clockAck.lag!.inMilliseconds / 10).round()}'
      : '';
  await tester.pump(elapsedTime - const Duration(milliseconds: 1));
  sendServerSocketMessages(GameController.socketUri(gameFullId), [
    '{"t": "move", "v": $socketVersion, "d": {"ply": $ply, "uci": "$uci", "san": "$san", "clock": {"white": ${(clockAck.white.inMilliseconds / 1000).toStringAsFixed(2)}, "black": ${(clockAck.black.inMilliseconds / 1000).toStringAsFixed(2)}$lagStr}}}',
  ]);
  await tester.pump();
}

/// Convenient function to start a new test game
Future<void> createTestGame(
  WidgetTester tester, {
  Variant variant = Variant.standard,
  String? initialFen,
  Side? youAre = Side.white,
  String? pgn,
  int socketVersion = 0,
  FullEventTestClock? clock = const (
    running: false,
    initial: Duration(minutes: 3),
    increment: Duration(seconds: 2),
    white: Duration(minutes: 3),
    black: Duration(minutes: 3),
    emerg: Duration(seconds: 30),
  ),
  FullEventTestCorrespondenceClock? correspondenceClock,
  Map<String, Object>? defaultPreferences,
  Map<ProviderOrFamily, Override>? overrides,
  TournamentMeta? tournament,
  ServerGamePrefs? serverPrefs,

  /// An optional listenable fake web socket channel factory to use in place of the default one if
  /// we need to listen to the sent messages.
  ListenableFakeWebSocketChannelFactory? socketFactory,
}) async {
  const gameFullId = GameFullId('qVChCOTcHSeW');
  final app = await makeTestProviderScopeApp(
    tester,
    home: const GameScreen(source: ExistingGameSource(gameFullId)),
    defaultPreferences: defaultPreferences,
    overrides: {
      lichessClientProvider: lichessClientProvider.overrideWith(
        (ref) => LichessClient(client, ref),
      ),
      if (socketFactory != null)
        webSocketChannelFactoryProvider: webSocketChannelFactoryProvider.overrideWith((ref) {
          ref.onDispose(socketFactory.dispose);
          return socketFactory;
        }),
      ...?overrides,
    },
  );
  await tester.pumpWidget(app);
  await tester.pump(const Duration(milliseconds: 10));

  sendServerSocketMessages(GameController.socketUri(gameFullId), [
    makeFullEvent(
      variant: variant,
      const GameId('qVChCOTc'),
      pgn ?? '',
      initialFen: initialFen,
      whiteUserName: 'Peter',
      blackUserName: 'Steven',
      youAre: youAre,
      socketVersion: socketVersion,
      clock: clock,
      correspondenceClock: correspondenceClock,
      tournament: tournament,
      serverPrefs: serverPrefs,
    ),
  ]);
  await tester.pump();
}

Future<void> loadFinishedTestGame(
  WidgetTester tester, {
  String serverFullEvent = _finishedGameFullEvent,
  Map<ProviderOrFamily, Override>? overrides,
}) async {
  final json = jsonDecode(serverFullEvent) as Map<String, dynamic>;
  final gameId = GameFullEvent.fromJson(json['d'] as Map<String, dynamic>).game.id;
  final gameFullId = GameFullId('${gameId.value}test');
  final app = await makeTestProviderScopeApp(
    tester,
    home: GameScreen(source: ExistingGameSource(gameFullId)),
    overrides: {
      lichessClientProvider: lichessClientProvider.overrideWith(
        (ref) => LichessClient(client, ref),
      ),
      ...?overrides,
    },
  );
  await tester.pumpWidget(app);
  await tester.pump(const Duration(milliseconds: 10));
  // wait for socket
  await tester.pump(kFakeWebSocketConnectionLag);

  sendServerSocketMessages(GameController.socketUri(gameFullId), [serverFullEvent]);
  await tester.pump();
}

const _finishedGameFullEvent = '''
{"t":"full","d":{"game":{"id":"CCW6EEru","variant":{"key":"standard","name":"Standard","short":"Std"},"speed":"bullet","perf":"bullet","rated":true,"fen":"6kr/p1p2rpp/4Q3/2b1p3/8/2P5/P2N1PPP/R3R1K1 b - - 0 22","turns":43,"source":"lobby","status":{"id":31,"name":"resign"},"createdAt":1706185945680,"winner":"white","pgn":"e4 e5 Nf3 Nc6 Bc4 Bc5 b4 Bxb4 c3 Ba5 d4 Bb6 Ba3 Nf6 Qb3 d6 Bxf7+ Kf8 O-O Qe7 Nxe5 Nxe5 dxe5 Be6 Bxe6 Nxe4 Re1 Nc5 Bxc5 Bxc5 Qxb7 Re8 Bh3 dxe5 Qf3+ Kg8 Nd2 Rf8 Qd5+ Rf7 Be6 Qxe6 Qxe6"},"white":{"user":{"name":"veloce","id":"veloce"},"rating":1789,"ratingDiff":9},"black":{"user":{"name":"chabrot","id":"chabrot"},"rating":1810,"ratingDiff":-9},"socket":0,"clock":{"running":false,"initial":120,"increment":1,"white":31.2,"black":27.42,"emerg":15,"moretime":15},"takebackable":true,"youAre":"white","prefs":{"autoQueen":2,"zen":2,"confirmResign":true,"enablePremove":true},"chat":{"lines":[]}}}
''';

/// Necessary to mock wakelock_plus method calls
/// See: https://github.com/fluttercommunity/wakelock_plus/blob/0c74e5bbc6aefac57b6c96bb7ef987705ed559ec/wakelock_plus_platform_interface/lib/messages.g.dart#L127-L156
class _PigeonCodec extends StandardMessageCodec {
  const _PigeonCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is int) {
      buffer.putUint8(4);
      buffer.putInt64(value);
    } else if (value is ToggleMessage) {
      buffer.putUint8(129);
      writeValue(buffer, value.encode());
    } else if (value is IsEnabledMessage) {
      buffer.putUint8(130);
      writeValue(buffer, value.encode());
    } else {
      super.writeValue(buffer, value);
    }
  }

  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case 129:
        return ToggleMessage.decode(readValue(buffer)!);
      case 130:
        return IsEnabledMessage.decode(readValue(buffer)!);
      default:
        return super.readValueOfType(type, buffer);
    }
  }
}
