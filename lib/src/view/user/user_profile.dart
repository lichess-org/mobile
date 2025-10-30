import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/app_links.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/user/profile.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/duration.dart';
import 'package:lichess_mobile/src/utils/l10n.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/lichess_assets.dart';
import 'package:lichess_mobile/src/view/user/countries.dart';
import 'package:url_launcher/url_launcher.dart';

const _userNameStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.w500);

class UserProfileWidget extends ConsumerWidget {
  const UserProfileWidget({required this.user, this.bioMaxLines = 15});

  final User user;

  final int bioMaxLines;
  static const bioStyle = TextStyle(fontStyle: FontStyle.italic);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authSession = ref.watch(authSessionProvider);
    final userFullName = user.profile?.realName != null
        ? Text(user.profile!.realName!, style: _userNameStyle)
        : null;

    return Card(
      margin: Styles.horizontalBodyPadding.add(Styles.sectionTopPadding),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (user.tosViolation == true && authSession?.user.id != user.id)
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Row(
                  children: [
                    Icon(Icons.error, color: context.lichessColors.error),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        context.l10n.thisAccountViolatedTos,
                        style: TextStyle(
                          color: context.lichessColors.error,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (userFullName != null)
              Padding(padding: const EdgeInsets.only(bottom: 5), child: userFullName),
            if (user.profile?.bio != null)
              Linkify(
                onOpen: (link) => onLinkifyOpen(context, link),
                linkifiers: kLichessLinkifiers,
                text: user.profile!.bio!,
                maxLines: bioMaxLines,
                style: bioStyle,
                overflow: TextOverflow.ellipsis,
                linkStyle: Styles.linkStyle,
              ),
            const SizedBox(height: 10),
            if (user.profile?.fideRating != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text('${context.l10n.xRating('FIDE')}: ${user.profile!.fideRating}'),
              ),
            if (user.profile?.uscfRating != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text('${context.l10n.xRating('USCF')}: ${user.profile!.uscfRating}'),
              ),
            if (user.profile?.ecfRating != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text('${context.l10n.xRating('ECF')}: ${user.profile!.ecfRating}'),
              ),
            if (user.profile?.rcfRating != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text('${context.l10n.xRating('RCF')}: ${user.profile!.rcfRating}'),
              ),
            if (user.profile?.cfcRating != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text('${context.l10n.xRating('CFC')}: ${user.profile!.cfcRating}'),
              ),
            if (user.profile?.dsbRating != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text('${context.l10n.xRating('DSB')}: ${user.profile!.dsbRating}'),
              ),
            if (user.profile != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Location(profile: user.profile!),
              ),
            if (user.createdAt != null)
              Text('${context.l10n.memberSince} ${DateFormat.yMMMMd().format(user.createdAt!)}'),
            if (user.seenAt != null) ...[
              const SizedBox(height: 5),
              Text(context.l10n.lastSeenActive(relativeDate(context.l10n, user.seenAt!))),
            ],
            if (user.playTime != null) ...[
              const SizedBox(height: 5),
              Text(
                context.l10n.tpTimeSpentPlaying(
                  user.playTime!.total.toDaysHoursMinutes(AppLocalizations.of(context)),
                ),
              ),
            ],
            if (user.profile?.links != null) ...[
              const SizedBox(height: 10),
              Text(
                context.l10n.socialMediaLinks,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Wrap(
                spacing: 16.0,
                children: [
                  for (final link in user.profile!.links!)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: InkWell(
                        onTap: () => launchUrl(link.url),
                        child: Text(
                          link.site?.title ?? link.url.toString(),
                          style: Styles.linkStyle,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
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
        if (profile.location != null) ...[Text(profile.location!), const SizedBox(width: 5)],
        if (profile.country != null) ...[
          CachedNetworkImage(
            imageUrl: lichessFlagSrc(profile.country!),
            errorWidget: (_, _, _) => kEmptyWidget,
          ),
          const SizedBox(width: 5),
        ],
        if (countries[profile.country] != null) Text(countries[profile.country]!),
      ],
    );
  }
}
