import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_preferences.dart';
import 'package:lichess_mobile/src/model/settings/preferences_storage.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/service/weights_service.dart';
import 'package:lichess_mobile/src/view/settings/engine_settings_screen.dart';

import '../../model/auth/fake_auth_storage.dart';
import '../../model/engine/fake_external_engines.dart';
import '../../model/engine/fake_stockfish_nnue_service.dart';
import '../../test_provider_scope.dart';

Future<ProviderContainer> _pumpScreen(
  WidgetTester tester, {
  ChessEnginePref enginePref = ChessEnginePref.sfLight,
  String? externalEngineId,
}) async {
  final app = await makeTestProviderScopeApp(
    tester,
    defaultPreferences: {
      PrefCategory.engineEvaluation.storageKey: jsonEncode(
        EngineEvaluationPrefState.defaults
            .copyWith(enginePref: enginePref, externalEngineId: externalEngineId)
            .toJson(),
      ),
    },
    overrides: {
      stockfishNnueServiceProvider: stockfishNnueServiceProvider.overrideWithValue(
        FakeStockfishNnueServiceUnavailable(),
      ),
      httpClientFactoryProvider: httpClientFactoryProvider.overrideWith(
        (ref) => externalEnginesClientFactory([testExternalEngine]),
      ),
    },
    authUser: fakeAuthUser,
    home: const EngineSettingsScreen(),
  );
  await tester.pumpWidget(app);
  await tester.pumpAndSettle();
  return ProviderScope.containerOf(tester.element(find.byType(EngineSettingsScreen)));
}

void main() {
  testWidgets('offers the registered engines beside Stockfish', (tester) async {
    final container = await _pumpScreen(tester);

    await tester.tap(find.text(ChessEnginePref.sfLight.label));
    await tester.pumpAndSettle();
    await tester.tap(find.text('External Stockfish'));
    await tester.pumpAndSettle();

    expect(
      container.read(engineEvaluationPreferencesProvider).externalEngineId,
      testExternalEngine.id,
    );
    expect(find.text('External Stockfish'), findsOne);
  });

  testWidgets('choosing a Stockfish clears the external engine', (tester) async {
    final container = await _pumpScreen(tester, externalEngineId: testExternalEngine.id);

    await tester.tap(find.text('External Stockfish'));
    await tester.pumpAndSettle();
    await tester.tap(find.text(ChessEnginePref.sfLight.label));
    await tester.pumpAndSettle();

    final prefs = container.read(engineEvaluationPreferencesProvider);
    expect(prefs.externalEngineId, isNull);
    expect(prefs.enginePref, ChessEnginePref.sfLight);
  });

  testWidgets('hides the NNUE download once an external engine is chosen', (tester) async {
    await _pumpScreen(tester, enginePref: ChessEnginePref.sfLatest);
    expect(find.text('Download NNUE file'), findsOne);

    await tester.tap(find.text(ChessEnginePref.sfLatest.label));
    await tester.pumpAndSettle();
    await tester.tap(find.text('External Stockfish'));
    await tester.pumpAndSettle();

    expect(find.text('Download NNUE file'), findsNothing);
  });
}
