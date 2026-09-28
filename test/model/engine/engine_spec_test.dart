import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/engine/engine_slot.dart';
import 'package:lichess_mobile/src/model/engine/engine_spec.dart';

import 'fake_external_engines.dart';

void main() {
  group('ExternalEngineSpec', () {
    test('two specs for the same registration are equal, whatever the rest of the record says', () {
      const spec = ExternalEngineSpec(testExternalEngine);
      final renamed = ExternalEngineSpec(testExternalEngine.copyWith(name: 'Renamed'));

      expect(renamed, spec);
      expect(renamed.hashCode, spec.hashCode);
    });

    test('specs for two registrations are not equal', () {
      expect(
        const ExternalEngineSpec(testExternalEngine),
        isNot(ExternalEngineSpec(testExternalEngine.copyWith(id: 'eei_bMLJnCKPow7k'))),
      );
    });

    test('runs in the external slot, which is not native', () {
      const spec = ExternalEngineSpec(testExternalEngine);

      expect(spec.slot, EngineSlot.external);
      expect(spec.slot.isNative, isFalse);
    });
  });
}
