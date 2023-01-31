import 'package:flutter/material.dart';

import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/common/lichess_colors.dart';
import 'package:lichess_mobile/src/features/user/model/user.dart';

class UserRating extends StatelessWidget {
  const UserRating({
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

/// This widget is meant to display the user basic informations in a [ListTile.title].
class ListTileUser extends StatelessWidget {
  const ListTileUser({
    required this.user,
    this.rating,
    super.key,
  });

  final LightUser user;
  final int? rating;

  @override
  Widget build(BuildContext context) {
    final nameAndRating = user.name + (rating != null ? ' ($rating)' : '');
    return Row(
      children: [
        if (user.title != null) ...[
          Text(
            user.title!,
            style: TextStyle(
              color: user.title == 'BOT'
                  ? LichessColors.fancy
                  : LichessColors.brag,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 5)
        ],
        Flexible(
          child:
              Text(nameAndRating, maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }
}
