import 'package:flutter/material.dart';

import 'package:lichess_mobile/src/common/lichess_colors.dart';
import 'package:lichess_mobile/src/constants.dart';
import './countdown_clock.dart';

/// A widget to display player information above/below the chess board.
///
/// It shows the full player name with title and rating and the clock if relevant.
class BoardPlayer extends StatelessWidget {
  const BoardPlayer({
    required this.name,
    this.title,
    this.rating,
    this.active,
    this.clock,
    super.key,
  });

  final String name;
  final int? rating;
  final String? title;
  final Duration? clock;
  final bool? active;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (title != null) ...[
                    Text(
                      title!,
                      style:
                          const TextStyle(fontSize: 18, color: Colors.orange),
                    ),
                    const SizedBox(width: 5),
                  ],
                  Flexible(
                    child: Text(
                      name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 3),
                  if (rating != null)
                    Text(
                      rating.toString(),
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13),
                    ),
                ],
              ),
            ),
          ),
          if (clock != null)
            CountdownClock(
              duration: clock!,
              active: active == true,
            ),
        ],
      ),
    );
  }
}

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
class PlayerTitle extends StatelessWidget {
  const PlayerTitle({
    required this.userName,
    this.title,
    this.rating,
    this.style,
    super.key,
  });

  final String userName;
  final String? title;
  final int? rating;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final nameAndRating = userName + (rating != null ? ' ($rating)' : '');
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null) ...[
          Text(
            title!,
            style: (style ?? const TextStyle()).copyWith(
              color: title == 'BOT' ? LichessColors.fancy : LichessColors.brag,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 5)
        ],
        Flexible(
          child: Text(
            nameAndRating,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: style,
          ),
        ),
      ],
    );
  }
}
