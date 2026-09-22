import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/team/team.dart';
import 'package:lichess_mobile/src/model/team/team_providers.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/user/user_or_profile_screen.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/haptic_refresh_indicator.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/team.dart';
import 'package:lichess_mobile/src/widgets/user.dart';
import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';

class const TeamChannelScreen({
  super.key,
  required final TeamId teamId,
  final LightTeam? initialTeam,
}) extends ConsumerWidget {
  static Route<dynamic> buildRoute({required TeamId teamId, LightTeam? initialTeam}) {
    return buildScreenRoute(
      screen: TeamChannelScreen(teamId: teamId, initialTeam: initialTeam),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAsync = ref.watch(teamChannelPaginatorProvider(teamId));
    final currentTeam = stateAsync.value?.currentTeam ?? initialTeam;
    final isSubscribed = stateAsync.value?.isSubscribed;

    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: currentTeam != null
            ? TeamFullNameWidget(team: currentTeam, maxLines: 2)
            : Text(teamId.value),
        actions: [
          if (isSubscribed != null)
            SemanticIconButton(
              icon: Icon(isSubscribed ? Icons.notifications : Icons.notifications_none),
              semanticsLabel: isSubscribed ? context.l10n.unsubscribe : context.l10n.subscribe,
              onPressed: () async {
                try {
                  await ref
                      .read(teamChannelPaginatorProvider(teamId).notifier)
                      .toggleSubscription();
                } catch (_) {
                  if (context.mounted) {
                    showSnackBar(
                      context,
                      'Could not update the subscription',
                      type: SnackBarType.error,
                    );
                  }
                }
              },
            ),
        ],
      ),
      body: switch (stateAsync) {
        AsyncData(:final value) => _ChannelMessagesBody(state: value, teamId: teamId),
        AsyncError() => FullScreenRetryRequest(
          onRetry: () {
            ref.invalidate(teamUpdatesOfTeamProvider);
            return ref.refresh(teamChannelPaginatorProvider(teamId));
          },
        ),
        _ => const CenterLoadingIndicator(),
      },
    );
  }
}

class const _ChannelMessagesBody({
  required final TeamChannelState state,
  required final TeamId teamId,
}) extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (state.updates.isEmpty) {
      return HapticRefreshIndicator(
        onRefresh: () {
          ref.invalidate(teamUpdatesOfTeamProvider);
          return ref.refresh(teamChannelPaginatorProvider(teamId).future);
        },
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
                      Icon(Icons.forum_outlined, size: 64, color: textShade(context, 0.4)),
                      const SizedBox(height: 16),
                      Text(
                        'No updates yet in this channel',
                        style: Theme.of(context).textTheme.titleMedium,
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

    final hasMorePages = state.hasMore && state.nextPage != null;
    final notifier = ref.read(teamChannelPaginatorProvider(teamId).notifier);

    return HapticRefreshIndicator(
      onRefresh: () {
        ref.invalidate(teamUpdatesOfTeamProvider);
        return ref.refresh(teamChannelPaginatorProvider(teamId).future);
      },
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: state.updates.length + (hasMorePages ? 1 : 0),
        itemBuilder: (context, index) {
          if (hasMorePages && index == state.updates.length) {
            return TeamUpdateNextPageTile(notifier.next);
          }

          final item = state.updates[index];
          return _TeamUpdateCard(item: item);
        },
      ),
    );
  }
}

class const TeamUpdateNextPageTile(final Future<void> Function() nextPageFunction, {super.key})
    extends StatefulWidget {
  @override
  State<TeamUpdateNextPageTile> createState() => _TeamUpdateNextPageTileState();
}

class _TeamUpdateNextPageTileState() extends State<TeamUpdateNextPageTile> {
  late Future<void> nextPageFuture;

  @override
  void initState() {
    super.initState();
    nextPageFuture = widget.nextPageFunction();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: nextPageFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Padding(
            padding: Styles.verticalBodyPadding,
            child: Center(
              child: TextButton(
                onPressed: () {
                  setState(() {
                    nextPageFuture = widget.nextPageFunction();
                  });
                },
                child: Text(context.l10n.retry),
              ),
            ),
          );
        }

        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Center(child: CircularProgressIndicator.adaptive()),
        );
      },
    );
  }
}

class const _TeamUpdateCard({required final TeamUpdateItem item}) extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: const RoundedRectangleBorder(borderRadius: Styles.cardBorderRadius),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Row(
              children: [
                Expanded(
                  child: UserFullNameWidget(
                    user: item.msg.sender,
                    style: const TextStyle(fontSize: 15, fontWeight: .bold),
                    onTap: () {
                      Navigator.of(context).push(UserOrProfileScreen.buildRoute(item.msg.sender));
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  relativeDate(context.l10n, item.msg.date),
                  style: TextStyle(fontSize: 15, color: textShade(context, 0.8)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            MarkdownBody(
              data: item.msg.text,
              softLineBreak: true,
              onTapLink: (text, url, title) {
                if (url == null) return;
                launchUrl(Uri.https('lichess.org').resolve(url));
              },
            ),
          ],
        ),
      ),
    );
  }
}
