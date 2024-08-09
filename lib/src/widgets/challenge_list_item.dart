import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lichess_mobile/src/model/challenge/challenge.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';
import 'package:lichess_mobile/src/model/lobby/correspondence_challenge.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/user_full_name.dart';

class ChallengeListItem extends StatelessWidget {
  const ChallengeListItem({
    super.key,
    required this.challenge,
    required this.user,
    required this.subtitle,
    this.cancelText,
    this.color,
    this.onPressed,
    this.onCancel,
  });

  final Challenge challenge;
  final LightUser user;
  final String subtitle;
  final String? cancelText;
  final Color? color;
  final VoidCallback? onPressed;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
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
                    label: cancelText ?? context.l10n.cancel,
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
          title: UserFullNameWidget(user: user),
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
    required this.subtitle,
    this.color,
    this.onPressed,
    this.onCancel,
  });

  final CorrespondenceChallenge challenge;
  final LightUser user;
  final String subtitle;
  final Color? color;
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
      subtitle: subtitle,
    );
  }
}
