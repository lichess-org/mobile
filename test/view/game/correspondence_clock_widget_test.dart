import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/view/game/correspondence_clock_widget.dart';

Widget _buildClock({
  required Duration duration,
  required bool active,
  required int resetId,
  VoidCallback? onFlag,
}) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    home: Scaffold(
      body: CorrespondenceClock(
        duration: duration,
        active: active,
        resetId: resetId,
        onFlag: onFlag,
      ),
    ),
  );
}

void main() {
  group('CorrespondenceClock', () {
    testWidgets('displays the initial time correctly', (tester) async {
      await tester.pumpWidget(
        _buildClock(duration: const Duration(minutes: 5), active: false, resetId: 0),
      );
      await tester.pump();
      expect(find.text('00:05:00', findRichText: true), findsOneWidget);
    });

    testWidgets('does not tick when inactive', (tester) async {
      await tester.pumpWidget(
        _buildClock(duration: const Duration(minutes: 5), active: false, resetId: 0),
      );
      await tester.pump();
      expect(find.text('00:05:00', findRichText: true), findsOneWidget);

      await tester.pump(const Duration(seconds: 10));
      expect(find.text('00:05:00', findRichText: true), findsOneWidget);
    });

    testWidgets('resets timeLeft when resetId changes (active true -> false, new duration)', (
      tester,
    ) async {
      await tester.pumpWidget(
        _buildClock(duration: const Duration(minutes: 5), active: true, resetId: 1),
      );
      await tester.pump();
      expect(find.text('00:05:00', findRichText: true), findsOneWidget);

      // Server confirms move: active and duration both change, resetId bumped.
      await tester.pumpWidget(
        _buildClock(duration: const Duration(minutes: 3), active: false, resetId: 2),
      );
      await tester.pump();

      expect(find.text('00:03:00', findRichText: true), findsOneWidget);
    });

    testWidgets('resets timeLeft when resetId changes (active false -> true, new duration)', (
      tester,
    ) async {
      await tester.pumpWidget(
        _buildClock(duration: const Duration(minutes: 3), active: false, resetId: 1),
      );
      await tester.pump();
      expect(find.text('00:03:00', findRichText: true), findsOneWidget);

      // Opponent moved: becomes our turn with updated duration, resetId bumped.
      await tester.pumpWidget(
        _buildClock(duration: const Duration(minutes: 5), active: true, resetId: 2),
      );
      await tester.pump();

      expect(find.text('00:05:00', findRichText: true), findsOneWidget);
    });

    // Key scenario: the player whose duration didn't change (their bank is untouched)
    // but who becomes active because the opponent just moved. The resetId bumps because
    // a move was made, so timeLeft must sync to the server duration even though the
    // duration value itself didn't change.
    testWidgets('resets timeLeft when resetId changes even if duration is unchanged', (
      tester,
    ) async {
      await tester.pumpWidget(
        _buildClock(duration: const Duration(minutes: 5), active: false, resetId: 1),
      );
      await tester.pump();
      expect(find.text('00:05:00', findRichText: true), findsOneWidget);

      // Opponent made a move: it's now our turn, our time bank is unchanged (5 min),
      // but a new move was made so resetId is bumped.
      await tester.pumpWidget(
        _buildClock(duration: const Duration(minutes: 5), active: true, resetId: 2),
      );
      await tester.pump();

      expect(find.text('00:05:00', findRichText: true), findsOneWidget);
    });

    testWidgets('does not reset timeLeft on widget rebuild when resetId is unchanged', (
      tester,
    ) async {
      await tester.pumpWidget(
        _buildClock(duration: const Duration(minutes: 5), active: true, resetId: 1),
      );
      await tester.pump();
      // Let the clock tick for 3 seconds.
      await tester.pump(const Duration(seconds: 3));
      expect(find.text('00:04:57', findRichText: true), findsOneWidget);

      // Widget rebuilds (e.g. unrelated state change) with same resetId — must not reset.
      await tester.pumpWidget(
        _buildClock(duration: const Duration(minutes: 5), active: true, resetId: 1),
      );
      await tester.pump();

      expect(find.text('00:04:57', findRichText: true), findsOneWidget);
    });
  });
}
