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
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
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

    final time = switch (challenge.timeControl) {
      ChallengeTimeControlType.clock => () {
          final clock = challenge.clock!;
          final minutes = switch (clock.time.inSeconds) {
            15 => '¼',
            30 => '½',
            45 => '¾',
            90 => '1.5',
            _ => clock.time.inMinutes,
          };
          return '$minutes+${clock.increment.inSeconds}';
        }(),
      ChallengeTimeControlType.correspondence =>
        '${context.l10n.daysPerTurn}: ${challenge.days}',
      ChallengeTimeControlType.unlimited => '∞',
    };

    final subtitle = challenge.rated
        ? '${context.l10n.rated} • $time'
        : '${context.l10n.casual} • $time';

    final color =
        isMyChallenge ? null : LichessColors.green.withValues(alpha: 0.2);

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
                    icon: Icons.cancel,
                    label: isMyChallenge
                        ? context.l10n.cancel
                        : context.l10n.decline,
                  ),
                ],
              )
            : null,
        child: PlatformListTile(
          padding: Styles.bodyPadding,
          leading: Icon(challenge.perf.icon),
          trailing: Icon(
            challenge.sideChoice == SideChoice.random
                ? LichessIcons.adjust
                : challenge.sideChoice == SideChoice.white
                    ? LichessIcons.circle
                    : LichessIcons.circle_empty,
          ),
          title: isMyChallenge
              ? UserFullNameWidget(
                  user: challenge.destUser != null
                      ? challenge.destUser!.user
                      : user,
                )
              : UserFullNameWidget(user: user),
          subtitle: Text(subtitle),
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
