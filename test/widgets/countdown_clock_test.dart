import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/common/service/sound_service.dart';
import 'package:lichess_mobile/src/widgets/countdown_clock.dart';
import 'package:mocktail/mocktail.dart';

import '../test_provider_scope.dart';

class MockSoundService extends Mock implements SoundService {}

void main() {
  setUpAll(() {
    registerFallbackValue(MockSoundService());
  });

  testWidgets('does not tick when not active', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: CountdownClock(
          timeLeft: Duration(seconds: 10),
          active: false,
        ),
      ),
    );

    expect(find.text('0:10', findRichText: true), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    expect(find.text('0:10', findRichText: true), findsOneWidget);
  });

  testWidgets('ticks when active', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: CountdownClock(
          timeLeft: Duration(seconds: 10),
          active: true,
        ),
      ),
    );

    expect(find.text('0:10', findRichText: true), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('0:09.9', findRichText: true), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('0:09.8', findRichText: true), findsOneWidget);
    await tester.pump(const Duration(seconds: 10));
    expect(find.text('0:00.0', findRichText: true), findsOneWidget);
  });

  testWidgets('ticks when active', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: CountdownClock(
          timeLeft: Duration(seconds: 10),
          active: true,
        ),
      ),
    );

    expect(find.text('0:10', findRichText: true), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('0:09.9', findRichText: true), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('0:09.8', findRichText: true), findsOneWidget);
    await tester.pump(const Duration(seconds: 10));
    expect(find.text('0:00.0', findRichText: true), findsOneWidget);
  });

  testWidgets('shows milliseconds when time < 1s and active is false',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: CountdownClock(
          timeLeft: Duration(seconds: 1),
          active: true,
        ),
      ),
    );

    expect(find.text('0:01.0', findRichText: true), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 10));
    expect(find.text('0:00.9', findRichText: true), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 10));
    expect(find.text('0:00.9', findRichText: true), findsOneWidget);

    await tester.pumpWidget(
      const MaterialApp(
        home: CountdownClock(
          timeLeft: Duration(milliseconds: 988),
          active: false,
        ),
      ),
      duration: const Duration(milliseconds: 1000),
    );

    expect(find.text('0:00.98', findRichText: true), findsOneWidget);
  });

  testWidgets('stops when active become false', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: CountdownClock(
          timeLeft: Duration(seconds: 10),
          active: true,
        ),
      ),
    );

    expect(find.text('0:10', findRichText: true), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('0:09.9', findRichText: true), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('0:09.8', findRichText: true), findsOneWidget);

    // clock is rebuilt with same time but inactive:
    // the time is kept and the clock stops counting the elapsed time
    await tester.pumpWidget(
      const MaterialApp(
        home: CountdownClock(
          timeLeft: Duration(seconds: 10),
          active: false,
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
      const MaterialApp(
        home: CountdownClock(
          timeLeft: Duration(seconds: 10),
          active: true,
          delay: Duration(milliseconds: 25),
        ),
      ),
    );
    expect(find.text('0:10', findRichText: true), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 25));
    expect(find.text('0:10', findRichText: true), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.text('0:09.9', findRichText: true), findsOneWidget);
  });

  testWidgets('compensates for UI lag', (WidgetTester tester) async {
    final now = clock.now();
    await tester.pump(const Duration(milliseconds: 10));

    await tester.pumpWidget(
      MaterialApp(
        home: CountdownClock(
          timeLeft: const Duration(seconds: 10),
          active: true,
          delay: const Duration(milliseconds: 20),
          clockStartTime: now,
        ),
      ),
    );
    expect(find.text('0:10', findRichText: true), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 10));
    expect(find.text('0:10', findRichText: true), findsOneWidget);

    // delay was 20m but UI lagged 10ms so with the compensation the clock has started already
    await tester.pump(const Duration(milliseconds: 10));
    expect(find.text('0:09.9', findRichText: true), findsOneWidget);
  });

  testWidgets('UI lag negative start delay', (WidgetTester tester) async {
    final now = clock.now();
    await tester.pump(const Duration(milliseconds: 20));

    await tester.pumpWidget(
      MaterialApp(
        home: CountdownClock(
          timeLeft: const Duration(seconds: 10),
          active: true,
          delay: const Duration(milliseconds: 10),
          clockStartTime: now,
        ),
      ),
    );
    // delay was 10ms but UI lagged 20ms so the clock time is already 10ms ahead
    expect(find.text('0:09.9', findRichText: true), findsOneWidget);
  });

  testWidgets('should call onFlag', (WidgetTester tester) async {
    int flagCount = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: CountdownClock(
          timeLeft: const Duration(seconds: 10),
          active: true,
          onFlag: () {
            flagCount++;
          },
        ),
      ),
    );
    expect(find.text('0:10', findRichText: true), findsOneWidget);
    await tester.pump(const Duration(seconds: 11));
    expect(flagCount, 1);
    expect(find.text('0:00.0', findRichText: true), findsOneWidget);
  });

  testWidgets('calls onStop', (WidgetTester tester) async {
    int onStopCount = 0;
    Duration? lastOnStopTime;
    await tester.pumpWidget(
      MaterialApp(
        home: CountdownClock(
          timeLeft: const Duration(seconds: 10),
          active: true,
          onStop: (Duration timeLeft) {
            onStopCount++;
            lastOnStopTime = timeLeft;
          },
        ),
      ),
    );
    expect(find.text('0:10', findRichText: true), findsOneWidget);
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpWidget(
      MaterialApp(
        home: CountdownClock(
          timeLeft: const Duration(seconds: 10),
          active: false,
          onStop: (Duration timeLeft) {
            onStopCount++;
            lastOnStopTime = timeLeft;
          },
        ),
      ),
    );

    expect(onStopCount, 1);
    expect(lastOnStopTime, const Duration(seconds: 5));
    expect(find.text('0:05.0', findRichText: true), findsOneWidget);
  });

  testWidgets('emergency feedback', (WidgetTester tester) async {
    final mockSoundService = MockSoundService();
    when(() => mockSoundService.play(Sound.lowTime)).thenAnswer((_) async {});

    const timeLeft = Duration(seconds: 10);

    final app = await makeTestProviderScopeApp(
      tester,
      home: const CountdownClock(
        timeLeft: timeLeft,
        active: true,
        emergencyThreshold: Duration(seconds: 5),
      ),
      overrides: [
        soundServiceProvider.overrideWith((ref) => mockSoundService),
      ],
    );
    await tester.pumpWidget(app);

    expect(find.text('0:10', findRichText: true), findsOneWidget);
    await tester.pump(const Duration(seconds: 5));
    expect(find.text('0:05.0', findRichText: true), findsOneWidget);
    verifyNever(() => mockSoundService.play(Sound.lowTime));
    await tester.pump(const Duration(milliseconds: 1));
    verify(() => mockSoundService.play(Sound.lowTime)).called(1);
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('0:04.8', findRichText: true), findsOneWidget);
    // emergency is only called once as long as the time is below the threshold
    verifyNever(() => mockSoundService.play(Sound.lowTime));

    // notifier.value = const CountdownClock(
    //   timeLeft: Duration(milliseconds: 5100),
    //   active: true,
    //   emergencyThreshold: Duration(seconds: 5),
    // );
    // await tester.pump();
    // expect(find.text('0:05.1', findRichText: true), findsOneWidget);
    // await tester.pump(const Duration(milliseconds: 150));
    // expect(find.text('0:04.9', findRichText: true), findsOneWidget);
    // // emergency is called again after the threshold is passed
    // verify(() => mockSoundService.play(Sound.lowTime)).called(1);
  });
}
