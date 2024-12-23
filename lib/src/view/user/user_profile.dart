import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/user/profile.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/duration.dart';
import 'package:lichess_mobile/src/utils/l10n.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/lichess_assets.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/user/user_screen.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:linkify/linkify.dart';
import 'package:url_launcher/url_launcher.dart';

import 'countries.dart';

const _userNameStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.w500);

class UserProfileWidget extends ConsumerWidget {
  const UserProfileWidget({required this.user, this.bioMaxLines = 10});

  final User user;

  final int bioMaxLines;
  static const bioStyle = TextStyle(fontStyle: FontStyle.italic);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userFullName =
        user.profile?.realName != null
            ? Text(user.profile!.realName!, style: _userNameStyle)
            : null;

    return Padding(
      padding: Styles.horizontalBodyPadding.add(Styles.sectionTopPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (user.tosViolation == true)
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
              onOpen: (link) async {
                if (link.originText.startsWith('@')) {
                  final username = link.originText.substring(1);
                  pushPlatformRoute(
                    context,
                    builder:
                        (ctx) => UserScreen(
                          user: LightUser(id: UserId.fromUserName(username), name: username),
                        ),
                  );
                } else {
                  launchUrl(Uri.parse(link.url));
                }
              },
              linkifiers: const [UrlLinkifier(), EmailLinkifier(), UserTagLinkifier()],
              text: user.profile!.bio!.replaceAll('\n', ' '),
              maxLines: bioMaxLines,
              style: bioStyle,
              overflow: TextOverflow.ellipsis,
              linkStyle: const TextStyle(color: Colors.blueAccent, decoration: TextDecoration.none),
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
            SizedBox(
              height: 50,
              width: double.infinity,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  for (final link in user.profile!.links!)
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: AdaptiveTextButton(
                        onPressed: () => launchUrl(link.url),
                        child: Text(link.site?.title ?? link.url.toString()),
                      ),
                    ),
                ],
              ),
            ),
          ],
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
        if (profile.country != null) ...[
          CachedNetworkImage(
            imageUrl: lichessFlagSrc(profile.country!),
            errorWidget: (_, __, ___) => kEmptyWidget,
          ),
          const SizedBox(width: 5),
        ] else
          kEmptyWidget,
        Text(profile.location ?? countries[profile.country] ?? ''),
      ],
    );
  }
}
