import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/tournament/tournament.dart';
import 'package:lichess_mobile/src/model/tournament/tournament_controller.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/theme.dart';
import 'package:lichess_mobile/src/utils/duration.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/game/game_screen.dart';
import 'package:lichess_mobile/src/widgets/board_thumbnail.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar_button.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/clock.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/platform_scaffold.dart';
import 'package:lichess_mobile/src/widgets/user_full_name.dart';

class TournamentScreen extends ConsumerWidget {
  const TournamentScreen({required this.id});

  final TournamentId id;

  static Route<void> buildRoute(BuildContext context, TournamentId id) {
    return buildScreenRoute(
      context,
      title: context.l10n.tournament,
      screen: TournamentScreen(id: id),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(tournamentControllerProvider(id).select((value) => value.valueOrNull?.currentGame), (
      prevGameId,
      currentGameId,
    ) {
      if (prevGameId != currentGameId && currentGameId != null) {
        Navigator.of(
          context,
          rootNavigator: true,
        ).push(GameScreen.buildRoute(context, initialGameId: currentGameId));
      }
    });

    return switch (ref.watch(tournamentControllerProvider(id))) {
      AsyncError(:final error) => Center(child: Text('Could not load tournament: $error')),
      AsyncValue(:final value?) => _Body(state: value),
      _ => const PlatformScaffold(
        appBarTitle: SizedBox.shrink(),
        body: Center(child: CircularProgressIndicator()),
      ),
    };
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.state});

  final TournamentState state;

  @override
  Widget build(BuildContext context) {
    final timeLeft = state.tournament.timeToStart ?? state.tournament.timeToFinish;

    return PlatformScaffold(
      appBarTitle: _Title(state: state),
      appBarActions: [
        if (timeLeft != null)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (state.tournament.timeToStart != null)
                  Text(context.l10n.startingIn, style: const TextStyle(fontSize: 14)),
                CountdownClockBuilder(
                  timeLeft: timeLeft,
                  active: true,
                  tickInterval: const Duration(seconds: 1),
                  builder:
                      (BuildContext context, Duration timeLeft) => Text(
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
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: Styles.horizontalBodyPadding,
              child: ListView(
                children: [
                  PlatformCard(
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
                            const Text.rich(
                              TextSpan(
                                children: [
                                  WidgetSpan(child: Icon(LichessIcons.body_cut, size: 16)),
                                  TextSpan(
                                    // TODO l10n
                                    text: ' No Berserk allowed',
                                  ),
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
                  if (state.tournament.featuredGame != null)
                    _FeaturedGame(state.tournament.featuredGame!),
                ],
              ),
            ),
          ),
          _BottomBar(state),
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({required this.state});

  final TournamentState state;

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(state.tournament.fullName, maxLines: 1, minFontSize: 14.0);
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
    return PlatformCard(
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

class _StandingPlayer extends StatelessWidget {
  const _StandingPlayer({required this.player});

  final StandingPlayer player;

  @override
  Widget build(BuildContext context) {
    return AdaptiveListTile(
      contentPadding: const EdgeInsetsDirectional.only(start: 16.0, end: 16.0),
      visualDensity: VisualDensity.compact,
      tileColor: player.rank.isEven ? context.lichessTheme.rowEven : context.lichessTheme.rowOdd,
      leading:
          player.withdraw
              ? Icon(Icons.pause, color: textShade(context, 0.3), size: 20)
              : Text('${player.rank}', textAlign: TextAlign.center),
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
                color:
                    score >= 4
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
        PlatformIconButton(
          onPressed:
              state.hasPreviousPage
                  ? ref
                      .read(tournamentControllerProvider(state.id).notifier)
                      .loadPreviousStandingsPage
                  : null,
          onLongPress:
              state.hasPreviousPage
                  ? ref.read(tournamentControllerProvider(state.id).notifier).loadFirstStandingsPage
                  : null,
          semanticsLabel: 'Previous',
          icon: Icons.skip_previous,
        ),
        Expanded(
          child: Text(
            '${state.firstRankOfPage}-${min(state.firstRankOfPage + kStandingsPageSize - 1, state.tournament.nbPlayers)} / ${state.tournament.nbPlayers}',
            style: const TextStyle(fontFeatures: [FontFeature.tabularFigures()]),
            textAlign: TextAlign.center,
          ),
        ),
        PlatformIconButton(
          onPressed:
              state.hasNextPage
                  ? ref.read(tournamentControllerProvider(state.id).notifier).loadNextStandingsPage
                  : null,
          onLongPress:
              state.hasNextPage
                  ? ref.read(tournamentControllerProvider(state.id).notifier).loadLastStandingsPage
                  : null,
          semanticsLabel: context.l10n.studyNext,
          icon: Icons.skip_next,
        ),
        if (state.tournament.me != null)
          PlatformIconButton(
            onPressed: ref.read(tournamentControllerProvider(state.id).notifier).jumpToMyPage,
            icon: Icons.person_pin_circle_outlined,
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
        Icon(tournament.perf.icon, size: 36),
        const SizedBox(width: 10),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${tournament.timeIncrement.display} • ${tournament.perf.title} • ${context.l10n.nbMinutes(tournament.duration.inMinutes)}',
              ),
              Text(
                '${tournament.rated ? context.l10n.rated : context.l10n.casual} • ${context.l10n.arenaArena}',
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
          color:
              isLoggedIn
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
                    color:
                        isLoggedIn
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
          if (game.finished == true)
            Text(
              game.winner == side
                  ? '1'
                  : game.winner == side.opposite
                  ? '0'
                  : '½',
              style: const TextStyle().copyWith(fontWeight: FontWeight.bold),
            )
          else
            CountdownClockBuilder(
              timeLeft: game.clockOf(side),
              active: clockActive,
              builder:
                  (context, timeLeft) => Text(
                    timeLeft.toHoursMinutesSeconds(),
                    style: TextStyle(
                      color: clockActive ? Colors.orange[900] : null,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
            ),
        ],
      ),
    );
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
    final isLoggedIn = ref.watch(authSessionProvider)?.user.id != null;

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

    return PlatformBottomBar(
      children: [
        if (isLoggedIn)
          joinOrLeaveInProgress
              ? const Center(child: CircularProgressIndicator())
              : BottomBarButton(
                label: widget.state.joined ? context.l10n.pause : context.l10n.join,
                icon: widget.state.joined ? Icons.pause : Icons.play_arrow,
                showLabel: true,
                onTap:
                    widget.state.canJoin
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
        else
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
