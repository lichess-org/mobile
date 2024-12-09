import 'package:flutter/widgets.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/styles/styles.dart';

const _customOpacity = 0.6;

class ProgressionWidget extends StatelessWidget {
  final int progress;

  const ProgressionWidget(this.progress);

  @override
  Widget build(BuildContext context) {
    const progressionFontSize = 20.0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (progress != 0) ...[
          Icon(
            progress > 0
                ? LichessIcons.arrow_full_upperright
                : LichessIcons.arrow_full_lowerright,
            color: progress > 0
                ? context.lichessColors.good
                : context.lichessColors.error,
          ),
          Text(
            progress.abs().toString(),
            style: TextStyle(
              color: progress > 0
                  ? context.lichessColors.good
                  : context.lichessColors.error,
              fontSize: progressionFontSize,
            ),
          ),
        ] else
          Text(
            '0',
            style: TextStyle(
              color: textShade(context, _customOpacity),
              fontSize: progressionFontSize,
            ),
          ),
      ],
    );
  }
}
