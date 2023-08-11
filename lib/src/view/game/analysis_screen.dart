import 'package:collection/collection.dart';
import 'package:dartchess/dartchess.dart';
import 'package:chessground/chessground.dart' as cg;
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/tree.dart';
import 'package:lichess_mobile/src/model/common/uci.dart';
import 'package:lichess_mobile/src/model/engine/engine_evaluation.dart';
import 'package:lichess_mobile/src/model/game/analysis_ctrl.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/immersive_mode.dart';
import 'package:lichess_mobile/src/view/engine/engine_gauge.dart';
import 'package:lichess_mobile/src/widgets/adaptive_action_sheet.dart';
import 'package:lichess_mobile/src/widgets/adaptive_dialog.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/non_linear_slider.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/chessground_compat.dart';
import 'package:lichess_mobile/src/model/game/game.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';

const baseTextStyle =
    TextStyle(fontFamily: 'ChessFont', fontWeight: FontWeight.bold);
const sideLineStyle =
    TextStyle(fontFamily: 'ChessFont', fontStyle: FontStyle.italic);

class AnalysisScreen extends ConsumerWidget {
  const AnalysisScreen({
    required this.steps,
    required this.orientation,
    required this.gameData,
  });

  final IList<GameStep> steps;
  final Side orientation;
  final ArchivedGameData gameData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ConsumerPlatformWidget(
      androidBuilder: _androidBuilder,
      iosBuilder: _iosBuilder,
      ref: ref,
    );
  }

  Widget _androidBuilder(BuildContext context, WidgetRef ref) {
    final ctrlProvider = analysisCtrlProvider(steps, orientation, gameData.id);
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.gameAnalysis),
        actions: [
          _EngineDepth(
            ref.watch(ctrlProvider.select((value) => value.evaluationContext)),
          ),
          SettingsButton(
            onPressed: () => showAdaptiveDialog<void>(
              context: context,
              builder: (_) => _Prefrences(ctrlProvider),
            ),
          )
        ],
      ),
      body: _Body(ctrlProvider: ctrlProvider),
    );
  }

  Widget _iosBuilder(BuildContext context, WidgetRef ref) {
    final ctrlProvider = analysisCtrlProvider(steps, orientation, gameData.id);
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(context.l10n.analysis),
      ),
      child: _Body(ctrlProvider: ctrlProvider),
    );
  }
}

class _Body extends ConsumerStatefulWidget {
  const _Body({
    required this.ctrlProvider,
  });

  final AnalysisCtrlProvider ctrlProvider;

  @override
  ConsumerState<_Body> createState() => _BodyState();
}

class _BodyState extends ConsumerState<_Body> with AndroidImmersiveMode {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              _TopTable(widget.ctrlProvider),
              _Board(widget.ctrlProvider),
              _InlineTreeView(widget.ctrlProvider),
            ],
          ),
        ),
        _BottomBar(ctrlProvider: widget.ctrlProvider),
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
    final evalBestMoves = ref.watch(
      engineEvaluationProvider(evalContext).select((e) => e?.bestMoves),
    );

    final bestMoves = evalBestMoves ?? analysisState.node.eval?.bestMoves;

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
            shapes: analysisState.isEngineEnabled && bestMoves != null
                ? ISet(
                    bestMoves.where((move) => move != null).mapIndexed(
                          (i, move) => cg.Arrow(
                            color: const Color(0x40003088)
                                .withOpacity(0.4 - 0.15 * i),
                            orig: move!.cg.from,
                            dest: move.cg.to,
                          ),
                        ),
                  )
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

class _TopTable extends ConsumerWidget {
  const _TopTable(this.ctrlProvider);

  final AnalysisCtrlProvider ctrlProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analysisState = ref.watch(ctrlProvider);

    return analysisState.isEngineEnabled
        ? Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EngineGauge(
                displayMode: EngineGaugeDisplayMode.horizontal,
                params: EngineGaugeParams(
                  evaluationContext: analysisState.evaluationContext,
                  position: analysisState.position,
                  savedEval: analysisState.node.eval,
                ),
              ),
              _CevalLines(ctrlProvider),
            ],
          )
        : const SizedBox.shrink();
  }
}

class _CevalLines extends ConsumerWidget {
  const _CevalLines(this.ctrlProvider);
  final AnalysisCtrlProvider ctrlProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analysisState = ref.watch(ctrlProvider);
    final ceval =
        ref.watch(engineEvaluationProvider(analysisState.evaluationContext));

    final content = ceval != null
        ? ceval.pvs
            .map(
              (pv) => _CevalLine(
                ctrlProvider,
                pv.sanMoves(ceval.currentPosition),
                analysisState.node.ply,
                pv,
              ),
            )
            .toList()
        : (analysisState.node.eval != null
            ? analysisState.node.eval!.pvs
                .map(
                  (pv) => _CevalLine(
                    ctrlProvider,
                    pv.sanMoves(analysisState.node.position),
                    analysisState.node.ply,
                    pv,
                  ),
                )
                .toList()
            : null);

    return content != null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: content,
          )
        : kEmptyWidget;
  }
}

class _CevalLine extends ConsumerWidget {
  const _CevalLine(
    this.ctrlProvider,
    this.moves,
    this.initialPly,
    this.data,
  );

  final AnalysisCtrlProvider ctrlProvider;
  final List<String> moves;
  final int initialPly;
  final PvData data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final builder = StringBuffer();
    var ply = initialPly + 1;
    moves.forEachIndexed((i, s) {
      builder.write(
        ply.isOdd
            ? '${(ply / 2).ceil()}. $s '
            : i == 0
                ? '${(ply / 2).ceil()}... $s '
                : '$s ',
      );
      ply += 1;
    });

    final eval = data.evalString;

    return InkWell(
      onTap: () => ref
          .read(ctrlProvider.notifier)
          .onUserMove(Move.fromUci(data.moves[0])!),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(2.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
              ),
              child: Text(
                eval,
                style: const TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(width: 8.0),
            Flexible(
              child: Text(
                builder.toString(),
                style: const TextStyle(
                  fontFamily: 'ChessFont',
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
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
          SizedBox(
            width: double.infinity,
            child: Wrap(
              spacing: 1.0,
              children: _buildTreeWidgets(
                ctrlProvider,
                nodes: IList([node]),
                path: path,
                inMainline: false,
                startSideline: true,
                currentPath: currentPath,
              ),
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
            BottomBarIconButton(
              semanticsLabel: context.l10n.menu,
              onPressed: () {
                _showGameMenu(context, ref);
              },
              icon: const Icon(Icons.menu),
            ),
            const SizedBox(
              width: 44.0,
            ),
            const SizedBox(
              width: 44.0,
            ),
            RepeatButton(
              onLongPress:
                  analysisState.canGoBack ? () => _moveBackward(ref) : null,
              child: BottomBarButton(
                onTap:
                    analysisState.canGoBack ? () => _moveBackward(ref) : null,
                label: 'Previous',
                shortLabel: 'Previous',
                icon: CupertinoIcons.chevron_back,
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

  Future<void> _showGameMenu(BuildContext context, WidgetRef ref) {
    return showAdaptiveActionSheet(
      context: context,
      actions: [
        BottomSheetAction(
          leading: const Icon(Icons.swap_vert),
          label: Text(context.l10n.flipBoard),
          onPressed: (context) {
            ref.read(ctrlProvider.notifier).toggleBoard();
          },
        ),
      ],
    );
  }
}

class _EngineDepth extends ConsumerWidget {
  const _EngineDepth(this.evalContext);

  final EvaluationContext evalContext;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final depth = ref.watch(
      engineEvaluationProvider(evalContext).select((value) => value?.depth),
    );

    return depth != null ? Text('$depth') : kEmptyWidget;
  }
}

class _Prefrences extends ConsumerWidget {
  const _Prefrences(this.ctrlProvider);

  final AnalysisCtrlProvider ctrlProvider;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(ctrlProvider);

    final content = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: Styles.bodyPadding,
            child: Text(
              context.l10n.settingsSettings,
              style: Styles.title,
            ),
          ),
          SwitchSettingTile(
            title: Text(context.l10n.bestMoveArrow),
            value: state.showBestMoveArrow,
            onChanged: (value) =>
                ref.read(ctrlProvider.notifier).toggleBestMoveArrow(),
          ),
          SwitchSettingTile(
            title: Text(context.l10n.evaluationGauge),
            value: state.isEngineEnabled,
            onChanged: (value) =>
                ref.read(ctrlProvider.notifier).toggleLocalEvaluation(),
          ),
          PlatformListTile(
            title: Text.rich(
              TextSpan(
                text: '${context.l10n.multipleLines}: ',
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                ),
                children: [
                  TextSpan(
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    text: state.numCevalLines.toString(),
                  ),
                ],
              ),
            ),
            subtitle: NonLinearSlider(
              value: state.numCevalLines,
              values: const [1, 2, 3],
              onChangeEnd: (value) =>
                  ref.read(ctrlProvider.notifier).setCevalLines(value.toInt()),
            ),
          ),
          PlatformListTile(
            title: Text.rich(
              TextSpan(
                text: '${context.l10n.cpus}: ',
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                ),
                children: [
                  TextSpan(
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    text: state.numCores.toString(),
                  ),
                ],
              ),
            ),
            subtitle: NonLinearSlider(
              value: state.numCores,
              values: List.generate(maxCores, (index) => index + 1),
              onChangeEnd: (value) =>
                  ref.read(ctrlProvider.notifier).setCores(value.toInt()),
            ),
          ),
        ],
      ),
    );

    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return CupertinoAlertDialog(
          title: Text(context.l10n.settingsSettings),
          content: content,
        );
      case TargetPlatform.android:
        return Dialog(child: content);

      default:
        throw UnimplementedError('Platform not supported');
    }
  }
}
