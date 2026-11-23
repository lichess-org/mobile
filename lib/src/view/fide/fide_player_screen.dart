import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_federation.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/fide/fide_player.dart';
import 'package:lichess_mobile/src/model/fide/fide_providers.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/utils/share.dart';
import 'package:lichess_mobile/src/view/user/rating_history_chart.dart';
import 'package:lichess_mobile/src/view/user/user_or_profile_screen.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/network_image.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/stat_card.dart';
import 'package:lichess_mobile/src/widgets/user.dart';
import 'package:material_ui/material_ui.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

/// A FIDE player's page, like lichess.org/fide/{id}/{name}: photo, federation, age, ratings and
/// their history, and the lichess account the player linked.
class const FidePlayerScreen(
  final FideId id, {

  /// The player as a list showed it, to show its name while the page loads.
  final FidePlayer? player,
  super.key,
}) extends ConsumerWidget {
  static Route<dynamic> buildRoute(FideId id, {FidePlayer? player}) {
    return buildScreenRoute(screen: FidePlayerScreen(id, player: player));
  }

  /// The perf whose label and icon stand for a FIDE time control in the rating chart.
  static Perf _perfOf(BroadcastFideTC tc) => switch (tc) {
    .standard => .classical,
    .rapid => .rapid,
    .blitz => .blitz,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncPlayer = ref.watch(fidePlayerProvider(id));
    final isLoggedIn = ref.watch(isLoggedInProvider);
    final displayPlayer = asyncPlayer.value?.player ?? player;
    final following = displayPlayer != null
        ? ref.watch(fideFollowingProvider.select((overrides) => overrides.get(id))) ??
              displayPlayer.following
        : null;

    return PlatformScaffold(
      appBar: PlatformAppBar(
        // A long title, next to the actions.
        centerTitle: false,
        title: displayPlayer != null
            ? Text.rich(
                TextSpan(
                  children: [
                    if (displayPlayer.title != null)
                      TextSpan(
                        text: '${displayPlayer.title} ',
                        style: TextStyle(
                          color: context.lichessColors.brag,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    TextSpan(text: displayPlayer.name),
                  ],
                ),
                overflow: TextOverflow.ellipsis,
              )
            : const SizedBox.shrink(),
        actions: [
          // Only the player's page knows the follow status: a list may predate a follow from
          // lichess.org.
          if (isLoggedIn && following != null && asyncPlayer.hasValue)
            SemanticIconButton(
              icon: Icon(following ? Icons.star : Icons.star_border),
              semanticsLabel: following ? context.l10n.unfollow : context.l10n.follow,
              onPressed: () async {
                try {
                  await ref.read(fideFollowingProvider.notifier).setFollowing(id, !following);
                } catch (_) {
                  if (context.mounted) {
                    showSnackBar(
                      context,
                      'Could not update the follow status',
                      type: SnackBarType.error,
                    );
                  }
                }
              },
            ),
          if (displayPlayer != null)
            SemanticIconButton(
              icon: const PlatformShareIcon(),
              semanticsLabel: context.l10n.mobileShare,
              onPressed: () => launchShareDialog(
                context,
                ShareParams(uri: lichessUri('/fide/$id/${displayPlayer.slug}')),
              ),
            ),
        ],
      ),
      body: switch (asyncPlayer) {
        AsyncData(value: (:final player, :final user, :final ratingHistory)) => ListView(
          padding: Styles.bodyPadding,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (player.photo case final photo?) ...[
                  SizedBox(
                    width: MediaQuery.widthOf(context) / 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 4.0,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: HttpNetworkImageWidget(photo.mediumUrl),
                        ),
                        if (photo.credit case final credit?)
                          Text(
                            'Credit: $credit',
                            style: TextStyle(
                              fontSize: 11,
                              color: textShade(context, Styles.subtitleOpacity),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
                Expanded(
                  child: Table(
                    columnWidths: const {0: IntrinsicColumnWidth(), 1: FlexColumnWidth()},
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      if (player.federation case final federation?)
                        TableRow(
                          children: [
                            _InfoLabel(context.l10n.broadcastFederation),
                            Row(
                              children: [
                                Image.asset(federation.flagAsset, height: 12),
                                const SizedBox(width: 5),
                                Flexible(child: Text(federation.name)),
                              ],
                            ),
                          ],
                        ),
                      TableRow(
                        children: [
                          _InfoLabel(context.l10n.broadcastFideProfile),
                          GestureDetector(
                            onTap: () =>
                                launchUrl(Uri.https('ratings.fide.com', '/profile/${player.id}')),
                            child: Text(
                              player.id.toString(),
                              style: TextStyle(color: ColorScheme.of(context).primary),
                            ),
                          ),
                        ],
                      ),
                      if (player.age case final age?)
                        TableRow(
                          children: [_InfoLabel(context.l10n.broadcastAge), Text(age.toString())],
                        ),
                      if (user != null)
                        TableRow(
                          children: [
                            const _InfoLabel('Lichess'),
                            GestureDetector(
                              onTap: () =>
                                  Navigator.of(context).push(UserOrProfileScreen.buildRoute(user)),
                              child: UserFullNameWidget(user: user),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            StatCardRow([
              for (final tc in BroadcastFideTC.values)
                StatCard(
                  tc.i18nName(context),
                  value: player.ratings.get(tc)?.toString() ?? context.l10n.broadcastUnrated,
                ),
            ]),
            if (ratingHistory.isNotEmpty) ...[
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Builder(
                    builder: (context) {
                      final colors = Styles.chartColors(context, ratingHistory.length);
                      return RatingHistoryChart(
                        IList([
                          for (final (index, MapEntry(key: tc, value: points))
                              in ratingHistory.entries.indexed)
                            RatingHistorySeries(
                              perf: _perfOf(tc),
                              points: points,
                              color: colors[index],
                              lineStyle: RatingHistoryLineStyle.values[index],
                            ),
                        ]),
                        alwaysShowLegend: true,
                      );
                    },
                  ),
                ),
              ),
            ],
          ],
        ),
        AsyncError() => FullScreenRetryRequest(
          onRetry: () => ref.invalidate(fidePlayerProvider(id)),
        ),
        _ => const Center(child: CircularProgressIndicator.adaptive()),
      },
    );
  }
}

class const _InfoLabel(final String label) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0, top: 6.0, bottom: 6.0),
      child: Text(label, style: TextStyle(color: textShade(context, Styles.subtitleOpacity))),
    );
  }
}
