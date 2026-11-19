import 'package:clock/clock.dart' as clock;
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/account/account_preferences.dart';
import 'package:lichess_mobile/src/widgets/clock.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  group('Clock', () {
    testWidgets('dims inactive emergency clocks while preserving normal and flagged colors', (
      tester,
    ) async {
      const style = ClockStyle(
        textColor: Colors.black,
        activeTextColor: Colors.blue,
        emergencyTextColor: Colors.white,
        backgroundColor: Colors.grey,
        activeBackgroundColor: Colors.green,
        emergencyBackgroundColor: Color(0x80FF0000),
      );

      for (final (active, timeLeft, expectedBackground, expectedText) in const [
        (true, Duration(seconds: 5), Color(0x80FF0000), Colors.white),
        (false, Duration(seconds: 5), Color(0x40FF0000), Colors.black),
        (true, Duration.zero, Color(0x80FF0000), Colors.white),
        (false, Duration.zero, Color(0x80FF0000), Colors.white),
        (true, Duration(seconds: 15), Colors.green, Colors.blue),
        (false, Duration(seconds: 15), Colors.grey, Colors.black),
      ]) {
        await tester.pumpWidget(
          MaterialApp(
            home: Clock(
              timeLeft: timeLeft,
              active: active,
              emergencyThreshold: const Duration(seconds: 10),
              clockStyle: style,
            ),
          ),
        );

        final clockFinder = find.byType(Clock);
        final container = tester.widget<Container>(
          find.descendant(of: clockFinder, matching: find.byType(Container)),
        );
        final timeText = tester.widget<Text>(
          find.descendant(of: clockFinder, matching: find.byType(Text)),
        );

        expect(
          (container.decoration! as BoxDecoration).color!.toARGB32(),
          expectedBackground.toARGB32(),
        );
        expect(timeText.textSpan!.style?.color, expectedText);
      }
    });

    testWidgets('shows milliseconds when time < 1s and active is false', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Clock(timeLeft: Duration(seconds: 1), active: true)),
      );

      expect(find.text('0:01.0', findRichText: true), findsOneWidget);

      await tester.pumpWidget(
        const MaterialApp(home: Clock(timeLeft: Duration(milliseconds: 988), active: false)),
        duration: const Duration(milliseconds: 1000),
      );

      expect(find.text('0:00.98', findRichText: true), findsOneWidget);
    });

    testWidgets('Show tenths according to pref', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: Clock(timeLeft: Duration(seconds: 11))));
      expect(find.text('0:11', findRichText: true), findsOneWidget);

      await tester.pumpWidget(const MaterialApp(home: Clock(timeLeft: Duration(seconds: 1))));
      expect(find.text('0:01.0', findRichText: true), findsOneWidget);

      await tester.pumpWidget(
        const MaterialApp(
          home: Clock(timeLeft: Duration(seconds: 11), clockTenths: ClockTenths.never),
        ),
      );
      expect(find.text('0:11', findRichText: true), findsOneWidget);

      await tester.pumpWidget(
        const MaterialApp(
          home: Clock(timeLeft: Duration(seconds: 1), clockTenths: ClockTenths.never),
        ),
      );
      expect(find.text('0:01', findRichText: true), findsOneWidget);

      await tester.pumpWidget(
        const MaterialApp(
          home: Clock(timeLeft: Duration(seconds: 11), clockTenths: ClockTenths.always),
        ),
      );
      expect(find.text('0:11.0', findRichText: true), findsOneWidget);

      await tester.pumpWidget(
        const MaterialApp(
          home: Clock(timeLeft: Duration(seconds: 1), clockTenths: ClockTenths.always),
        ),
      );
      expect(find.text('0:01.0', findRichText: true), findsOneWidget);

      await tester.pumpWidget(
        const MaterialApp(
          home: Clock(
            timeLeft: Duration(minutes: 59, seconds: 59),
            clockTenths: ClockTenths.always,
          ),
        ),
      );
      expect(find.text('59:59.0', findRichText: true), findsOneWidget);

      await tester.pumpWidget(
        const MaterialApp(
          home: Clock(timeLeft: Duration(hours: 1, seconds: 1), clockTenths: ClockTenths.always),
        ),
      );
      expect(find.text('1:00:01', findRichText: true), findsOneWidget);
    });
  });

  group('CountdownClockBuilder', () {
    Widget clockBuilder(BuildContext context, Duration timeLeft) {
      final mins = timeLeft.inMinutes.remainder(60);
      final secs = timeLeft.inSeconds.remainder(60).toString().padLeft(2, '0');
      final tenths = timeLeft.inMilliseconds.remainder(1000) ~/ 100;
      return Text('$mins:$secs.$tenths');
    }

    testWidgets('does not tick when not active', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: CountdownClockBuilder(
            timeLeft: const Duration(seconds: 10),
            active: false,
            builder: clockBuilder,
          ),
        ),
      );

      expect(find.text('0:10.0'), findsOneWidget);

      await tester.pump(const Duration(seconds: 2));
      expect(find.text('0:10.0'), findsOneWidget);
    });

    testWidgets('ticks when active', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: CountdownClockBuilder(
            timeLeft: const Duration(seconds: 10),
            active: true,
            builder: clockBuilder,
          ),
        ),
      );

      expect(find.text('0:10.0'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('0:09.9'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('0:09.8'), findsOneWidget);
      await tester.pump(const Duration(seconds: 10));
      expect(find.text('0:00.0'), findsOneWidget);
    });

    testWidgets('update time by changing widget configuration', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: CountdownClockBuilder(
            timeLeft: const Duration(seconds: 10),
            clockUpdatedAt: clock.clock.now(),
            active: true,
            builder: clockBuilder,
          ),
        ),
      );

      expect(find.text('0:10.0'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('0:09.9'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('0:09.8'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('0:09.7'), findsOneWidget);

      await tester.pumpWidget(
        MaterialApp(
          home: CountdownClockBuilder(
            timeLeft: const Duration(seconds: 11),
            clockUpdatedAt: clock.clock.now(),
            active: true,
            builder: clockBuilder,
          ),
        ),
      );
      expect(find.text('0:11.0'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('0:10.9'), findsOneWidget);
      await tester.pump(const Duration(seconds: 11));
      expect(find.text('0:00.0'), findsOneWidget);
    });

    testWidgets('do not update if timeLeft is different but clockUpdatedAt is same', (
      WidgetTester tester,
    ) async {
      final now = clock.clock.now();
      await tester.pumpWidget(
        MaterialApp(
          home: CountdownClockBuilder(
            timeLeft: const Duration(seconds: 10),
            clockUpdatedAt: now,
            active: true,
            builder: clockBuilder,
          ),
        ),
      );

      expect(find.text('0:10.0'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('0:09.9'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('0:09.8'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('0:09.7'), findsOneWidget);

      await tester.pumpWidget(
        MaterialApp(
          home: CountdownClockBuilder(
            timeLeft: const Duration(seconds: 11),
            clockUpdatedAt: now,
            active: true,
            builder: clockBuilder,
          ),
        ),
      );

      expect(find.text('0:09.7'), findsOneWidget);
      await tester.pump(const Duration(seconds: 10));
      expect(find.text('0:00.0'), findsOneWidget);
    });

    testWidgets('update if timeLeft is different and clockUpdatedAt is null', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: CountdownClockBuilder(
            timeLeft: const Duration(seconds: 10),
            active: true,
            builder: clockBuilder,
          ),
        ),
      );

      expect(find.text('0:10.0'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('0:09.9'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('0:09.8'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('0:09.7'), findsOneWidget);

      await tester.pumpWidget(
        MaterialApp(
          home: CountdownClockBuilder(
            timeLeft: const Duration(seconds: 11),
            active: true,
            builder: clockBuilder,
          ),
        ),
      );

      expect(find.text('0:11.0'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('0:10.9'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('0:10.8'), findsOneWidget);
      await tester.pump(const Duration(seconds: 11));
      expect(find.text('0:00.0'), findsOneWidget);
    });

    testWidgets('stops when active become false', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: CountdownClockBuilder(
            timeLeft: const Duration(seconds: 10),
            active: true,
            builder: clockBuilder,
          ),
        ),
      );

      expect(find.text('0:10.0', findRichText: true), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('0:09.9', findRichText: true), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('0:09.8', findRichText: true), findsOneWidget);

      // clock is rebuilt with same time but inactive:
      // the time is kept and the clock stops counting the elapsed time
      await tester.pumpWidget(
        MaterialApp(
          home: CountdownClockBuilder(
            timeLeft: const Duration(seconds: 10),
            active: false,
            builder: clockBuilder,
          ),
        ),
        duration: const Duration(milliseconds: 100),
      );
      expect(find.text('0:09.7', findRichText: true), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('0:09.7', findRichText: true), findsOneWidget);
    });

    testWidgets('starts with a delay if set', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: CountdownClockBuilder(
            timeLeft: const Duration(seconds: 10),
            active: true,
            delay: const Duration(milliseconds: 250),
            builder: clockBuilder,
          ),
        ),
      );
      expect(find.text('0:10.0', findRichText: true), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 250));
      expect(find.text('0:10.0', findRichText: true), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('0:09.9', findRichText: true), findsOneWidget);
    });

    testWidgets('compensates for UI lag', (WidgetTester tester) async {
      final now = clock.clock.now();
      await tester.pump(const Duration(milliseconds: 100));

      await tester.pumpWidget(
        MaterialApp(
          home: CountdownClockBuilder(
            timeLeft: const Duration(seconds: 10),
            active: true,
            delay: const Duration(milliseconds: 200),
            clockUpdatedAt: now,
            builder: clockBuilder,
          ),
        ),
      );
      expect(find.text('0:10.0', findRichText: true), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('0:10.0', findRichText: true), findsOneWidget);

      // delay was 200ms but UI lagged 100ms so with the compensation the clock has started already
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('0:09.9', findRichText: true), findsOneWidget);
    });

    testWidgets('UI lag negative start delay', (WidgetTester tester) async {
      final now = clock.clock.now();
      await tester.pump(const Duration(milliseconds: 200));

      await tester.pumpWidget(
        MaterialApp(
          home: CountdownClockBuilder(
            timeLeft: const Duration(seconds: 10),
            active: true,
            delay: const Duration(milliseconds: 100),
            clockUpdatedAt: now,
            builder: clockBuilder,
          ),
        ),
      );
      // delay was 100ms but UI lagged 200ms so the clock time is already 100ms ahead
      expect(find.text('0:09.9', findRichText: true), findsOneWidget);
    });
  });
}
