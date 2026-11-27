import 'dart:convert';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_preferences.dart';
import 'package:lichess_mobile/src/model/engine/external_engine.dart';
import 'package:lichess_mobile/src/model/settings/preferences_storage.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/view/analysis/engine_settings_widget.dart';
import 'package:material_ui/material_ui.dart';

import '../../model/auth/fake_auth_storage.dart';
import '../../model/engine/fake_external_engines.dart';
import '../../test_provider_scope.dart';

Future<void> _pumpWidget(
  WidgetTester tester, {
  IList<ExternalEngine> engines = const IListConst([]),
  String? externalEngineId,
}) async {
  final app = await makeTestProviderScopeApp(
    tester,
    defaultPreferences: {
      PrefCategory.engineEvaluation.storageKey: jsonEncode(
        EngineEvaluationPrefState.defaults.copyWith(externalEngineId: externalEngineId).toJson(),
      ),
    },
    overrides: {
      httpClientFactoryProvider: httpClientFactoryProvider.overrideWith(
        (ref) => externalEnginesClientFactory(engines),
      ),
    },
    authUser: fakeAuthUser,
    home: Scaffold(
      body: ListView(
        children: [EngineSettingsWidget(onSetEngineSearchTime: (_) {}, onSetEngineCores: (_) {})],
      ),
    ),
  );

  await tester.pumpWidget(app);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Hides this device threads while an external engine is chosen', (tester) async {
    await _pumpWidget(
      tester,
      engines: const IListConst([testExternalEngine]),
      externalEngineId: testExternalEngine.id,
    );

    expect(find.text('Threads'), findsNothing);
  });
}
