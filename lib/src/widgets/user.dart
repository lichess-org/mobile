import 'package:flutter/material.dart';

import 'package:lichess_mobile/src/common/lichess_colors.dart';
import 'package:lichess_mobile/src/common/model/user.dart';

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
          Text(user.title!,
              style: TextStyle(
                  color: user.title == 'BOT'
                      ? LichessColors.fancy
                      : LichessColors.brag,
                  fontWeight: FontWeight.bold)),
          const SizedBox(width: 5)
        ],
        Text(nameAndRating, maxLines: 1, overflow: TextOverflow.ellipsis),
      ],
    );
  }
}
