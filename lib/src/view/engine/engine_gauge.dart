import 'package:dartchess/dartchess.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_service.dart';
import 'package:lichess_mobile/src/model/settings/brightness.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';

const double kEvalGaugeSize = 24.0;
const double kEvalGaugeFontSize = 11.0;
const Color _kEvalGaugeBackgroundColor = Color(0xFF444444);
const Color _kEvalGaugeValueColorDarkBg = Color(0xEEEEEEEE);
const Color _kEvalGaugeValueColorLightBg = Color(0xFFFFFFFF);

enum EngineGaugeDisplayMode { vertical, horizontal }

typedef EngineGaugeParams =
    ({
      bool isLocalEngineAvailable,

      /// Only used for vertical display mode.
      Side orientation,

      /// Position to evaluate.
      Position position,

      /// Saved evaluation to display when the current evaluation is not available.
      Eval? savedEval,
    });

class EngineGauge extends ConsumerWidget {
  const EngineGauge({required this.displayMode, required this.params});

  final EngineGaugeDisplayMode displayMode;

  final EngineGaugeParams params;

  static Color backgroundColor(BuildContext context, Brightness brightness) =>
      Theme.of(context).platform == TargetPlatform.iOS
          ? _kEvalGaugeBackgroundColor
          : brightness == Brightness.dark
          ? lighten(Theme.of(context).colorScheme.surface, .07)
          : lighten(Theme.of(context).colorScheme.onSurface, .17);

  static Color valueColor(BuildContext context, Brightness brightness) =>
      Theme.of(context).platform == TargetPlatform.iOS
          ? brightness == Brightness.dark
              ? _kEvalGaugeValueColorDarkBg
              : _kEvalGaugeValueColorLightBg
          : brightness == Brightness.dark
          ? darken(Theme.of(context).colorScheme.onSurface, .03)
          : darken(Theme.of(context).colorScheme.surface, .01);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localEval =
        params.isLocalEngineAvailable ? ref.watch(engineEvaluationProvider).eval : null;

    return localEval != null
        ? _EvalGauge(
          displayMode: displayMode,
          position: params.position,
          orientation: params.orientation,
          eval: localEval,
        )
        : params.savedEval != null
        ? _EvalGauge(
          displayMode: displayMode,
          position: params.position,
          orientation: params.orientation,
          eval: params.savedEval,
        )
        : _EvalGauge(
          displayMode: displayMode,
          position: params.position,
          orientation: params.orientation,
        );
  }
}

class _EvalGauge extends ConsumerStatefulWidget {
  const _EvalGauge({
    required this.position,
    required this.displayMode,
    required this.orientation,
    this.eval,
  });

  final EngineGaugeDisplayMode displayMode;
  final Position position;
  final Eval? eval;
  final Side orientation;

  double get whiteWinningChances => eval?.winningChances(Side.white) ?? 0.0;
  double get animationValue =>
      (((whiteWinningChances + 1) * 0.5).abs() * 100).roundToDouble() / 100;

  @override
  ConsumerState<_EvalGauge> createState() => _EvalGaugeState();
}

class _EvalGaugeState extends ConsumerState<_EvalGauge> {
  double fromValue = 0.5;

  @override
  void didUpdateWidget(_EvalGauge oldWidget) {
    super.didUpdateWidget(oldWidget);
    fromValue = oldWidget.animationValue;
  }

  @override
  Widget build(BuildContext context) {
    final brightness = ref.watch(currentBrightnessProvider);
    final TextDirection textDirection = Directionality.of(context);

    final evalDisplay =
        widget.position.outcome != null
            ? widget.position.outcome!.winner == null
                ? widget.position.isStalemate
                    ? context.l10n.stalemate
                    : context.l10n.insufficientMaterial
                : widget.position.isCheckmate
                ? context.l10n.checkmate
                : context.l10n.variantEnding
            : widget.eval?.evalString;

    final toValue =
        widget.position.outcome != null
            ? widget.position.outcome!.winner == null
                ? 0.5
                : widget.position.outcome!.winner == Side.white
                ? 1.0
                : 0.0
            : widget.animationValue;

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: fromValue, end: toValue),
      duration: const Duration(milliseconds: 800),
      curve: Curves.ease,
      builder: (BuildContext context, double value, Widget? child) {
        return Semantics(
          label: context.l10n.evaluationGauge,
          value: evalDisplay ?? context.l10n.loadingEngine,
          child: RepaintBoundary(
            child: Container(
              constraints:
                  widget.displayMode == EngineGaugeDisplayMode.vertical
                      ? const BoxConstraints(minWidth: kEvalGaugeSize, minHeight: double.infinity)
                      : const BoxConstraints(minWidth: double.infinity, minHeight: kEvalGaugeSize),
              width: widget.displayMode == EngineGaugeDisplayMode.vertical ? kEvalGaugeSize : null,
              height: widget.displayMode == EngineGaugeDisplayMode.vertical ? null : kEvalGaugeSize,
              child: CustomPaint(
                painter:
                    widget.displayMode == EngineGaugeDisplayMode.vertical
                        ? _EvalGaugeVerticalPainter(
                          orientation: widget.orientation,
                          backgroundColor: EngineGauge.backgroundColor(context, brightness),
                          valueColor: EngineGauge.valueColor(context, brightness),
                          value: value,
                        )
                        : _EvalGaugeHorizontalPainter(
                          backgroundColor: EngineGauge.backgroundColor(context, brightness),
                          valueColor: EngineGauge.valueColor(context, brightness),
                          value: value,
                          textDirection: textDirection,
                        ),
                child:
                    widget.displayMode == EngineGaugeDisplayMode.vertical
                        ? const SizedBox.shrink()
                        : Align(
                          alignment: toValue >= 0.5 ? Alignment.centerLeft : Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Text(
                              evalDisplay ?? '',
                              style: TextStyle(
                                color: toValue >= 0.5 ? Colors.black : Colors.white,
                                fontSize: kEvalGaugeFontSize,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _EvalGaugeHorizontalPainter extends CustomPainter {
  const _EvalGaugeHorizontalPainter({
    required this.backgroundColor,
    required this.valueColor,
    required this.value,
    required this.textDirection,
  });

  final Color backgroundColor;
  final Color valueColor;
  final double value;
  final TextDirection textDirection;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint =
        Paint()
          ..color = backgroundColor
          ..style = PaintingStyle.fill;
    canvas.drawRect(Offset.zero & size, paint);

    paint.color = valueColor;

    void drawBar(double x, double width) {
      if (width <= 0.0) {
        return;
      }

      final double left;
      switch (textDirection) {
        case TextDirection.rtl:
          left = size.width - width - x;
        case TextDirection.ltr:
          left = x;
      }
      canvas.drawRect(Offset(left, 0.0) & Size(width, size.height), paint);
    }

    drawBar(0.0, clampDouble(value, 0.0, 1.0) * size.width);
  }

  @override
  bool shouldRepaint(_EvalGaugeHorizontalPainter oldPainter) {
    return oldPainter.backgroundColor != backgroundColor ||
        oldPainter.valueColor != valueColor ||
        oldPainter.value != value ||
        oldPainter.textDirection != textDirection;
  }
}

class _EvalGaugeVerticalPainter extends CustomPainter {
  const _EvalGaugeVerticalPainter({
    required this.backgroundColor,
    required this.valueColor,
    required this.value,
    required this.orientation,
  });

  final Color backgroundColor;
  final Color valueColor;
  final double value;
  final Side orientation;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint =
        Paint()
          ..color = backgroundColor
          ..style = PaintingStyle.fill;
    canvas.drawRect(Offset.zero & size, paint);

    paint.color = valueColor;

    void drawBar(double y, double height) {
      if (height == 0.0) {
        return;
      }

      canvas.drawRect(Offset(0.0, y) & Size(size.width, height), paint);
    }

    final double height = clampDouble(value, 0.0, 1.0) * size.height;

    drawBar(
      orientation == Side.white ? size.height : 0.0,
      height * (orientation == Side.white ? -1.0 : 1.0),
    );
  }

  @override
  bool shouldRepaint(_EvalGaugeVerticalPainter oldPainter) {
    return oldPainter.backgroundColor != backgroundColor ||
        oldPainter.valueColor != valueColor ||
        oldPainter.value != value;
  }
}
