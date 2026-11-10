import 'dart:async';

import 'package:dartchess/dartchess.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/node.dart';
import 'package:lichess_mobile/src/model/common/uci.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_mixin.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_preferences.dart';
import 'package:lichess_mobile/src/model/engine/position_evaluator.dart';
import 'package:lichess_mobile/src/model/engine/work.dart';
import 'package:lichess_mobile/src/network/socket.dart';

import '../../binding.dart';
import '../../test_container.dart';

const _testContext = EvaluationContext(
  id: StringId('eval_mixin_test'),
  variant: Variant.standard,
  initialPosition: Chess.initial,
);

/// An evaluator that does not touch any engine: it hands out controllable streams so the test can
/// observe whether the mixin keeps the returned subscription alive or cancels it.
class _FakePositionEvaluator(super.context) extends PositionEvaluator {
  /// Every stream handed out by [evaluate], in request order.
  final List<StreamController<EvalResult>> streams = [];

  @override
  EngineEvaluationState build() => PositionEvaluator.defaultState;

  @override
  Stream<EvalResult> evaluate(EvalWork work) {
    final controller = StreamController<EvalResult>.broadcast();
    streams.add(controller);
    return controller.stream.where((result) => result.$1 == work);
  }
}

class _TestState() with EvaluationMixinState<_TestState> {
  @override
  bool isEngineAvailable(EngineEvaluationPrefState prefs) => true;

  @override
  EvaluationContext get evaluationContext => _testContext;

  @override
  UciPath get currentPath => UciPath.empty;

  @override
  Position? get currentPosition => Chess.initial;

  @override
  bool get alwaysRequestCloudEval => false;

  @override
  bool get engineInThreatMode => false;

  @override
  _TestState withThreatMode(bool engineInThreatMode) => this;
}

class _TestController() extends AsyncNotifier<_TestState> with EngineEvaluationMixin<_TestState> {
  final Node _tree = Root(position: Chess.initial);

  @override
  Future<_TestState> build() async => _TestState();

  @override
  SocketClient? get socketClient => null;

  @override
  Node get positionTree => _tree;
}

final _testControllerProvider = AsyncNotifierProvider.autoDispose<_TestController, _TestState>(
  _TestController.new,
  name: 'TestEvalControllerProvider',
);

/// Lets the eval request debounce fire.
Future<void> elapseEvalDebounce() =>
    Future<void>.delayed(kRequestEvalDebounceDelay + const Duration(milliseconds: 50));

void main() {
  TestLichessBinding.ensureInitialized();

  late _FakePositionEvaluator fakeEvaluator;

  Future<ProviderContainer> makeTestContainer() => makeContainer(
    overrides: {
      positionEvaluatorProvider: positionEvaluatorProvider.overrideWith2((_) => fakeEvaluator),
    },
  );

  setUp(() {
    fakeEvaluator = _FakePositionEvaluator(_testContext);
  });

  test('a new eval request cancels the subscription of the replaced request', () async {
    final container = await makeTestContainer();
    final subscription = container.listen(_testControllerProvider, (_, _) {});
    addTearDown(subscription.close);

    await container.read(_testControllerProvider.future);
    final controller = container.read(_testControllerProvider.notifier);

    controller.requestEval();
    await elapseEvalDebounce();

    expect(fakeEvaluator.streams, hasLength(1));
    expect(fakeEvaluator.streams.single.hasListener, isTrue);

    controller.requestEval();
    await elapseEvalDebounce();

    expect(fakeEvaluator.streams, hasLength(2));
    expect(
      fakeEvaluator.streams.first.hasListener,
      isFalse,
      reason: 'the replaced request must not leave a listener on the evaluator stream',
    );
    expect(fakeEvaluator.streams.last.hasListener, isTrue);
  });

  test('disposing the notifier cancels the eval stream subscription', () async {
    final container = await makeTestContainer();
    final subscription = container.listen(_testControllerProvider, (_, _) {});

    await container.read(_testControllerProvider.future);
    final controller = container.read(_testControllerProvider.notifier);

    controller.requestEval();
    await elapseEvalDebounce();
    expect(fakeEvaluator.streams.single.hasListener, isTrue);

    // closing the last listener disposes the autoDispose notifier
    subscription.close();
    await Future<void>.delayed(Duration.zero);

    expect(
      fakeEvaluator.streams.single.hasListener,
      isFalse,
      reason: 'a disposed notifier must not leave a listener on the evaluator stream',
    );
  });
}
