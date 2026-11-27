import 'dart:math';

import 'package:dartchess/dartchess.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/challenge/challenge.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/game.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';
import 'package:lichess_mobile/src/model/lobby/correspondence_seek.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/styles/icon_extensions.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/board_thumbnail.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/swipe_actions.dart';
import 'package:lichess_mobile/src/widgets/user.dart';
import 'package:material_ui/material_ui.dart';

class const ChallengeListItem({
  super.key,
  required final Challenge challenge,
  required final LightUser challengerUser,
  final VoidCallback? onPressed,
  final VoidCallback? onAccept,
  final void Function(ChallengeDeclineReason? reason)? onDecline,
  final VoidCallback? onCancel,
}) extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final me = ref.watch(authControllerProvider)?.user;
    final isMyChallenge = me != null && me.id == challengerUser.id;

    final color = isMyChallenge ? context.lichessColors.green.withValues(alpha: 0.2) : null;

    final isFromPosition = challenge.variant == Variant.fromPosition;

    final leading = Icon(challenge.perf.icon);
    final trailing = challenge.challenger?.lagRating != null
        ? LagIndicator(lagRating: challenge.challenger!.lagRating!)
        : null;
    final title = isMyChallenge
        // shows destUser if it exists, otherwise shows the challenger (me)
        // if no destUser, it's an open challenge I sent
        ? UserFullNameWidget(
            user: challenge.destUser != null ? challenge.destUser!.user : challengerUser,
            rating: challenge.destUser?.rating ?? challenge.challenger?.rating,
          )
        : UserFullNameWidget(user: challengerUser, rating: challenge.challenger?.rating);
    final subtitle = Text(challenge.description(context.l10n));

    final screenWidth = MediaQuery.widthOf(context);

    return SwipeActions(
      extentRatio: 0.6,
      allowsFullSwipe: false,
      endActions: [
        if (isMyChallenge && onCancel != null)
          SwipeAction(
            icon: Icons.close,
            onPressed: onCancel!,
            backgroundColor: context.lichessColors.red,
            foregroundColor: Colors.white,
            label: context.l10n.cancel,
          )
        else if (!isMyChallenge && onDecline != null)
          SwipeAction(
            icon: Icons.close,
            onPressed: () => onDecline!(null),
            backgroundColor: context.lichessColors.red,
            foregroundColor: Colors.white,
            label: context.l10n.decline,
          ),
        if (onAccept != null)
          SwipeAction(
            icon: Icons.check,
            onPressed: onAccept!,
            backgroundColor: context.lichessColors.green,
            foregroundColor: Colors.white,
            label: context.l10n.accept,
          ),
      ],
      child: isFromPosition
          ? ExpansionTile(
              backgroundColor: color,
              childrenPadding: Styles.bodyPadding.subtract(const EdgeInsets.only(top: 8.0)),
              leading: leading,
              title: title,
              subtitle: subtitle,
              children: [
                if (challenge.variant == Variant.fromPosition && challenge.initialFen != null)
                  BoardThumbnail(
                    size: min(400, screenWidth - 2 * Styles.bodyPadding.horizontal),
                    orientation: challenge.sideChoice == SideChoice.white ? Side.white : Side.black,
                    fen: challenge.initialFen!,
                    onTap: onPressed,
                  ),
              ],
              // onTap: onPressed,
            )
          : ListTile(
              tileColor: color,
              leading: leading,
              title: title,
              subtitle: subtitle,
              trailing: trailing,
              onTap: onPressed,
            ),
    );
  }
}

class const CorrespondenceChallengeListItem({
  super.key,
  required final CorrespondenceSeek seek,
  required final LightUser challengerUser,
  final VoidCallback? onPressed,
  final VoidCallback? onCancel,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChallengeListItem(
      challenge: Challenge(
        id: ChallengeId(seek.id.value),
        status: ChallengeStatus.created,
        variant: seek.variant,
        speed: Speed.correspondence,
        timeControl: seek.days != null
            ? ChallengeTimeControlType.correspondence
            : ChallengeTimeControlType.unlimited,
        rated: seek.rated,
        sideChoice: seek.side == null
            ? SideChoice.random
            : seek.side == Side.white
            ? SideChoice.white
            : SideChoice.black,
        days: seek.days,
        challenger: (
          user: challengerUser,
          rating: seek.rating,
          provisionalRating: seek.provisional,
          lagRating: null,
        ),
      ),
      challengerUser: challengerUser,
      onPressed: onPressed,
      onCancel: onCancel,
    );
  }
}
