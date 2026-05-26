import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:signal_strength_indicator/signal_strength_indicator.dart';

void main() {
  group('LagIndicator', () {
    // lagRating=0 requires a size >= 30 to avoid SpinKitThreeBounce overflow
    // (SpinKitThreeBounce internally sizes to Size(bounceSize * 2, bounceSize) = Size(30, 15))
    testWidgets('shows loading indicator when lagRating is 0', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: LagIndicator(lagRating: 0, size: 40.0))),
      );

      expect(find.byType(SpinKitThreeBounce), findsOneWidget);
      expect(find.byType(SignalStrengthIndicator), findsOneWidget);
    });

    testWidgets('does not show loading indicator when lagRating is > 0', (
      WidgetTester tester,
    ) async {
      for (final rating in [1, 2, 3, 4]) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: LagIndicator(lagRating: rating)),
          ),
        );

        expect(find.byType(SpinKitThreeBounce), findsNothing, reason: 'lagRating=$rating');
        expect(find.byType(SignalStrengthIndicator), findsOneWidget, reason: 'lagRating=$rating');
      }
    });

    testWidgets('respects the size parameter', (WidgetTester tester) async {
      const testSize = 32.0;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: LagIndicator(lagRating: 2, size: testSize)),
        ),
      );

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).first);
      expect(sizedBox.width, testSize);
      expect(sizedBox.height, testSize);
    });

    testWidgets('uses default size of 20.0', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: LagIndicator(lagRating: 1))));

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).first);
      expect(sizedBox.width, 20.0);
      expect(sizedBox.height, 20.0);
    });

    test('throws assertion for lagRating below 0', () {
      expect(() => LagIndicator(lagRating: -1), throwsA(isA<AssertionError>()));
    });

    test('throws assertion for lagRating above 4', () {
      expect(() => LagIndicator(lagRating: 5), throwsA(isA<AssertionError>()));
    });
  });
}
