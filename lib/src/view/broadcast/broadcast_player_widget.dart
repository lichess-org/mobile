import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/lichess_assets.dart';

class BroadcastPlayerWidget extends ConsumerWidget {
  const BroadcastPlayerWidget(
    this.player, {
    this.textStyle,
    this.withRating = false,
  });

  final dynamic player;
  final TextStyle? textStyle;
  final bool withRating;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        if (player.federation != null) ...[
          SvgPicture.network(
            lichessFideFedSrc(player.federation!),
            height: 12,
            httpClient: ref.read(defaultClientProvider),
          ),
          const SizedBox(width: 5),
        ],
        if (player.title != null) ...[
          Text(
            player.title!,
            style: const TextStyle().copyWith(
              color: context.lichessColors.brag,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 5),
        ],
        Flexible(
          child: Text(
            player.name,
            style: textStyle,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (withRating && player.rating != null) ...[
          const SizedBox(width: 5),
          Text(
            player.rating.toString(),
            style: const TextStyle(),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }
}
