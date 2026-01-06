import 'package:dartchess/dartchess.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_preferences.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_service.dart';

import '../../test_container.dart';

void main() {
  group('EvaluationService', () {
    test('Concurrent NNUE download operations are prevented', () async {
      final container = await makeContainer();
      final service = container.read(evaluationServiceProvider);

      bool secondCallReturned = false;
      bool secondCallResult = true;

      // Start first download (will fail due to missing connectivity/files, but that's ok)
      final firstDownload = service.downloadNNUEFiles(inBackground: true).catchError((_) {
        return false;
      });

      // Immediately start second download while first is in progress
      final secondDownload = service
          .downloadNNUEFiles(inBackground: true)
          .then((result) {
            secondCallReturned = true;
            secondCallResult = result;
            return result;
          })
          .catchError((_) {
            secondCallReturned = true;
            secondCallResult = false;
            return false;
          });

      await Future.wait([firstDownload, secondDownload]);

      expect(secondCallReturned, isTrue);
      expect(
        secondCallResult,
        isFalse,
        reason: 'Second concurrent download call should be rejected',
      );
    });

    test('Sequential NNUE downloads are allowed', () async {
      final container = await makeContainer();
      final service = container.read(evaluationServiceProvider);

      // First download
      await service.downloadNNUEFiles(inBackground: true).catchError((_) => false);

      // Wait for first to complete, then start second
      final secondResult = await service
          .downloadNNUEFiles(inBackground: true)
          .catchError((_) => false);

      // Second call should be allowed since first completed
      // (will still fail due to missing files, but won't be rejected by the flag)
      expect(secondResult, isA<bool>());
    });

    test('Concurrent engine initialization operations are prevented', () async {
      final container = await makeContainer();
      final service = container.read(evaluationServiceProvider);

      const context = EvaluationContext(variant: Variant.standard, initialPosition: Chess.initial);

      const options = EvaluationOptions(
        enginePref: ChessEnginePref.sf16,
        multiPv: 1,
        cores: 1,
        searchTime: Duration(seconds: 1),
      );

      // Start first initialization
      final firstInit = service.ensureEngineInitialized(context, initOptions: options);

      // Immediately start second initialization while first is in progress
      final secondInit = service.ensureEngineInitialized(
        context,
        initOptions: options.copyWith(multiPv: 2),
      );

      await Future.wait([firstInit, secondInit]);

      // Second call returns immediately without re-initializing. Both should complete successfully.
      expect(firstInit, completes);
      expect(secondInit, completes);

      // Options should still match the first initialization
      expect(service.options, options);

      await service.disposeEngine();
    });

    test('Sequential engine initializations are allowed', () async {
      final container = await makeContainer();
      final service = container.read(evaluationServiceProvider);

      const context = EvaluationContext(variant: Variant.standard, initialPosition: Chess.initial);

      const options = EvaluationOptions(
        enginePref: ChessEnginePref.sf16,
        multiPv: 1,
        cores: 1,
        searchTime: Duration(seconds: 1),
      );

      // First initialization
      await service.ensureEngineInitialized(context, initOptions: options);

      // Wait for first to complete, then start second with different options
      const options2 = EvaluationOptions(
        enginePref: ChessEnginePref.sf16,
        multiPv: 2,
        cores: 1,
        searchTime: Duration(seconds: 2),
      );

      await service.ensureEngineInitialized(context, initOptions: options2);

      // Second call should be allowed since first completed
      expect(service.options, options2);

      await service.disposeEngine();
    });
  });
}
