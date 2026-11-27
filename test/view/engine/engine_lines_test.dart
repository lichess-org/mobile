import 'dart:convert';

import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/analysis/common_analysis_state.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/engine/engine_spec.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_context.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_preferences.dart';
import 'package:lichess_mobile/src/model/engine/position_evaluator.dart';
import 'package:lichess_mobile/src/model/settings/preferences_storage.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/view/engine/engine_lines.dart';
import 'package:material_ui/material_ui.dart';

import '../../model/auth/fake_auth_storage.dart';
import '../../model/engine/fake_external_engines.dart';
import '../../test_provider_scope.dart';

const _filters = (
  context: EvaluationContext(
    id: StringId('test'),
    variant: Variant.standard,
    initialPosition: Chess.initial,
  ),
  path: null,
);

final _previousPositionEval = LocalEval(
  position: Chess.initial,
  depth: 20,
  nodes: 100000,
  millis: 1000,
  searchTime: const Duration(seconds: 1),
  threatMode: false,
  cp: 30,
  pvs: IList(const [
    PvData(moves: IListConst(['e2e4', 'e7e5']), cp: 30),
  ]),
);

/// What the evaluator reports, set by each test.
final _evaluationProvider = NotifierProvider<_Evaluation, EngineEvaluationState>(_Evaluation.new);

class _Evaluation() extends Notifier<EngineEvaluationState> {
  @override
  EngineEvaluationState build() => PositionEvaluator.defaultState;

  EngineEvaluationState get evaluation => state;

  set evaluation(EngineEvaluationState evaluation) => state = evaluation;
}

class _AnalysisState() implements CommonAnalysisState {
  @override
  Position? get currentPosition => Chess.initial;

  @override
  AnalysisCurrentNodeInterface get currentNode => _Node();

  @override
  bool get engineInThreatMode => false;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Node() implements AnalysisCurrentNodeInterface {
  @override
  ClientEval? get eval => null;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Future<ProviderContainer> _pumpLines(WidgetTester tester, {String? externalEngineId}) async {
  final app = await makeTestProviderScopeApp(
    tester,
    defaultPreferences: {
      PrefCategory.engineEvaluation.storageKey: jsonEncode(
        EngineEvaluationPrefState.defaults
            .copyWith(numEvalLines: 2, externalEngineId: externalEngineId)
            .toJson(),
      ),
    },
    overrides: {
      httpClientFactoryProvider: httpClientFactoryProvider.overrideWith(
        (ref) => externalEnginesClientFactory([testExternalEngine]),
      ),
      engineEvaluationProvider: engineEvaluationProvider.overrideWith(
        (ref, _) => ref.watch(_evaluationProvider),
      ),
    },
    authUser: fakeAuthUser,
    home: Scaffold(
      body: EngineLines(filters: _filters, onTapMove: (_) {}, analysisState: _AnalysisState()),
    ),
  );
  await tester.pumpWidget(app);
  await tester.pumpAndSettle();
  return ProviderScope.containerOf(tester.element(find.byType(EngineLines)));
}

EngineEvaluationState _evaluation({
  required EngineSpec spec,
  AsyncValue<String?> engine = const AsyncData('engine'),
  LocalEval? eval,
}) => (engine: engine, engineSpec: spec, eval: eval, isComputing: true, currentWork: null);

void main() {
  testWidgets('An external engine shows it is loading instead of older lines', (tester) async {
    final container = await _pumpLines(tester, externalEngineId: testExternalEngine.id);
    final evaluation = container.read(_evaluationProvider.notifier);
    const spec = ExternalEngineSpec(testExternalEngine);

    evaluation.evaluation = _evaluation(spec: spec, eval: _previousPositionEval);
    await tester.pump();
    expect(find.textContaining('e4'), findsOne);

    evaluation.evaluation = _evaluation(spec: spec);
    await tester.pump();
    expect(find.text('Loading engine...'), findsOne);
    expect(find.textContaining('e4'), findsNothing);
  });

  testWidgets('A failed external engine says so in the lines', (tester) async {
    final container = await _pumpLines(tester, externalEngineId: testExternalEngine.id);

    container.read(_evaluationProvider.notifier).evaluation = _evaluation(
      spec: const ExternalEngineSpec(testExternalEngine),
      engine: AsyncError(Exception('503'), StackTrace.empty),
    );
    await tester.pump();

    expect(find.text('Error loading engine'), findsOne);
  });

  testWidgets('A local engine keeps the last lines while the next ones load', (tester) async {
    final container = await _pumpLines(tester);
    final evaluation = container.read(_evaluationProvider.notifier);
    const spec = StockfishSpec.light();

    evaluation.evaluation = _evaluation(spec: spec, eval: _previousPositionEval);
    await tester.pump();
    evaluation.evaluation = _evaluation(spec: spec);
    await tester.pump();

    expect(find.textContaining('e4'), findsOne);
    expect(find.text('Loading engine...'), findsNothing);
  });
}
