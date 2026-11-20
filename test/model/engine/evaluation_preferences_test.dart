import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_preferences.dart';

import '../../test_container.dart';

void main() {
  group('EngineEvaluationPreferences external engine', () {
    test('no external engine is chosen by default', () async {
      final container = await makeContainer();

      expect(container.read(engineEvaluationPreferencesProvider).externalEngineId, isNull);
    });

    test('a chosen external engine is read back, and choosing none clears it', () async {
      final container = await makeContainer();
      final notifier = container.read(engineEvaluationPreferencesProvider.notifier);

      await notifier.setExternalEngine('eei_aTKImBJOnv6j');
      expect(
        container.read(engineEvaluationPreferencesProvider).externalEngineId,
        'eei_aTKImBJOnv6j',
      );

      await notifier.setExternalEngine(null);
      expect(container.read(engineEvaluationPreferencesProvider).externalEngineId, isNull);
    });

    test('preferences stored before the external engine existed still load', () {
      final state = EngineEvaluationPrefState.fromJson({
        'isEnabled': true,
        'numEvalLines': 2,
        'numEngineCores': 1,
        'engineSearchTime': 4,
        'enginePref': 'sfLight',
      });

      expect(state.externalEngineId, isNull);
      expect(state.numEvalLines, 2);
    });

    test('the chosen external engine survives a round trip through json', () {
      final state = EngineEvaluationPrefState.defaults.copyWith(
        externalEngineId: 'eei_aTKImBJOnv6j',
      );

      expect(EngineEvaluationPrefState.fromJson(state.toJson()), state);
    });
  });
}
