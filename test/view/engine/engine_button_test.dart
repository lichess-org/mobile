import 'package:chessground/chessground.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_mixin.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_service.dart';
import 'package:lichess_mobile/src/view/engine/engine_button.dart';

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

    // engine not yet started, so it still displays loading indicator
    expect(
      find.descendant(of: find.byType(EngineButton), matching: find.byType(SpinKitFadingFour)),
      findsOne,
    );

    // wait for engine
    await tester.pump(kRequestEvalDebounceDelay + kEngineEvalEmissionThrottleDelay);
    expect(find.widgetWithText(EngineButton, '16'), findsOne);
  });
}
