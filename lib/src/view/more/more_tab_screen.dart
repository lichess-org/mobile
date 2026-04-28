import 'package:dartchess/dartchess.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/experimental/mutation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/message/message_repository.dart';
import 'package:lichess_mobile/src/network/connectivity.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/tab_scaffold.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/account/account_drawer.dart';
import 'package:lichess_mobile/src/view/account/profile_screen.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_screen.dart';
import 'package:lichess_mobile/src/view/board_editor/board_editor_screen.dart';
import 'package:lichess_mobile/src/view/clock/clock_tool_screen.dart';
import 'package:lichess_mobile/src/view/explorer/opening_explorer_screen.dart';
import 'package:lichess_mobile/src/view/message/contacts_screen.dart';
import 'package:lichess_mobile/src/view/more/import_pgn_screen.dart';
import 'package:lichess_mobile/src/view/relation/friend_screen.dart';
import 'package:lichess_mobile/src/view/settings/settings_screen.dart';
import 'package:lichess_mobile/src/view/user/player_screen.dart';
import 'package:lichess_mobile/src/widgets/adaptive_action_sheet.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/misc.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';
import 'package:lichess_mobile/src/widgets/user.dart';
import 'package:url_launcher/url_launcher.dart';

class MoreTabScreen extends ConsumerWidget {
  const MoreTabScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, _) {
        if (!didPop) {
          ref.read(currentBottomTabProvider.notifier).state = BottomTab.home;
        }
      },
      child: PlatformScaffold(
        appBar: PlatformAppBar(
          title: const AppBarLichessTitle(),
          centerTitle: true,
          leading: Theme.of(context).platform == TargetPlatform.android
              ? null
              : const AccountDrawerIconButton(),
          actions: [
            if (Theme.of(context).platform == TargetPlatform.android) const AndroidOverflowMenu(),
          ],
        ),
        drawer: Theme.of(context).platform == TargetPlatform.android ? null : const AccountDrawer(),
        body: const _Body(),
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOnline = ref.watch(onlineStatusProvider).value ?? false;
    final authUser = ref.watch(authControllerProvider);

    return ListTileTheme.merge(
      iconColor: Theme.of(context).colorScheme.primary,
      child: ListView(
        controller: moreScrollController,
        children: [
          ListSection(
            header: SettingsSectionTitle(context.l10n.tools),
            hasLeading: true,
            children: [
              ListTile(
                leading: const Icon(Icons.upload_file_outlined),
                trailing: Theme.of(context).platform == TargetPlatform.iOS
                    ? const CupertinoListTileChevron()
                    : null,
                title: Text(context.l10n.importPgn),
                onTap: () => Navigator.of(context).push(ImportPgnScreen.buildRoute(context)),
              ),
              ListTile(
                leading: const Icon(Icons.biotech_outlined),
                trailing: Theme.of(context).platform == TargetPlatform.iOS
                    ? const CupertinoListTileChevron()
                    : null,
                title: Text(context.l10n.analysis),
                onTap: () => Navigator.of(context, rootNavigator: true).push(
                  AnalysisScreen.buildRoute(
                    context,
                    const AnalysisOptions.standalone(variant: Variant.standard),
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.explore_outlined),
                trailing: Theme.of(context).platform == TargetPlatform.iOS
                    ? const CupertinoListTileChevron()
                    : null,
                title: Text(context.l10n.openingExplorer),
                enabled: isOnline,
                onTap: () => Navigator.of(context, rootNavigator: true).push(
                  OpeningExplorerScreen.buildRoute(
                    context,
                    const AnalysisOptions.pgn(
                      id: StringId('standalone_opening_explorer'),
                      orientation: Side.white,
                      pgn: '',
                      isComputerAnalysisAllowed: false,
                      variant: Variant.standard,
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                trailing: Theme.of(context).platform == TargetPlatform.iOS
                    ? const CupertinoListTileChevron()
                    : null,
                title: Text(context.l10n.boardEditor),
                onTap: () => Navigator.of(context, rootNavigator: true).push(
                  BoardEditorScreen.buildRoute(context, (
                    initialVariant: Variant.standard,
                    initialFen: null,
                  )),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.alarm_outlined),
                trailing: Theme.of(context).platform == TargetPlatform.iOS
                    ? const CupertinoListTileChevron()
                    : null,
                title: Text(context.l10n.clock),
                onTap: () {
                  Navigator.of(
                    context,
                    rootNavigator: true,
                  ).push(ClockToolScreen.buildRoute(context));
                },
              ),
            ],
          ),
          ListSection(
            header: SettingsSectionTitle(context.l10n.community),
            hasLeading: true,
            children: [
              ListTile(
                leading: const Icon(Icons.groups_3_outlined),
                title: Text(context.l10n.players),
                enabled: isOnline,
                trailing: Theme.of(context).platform == TargetPlatform.iOS
                    ? const CupertinoListTileChevron()
                    : null,
                onTap: () {
                  Navigator.of(context, rootNavigator: true).push(PlayerScreen.buildRoute(context));
                },
              ),
              if (authUser != null)
                ListTile(
                  leading: const Icon(Icons.people_outline),
                  title: Text(context.l10n.friends),
                  enabled: isOnline,
                  trailing: Theme.of(context).platform == TargetPlatform.iOS
                      ? const CupertinoListTileChevron()
                      : null,
                  onTap: () {
                    Navigator.of(
                      context,
                      rootNavigator: true,
                    ).push(FriendScreen.buildRoute(context));
                  },
                ),
            ],
          ),
          const _AccountSection(),
          if (Theme.of(context).platform == TargetPlatform.android)
            ListSection(
              hasLeading: true,
              children: [
                ListTile(
                  leading: PatronIcon(color: 10, size: IconTheme.of(context).size),
                  title: Text(context.l10n.patronDonate),
                  subtitle: Text(context.l10n.patronBecomePatron),
                  enabled: isOnline,
                  onTap: () {
                    launchUrl(Uri.parse('https://lichess.org/patron'));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: Text(context.l10n.about),
                  onTap: () {
                    Navigator.of(
                      context,
                      rootNavigator: true,
                    ).push(AboutScreen.buildRoute(context));
                  },
                ),
              ],
            ),
          Padding(
            padding: Styles.bodySectionPadding,
            child: LichessMessage(style: TextTheme.of(context).bodyMedium),
          ),
        ],
      ),
    );
  }
}

class _AccountSection extends ConsumerWidget {
  const _AccountSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOnline = ref.watch(onlineStatusProvider).value ?? false;
    final account = ref.watch(accountProvider);
    final authUser = ref.watch(authControllerProvider);
    final kidMode = account.value?.kid ?? false;
    final unreadMessages = ref.watch(unreadMessagesProvider).value?.unread ?? 0;
    final signOutState = ref.watch(signOutMutation);
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    final user = authUser?.user;

    return ListSection(
      header: user != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [UserAvatar(user, radius: 10), const SizedBox(width: 8), Text(user.name)],
            )
          : null,
      hasLeading: true,
      children: [
        if (user != null) ...[
          ListTile(
            leading: const Icon(Icons.person_outlined),
            title: Text(context.l10n.profile),
            trailing: isIOS ? const CupertinoListTileChevron() : null,
            enabled: isOnline,
            onTap: () {
              ref.invalidate(accountProvider);
              Navigator.of(context, rootNavigator: true).push(ProfileScreen.buildRoute(context));
            },
          ),
          if (!kidMode)
            ListTile(
              leading: Badge.count(
                isLabelVisible: unreadMessages > 0,
                count: unreadMessages,
                child: const Icon(Icons.mail_outline),
              ),
              title: Text(context.l10n.inbox),
              trailing: isIOS ? const CupertinoListTileChevron() : null,
              enabled: isOnline,
              onTap: () {
                Navigator.of(context, rootNavigator: true).push(ContactsScreen.buildRoute(context));
              },
            ),
        ],
        ListTile(
          leading: const Icon(Icons.settings_outlined),
          title: Text(context.l10n.settingsSettings),
          trailing: isIOS ? const CupertinoListTileChevron() : null,
          onTap: () {
            Navigator.of(context, rootNavigator: true).push(SettingsScreen.buildRoute(context));
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
    }
    return showDialog<void>(
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
