import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/view/game/game_player.dart';

import '../../test_provider_scope.dart';

void main() {
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
