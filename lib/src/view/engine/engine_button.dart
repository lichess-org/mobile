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

/// A button to toggle engine evaluation and show engine depth.
class EngineButton extends ConsumerWidget {
  const EngineButton({this.onTap, this.savedEval, this.goDeeper});

  final ClientEval? savedEval;

  final VoidCallback? onTap;

  final VoidCallback? goDeeper;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (engineName: engineName, eval: localEval, state: engineState, currentWork: work) = ref
        .watch(engineEvaluationProvider);
    final eval = pickBestClientEval(localEval: localEval, savedEval: savedEval);

    final color = switch (engineState) {
      EngineState.loading ||
      EngineState.computing ||
      EngineState.idle => ColorScheme.of(context).primary,
      _ => IconTheme.of(context).color ?? TextTheme.of(context).bodyMedium!.color!,
    };
    final textColor = switch (engineState) {
      EngineState.loading ||
      EngineState.computing ||
      EngineState.idle => ColorScheme.of(context).primary,
      _ => IconTheme.of(context).color ?? TextTheme.of(context).bodyMedium!.color!,
    };

    final loadingIndicator = SpinKitFadingFour(color: textColor.withValues(alpha: 0.7), size: 10);

    const microChipSize = 28.0;
    final iconTextStyle = TextStyle(
      color: textColor,
      fontFeatures: const [FontFeature.tabularFigures()],
      fontWeight: FontWeight.w600,
      fontSize: 11,
    );

    return SemanticIconButton(
      semanticsLabel: switch (eval) {
        LocalEval(:final depth) => '$engineName, ${context.l10n.depthX('$depth')}',
        CloudEval(:final depth) =>
          '${context.l10n.cloudAnalysis}, ${context.l10n.depthX('$depth')}',
        _ => context.l10n.loadingEngine,
      },
      onPressed: onTap,
      onLongPress: () {
        showPopover(
          context: context,
          bodyBuilder: (_) {
            return _EnginePopup(goDeeper: goDeeper);
          },
          direction: PopoverDirection.top,
          width: 250,
          backgroundColor:
              DialogTheme.of(context).backgroundColor ??
              ColorScheme.of(context).surfaceContainerHigh,
          transitionDuration: Duration.zero,
          popoverTransitionBuilder: (_, child) => child,
        );
      },
      icon: Badge(
        offset: const Offset(4, -7),
        backgroundColor: ColorScheme.of(context).tertiaryContainer,
        textColor: ColorScheme.of(context).onTertiaryContainer,
        label: eval is CloudEval ? const Text('CLOUD') : null,
        textStyle: const TextStyle(fontSize: 8),
        isLabelVisible: eval is CloudEval,
        child: AnimatedOpacity(
          opacity: switch (engineState) {
            EngineState.idle => 0.8,
            _ => 1.0,
          },
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
                    child: eval is CloudEval
                        ? Text('${math.min(99, eval.depth)}', style: iconTextStyle)
                        : switch (engineState) {
                            EngineState.computing || EngineState.idle =>
                              eval?.depth != null
                                  ? Text('${math.min(99, eval!.depth)}', style: iconTextStyle)
                                  : loadingIndicator,
                            _ => const SizedBox.shrink(),
                          },
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
    const outerRimWidth = 1.5;

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final outerStrokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = outerRimWidth;

    final innerStrokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = innerRimWidth;

    final innerSquareSize = size.width - pinLength - innerRimWidth - outerRimWidth;

    final innerSquarePath = Path()
      ..addRRect(
        RRect.fromLTRBR(
          pinLength + innerRimWidth + outerRimWidth,
          pinLength + innerRimWidth + outerRimWidth,
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

    canvas.drawPath(outerRimPath, outerStrokePaint);
    canvas.drawPath(pinsPath, fillPaint);
    canvas.drawPath(innerSquarePath, innerStrokePaint);
  }

  @override
  bool shouldRepaint(covariant MicroChipPainter oldDelegate) => color != oldDelegate.color;
}

class _EnginePopup extends ConsumerWidget {
  const _EnginePopup({this.goDeeper});

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

    final currentEval = switch (engineState) {
      EngineState.computing || EngineState.idle => evalStateEval,
      _ => null,
    };

    if (currentEval is CloudEval) {
      return ListTile(
        contentPadding: const EdgeInsets.only(left: 16.0),
        title: Text(context.l10n.cloudAnalysis),
        subtitle: Text(context.l10n.depthX('${currentEval!.depth}')),
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

    // remove Fairy-Stockfish version from engine name
    final fixedEngineName = engineName.startsWith('Fairy-Stockfish')
        ? 'Fairy-Stockfish'
        : engineName;

    return ListTile(
      contentPadding: const EdgeInsets.only(left: 16.0),
      leading: Image.asset('assets/images/stockfish/icon.png', width: 44, height: 44),
      title: Text(fixedEngineName),
      subtitle: currentEval != null ? Text(context.l10n.depthX('${currentEval.depth}$knps')) : null,
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
