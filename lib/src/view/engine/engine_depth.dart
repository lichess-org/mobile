import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/engine/engine.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_service.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:popover/popover.dart';

class EngineDepth extends ConsumerWidget {
  const EngineDepth({this.eval});

  final ClientEval? eval;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final depth = eval?.depth;

    return depth != null
        ? AppBarTextButton(
          onPressed: switch (eval) {
            final LocalEval? localEval => () {
              showPopover(
                context: context,
                bodyBuilder: (context) {
                  return _StockfishInfo(localEval);
                },
                direction: PopoverDirection.top,
                width: 240,
                backgroundColor:
                    Theme.of(context).platform == TargetPlatform.android
                        ? DialogTheme.of(context).backgroundColor ??
                            ColorScheme.of(context).surfaceContainerHigh
                        : CupertinoDynamicColor.resolve(
                          CupertinoColors.tertiarySystemBackground,
                          context,
                        ),
                transitionDuration: Duration.zero,
                popoverTransitionBuilder: (_, child) => child,
              );
            },
            CloudEval() => () {},
          },
          child: switch (eval) {
            LocalEval() || null => RepaintBoundary(
              child: Container(
                width: 20.0,
                height: 20.0,
                padding: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                  color: ColorScheme.of(context).secondary,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Text(
                    '${math.min(99, depth)}',
                    style: TextStyle(
                      color: ColorScheme.of(context).onSecondary,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ),
              ),
            ),
            CloudEval(:final depth) => Stack(
              alignment: const AlignmentDirectional(-0.05, 0.15),
              children: [
                Icon(Icons.cloud, size: 30, color: ColorScheme.of(context).secondary),
                Text(
                  '${math.min(99, depth)}',
                  style: TextStyle(
                    color: ColorScheme.of(context).onSecondary,
                    fontFeatures: const [FontFeature.tabularFigures()],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          },
        )
        : const SizedBox.shrink();
  }
}

class _StockfishInfo extends ConsumerWidget {
  const _StockfishInfo(this.defaultEval);

  final LocalEval? defaultEval;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (engineName: engineName, eval: eval, state: engineState) = ref.watch(
      engineEvaluationProvider,
    );

    final currentEval = eval ?? defaultEval;

    final knps = engineState == EngineState.computing ? ', ${eval?.knps.round()}kn/s' : '';
    final depth = currentEval?.depth ?? 0;

    return PlatformListTile(
      leading: Image.asset('assets/images/stockfish/icon.png', width: 44, height: 44),
      title: Text(engineName),
      subtitle: Text(context.l10n.depthX('$depth$knps')),
    );
  }
}
