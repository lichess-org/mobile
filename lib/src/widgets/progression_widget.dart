import 'package:flutter/widgets.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/styles/styles.dart';

const _customOpacity = 0.6;

class ProgressionWidget extends StatelessWidget {
  final int progress;
  final double fontSize;

  const ProgressionWidget(this.progress, {this.fontSize = 20});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (progress != 0) ...[
          Icon(
            progress > 0 ? LichessIcons.arrow_full_upperright : LichessIcons.arrow_full_lowerright,
            size: fontSize,
            color: progress > 0 ? context.lichessColors.good : context.lichessColors.error,
          ),
          Text(
            progress.abs().toString(),
            style: TextStyle(
              color: progress > 0 ? context.lichessColors.good : context.lichessColors.error,
              fontSize: fontSize,
            ),
          ),
        ] else
          Text(
            '0',
            style: TextStyle(color: textShade(context, _customOpacity), fontSize: fontSize),
          ),
      ],
    );
  }
}
