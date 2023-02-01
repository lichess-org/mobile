import 'package:cached_network_image/cached_network_image.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:lichess_mobile/src/common/lichess_colors.dart';
import 'package:lichess_mobile/src/common/lichess_icons.dart';
import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/features/game/data/game_repository.dart';
import 'package:lichess_mobile/src/features/game/model/game.dart';
import 'package:lichess_mobile/src/features/game/ui/board/archived_game_screen.dart';
import 'package:lichess_mobile/src/features/user/data/user_repository.dart';
import 'package:lichess_mobile/src/features/user/model/user.dart';
import 'package:lichess_mobile/src/features/user/ui/perf_stats_screen.dart';
import 'package:lichess_mobile/src/utils/duration.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/utils/style.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/user_widgets.dart';

final recentGamesProvider = FutureProvider.autoDispose
    .family<List<ArchivedGameData>, UserId>((ref, userId) {
  final repo = ref.watch(gameRepositoryProvider);
  return Result.release(repo.getUserGames(userId));
});

final userProvider =
    FutureProvider.autoDispose.family<User, UserId>((ref, userId) {
  final repo = ref.watch(userRepositoryProvider);
  return Result.release(repo.getUser(userId));
});

class UserScreen extends ConsumerWidget {
  const UserScreen({required this.userId, super.key});

  final UserId userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ConsumerPlatformWidget(
      ref: ref,
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }

  Widget _buildAndroid(BuildContext context, WidgetRef ref) {
    final asyncUser = ref.watch(userProvider(userId));
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.profile),
      ),
      body: asyncUser.maybeWhen(
        data: (user) {
          return UserScreenBody(user: user);
        },
        orElse: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildIos(BuildContext context, WidgetRef ref) {
    final asyncUser = ref.watch(userProvider(userId));
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(),
      child: asyncUser.maybeWhen(
        data: (user) => UserScreenBody(user: user),
        orElse: () => const Center(child: CircularProgressIndicator.adaptive()),
      ),
    );
  }
}

class UserScreenBody extends StatelessWidget {
  const UserScreenBody({required this.user, super.key});

  final User user;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: kBodyPadding,
      children: [
        ListTile(
          leading: user.patron == true
              ? const Icon(LichessIcons.patron, size: 40)
              : null,
          title: Text(
            user.username,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          subtitle: user.profile?.fullName != null
              ? Text(user.profile!.fullName!)
              : null,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (user.profile != null)
              Location(profile: user.profile!)
            else
              kEmptyWidget,
            const SizedBox(height: 5),
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
        const SizedBox(height: 20),
        PerfCards(user: user),
        const SizedBox(height: 20),
        // TODO translate
        const Text('Recent games', style: kSectionTitle),
        RecentGames(user: user),
      ],
    );
  }
}

class PerfCards extends StatelessWidget {
  const PerfCards({required this.user, super.key});

  final User user;

  @override
  Widget build(BuildContext context) {
    final List<Perf> userPerfs = Perf.values.where((element) {
      final p = user.perfs[element];
      return p != null &&
          p.numberOfGames > 0 &&
          p.ratingDeviation < kClueLessDeviation;
    }).toList(growable: false);

    return SizedBox(
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
              child: InkWell(
                splashFactory: isPerfWithoutStats
                    ? NoSplash.splashFactory
                    : InkSplash.splashFactory,
                customBorder: kPlatformCardBorder,
                onTap: isPerfWithoutStats
                    ? null
                    : () => pushPlatformRoute(
                          context: context,
                          title: context.l10n
                              .perfStats('${user.username} ${perf.title}'),
                          builder: (context) => PerfStatsScreen(
                            user: user,
                            perf: perf,
                            loggedInUser: user,
                          ),
                        ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
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
                        children: [
                          UserRating(
                            rating: userPerf.rating,
                            deviation: userPerf.ratingDeviation,
                            provisional: userPerf.provisional,
                            style: kBold,
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
                                fontSize: 12,
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
    );
  }
}

class RecentGames extends ConsumerWidget {
  const RecentGames({required this.user, super.key});

  final User user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentGames = ref.watch(recentGamesProvider(user.id));

    return recentGames.when(
      data: (data) {
        return Column(
          children: ListTile.divideTiles(
            color: dividerColor(context),
            context: context,
            tiles: data.map((game) {
              final mySide = game.white.id == user.id ? Side.white : Side.black;
              final opponent =
                  game.white.id == user.id ? game.black : game.white;
              final opponentName = opponent.name == 'Stockfish'
                  ? context.l10n.aiNameLevelAiLevel(
                      opponent.name,
                      opponent.aiLevel.toString(),
                    )
                  : opponent.name;

              return ListTile(
                onTap: () {
                  Navigator.of(context, rootNavigator: true).push<void>(
                    MaterialPageRoute(
                      builder: (context) => ArchivedGameScreen(
                        gameData: game,
                        orientation:
                            user.id == game.white.id ? Side.white : Side.black,
                      ),
                    ),
                  );
                },
                leading: Icon(game.perf.icon),
                title: ListTileUser(
                  userName: opponentName,
                  title: opponent.title,
                  rating: opponent.rating,
                ),
                subtitle: Text(
                  timeago.format(game.lastMoveAt),
                  style: TextStyle(color: textShade(context, 0.7)),
                ),
                trailing: game.winner == mySide
                    ? const Icon(
                        CupertinoIcons.plus_square_fill,
                        color: LichessColors.good,
                      )
                    : const Icon(
                        CupertinoIcons.minus_square_fill,
                        color: LichessColors.red,
                      ),
              );
            }),
          ).toList(growable: false),
        );
      },
      error: (error, stackTrace) {
        debugPrint(
          'SEVERE: [UserScreen] could not load user games; $error\n$stackTrace',
        );
        return const Text('Could not load games.');
      },
      loading: () => const CenterLoadingIndicator(),
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
        Text(profile.location ?? ''),
      ],
    );
  }
}

String lichessFlagSrc(String country) {
  return '$kLichessHost/assets/images/flags/$country.png';
}
