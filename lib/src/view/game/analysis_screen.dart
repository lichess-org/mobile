import 'package:dartchess/dartchess.dart';
import 'package:chessground/chessground.dart' as cg;
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/tree.dart';
import 'package:lichess_mobile/src/model/common/uci.dart';
import 'package:lichess_mobile/src/model/engine/engine_evaluation.dart';
import 'package:lichess_mobile/src/model/game/analysis_ctrl.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/immersive_mode.dart';
import 'package:lichess_mobile/src/view/engine/engine_gauge.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/chessground_compat.dart';
import 'package:lichess_mobile/src/model/game/game.dart';

const baseTextStyle =
    TextStyle(fontFamily: 'ChessFont', fontWeight: FontWeight.bold);
const sideLineStyle =
    TextStyle(fontFamily: 'ChessFont', fontStyle: FontStyle.italic);

class AnalysisScreen extends StatelessWidget {
  const AnalysisScreen({
    required this.steps,
    required this.orientation,
    required this.gameData,
  });

  final IList<GameStep> steps;
  final Side orientation;
  final ArchivedGameData gameData;

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _androidBuilder,
      iosBuilder: _iosBuilder,
    );
  }

  Widget _androidBuilder(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.gameAnalysis),
      ),
      body: _Body(
        steps: steps,
        orientation: orientation,
        gameData: gameData,
      ),
    );
  }

  Widget _iosBuilder(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(context.l10n.analysis),
      ),
      child: _Body(
        steps: steps,
        orientation: orientation,
        gameData: gameData,
      ),
    );
  }
}

class _Body extends ConsumerStatefulWidget {
  const _Body({
    required this.steps,
    required this.orientation,
    required this.gameData,
  });

  final IList<GameStep> steps;
  final Side orientation;
  final ArchivedGameData gameData;

  @override
  ConsumerState<_Body> createState() => _BodyState();
}

class _BodyState extends ConsumerState<_Body> with AndroidImmersiveMode {
  @override
  Widget build(BuildContext context) {
    final ctrlProvider = analysisCtrlProvider(
      widget.steps,
      widget.orientation,
      widget.gameData.id,
    );

    return Column(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              _Ceval(ctrlProvider),
              _Board(ctrlProvider),
              _InlineTreeView(ctrlProvider),
            ],
          ),
        ),
        _BottomBar(ctrlProvider: ctrlProvider),
      ],
    );
  }
}

class _Board extends ConsumerWidget {
  const _Board(this.ctrlProvider);

  final AnalysisCtrlProvider ctrlProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analysisState = ref.watch(ctrlProvider);
    final boardPrefs = ref.watch(boardPreferencesProvider);
    final evalContext =
        ref.watch(ctrlProvider.select((value) => value.evaluationContext));
    final currentEvalBest = ref.watch(
      engineEvaluationProvider(evalContext).select((e) => e?.bestMove),
    );

    final evalBestMove =
        (currentEvalBest ?? analysisState.node.eval?.bestMove)?.cg;

    return LayoutBuilder(
      builder: (context, constraints) {
        final boardSize = constraints.biggest.shortestSide;
        return cg.Board(
          size: boardSize,
          data: cg.BoardData(
            orientation: analysisState.pov.cg,
            interactableSide: analysisState.position.isGameOver
                ? cg.InteractableSide.none
                : analysisState.position.turn == Side.white
                    ? cg.InteractableSide.white
                    : cg.InteractableSide.black,
            fen: analysisState.fen,
            isCheck: analysisState.position.isCheck,
            lastMove: analysisState.lastMove?.cg,
            sideToMove: analysisState.position.turn.cg,
            validMoves: analysisState.validMoves,
            onMove: (move, {isDrop, isPremove}) => ref
                .read(ctrlProvider.notifier)
                .onUserMove(Move.fromUci(move.uci)!),
            shapes: analysisState.isEngineEnabled && evalBestMove != null
                ? ISet([
                    cg.Arrow(
                      color: const Color(0x40003088),
                      orig: evalBestMove.from,
                      dest: evalBestMove.to,
                    )
                  ])
                : null,
          ),
          settings: cg.BoardSettings(
            pieceAssets: boardPrefs.pieceSet.assets,
            colorScheme: boardPrefs.boardTheme.colors,
            showValidMoves: boardPrefs.showLegalMoves,
            showLastMove: boardPrefs.boardHighlights,
            enableCoordinates: boardPrefs.coordinates,
            animationDuration: boardPrefs.pieceAnimationDuration,
          ),
        );
      },
    );
  }
}

class _Ceval extends ConsumerWidget {
  const _Ceval(this.ctrlProvider);

  final AnalysisCtrlProvider ctrlProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analysisState = ref.watch(ctrlProvider);

    return analysisState.isEngineEnabled
        ? EngineGauge(
            displayMode: EngineGaugeDisplayMode.horizontal,
            params: EngineGaugeParams(
              evaluationContext: analysisState.evaluationContext,
              position: analysisState.position,
              savedEval: analysisState.node.eval,
            ),
          )
        : const SizedBox.shrink();
  }
}

class _InlineTreeView extends ConsumerWidget {
  const _InlineTreeView(this.ctrlProvider);

  final AnalysisCtrlProvider ctrlProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nodes = ref.watch(ctrlProvider.select((value) => value.root));
    final currentPath =
        ref.watch(ctrlProvider.select((value) => value.currentPath));

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
        child: SingleChildScrollView(
          child: Wrap(
            spacing: 1.0,
            children: _buildTreeWidgets(
              ctrlProvider,
              nodes: nodes,
              inMainline: true,
              startSideline: false,
              path: UciPath.empty,
              currentPath: currentPath,
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildTreeWidgets(
    AnalysisCtrlProvider ctrlProvider, {
    required IList<ViewNode> nodes,
    required bool inMainline,
    required bool startSideline,
    required UciPath path,
    required UciPath currentPath,
  }) {
    if (nodes.isEmpty) {
      return inMainline
          ? []
          : [
              const Opacity(
                opacity: 0.8,
                child: Text(')', style: sideLineStyle),
              )
            ];
    }

    final List<Widget> widgets = [];

    if (startSideline) {
      widgets.add(
        const Opacity(
          opacity: 0.8,
          child: Text(
            '(',
            style: sideLineStyle,
          ),
        ),
      );
    }

    for (var i = 1; i < nodes.length; i++) {
      final node = nodes[i];
      if (inMainline) {
        widgets.add(
          Wrap(
            spacing: 1.0,
            alignment: WrapAlignment.center,
            children: _buildTreeWidgets(
              ctrlProvider,
              nodes: IList([node]),
              path: path,
              inMainline: false,
              startSideline: true,
              currentPath: currentPath,
            ),
          ),
        );
      } else {
        final newPath = path + node.id;
        widgets.add(
          _Move(
            ctrlProvider,
            path: newPath,
            move: node.sanMove,
            ply: node.ply,
            isCurrentMove: newPath == currentPath,
            isSideline: !inMainline,
          ),
        );
        widgets.addAll(
          _buildTreeWidgets(
            ctrlProvider,
            nodes: node.children,
            inMainline: false,
            path: newPath,
            startSideline: true,
            currentPath: currentPath,
          ),
        );
      }
    }

    final newPath = path + nodes[0].id;
    widgets.add(
      _Move(
        ctrlProvider,
        path: newPath,
        move: nodes[0].sanMove,
        ply: nodes[0].ply,
        isCurrentMove: newPath == currentPath,
        isSideline: !inMainline,
        startSideline: startSideline,
      ),
    );
    widgets.addAll(
      _buildTreeWidgets(
        ctrlProvider,
        nodes: nodes[0].children,
        inMainline: inMainline,
        startSideline: false,
        path: newPath,
        currentPath: currentPath,
      ),
    );

    return widgets;
  }
}

class _Move extends ConsumerWidget {
  const _Move(
    this.ctrlProvider, {
    required this.path,
    required this.move,
    required this.ply,
    required this.isCurrentMove,
    required this.isSideline,
    this.startSideline = false,
  });

  final AnalysisCtrlProvider ctrlProvider;
  final UciPath path;
  final SanMove move;
  final int ply;
  final bool isCurrentMove;
  final bool isSideline;
  final bool startSideline;
  static const borderRadius = BorderRadius.all(Radius.circular(8.0));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = buildText();
    return InkWell(
      borderRadius: borderRadius,
      onTap: () => ref.read(ctrlProvider.notifier).userJump(path),
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: isCurrentMove
            ? BoxDecoration(
                color: Theme.of(context).focusColor,
                shape: BoxShape.rectangle,
                borderRadius: borderRadius,
              )
            : null,
        child: Opacity(
          opacity: isSideline ? 0.8 : 1.0,
          child: Text(
            text,
            style: isSideline ? sideLineStyle : baseTextStyle,
          ),
        ),
      ),
    );
  }

  String buildText() {
    if (startSideline) {
      return '${(ply / 2).ceil()}... ${move.san}';
    } else {
      return ply.isOdd ? '${(ply / 2).ceil()}. ${move.san}' : move.san;
    }
  }
}

class _BottomBar extends ConsumerWidget {
  const _BottomBar({
    required this.ctrlProvider,
  });

  final AnalysisCtrlProvider ctrlProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analysisState = ref.watch(ctrlProvider);

    return Container(
      padding: Styles.horizontalBodyPadding,
      color: defaultTargetPlatform == TargetPlatform.iOS
          ? CupertinoTheme.of(context).barBackgroundColor
          : Theme.of(context).bottomAppBarTheme.color,
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            RepeatButton(
              onLongPress:
                  analysisState.canGoBack ? () => _moveBackward(ref) : null,
              child: BottomBarButton(
                onTap:
                    analysisState.canGoBack ? () => _moveBackward(ref) : null,
                label: 'Previous',
                shortLabel: 'Previous',
                icon: CupertinoIcons.chevron_back,
                showAndroidShortLabel: true,
                showAndroidTooltip: false,
              ),
            ),
            RepeatButton(
              onLongPress:
                  analysisState.canGoNext ? () => _moveForward(ref) : null,
              child: BottomBarButton(
                icon: CupertinoIcons.chevron_forward,
                label: context.l10n.next,
                shortLabel: context.l10n.next,
                showAndroidShortLabel: true,
                onTap: analysisState.canGoNext ? () => _moveForward(ref) : null,
                showAndroidTooltip: false,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _moveForward(WidgetRef ref) =>
      ref.read(ctrlProvider.notifier).userNext();
  void _moveBackward(WidgetRef ref) =>
      ref.read(ctrlProvider.notifier).userPrevious();
}
