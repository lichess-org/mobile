import 'package:flutter/material.dart';

import 'package:lichess_mobile/src/common/lichess_colors.dart';

class BriefGameResultBox extends StatelessWidget {
  const BriefGameResultBox({
    required this.win,
    required this.draw,
    required this.loss,
  });

  final int win;
  final int draw;
  final int loss;

  @override
  Widget build(BuildContext context) {
    const gameStatsFontStyle = TextStyle(
      color: Colors.white,
      fontSize: 10,
      fontWeight: FontWeight.bold,
    );

    return SizedBox(
      height: 20,
      width: (win != 0 ? 1 : 0) * 18 +
          (draw != 0 ? 1 : 0) * 18 +
          (loss != 0 ? 1 : 0) * 18 +
          ((win != 0 ? 1 : 0) + (draw != 0 ? 1 : 0) + (loss != 0 ? 1 : 0) - 1) *
              3,
      child: Row(
        children: [
          if (win != 0)
            SizedBox(
              height: 18,
              width: 18,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: LichessColors.good,
                  borderRadius: BorderRadius.circular(3.0),
                ),
                child: Center(
                  child: Text(
                    win.toString(),
                    style: gameStatsFontStyle,
                  ),
                ),
              ),
            ),
          if (win != 0 && draw != 0)
            const SizedBox(
              width: 3,
            ),
          if (draw != 0)
            SizedBox(
              height: 18,
              width: 18,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: LichessColors.brag,
                  borderRadius: BorderRadius.circular(3.0),
                ),
                child: Center(
                  child: Text(
                    draw.toString(),
                    style: gameStatsFontStyle,
                  ),
                ),
              ),
            ),
          if ((draw != 0 && loss != 0) || (win != 0 && loss != 0))
            const SizedBox(
              width: 3,
            ),
          if (loss != 0)
            SizedBox(
              height: 18,
              width: 18,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: LichessColors.red,
                  borderRadius: BorderRadius.circular(3.0),
                ),
                child: Center(
                  child: Text(
                    loss.toString(),
                    style: gameStatsFontStyle,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
