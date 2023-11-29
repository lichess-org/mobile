import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/utils/duration.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';

import 'countries.dart';

const _userNameStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.w500);

class UserProfile extends StatelessWidget {
  const UserProfile({
    required this.user,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    final userFullName = user.profile?.fullName != null
        ? Text(
            user.profile!.fullName!,
            style: _userNameStyle,
          )
        : null;

    return Padding(
      padding: Styles.bodySectionPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (userFullName != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: userFullName,
            ),
          if (user.profile?.bio != null)
            Text(
              user.profile!.bio!,
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
          const SizedBox(height: 10),
          if (user.profile != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Location(profile: user.profile!),
            ),
          Text(
            '${context.l10n.memberSince} ${DateFormat.yMMMMd().format(user.createdAt)}',
          ),
          if (user.seenAt != null) ...[
            const SizedBox(height: 5),
            Text(context.l10n.lastSeenActive(timeago.format(user.seenAt!))),
          ],
          const SizedBox(height: 5),
          if (user.playTime != null)
            Text(
              context.l10n.tpTimeSpentPlaying(
                user.playTime!.total
                    .toDaysHoursMinutes(AppLocalizations.of(context)),
              ),
            )
          else
            kEmptyWidget,
        ],
      ),
    );
  }
}

class Location extends StatelessWidget {
  const Location({required this.profile, super.key});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (profile.country != null)
          CachedNetworkImage(
            imageUrl: lichessFlagSrc(profile.country!),
            errorWidget: (_, __, ___) => kEmptyWidget,
          )
        else
          kEmptyWidget,
        const SizedBox(width: 10),
        Text(profile.location ?? countries[profile.country] ?? ''),
      ],
    );
  }
}

String lichessFlagSrc(String country) {
  return '$kLichessHost/assets/images/flags/$country.png';
}
