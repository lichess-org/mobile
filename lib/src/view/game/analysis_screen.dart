import 'package:dartchess/dartchess.dart';
import 'package:chessground/chessground.dart' as cg;
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/game/analysis_ctrl.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/immersive_mode.dart';
import 'package:lichess_mobile/src/widgets/board_table.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/chessground_compat.dart';
import 'package:lichess_mobile/src/model/game/game.dart';

class AnalysisScreen extends StatelessWidget {
  const AnalysisScreen({
    required this.steps,
    required this.orientation,
  });

  final IList<GameStep> steps;
  final Side orientation;

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
      ),
    );
  }
}

class _Body extends ConsumerStatefulWidget {
  const _Body({
    required this.steps,
    required this.orientation,
  });

  final IList<GameStep> steps;
  final Side orientation;

  @override
  ConsumerState<_Body> createState() => _BodyState();
}

class _BodyState extends ConsumerState<_Body> with AndroidImmersiveMode {
  @override
  Widget build(BuildContext context) {
    final ctrlProvider = analysisCtrlProvider(widget.steps, widget.orientation);
    final analysisState = ref.watch(ctrlProvider);

    return Column(
      children: [
        Expanded(
          child: Center(
            child: SafeArea(
              bottom: false,
              child: BoardTable(
                boardData: cg.BoardData(
                  orientation: analysisState.pov.cg,
                  interactableSide: analysisState
                          .currentNode.position.isGameOver
                      ? cg.InteractableSide.none
                      : analysisState.currentNode.position.turn == Side.white
                          ? cg.InteractableSide.white
                          : cg.InteractableSide.black,
                  fen: analysisState.currentNode.fen,
                  isCheck: analysisState.currentNode.position.isCheck,
                  lastMove: analysisState.lastMove?.cg,
                  sideToMove: analysisState.currentNode.position.turn.cg,
                  validMoves: analysisState.validMoves,
                ),
                topTable: const SizedBox(height: 50),
                bottomTable: const SizedBox(height: 50),
              ),
            ),
          ),
        ),
        _BottomBar(ctrlProvider: ctrlProvider),
      ],
    );
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
            const RepeatButton(
              onLongPress: null,
              child: BottomBarButton(
                onTap: null,
                label: 'Previous',
                shortLabel: 'Previous',
                icon: CupertinoIcons.chevron_back,
                showAndroidTooltip: false,
              ),
            ),
            RepeatButton(
              onLongPress: null,
              child: BottomBarButton(
                icon: CupertinoIcons.chevron_forward,
                label: context.l10n.next,
                shortLabel: context.l10n.next,
                onTap: null,
                showAndroidTooltip: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
