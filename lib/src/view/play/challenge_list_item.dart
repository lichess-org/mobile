import 'dart:math';

import 'package:dartchess/dartchess.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/challenge/challenge.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/game.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';
import 'package:lichess_mobile/src/model/lobby/correspondence_challenge.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/board_thumbnail.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/user.dart';

class ChallengeListItem extends ConsumerWidget {
  const ChallengeListItem({
    super.key,
    required this.challenge,
    required this.challengerUser,
    this.onPressed,
    this.onAccept,
    this.onDecline,
    this.onCancel,
  });

  final Challenge challenge;
  final LightUser challengerUser;
  final VoidCallback? onPressed;
  final VoidCallback? onAccept;
  final VoidCallback? onCancel;
  final void Function(ChallengeDeclineReason? reason)? onDecline;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final me = ref.watch(authSessionProvider)?.user;
    final isMyChallenge = me != null && me.id == challengerUser.id;

    final color = isMyChallenge ? context.lichessColors.good.withValues(alpha: 0.2) : null;

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

    final screenWidth = MediaQuery.sizeOf(context).width;

    return Slidable(
      enabled: onAccept != null || onDecline != null || (isMyChallenge && onCancel != null),
      dragStartBehavior: DragStartBehavior.start,
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        extentRatio: 0.6,
        children: [
          if (onAccept != null)
            SlidableAction(
              icon: Icons.check,
              onPressed: (_) => onAccept!(),
              spacing: 8.0,
              backgroundColor: context.lichessColors.good,
              foregroundColor: Colors.white,
              label: context.l10n.accept,
            ),
          if (onDecline != null || (isMyChallenge && onCancel != null))
            SlidableAction(
              icon: Icons.close,
              onPressed: isMyChallenge
                  ? (_) => onCancel!()
                  : onDecline != null
                  ? (_) => onDecline!(null)
                  : null,
              spacing: 8.0,
              backgroundColor: context.lichessColors.error,
              foregroundColor: Colors.white,
              label: isMyChallenge ? context.l10n.cancel : context.l10n.decline,
            ),
        ],
      ),
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

class CorrespondenceChallengeListItem extends StatelessWidget {
  const CorrespondenceChallengeListItem({
    super.key,
    required this.challenge,
    required this.challengerUser,
    this.onPressed,
    this.onCancel,
  });

  final CorrespondenceChallenge challenge;
  final LightUser challengerUser;
  final VoidCallback? onPressed;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    return ChallengeListItem(
      challenge: Challenge(
        id: ChallengeId(challenge.id.value),
        status: ChallengeStatus.created,
        variant: challenge.variant,
        speed: Speed.correspondence,
        timeControl: challenge.days != null
            ? ChallengeTimeControlType.correspondence
            : ChallengeTimeControlType.unlimited,
        rated: challenge.rated,
        sideChoice: challenge.side == null
            ? SideChoice.random
            : challenge.side == Side.white
            ? SideChoice.white
            : SideChoice.black,
        days: challenge.days,
        challenger: (
          user: challengerUser,
          rating: challenge.rating,
          provisionalRating: challenge.provisional,
          lagRating: null,
        ),
      ),
      challengerUser: challengerUser,
      onPressed: onPressed,
      onCancel: onCancel,
    );
  }
}
