import 'dart:math' show min;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/experimental/mutation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/common/preloaded_data.dart';
import 'package:lichess_mobile/src/model/message/message_repository.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/network/connectivity.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/http_network_image.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/lichess_assets.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/account/profile_screen.dart';
import 'package:lichess_mobile/src/view/message/contacts_screen.dart';
import 'package:lichess_mobile/src/view/settings/settings_screen.dart';
import 'package:lichess_mobile/src/widgets/adaptive_action_sheet.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountDrawerIconButton extends ConsumerStatefulWidget {
  const AccountDrawerIconButton({super.key});

  @override
  ConsumerState<AccountDrawerIconButton> createState() => _AccountIconButtonState();
}

class _AccountIconButtonState extends ConsumerState<AccountDrawerIconButton> {
  bool errorLoadingFlair = false;

  @override
  Widget build(BuildContext context) {
    final account = ref.watch(accountProvider);
    final unreadMessages = ref.watch(unreadMessagesProvider).value?.unread ?? 0;
    final client = ref.watch(defaultClientProvider);
    return switch (account) {
      AsyncData(:final value) => Badge.count(
        offset: const Offset(-4, 0),
        count: unreadMessages,
        isLabelVisible: unreadMessages > 0,
        child: IconButton(
          tooltip: value == null ? context.l10n.signIn : value.username,
          icon: value == null
              ? const Icon(Icons.account_circle_outlined, size: 30)
              : CircleAvatar(
                  radius: 16,
                  foregroundImage: value.flair != null
                      ? HttpNetworkImage(lichessFlairSrc(value.flair!), client)
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
    final client = ref.read(defaultClientProvider);
    final isOnline = ref.watch(
      connectivityChangesProvider.select((s) => s.value?.isOnline ?? false),
    );
    final signInState = ref.watch(signInMutation);
    final signOutState = ref.watch(signOutMutation);
    final account = ref.watch(accountProvider);
    final authUser = ref.watch(authControllerProvider);
    final kidMode = account.value?.kid ?? false;
    final LightUser? user = account.value?.lightUser ?? authUser?.user;

    final unreadMessages = ref.watch(unreadMessagesProvider).value?.unread ?? 0;

    return Drawer(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      width: min(350.0, MediaQuery.sizeOf(context).width * 0.8),
      child: ListView(
        children: [
          if (user != null) ...[
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              leading: switch (account) {
                AsyncData(:final value) =>
                  value == null
                      ? const Icon(Icons.account_circle_outlined, size: 30)
                      : CircleAvatar(
                          radius: 20,
                          foregroundImage: value.flair != null
                              ? HttpNetworkImage(lichessFlairSrc(value.flair!), client)
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
            if (kidMode)
              ListTile(
                tileColor: Theme.of(context).colorScheme.primaryContainer,
                leading: const Icon(Symbols.sentiment_satisfied, weight: 600),
                title: Text(context.l10n.kidModeIsEnabled),
                onTap: () {
                  launchUrl(lichessUri('/account/kid')).then((_) {
                    ref.invalidate(accountProvider);
                  });
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
            if (account.hasValue && !kidMode)
              ListTile(
                leading: Badge.count(
                  isLabelVisible: unreadMessages > 0,
                  count: unreadMessages,
                  child: const Icon(Icons.mail_outline),
                ),
                title: Text(context.l10n.inbox),
                enabled: isOnline,
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(
                    context,
                    rootNavigator: true,
                  ).push(ContactsScreen.buildRoute(context));
                },
              ),
            switch (signOutState) {
              MutationPending() => const ListTile(
                leading: Icon(Icons.logout_outlined),
                enabled: false,
                title: Center(child: ButtonLoadingIndicator()),
              ),
              _ => ListTile(
                leading: const Icon(Icons.logout_outlined),
                title: Text(context.l10n.logOut),
                enabled: isOnline,
                onTap: () {
                  _showSignOutConfirmDialog(context, ref);
                },
              ),
            },
          ] else ...[
            switch (signInState) {
              MutationPending() => const ListTile(
                leading: Icon(Icons.login_outlined),
                enabled: false,
                title: Center(child: ButtonLoadingIndicator()),
              ),
              _ => ListTile(
                leading: const Icon(Icons.login_outlined),
                title: Text(context.l10n.signIn),
                enabled: isOnline,
                onTap: () {
                  signInMutation.run(ref, (tsx) async {
                    await tsx.get(authControllerProvider.notifier).signIn();
                  });
                },
              ),
            },
          ],
          if (Theme.of(context).platform == TargetPlatform.android)
            ListTile(
              leading: Icon(LichessIcons.patron, semanticLabel: context.l10n.patronLichessPatron),
              title: Text(context.l10n.patronDonate),
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
          const PlatformDivider(indent: 0),
          const SocketPingRatingListTile(),
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
              await signOutMutation.run(ref, (tsx) async {
                await tsx.get(authControllerProvider.notifier).signOut();
              });
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
                  await signOutMutation.run(ref, (tsx) async {
                    await tsx.get(authControllerProvider.notifier).signOut();
                  });
                },
              ),
            ],
          );
        },
      );
    }
  }
}

class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  static Route<void> buildRoute(BuildContext context) {
    return buildScreenRoute(context, screen: const AboutScreen());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packageInfo = ref.read(preloadedDataProvider).requireValue.packageInfo;

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
          ListSection(
            hasLeading: true,
            children: [
              ListTile(
                leading: const Icon(Icons.copyright_outlined),
                title: const Text('View licences'),
                trailing: Theme.of(context).platform == TargetPlatform.iOS
                    ? const CupertinoListTileChevron()
                    : null,
                onTap: () {
                  showLicensePage(
                    context: context,
                    applicationName: 'Lichess',
                    applicationVersion: packageInfo.version,
                    applicationIcon: const Icon(LichessIcons.logo_lichess),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
