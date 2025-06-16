import 'package:dartchess/dartchess.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/network/connectivity.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/tab_scaffold.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/account/account_drawer.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_screen.dart';
import 'package:lichess_mobile/src/view/board_editor/board_editor_screen.dart';
import 'package:lichess_mobile/src/view/clock/clock_tool_screen.dart';
import 'package:lichess_mobile/src/view/more/load_position_screen.dart';
import 'package:lichess_mobile/src/view/opening_explorer/opening_explorer_screen.dart';
import 'package:lichess_mobile/src/view/relation/friend_screen.dart';
import 'package:lichess_mobile/src/view/user/player_screen.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/misc.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';
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
          leading: const AccountDrawerIconButton(),
        ),
        drawer: const AccountDrawer(),
        body: const _Body(),
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOnline = ref.watch(connectivityChangesProvider).valueOrNull?.isOnline ?? false;
    final session = ref.watch(authSessionProvider);

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
                title: Text(context.l10n.loadPosition),
                onTap: () => Navigator.of(context).push(LoadPositionScreen.buildRoute(context)),
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
                    const AnalysisOptions(
                      orientation: Side.white,
                      standalone: (
                        pgn: '',
                        isComputerAnalysisAllowed: true,
                        variant: Variant.standard,
                      ),
                    ),
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
                    const AnalysisOptions(
                      orientation: Side.white,
                      standalone: (
                        pgn: '',
                        isComputerAnalysisAllowed: false,
                        variant: Variant.standard,
                      ),
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
                onTap: () => Navigator.of(
                  context,
                  rootNavigator: true,
                ).push(BoardEditorScreen.buildRoute(context)),
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
              if (session != null)
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
          if (Theme.of(context).platform == TargetPlatform.android)
            ListSection(
              hasLeading: true,
              children: [
                ListTile(
                  leading: Icon(
                    LichessIcons.patron,
                    semanticLabel: context.l10n.patronLichessPatron,
                  ),
                  title: Text(context.l10n.patronDonate),
                  trailing: Theme.of(context).platform == TargetPlatform.iOS
                      ? const CupertinoListTileChevron()
                      : null,
                  enabled: isOnline,
                  onTap: () {
                    launchUrl(Uri.parse('https://lichess.org/patron'));
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
