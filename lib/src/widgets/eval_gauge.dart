import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dartchess/dartchess.dart';

import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/common/eval.dart';

class EvalGauge extends StatefulWidget {
  const EvalGauge({
    super.key,
    required this.eval,
  });

  final ClientEval eval;

  @override
  State<EvalGauge> createState() => _EvalGaugeState();
}

class _EvalGaugeState extends State<EvalGauge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(EvalGauge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextDirection textDirection = Directionality.of(context);

    final chances = widget.eval.winningChances(Side.white);
    final value = 1 - (chances + 1) * 0.5;

    return AnimatedBuilder(
      animation: _controller.view,
      builder: (context, Widget? child) {
        return Semantics(
          label: context.l10n.evaluationGauge,
          value: widget.eval.evalString,
          child: Container(
            constraints: const BoxConstraints(
              minWidth: double.infinity,
              minHeight: 20.0,
            ),
            child: CustomPaint(
              painter: _EvalGaugePainter(
                backgroundColor: Colors.black,
                valueColor: Colors.white,
                value: value,
                animationValue: _controller.value,
                textDirection: textDirection,
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
    required this.animationValue,
    required this.textDirection,
  });

  final Color backgroundColor;
  final Color valueColor;
  final double value;
  final double animationValue;
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
        oldPainter.animationValue != animationValue ||
        oldPainter.textDirection != textDirection;
  }
}
