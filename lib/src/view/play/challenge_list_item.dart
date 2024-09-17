import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/challenge/challenge.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';
import 'package:lichess_mobile/src/model/lobby/correspondence_challenge.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/user_full_name.dart';

class ChallengeListItem extends ConsumerWidget {
  const ChallengeListItem({
    super.key,
    required this.challenge,
    required this.user,
    this.onPressed,
    this.onCancel,
  });

  final Challenge challenge;
  final LightUser user;
  final VoidCallback? onPressed;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final me = ref.watch(authSessionProvider)?.user;
    final isMyChallenge = me != null && me.id == user.id;

    final color =
        isMyChallenge ? LichessColors.green.withValues(alpha: 0.2) : null;

    return Container(
      color: color,
      child: Slidable(
        endActionPane: onCancel != null
            ? ActionPane(
                motion: const ScrollMotion(),
                extentRatio: 0.3,
                children: [
                  SlidableAction(
                    onPressed: (BuildContext context) => onCancel!(),
                    backgroundColor: context.lichessColors.error,
                    foregroundColor: Colors.white,
                    label: isMyChallenge
                        ? context.l10n.cancel
                        : context.l10n.decline,
                  ),
                ],
              )
            : null,
        child: PlatformListTile(
          padding: Styles.bodyPadding,
          trailing: Icon(challenge.perf.icon, size: 36),
          title: isMyChallenge
              ? UserFullNameWidget(
                  user: challenge.destUser != null
                      ? challenge.destUser!.user
                      : user,
                )
              : UserFullNameWidget(user: user),
          subtitle: Text(challenge.description(context.l10n)),
          onTap: onPressed,
        ),
      ),
    );
  }
}

class CorrespondenceChallengeListItem extends StatelessWidget {
  const CorrespondenceChallengeListItem({
    super.key,
    required this.challenge,
    required this.user,
    this.onPressed,
    this.onCancel,
  });

  final CorrespondenceChallenge challenge;
  final LightUser user;
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
        timeControl: ChallengeTimeControlType.correspondence,
        rated: challenge.rated,
        sideChoice: challenge.side == null
            ? SideChoice.random
            : challenge.side == Side.white
                ? SideChoice.white
                : SideChoice.black,
        days: challenge.days,
      ),
      user: user,
      onPressed: onPressed,
      onCancel: onCancel,
    );
  }
}
