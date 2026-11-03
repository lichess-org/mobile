import 'dart:async';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/node.dart';
import 'package:lichess_mobile/src/model/common/uci.dart';
import 'package:lichess_mobile/src/model/engine/engine_budget.dart';
import 'package:lichess_mobile/src/model/engine/engine_utils.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_context.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_preferences.dart';
import 'package:lichess_mobile/src/model/engine/position_evaluator.dart';
import 'package:lichess_mobile/src/model/engine/work.dart';
import 'package:lichess_mobile/src/view/analysis/local_game_analysis_session.dart';
import 'package:lichess_mobile/src/view/analysis/local_game_division.dart';
import 'package:lichess_mobile/src/widgets/acpl_chart.dart';
import 'package:lichess_mobile/src/widgets/game_summary_table.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';
import 'package:logging/logging.dart';
import 'package:material_ui/material_ui.dart' hide Step;

const _ultraBulletLocalReviewSearchTime = Duration(milliseconds: 100);
const _bulletLocalReviewSearchTime = Duration(milliseconds: 250);
const _blitzLocalReviewSearchTime = Duration(milliseconds: 500);
const _rapidLocalReviewSearchTime = Duration(seconds: 1);
const _localReviewRetrySearchTime = Duration(seconds: 1);
const _thoroughLocalReviewSearchTime = Duration(seconds: 3);
const _manualLocalReviewSearchTimeStep = Duration(milliseconds: 250);
const _minimumManualLocalReviewSearchTime = Duration(milliseconds: 250);
const _maximumManualLocalReviewSearchTime = Duration(seconds: 10);

enum _LocalReviewSpeed() {
  ultraBullet,
  bullet,
  blitz,
  rapid,
  thorough,
  manual,
}

enum _LocalReviewStatus() {
  ready,
  running,
  complete,
  error,
}

class const LocalGameAnalysis({
  required final AnalysisOptions options,
  required final ViewNode root,
  super.key,
}) extends ConsumerStatefulWidget {
  @override
  ConsumerState<LocalGameAnalysis> createState() => _LocalGameAnalysisState();
}

class _LocalGameAnalysisState() extends ConsumerState<LocalGameAnalysis> {
  _LocalReviewStatus _status = .ready;
  int _positionsAnalyzed = 0;
  int _totalPositions = 0;
  String? _error;
  int _runId = 0;
  Completer<void>? _cancelSignal;
  PositionEvaluator? _evaluator;
  EvalWork? _activeWork;
  bool _isReviewing = false;
  IList<LocalEval> _evaluations = const IListConst([]);

  String get _sessionKey => localGameAnalysisSessionKey(widget.options.contextId, widget.root);

  @override
  void initState() {
    super.initState();
    final cached = ref.read(localGameAnalysisSessionProvider(_sessionKey));
    if (cached != null && cached.length == widget.root.mainline.length + 1) {
      _evaluations = cached;
      _status = .complete;
    }
  }

  @override
  void dispose() {
    _cancelSignal?.complete();
    if (_activeWork != null && _evaluator?.currentWork == _activeWork) {
      _evaluator?.stop();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final evaluationContext = ref
        .watch(analysisControllerProvider(widget.options))
        .requireValue
        .evaluationContext;
    final enginePreferences = ref.watch(engineEvaluationPreferencesProvider);
    final engineState = ref.watch(positionEvaluatorProvider(evaluationContext));

    return switch (_status) {
      .ready => _buildReady(context, enginePreferences.isEnabled, engineState.engine),
      .running => _buildRunning(context),
      .complete => _buildComplete(context),
      .error => _buildError(context),
    };
  }

  Widget _buildReady(BuildContext context, bool engineEnabled, AsyncValue<String?>? engine) {
    final moves = widget.root.mainline.length;
    final enginePreferences = ref.read(engineEvaluationPreferencesProvider);
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const Text(
          'Stockfish will review every position on this device. Longer searches can improve '
          'analysis but take more time.',
        ),
        const SizedBox(height: 16.0),
        _buildLocalReviewSettings(enginePreferences),
        if (engine case AsyncError(:final error))
          Padding(padding: const EdgeInsets.only(top: 12.0), child: Text('Engine error: $error')),
        if (!engineEnabled)
          const Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text('Enable computer analysis to start the review.'),
          ),
        if (moves == 0)
          const Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text('There are no moves to analyze.'),
          ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: FilledButton.icon(
            onPressed: engineEnabled && moves > 0 && !_isReviewing ? _startReview : null,
            icon: const Icon(Icons.play_arrow),
            label: const Text('Analyze game'),
          ),
        ),
      ],
    );
  }

  Widget _buildRunning(BuildContext context) {
    final progress = _totalPositions == 0 ? 0.0 : _positionsAnalyzed / _totalPositions;
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: progress),
          duration: const Duration(milliseconds: 180),
          curve: Curves.linear,
          builder: (context, value, child) => LinearProgressIndicator(value: value),
        ),
        const SizedBox(height: 12.0),
        Text('Analyzing position ${_positionsAnalyzed + 1} of $_totalPositions…'),
        const SizedBox(height: 12.0),
        OutlinedButton(onPressed: _cancelReview, child: const Text('Cancel')),
      ],
    );
  }

  Widget _buildComplete(BuildContext context) {
    final analysisState = ref.watch(analysisControllerProvider(widget.options)).requireValue;
    final enginePreferences = ref.watch(engineEvaluationPreferencesProvider);
    final summary = localGameAnalysisSummary(widget.root, _evaluations);

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      children: [
        if (_evaluations.length > 1)
          AcplChart(
            params: (
              acplChartData: IList(
                _evaluations.skip(1).map((eval) => ExternalEval(cp: eval.cp, mate: eval.mate)),
              ),
              division: inferLocalGameDivision(widget.root),
              rootPly: widget.root.position.ply,
              currentNodePly: ref
                  .watch(analysisControllerProvider(widget.options))
                  .requireValue
                  .currentPosition
                  .ply,
              isOnMainline: true,
              onJumpToNode: (index) => ref
                  .read(analysisControllerProvider(widget.options).notifier)
                  .jumpToNthNodeOnMainline(index),
            ),
          ),
        GameSummaryTable(
          pgnHeaders: analysisState.pgnHeaders,
          playersAnalysis: summary.playersAnalysis,
          whiteExpectedScore: summary.whiteExpectedScore,
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              OutlinedButton.icon(
                onPressed: _startReview,
                icon: const Icon(Icons.refresh),
                label: const Text('Analyze again'),
              ),
              const SizedBox(height: 16.0),
              _buildLocalReviewSettings(enginePreferences),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildError(BuildContext context) {
    final enginePreferences = ref.watch(engineEvaluationPreferencesProvider);
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Text('The local game review could not be completed: ${_error ?? 'Unknown error'}'),
        const SizedBox(height: 16.0),
        _buildLocalReviewSettings(enginePreferences),
        const SizedBox(height: 12.0),
        FilledButton.icon(
          onPressed: _startReview,
          icon: const Icon(Icons.refresh),
          label: const Text('Try again'),
        ),
      ],
    );
  }

  Widget _buildLocalReviewSettings(EngineEvaluationPrefState preferences) {
    final selectedSpeed = _localReviewSpeed(preferences);
    final manualSearchTime = _normalizedManualSearchTime(preferences.localGameAnalysisSearchTime);
    final threads = _normalizedLocalReviewThreads(
      preferences.localGameAnalysisThreads ?? preferences.numEngineCores,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Local review speed settings', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8.0),
            DropdownButtonFormField<_LocalReviewSpeed>(
              isExpanded: true,
              initialValue: selectedSpeed,
              decoration: const InputDecoration(labelText: 'Analysis speed'),
              items: [
                for (final speed in _LocalReviewSpeed.values)
                  DropdownMenuItem(
                    value: speed,
                    child: Text(
                      speed.label,
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
              onChanged: (speed) {
                if (speed == null) return;
                final settings = ref.read(engineEvaluationPreferencesProvider.notifier);
                switch (speed) {
                  case .ultraBullet:
                    unawaited(
                      settings.setLocalGameAnalysisSettings(
                        searchTime: _ultraBulletLocalReviewSearchTime,
                        isManual: false,
                        threads: threads,
                      ),
                    );
                  case .bullet:
                    unawaited(
                      settings.setLocalGameAnalysisSettings(
                        searchTime: _bulletLocalReviewSearchTime,
                        isManual: false,
                        threads: threads,
                      ),
                    );
                  case .blitz:
                    unawaited(
                      settings.setLocalGameAnalysisSettings(
                        searchTime: _blitzLocalReviewSearchTime,
                        isManual: false,
                        threads: threads,
                      ),
                    );
                  case .rapid:
                    unawaited(
                      settings.setLocalGameAnalysisSettings(
                        searchTime: _rapidLocalReviewSearchTime,
                        isManual: false,
                        threads: threads,
                      ),
                    );
                  case .thorough:
                    unawaited(
                      settings.setLocalGameAnalysisSettings(
                        searchTime: _thoroughLocalReviewSearchTime,
                        isManual: false,
                        threads: threads,
                      ),
                    );
                  case .manual:
                    unawaited(
                      settings.setLocalGameAnalysisSettings(
                        searchTime: manualSearchTime,
                        isManual: true,
                        threads: threads,
                      ),
                    );
                }
              },
            ),
            if (selectedSpeed == .manual)
              SliderSettingsTile(
                title: const Text('Time per position'),
                explanation: 'Longer times may improve analysis but increase review duration.',
                value: manualSearchTime.inMilliseconds.toDouble(),
                values: [
                  for (
                    var millis = _minimumManualLocalReviewSearchTime.inMilliseconds;
                    millis <= _maximumManualLocalReviewSearchTime.inMilliseconds;
                    millis += _manualLocalReviewSearchTimeStep.inMilliseconds
                  )
                    millis.toDouble(),
                ],
                labelBuilder: (value) => _formatSearchTime(Duration(milliseconds: value.toInt())),
                onChangeEnd: (value) {
                  unawaited(
                    ref
                        .read(engineEvaluationPreferencesProvider.notifier)
                        .setLocalGameAnalysisSettings(
                          searchTime: Duration(milliseconds: value.toInt()),
                          isManual: true,
                          threads: threads,
                        ),
                  );
                },
              ),
            if (maxEngineCores > 1)
              SliderSettingsTile(
                title: const Text('Threads (experimental)'),
                explanation:
                    'Uses multiple processor cores for local analysis. Higher values may use '
                    'more battery and make the device warmer; speed gains vary.',
                value: threads.toDouble(),
                values: [
                  for (var threadCount = 1; threadCount <= maxEngineCores; threadCount++)
                    threadCount.toDouble(),
                ],
                labelBuilder: (value) => value.toInt().toString(),
                onChangeEnd: (value) {
                  unawaited(
                    ref
                        .read(engineEvaluationPreferencesProvider.notifier)
                        .setLocalGameAnalysisSettings(
                          searchTime: preferences.localGameAnalysisSearchTime,
                          isManual: preferences.isLocalGameAnalysisManual,
                          threads: value.toInt(),
                        ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _startReview() async {
    if (_isReviewing) return;
    final runId = ++_runId;
    final signal = Completer<void>();
    _cancelSignal = signal;
    final ctrl = ref.read(analysisControllerProvider(widget.options).notifier);
    final analysis = ref.read(analysisControllerProvider(widget.options)).requireValue;
    final reviewContext = EvaluationContext(
      id: StringId('local-review-${analysis.evaluationContext.id.value}'),
      variant: analysis.variant,
      initialPosition: widget.root.position,
    );
    final evaluator = ref.read(positionEvaluatorProvider(reviewContext).notifier);
    final enginePreferences = ref.read(engineEvaluationPreferencesProvider);
    final searchTime = enginePreferences.localGameAnalysisSearchTime;
    final engineBudget = ref.read(engineBudgetProvider);
    final root = widget.root;
    final branches = root.mainline.toList(growable: false);
    final steps = [
      for (final branch in branches) Step(position: branch.position, sanMove: branch.sanMove),
    ];
    final totalPositions = branches.length + 1;
    final path = StringBuffer();
    final evaluatorSubscription = ref.listenManual(
      positionEvaluatorProvider(reviewContext),
      (previous, next) {},
    );

    _evaluator = evaluator;
    _isReviewing = true;
    setState(() {
      _status = .running;
      _positionsAnalyzed = 0;
      _totalPositions = totalPositions;
      _error = null;
    });

    final evaluations = <LocalEval>[];
    try {
      for (var ply = 0; ply < totalPositions; ply++) {
        _ensureActive(runId);
        final work = EvalWork(
          id: reviewContext.id,
          variant: analysis.variant,
          threads: engineBudget.analysisThreads(
            enginePreferences.localGameAnalysisThreads ?? enginePreferences.numEngineCores,
          ),
          path: UciPath(path.toString()),
          searchTime: searchTime,
          multiPv: 1,
          threatMode: false,
          initialPosition: root.position,
          steps: IList(steps.take(ply)),
        );

        _activeWork = work;
        evaluations.add(await _evaluatePosition(ref, evaluator, work, runId, signal, searchTime));
        _activeWork = null;
        _ensureActive(runId);
        setState(() => _positionsAnalyzed = ply + 1);
        if (ply < branches.length) path.write(branches[ply].id);
      }

      if (!mounted || runId != _runId) return;
      setState(() {
        _status = .complete;
        _evaluations = evaluations.lock;
      });
      ref.read(localGameAnalysisSessionProvider(_sessionKey).notifier).evaluations = _evaluations;
    } on _LocalReviewCancelled {
      return;
    } on Object catch (error, stackTrace) {
      _logger.severe('Local game analysis failed', error, stackTrace);
      if (mounted && runId == _runId) {
        setState(() {
          _status = .error;
          _error = error.toString();
        });
      }
    } finally {
      if (evaluator.currentWork == _activeWork) evaluator.stop();
      _activeWork = null;
      if (identical(_evaluator, evaluator)) _evaluator = null;
      _isReviewing = false;
      if (mounted) setState(() {});
      if (mounted) ctrl.requestEval();
      evaluatorSubscription.close();
    }
  }

  Future<LocalEval> _evaluatePosition(
    WidgetRef ref,
    PositionEvaluator evaluator,
    EvalWork work,
    int runId,
    Completer<void> signal,
    Duration searchTime,
  ) async {
    final firstEval = Completer<void>();
    final searchStopped = Completer<void>();
    LocalEval? latestEval;
    var hasStartedSearching = false;
    final stopwatch = Stopwatch()..start();
    final subscription = ref.listenManual(positionEvaluatorProvider(evaluator.context), (
      previous,
      next,
    ) {
      if (next.currentWork == work) {
        if (next.isComputing) {
          hasStartedSearching = true;
        } else if (hasStartedSearching && !searchStopped.isCompleted) {
          searchStopped.complete();
        }
        final eval = next.eval;
        if (eval != null) {
          latestEval = eval;
          if (!firstEval.isCompleted) firstEval.complete();
        }
      } else if (hasStartedSearching && !next.isComputing && !searchStopped.isCompleted) {
        searchStopped.complete();
      }
    });
    final evalSubscription = evaluator.evalStream.where((result) => result.$1 == work).listen((
      result,
    ) {
      latestEval = result.$2;
      if (!firstEval.isCompleted) firstEval.complete();
    });

    try {
      evaluator.evaluate(work);
      await Future.any([
        firstEval.future.timeout(const Duration(seconds: 30)),
        searchStopped.future.timeout(const Duration(seconds: 30)),
        signal.future.then((_) => throw const _LocalReviewCancelled()),
      ]);
      _ensureActive(runId);

      if (latestEval == null && searchStopped.isCompleted) {
        await Future.any([
          firstEval.future,
          Future<void>.delayed(kEngineEvalEmissionThrottleDelay),
          signal.future.then((_) => throw const _LocalReviewCancelled()),
        ]);
        _ensureActive(runId);
      }

      final remaining = searchTime - stopwatch.elapsed;
      final currentState = ref.read(positionEvaluatorProvider(evaluator.context));
      if (latestEval != null && currentState.isComputing && remaining > Duration.zero) {
        await Future.any([
          Future<void>.delayed(remaining),
          searchStopped.future,
          signal.future.then((_) => throw const _LocalReviewCancelled()),
        ]);
      }
      _ensureActive(runId);
      if (ref.read(positionEvaluatorProvider(evaluator.context)).isComputing) {
        evaluator.stop();
        await Future.any([
          searchStopped.future.timeout(const Duration(seconds: 30)),
          signal.future.then((_) => throw const _LocalReviewCancelled()),
        ]);
      }
      _ensureActive(runId);

      if (latestEval case final eval?) return eval;
      if (work.position.isCheckmate || work.position.isStalemate) {
        return LocalEval(
          position: work.position,
          depth: 0,
          nodes: 0,
          pvs: const IListConst([]),
          millis: 0,
          searchTime: searchTime,
          threatMode: work.threatMode,
          mate: work.position.isCheckmate ? (work.position.turn == .white ? -1 : 1) : null,
          cp: work.position.isStalemate ? 0 : null,
        );
      }
      if (searchTime < _localReviewRetrySearchTime) {
        const retryTime = _localReviewRetrySearchTime;
        return await _evaluatePosition(
          ref,
          evaluator,
          work.copyWith(searchTime: retryTime),
          runId,
          signal,
          retryTime,
        );
      }
      throw StateError(
        'Stockfish returned no evaluation for ply ${work.position.ply} after '
        '${searchTime.inMilliseconds} ms.',
      );
    } finally {
      subscription.close();
      await evalSubscription.cancel();
    }
  }

  void _cancelReview() {
    ++_runId;
    _cancelSignal?.complete();
    if (_activeWork != null && _evaluator?.currentWork == _activeWork) _evaluator?.stop();
    _evaluator = null;
    if (!mounted) return;
    setState(() {
      _status = .ready;
      _positionsAnalyzed = 0;
    });
  }

  void _ensureActive(int runId) {
    if (!mounted || runId != _runId) throw const _LocalReviewCancelled();
  }
}

_LocalReviewSpeed _localReviewSpeed(EngineEvaluationPrefState preferences) {
  if (preferences.isLocalGameAnalysisManual) return .manual;
  return switch (preferences.localGameAnalysisSearchTime) {
    _ultraBulletLocalReviewSearchTime => .ultraBullet,
    _bulletLocalReviewSearchTime => .bullet,
    _blitzLocalReviewSearchTime => .blitz,
    _rapidLocalReviewSearchTime => .rapid,
    _thoroughLocalReviewSearchTime => .thorough,
    _ => .manual,
  };
}

Duration _normalizedManualSearchTime(Duration value) {
  final steps = (value.inMilliseconds / _manualLocalReviewSearchTimeStep.inMilliseconds)
      .round()
      .clamp(
        _minimumManualLocalReviewSearchTime.inMilliseconds ~/
            _manualLocalReviewSearchTimeStep.inMilliseconds,
        _maximumManualLocalReviewSearchTime.inMilliseconds ~/
            _manualLocalReviewSearchTimeStep.inMilliseconds,
      );
  return Duration(milliseconds: steps * _manualLocalReviewSearchTimeStep.inMilliseconds);
}

int _normalizedLocalReviewThreads(int value) => value.clamp(1, maxEngineCores);

String _formatSearchTime(Duration value) => value.inMilliseconds % 1000 == 0
    ? '${value.inSeconds}s'
    : '${(value.inMilliseconds / 1000).toStringAsFixed(2)}s';

extension on _LocalReviewSpeed {
  String get label => switch (this) {
    .ultraBullet =>
      'Ultra bullet (experimental) · ${_formatSearchTime(_ultraBulletLocalReviewSearchTime)}',
    .bullet => 'Bullet · ${_formatSearchTime(_bulletLocalReviewSearchTime)}',
    .blitz => 'Blitz · ${_formatSearchTime(_blitzLocalReviewSearchTime)}',
    .rapid => 'Rapid · ${_formatSearchTime(_rapidLocalReviewSearchTime)}',
    .thorough => 'Thorough · ${_formatSearchTime(_thoroughLocalReviewSearchTime)}',
    .manual => 'Manual',
  };
}

final _logger = Logger('LocalGameAnalysis');

final class const _LocalReviewCancelled() implements Exception;
