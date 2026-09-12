import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:material_ui/material_ui.dart';

class const BroadcastPlayerWidget({
  required final BroadcastPlayer player,
  final bool showFederation = true,
  final bool showRating = true,
  final TextStyle? textStyle,
}) extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final BroadcastPlayer(:federation, :title, :name, :rating) = player;

    return Row(
      children: [
        if (federation != null && showFederation) ...[
          Image.asset(
            'assets/images/fide-fed/$federation.webp',
            height: ((textStyle ?? DefaultTextStyle.of(context).style).fontSize ?? 14) - 2,
          ),
          const SizedBox(width: 5),
        ],
        if (title != null) ...[
          Text(
            title,
            style: TextStyle(
              color: (title == 'BOT') ? context.lichessColors.fancy : context.lichessColors.brag,
              fontWeight: .bold,
              fontSize: textStyle?.fontSize,
            ),
          ),
          const SizedBox(width: 5),
        ],
        Flexible(
          child: Text(name ?? '', style: textStyle, overflow: .ellipsis),
        ),
        if (rating != null && showRating) ...[
          const SizedBox(width: 5),
          Text(
            rating.toString(),
            overflow: .ellipsis,
            style: TextStyle(fontSize: textStyle?.fontSize),
          ),
        ],
      ],
    );
  }
}
