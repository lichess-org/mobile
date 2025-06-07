import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/engine/engine.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_service.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:popover/popover.dart';

class EngineDepth extends ConsumerWidget {
  const EngineDepth({this.savedEval, this.goDeeper});

  final ClientEval? savedEval;
  final VoidCallback? goDeeper;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (engineName: engineName, eval: localEval, state: engineState, currentWork: work) = ref
        .watch(engineEvaluationProvider);
    final eval = pickBestClientEval(localEval: localEval, savedEval: savedEval);

    final color =
        engineName ==
            'Stockfish' // while loading name is 'Stockfish'
        ? Colors.grey
        : ColorScheme.of(context).secondary;
    final textColor = ColorScheme.of(context).onSecondary;

    final loadingIndicator = SpinKitFadingFour(color: textColor.withValues(alpha: 0.7), size: 10);

    const microChipSize = 28.0;
    final iconTextStyle = TextStyle(
      color: textColor,
      fontFeatures: const [FontFeature.tabularFigures()],
      fontSize: 11,
    );

    return SemanticIconButton(
      semanticsLabel: switch (eval) {
        LocalEval(:final depth) => '$engineName, ${context.l10n.depthX('$depth')}',
        CloudEval(:final depth) =>
          '${context.l10n.cloudAnalysis}, ${context.l10n.depthX('$depth')}',
        _ => context.l10n.loadingEngine,
      },
      onPressed: eval != null
          ? () {
              showPopover(
                context: context,
                bodyBuilder: (_) {
                  return _EnginePopup(eval: eval, goDeeper: goDeeper);
                },
                direction: PopoverDirection.top,
                width: 250,
                backgroundColor:
                    DialogTheme.of(context).backgroundColor ??
                    ColorScheme.of(context).surfaceContainerHigh,
                transitionDuration: Duration.zero,
                popoverTransitionBuilder: (_, child) => child,
              );
            }
          : null,
      icon: Badge(
        offset: const Offset(4, -7),
        backgroundColor: ColorScheme.of(context).tertiaryContainer,
        textColor: ColorScheme.of(context).onTertiaryContainer,
        label: eval is CloudEval ? const Text('CLOUD') : null,
        textStyle: const TextStyle(fontSize: 8),
        isLabelVisible: eval is CloudEval,
        child: AnimatedOpacity(
          opacity: engineState == EngineState.computing ? 1.0 : 0.8,
          duration: const Duration(milliseconds: 150),
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: const Size(microChipSize, microChipSize),
                painter: MicroChipPainter(color),
              ),
              SizedBox(
                width: microChipSize,
                height: microChipSize,
                child: RepaintBoundary(
                  child: Center(
                    child: eval?.depth != null
                        ? Text('${math.min(99, eval!.depth)}', style: iconTextStyle)
                        : loadingIndicator,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MicroChipPainter extends CustomPainter {
  const MicroChipPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const pinLength = 3.5;
    const pinRadius = Radius.circular(1);
    const innerRimWidth = 1.0;
    const outerRimWidth = 2.5;

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = outerRimWidth;

    final innerSquareSize = size.width - pinLength - innerRimWidth - outerRimWidth / 2;

    final innerSquarePath = Path()
      ..addRRect(
        RRect.fromLTRBR(
          pinLength + innerRimWidth + outerRimWidth / 2,
          pinLength + innerRimWidth + outerRimWidth / 2,
          innerSquareSize,
          innerSquareSize,
          const Radius.circular(2),
        ),
      );

    final outerRimPath = Path()
      ..addRRect(
        RRect.fromLTRBR(
          pinLength,
          pinLength,
          size.width - pinLength,
          size.height - pinLength,
          const Radius.circular(4),
        ),
      );

    final pinsPath = Path();
    final chipSide = size.width - pinLength * 2;
    final pinsMargin = (chipSide - chipSide * 0.6) / 2;
    final pinWidth = chipSide / 10;
    final pinSpacing = (chipSide - (pinsMargin * 2) - 3 * pinWidth) / 2;
    // draw left pins
    for (var i = 0; i < 3; i++) {
      pinsPath.addRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(
            0,
            pinLength + pinsMargin + i * (pinWidth + pinSpacing),
            pinLength,
            pinWidth,
          ),
          topLeft: pinRadius,
          bottomLeft: pinRadius,
        ),
      );
    }
    // draw right pins
    for (var i = 0; i < 3; i++) {
      pinsPath.addRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(
            size.width - pinLength,
            pinLength + pinsMargin + i * (pinWidth + pinSpacing),
            pinLength,
            pinWidth,
          ),
          topRight: pinRadius,
          bottomRight: pinRadius,
        ),
      );
    }
    // draw top pins
    for (var i = 0; i < 3; i++) {
      pinsPath.addRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(
            pinLength + pinsMargin + i * (pinWidth + pinSpacing),
            0,
            pinWidth,
            pinLength,
          ),
          topLeft: pinRadius,
          topRight: pinRadius,
        ),
      );
    }
    // draw bottom pins
    for (var i = 0; i < 3; i++) {
      pinsPath.addRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(
            pinLength + pinsMargin + i * (pinWidth + pinSpacing),
            size.height - pinLength,
            pinWidth,
            pinLength,
          ),
          bottomLeft: pinRadius,
          bottomRight: pinRadius,
        ),
      );
    }

    canvas.drawPath(outerRimPath, strokePaint);
    canvas.drawPath(pinsPath, fillPaint);
    canvas.drawPath(innerSquarePath, fillPaint);
  }

  @override
  bool shouldRepaint(covariant MicroChipPainter oldDelegate) => color != oldDelegate.color;
}

class _EnginePopup extends ConsumerWidget {
  const _EnginePopup({required this.eval, this.goDeeper});

  final ClientEval eval;
  final VoidCallback? goDeeper;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final evalState = ref.watch(engineEvaluationProvider);
    final (state: engineState, currentWork: work, engineName: engineName, eval: evalStateEval) =
        evalState;
    final bool canGoDeeper =
        goDeeper != null &&
        engineState == EngineState.idle &&
        (work == null || work.isDeeper != true);

    final currentEval = engineState == EngineState.computing ? evalStateEval ?? eval : eval;

    if (currentEval is CloudEval) {
      return ListTile(
        contentPadding: const EdgeInsets.only(left: 16.0),
        title: Text(context.l10n.cloudAnalysis),
        subtitle: Text(context.l10n.depthX('${eval.depth}')),
        trailing: canGoDeeper
            ? IconButton(
                icon: const Icon(Icons.add_circle_outlined),
                onPressed: goDeeper,
                tooltip: context.l10n.goDeeper,
              )
            : null,
      );
    }

    final knps = engineState == EngineState.computing ? ', ${evalStateEval?.knps.round()}kn/s' : '';
    final depth = currentEval.depth;

    // remove Fairy-Stockfish version from engine name
    final fixedEngineName = engineName.startsWith('Fairy-Stockfish')
        ? 'Fairy-Stockfish'
        : engineName;

    return ListTile(
      contentPadding: const EdgeInsets.only(left: 16.0),
      leading: Image.asset('assets/images/stockfish/icon.png', width: 44, height: 44),
      title: Text(fixedEngineName),
      subtitle: Text(context.l10n.depthX('$depth$knps')),
      trailing: canGoDeeper
          ? IconButton(
              icon: const Icon(Icons.add_circle_outlined),
              onPressed: goDeeper,
              tooltip: context.l10n.goDeeper,
            )
          : null,
    );
  }
}
