import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/common/service/sound_service.dart';
import 'package:lichess_mobile/src/model/game/game.dart';
import 'package:lichess_mobile/src/model/game/material_diff.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/lichess_assets.dart';
import 'package:lichess_mobile/src/utils/screen.dart';
import 'package:lichess_mobile/src/view/account/rating_pref_aware.dart';
import 'package:lichess_mobile/src/view/user/user_or_profile_screen.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/user.dart';

/// A widget to display player information above/below the chess board.
class GamePlayer extends StatelessWidget {
  const GamePlayer({
    required this.game,
    required this.side,
    this.matchupScore,
    this.clock,
    this.materialDiff,
    this.materialDifferenceFormat,
    this.confirmMoveCallbacks,
    this.timeToMove,
    this.shouldLinkToUserProfile = true,
    this.mePlaying = false,
    this.canGoForward = false,
    this.zenMode = false,
    this.clockPosition = ClockPosition.right,
    super.key,
  });

  final BaseGame game;
  final Side side;

  final Widget? clock;
  final MaterialDiffSide? materialDiff;
  final MaterialDifferenceFormat? materialDifferenceFormat;

  /// if confirm move preference is enabled, used to display confirmation buttons
  final ({VoidCallback confirm, VoidCallback cancel})? confirmMoveCallbacks;

  final double? matchupScore;
  final bool shouldLinkToUserProfile;
  final bool mePlaying;
  final bool canGoForward;
  final bool zenMode;
  final ClockPosition clockPosition;

  /// Time left for the player to move at the start of the game.
  final Duration? timeToMove;

  @override
  Widget build(BuildContext context) {
    final playerFontSize = isShortVerticalScreen(context) ? 15.0 : 16.0;

    final player = game.playerOf(side);

    final tournament = game.meta.tournament;

    final playerWidget = Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!zenMode)
          Row(
            mainAxisAlignment: clockPosition == ClockPosition.right
                ? MainAxisAlignment.start
                : MainAxisAlignment.end,
            children: [
              if (matchupScore != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4.0,
                    vertical: 2.0,
                  ),
                  decoration: BoxDecoration(
                    color: ColorScheme.of(context).primaryContainer,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Text(
                    _scoreDisplay(matchupScore!),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: ColorScheme.of(context).onPrimaryContainer,
                    ),
                  ),
                ),
                const SizedBox(width: 5),
              ],
              if (tournament?.ranks != null)
                Text(
                  '#${side == Side.white ? tournament?.ranks?.white : tournament?.ranks?.black} ',
                  style: TextStyle(
                    fontSize: playerFontSize,
                    color: textShade(context, 0.7),
                  ),
                ),
              if (player.user != null) ...[
                ConnectedIcon(
                  isConnected: player.onGame == true,
                  shouldShowIsOnGameLabels: true,
                  size: DefaultTextStyle.of(context).style.fontSize,
                ),
              ],
              const SizedBox(width: 5),
              if (player.user?.isPatron == true) ...[
                PatronIcon(
                  size: playerFontSize,
                  color: player.user?.patronColor,
                ),
                const SizedBox(width: 5),
              ],
              if (player.user?.title != null) ...[
                Text(
                  player.user!.title!,
                  style: TextStyle(
                    fontSize: playerFontSize,
                    fontWeight: player.user?.title == 'BOT'
                        ? null
                        : FontWeight.bold,
                    color: player.user?.title == 'BOT'
                        ? context.lichessColors.fancy
                        : context.lichessColors.brag,
                  ),
                ),
                const SizedBox(width: 5),
              ],
              Flexible(
                child: Text(
                  player.displayName(context.l10n),
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
                  errorWidget: (_, _, _) => kEmptyWidget,
                  width: 16,
                  height: 16,
                ),
              ],
              if (player.rating != null)
                RatingPrefAware(
                  isActiveGameOfCurrentUser:
                      game.me != null && !game.finished && !game.aborted,
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
                                  : player.ratingDiff! == 0
                                  ? context.lichessColors.brag
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
              if (player.berserk == true) ...[
                const SizedBox(width: 5),
                Icon(
                  LichessIcons.body_cut,
                  color: LichessColors.brag,
                  size: playerFontSize,
                  semanticLabel: context.l10n.arenaBerserk,
                ),
              ],
            ],
          ),
        if (timeToMove != null)
          MoveExpiration(timeToMove: timeToMove!, mePlaying: mePlaying)
        else
          MaterialDifferenceDisplay(
            materialDiff: materialDiff,
            materialDifferenceFormat: materialDifferenceFormat,
          ),
      ],
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (clock != null && clockPosition == ClockPosition.left)
          Flexible(flex: 3, child: clock!),
        if (mePlaying && confirmMoveCallbacks != null && canGoForward == false)
          Expanded(
            flex: 7,
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
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
              padding: const EdgeInsets.only(right: 16.0),
              child: shouldLinkToUserProfile
                  ? Consumer(
                      builder: (context, ref, _) {
                        return GestureDetector(
                          onTap: player.user != null
                              ? () {
                                  if (mePlaying) {
                                    ref.invalidate(accountProvider);
                                  }
                                  Navigator.of(context).push(
                                    UserOrProfileScreen.buildRoute(
                                      context,
                                      player.user!,
                                    ),
                                  );
                                }
                              : null,
                          child: playerWidget,
                        );
                      },
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
        SemanticIconButton(
          icon: const Icon(CupertinoIcons.xmark_rectangle_fill),
          color: context.lichessColors.error,
          iconSize: 35,
          semanticsLabel: context.l10n.cancel,
          padding: const EdgeInsets.all(10),
          onPressed: onCancel,
        ),
        Flexible(
          child: Text(
            context.l10n.confirmMove,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
        ),
        SemanticIconButton(
          icon: const Icon(CupertinoIcons.checkmark_rectangle_fill),
          color: context.lichessColors.good,
          iconSize: 35,
          semanticsLabel: context.l10n.accept,
          padding: const EdgeInsets.all(10),
          onPressed: onConfirm,
        ),
      ],
    );
  }
}

String _scoreDisplay(double score) {
  final integerPart = score.truncate();
  final decimalPart = score - integerPart;

  return integerPart == 0 && decimalPart == 0.5
      ? '½'
      : '$integerPart${decimalPart == 0.5 ? '½' : ''}';
}

class MoveExpiration extends ConsumerStatefulWidget {
  const MoveExpiration({
    required this.timeToMove,
    required this.mePlaying,
    super.key,
  });

  final Duration timeToMove;
  final bool mePlaying;

  @override
  ConsumerState<MoveExpiration> createState() => _MoveExpirationState();
}

class _MoveExpirationState extends ConsumerState<MoveExpiration> {
  static const _period = Duration(milliseconds: 1000);
  Timer? _timer;
  Duration timeLeft = Duration.zero;
  bool playedEmergencySound = false;

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

    if (emerg && widget.mePlaying && !playedEmergencySound) {
      ref.read(soundServiceProvider).play(Sound.lowTime);
      setState(() {
        playedEmergencySound = true;
      });
    }

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

class MaterialDifferenceDisplay extends StatelessWidget {
  const MaterialDifferenceDisplay({
    required this.materialDiff,
    this.materialDifferenceFormat = MaterialDifferenceFormat.materialDifference,
  });

  final MaterialDiffSide? materialDiff;
  final MaterialDifferenceFormat? materialDifferenceFormat;

  @override
  Widget build(BuildContext context) {
    final IMap<Role, int> piecesToRender = materialDiff != null
        ? (materialDifferenceFormat == MaterialDifferenceFormat.capturedPieces
              ? materialDiff!.capturedPieces
              : materialDiff!.pieces)
        : IMap();

    return materialDifferenceFormat?.visible ?? true
        ? Row(
            children: [
              for (final role in Role.values)
                for (int i = 0; i < (piecesToRender.get(role) ?? 0); i++)
                  Icon(
                    _iconByRole[role],
                    size: 13,
                    color: textShade(context, 0.5),
                  ),
              const SizedBox(width: 3),
              Text(
                // a text font size of 14 is used to ensure that the text will take more vertical space
                // than the icons
                // this is a trick to make sure the player name widget will not shift, since the text
                // widget is always present (contrary to the icons)
                style: TextStyle(fontSize: 14, color: textShade(context, 0.5)),
                materialDiff != null && materialDiff!.score > 0
                    ? '+${materialDiff!.score}'
                    : '',
              ),
            ],
          )
        : const SizedBox.shrink();
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
