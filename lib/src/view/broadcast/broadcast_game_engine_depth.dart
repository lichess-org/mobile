import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_game_controller.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/engine/engine.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_service.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:popover/popover.dart';

class BroadcastGameEngineDepth extends ConsumerWidget {
  final BroadcastRoundId roundId;
  final BroadcastGameId gameId;

  const BroadcastGameEngineDepth(this.roundId, this.gameId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEngineAvailable = ref.watch(
      broadcastGameControllerProvider(roundId, gameId).select(
        (value) => value.requireValue.isEngineAvailable,
      ),
    );
    final currentNode = ref.watch(
      broadcastGameControllerProvider(roundId, gameId)
          .select((value) => value.requireValue.currentNode),
    );
    final depth = ref.watch(
          engineEvaluationProvider.select((value) => value.eval?.depth),
        ) ??
        currentNode.eval?.depth;

    return isEngineAvailable && depth != null
        ? AppBarTextButton(
            onPressed: () {
              showPopover(
                context: context,
                bodyBuilder: (context) {
                  return _StockfishInfo(currentNode);
                },
                direction: PopoverDirection.top,
                width: 240,
                backgroundColor:
                    Theme.of(context).platform == TargetPlatform.android
                        ? Theme.of(context).dialogBackgroundColor
                        : CupertinoDynamicColor.resolve(
                            CupertinoColors.tertiarySystemBackground,
                            context,
                          ),
                transitionDuration: Duration.zero,
                popoverTransitionBuilder: (_, child) => child,
              );
            },
            child: RepaintBoundary(
              child: Container(
                width: 20.0,
                height: 20.0,
                padding: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).platform == TargetPlatform.android
                      ? Theme.of(context).colorScheme.secondary
                      : CupertinoTheme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Text(
                    '${math.min(99, depth)}',
                    style: TextStyle(
                      color: Theme.of(context).platform ==
                              TargetPlatform.android
                          ? Theme.of(context).colorScheme.onSecondary
                          : CupertinoTheme.of(context).primaryContrastingColor,
                      fontFeatures: const [
                        FontFeature.tabularFigures(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}

class _StockfishInfo extends ConsumerWidget {
  const _StockfishInfo(this.currentNode);

  final AnalysisCurrentNode currentNode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (engineName: engineName, eval: eval, state: engineState) =
        ref.watch(engineEvaluationProvider);

    final currentEval = eval ?? currentNode.eval;

    final knps = engineState == EngineState.computing
        ? ', ${eval?.knps.round()}kn/s'
        : '';
    final depth = currentEval?.depth ?? 0;
    final maxDepth = math.max(depth, kMaxEngineDepth);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        PlatformListTile(
          leading: Image.asset(
            'assets/images/stockfish/icon.png',
            width: 44,
            height: 44,
          ),
          title: Text(engineName),
          subtitle: Text(
            context.l10n.depthX(
              '$depth/$maxDepth$knps',
            ),
          ),
        ),
      ],
    );
  }
}
