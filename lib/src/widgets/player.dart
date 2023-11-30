import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/account/account_preferences.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';

/// Displays a player's name and title with an optional rating.
class PlayerTitle extends ConsumerWidget {
  const PlayerTitle({
    required this.userName,
    this.title,
    this.rating,
    this.isPatron,
    this.provisional,
    this.style,
    super.key,
  });

  final String userName;
  final String? title;
  final int? rating;
  final bool? isPatron;
  final bool? provisional;
  final TextStyle? style;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provisionalStr = provisional == true ? '?' : '';
    final nameAndRating =
        userName + (rating != null ? ' ($rating$provisionalStr)' : '');
    final showRatingAsync = ref.watch(showRatingsPrefProvider);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isPatron == true)
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Icon(
              LichessIcons.patron,
              size: DefaultTextStyle.of(context).style.fontSize,
              color: DefaultTextStyle.of(context).style.color,
            ),
          ),
        if (title != null) ...[
          Text(
            title!,
            style: (style ?? const TextStyle()).copyWith(
              color: title == 'BOT' ? LichessColors.fancy : LichessColors.brag,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 5),
        ],
        Flexible(
          child: showRatingAsync.maybeWhen(
            data: (showRating) => Text(
              showRating ? nameAndRating : userName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: style,
            ),
            orElse: () => Text(
              userName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: style,
            ),
          ),
        ),
      ],
    );
  }
}
