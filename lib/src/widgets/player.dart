import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/model/game/material_diff.dart';
import 'package:dartchess/dartchess.dart';

import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/game/player.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/user/user_screen.dart';

/// A widget to display player information above/below the chess board.
///
/// It shows the full player name with title and rating and the clock if relevant.
class BoardPlayer extends StatelessWidget {
  const BoardPlayer({
    required this.player,
    this.clock,
    this.materialDiff,
    this.timeToMove,
    this.shouldLinkToUserProfile = true,
    this.mePlaying = false,
    super.key,
  });

  final Player player;
  final Widget? clock;
  final MaterialDiffSide? materialDiff;
  final bool shouldLinkToUserProfile;
  final bool mePlaying;

  /// Time left for the player to move at the start of the game.
  final Duration? timeToMove;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final playerFontSize =
        screenHeight < kSmallHeightScreenThreshold ? 14.0 : 16.0;

    final playerWidget = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (player.patron == true)
              Icon(
                LichessIcons.patron,
                size: 14,
                color:
                    player.onGame == true ? LichessColors.green : Colors.grey,
              )
            else
              Icon(
                player.onGame == true
                    ? CupertinoIcons.circle_fill
                    : CupertinoIcons.circle,
                size: 14,
                color:
                    player.onGame == true ? LichessColors.green : Colors.grey,
              ),
            const SizedBox(width: 5),
            if (player.title != null) ...[
              Text(
                player.title!,
                style: TextStyle(
                  fontSize: playerFontSize,
                  fontWeight: FontWeight.bold,
                  color: LichessColors.brag,
                ),
              ),
              const SizedBox(width: 5),
            ],
            Flexible(
              child: Text(
                player.displayName(context),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: playerFontSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 5),
            if (player.rating != null)
              Text.rich(
                TextSpan(
                  text:
                      '${player.rating}${player.provisional == true ? '?' : ''}',
                  children: [
                    if (player.ratingDiff != null)
                      TextSpan(
                        text:
                            ' ${player.ratingDiff! > 0 ? '+' : ''}${player.ratingDiff}',
                        style: TextStyle(
                          color: player.ratingDiff! > 0
                              ? LichessColors.green
                              : LichessColors.red,
                        ),
                      ),
                  ],
                ),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  color: textShade(context, 0.7),
                ),
              ),
          ],
        ),
        if (timeToMove != null)
          MoveExpiration(timeToMove: timeToMove!, mePlaying: mePlaying)
        else if (materialDiff != null)
          Row(
            children: [
              for (final role in Role.values)
                for (int i = 0; i < materialDiff!.pieces[role]!; i++)
                  Icon(
                    _iconByRole[role],
                    size: 13,
                    color: Colors.grey,
                  ),
              const SizedBox(width: 3),
              Text(
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
                materialDiff != null && materialDiff!.score > 0
                    ? '+${materialDiff!.score}'
                    : '',
              )
            ],
          )
        else
          const Text('', style: TextStyle(fontSize: 13)),
      ],
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 20),
            child: shouldLinkToUserProfile
                ? GestureDetector(
                    onTap: player.lightUser != null
                        ? () {
                            pushPlatformRoute(
                              context,
                              builder: (context) =>
                                  UserScreen(user: player.lightUser!),
                            );
                          }
                        : null,
                    child: playerWidget,
                  )
                : playerWidget,
          ),
        ),
        if (clock != null) clock!,
      ],
    );
  }
}

class MoveExpiration extends StatefulWidget {
  const MoveExpiration({
    required this.timeToMove,
    required this.mePlaying,
    super.key,
  });

  final Duration timeToMove;
  final bool mePlaying;

  @override
  State<MoveExpiration> createState() => _MoveExpirationState();
}

class _MoveExpirationState extends State<MoveExpiration> {
  static const _period = Duration(milliseconds: 1000);
  Timer? _timer;
  Duration timeLeft = Duration.zero;

  Timer startTimer() {
    return Timer.periodic(_period, (timer) {
      setState(() {
        timeLeft = timeLeft - _period;
        if (timeLeft <= Duration.zero) {
          timer.cancel();
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    timeLeft = widget.timeToMove;
    _timer = startTimer();
  }

  @override
  void didUpdateWidget(covariant MoveExpiration oldWidget) {
    super.didUpdateWidget(oldWidget);
    _timer?.cancel();
    timeLeft = widget.timeToMove;
    _timer = startTimer();
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final secs = timeLeft.inSeconds.remainder(60);
    final emerg = timeLeft <= const Duration(seconds: 8);
    return secs <= 20
        ? Text(
            context.l10n.nbSecondsToPlayTheFirstMove(secs),
            style: TextStyle(
              color: widget.mePlaying && emerg ? LichessColors.red : null,
            ),
          )
        : const Text('');
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

const Map<Role, IconData> _iconByRole = {
  Role.king: LichessIcons.chess_king,
  Role.queen: LichessIcons.chess_queen,
  Role.rook: LichessIcons.chess_rook,
  Role.bishop: LichessIcons.chess_bishop,
  Role.knight: LichessIcons.chess_knight,
  Role.pawn: LichessIcons.chess_pawn,
};
