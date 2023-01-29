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
import 'package:lichess_mobile/src/features/auth/ui/auth_actions_notifier.dart';
import 'package:lichess_mobile/src/features/game/data/game_repository.dart';
import 'package:lichess_mobile/src/features/game/model/game.dart';
import 'package:lichess_mobile/src/features/game/ui/board/archived_game_screen.dart';
import 'package:lichess_mobile/src/features/settings/ui/settings_screen.dart';
import 'package:lichess_mobile/src/features/user/model/user.dart';
import 'package:lichess_mobile/src/features/user/ui/perf_stats_screen.dart';
import 'package:lichess_mobile/src/utils/duration.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/utils/style.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/user.dart';

import '../../auth/data/auth_repository.dart';

final recentGamesProvider = FutureProvider.autoDispose
    .family<List<ArchivedGameData>, String>((ref, userName) {
  final repo = ref.watch(gameRepositoryProvider);
  return Result.release(repo.getUserGames(userName));
});

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _androidRefreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }

  Widget _buildAndroid(BuildContext context) {
    final authState = ref.watch(authStateChangesProvider);
    final authActionsAsync = ref.watch(authActionsProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.profile),
        actions: [
          IconButton(
            tooltip: context.l10n.settings,
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.of(context).push<void>(
              MaterialPageRoute(
                builder: (context) => const SettingsScreen(),
              ),
            ),
          ),
        ],
      ),
      body: authState.maybeWhen(
          data: (account) {
            return account != null
                ? RefreshIndicator(
                    key: _androidRefreshKey,
                    onRefresh: () => _refreshData(account),
                    child: ListView(
                      padding: kBodyPadding,
                      children: _buildList(context, account),
                    ),
                  )
                : Center(
                    child: FatButton(
                        semanticsLabel: context.l10n.signIn,
                        onPressed: authActionsAsync.isLoading
                            ? null
                            : () =>
                                ref.read(authActionsProvider.notifier).signIn(),
                        child: Text(context.l10n.signIn)));
          },
          orElse: () => const Center(child: CircularProgressIndicator())),
    );
  }

  Widget _buildIos(BuildContext context) {
    final authState = ref.watch(authStateChangesProvider);
    final authActionsAsync = ref.watch(authActionsProvider);
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: Text(context.l10n.profile),
            trailing: CupertinoIconButton(
              semanticsLabel: context.l10n.settings,
              onPressed: () => Navigator.of(context).push<void>(
                CupertinoPageRoute(
                  title: context.l10n.settings,
                  builder: (context) => const SettingsScreen(),
                ),
              ),
              icon: const Icon(Icons.settings),
            ),
          ),
          ...authState.maybeWhen(
            data: (account) {
              return [
                if (account != null)
                  CupertinoSliverRefreshControl(
                    onRefresh: () => _refreshData(account),
                  ),
                if (account != null)
                  SliverSafeArea(
                    top: false,
                    sliver: SliverPadding(
                      padding: kBodyPadding,
                      sliver: SliverList(
                        delegate: SliverChildListDelegate(
                          _buildList(context, account),
                        ),
                      ),
                    ),
                  )
                else
                  SliverFillRemaining(
                    child: Center(
                        child: FatButton(
                            semanticsLabel: context.l10n.signIn,
                            onPressed: authActionsAsync.isLoading
                                ? null
                                : () => ref
                                    .read(authActionsProvider.notifier)
                                    .signIn(),
                            child: Text(context.l10n.signIn))),
                  ),
              ];
            },
            orElse: () => const [
              SliverFillRemaining(
                child: Center(child: CircularProgressIndicator.adaptive()),
              )
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildList(BuildContext context, User account) {
    return [
      ListTile(
        leading: account.patron == true
            ? const Icon(LichessIcons.patron, size: 40)
            : null,
        title: Text(
          account.username,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        subtitle: account.profile?.fullName != null
            ? Text(account.profile!.fullName!)
            : null,
        contentPadding: const EdgeInsets.symmetric(vertical: 10),
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (account.profile != null)
            Location(profile: account.profile!)
          else
            kEmptyWidget,
          const SizedBox(height: 5),
          Text(
              '${context.l10n.memberSince} ${DateFormat.yMMMMd().format(account.createdAt)}'),
          const SizedBox(height: 5),
          Text(context.l10n.lastSeenActive(timeago.format(account.seenAt))),
          const SizedBox(height: 5),
          if (account.playTime != null)
            Text(context.l10n.tpTimeSpentPlaying(account.playTime!.total
                .toDaysHoursMinutes(AppLocalizations.of(context))))
          else
            kEmptyWidget,
        ],
      ),
      const SizedBox(height: 20),
      PerfCards(account: account),
      const SizedBox(height: 20),
      // TODO translate
      const Text('Recent games', style: kSectionTitle),
      RecentGames(account: account),
    ];
  }

  // TODO also refresh user account data for perfs
  Future<void> _refreshData(User account) {
    return ref.refresh(recentGamesProvider(account.id).future);
  }
}

class PerfCards extends StatelessWidget {
  const PerfCards({required this.account, super.key});

  final User account;

  @override
  Widget build(BuildContext context) {
    final List<Perf> userPerfs = Perf.values.where((element) {
      final p = account.perfs[element];
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
          final userPerf = account.perfs[perf]!;
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
                            .perfStats('${account.username} ${perf.title}'),
                        builder: (context) => PerfStatsScreen(
                            username: account.username,
                            perf: perf,
                            loggedInUser: account)),
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
                          Text(
                              '${userPerf.rating}${userPerf.provisional == true || userPerf.ratingDeviation > kProvisionalDeviation ? '?' : ''}',
                              style: kBold),
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
                            Text(userPerf.progression.abs().toString(),
                                style: TextStyle(
                                    color: userPerf.progression > 0
                                        ? LichessColors.good
                                        : LichessColors.red,
                                    fontSize: 12)),
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
  const RecentGames({required this.account, super.key});

  final User account;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentGames = ref.watch(recentGamesProvider(account.id));

    return recentGames.when(
      data: (data) {
        return Column(
          children: ListTile.divideTiles(
              color: dividerColor(context),
              context: context,
              tiles: data.map((game) {
                final mySide =
                    game.white.id == account.id ? Side.white : Side.black;
                final opponent =
                    game.white.id == account.id ? game.black : game.white;
                final opponentName = opponent.name == 'Stockfish'
                    ? context.l10n.aiNameLevelAiLevel(
                        opponent.name, opponent.aiLevel.toString())
                    : opponent.name;

                return ListTile(
                  onTap: () {
                    Navigator.of(context, rootNavigator: true).push<void>(
                      MaterialPageRoute(
                        builder: (context) => ArchivedGameScreen(
                            gameData: game, account: account),
                      ),
                    );
                  },
                  leading: Icon(game.perf.icon),
                  title: ListTileUser(
                      user:
                          LightUser(name: opponentName, title: opponent.title)),
                  subtitle: Text(timeago.format(game.lastMoveAt)),
                  trailing: game.winner == mySide
                      ? const Icon(CupertinoIcons.plus_square_fill,
                          color: LichessColors.good)
                      : const Icon(CupertinoIcons.minus_square_fill,
                          color: LichessColors.red),
                );
              })).toList(growable: false),
        );
      },
      error: (error, stackTrace) {
        debugPrint(
            'SEVERE: [ProfileScreen] could not load user games; $error\n$stackTrace');
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
    return Row(children: [
      if (profile.country != null)
        CachedNetworkImage(
          imageUrl: lichessFlagSrc(profile.country!),
          errorWidget: (_, __, ___) => kEmptyWidget,
        )
      else
        kEmptyWidget,
      const SizedBox(width: 10),
      Text(profile.location ?? ''),
    ]);
  }
}

String lichessFlagSrc(String country) {
  return '$kLichessHost/assets/images/flags/$country.png';
}
