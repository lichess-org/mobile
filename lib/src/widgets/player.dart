import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/account/account_preferences.dart';

class PlayerRating extends StatelessWidget {
  const PlayerRating({
    required this.rating,
    required this.deviation,
    this.provisional,
    this.style,
    super.key,
  });

  final num rating;
  final num deviation;
  final bool? provisional;

  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final ratingStr =
        rating is double ? rating.toStringAsFixed(2) : rating.toString();
    return Text(
      '$ratingStr${provisional == true || deviation > kProvisionalDeviation ? '?' : ''}',
      style: style,
    );
  }
}

/// Displays a player's name and title with an optional rating.
class PlayerTitle extends ConsumerWidget {
  const PlayerTitle({
    required this.userName,
    this.title,
    this.rating,
    this.isPatron,
    this.style,
    super.key,
  });

  final String userName;
  final String? title;
  final int? rating;
  final bool? isPatron;
  final TextStyle? style;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameAndRating = userName + (rating != null ? ' ($rating)' : '');
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
