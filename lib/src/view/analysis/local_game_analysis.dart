import 'dart:async';

import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/node.dart';
import 'package:lichess_mobile/src/model/common/uci.dart';
import 'package:lichess_mobile/src/model/engine/engine_budget.dart';
import 'package:lichess_mobile/src/model/engine/engine_utils.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_context.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_preferences.dart';
import 'package:lichess_mobile/src/model/engine/position_evaluator.dart';
import 'package:lichess_mobile/src/model/engine/practice_comment.dart';
import 'package:lichess_mobile/src/model/engine/work.dart';
import 'package:lichess_mobile/src/model/game/player.dart';
import 'package:lichess_mobile/src/model/study/study.dart';
import 'package:lichess_mobile/src/model/study/study_controller.dart';
import 'package:lichess_mobile/src/model/study/study_repository.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/analysis/local_game_division.dart';
import 'package:lichess_mobile/src/view/study/study_screen.dart';
import 'package:lichess_mobile/src/widgets/acpl_chart.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/game_summary_table.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';
import 'package:logging/logging.dart';
import 'package:material_ui/material_ui.dart' hide Step;

const _fastLocalReviewSearchTime = Duration(milliseconds: 500);
const _balancedLocalReviewSearchTime = Duration(seconds: 1);
const _thoroughLocalReviewSearchTime = Duration(seconds: 3);
const _manualLocalReviewSearchTimeStep = Duration(milliseconds: 250);
const _minimumManualLocalReviewSearchTime = Duration(milliseconds: 250);
const _maximumManualLocalReviewSearchTime = Duration(seconds: 10);

enum _LocalReviewSpeed { fast, balanced, thorough, manual }

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
  bool _isRequestingServerAnalysis = false;
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
        const SizedBox(height: 8.0),
        _buildServerAnalysisButton(context, moves),
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
    final analysisState = ref.watch(analysisControllerProvider(widget.options)).requireValue;
    final enginePreferences = ref.watch(engineEvaluationPreferencesProvider);
    final playersAnalysis = (
      white: _playerAnalysisFor(Side.white),
      black: _playerAnalysisFor(Side.black),
    );

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
        GameSummaryTable(pgnHeaders: analysisState.pgnHeaders, playersAnalysis: playersAnalysis),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            '$goodMoves good moves · '
            '${playersAnalysis.white.inaccuracies + playersAnalysis.black.inaccuracies} '
            'inaccuracies · '
            '${playersAnalysis.white.mistakes + playersAnalysis.black.mistakes} mistakes · '
            '${playersAnalysis.white.blunders + playersAnalysis.black.blunders} blunders',
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
                  .userJump(
                    UciPath.fromIds(
                      widget.root.mainline.take(review.ply + 1).map((branch) => branch.id),
                    ),
                  ),
            ),
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
              const SizedBox(height: 8.0),
              _buildServerAnalysisButton(context, widget.root.mainline.length),
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
        const SizedBox(height: 8.0),
        _buildServerAnalysisButton(context, widget.root.mainline.length),
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
              initialValue: selectedSpeed,
              decoration: const InputDecoration(labelText: 'Analysis speed'),
              items: [
                for (final speed in _LocalReviewSpeed.values)
                  DropdownMenuItem(value: speed, child: Text(speed.label)),
              ],
              onChanged: (speed) {
                if (speed == null) return;
                final settings = ref.read(engineEvaluationPreferencesProvider.notifier);
                switch (speed) {
                  case .fast:
                    unawaited(
                      settings.setLocalGameAnalysisSettings(
                        searchTime: _fastLocalReviewSearchTime,
                        isManual: false,
                        threads: threads,
                      ),
                    );
                  case .balanced:
                    unawaited(
                      settings.setLocalGameAnalysisSettings(
                        searchTime: _balancedLocalReviewSearchTime,
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

  Widget _buildServerAnalysisButton(BuildContext context, int moves) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OutlinedButton.icon(
          onPressed: moves >= 4 && !_isRequestingServerAnalysis ? _requestServerAnalysis : null,
          icon: _isRequestingServerAnalysis
              ? const SizedBox(
                  width: 18.0,
                  height: 18.0,
                  child: CircularProgressIndicator.adaptive(strokeWidth: 2.0),
                )
              : const Icon(Icons.cloud_upload_outlined),
          label: Text(context.l10n.requestAComputerAnalysis),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(
            moves < 4
                ? 'Server analysis requires at least four moves.'
                : 'Uploads this game to a private Lichess study before requesting server analysis.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }

  Future<void> _requestServerAnalysis() async {
    if (_isRequestingServerAnalysis) return;

    final authUser = ref.read(authControllerProvider);
    if (authUser == null) {
      showSnackBar(context, context.l10n.youNeedAnAccountToDoThat);
      return;
    }

    final (pgn, orientation, variant) = switch (widget.options) {
      Pgn(:final pgn, :final orientation, :final variant) => (pgn, orientation, variant),
      _ => throw StateError('Server analysis requires a PGN game.'),
    };

    setState(() => _isRequestingServerAnalysis = true);
    try {
      final (studyId, chapterIds) = await ref
          .read(studyRepositoryProvider)
          .createStudy(
            CreateStudyPayload(
              name: '${authUser.user.name} - Game Analysis',
              chat: StudyFeatureAccess.nobody,
              cloneable: StudyFeatureAccess.nobody,
              computer: StudyFeatureAccess.owner,
              explorer: StudyFeatureAccess.nobody,
              shareable: StudyFeatureAccess.nobody,
              visibility: StudyVisibility.private,
              sticky: false,
            ),
            CreateStudyChapterPayload(
              pgn: pgn,
              name: context.l10n.computerAnalysis,
              orientation: orientation,
              variant: variant,
            ),
          );
      final chapterId = chapterIds.isNotEmpty ? chapterIds.first : null;
      if (chapterId == null) {
        throw StateError('The server created a study without a chapter.');
      }

      final studyOptions = (id: studyId, initialChapter: chapterId);
      Navigator.of(context).push(StudyScreen.buildRoute(studyOptions, openComputerAnalysis: true));
      await ref.read(studyControllerProvider(studyOptions).future);
      await ref.read(studyControllerProvider(studyOptions).notifier).requestServerAnalysis();
    } on Object catch (error, stackTrace) {
      _logger.severe('Could not request server analysis for offline game', error, stackTrace);
      if (mounted) {
        showSnackBar(context, error.toString(), type: SnackBarType.error);
      }
    } finally {
      if (mounted) setState(() => _isRequestingServerAnalysis = false);
    }
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

      final reviews = _makeReviews(evaluations.lock);

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
    Duration searchTime,
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

      final remaining = searchTime - stopwatch.elapsed;
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
    required int ply,
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
      side: before.position.turn,
      ply: ply,
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
          ply: index,
        ),
    ];
  }

  PlayerAnalysis _playerAnalysisFor(Side side) {
    var inaccuracies = 0;
    var mistakes = 0;
    var blunders = 0;

    for (final review in _reviews) {
      if (review.side != side) continue;
      switch (review.verdict) {
        case .inaccuracy:
          inaccuracies++;
        case .mistake:
          mistakes++;
        case .blunder:
          blunders++;
        case _:
          break;
      }
    }
    return PlayerAnalysis(inaccuracies: inaccuracies, mistakes: mistakes, blunders: blunders);
  }
}

_LocalReviewSpeed _localReviewSpeed(EngineEvaluationPrefState preferences) {
  if (preferences.isLocalGameAnalysisManual) return .manual;
  return switch (preferences.localGameAnalysisSearchTime) {
    _fastLocalReviewSearchTime => .fast,
    _balancedLocalReviewSearchTime => .balanced,
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
    .fast => 'Fast (${_formatSearchTime(_fastLocalReviewSearchTime)} per position)',
    .balanced => 'Balanced (${_formatSearchTime(_balancedLocalReviewSearchTime)} per position)',
    .thorough => 'Thorough (${_formatSearchTime(_thoroughLocalReviewSearchTime)} per position)',
    .manual => 'Manual',
  };
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
  required this.side,
  required this.ply,
}) {
  final String moveLabel;
  final String evalLabel;
  final MoveVerdict? verdict;
  final Side side;
  final int ply;
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
