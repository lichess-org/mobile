import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart' show GlassToast;
import 'package:material_ui/material_ui.dart';
import 'package:signal_strength_indicator/signal_strength_indicator.dart';

import '../test_provider_scope.dart';

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

    testWidgets('does not show loading indicator when lagRating is 0 but inactive', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: LagIndicator(lagRating: 0, isActive: false, size: 40.0)),
        ),
      );

      expect(find.byType(SpinKitThreeBounce), findsNothing);
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

  group('showSnackBar', () {
    Future<void> pumpApp(WidgetTester tester, void Function(BuildContext) onPressed) async {
      final app = await makeTestProviderScopeApp(
        tester,
        home: Scaffold(
          body: Builder(
            builder: (context) => Center(
              child: ElevatedButton(onPressed: () => onPressed(context), child: const Text('Show')),
            ),
          ),
        ),
      );
      await tester.pumpWidget(app);
    }

    testWidgets(
      'shows a glass toast on iOS, replaced by the next one and dismissed after a while',
      (WidgetTester tester) async {
        var count = 0;
        await pumpApp(tester, (context) => showSnackBar(context, 'Message ${++count}'));

        await tester.tap(find.text('Show'));
        await tester.pumpAndSettle();
        expect(find.byType(SnackBar), findsNothing);
        expect(find.byType(GlassToast), findsOneWidget);
        expect(find.text('Message 1'), findsOneWidget);

        await tester.tap(find.text('Show'));
        await tester.pumpAndSettle();
        expect(find.byType(GlassToast), findsOneWidget);
        expect(find.text('Message 1'), findsNothing);
        expect(find.text('Message 2'), findsOneWidget);

        await tester.pump(const Duration(seconds: 4));
        await tester.pumpAndSettle();
        expect(find.byType(GlassToast), findsNothing);
      },
      variant: const TargetPlatformVariant({TargetPlatform.iOS}),
    );

    testWidgets('shows a Material snackbar on Android', (WidgetTester tester) async {
      await pumpApp(tester, (context) => showSnackBar(context, 'Message'));

      await tester.tap(find.text('Show'));
      await tester.pumpAndSettle();
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.byType(GlassToast), findsNothing);
      expect(find.text('Message'), findsOneWidget);
    }, variant: const TargetPlatformVariant({TargetPlatform.android}));
  });
}
