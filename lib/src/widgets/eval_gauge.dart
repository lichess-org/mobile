import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lichess_mobile/src/common/brightness.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/common/eval.dart';

const double _kEvalGaugeHeight = 20.0;
const Color _kEvalGaugeBackgroundColor = Color(0xFF444444);
const Color _kEvalGaugeValueColorDarkBg = Color(0xEEEEEEEE);
const Color _kEvalGaugeValueColorLightBg = Color(0xFFFFFFFF);

class EvalGauge extends ConsumerStatefulWidget {
  const EvalGauge({
    super.key,
    required this.eval,
  });

  final ClientEval eval;

  double get whiteWinningChances => eval.winningChances(Side.white);
  double get animationValue => 1 - whiteWinningChances * 0.5;

  @override
  ConsumerState<EvalGauge> createState() => _EvalGaugeState();
}

class _EvalGaugeState extends ConsumerState<EvalGauge> {
  double fromValue = 0.5;

  @override
  void didUpdateWidget(EvalGauge oldWidget) {
    super.didUpdateWidget(oldWidget);
    fromValue = oldWidget.animationValue;
  }

  @override
  Widget build(BuildContext context) {
    final brightness = ref.watch(currentBrightnessProvider);
    final TextDirection textDirection = Directionality.of(context);

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: fromValue, end: widget.animationValue),
      duration: const Duration(milliseconds: 800),
      builder: (BuildContext context, double value, Widget? child) {
        return Semantics(
          label: context.l10n.evaluationGauge,
          value: widget.eval.evalString,
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Text(
                  widget.eval.evalString,
                  style: TextStyle(
                    color: widget.whiteWinningChances >= 0
                        ? Colors.black
                        : Colors.white,
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: widget.whiteWinningChances >= 0
                      ? TextAlign.left
                      : TextAlign.right,
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
          break;
        case TextDirection.ltr:
          left = x;
          break;
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
