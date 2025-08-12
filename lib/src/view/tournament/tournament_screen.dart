import 'dart:io';
import 'dart:math';

import 'package:dartchess/dartchess.dart' hide File;
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/game_history.dart';
import 'package:lichess_mobile/src/model/game/game_status.dart';
import 'package:lichess_mobile/src/model/tournament/tournament.dart';
import 'package:lichess_mobile/src/model/tournament/tournament_controller.dart';
import 'package:lichess_mobile/src/model/tournament/tournament_repository.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/tab_scaffold.dart';
import 'package:lichess_mobile/src/theme.dart';
import 'package:lichess_mobile/src/utils/duration.dart';
import 'package:lichess_mobile/src/utils/focus_detector.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/utils/share.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_screen.dart';
import 'package:lichess_mobile/src/view/chat/chat_screen.dart';
import 'package:lichess_mobile/src/view/game/game_screen.dart';
import 'package:lichess_mobile/src/view/user/user_screen.dart';
import 'package:lichess_mobile/src/view/watch/tv_screen.dart';
import 'package:lichess_mobile/src/widgets/board_thumbnail.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/clock.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/misc.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/user_full_name.dart';
import 'package:path_provider/path_provider.dart' show getTemporaryDirectory;
import 'package:share_plus/share_plus.dart';

class TournamentScreen extends ConsumerStatefulWidget {
  const TournamentScreen({required this.id});

  final TournamentId id;

  static const String routeName = '/tournament';

  static Route<void> buildRoute(BuildContext context, TournamentId id) {
    return buildScreenRoute(
      context,
      screen: TournamentScreen(id: id),
      settings: const RouteSettings(name: routeName),
    );
  }

  @override
  ConsumerState<TournamentScreen> createState() => _TournamentScreenState();
}

class _TournamentScreenState extends ConsumerState<TournamentScreen> with RouteAware {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route != null && route is PageRoute) {
      rootNavPageRouteObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    rootNavPageRouteObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPop() {
    if (mounted) {
      final joined = ref.read(tournamentControllerProvider(widget.id)).valueOrNull?.hasJoined;
      if (joined == true) {
        ref.invalidate(myRecentGamesProvider);
        ref.invalidate(accountProvider);
      }
    }
    super.didPop();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      tournamentControllerProvider(widget.id).select((value) => value.valueOrNull?.currentGame),
      (prevGameId, currentGameId) {
        if (prevGameId != currentGameId && currentGameId != null) {
          Navigator.of(
            context,
          ).popUntil((route) => route.settings.name == TournamentScreen.routeName);
          Navigator.of(
            context,
            rootNavigator: true,
          ).push(GameScreen.buildRoute(context, initialGameId: currentGameId));
        }
      },
    );

    return switch (ref.watch(tournamentControllerProvider(widget.id))) {
      AsyncError(:final error) => PlatformScaffold(
        appBar: PlatformAppBar(title: const SizedBox.shrink()),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(child: Text('Could not load tournament: $error')),
        ),
      ),
      AsyncValue(:final value?) => _Body(id: widget.id, state: value),
      _ => PlatformScaffold(
        appBar: PlatformAppBar(title: const SizedBox.shrink()),
        body: const Center(child: CircularProgressIndicator.adaptive()),
      ),
    };
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.id, required this.state});

  final TournamentId id;
  final TournamentState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(authSessionProvider);
    final timeLeft = state.tournament.timeToStart ?? state.tournament.timeToFinish;

    return FocusDetector(
      onFocusRegained: () {
        if (context.mounted) {
          ref.read(tournamentControllerProvider(id).notifier).onFocusRegained();
        }
      },
      child: PlatformScaffold(
        extendBody: Theme.of(context).platform == TargetPlatform.iOS,
        appBar: PlatformAppBar(
          title: _Title(state: state),
          actions: [
            if (state.tournament.isFinished != true)
              SocketPingRatingIcon(socketUri: TournamentController.socketUri(id)),
            if (timeLeft != null)
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (state.tournament.timeToStart != null)
                      Text(context.l10n.startingIn, style: const TextStyle(fontSize: 14)),
                    CountdownClockBuilder(
                      timeLeft: timeLeft.$1,
                      clockUpdatedAt: timeLeft.$2,
                      active: true,
                      tickInterval: const Duration(seconds: 1),
                      builder: (BuildContext context, Duration timeLeft) => Text(
                        '${timeLeft.toHoursMinutesSeconds()} ',
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontFeatures: [FontFeature.tabularFigures()],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        body: Padding(
          padding: Styles.horizontalBodyPadding,
          child: ListView(
            children: [
              Card(
                child: Padding(
                  padding: Styles.bodySectionPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _TournamentInfo(state.tournament),
                      if (state.tournament.verdicts.list.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        _Verdicts(state.tournament.verdicts),
                      ],
                      if (!state.tournament.berserkable) ...[
                        const SizedBox(height: 10),
                        Text.rich(
                          TextSpan(
                            children: [
                              const WidgetSpan(child: Icon(LichessIcons.body_cut, size: 16)),
                              TextSpan(text: ' ${context.l10n.arenaNoBerserkAllowed}'),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _Standing(state),
              const SizedBox(height: 16),
              if (state.tournament.isStarted != true && state.tournament.isFinished != true)
                _TournamentHelp(state: state)
              else if (state.tournament.isFinished == true)
                _TournamentCompleteWidget(state: state)
              else if (state.tournament.featuredGame != null)
                _FeaturedGame(state.tournament.featuredGame!),
              if (session != null && state.joined) const SizedBox(height: 35),
            ],
          ),
        ),
        bottomSheet: session != null && state.joined && state.tournament.isFinished != true
            ? Material(
                child: Container(
                  height: 35,
                  width: double.infinity,
                  color: state.tournament.pairingsClosed
                      ? context.lichessColors.primary
                      : context.lichessColors.good,
                  child: Padding(
                    padding: Styles.horizontalBodyPadding,
                    child: Center(
                      child: Text(
                        state.tournament.pairingsClosed
                            ? context.l10n.arenaTournamentPairingsAreNowClosed
                            : context.l10n.standByX(session.user.name),
                        style: const TextStyle(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink(),
        bottomNavigationBar: _BottomBar(state),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({required this.state});

  final TournamentState state;

  @override
  Widget build(BuildContext context) {
    return AppBarTitleText(state.tournament.meta.fullName, maxLines: 2);
  }
}

class _TournamentHelp extends StatelessWidget {
  const _TournamentHelp({required this.state});

  final TournamentState state;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Styles.bodySectionPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // show a famous chess quote if available
          if (state.tournament.quote != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Theme.of(context).dividerColor, width: 1),
                        bottom: BorderSide(color: Theme.of(context).dividerColor, width: 1),
                      ),
                    ),
                    child: Text(
                      state.tournament.quote!.text,
                      style: const TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '\u2014 ${state.tournament.quote!.author}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          Padding(
            padding: Styles.verticalBodyPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.l10n.arenaIsItRated, style: Styles.sectionTitle),
                const SizedBox(height: 10),
                if (state.tournament.meta.rated)
                  Text(context.l10n.arenaIsRated)
                else
                  Text(context.l10n.arenaIsNotRated),
              ],
            ),
          ),
          Padding(
            padding: Styles.verticalBodyPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.l10n.arenaHowAreScoresCalculated, style: Styles.sectionTitle),
                const SizedBox(height: 10),
                Text(context.l10n.arenaHowAreScoresCalculatedAnswer),
              ],
            ),
          ),
          if (state.tournament.berserkable)
            Padding(
              padding: Styles.verticalBodyPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.l10n.arenaBerserk, style: Styles.sectionTitle),
                  const SizedBox(height: 10),
                  Text(context.l10n.arenaBerserkAnswer),
                ],
              ),
            ),
          Padding(
            padding: Styles.verticalBodyPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.l10n.arenaHowIsTheWinnerDecided, style: Styles.sectionTitle),
                const SizedBox(height: 10),
                Text(context.l10n.arenaHowIsTheWinnerDecidedAnswer),
              ],
            ),
          ),
          Padding(
            padding: Styles.verticalBodyPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.l10n.arenaHowDoesPairingWork, style: Styles.sectionTitle),
                const SizedBox(height: 10),
                Text(context.l10n.arenaHowDoesPairingWorkAnswer),
              ],
            ),
          ),
          Padding(
            padding: Styles.verticalBodyPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.l10n.arenaHowDoesItEnd, style: Styles.sectionTitle),
                const SizedBox(height: 10),
                Text(context.l10n.arenaHowDoesItEndAnswer),
              ],
            ),
          ),
          Padding(
            padding: Styles.verticalBodyPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.l10n.arenaOtherRules, style: Styles.sectionTitle),
                const SizedBox(height: 10),
                Text(context.l10n.arenaThereIsACountdown),
                const SizedBox(height: 6),
                Text(context.l10n.arenaDrawingWithinNbMoves(10)),
                const SizedBox(height: 6),
                Text(context.l10n.arenaDrawStreakStandard('30')),
                const SizedBox(height: 6),
                Text(context.l10n.arenaDrawStreakVariants),
                DataTable(
                  dataRowMinHeight: 40,
                  dataRowMaxHeight: 70,
                  columns: [
                    DataColumn(label: Text(context.l10n.arenaVariant)),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          context.l10n.arenaMinimumGameLength,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                  rows: const [
                    DataRow(
                      cells: [DataCell(Text('Standard, Chess960, Horde')), DataCell(Text('30'))],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('Antichess, Crazyhouse, King of the Hill')),
                        DataCell(Text('20')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('Three-check, Atomic, Racing Kings')),
                        DataCell(Text('10')),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Standing extends ConsumerWidget {
  const _Standing(this.state);

  final TournamentState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final standing = state.tournament.standing;
    if (standing == null) {
      return const SizedBox.shrink();
    }
    return Card(
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: [
          _StandingControls(state: state),
          ...List.generate(
            10,
            (i) => standing.players.getOrNull(i),
          ).nonNulls.map((player) => _StandingPlayer(player: player)),
        ],
      ),
    );
  }
}

class _StandingPlayer extends ConsumerWidget {
  const _StandingPlayer({required this.player});

  final StandingPlayer player;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tournamentId = context.findAncestorWidgetOfExactType<_Body>()?.id;
    return ListTile(
      contentPadding: const EdgeInsetsDirectional.only(start: 16.0, end: 16.0),
      visualDensity: VisualDensity.compact,
      tileColor: player.rank.isEven ? context.lichessTheme.rowEven : context.lichessTheme.rowOdd,
      leading: player.withdraw
          ? Icon(Icons.pause, color: textShade(context, 0.3), size: 20)
          : Text(player.rank.toString().padLeft(2).padRight(3), textAlign: TextAlign.center),
      title: UserFullNameWidget(
        user: player.user,
        rating: player.rating,
        provisional: player.provisional,
        shouldShowOnline: false,
      ),
      subtitle: player.sheet.scores.isNotEmpty ? _Scores(player.sheet.scores) : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Visibility.maintain(
            visible: player.sheet.fire,
            child: const Icon(LichessIcons.blitz, size: 15, color: LichessColors.brag),
          ),
          Text(
            player.score.toString().padLeft(2),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ],
      ),
      onTap: tournamentId != null
          ? () {
              _showPlayerDetails(context, ref, tournamentId, player.user.id);
            }
          : null,
    );
  }
}

class _Scores extends StatelessWidget {
  const _Scores(this.scores);

  final IList<int> scores;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: scores.reversed
          .map(
            (score) => Text(
              softWrap: false,
              '$score',
              style: TextStyle(
                color: score >= 4
                    ? LichessColors.brag
                    : score > 1
                    ? LichessColors.good
                    : textShade(context, 0.5),
                letterSpacing: 0.5,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          )
          .toList(growable: false),
    );
  }
}

class _StandingControls extends ConsumerWidget {
  const _StandingControls({required this.state});

  final TournamentState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        SemanticIconButton(
          onPressed: state.hasPreviousPage
              ? ref.read(tournamentControllerProvider(state.id).notifier).loadPreviousStandingsPage
              : null,
          onLongPress: state.hasPreviousPage
              ? ref.read(tournamentControllerProvider(state.id).notifier).loadFirstStandingsPage
              : null,
          // TODO l10n
          semanticsLabel: 'Previous',
          icon: const Icon(Icons.chevron_left),
        ),
        Expanded(
          child: Text(
            '${state.firstRankOfPage}-${min(state.firstRankOfPage + kStandingsPageSize - 1, state.tournament.nbPlayers)} / ${state.tournament.nbPlayers}',
            style: const TextStyle(fontFeatures: [FontFeature.tabularFigures()]),
            textAlign: TextAlign.center,
          ),
        ),
        SemanticIconButton(
          onPressed: state.hasNextPage
              ? ref.read(tournamentControllerProvider(state.id).notifier).loadNextStandingsPage
              : null,
          onLongPress: state.hasNextPage
              ? ref.read(tournamentControllerProvider(state.id).notifier).loadLastStandingsPage
              : null,
          semanticsLabel: context.l10n.studyNext,
          icon: const Icon(Icons.chevron_right),
        ),
        if (state.tournament.me != null)
          SemanticIconButton(
            onPressed: ref.read(tournamentControllerProvider(state.id).notifier).jumpToMyPage,
            icon: const Icon(Icons.person_pin_circle_outlined),
            // TODO l10n
            semanticsLabel: 'Jump to my page',
          ),
      ],
    );
  }
}

class _TournamentInfo extends StatelessWidget {
  const _TournamentInfo(this.tournament);

  final Tournament tournament;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(tournament.meta.perf.icon, size: 36),
        const SizedBox(width: 10),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${tournament.meta.timeIncrement.display} • ${tournament.meta.perf.title} • ${context.l10n.nbMinutes(tournament.meta.duration.inMinutes)}',
              ),
              Text(
                '${tournament.meta.rated ? context.l10n.rated : context.l10n.casual} • ${context.l10n.arenaArena}',
              ),
              const SizedBox(height: 5),
            ],
          ),
        ),
      ],
    );
  }
}

class _Verdicts extends ConsumerWidget {
  const _Verdicts(this.verdicts);

  final Verdicts verdicts;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoggedIn = ref.watch(authSessionProvider)?.user.id != null;

    if (verdicts.list.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      children: [
        Icon(
          isLoggedIn && verdicts.accepted ? Icons.check : Icons.lock,
          color: isLoggedIn
              ? verdicts.accepted
                    ? context.lichessColors.good
                    : context.lichessColors.error
              : null,
          size: 30.0,
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final verdict in verdicts.list)
                Text(
                  verdict.condition,
                  style: TextStyle(
                    color: isLoggedIn
                        ? verdict.ok
                              ? context.lichessColors.good
                              : context.lichessColors.error
                        : null,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FeaturedGame extends ConsumerWidget {
  const _FeaturedGame(this.featuredGame);

  final FeaturedGame featuredGame;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boardSize = constraints.maxWidth;

        return BoardThumbnail(
          size: boardSize,
          orientation: featuredGame.orientation,
          fen: featuredGame.fen,
          header: _FeaturedGamePlayer(game: featuredGame, side: featuredGame.orientation.opposite),
          footer: _FeaturedGamePlayer(game: featuredGame, side: featuredGame.orientation),
          lastMove: featuredGame.lastMove,
        );
      },
    );
  }
}

class _FeaturedGamePlayer extends StatelessWidget {
  const _FeaturedGamePlayer({required this.game, required this.side});

  final FeaturedGame game;
  final Side side;

  @override
  Widget build(BuildContext context) {
    final player = game.playerOf(side);

    final isOurTurn =
        game.fen.endsWith(' w') && side == Side.white ||
        game.fen.endsWith(' b') && side == Side.black;

    // See https://github.com/lichess-org/lila/blob/974e1fbd9af0a9d125cec3008d4e72ec09834cf3/ui/lib/src/clock.ts#L13
    final clockActive =
        isOurTurn &&
        (side == Side.white
            ? !game.fen.contains('PPPPPPPP/RNBQKBNR')
            : !game.fen.startsWith('rnbqkbnr/pppppppp'));

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Text('#${player.rank} ', style: const TextStyle(fontWeight: FontWeight.bold)),
                Flexible(
                  child: UserFullNameWidget(
                    user: player.user,
                    showPatron: false,
                    rating: player.rating,
                    provisional: player.provisional,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 5),
          if (game.active)
            CountdownClockBuilder(
              timeLeft: game.clockOf(side)!,
              active: clockActive,
              builder: (context, timeLeft) => Text(
                timeLeft.toHoursMinutesSeconds(),
                style: TextStyle(
                  color: clockActive ? Colors.orange[900] : null,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            )
          else
            Text(
              game.winner == side
                  ? '1'
                  : game.winner == side.opposite
                  ? '0'
                  : '½',
              style: const TextStyle().copyWith(fontWeight: FontWeight.bold),
            ),
        ],
      ),
    );
  }
}

class _TournamentCompleteWidget extends ConsumerWidget {
  const _TournamentCompleteWidget({required this.state});

  final TournamentState state;

  static const _headerStyle = TextStyle();
  static const _valueStyle = TextStyle(fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(authSessionProvider);

    final stats = state.tournament.stats;
    if (stats == null) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: Styles.bodySectionPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.l10n.tournamentComplete, style: Styles.sectionTitle),
            const SizedBox(height: 10),
            DataTable(
              headingRowHeight: 0,
              dividerThickness: 0,
              horizontalMargin: 0,
              columns: const [
                DataColumn(label: SizedBox.shrink()),
                DataColumn(label: SizedBox.shrink()),
              ],
              rows: [
                DataRow(
                  cells: [
                    DataCell(Text(context.l10n.averageElo, style: _headerStyle)),
                    DataCell(Text(stats.averageRating.toString(), style: _valueStyle)),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text(context.l10n.gamesPlayed, style: _headerStyle)),
                    DataCell(Text(stats.nbGames.toString(), style: _valueStyle)),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text(context.l10n.movesPlayed, style: _headerStyle)),
                    DataCell(Text(stats.nbMoves.toString(), style: _valueStyle)),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text(context.l10n.whiteWins, style: _headerStyle)),
                    DataCell(Text('${stats.whiteWinRate}%', style: _valueStyle)),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text(context.l10n.blackWins, style: _headerStyle)),
                    DataCell(Text('${stats.blackWinRate}%', style: _valueStyle)),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text(context.l10n.drawRate, style: _headerStyle)),
                    DataCell(Text('${stats.drawRate}%', style: _valueStyle)),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text(context.l10n.arenaBerserkRate, style: _headerStyle)),
                    DataCell(Text('${stats.berserkRate}%', style: _valueStyle)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            LoadingButtonBuilder<File>(
              fetchData: () => _downloadGames(ref),
              builder: (context, isLoading, fetchData) {
                return ListTile(
                  leading: const Icon(Icons.download),
                  title: Text(context.l10n.downloadAllGames),
                  enabled: !isLoading,
                  onTap: () async {
                    final file = await fetchData();
                    if (context.mounted) {
                      launchShareDialog(
                        context,
                        ShareParams(
                          fileNameOverrides: [
                            'lichess_tournament_${state.tournament.startsAt}.${state.tournament.id}.pgn',
                          ],
                          files: [XFile(file.path, mimeType: 'text/plain')],
                        ),
                      );
                    }
                  },
                );
              },
            ),
            if (session != null)
              LoadingButtonBuilder<File>(
                fetchData: () => _downloadGames(ref, session.user),
                builder: (context, isLoading, fetchData) {
                  return ListTile(
                    leading: const Icon(Icons.download),
                    title: const Text('Download my games'),
                    enabled: !isLoading,
                    onTap: () async {
                      final file = await fetchData();
                      if (context.mounted) {
                        launchShareDialog(
                          context,
                          ShareParams(
                            fileNameOverrides: [
                              'lichess_tournament_${state.tournament.startsAt}.${state.tournament.id}_${session.user.name}.pgn',
                            ],
                            files: [XFile(file.path, mimeType: 'text/plain')],
                          ),
                        );
                      }
                    },
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  static final _dateFormat = DateFormat('yyyy-MM-dd');

  Future<File> _downloadGames(WidgetRef ref, [LightUser? player]) async {
    final tempDir = await getTemporaryDirectory();
    final file = File(
      '${tempDir.path}/lichess_tournament${state.tournament.startsAt != null ? '_${_dateFormat.format(state.tournament.startsAt!)}' : ''}_${state.tournament.id}${player?.name != null ? '_${player?.name}' : ''}.pgn',
    );
    final res = await ref
        .read(tournamentRepositoryProvider)
        .downloadTournamentGames(state.tournament.id, file, userId: player?.id);
    if (res) {
      return file;
    } else {
      throw Exception('Failed to download tournament games');
    }
  }
}

class _BottomBar extends ConsumerStatefulWidget {
  const _BottomBar(this.state);

  final TournamentState state;

  @override
  ConsumerState<_BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends ConsumerState<_BottomBar> {
  bool joinOrLeaveInProgress = false;

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(authSessionProvider);
    final kidModeAsync = ref.watch(kidModeProvider);

    ref.listen(
      tournamentControllerProvider(widget.state.id).select((value) => value.valueOrNull?.joined),
      (prevJoined, joined) {
        if (prevJoined != joined) {
          setState(() {
            joinOrLeaveInProgress = false;
          });
        }
      },
    );

    return BottomBar(
      cupertinoTransparent: true,
      children: [
        if (widget.state.chatOptions != null && kidModeAsync.valueOrNull == false)
          ChatBottomBarButton(options: widget.state.chatOptions!, showLabel: true),

        if (widget.state.tournament.isFinished != true && session != null)
          joinOrLeaveInProgress
              ? const Center(child: CircularProgressIndicator.adaptive())
              : BottomBarButton(
                  label: widget.state.joined ? context.l10n.pause : context.l10n.join,
                  icon: widget.state.joined ? Icons.pause : Icons.play_arrow,
                  showLabel: true,
                  onTap: widget.state.canJoin
                      ? () {
                          ref
                              .read(tournamentControllerProvider(widget.state.id).notifier)
                              .joinOrPause();
                          setState(() {
                            joinOrLeaveInProgress = true;
                          });
                        }
                      : null,
                )
        else if (widget.state.tournament.isFinished != true)
          BottomBarButton(
            label: context.l10n.signIn,
            showLabel: true,
            icon: Icons.login,
            onTap: () {
              final authController = ref.watch(authControllerProvider);

              if (!authController.isLoading) {
                ref.read(authControllerProvider.notifier).signIn();
              }
            },
          ),
      ],
    );
  }
}

void _showPlayerDetails(
  BuildContext context,
  WidgetRef ref,
  TournamentId tournamentId,
  UserId userId,
) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return FutureBuilder<TournamentPlayer>(
            future: ref
                .read(tournamentRepositoryProvider)
                .getTournamentPlayer(tournamentId, userId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator.adaptive());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error loading player data: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                return _TournamentPlayerDetails(
                  player: snapshot.data!,
                  tournamentId: tournamentId,
                  scrollController: scrollController,
                );
              } else {
                return const Center(child: Text('No player data found'));
              }
            },
          );
        },
      );
    },
  );
}

class _TournamentPlayerDetails extends ConsumerWidget {
  final TournamentPlayer player;
  final TournamentId tournamentId;
  final ScrollController scrollController;

  const _TournamentPlayerDetails({
    required this.player,
    required this.tournamentId,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tournamentState = ref.watch(tournamentControllerProvider(tournamentId));
    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Row(
                children: [
                  Text('#${player.rank}', style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  Flexible(
                    child: UserFullNameWidget(
                      user: player.user,
                      rating: player.rating,
                      style: Styles.title,
                      onTap: tournamentState.valueOrNull?.isSpectator == true
                          ? () => Navigator.of(
                              context,
                            ).push(UserScreen.buildRoute(context, player.user))
                          : null,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
          ],
        ),

        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            child: Column(
              children: [
                _StatRow(
                  label: context.l10n.stormScore,
                  value: '${player.score}',
                  prefix: player.fire
                      ? const Icon(LichessIcons.blitz, size: 15, color: LichessColors.brag)
                      : null,
                ),
                if (player.performance != null)
                  _StatRow(
                    label: context.l10n.performance,
                    value: player.performance.toString() + (player.stats.game < 3 ? '?' : ''),
                  ),
                if (player.stats.game > 0) ...[
                  _StatRow(label: context.l10n.gamesPlayed, value: '${player.stats.game}'),
                  if (player.stats.win > 0)
                    _StatRow(
                      label: context.l10n.winRate,
                      value: '${((player.stats.win / player.stats.game) * 100).round()}%',
                    ),
                  _StatRow(
                    label: context.l10n.arenaBerserkRate,
                    value: '${((player.stats.berserk / player.stats.game) * 100).round()}%',
                  ),
                ],
                if (player.pairings.isNotEmpty)
                  _StatRow(
                    label: context.l10n.averageOpponent,
                    value: '${_calculateAverageOpponentRating(player)}',
                  ),
              ],
            ),
          ),
        ),

        if (player.pairings.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(context.l10n.games, style: Styles.sectionTitle),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ...player.pairings.asMap().entries.map(
                  (entry) => _PairingTile(
                    pairing: entry.value,
                    tournamentId: tournamentId,
                    player: player.user,
                    index: entry.key,
                    nbGames: player.pairings.length,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  final Widget? prefix;

  const _StatRow({required this.label, required this.value, this.prefix});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: textShade(context, 0.6))),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (prefix != null) prefix!,
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}

class _PairingTile extends ConsumerWidget {
  final TournamentPairing pairing;
  final LightUser player;
  final int index;
  final int nbGames;
  final TournamentId tournamentId;

  const _PairingTile({
    required this.pairing,
    required this.player,
    required this.index,
    required this.nbGames,
    required this.tournamentId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tournamentState = ref.watch(tournamentControllerProvider(tournamentId));

    final resultColor = pairing.score != null && pairing.score! >= 4
        ? LichessColors.brag
        : pairing.score != null && pairing.score! > 1
        ? LichessColors.good
        : null;

    return ListTile(
      contentPadding: const EdgeInsetsDirectional.only(start: 16.0, end: 16.0),
      visualDensity: VisualDensity.compact,
      tileColor: index.isEven ? context.lichessTheme.rowEven : context.lichessTheme.rowOdd,
      onTap: tournamentState.valueOrNull?.isSpectator == true
          ? () {
              // If game is finished (status neither started nor created), go to analysis board
              if (pairing.status != GameStatus.started && pairing.status != GameStatus.created) {
                Navigator.of(context, rootNavigator: true).push(
                  AnalysisScreen.buildRoute(
                    context,
                    AnalysisOptions.archivedGame(
                      orientation: pairing.color,
                      gameId: pairing.gameId,
                    ),
                  ),
                );
              } else {
                // If game is still in progress, go to TV view
                Navigator.of(context, rootNavigator: true).push(
                  TvScreen.buildRoute(
                    context,
                    gameId: pairing.gameId,
                    orientation: pairing.color,
                    user: player,
                  ),
                );
              }
            }
          : null,

      leading: Text((nbGames - index).toString().padLeft(2)),

      title: UserFullNameWidget(user: pairing.opponent, rating: pairing.opponentRating),

      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (pairing.berserk)
            const Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Icon(LichessIcons.body_cut, size: 20),
            ),
          Icon(pairing.color == Side.white ? Icons.circle_outlined : Icons.circle, size: 20),
          SizedBox(
            width: 24,
            height: 24,
            child: Center(
              child: Text(
                pairing.score?.toString() ?? '*',
                style: TextStyle(fontWeight: FontWeight.bold, color: resultColor, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

int _calculateAverageOpponentRating(TournamentPlayer player) {
  if (player.pairings.isEmpty) {
    return 0;
  }
  final totalRating = player.pairings.fold(0, (sum, pairing) => sum + pairing.opponentRating);
  return (totalRating / player.pairings.length).round();
}
