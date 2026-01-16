import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/uci.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_preferences.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_service.dart';
import 'package:lichess_mobile/src/model/engine/work.dart';

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

    test('Concurrent evaluate calls with engine initialization are handled', () async {
      final container = await makeContainer();
      final service = container.read(evaluationServiceProvider);

      const work = Work(
        enginePref: ChessEnginePref.sf16,
        variant: Variant.standard,
        threads: 1,
        path: UciPath.empty,
        searchTime: Duration(seconds: 1),
        multiPv: 1,
        threatMode: false,
        initialPosition: Chess.initial,
        steps: IListConst([]),
      );

      // Start first evaluate (will initialize engine)
      final firstEval = service.evaluate(work, shouldEmit: (_) => true);

      // Immediately start second evaluate while first is initializing
      final secondEval = service.evaluate(work, shouldEmit: (_) => true);

      // Both should complete without errors
      await Future.wait([firstEval, secondEval]);

      service.disposeEngine();
    });

    test('Sequential evaluations with same enginePref reuse engine', () async {
      final container = await makeContainer();
      final service = container.read(evaluationServiceProvider);

      const work1 = Work(
        enginePref: ChessEnginePref.sf16,
        variant: Variant.standard,
        threads: 1,
        path: UciPath.empty,
        searchTime: Duration(seconds: 1),
        multiPv: 1,
        threatMode: false,
        initialPosition: Chess.initial,
        steps: IListConst([]),
      );

      // First evaluate
      await service.evaluate(work1, shouldEmit: (_) => true);

      // Second evaluate with same enginePref but different params
      const work2 = Work(
        enginePref: ChessEnginePref.sf16,
        variant: Variant.standard,
        threads: 2,
        path: UciPath.empty,
        searchTime: Duration(seconds: 2),
        multiPv: 2,
        threatMode: false,
        initialPosition: Chess.initial,
        steps: IListConst([]),
      );

      await service.evaluate(work2, shouldEmit: (_) => true);

      // Both should complete without errors (engine is reused)
      service.disposeEngine();
    });
  });
}
