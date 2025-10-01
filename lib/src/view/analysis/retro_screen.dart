import 'dart:math' as math;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_preferences.dart';
import 'package:lichess_mobile/src/model/analysis/retro_controller.dart';
import 'package:lichess_mobile/src/model/common/node.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_preferences.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/model/settings/general_preferences.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_board.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_layout.dart';
import 'package:lichess_mobile/src/view/analysis/retro_settings_screen.dart';
import 'package:lichess_mobile/src/view/engine/engine_depth.dart';
import 'package:lichess_mobile/src/view/engine/engine_gauge.dart';
import 'package:lichess_mobile/src/view/engine/engine_lines.dart';
import 'package:lichess_mobile/src/view/puzzle/puzzle_feedback_widget.dart';
import 'package:lichess_mobile/src/view/settings/toggle_sound_button.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/misc.dart';
import 'package:lichess_mobile/src/widgets/pgn.dart';
import 'package:lichess_mobile/src/widgets/platform_context_menu_button.dart';

class RetroScreen extends ConsumerWidget {
  const RetroScreen({required this.options, super.key});

  final RetroOptions options;

  static Route<dynamic> buildRoute(BuildContext context, RetroOptions options) {
    return buildScreenRoute(context, screen: RetroScreen(options: options));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enginePrefs = ref.watch(engineEvaluationPreferencesProvider);
    final asyncState = ref.watch(retroControllerProvider(options));

    return switch (asyncState) {
      AsyncError() => const Center(child: Text('Failed to load mistakes for this game.')),
      AsyncData() => Scaffold(
        appBar: AppBar(
          title: AppBarTitleText(
            '${context.l10n.learnFromYourMistakes} (${math.min(asyncState.requireValue.mistakes.length, asyncState.requireValue.currentMistakeIndex + 1)}/${asyncState.requireValue.mistakes.length})',
            maxLines: 2,
          ),
          actions: [
            if (asyncState.requireValue.isEngineAvailable(enginePrefs) == true)
              EngineDepth(
                savedEval: asyncState.valueOrNull?.currentNode.eval,
                goDeeper: () =>
                    ref.read(retroControllerProvider(options).notifier).requestEval(goDeeper: true),
              ),
            _RetroMenu(options: options),
          ],
        ),
        body: DefaultTabController(length: 1, child: _RetroScreen(options)),
      ),
      _ => Scaffold(
        appBar: AppBar(title: AppBarTitleText(context.l10n.learnFromYourMistakes)),
        body: const Center(child: CircularProgressIndicator.adaptive()),
      ),
    };
  }
}

class _RetroScreen extends ConsumerWidget {
  const _RetroScreen(this.options);

  final RetroOptions options;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analysisPrefs = ref.watch(analysisPreferencesProvider);
    final enginePrefs = ref.watch(engineEvaluationPreferencesProvider);
    final showEvaluationGauge = analysisPrefs.showEvaluationGauge;

    final numEvalLines = enginePrefs.numEvalLines;

    final state = ref.watch(retroControllerProvider(options)).requireValue;

    final hideEngineLines = state.isSolving || numEvalLines == 0;

    return AnalysisLayout(
      smallBoard: analysisPrefs.smallBoard,
      pov: state.pov,
      boardBuilder: (context, boardSize, borderRadius) =>
          RetroAnalysisBoard(options, boardSize: boardSize, boardRadius: borderRadius),
      engineGaugeBuilder: showEvaluationGauge
          ? (context, orientation) {
              return orientation == Orientation.portrait
                  ? EngineGauge(
                      displayMode: EngineGaugeDisplayMode.horizontal,
                      params: state.engineGaugeParams,
                      engineLinesState: hideEngineLines
                          ? null
                          : analysisPrefs.showEngineLines
                          ? EngineLinesShowState.expanded
                          : EngineLinesShowState.collapsed,
                      onTap: () {
                        ref.read(analysisPreferencesProvider.notifier).toggleShowEngineLines();
                      },
                    )
                  : Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(4.0)),
                      child: EngineGauge(
                        displayMode: EngineGaugeDisplayMode.vertical,
                        params: state.engineGaugeParams,
                      ),
                    );
            }
          : null,
      engineLines: analysisPrefs.showEngineLines
          // We hide engine lines while solving (as they would give away the solution),
          // but show them once the solution has been found.
          // To avoid a layout jump, make the widget invisible instead of removing it completely.
          ? Visibility.maintain(
              visible: !hideEngineLines,
              child: EngineLines(
                onTapMove: ref.read(retroControllerProvider(options).notifier).onUserMove,
                savedEval: state.currentNode.eval,
                isGameOver: state.currentNode.position.isGameOver,
              ),
            )
          : null,
      bottomBar: _BottomBar(options),
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _FeedbackWidget(options),
              if (state.feedback == RetroFeedback.done)
                FilledButton(
                  onPressed: ref.read(retroControllerProvider(options).notifier).flipSide,
                  child: Text(
                    state.pov == Side.white
                        ? context.l10n.reviewBlackMistakes
                        : context.l10n.reviewWhiteMistakes,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class RetroAnalysisBoard extends AnalysisBoard {
  const RetroAnalysisBoard(this.options, {required super.boardSize, super.boardRadius});

  final RetroOptions options;

  @override
  ConsumerState<RetroAnalysisBoard> createState() => _RetroAnalysisBoardState();
}

class _RetroAnalysisBoardState
    extends AnalysisBoardState<RetroAnalysisBoard, RetroState, AnalysisPrefs> {
  @override
  RetroState get analysisState => ref.watch(retroControllerProvider(widget.options)).requireValue;

  @override
  AnalysisPrefs get analysisPrefs => ref.watch(analysisPreferencesProvider);

  @override
  bool get showAnnotations => analysisPrefs.showAnnotations;

  @override
  bool get hideBestMoveArrow => analysisState.isSolving;

  // Disable interaction while the engine is evaluating the move
  @override
  bool get interactive => analysisState.feedback != RetroFeedback.evalMove;

  @override
  void onUserMove(NormalMove move) {
    ref.read(retroControllerProvider(widget.options).notifier).onUserMove(move);
  }

  @override
  void onPromotionSelection(Role? role) {
    ref.read(retroControllerProvider(widget.options).notifier).onPromotionSelection(role);
  }

  @override
  String get fen => analysisState.currentPosition.board.fen;

  @override
  ISet<Shape> get extraShapes {
    final state = ref.watch(retroControllerProvider(widget.options)).requireValue;
    if (state.isSolving && state.currentMistake != null) {
      final mistake = state.currentMistake!.userMove;
      return ISet<Shape>([
        Arrow(
          color: ShapeColor.red.color.withValues(alpha: 0.4),
          orig: mistake.from,
          dest: mistake.to,
        ),
      ]);
    }
    return ISet();
  }
}

class _BottomBar extends ConsumerWidget {
  const _BottomBar(this.options);

  final RetroOptions options;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(retroControllerProvider(options)).requireValue;

    final onGoForward = state.canGoNext
        ? ref.read(retroControllerProvider(options).notifier).userNext
        : null;
    final onGoBack = state.canGoBack
        ? ref.read(retroControllerProvider(options).notifier).userPrevious
        : null;

    return BottomBar(
      children: [
        if (state.isSolving) ...[
          BottomBarButton(
            icon: Icons.help,
            label: context.l10n.viewTheSolution,
            showLabel: true,
            onTap: ref.read(retroControllerProvider(options).notifier).viewSolution,
          ),
          BottomBarButton(
            icon: Icons.skip_next,
            label: context.l10n.skipThisMove,
            showLabel: true,
            onTap: ref.read(retroControllerProvider(options).notifier).nextMistake,
          ),
        ] else ...[
          if (state.feedback == RetroFeedback.done && state.hasMistakes)
            BottomBarButton(
              icon: Icons.skip_previous,
              label: context.l10n.doItAgain,
              showLabel: true,
              onTap: ref.read(retroControllerProvider(options).notifier).restart,
            ),
          RepeatButton(
            onLongPress: onGoBack,
            child: BottomBarButton(
              key: const ValueKey('goto-previous'),
              onTap: onGoBack,
              label: context.l10n.studyBack,
              showLabel: true,
              icon: CupertinoIcons.chevron_back,
              showTooltip: false,
            ),
          ),
          RepeatButton(
            onLongPress: onGoForward,
            child: BottomBarButton(
              key: const ValueKey('goto-next'),
              icon: CupertinoIcons.chevron_forward,
              onTap: onGoForward,
              label: context.l10n.studyNext,
              showLabel: true,
              showTooltip: false,
            ),
          ),
          if (state.feedback != RetroFeedback.done)
            BottomBarButton(
              icon: Icons.play_arrow,
              label: context.l10n.keyNextMistake,
              showLabel: true,
              onTap: ref.read(retroControllerProvider(options).notifier).nextMistake,
            ),
        ],
      ],
    );
  }
}

class _FeedbackWidget extends ConsumerWidget {
  const _FeedbackWidget(this.options);

  final RetroOptions options;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(retroControllerProvider(options)).requireValue;

    final feedbackTile = state.hasMistakes
        ? switch (state.feedback) {
            RetroFeedback.findMove => FeedbackTile(
              leading: SideToPlayPiece(side: state.pov),
              title: Text(
                context.l10n.xWasPlayed(_branchMoveToString(state.currentMistake!.userBranch)),
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                state.pov == Side.white
                    ? context.l10n.findBetterMoveForWhite
                    : context.l10n.findBetterMoveForBlack,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
            RetroFeedback.correct => FeedbackTile(
              leading: Icon(Icons.check, size: 36, color: context.lichessColors.good),
              title: Text(context.l10n.puzzleGoodMove),
            ),
            RetroFeedback.incorrect => FeedbackTile(
              leading: Icon(Icons.close, size: 36, color: context.lichessColors.error),
              title: Text(context.l10n.youCanDoBetter),
              subtitle: state.pov == Side.white
                  ? Text(context.l10n.tryAnotherMoveForWhite)
                  : Text(context.l10n.tryAnotherMoveForBlack),
            ),
            RetroFeedback.viewingSolution => FeedbackTile(
              leading: const Icon(Icons.check, size: 36),
              title: Text(context.l10n.solution),
              subtitle: Text(
                context.l10n.bestWasX(_branchMoveToString(state.currentMistake!.serverBranch)),
              ),
            ),
            RetroFeedback.evalMove => FeedbackTile(
              leading: CustomPaint(
                size: const Size(36, 36),
                painter: MicroChipPainter(ColorScheme.of(context).secondary),
              ),
              title: Text(context.l10n.evaluatingYourMove),
              subtitle: LinearProgressIndicator(
                value: state.evalProgress,
                color: context.lichessColors.primary,
              ),
            ),
            RetroFeedback.done => FeedbackTile(
              leading: SideToPlayPiece(side: state.pov),
              title: Text(
                state.pov == Side.white
                    ? context.l10n.doneReviewingWhiteMistakes
                    : context.l10n.doneReviewingBlackMistakes,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          }
        : FeedbackTile(
            leading: SideToPlayPiece(side: state.pov),
            title: AutoSizeText(
              state.pov == Side.white
                  ? context.l10n.noMistakesFoundForWhite
                  : context.l10n.noMistakesFoundForBlack,
            ),
          );

    return Padding(padding: const EdgeInsets.all(8.0), child: feedbackTile);
  }
}

String _branchMoveToString(ViewBranch branch) {
  final nag = moveAnnotationChar(branch.nags ?? []);
  return '${(branch.position.ply / 2).ceil()}${branch.position.turn == Side.black ? '.' : '...'} ${branch.sanMove.san}$nag';
}

class _RetroMenu extends ConsumerWidget {
  const _RetroMenu({required this.options});

  final RetroOptions options;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ContextMenuIconButton(
      icon: const Icon(Icons.more_horiz),
      semanticsLabel: context.l10n.menu,
      actions: [
        ContextMenuAction(
          icon: Icons.settings,
          label: context.l10n.settingsSettings,
          onPressed: () =>
              Navigator.of(context).push(RetroSettingsScreen.buildRoute(context, options: options)),
        ),
        ToggleSoundContextMenuAction(
          isEnabled: ref.watch(generalPreferencesProvider.select((prefs) => prefs.isSoundEnabled)),
          onPressed: () => ref.read(generalPreferencesProvider.notifier).toggleSoundEnabled(),
        ),
      ],
    );
  }
}
