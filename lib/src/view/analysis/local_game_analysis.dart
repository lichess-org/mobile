import 'dart:async';

import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/node.dart';
import 'package:lichess_mobile/src/model/common/uci.dart';
import 'package:lichess_mobile/src/model/engine/engine_budget.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_context.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_preferences.dart';
import 'package:lichess_mobile/src/model/engine/position_evaluator.dart';
import 'package:lichess_mobile/src/model/engine/practice_comment.dart';
import 'package:lichess_mobile/src/model/engine/work.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/analysis/local_game_division.dart';
import 'package:lichess_mobile/src/widgets/acpl_chart.dart';
import 'package:logging/logging.dart';
import 'package:material_ui/material_ui.dart' hide Step;

const _localReviewSearchTime = Duration(seconds: 1);

final _localGameAnalysisSessionProvider =
    NotifierProvider.family<_LocalGameAnalysisSession, IList<LocalEval>?, String>(
      _LocalGameAnalysisSession.new,
    );

enum _LocalReviewStatus { ready, running, complete, error }

class const LocalGameAnalysis({
  required final AnalysisOptions options,
  required final ViewNode root,
  super.key,
}) extends ConsumerStatefulWidget {
  @override
  ConsumerState<LocalGameAnalysis> createState() => _LocalGameAnalysisState();
}

class _LocalGameAnalysisState extends ConsumerState<LocalGameAnalysis> {
  _LocalReviewStatus _status = .ready;
  int _positionsAnalyzed = 0;
  int _totalPositions = 0;
  List<_MoveReview> _reviews = const [];
  String? _error;
  int _runId = 0;
  Completer<void>? _cancelSignal;
  PositionEvaluator? _evaluator;
  EvalWork? _activeWork;
  bool _isReviewing = false;
  IList<LocalEval> _evaluations = const IListConst([]);

  String get _sessionKey =>
      '${widget.options.contextId.value}:${widget.root.position.fen}:'
      '${widget.root.mainline.map((branch) => branch.id).join()}';

  @override
  void initState() {
    super.initState();
    final cached = ref.read(_localGameAnalysisSessionProvider(_sessionKey));
    if (cached != null && cached.length == widget.root.mainline.length + 1) {
      _evaluations = cached;
      _reviews = _makeReviews(cached);
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
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const Text(
          'Stockfish will review every position on this device. It searches for one second per '
          'position; longer games take more time.',
        ),
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
        LinearProgressIndicator(value: progress),
        const SizedBox(height: 12.0),
        Text('Analyzing position ${_positionsAnalyzed + 1} of $_totalPositions…'),
        const SizedBox(height: 12.0),
        OutlinedButton(onPressed: _cancelReview, child: const Text('Cancel')),
      ],
    );
  }

  Widget _buildComplete(BuildContext context) {
    final goodMoves = _reviews
        .where((review) => review.verdict == .goodMove || review.verdict == .notBest)
        .length;
    final inaccuracies = _reviews.where((review) => review.verdict == .inaccuracy).length;
    final mistakes = _reviews.where((review) => review.verdict == .mistake).length;
    final blunders = _reviews.where((review) => review.verdict == .blunder).length;

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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            '$goodMoves good moves · $inaccuracies inaccuracies · $mistakes mistakes · '
            '$blunders blunders',
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        for (final review in _reviews)
          Material(
            type: MaterialType.transparency,
            child: ListTile(
              leading: Icon(
                review.verdict?.icon ?? Icons.help_outline,
                color: review.verdict?.color ?? Theme.of(context).disabledColor,
              ),
              title: Text(review.moveLabel),
              subtitle: Text(review.evalLabel),
              trailing: review.verdict != null ? Text(review.verdict!.label(context)) : null,
              onTap: () => ref
                  .read(analysisControllerProvider(widget.options).notifier)
                  .userJump(review.path),
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: OutlinedButton.icon(
            onPressed: _startReview,
            icon: const Icon(Icons.refresh),
            label: const Text('Analyze again'),
          ),
        ),
      ],
    );
  }

  Widget _buildError(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Text('The local game review could not be completed: ${_error ?? 'Unknown error'}'),
        const SizedBox(height: 12.0),
        FilledButton.icon(
          onPressed: _startReview,
          icon: const Icon(Icons.refresh),
          label: const Text('Try again'),
        ),
      ],
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
    final engineBudget = ref.read(engineBudgetProvider);
    final root = widget.root;
    final branches = root.mainline.toList(growable: false);
    final totalPositions = branches.length + 1;

    _evaluator = evaluator;
    _isReviewing = true;
    setState(() {
      _status = .running;
      _positionsAnalyzed = 0;
      _totalPositions = totalPositions;
      _reviews = const [];
      _error = null;
    });

    final evaluations = <LocalEval>[];
    try {
      for (var ply = 0; ply < totalPositions; ply++) {
        _ensureActive(runId);
        final path = UciPath.fromIds(branches.take(ply).map((branch) => branch.id));
        final work = EvalWork(
          id: reviewContext.id,
          variant: analysis.variant,
          threads: engineBudget.analysisThreads(enginePreferences.numEngineCores),
          path: path,
          searchTime: _localReviewSearchTime,
          multiPv: 1,
          threatMode: false,
          initialPosition: root.position,
          steps: [
            for (final branch in branches.take(ply))
              Step(position: branch.position, sanMove: branch.sanMove),
          ].lock,
        );

        _activeWork = work;
        evaluations.add(await _evaluatePosition(ref, evaluator, work, runId, signal));
        _activeWork = null;
        _ensureActive(runId);
        setState(() => _positionsAnalyzed = ply + 1);
      }

      final reviews = [..._makeReviews(evaluations.lock)];

      if (!mounted || runId != _runId) return;
      setState(() {
        _status = .complete;
        _evaluations = evaluations.lock;
        _reviews = reviews;
      });
      ref.read(_localGameAnalysisSessionProvider(_sessionKey).notifier).evaluations = _evaluations;
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
      _isReviewing = false;
      if (identical(_evaluator, evaluator)) _evaluator = null;
      if (mounted) ctrl.requestEval();
    }
  }

  Future<LocalEval> _evaluatePosition(
    WidgetRef ref,
    PositionEvaluator evaluator,
    EvalWork work,
    int runId,
    Completer<void> signal,
  ) async {
    final firstEval = Completer<void>();
    LocalEval? latestEval;
    final stopwatch = Stopwatch()..start();
    final subscription = ref.listenManual(positionEvaluatorProvider(evaluator.context), (
      previous,
      next,
    ) {
      if (next.currentWork == work) {
        final eval = next.eval;
        if (eval != null) {
          latestEval = eval;
          if (!firstEval.isCompleted) firstEval.complete();
        }
      }
    });

    try {
      evaluator.evaluate(work);
      await Future.any([
        firstEval.future.timeout(const Duration(seconds: 30)),
        signal.future.then((_) => throw const _LocalReviewCancelled()),
      ]);
      _ensureActive(runId);

      final remaining = _localReviewSearchTime - stopwatch.elapsed;
      if (ref.read(positionEvaluatorProvider(evaluator.context)).isComputing &&
          remaining > Duration.zero) {
        await Future.any([
          Future<void>.delayed(remaining),
          signal.future.then((_) => throw const _LocalReviewCancelled()),
        ]);
      }
      _ensureActive(runId);
      evaluator.stop();
      await Future<void>.delayed(kEngineEvalEmissionThrottleDelay);
      _ensureActive(runId);

      return latestEval ?? (throw StateError('The engine returned no evaluation.'));
    } finally {
      subscription.close();
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

  _MoveReview _makeReview({
    required ViewBranch branch,
    required LocalEval before,
    required LocalEval after,
    required UciPath path,
  }) {
    final moveNumber = before.position.fullmoves;
    final movePrefix = before.position.turn == Side.white ? '$moveNumber.' : '$moveNumber...';
    final bestMove = before.bestMove;
    final verdict = bestMove == null
        ? null
        : MoveVerdict.fromShift(
            before.winningChances(before.position.turn) -
                after.winningChances(before.position.turn),
            hasBetterMove: bestMove != branch.sanMove.move,
            winningChancesBefore: before.winningChances(before.position.turn),
            winningChancesAfter: after.winningChances(before.position.turn),
          );

    return _MoveReview(
      moveLabel: '$movePrefix ${branch.sanMove.san}',
      evalLabel: '${before.evalString} → ${after.evalString}',
      verdict: verdict,
      path: path,
    );
  }

  List<_MoveReview> _makeReviews(IList<LocalEval> evaluations) {
    final branches = widget.root.mainline;
    return [
      for (final (index, branch) in branches.indexed)
        _makeReview(
          branch: branch,
          before: evaluations[index],
          after: evaluations[index + 1],
          path: UciPath.fromIds(branches.take(index + 1).map((move) => move.id)),
        ),
    ];
  }
}

final _logger = Logger('LocalGameAnalysis');

class _LocalGameAnalysisSession(final String sessionKey) extends Notifier<IList<LocalEval>?> {
  @override
  IList<LocalEval>? build() => null;

  IList<LocalEval>? get evaluations => state;

  set evaluations(IList<LocalEval> evaluations) => state = evaluations;
}

class const _MoveReview({
  required this.moveLabel,
  required this.evalLabel,
  required this.verdict,
  required this.path,
}) {
  final String moveLabel;
  final String evalLabel;
  final MoveVerdict? verdict;
  final UciPath path;
}

final class _LocalReviewCancelled implements Exception {
  const _LocalReviewCancelled();
}

extension on MoveVerdict {
  IconData get icon => switch (this) {
    .goodMove => Icons.check_circle,
    .notBest => Icons.info,
    .inaccuracy => Icons.help,
    .mistake => Icons.error,
    .blunder => Icons.cancel,
  };

  Color get color => switch (this) {
    .goodMove || .notBest => LichessColors.good,
    .inaccuracy => LichessColors.inaccuracy,
    .mistake => LichessColors.mistake,
    .blunder => LichessColors.blunder,
  };

  String label(BuildContext context) => switch (this) {
    .goodMove => context.l10n.studyGoodMove,
    .notBest => context.l10n.mobileGoodMoveButThereIsBetter,
    .inaccuracy => context.l10n.inaccuracy,
    .mistake => context.l10n.mistake,
    .blunder => context.l10n.blunder,
  };
}
