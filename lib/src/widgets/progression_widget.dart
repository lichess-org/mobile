import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:material_ui/material_ui.dart';

const _customOpacity = 0.6;

class const ProgressionWidget(
  final int progress, {
  final double fontSize = 20,
  final bool useTrendArrows = false,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final IconData positiveIcon = useTrendArrows
        ? Icons.trending_up
        : LichessIcons.arrow_full_upperright;
    final IconData negativeIcon = useTrendArrows
        ? Icons.trending_down
        : LichessIcons.arrow_full_lowerright;

    return Row(
      mainAxisSize: .min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (progress != 0) ...[
          Icon(
            progress > 0 ? positiveIcon : negativeIcon,
            size: fontSize,
            color: progress > 0 ? context.lichessColors.good : context.lichessColors.error,
          ),
          Text(
            progress.abs().toString(),
            style: TextStyle(
              color: progress > 0 ? context.lichessColors.good : context.lichessColors.error,
              fontSize: fontSize,
              fontFeatures: const [FontFeature.tabularFigures()],
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
