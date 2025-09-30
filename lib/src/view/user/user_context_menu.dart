import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/app_links.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/model/user/user_repository_providers.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/user/user_screen.dart';
import 'package:lichess_mobile/src/view/watch/tv_screen.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/user.dart';

class UserContextMenu extends ConsumerWidget {
  const UserContextMenu({this.user, this.userId, super.key})
    : assert(user != null || userId != null, 'user or userId must be provided');

  final User? user;
  final UserId? userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(authSessionProvider);

    final AsyncValue<User> userAsync = user != null
        ? AsyncData(user!)
        : ref.watch(userProvider(id: userId!));

    switch (userAsync) {
      case AsyncData(:final value):
        return BottomSheetScrollableContainer(
          children: [
            Padding(
              padding: Styles.horizontalBodyPadding.add(const EdgeInsets.only(bottom: 16.0)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  UserFullNameWidget(user: value.lightUser, style: Styles.title),
                  const SizedBox(height: 8.0),
                  if (value.profile?.bio != null)
                    Linkify(
                      onOpen: (link) => onLinkifyOpen(context, link),
                      linkifiers: kLichessLinkifiers,
                      text: value.profile!.bio!,
                      maxLines: 20,
                      overflow: TextOverflow.ellipsis,
                      linkStyle: const TextStyle(
                        color: Colors.blueAccent,
                        decoration: TextDecoration.none,
                      ),
                    ),
                ],
              ),
            ),
            const PlatformDivider(),
            BottomSheetContextMenuAction(
              onPressed: () {
                Navigator.of(context).push(UserScreen.buildRoute(context, value.lightUser));
              },
              icon: Icons.person,
              child: Text(context.l10n.profile),
            ),
            ListTile(
              title: Text(context.l10n.watchGames),
              leading: const Icon(Icons.live_tv_outlined),
              onTap: () {
                Navigator.of(
                  context,
                  rootNavigator: true,
                ).push(TvScreen.buildRoute(context, user: value.lightUser));
              },
            ),
            if (session != null && value.canChallenge == true)
              BottomSheetContextMenuAction(
                onPressed: () => UserScreen.challengeUser(value, context: context, ref: ref),
                icon: LichessIcons.crossed_swords,
                child: Text(context.l10n.challengeChallengeToPlay),
              ),
          ],
        );
      case AsyncError(:final error):
        debugPrint('Could not load user: $error');
        return const Center(child: Text('Could not load user'));
      case _:
        return const CenterLoadingIndicator();
    }
  }
}
