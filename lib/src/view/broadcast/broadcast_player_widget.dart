import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/styles/styles.dart';

class BroadcastPlayerWidget extends ConsumerWidget {
  const BroadcastPlayerWidget({
    required this.player,
    this.showFederation = true,
    this.showRating = true,
    this.textStyle,
  });

  final BroadcastPlayer player;
  final bool showFederation;
  final bool showRating;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final BroadcastPlayer(:federation, :title, :name, :rating) = player;

    return Row(
      children: [
        if (federation != null && showFederation) ...[
          Image.asset('assets/images/fide-fed/$federation.png', height: 12),
          const SizedBox(width: 5),
        ],
        if (title != null) ...[
          Text(
            title,
            style: TextStyle(
              color: (title == 'BOT') ? context.lichessColors.fancy : context.lichessColors.brag,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 5),
        ],
        Flexible(child: Text(name, style: textStyle, overflow: TextOverflow.ellipsis)),
        if (rating != null && showRating) ...[
          const SizedBox(width: 5),
          Text(rating.toString(), overflow: TextOverflow.ellipsis),
        ],
      ],
    );
  }
}
