import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:material_ui/material_ui.dart';

/// A compact bar that shows the share of wins, draws and losses.
///
/// The bar is decorative: the counts and percentages beside it carry the meaning for screen
/// readers, so it is excluded from semantics.
class const ResultMeter({
  required final int wins,
  required final int draws,
  required final int losses,
  final double height = 10.0,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);
    final trackColor = colorScheme.onSurface.withValues(alpha: 0.12);
    final drawColor = colorScheme.onSurface.withValues(alpha: 0.3);

    return ExcludeSemantics(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(height / 2),
        child: SizedBox(
          height: height,
          width: double.infinity,
          child: ColoredBox(
            color: trackColor,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 2.0,
              children: [
                if (wins > 0)
                  Expanded(
                    flex: wins,
                    child: ColoredBox(color: context.lichessColors.good),
                  ),
                if (draws > 0)
                  Expanded(
                    flex: draws,
                    child: ColoredBox(color: drawColor),
                  ),
                if (losses > 0)
                  Expanded(
                    flex: losses,
                    child: ColoredBox(color: context.lichessColors.error),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
