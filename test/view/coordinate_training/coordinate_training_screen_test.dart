import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/common/game.dart';
import 'package:lichess_mobile/src/model/coordinate_training/coordinate_training_controller.dart';
import 'package:lichess_mobile/src/model/coordinate_training/coordinate_training_preferences.dart';
import 'package:lichess_mobile/src/view/coordinate_training/coordinate_training_screen.dart';

import '../../test_helpers.dart';
import '../../test_provider_scope.dart';

/// Returns true if the board has a highlight on [square].
bool _boardHasHighlight(WidgetTester tester, Square square) {
  return findBoardHighlightPainter(tester).squareHighlights.containsKey(square);
}

void main() {
  group('Coordinate Training', () {
    testWidgets('Initial state when started in FindSquare mode', (tester) async {
      final app = await makeTestProviderScopeApp(tester, home: const CoordinateTrainingScreen());
      await tester.pumpWidget(app);

      await tester.tap(find.text('Start training'));
      await tester.pumpAndSettle();

      final container = ProviderScope.containerOf(tester.element(find.byType(StaticChessboard)));
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

      final container = ProviderScope.containerOf(tester.element(find.byType(StaticChessboard)));
      final trainingPrefsNotifier = container.read(coordinateTrainingPreferencesProvider.notifier);
      trainingPrefsNotifier.setMode(TrainingMode.findSquare);
      trainingPrefsNotifier.setSideChoice(SideChoice.white);

      await tester.tap(find.text('Start training'));
      await tester.pumpAndSettle();

      final controllerProvider = coordinateTrainingControllerProvider;

      final currentCoord = container.read(controllerProvider).currentCoord;
      final nextCoord = container.read(controllerProvider).nextCoord;

      final wrongCoord = Square.values[(currentCoord! + 1) % Square.values.length];

      await tester.tapAt(squareOffset(wrongCoord, tester.getRect(find.byType(StaticChessboard))));
      await tester.pump();

      expect(container.read(controllerProvider).score, 0);
      expect(container.read(controllerProvider).currentCoord, currentCoord);
      expect(container.read(controllerProvider).nextCoord, nextCoord);
      expect(container.read(controllerProvider).trainingActive, true);

      expect(_boardHasHighlight(tester, wrongCoord), isTrue);

      await tester.pump(const Duration(milliseconds: 300));
      expect(_boardHasHighlight(tester, wrongCoord), isFalse);
    });

    testWidgets('Tap correct square', (tester) async {
      final app = await makeTestProviderScopeApp(tester, home: const CoordinateTrainingScreen());
      await tester.pumpWidget(app);

      final container = ProviderScope.containerOf(tester.element(find.byType(StaticChessboard)));
      final trainingPrefsNotifier = container.read(coordinateTrainingPreferencesProvider.notifier);
      trainingPrefsNotifier.setMode(TrainingMode.findSquare);
      trainingPrefsNotifier.setSideChoice(SideChoice.white);

      final controllerProvider = coordinateTrainingControllerProvider;

      await tester.tap(find.text('Start training'));
      await tester.pumpAndSettle();

      final currentCoord = container.read(controllerProvider).currentCoord;
      final nextCoord = container.read(controllerProvider).nextCoord;

      await tester.tapAt(
        squareOffset(currentCoord!, tester.getRect(find.byType(StaticChessboard))),
      );

      await tester.pump();

      expect(_boardHasHighlight(tester, currentCoord), isTrue);

      expect(container.read(controllerProvider).score, 1);
      expect(container.read(controllerProvider).currentCoord, nextCoord);
      expect(container.read(controllerProvider).trainingActive, true);

      await tester.pumpAndSettle(const Duration(milliseconds: 300));
      expect(_boardHasHighlight(tester, currentCoord), isFalse);

      expect(find.text(container.read(controllerProvider).currentCoord!.name), findsOneWidget);
      expect(find.text(container.read(controllerProvider).nextCoord!.name), findsOneWidget);
    });

    testWidgets('a score of 20 or more fits in its square with a large text size', (tester) async {
      // Regression test for https://github.com/lichess-org/mobile/issues/3871: with a large text
      // size, a two-digit score wrapped on two lines and the second digit was drawn outside of
      // the square, white on the light background, so only "2" could be seen.
      final app = await makeTestProviderScopeApp(
        tester,
        home: Builder(
          builder: (context) => MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.5)),
            child: const CoordinateTrainingScreen(),
          ),
        ),
      );
      await tester.pumpWidget(app);

      final container = ProviderScope.containerOf(tester.element(find.byType(StaticChessboard)));
      final trainingPrefsNotifier = container.read(coordinateTrainingPreferencesProvider.notifier);
      trainingPrefsNotifier.setMode(TrainingMode.findSquare);
      trainingPrefsNotifier.setSideChoice(SideChoice.white);

      await tester.tap(find.text('Start training'));
      await tester.pumpAndSettle();

      for (var i = 0; i < 20; i++) {
        final currentCoord = container.read(coordinateTrainingControllerProvider).currentCoord;
        await tester.tapAt(
          squareOffset(currentCoord!, tester.getRect(find.byType(StaticChessboard))),
        );
        await tester.pump();
      }
      expect(container.read(coordinateTrainingControllerProvider).score, 20);

      // Where each digit is actually drawn, in global coordinates: the Text's own box is clamped
      // to the square, but the glyphs of an overflowing paragraph are painted outside of it.
      final scoreText = find.text('20');
      final paragraph = tester.renderObject<RenderParagraph>(scoreText);
      final digitRects = paragraph
          .getBoxesForSelection(const TextSelection(baseOffset: 0, extentOffset: 2))
          .map((box) => MatrixUtils.transformRect(paragraph.getTransformTo(null), box.toRect()));
      final squareRect = tester.getRect(
        find.ancestor(of: scoreText, matching: find.byType(Container)).first,
      );

      expect(digitRects, isNotEmpty);
      expect(
        digitRects.map((r) => r.top).toSet(),
        hasLength(1),
        reason: 'both digits must be on the same line: $digitRects',
      );
      for (final rect in digitRects) {
        expect(
          squareRect.inflate(0.5).intersect(rect) == rect,
          isTrue,
          reason: 'digit $rect must be drawn inside the score square $squareRect',
        );
      }
    });
  });
}
