import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/common/game.dart';
import 'package:lichess_mobile/src/model/coordinate_training/coordinate_training_controller.dart';
import 'package:lichess_mobile/src/model/coordinate_training/coordinate_training_preferences.dart';
import 'package:lichess_mobile/src/view/coordinate_training/coordinate_training_screen.dart';

import '../../test_helpers.dart';
import '../../test_provider_scope.dart';

void main() {
  group('Coordinate Training', () {
    testWidgets('Initial state when started in FindSquare mode', (tester) async {
      final app = await makeTestProviderScopeApp(tester, home: const CoordinateTrainingScreen());
      await tester.pumpWidget(app);

      await tester.tap(find.text('Start Training'));
      await tester.pumpAndSettle();

      final container = ProviderScope.containerOf(tester.element(find.byType(Chessboard)));
      final controllerProvider = coordinateTrainingControllerProvider;

      final trainingPrefsNotifier = container.read(coordinateTrainingPreferencesProvider.notifier);
      trainingPrefsNotifier.setMode(TrainingMode.findSquare);
      await tester.pumpAndSettle();

      expect(container.read(controllerProvider).score, 0);
      expect(container.read(controllerProvider).currentCoord, isNotNull);
      expect(container.read(controllerProvider).nextCoord, isNotNull);
      expect(container.read(controllerProvider).trainingActive, true);

      // Current and next coordinate prompt should be displayed
      expect(find.text(container.read(controllerProvider).currentCoord!.name), findsOneWidget);
      expect(find.text(container.read(controllerProvider).nextCoord!.name), findsOneWidget);
    });

    testWidgets('Tap wrong square', (tester) async {
      final app = await makeTestProviderScopeApp(tester, home: const CoordinateTrainingScreen());
      await tester.pumpWidget(app);

      final container = ProviderScope.containerOf(tester.element(find.byType(Chessboard)));
      final trainingPrefsNotifier = container.read(coordinateTrainingPreferencesProvider.notifier);
      trainingPrefsNotifier.setMode(TrainingMode.findSquare);
      trainingPrefsNotifier.setSideChoice(SideChoice.white);

      await tester.tap(find.text('Start Training'));
      await tester.pumpAndSettle();

      final controllerProvider = coordinateTrainingControllerProvider;

      final currentCoord = container.read(controllerProvider).currentCoord;
      final nextCoord = container.read(controllerProvider).nextCoord;

      final wrongCoord = Square.values[(currentCoord! + 1) % Square.values.length];

      await tester.tapAt(squareOffset(wrongCoord, tester.getRect(find.byType(Chessboard))));
      await tester.pump();

      expect(container.read(controllerProvider).score, 0);
      expect(container.read(controllerProvider).currentCoord, currentCoord);
      expect(container.read(controllerProvider).nextCoord, nextCoord);
      expect(container.read(controllerProvider).trainingActive, true);

      expect(find.byKey(ValueKey('${wrongCoord.name}-highlight')), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byKey(ValueKey('${wrongCoord.name}-highlight')), findsNothing);
    });

    testWidgets('Tap correct square', (tester) async {
      final app = await makeTestProviderScopeApp(tester, home: const CoordinateTrainingScreen());
      await tester.pumpWidget(app);

      final container = ProviderScope.containerOf(tester.element(find.byType(Chessboard)));
      final trainingPrefsNotifier = container.read(coordinateTrainingPreferencesProvider.notifier);
      trainingPrefsNotifier.setMode(TrainingMode.findSquare);
      trainingPrefsNotifier.setSideChoice(SideChoice.white);

      final controllerProvider = coordinateTrainingControllerProvider;

      await tester.tap(find.text('Start Training'));
      await tester.pumpAndSettle();

      final currentCoord = container.read(controllerProvider).currentCoord;
      final nextCoord = container.read(controllerProvider).nextCoord;

      await tester.tapAt(squareOffset(currentCoord!, tester.getRect(find.byType(Chessboard))));

      await tester.pump();

      expect(find.byKey(ValueKey('${currentCoord.name}-highlight')), findsOneWidget);

      expect(container.read(controllerProvider).score, 1);
      expect(container.read(controllerProvider).currentCoord, nextCoord);
      expect(container.read(controllerProvider).trainingActive, true);

      await tester.pumpAndSettle(const Duration(milliseconds: 300));
      expect(find.byKey(ValueKey('${currentCoord.name}-highlight')), findsNothing);

      expect(find.text(container.read(controllerProvider).currentCoord!.name), findsOneWidget);
      expect(find.text(container.read(controllerProvider).nextCoord!.name), findsOneWidget);
    });
  });
}
