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

/// Account menu screen opened by [AccountMenuButton].
///
/// On Android it is pushed as a full-screen page. On iOS it is presented
/// inside a [CupertinoSheetRoute] with nested navigation.
class AccountMenuScreen extends ConsumerStatefulWidget {
  const AccountMenuScreen({super.key});

  static Route<void> buildRoute(BuildContext context) {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      return buildScreenRoute(context, screen: const AccountMenuScreen());
    }

    return PageRouteBuilder<void>(
      pageBuilder: (_, a, b) => const AccountMenuScreen(),
      transitionsBuilder: (_, animation, b, child) {
        final tween = Tween(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeInOut));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }

  @override
  ConsumerState<AccountMenuScreen> createState() => _AccountMenuScreenState();
}

class _AccountMenuScreenState extends ConsumerState<AccountMenuScreen> with WidgetsBindingObserver {
  bool _errorLoadingFlair = false;
  bool _pendingKidModeRefresh = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _pendingKidModeRefresh) {
      _pendingKidModeRefresh = false;
      ref.invalidate(accountProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final client = ref.read(defaultClientProvider);
    final isOnline = ref.watch(onlineStatusProvider).value ?? false;
    final signInState = ref.watch(signInMutation);
    final signOutState = ref.watch(signOutMutation);
    final account = ref.watch(accountProvider);
    final authUser = ref.watch(authControllerProvider);
    final kidMode = account.value?.kid ?? false;
    final LightUser? user = account.value?.lightUser ?? authUser?.user;
    final unreadMessages = ref.watch(unreadMessagesProvider).value?.unread ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.mobileAccount),
        automaticallyImplyLeading: Theme.of(context).platform == TargetPlatform.iOS,
        actions: [
          if (Theme.of(context).platform != TargetPlatform.iOS)
            IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(context).pop()),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                if (user != null)
                  ListSection(
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        leading: switch (account) {
                          AsyncData(:final value) =>
                            value == null
                                ? const Icon(Icons.account_circle_outlined, size: 30)
                                : CircleAvatar(
                                    radius: 20,
                                    foregroundImage: value.flair != null && !_errorLoadingFlair
                                        ? HttpNetworkImage(lichessFlairSrc(value.flair!), client)
                                        : null,
                                    onForegroundImageError: value.flair != null
                                        ? (error, _) => setState(() => _errorLoadingFlair = true)
                                        : null,
                                    backgroundColor: value.flair == null || _errorLoadingFlair
                                        ? null
                                        : ColorScheme.of(context).surfaceContainer,
                                    child: value.flair == null || _errorLoadingFlair
                                        ? Text(value.initials)
                                        : null,
                                  ),
                          _ => const Icon(Icons.account_circle_outlined, size: 30),
                        },
                        trailing: Theme.of(context).platform == TargetPlatform.iOS
                            ? const CupertinoListTileChevron()
                            : null,
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
                          _navigate(context, ProfileScreen.buildRoute(context));
                        },
                      ),
                      if (kidMode)
                        ListTile(
                          textColor: Theme.of(context).colorScheme.primary,
                          iconColor: Theme.of(context).colorScheme.primary,
                          leading: const Icon(Symbols.sentiment_satisfied, weight: 600),
                          title: Text(
                            context.l10n.kidModeIsEnabled,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          onTap: () {
                            _pendingKidModeRefresh = true;
                            launchUrl(lichessUri('/account/kid'));
                          },
                        ),
                    ],
                  )
                else ...[
                  Center(
                    child: FilledButton(
                      onPressed: isOnline
                          ? switch (signInState) {
                              MutationPending() => null,
                              _ => () {
                                signInMutation.run(ref, (tsx) async {
                                  await tsx.get(authControllerProvider.notifier).signIn();
                                });
                              },
                            }
                          : null,
                      child: Text(context.l10n.signIn),
                    ),
                  ),
                ],
                ListSection(
                  children: [
                    if (user != null && account.hasValue && !kidMode)
                      ListTile(
                        leading: Badge.count(
                          isLabelVisible: unreadMessages > 0,
                          count: unreadMessages,
                          child: const Icon(Icons.mail_outline),
                        ),
                        trailing: Theme.of(context).platform == TargetPlatform.iOS
                            ? const CupertinoListTileChevron()
                            : null,
                        title: Text(context.l10n.inbox),
                        enabled: isOnline,
                        onTap: () {
                          _navigate(context, ContactsScreen.buildRoute(context));
                        },
                      ),
                    ListTile(
                      leading: const Icon(Icons.settings_outlined),
                      trailing: Theme.of(context).platform == TargetPlatform.iOS
                          ? const CupertinoListTileChevron()
                          : null,
                      title: Text(context.l10n.settingsSettings),
                      onTap: () {
                        _navigate(context, SettingsScreen.buildRoute(context));
                      },
                    ),
                    if (user != null)
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
                          onTap: () => _showSignOutConfirmDialog(context, ref),
                        ),
                      },
                  ],
                ),
                ListSection(
                  children: [
                    if (Theme.of(context).platform == TargetPlatform.android)
                      ListTile(
                        leading: Icon(
                          LichessIcons.patron,
                          semanticLabel: context.l10n.patronLichessPatron,
                        ),
                        title: Text(context.l10n.patronDonate),
                        enabled: isOnline,
                        onTap: () => launchUrl(Uri.parse('https://lichess.org/patron')),
                      ),
                    ListTile(
                      leading: const Icon(Icons.info_outline),
                      trailing: Theme.of(context).platform == TargetPlatform.iOS
                          ? const CupertinoListTileChevron()
                          : null,
                      title: Text(context.l10n.about),
                      onTap: () {
                        _navigate(context, AboutScreen.buildRoute(context));
                      },
                    ),
                  ],
                ),
                const SocketPingRatingListTile(),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: Theme.of(context).platform == TargetPlatform.iOS ? 8.0 : 16.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: TextTheme.of(context).bodyMedium,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    ),
                    onPressed: () => launchUrl(Uri.parse('https://lichess.org/terms-of-service')),
                    child: Text(context.l10n.termsOfService),
                  ),
                  Text('  •  ', style: TextTheme.of(context).bodyMedium),
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: TextTheme.of(context).bodyMedium,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    ),
                    onPressed: () => launchUrl(Uri.parse('https://lichess.org/privacy')),
                    child: Text(context.l10n.privacyPolicy),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigate(BuildContext context, Route<dynamic> route) {
    Navigator.of(context).push(route);
  }

  void _showSignOutConfirmDialog(BuildContext context, WidgetRef ref) {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      showCupertinoActionSheet<void>(
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
      showDialog<void>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: Text(context.l10n.logOut),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(context.l10n.cancel),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(dialogContext).pop();
                  await signOutMutation.run(ref, (tsx) async {
                    await tsx.get(authControllerProvider.notifier).signOut();
                  });
                },
                child: Text(context.l10n.mobileOkButton),
              ),
            ],
          );
        },
      );
    }
  }
}

/// Avatar button that opens the account menu.
///
/// On Android opens [AccountMenuScreen] as a full-screen page sliding from the
/// right. On iOS opens the same screen inside a [CupertinoSheetRoute] with
/// nested navigation.
class AccountMenuButton extends ConsumerStatefulWidget {
  const AccountMenuButton({super.key});

  @override
  ConsumerState<AccountMenuButton> createState() => _AccountMenuButtonState();
}

class _AccountMenuButtonState extends ConsumerState<AccountMenuButton> {
  bool _errorLoadingFlair = false;

  static const _materialAnonIconSize = 30.0;
  static const _cupertinoAnonIconSize = 32.0;

  @override
  Widget build(BuildContext context) {
    final account = ref.watch(accountProvider);
    final kidMode = account.value?.kid ?? false;
    final unreadMessages = ref.watch(unreadMessagesProvider).value?.unread ?? 0;
    final client = ref.watch(defaultClientProvider);

    void openMenu() {
      Navigator.of(context, rootNavigator: true).push(AccountMenuScreen.buildRoute(context));
    }

    return switch (account) {
      AsyncData(:final value) => Badge.count(
        offset: const Offset(-4, 0),
        count: unreadMessages,
        isLabelVisible: !kidMode && unreadMessages > 0,
        child: IconButton(
          tooltip: value == null ? context.l10n.signIn : value.username,
          icon: value == null
              ? Icon(
                  Icons.account_circle_outlined,
                  size: Theme.of(context).platform == TargetPlatform.iOS
                      ? _cupertinoAnonIconSize
                      : _materialAnonIconSize,
                )
              : CircleAvatar(
                  radius:
                      (Theme.of(context).platform == TargetPlatform.iOS
                          ? _cupertinoAnonIconSize / 2
                          : _materialAnonIconSize / 2) +
                      1,
                  foregroundImage: value.flair != null && !_errorLoadingFlair
                      ? HttpNetworkImage(lichessFlairSrc(value.flair!), client)
                      : null,
                  onForegroundImageError: value.flair != null
                      ? (error, _) => setState(() => _errorLoadingFlair = true)
                      : null,
                  backgroundColor: value.flair == null || _errorLoadingFlair
                      ? null
                      : ColorScheme.of(context).surfaceContainer,
                  child: value.flair == null || _errorLoadingFlair ? Text(value.initials) : null,
                ),
          onPressed: openMenu,
        ),
      ),
      _ => IconButton(
        icon: Icon(
          Icons.account_circle_outlined,
          size: Theme.of(context).platform == TargetPlatform.iOS
              ? _cupertinoAnonIconSize
              : _materialAnonIconSize,
        ),
        tooltip: context.l10n.signIn,
        onPressed: openMenu,
      ),
    };
  }
}

/// About screen with links to various lichess resources and legal information.
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
          Padding(
            padding: Styles.bodySectionPadding,
            child: Text('v${packageInfo.version}', style: TextTheme.of(context).bodySmall),
          ),
        ],
      ),
    );
  }
}
