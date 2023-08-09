import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/user/user_repository_providers.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/view/user/perf_stats_screen.dart';
import 'package:lichess_mobile/src/utils/duration.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/player.dart';
import 'package:lichess_mobile/src/view/user/recent_games.dart';

import 'user_activity.dart';
import 'countries.dart';

class UserScreen extends ConsumerWidget {
  const UserScreen({required this.user, super.key});

  final LightUser user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ConsumerPlatformWidget(
      ref: ref,
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }

  Widget _buildAndroid(BuildContext context, WidgetRef ref) {
    final asyncUser = ref.watch(userProvider(id: user.id));
    return Scaffold(
      appBar: AppBar(
        title: PlayerTitle(
          userName: user.name,
          title: user.title,
          isPatron: user.isPatron,
        ),
      ),
      body: asyncUser.when(
        data: (user) {
          return ListView(children: buildUserScreenList(user));
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) {
          return FullScreenRetryRequest(
            onRetry: () => ref.invalidate(userProvider(id: user.id)),
          );
        },
      ),
    );
  }

  Widget _buildIos(BuildContext context, WidgetRef ref) {
    final asyncUser = ref.watch(userProvider(id: user.id));
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: PlayerTitle(
          userName: user.name,
          title: user.title,
          isPatron: user.isPatron,
        ),
      ),
      child: asyncUser.when(
        data: (user) => SafeArea(
          child: ListView(children: buildUserScreenList(user)),
        ),
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
        error: (error, _) {
          return FullScreenRetryRequest(
            onRetry: () => ref.invalidate(userProvider(id: user.id)),
          );
        },
      ),
    );
  }
}

// ignore: avoid-returning-widgets
/// Common content for [UserScreen] and [ProfileScreen].
List<Widget> buildUserScreenList(User user) {
  return [
    _Profile(user: user),
    PerfCards(user: user),
    UserActivityWidget(user: user),
    RecentGames(user: user),
  ];
}

const _userNameStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.w500);

class _Profile extends StatelessWidget {
  const _Profile({
    required this.user,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    final userFullName = user.profile?.fullName != null
        ? Text(
            user.profile!.fullName!,
            style: _userNameStyle,
          )
        : null;

    return Padding(
      padding: Styles.bodySectionPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (userFullName != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: userFullName,
            ),
          if (user.profile?.bio != null)
            Text(
              user.profile!.bio!,
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
          const SizedBox(height: 10),
          if (user.profile != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Location(profile: user.profile!),
            ),
          Text(
            '${context.l10n.memberSince} ${DateFormat.yMMMMd().format(user.createdAt)}',
          ),
          const SizedBox(height: 5),
          Text(context.l10n.lastSeenActive(timeago.format(user.seenAt))),
          const SizedBox(height: 5),
          if (user.playTime != null)
            Text(
              context.l10n.tpTimeSpentPlaying(
                user.playTime!.total
                    .toDaysHoursMinutes(AppLocalizations.of(context)),
              ),
            )
          else
            kEmptyWidget,
        ],
      ),
    );
  }
}

class PerfCards extends StatelessWidget {
  const PerfCards({required this.user, super.key});

  final User user;

  @override
  Widget build(BuildContext context) {
    List<Perf> userPerfs = Perf.values.where((element) {
      final p = user.perfs[element];
      return p != null &&
          p.numberOfGames > 0 &&
          p.ratingDeviation < kClueLessDeviation;
    }).toList(growable: false);

    userPerfs.sort(
      (p1, p2) => user.perfs[p1]!.numberOfGames
          .compareTo(user.perfs[p2]!.numberOfGames),
    );
    userPerfs = userPerfs.reversed.toList();

    if (userPerfs.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: Styles.bodySectionPadding,
      child: SizedBox(
        height: 106,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 3.0),
          scrollDirection: Axis.horizontal,
          itemCount: userPerfs.length,
          itemBuilder: (context, index) {
            final perf = userPerfs[index];
            final userPerf = user.perfs[perf]!;
            final bool isPerfWithoutStats =
                [Perf.puzzle, Perf.storm].contains(perf);
            return SizedBox(
              height: 100,
              width: 100,
              child: PlatformCard(
                child: AdaptiveInkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: isPerfWithoutStats
                      ? null
                      : () => _handlePerfCardTap(context, perf),
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          perf.shortTitle,
                          style: TextStyle(color: textShade(context, 0.7)),
                        ),
                        Icon(perf.icon, color: textShade(context, 0.6)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            PlayerRating(
                              rating: userPerf.rating,
                              deviation: userPerf.ratingDeviation,
                              provisional: userPerf.provisional,
                              style: Styles.bold,
                            ),
                            const SizedBox(width: 3),
                            if (userPerf.progression != 0) ...[
                              Icon(
                                userPerf.progression > 0
                                    ? LichessIcons.arrow_full_upperright
                                    : LichessIcons.arrow_full_lowerright,
                                color: userPerf.progression > 0
                                    ? LichessColors.good
                                    : LichessColors.red,
                                size: 12,
                              ),
                              Text(
                                userPerf.progression.abs().toString(),
                                style: TextStyle(
                                  color: userPerf.progression > 0
                                      ? LichessColors.good
                                      : LichessColors.red,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (context, index) => const SizedBox(width: 10),
        ),
      ),
    );
  }

  void _handlePerfCardTap(BuildContext context, Perf perf) {
    pushPlatformRoute(
      context,
      builder: (context) => PerfStatsScreen(
        user: user,
        perf: perf,
      ),
    );
  }
}

class Location extends StatelessWidget {
  const Location({required this.profile, super.key});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (profile.country != null)
          CachedNetworkImage(
            imageUrl: lichessFlagSrc(profile.country!),
            errorWidget: (_, __, ___) => kEmptyWidget,
          )
        else
          kEmptyWidget,
        const SizedBox(width: 10),
        Text(profile.location ?? countries[profile.country] ?? ''),
      ],
    );
  }
}

String lichessFlagSrc(String country) {
  return '$kLichessHost/assets/images/flags/$country.png';
}
