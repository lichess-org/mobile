import 'dart:convert';

import 'package:dartchess/dartchess.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/game_socket_events.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/service/sound_service.dart';
import 'package:lichess_mobile/src/view/game/correspondence_clock_widget.dart';
import 'package:lichess_mobile/src/view/game/game_player.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';

import '../../model/game/game_socket_example_data.dart';
import '../../test_provider_scope.dart';

class MockSoundService() extends Mock implements SoundService;

void main() {
  group('GamePlayer responsive countdown', () {
    for (final clockPosition in ClockPosition.values) {
      for (final resize in [true, false]) {
        testWidgets('preserves timers and low-time sound: $clockPosition, resize=$resize', (
          tester,
        ) async {
          final narrow = ValueNotifier(false);
          addTearDown(narrow.dispose);
          final sound = MockSoundService();
          when(() => sound.play(Sound.lowTime)).thenAnswer((_) async {});
          final event = jsonDecode(
            makeFullEvent(
              const GameId('abcdefgh'),
              '',
              whiteUserName: 'White',
              blackUserName: 'Black',
            ),
          ) as Map<String, dynamic>;
          final game = GameFullEvent.fromJson(event['d'] as Map<String, dynamic>).game;
          final flutterTestOnError = FlutterError.onError!;
          final app = await makeTestProviderScopeApp(
            tester,
            home: Scaffold(
              body: ListenableBuilder(
                listenable: narrow,
                builder: (context, _) => MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(textScaler: TextScaler.linear(resize || narrow.value ? 2 : 1)),
                  child: Center(
                    child: SizedBox(
                      width: resize && !narrow.value ? 400 : 240,
                      child: GamePlayer(
                        game: game,
                        side: Side.white,
                        mePlaying: true,
                        timeToMove: const Duration(seconds: 10),
                        clockPosition: clockPosition,
                        clock: const CorrespondenceClock(
                          duration: Duration(minutes: 5),
                          active: true,
                          resetId: 0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            overrides: {soundServiceProvider: soundServiceProvider.overrideWithValue(sound)},
          );
          FlutterError.onError = flutterTestOnError;
          addTearDown(() => FlutterError.onError = flutterTestOnError);
          await tester.pumpWidget(app);
          await tester.pump();
          final countdownState = tester.state(find.byType(MoveExpiration));
          final clockState = tester.state(find.byType(CorrespondenceClock));

          await tester.pump(const Duration(seconds: 3));
          expect(find.text('7 seconds to play the first move'), findsOneWidget);
          expect(find.text('00:04:57', findRichText: true), findsOneWidget);

          narrow.value = true;
          await tester.pump();
          expect(find.text('7 seconds to play the first move'), findsOneWidget);
          expect(tester.state(find.byType(MoveExpiration)), same(countdownState));
          expect(tester.state(find.byType(CorrespondenceClock)), same(clockState));
          expect(find.text('00:04:57', findRichText: true), findsOneWidget);

          await tester.pump(const Duration(seconds: 1));
          narrow.value = false;
          await tester.pump();
          expect(find.text('6 seconds to play the first move'), findsOneWidget);
          expect(tester.state(find.byType(MoveExpiration)), same(countdownState));
          expect(tester.state(find.byType(CorrespondenceClock)), same(clockState));
          expect(find.text('00:04:56', findRichText: true), findsOneWidget);

          await tester.pump(const Duration(seconds: 1));
          expect(find.text('5 seconds to play the first move'), findsOneWidget);
          verify(() => sound.play(Sound.lowTime)).called(1);
          expect(tester.takeException(), isNull);
        });
      }
    }
  });

  group('MoveExpiration', () {
    testWidgets('does not restart the timer when rebuilt with the same timeToMove', (tester) async {
      // Ticked to force a rebuild of [MoveExpiration] without changing its props.
      final rebuild = ValueNotifier(0);
      addTearDown(rebuild.dispose);
      const timeToMove = Duration(seconds: 15);

      final app = await makeTestProviderScopeApp(
        tester,
        home: ListenableBuilder(
          listenable: rebuild,
          builder: (context, _) => const MoveExpiration(timeToMove: timeToMove, mePlaying: false),
        ),
      );
      await tester.pumpWidget(app);
      await tester.pump();

      expect(find.text('15 seconds to play the first move'), findsOneWidget);

      // Let the countdown tick for 3 seconds.
      await tester.pump(const Duration(seconds: 3));
      expect(find.text('12 seconds to play the first move'), findsOneWidget);

      // Parent rebuilds with an identical timeToMove: the timer must keep
      // running from where it left off, not restart from 15s.
      rebuild.value++;
      await tester.pump();

      expect(find.text('12 seconds to play the first move'), findsOneWidget);

      // Still counting down from the same point, not a fresh 15s timer.
      await tester.pump(const Duration(seconds: 2));
      expect(find.text('10 seconds to play the first move'), findsOneWidget);
    });

    testWidgets('restarts the timer when timeToMove changes', (tester) async {
      final rebuild = ValueNotifier(0);
      addTearDown(rebuild.dispose);
      var timeToMove = const Duration(seconds: 15);

      final app = await makeTestProviderScopeApp(
        tester,
        home: ListenableBuilder(
          listenable: rebuild,
          builder: (context, _) => MoveExpiration(timeToMove: timeToMove, mePlaying: false),
        ),
      );
      await tester.pumpWidget(app);
      await tester.pump();

      expect(find.text('15 seconds to play the first move'), findsOneWidget);

      await tester.pump(const Duration(seconds: 3));
      expect(find.text('12 seconds to play the first move'), findsOneWidget);

      // A new time to move arrives: countdown must reset to the new value.
      timeToMove = const Duration(seconds: 20);
      rebuild.value++;
      await tester.pump();

      expect(find.text('20 seconds to play the first move'), findsOneWidget);

      await tester.pump(const Duration(seconds: 5));
      expect(find.text('15 seconds to play the first move'), findsOneWidget);
    });
  });
}
