import 'package:flutter/widgets.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/team/team.dart';
import 'package:lichess_mobile/src/utils/lichess_assets.dart';
import 'package:lichess_mobile/src/widgets/network_image.dart';

/// A widget that displays a team's name followed by its flair.
class const TeamFullNameWidget({
  super.key,
  required final LightTeam team,
  final TextStyle? style,

  /// Whether to show the team's flair. Defaults to `true`.
  final bool showFlair = true,
  final int? maxLines,
  final TextOverflow? overflow,

  /// Callback when the user taps on the name.
  final VoidCallback? onTap,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final contextTextStyle = style ?? DefaultTextStyle.of(context).style;
    final fontSize = contextTextStyle.fontSize ?? 16.0;

    final content = Text.rich(
      TextSpan(
        text: team.name,
        children: [
          if (showFlair && team.flair != null) ...[
            const WidgetSpan(child: SizedBox(width: 5)),
            WidgetSpan(
              alignment: .middle,
              child: HttpNetworkImageWidget(
                lichessFlairSrc(team.flair!),
                errorBuilder: (_, _, _) => kEmptyWidget,
                width: fontSize,
                height: fontSize,
              ),
            ),
          ],
        ],
      ),
      style: style,
      maxLines: maxLines,
      overflow: overflow ?? (maxLines != null ? .ellipsis : .clip),
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: content);
    }

    return content;
  }
}
