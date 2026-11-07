import 'dart:async';
import 'dart:convert';

import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/node.dart';
import 'package:lichess_mobile/src/model/common/uci.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_mixin.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_preferences.dart';
import 'package:lichess_mobile/src/model/engine/position_evaluator.dart';
import 'package:lichess_mobile/src/model/engine/work.dart';
import 'package:lichess_mobile/src/network/socket.dart';

import '../../binding.dart';
import '../../network/fake_websocket_channel.dart';
import '../../test_container.dart';

const _testContext = EvaluationContext(
  id: StringId('eval_mixin_test'),
  variant: Variant.standard,
  initialPosition: Chess.initial,
);

final _e4Path = UciPath.fromId(UciCharPair.fromUci('e2e4'));

final _afterE4 = Chess.initial.play(Move.parse('e2e4')!);

/// An evaluator that does not touch any engine: it hands out controllable streams so the test can
/// observe whether the mixin keeps the returned subscription alive or cancels it.
class _FakePositionEvaluator(super.context) extends PositionEvaluator {
  /// Every stream handed out by [evaluate], in request order.
  final List<StreamController<EvalResult>> streams = [];

  /// Every work passed to [evaluate], in request order.
  final List<EvalWork> works = [];

  int stopCount = 0;

  bool external = false;

  @override
  bool get usesExternalEngine => external;

  @override
  EngineEvaluationState build() => PositionEvaluator.defaultState;

  @override
  Stream<EvalResult> evaluate(EvalWork work) {
    final controller = StreamController<EvalResult>.broadcast();
    streams.add(controller);
    works.add(work);
    return controller.stream.where((result) => result.$1 == work);
  }

  @override
  void stop() {
    stopCount++;
    super.stop();
  }
}

class _TestState() with EvaluationMixinState<_TestState> {
  @override
  bool isEngineAvailable(EngineEvaluationPrefState prefs) => true;

  @override
  EvaluationContext get evaluationContext => _testContext;

  @override
  UciPath get currentPath => _e4Path;

  @override
  Position? get currentPosition => _afterE4;

  @override
  bool get alwaysRequestCloudEval => false;

  @override
  bool get engineInThreatMode => false;

  @override
  _TestState withThreatMode(bool engineInThreatMode) => this;
}

class _TestController() extends AsyncNotifier<_TestState> with EngineEvaluationMixin<_TestState> {
  final Node _tree = Root.fromPgnMoves('e4');

  SocketClient? socket;

  @override
  Future<_TestState> build() async => _TestState();

  @override
  SocketClient? get socketClient => socket;

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

  CloudEval deepCloudEval() => CloudEval(
    position: _afterE4,
    depth: 40,
    nodes: 100000000,
    pvs: IList(const [
      PvData(moves: IListConst(['e7e5']), cp: 20),
    ]),
  );

  Future<List<dynamic>> evalGetsSent({required bool external}) async {
    final channel = FakeWebSocketChannel(Uri(path: kDefaultSocketRoute));
    final container = await makeContainer(
      overrides: {
        positionEvaluatorProvider: positionEvaluatorProvider.overrideWith2((_) => fakeEvaluator),
        webSocketChannelFactoryProvider: webSocketChannelFactoryProvider.overrideWith(
          (_) => FakeWebSocketChannelFactory((_) => channel),
        ),
      },
    );
    final client = container.read(socketPoolProvider).open(Uri(path: kDefaultSocketRoute));
    await client.firstConnection;
    final sent = <dynamic>[];
    final sentSubscription = channel.sentMessagesExceptPing.listen(sent.add);
    addTearDown(sentSubscription.cancel);
    final subscription = container.listen(_testControllerProvider, (_, _) {});
    addTearDown(subscription.close);

    await container.read(_testControllerProvider.future);
    final controller = container.read(_testControllerProvider.notifier);
    controller.socket = client;
    fakeEvaluator.external = external;

    controller.requestEval();
    await elapseEvalDebounce();

    return sent
        .where(
          (message) => (jsonDecode(message as String) as Map<String, dynamic>)['t'] == 'evalGet',
        )
        .toList();
  }

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

  test(
    'an external engine evaluates a position that has a cloud eval, and overwrites it',
    () async {
      final container = await makeTestContainer();
      final subscription = container.listen(_testControllerProvider, (_, _) {});
      addTearDown(subscription.close);

      await container.read(_testControllerProvider.future);
      final controller = container.read(_testControllerProvider.notifier);
      fakeEvaluator.external = true;
      controller.positionTree.updateAt(_e4Path, (node) => node.eval = deepCloudEval());

      controller.requestEval();
      await elapseEvalDebounce();

      expect(fakeEvaluator.streams, hasLength(1));

      final localEval = LocalEval(
        position: _afterE4,
        depth: 10,
        nodes: 1000,
        millis: 100,
        searchTime: const Duration(milliseconds: 100),
        threatMode: false,
        cp: 30,
        pvs: IList(const [
          PvData(moves: IListConst(['e7e5']), cp: 30),
        ]),
      );
      fakeEvaluator.streams.single.add((fakeEvaluator.works.single, localEval));
      await pumpEventQueue();

      expect(controller.positionTree.nodeAt(_e4Path).eval, localEval);
      expect(fakeEvaluator.stopCount, 0);
      expect(fakeEvaluator.streams.single.hasListener, isTrue);
    },
  );

  test('a local engine does not evaluate a position that has a cloud eval', () async {
    final container = await makeTestContainer();
    final subscription = container.listen(_testControllerProvider, (_, _) {});
    addTearDown(subscription.close);

    await container.read(_testControllerProvider.future);
    final controller = container.read(_testControllerProvider.notifier);
    controller.positionTree.updateAt(_e4Path, (node) => node.eval = deepCloudEval());

    controller.requestEval();
    await elapseEvalDebounce();

    expect(fakeEvaluator.streams, isEmpty);
  });

  test('no cloud eval is asked for while an external engine is in use', () async {
    expect(await evalGetsSent(external: true), isEmpty);
  });

  test('a cloud eval is asked for while a local engine is in use', () async {
    expect(await evalGetsSent(external: false), hasLength(1));
  });
}
