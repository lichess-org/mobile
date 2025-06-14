import 'dart:math' show min;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/network/connectivity.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/lichess_assets.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/account/profile_screen.dart';
import 'package:lichess_mobile/src/view/settings/account_preferences_screen.dart';
import 'package:lichess_mobile/src/view/settings/settings_screen.dart';
import 'package:lichess_mobile/src/widgets/adaptive_action_sheet.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountIconButton extends ConsumerStatefulWidget {
  const AccountIconButton({super.key});

  @override
  ConsumerState<AccountIconButton> createState() => _AccountIconButtonState();
}

class _AccountIconButtonState extends ConsumerState<AccountIconButton> {
  bool errorLoadingFlair = false;

  @override
  Widget build(BuildContext context) {
    final account = ref.watch(accountProvider);
    return switch (account) {
      AsyncData(:final value) => IconButton(
        tooltip: value == null ? context.l10n.signIn : value.username,
        icon: value == null
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
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
      _ => IconButton(
        icon: const Icon(Icons.account_circle_outlined, size: 30),
        tooltip: context.l10n.signIn,
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
    };
  }
}

class AccountDrawer extends ConsumerStatefulWidget {
  const AccountDrawer({super.key});

  @override
  ConsumerState<AccountDrawer> createState() => _AccountDrawerState();
}

class _AccountDrawerState extends ConsumerState<AccountDrawer> {
  bool errorLoadingFlair = false;

  @override
  Widget build(BuildContext context) {
    final isOnline = ref.watch(
      connectivityChangesProvider.select((s) => s.value?.isOnline ?? false),
    );
    final authController = ref.watch(authControllerProvider);
    final account = ref.watch(accountProvider);
    final userSession = ref.watch(authSessionProvider);
    final LightUser? user = account.valueOrNull?.lightUser ?? userSession?.user;

    return Drawer(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      width: min(350.0, MediaQuery.sizeOf(context).width * 0.8),
      child: ListView(
        children: [
          if (user != null) ...[
            ListTile(
              leading: switch (account) {
                AsyncData(:final value) =>
                  value == null
                      ? const Icon(Icons.account_circle_outlined, size: 30)
                      : CircleAvatar(
                          radius: 20,
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
                          child: value.flair == null || errorLoadingFlair
                              ? Text(value.initials)
                              : null,
                        ),
                _ => const Icon(Icons.account_circle_outlined, size: 30),
              },
              trailing: const SocketPingRating(),
              title: AutoSizeText(
                user.name,
                style: Styles.callout,
                maxLines: 1,
                minFontSize: 14,
                maxFontSize: 18,
                overflow: TextOverflow.ellipsis,
              ),
              enabled: isOnline,
              onTap: () {
                ref.invalidate(accountProvider);
                Navigator.of(context).pop();
                Navigator.of(context, rootNavigator: true).push(ProfileScreen.buildRoute(context));
              },
            ),
            const PlatformDivider(indent: 0),
          ],
          if (user != null) ...[
            ListTile(
              leading: const Icon(Icons.person_outlined),
              title: Text(context.l10n.profile),
              enabled: isOnline,
              onTap: () {
                ref.invalidate(accountProvider);
                Navigator.of(context).pop();
                Navigator.of(context, rootNavigator: true).push(ProfileScreen.buildRoute(context));
              },
            ),
            ListTile(
              leading: const Icon(Icons.manage_accounts_outlined),
              title: Text(context.l10n.mobileAccountPreferences),
              enabled: isOnline,
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(
                  context,
                  rootNavigator: true,
                ).push(AccountPreferencesScreen.buildRoute(context));
              },
            ),
            if (authController.isLoading)
              const ListTile(
                leading: Icon(Icons.logout_outlined),
                enabled: false,
                title: Center(child: ButtonLoadingIndicator()),
              )
            else
              ListTile(
                leading: const Icon(Icons.logout_outlined),
                title: Text(context.l10n.logOut),
                enabled: isOnline,
                onTap: () {
                  _showSignOutConfirmDialog(context, ref);
                },
              ),
          ] else ...[
            if (authController.isLoading)
              const ListTile(
                leading: Icon(Icons.login_outlined),
                trailing: SocketPingRating(),
                enabled: false,
                title: Center(child: ButtonLoadingIndicator()),
              )
            else
              ListTile(
                leading: const Icon(Icons.login_outlined),
                trailing: const SocketPingRating(),
                title: Text(context.l10n.signIn),
                enabled: isOnline,
                onTap: () {
                  ref.read(authControllerProvider.notifier).signIn();
                },
              ),
          ],
          if (Theme.of(context).platform == TargetPlatform.android)
            ListTile(
              leading: Icon(LichessIcons.patron, semanticLabel: context.l10n.patronLichessPatron),
              title: Text(context.l10n.patronDonate),
              trailing: Theme.of(context).platform == TargetPlatform.iOS
                  ? const Icon(Icons.chevron_right)
                  : null,
              enabled: isOnline,
              onTap: () {
                launchUrl(Uri.parse('https://lichess.org/patron'));
              },
            ),
          const PlatformDivider(indent: 0),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: Text(context.l10n.settingsSettings),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context, rootNavigator: true).push(SettingsScreen.buildRoute(context));
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(context.l10n.about),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context, rootNavigator: true).push(AboutScreen.buildRoute(context));
            },
          ),
        ],
      ),
    );
  }

  Future<void> _showSignOutConfirmDialog(BuildContext context, WidgetRef ref) {
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
}

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static Route<void> buildRoute(BuildContext context) {
    return buildScreenRoute(context, screen: const AboutScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.about)),
      body: ListView(
        children: [
          ListSection(
            hasLeading: true,
            children: [
              ListTile(
                leading: const Icon(Icons.info_outlined),
                title: Text(context.l10n.aboutX('Lichess')),
                trailing: Theme.of(context).platform == TargetPlatform.iOS
                    ? const CupertinoListTileChevron()
                    : null,
                onTap: () {
                  launchUrl(Uri.parse('https://lichess.org/about'));
                },
              ),
              ListTile(
                leading: const Icon(Icons.feedback_outlined),
                title: Text(context.l10n.mobileFeedbackButton),
                trailing: Theme.of(context).platform == TargetPlatform.iOS
                    ? const CupertinoListTileChevron()
                    : null,
                onTap: () {
                  launchUrl(Uri.parse('https://lichess.org/contact'));
                },
              ),
              ListTile(
                leading: const Icon(Icons.article_outlined),
                title: Text(context.l10n.termsOfService),
                trailing: Theme.of(context).platform == TargetPlatform.iOS
                    ? const CupertinoListTileChevron()
                    : null,
                onTap: () {
                  launchUrl(Uri.parse('https://lichess.org/terms-of-service'));
                },
              ),
              ListTile(
                leading: const Icon(Icons.privacy_tip_outlined),
                title: Text(context.l10n.privacyPolicy),
                trailing: Theme.of(context).platform == TargetPlatform.iOS
                    ? const CupertinoListTileChevron()
                    : null,
                onTap: () {
                  launchUrl(Uri.parse('https://lichess.org/privacy'));
                },
              ),
            ],
          ),
          ListSection(
            hasLeading: true,
            children: [
              ListTile(
                leading: const Icon(Symbols.database),
                title: Text(context.l10n.database),
                trailing: Theme.of(context).platform == TargetPlatform.iOS
                    ? const CupertinoListTileChevron()
                    : null,
                onTap: () {
                  launchUrl(Uri.parse('https://database.lichess.org'));
                },
              ),
              ListTile(
                leading: const Icon(Icons.code_outlined),
                title: Text(context.l10n.sourceCode),
                trailing: Theme.of(context).platform == TargetPlatform.iOS
                    ? const CupertinoListTileChevron()
                    : null,
                onTap: () {
                  launchUrl(Uri.parse('https://lichess.org/source'));
                },
              ),
              ListTile(
                leading: const Icon(Icons.bug_report_outlined),
                title: Text(context.l10n.contribute),
                trailing: Theme.of(context).platform == TargetPlatform.iOS
                    ? const CupertinoListTileChevron()
                    : null,
                onTap: () {
                  launchUrl(Uri.parse('https://lichess.org/help/contribute'));
                },
              ),
              ListTile(
                leading: const Icon(Icons.star_border_outlined),
                title: Text(context.l10n.thankYou),
                trailing: Theme.of(context).platform == TargetPlatform.iOS
                    ? const CupertinoListTileChevron()
                    : null,
                onTap: () {
                  launchUrl(Uri.parse('https://lichess.org/thanks'));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
