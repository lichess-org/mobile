import 'dart:convert';
import 'dart:math' show max;

import 'package:dartchess/dartchess.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_preferences.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_preferences.dart';
import 'package:lichess_mobile/src/model/settings/preferences_storage.dart';
import 'package:lichess_mobile/src/network/socket.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_screen.dart';

import '../../network/fake_websocket_channel.dart';
import '../../test_provider_scope.dart';

/// Creates a test app to test engine evaluation with the [AnalysisScreen] and the given [testBody].
Future<void> makeEngineTestApp(
  WidgetTester tester, {
  int numEvalLines = 1,
  bool isComputerAnalysisAllowed = true,
  bool isComputerAnalysisEnabled = true,
  bool isEngineEnabled = true,
  bool isCloudEvalEnabled = true,
}) async {
  final fakeChannel = FakeWebSocketChannel(
    serverHandlers: {
      if (isCloudEvalEnabled)
        'evalGet': (json) {
          final data = json['d'] as Map<String, dynamic>;
          // final fen = data['fen'] as String;
          return {
            't': 'evalHit',
            'd': {
              'path': data['path'],
              'depth': '36',
              'pvs': [
                for (var i = 0; i < max(1, numEvalLines); i++)
                  {'moves': 'e2e4 e7e5 g1f3 b8c6 f1b5 g8f6', 'cp': '23'},
              ],
            },
          };
        },
    },
  );
  final app = await makeTestProviderScopeApp(
    tester,
    defaultPreferences: {
      PrefCategory.engineEvaluation.storageKey: jsonEncode(
        EngineEvaluationPrefState.defaults
            .copyWith(numEvalLines: numEvalLines, isEnabled: isEngineEnabled)
            .toJson(),
      ),
      PrefCategory.analysis.storageKey: jsonEncode(
        AnalysisPrefs.defaults.copyWith(enableComputerAnalysis: isComputerAnalysisEnabled).toJson(),
      ),
    },
    overrides: [
      webSocketChannelFactoryProvider.overrideWith(
        (_) => FakeWebSocketChannelFactory((_) => fakeChannel),
      ),
    ],
    home: AnalysisScreen(
      options: AnalysisOptions(
        orientation: Side.white,
        standalone: (
          pgn: '',
          isComputerAnalysisAllowed: isComputerAnalysisAllowed,
          variant: Variant.standard,
        ),
      ),
    ),
  );

  await tester.pumpWidget(app);
}
