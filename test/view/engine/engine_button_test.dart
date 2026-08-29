import 'package:chessground/chessground.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_mixin.dart';
import 'package:lichess_mobile/src/model/engine/position_evaluator.dart';
import 'package:lichess_mobile/src/view/engine/engine_button.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:material_ui/material_ui.dart';

import '../../model/engine/fake_engine.dart';
import 'test_engine_app.dart';

void main() {
  testWidgets('Engine button is not displayed if computer analysis is not allowed', (tester) async {
    await makeEngineTestApp(tester, isComputerAnalysisAllowed: false);
    expect(find.byType(EngineButton), findsNothing);
  });

  testWidgets('Engine starts immediately after the request eval delay', (tester) async {
    // loads a finished game, disable cloud eval because it is ususally not availabe in mid/end game
    await makeEngineTestApp(tester, isCloudEvalEnabled: false, gameId: const GameId('xze7RH66'));

    expect(find.byType(CircularProgressIndicator), findsOne);
    // wait for the game to be loaded
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(Chessboard), findsOne);
    expect(find.byType(EngineButton), findsOne);

    // engine not yet started, so it still displays initial state
    expect(find.widgetWithText(EngineButton, '-'), findsOne);

    // wait for engine
    await tester.pump(kRequestEvalDebounceDelay + kEngineEvalEmissionThrottleDelay);
    expect(find.widgetWithText(EngineButton, '16'), findsOne);
  });

  testWidgets('No engine is started when the user has turned the engine off', (tester) async {
    final stockfish = FakeEngine();
    await makeEngineTestApp(
      tester,
      isEngineEnabled: false,
      isCloudEvalEnabled: false,
      gameId: const GameId('xze7RH66'),
      stockfish: stockfish,
    );
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pump(kRequestEvalDebounceDelay + kEngineEvalEmissionThrottleDelay);

    // Opening a screen with the engine off asks for no evaluation, so no engine is ever created:
    // an engine nobody is going to use must not be started, on this screen or the next.
    expect(stockfish.startCount, 0);
  });

  testWidgets('Long pressing the engine button opens the engine popup', (tester) async {
    await makeEngineTestApp(tester, isCloudEvalEnabled: false, gameId: const GameId('xze7RH66'));
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pump(kRequestEvalDebounceDelay + kEngineEvalEmissionThrottleDelay);

    await tester.longPress(
      find.descendant(of: find.byType(EngineButton), matching: find.byType(SemanticIconButton)),
    );
    await tester.pumpAndSettle();

    // The popup lists the engine in a ListTile, which needs a Material ancestor.
    expect(
      find.descendant(of: find.byType(ListTile), matching: find.textContaining('Stockfish')),
      findsOne,
    );
  });
}
