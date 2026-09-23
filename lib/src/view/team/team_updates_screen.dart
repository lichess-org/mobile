import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/team/team.dart';
import 'package:lichess_mobile/src/model/team/team_providers.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/lichess_assets.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/team/team_channel_screen.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/haptic_refresh_indicator.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/misc.dart';
import 'package:lichess_mobile/src/widgets/network_image.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/team.dart';
import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';

class const TeamUpdatesScreen({super.key}) extends ConsumerWidget {
  static Route<dynamic> buildRoute() {
    return buildScreenRoute(screen: const TeamUpdatesScreen());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAsync = ref.watch(teamUpdatesProvider);

    return PlatformScaffold(
      appBar: PlatformAppBar(title: Text(context.l10n.teamTeamUpdates)),
      body: switch (stateAsync) {
        AsyncData(:final value) => _ChannelsList(teams: value.byTeam),
        AsyncError() => FullScreenRetryRequest(onRetry: () => ref.refresh(teamUpdatesProvider)),
        _ => const CenterLoadingIndicator(),
      },
    );
  }
}

class const _ChannelsList({required final IList<TeamUpdatesByTeam> teams}) extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (teams.isEmpty) {
      return HapticRefreshIndicator(
        onRefresh: () => ref.refresh(teamUpdatesProvider.future),
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Center(
                child: Padding(
                  padding: Styles.bodyPadding,
                  child: Column(
                    mainAxisSize: .min,
                    children: [
                      Icon(Icons.groups_outlined, size: 64, color: textShade(context, 0.4)),
                      const SizedBox(height: 16),
                      Text('No team updates yet', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Text(
                        'Updates from teams you join will appear here.',
                        style: TextStyle(color: textShade(context, 0.6)),
                        textAlign: .center,
                      ),
                      const SizedBox(height: 16),
                      TextButton.icon(
                        onPressed: () => launchUrl(lichessUri('/team/all')),
                        icon: const OpenInNewIcon(),
                        label: const Text('Join teams'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    return HapticRefreshIndicator(
      onRefresh: () => ref.refresh(teamUpdatesProvider.future),
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        separatorBuilder: (context, index) => isIOS
            ? const PlatformDivider(
                height: 1,
                cupertinoHasLeading: true,
                cupertinoLeadingIndent: 56,
              )
            : const SizedBox.shrink(),
        itemCount: teams.length,
        itemBuilder: (context, index) {
          final entry = teams[index];
          final hasUnread = entry.unread > 0;

          return ListTile(
            contentPadding: Theme.of(context).listTileTheme.contentPadding
                ?.add(const EdgeInsets.symmetric(vertical: 4.0)),
            leading: entry.team.flair != null
                ? HttpNetworkImageWidget(
                    lichessFlairSrc(entry.team.flair!),
                    width: 28,
                    height: 28,
                    errorBuilder: (_, _, _) => const Icon(Icons.groups_outlined),
                  )
                : const Icon(Icons.groups_outlined),
            title: TeamFullNameWidget(team: entry.team, showFlair: false),
            subtitle: Text(relativeDate(context.l10n, entry.last)),
            trailing: isIOS
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (hasUnread) ...[
                        Badge.count(count: entry.unread),
                        const SizedBox(width: 8),
                      ],
                      const CupertinoListTileChevron(),
                    ],
                  )
                : hasUnread
                ? Badge.count(count: entry.unread)
                : null,
            onTap: () async {
              await Navigator.of(
                context,
                rootNavigator: true,
              ).push(TeamChannelScreen.buildRoute(teamId: entry.team.id, initialTeam: entry.team));
              ref.invalidate(teamUpdatesProvider);
            },
          );
        },
      ),
    );
  }
}
