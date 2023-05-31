import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartchess/dartchess.dart';

import 'package:lichess_mobile/src/model/settings/brightness.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/engine/engine_evaluation.dart';

const double _kEvalGaugeHeight = 20.0;
const Color _kEvalGaugeBackgroundColor = Color(0xFF444444);
const Color _kEvalGaugeValueColorDarkBg = Color(0xEEEEEEEE);
const Color _kEvalGaugeValueColorLightBg = Color(0xFFFFFFFF);

class EngineGauge extends ConsumerWidget {
  const EngineGauge({
    required this.evaluationContext,
    required this.position,
    this.savedEval,
  });

  final EvaluationContext evaluationContext;

  /// Position to evaluate.
  final Position position;

  /// Saved evaluation to display when the current evaluation is not available.
  final ClientEval? savedEval;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eval = ref.watch(engineEvaluationProvider(evaluationContext));

    return eval != null
        ? _EvalGauge(
            position: position,
            eval: eval,
          )
        : savedEval != null
            ? _EvalGauge(
                position: position,
                eval: savedEval,
              )
            : _EvalGauge(position: position);
  }
}

class _EvalGauge extends ConsumerStatefulWidget {
  const _EvalGauge({
    required this.position,
    this.eval,
  });

  final Position position;
  final ClientEval? eval;

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

    final evalDisplay = widget.position.outcome != null
        ? widget.position.outcome!.winner == null
            ? widget.position.isStalemate
                ? context.l10n.stalemate
                : context.l10n.insufficientMaterial
            : widget.position.isCheckmate
                ? context.l10n.checkmate
                : context.l10n.variantEnding
        : widget.eval?.evalString;

    final toValue = widget.position.outcome != null
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
          child: Container(
            constraints: const BoxConstraints(
              minWidth: double.infinity,
              minHeight: _kEvalGaugeHeight,
            ),
            child: CustomPaint(
              painter: _EvalGaugePainter(
                backgroundColor: _kEvalGaugeBackgroundColor,
                valueColor: brightness == Brightness.dark
                    ? _kEvalGaugeValueColorDarkBg
                    : _kEvalGaugeValueColorLightBg,
                value: value,
                textDirection: textDirection,
              ),
              child: Align(
                alignment: toValue >= 0.5
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text(
                    evalDisplay ?? '',
                    style: TextStyle(
                      color: toValue >= 0.5 ? Colors.black : Colors.white,
                      fontSize: 11.0,
                      fontWeight: FontWeight.bold,
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

class _EvalGaugePainter extends CustomPainter {
  const _EvalGaugePainter({
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
    final Paint paint = Paint()
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
  bool shouldRepaint(_EvalGaugePainter oldPainter) {
    return oldPainter.backgroundColor != backgroundColor ||
        oldPainter.valueColor != valueColor ||
        oldPainter.value != value ||
        oldPainter.textDirection != textDirection;
  }
}
