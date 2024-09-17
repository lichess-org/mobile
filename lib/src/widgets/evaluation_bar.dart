import 'package:flutter/material.dart';

const evaluationBarAspectRatio = 1 / 20;

class EvaluationBar extends StatelessWidget {
  final double height;
  final double whiteWinnigChances;

  const EvaluationBar({
    super.key,
    required this.height,
    required this.whiteWinnigChances,
  });

  const EvaluationBar.loading({
    super.key,
    required this.height,
  }) : whiteWinnigChances = 0;

  @override
  Widget build(BuildContext context) {
    final whiteBarHeight = height * (whiteWinnigChances + 1) / 2;

    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          children: [
            SizedBox(
              height: height - whiteBarHeight,
              width: height * evaluationBarAspectRatio,
              child: ColoredBox(color: Colors.black.withValues(alpha: 0.6)),
            ),
            SizedBox(
              height: whiteBarHeight,
              width: height * evaluationBarAspectRatio,
              child: ColoredBox(color: Colors.white.withValues(alpha: 0.6)),
            ),
          ],
        ),
        SizedBox(
          height: height / 100,
          width: height * evaluationBarAspectRatio,
          child: const ColoredBox(color: Colors.red),
        ),
      ],
    );
  }
}
