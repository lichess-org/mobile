import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/lichess_assets.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/account/profile_screen.dart';
import 'package:lichess_mobile/src/view/settings/account_preferences_screen.dart';
import 'package:lichess_mobile/src/widgets/adaptive_action_sheet.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/platform_context_menu_button.dart';
import 'package:lichess_mobile/src/widgets/user_full_name.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountMenu extends ConsumerStatefulWidget {
  const AccountMenu({super.key});

  @override
  ConsumerState<AccountMenu> createState() => _AccountMenuState();
}

class _AccountMenuState extends ConsumerState<AccountMenu> {
  bool errorLoadingFlair = false;

  @override
  Widget build(BuildContext context) {
    final authController = ref.watch(authControllerProvider);
    final account = ref.watch(accountProvider);
    final userSession = ref.watch(authSessionProvider);
    final LightUser? user = account.valueOrNull?.lightUser ?? userSession?.user;

    return ContextMenuIconButton(
      icon: switch (account) {
        AsyncData(:final value) =>
          value == null
              ? const Icon(Icons.account_circle_outlined, size: 30)
              : CircleAvatar(
                  radius: 16,
                  foregroundImage: value.flair != null
                      ? CachedNetworkImageProvider(lichessFlairSrc(value.flair!))
                      : null,
                  onForegroundImageError: value.flair != null
                      ? (error, _) {
                          setState(() {
                            errorLoadingFlair = true;
                          });
                        }
                      : null,
                  backgroundColor: value.flair == null || errorLoadingFlair
                      ? null
                      : ColorScheme.of(context).surfaceContainer,
                  child: value.flair == null || errorLoadingFlair ? Text(value.initials) : null,
                ),
        _ => Icon(Icons.account_circle_outlined, semanticLabel: context.l10n.signIn, size: 30),
      },
      semanticsLabel: user == null ? context.l10n.signIn : user.name,
      actions: [
        if (userSession != null) ...[
          ContextMenuAction(
            icon: Icons.person_outline,
            label: context.l10n.profile,
            onPressed: () {
              ref.invalidate(accountProvider);
              Navigator.of(context).push(ProfileScreen.buildRoute(context));
            },
          ),
          ContextMenuAction(
            icon: Icons.manage_accounts_outlined,
            label: context.l10n.mobileAccountPreferences,
            onPressed: () {
              Navigator.of(context).push(AccountPreferencesScreen.buildRoute(context));
            },
          ),
          if (authController.isLoading)
            ContextMenuAction(
              icon: Icons.logout_outlined,
              label: context.l10n.logOut,
              onPressed: null, // Disabled while loading
            )
          else
            ContextMenuAction(
              icon: Icons.logout_outlined,
              label: context.l10n.logOut,
              onPressed: () {
                showSignOutConfirmDialog(context, ref);
              },
            ),
        ] else ...[
          if (authController.isLoading)
            ContextMenuAction(
              icon: Icons.login_outlined,
              label: context.l10n.signIn,
              onPressed: null, // Disabled while loading
            )
          else
            ContextMenuAction(
              icon: Icons.login_outlined,
              label: context.l10n.signIn,
              onPressed: () {
                ref.read(authControllerProvider.notifier).signIn();
              },
            ),
        ],
      ],
    );
  }
}

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  static Route<dynamic> buildRoute(BuildContext context) {
    return buildScreenRoute(context, screen: const AccountScreen());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authController = ref.watch(authControllerProvider);
    final account = ref.watch(accountProvider);
    final userSession = ref.watch(authSessionProvider);
    final LightUser? user = account.valueOrNull?.lightUser ?? userSession?.user;

    final Widget? donateButton = userSession == null || userSession.user.isPatron != true
        ? ListTile(
            leading: Icon(
              LichessIcons.patron,
              semanticLabel: context.l10n.patronLichessPatron,
              color: context.lichessColors.brag,
            ),
            title: Text(
              context.l10n.patronDonate,
              style: TextStyle(color: context.lichessColors.brag),
            ),
            trailing: Theme.of(context).platform == TargetPlatform.iOS
                ? const CupertinoListTileChevron()
                : null,
            onTap: () {
              launchUrl(Uri.parse('https://lichess.org/patron'));
            },
          )
        : null;

    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: user == null ? const SizedBox.shrink() : UserFullNameWidget(user: user),
        actions: const [SocketPingRating()],
      ),
      body: ListView(
        children: [
          ListSection(
            hasLeading: true,
            children: [
              if (userSession != null) ...[
                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: Text(context.l10n.profile),
                  trailing: Theme.of(context).platform == TargetPlatform.iOS
                      ? const CupertinoListTileChevron()
                      : null,
                  onTap: () {
                    ref.invalidate(accountProvider);
                    Navigator.of(context).push(ProfileScreen.buildRoute(context));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.manage_accounts_outlined),
                  title: Text(context.l10n.mobileAccountPreferences),
                  trailing: Theme.of(context).platform == TargetPlatform.iOS
                      ? const CupertinoListTileChevron()
                      : null,
                  onTap: () {
                    Navigator.of(context).push(AccountPreferencesScreen.buildRoute(context));
                  },
                ),
                if (authController.isLoading)
                  const ListTile(
                    leading: Icon(Icons.logout_outlined),
                    title: Center(child: ButtonLoadingIndicator()),
                  )
                else
                  ListTile(
                    leading: const Icon(Icons.logout_outlined),
                    title: Text(context.l10n.logOut),
                    onTap: () {
                      showSignOutConfirmDialog(context, ref);
                    },
                  ),
              ] else ...[
                if (authController.isLoading)
                  const ListTile(
                    leading: Icon(Icons.login_outlined),
                    title: Center(child: ButtonLoadingIndicator()),
                  )
                else
                  ListTile(
                    leading: const Icon(Icons.login_outlined),
                    title: Text(context.l10n.signIn),
                    onTap: () {
                      ref.read(authControllerProvider.notifier).signIn();
                    },
                  ),
              ],
              if (Theme.of(context).platform == TargetPlatform.android && donateButton != null)
                donateButton,
            ],
          ),
        ],
      ),
    );
  }
}

Future<void> showSignOutConfirmDialog(BuildContext context, WidgetRef ref) {
  if (Theme.of(context).platform == TargetPlatform.iOS) {
    return showCupertinoActionSheet(
      context: context,
      actions: [
        BottomSheetAction(
          makeLabel: (context) => Text(context.l10n.logOut),
          isDestructiveAction: true,
          onPressed: () async {
            await ref.read(authControllerProvider.notifier).signOut();
          },
        ),
      ],
    );
  } else {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(context.l10n.logOut),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(textStyle: TextTheme.of(context).labelLarge),
              child: Text(context.l10n.cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(textStyle: TextTheme.of(context).labelLarge),
              child: Text(context.l10n.mobileOkButton),
              onPressed: () async {
                Navigator.of(context).pop();
                await ref.read(authControllerProvider.notifier).signOut();
              },
            ),
          ],
        );
      },
    );
  }
}
