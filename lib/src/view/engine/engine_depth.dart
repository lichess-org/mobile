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
  const EngineDepth({this.savedEval});

  final ClientEval? savedEval;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localEval = ref.watch(engineEvaluationProvider).eval;
    final eval = pickBestClientEval(localEval: localEval, savedEval: savedEval);

    const cloudSize = 31.0;
    const microChipSize = 29.0;
    const cloudIconAlignment = AlignmentDirectional(0.0, 0.20);
    final cloudIcon = Icon(Icons.cloud, size: cloudSize, color: ColorScheme.of(context).secondary);
    final iconTextStyle = TextStyle(
      color: ColorScheme.of(context).onSecondary,
      fontFeatures: const [FontFeature.tabularFigures()],
      fontSize: 12,
    );

    return AppBarTextButton(
      onPressed:
          eval != null
              ? () {
                showPopover(
                  context: context,
                  bodyBuilder: (context) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        switch (eval) {
                          LocalEval() => _StockfishInfo(eval),
                          CloudEval(:final depth) => PlatformListTile(
                            title: Text(context.l10n.cloudAnalysis),
                            subtitle: Text(context.l10n.depthX('$depth')),
                          ),
                        },
                      ],
                    );
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
              }
              : null,
      child: switch (eval) {
        LocalEval(:final depth) => RepaintBoundary(
          child: Stack(
            children: [
              CustomPaint(
                size: const Size(microChipSize, microChipSize),
                painter: MicroChipPainter(ColorScheme.of(context).secondary),
              ),
              SizedBox(
                width: microChipSize,
                height: microChipSize,
                child: Center(child: Text('${math.min(99, depth)}', style: iconTextStyle)),
              ),
            ],
          ),
        ),
        CloudEval(:final depth) => Stack(
          children: [
            cloudIcon,
            SizedBox(
              width: cloudSize,
              height: cloudSize,
              child: Align(
                alignment: cloudIconAlignment,
                child: Text('${math.min(99, depth)}', style: iconTextStyle),
              ),
            ),
          ],
        ),
        null => Stack(
          children: [
            cloudIcon,
            SizedBox(
              width: cloudSize,
              height: cloudSize,
              child: Align(
                alignment: cloudIconAlignment,
                child: Text('\u{2026}', style: iconTextStyle),
              ),
            ),
          ],
        ),
      },
    );
  }
}

class MicroChipPainter extends CustomPainter {
  const MicroChipPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const pinLength = 3.5;
    const pinRadius = Radius.circular(3);
    const innerRimWidth = 1.5;
    const outerRimWidth = 2.0;

    final fillPaint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;
    final strokePaint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = outerRimWidth;

    final innerSquareSize = size.width - pinLength - innerRimWidth - outerRimWidth / 2;

    final innerSquarePath =
        Path()..addRect(
          Rect.fromLTRB(
            pinLength + innerRimWidth + outerRimWidth / 2,
            pinLength + innerRimWidth + outerRimWidth / 2,
            innerSquareSize,
            innerSquareSize,
          ),
        );

    final outerRimPath =
        Path()..addRRect(
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
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _StockfishInfo extends ConsumerWidget {
  const _StockfishInfo(this.defaultEval);

  final ClientEval? defaultEval;

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
