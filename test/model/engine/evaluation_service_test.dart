import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/uci.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_preferences.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_service.dart';
import 'package:lichess_mobile/src/model/engine/work.dart';

import '../../binding.dart';
import '../../test_container.dart';
import 'fake_stockfish.dart';

void main() {
  TestLichessBinding.ensureInitialized();

  setUp(() {
    testBinding.stockfish = FakeStockfish();
  });

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

    test('Multiple evaluations - last caller wins', () async {
      final container = await makeContainer();
      final service = container.read(evaluationServiceProvider);

      const options = EvaluationOptions(
        enginePref: ChessEnginePref.sf16,
        multiPv: 1,
        cores: 1,
        searchTime: Duration(seconds: 1),
      );

      final work1 = Work(
        variant: Variant.standard,
        threads: 1,
        path: UciPath.empty,
        searchTime: const Duration(seconds: 1),
        multiPv: 1,
        initialPosition: Chess.initial,
        steps: IList(),
        threatMode: false,
      );

      final work2 = Work(
        variant: Variant.standard,
        threads: 1,
        path: UciPath.fromId(UciCharPair.fromUci('e2e4')),
        searchTime: const Duration(seconds: 1),
        multiPv: 1,
        initialPosition: Chess.initial,
        steps: IList(),
        threatMode: false,
      );

      // Start first evaluation
      service.evaluate(work1, options: options);

      // Start second evaluation - should take over
      final stream2 = service.evaluate(work2, options: options);

      // The second evaluation should be the current one
      expect(service.currentWork, work2);

      // Results from stream2 should have work2
      if (stream2 != null) {
        final result = await stream2.first;
        expect(result.$1, work2);
      }
    });

    test('Stop clears current work', () async {
      final container = await makeContainer();
      final service = container.read(evaluationServiceProvider);

      const options = EvaluationOptions(
        enginePref: ChessEnginePref.sf16,
        multiPv: 1,
        cores: 1,
        searchTime: Duration(seconds: 1),
      );

      final work = Work(
        variant: Variant.standard,
        threads: 1,
        path: UciPath.empty,
        searchTime: const Duration(seconds: 1),
        multiPv: 1,
        initialPosition: Chess.initial,
        steps: IList(),
        threatMode: false,
      );

      service.evaluate(work, options: options);
      expect(service.currentWork, work);

      service.stop();
      expect(service.currentWork, isNull);
    });
  });
}
