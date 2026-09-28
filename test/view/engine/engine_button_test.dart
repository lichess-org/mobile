import 'dart:convert';

import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/engine/engine_spec.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_mixin.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_preferences.dart';
import 'package:lichess_mobile/src/model/engine/position_evaluator.dart';
import 'package:lichess_mobile/src/model/settings/preferences_storage.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/view/engine/engine_button.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart' show GlassPopover;
import 'package:material_ui/material_ui.dart';

import '../../model/auth/fake_auth_storage.dart';
import '../../model/engine/fake_engine.dart';
import '../../model/engine/fake_external_engines.dart';
import '../../test_provider_scope.dart';
import 'test_engine_app.dart';

void main() {
  testWidgets('Engine button is not displayed if computer analysis is not allowed', (tester) async {
    await makeEngineTestApp(tester, isComputerAnalysisAllowed: false);
    expect(find.byType(EngineButton), findsNothing);
  });

  testWidgets('Engine starts immediately after the request eval delay', (tester) async {
    // loads a finished game, disable cloud eval because it is usually not available in mid/end game
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

  testWidgets('The engine popup is an opaque glass popover on iOS', (tester) async {
    await makeEngineTestApp(tester, isCloudEvalEnabled: false, gameId: const GameId('xze7RH66'));
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pump(kRequestEvalDebounceDelay + kEngineEvalEmissionThrottleDelay);

    final popover = tester.widget<GlassPopover>(find.byType(GlassPopover));
    expect(popover.settings?.glassColor.a, 1.0);
  }, variant: const TargetPlatformVariant({TargetPlatform.iOS}));

  testWidgets('The engine button names an external engine and badges it', (tester) async {
    const engine = testExternalEngine;
    const filters = (
      context: EvaluationContext(
        id: StringId('test'),
        variant: Variant.standard,
        initialPosition: Chess.initial,
      ),
      path: null,
    );

    final app = await makeTestProviderScopeApp(
      tester,
      overrides: {
        engineEvaluationProvider: engineEvaluationProvider.overrideWith(
          (ref, _) => (
            engine: const AsyncData('External Stockfish'),
            engineSpec: const ExternalEngineSpec(engine),
            eval: null,
            isComputing: false,
            currentWork: null,
          ),
        ),
      },
      home: Scaffold(
        body: Center(
          child: EngineButton(filters: filters, onTap: () {}),
        ),
      ),
    );
    await tester.pumpWidget(app);
    // Not pumpAndSettle: with no eval yet the button spins a loading indicator forever.
    await tester.pump();

    expect(find.widgetWithText(EngineButton, 'EXT'), findsOne);
    expect(find.widgetWithText(EngineButton, 'External Stockfish'), findsOne);

    await tester.longPress(
      find.descendant(of: find.byType(EngineButton), matching: find.byType(SemanticIconButton)),
    );
    await tester.pump();
    await tester.pump();

    expect(
      find.descendant(of: find.byType(ListTile), matching: find.text('External Stockfish')),
      findsOne,
    );
  });

  testWidgets('A disabled engine button still names the external engine chosen', (tester) async {
    const filters = (
      context: EvaluationContext(
        id: StringId('test'),
        variant: Variant.standard,
        initialPosition: Chess.initial,
      ),
      path: null,
    );

    final app = await makeTestProviderScopeApp(
      tester,
      defaultPreferences: {
        PrefCategory.engineEvaluation.storageKey: jsonEncode(
          EngineEvaluationPrefState.defaults
              .copyWith(isEnabled: false, externalEngineId: testExternalEngine.id)
              .toJson(),
        ),
      },
      overrides: {
        httpClientFactoryProvider: httpClientFactoryProvider.overrideWith(
          (ref) => externalEnginesClientFactory([testExternalEngine]),
        ),
        engineEvaluationProvider: engineEvaluationProvider.overrideWith(
          (ref, _) =>
              (engine: null, engineSpec: null, eval: null, isComputing: false, currentWork: null),
        ),
      },
      authUser: fakeAuthUser,
      home: Scaffold(
        body: Center(
          child: EngineButton(filters: filters, onTap: () {}),
        ),
      ),
    );
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    expect(find.widgetWithText(EngineButton, 'External Stockfish'), findsOne);
    expect(find.text('EXT'), findsNothing);

    await tester.longPress(
      find.descendant(of: find.byType(EngineButton), matching: find.byType(SemanticIconButton)),
    );
    await tester.pumpAndSettle();

    expect(
      find.descendant(of: find.byType(ListTile), matching: find.text('External Stockfish')),
      findsOne,
    );
  });

  testWidgets('A long external engine name fits the bottom bar', (tester) async {
    const name = 'Personal MBP | stockfish 17.1 with 32 threads, 4 GB of hash and a long name';
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    final engine = testExternalEngine.copyWith(name: name);
    const filters = (
      context: EvaluationContext(
        id: StringId('test'),
        variant: Variant.standard,
        initialPosition: Chess.initial,
      ),
      path: null,
    );

    final app = await makeTestProviderScopeApp(
      tester,
      overrides: {
        engineEvaluationProvider: engineEvaluationProvider.overrideWith(
          (ref, _) => (
            engine: const AsyncData(name),
            engineSpec: ExternalEngineSpec(engine),
            eval: null,
            isComputing: false,
            currentWork: null,
          ),
        ),
      },
      home: Scaffold(
        bottomNavigationBar: BottomBar(
          cupertinoGlass: true,
          children: [
            BottomBarButton(onTap: () {}, label: 'Menu', icon: Icons.menu),
            EngineButton(filters: filters, onTap: () {}),
            BottomBarButton(onTap: () {}, label: 'Previous', icon: Icons.chevron_left),
            BottomBarButton(onTap: () {}, label: 'Next', icon: Icons.chevron_right),
          ],
        ),
      ),
    );
    await tester.pumpWidget(app);
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(tester.getSize(find.text(name)).width, lessThan(390));
  }, variant: const TargetPlatformVariant({TargetPlatform.iOS, TargetPlatform.android}));
}
