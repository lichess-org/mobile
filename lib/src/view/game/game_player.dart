import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/game/material_diff.dart';
import 'package:lichess_mobile/src/model/game/player.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/lichess_assets.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/utils/screen.dart';
import 'package:lichess_mobile/src/view/account/profile_screen.dart';
import 'package:lichess_mobile/src/view/account/rating_pref_aware.dart';
import 'package:lichess_mobile/src/view/user/user_screen.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';

/// A widget to display player information above/below the chess board.
class GamePlayer extends StatelessWidget {
  const GamePlayer({
    required this.player,
    this.clock,
    this.materialDiff,
    this.confirmMoveCallbacks,
    this.timeToMove,
    this.shouldLinkToUserProfile = true,
    this.mePlaying = false,
    this.zenMode = false,
    this.clockPosition = ClockPosition.right,
    super.key,
  });

  final Player player;
  final Widget? clock;
  final MaterialDiffSide? materialDiff;

  /// if confirm move preference is enabled, used to display confirmation buttons
  final ({VoidCallback confirm, VoidCallback cancel})? confirmMoveCallbacks;

  final bool shouldLinkToUserProfile;
  final bool mePlaying;
  final bool zenMode;
  final ClockPosition clockPosition;

  /// Time left for the player to move at the start of the game.
  final Duration? timeToMove;

  @override
  Widget build(BuildContext context) {
    final remaingHeight = estimateRemainingHeightLeftBoard(context);
    final playerFontSize =
        remaingHeight <= kSmallRemainingHeightLeftBoardThreshold ? 14.0 : 16.0;

    final playerWidget = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!zenMode)
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (player.user != null) ...[
                Icon(
                  player.onGame == true ? Icons.cloud : Icons.cloud_off,
                  color: player.onGame == true ? LichessColors.green : null,
                  size: 14,
                ),
              ],
              const SizedBox(width: 5),
              if (player.user?.isPatron == true) ...[
                Icon(
                  LichessIcons.patron,
                  size: playerFontSize,
                  semanticLabel: context.l10n.patronLichessPatron,
                ),
                const SizedBox(width: 5),
              ],
              if (player.user?.title != null) ...[
                Text(
                  player.user!.title!,
                  style: TextStyle(
                    fontSize: playerFontSize,
                    fontWeight:
                        player.user?.title == 'BOT' ? null : FontWeight.bold,
                    color: player.user?.title == 'BOT'
                        ? context.lichessColors.fancy
                        : context.lichessColors.brag,
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
              if (player.user?.flair != null) ...[
                const SizedBox(width: 5),
                CachedNetworkImage(
                  imageUrl: lichessFlairSrc(player.user!.flair!),
                  errorWidget: (_, __, ___) => kEmptyWidget,
                  width: 16,
                  height: 16,
                ),
              ],
              if (player.rating != null)
                RatingPrefAware(
                  child: Text.rich(
                    TextSpan(
                      text:
                          ' ${player.rating}${player.provisional == true ? '?' : ''}',
                      children: [
                        if (player.ratingDiff != null)
                          TextSpan(
                            text:
                                ' ${player.ratingDiff! > 0 ? '+' : ''}${player.ratingDiff}',
                            style: TextStyle(
                              color: player.ratingDiff! > 0
                                  ? context.lichessColors.good
                                  : context.lichessColors.error,
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
              ),
            ],
          )
        else
          // to avoid shifts use an empty text widget
          const Text('', style: TextStyle(fontSize: 13)),
      ],
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (clock != null && clockPosition == ClockPosition.left)
          Flexible(flex: 3, child: clock!),
        if (mePlaying && confirmMoveCallbacks != null)
          Expanded(
            flex: 7,
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: ConfirmMove(
                onConfirm: confirmMoveCallbacks!.confirm,
                onCancel: confirmMoveCallbacks!.cancel,
              ),
            ),
          )
        else
          Expanded(
            flex: 7,
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: shouldLinkToUserProfile
                  ? GestureDetector(
                      onTap: player.user != null
                          ? () {
                              pushPlatformRoute(
                                context,
                                builder: (context) => mePlaying
                                    ? const ProfileScreen()
                                    : UserScreen(
                                        user: player.user!,
                                      ),
                              );
                            }
                          : null,
                      child: playerWidget,
                    )
                  : playerWidget,
            ),
          ),
        if (clock != null && clockPosition == ClockPosition.right)
          Flexible(flex: 3, child: clock!),
      ],
    );
  }
}

class ConfirmMove extends StatelessWidget {
  const ConfirmMove({
    required this.onConfirm,
    required this.onCancel,
    super.key,
  });

  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        PlatformIconButton(
          icon: CupertinoIcons.xmark_rectangle_fill,
          color: context.lichessColors.error,
          iconSize: 35,
          semanticsLabel: context.l10n.cancel,
          padding: const EdgeInsets.all(10),
          onTap: onCancel,
        ),
        Flexible(
          child: Text(
            context.l10n.confirmMove,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
        ),
        PlatformIconButton(
          icon: CupertinoIcons.checkmark_rectangle_fill,
          color: context.lichessColors.good,
          iconSize: 35,
          semanticsLabel: context.l10n.accept,
          padding: const EdgeInsets.all(10),
          onTap: onConfirm,
        ),
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
              color: widget.mePlaying && emerg
                  ? context.lichessColors.error
                  : null,
            ),
          )
        : const Text('');
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
