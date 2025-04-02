import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/playable_game.dart';
import 'package:lichess_mobile/src/model/tournament/tournament.dart';
import 'package:lichess_mobile/src/model/tournament/tournament_controller.dart';
import 'package:lichess_mobile/src/model/tv/tv_controller.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/duration.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/game/game_loading_board.dart';
import 'package:lichess_mobile/src/view/game/game_player.dart';
import 'package:lichess_mobile/src/view/game/game_screen.dart';
import 'package:lichess_mobile/src/widgets/board_thumbnail.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar_button.dart';
import 'package:lichess_mobile/src/widgets/clock.dart';
import 'package:lichess_mobile/src/widgets/platform_scaffold.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';
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

class _Body extends ConsumerWidget {
  const _Body({required this.state});

  final TournamentState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PlatformScaffold(
      appBarTitle: _Title(state: state),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: Styles.bodySectionPadding,
              child: SingleChildScrollView(
                child: Column(
                  spacing: 20,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Verdicts(state.tournament.verdicts),
                    if (!state.tournament.berserkable)
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
                    _Standing(state),
                    if (state.tournament.featuredGame != null)
                      _FeaturedGame(state.tournament.featuredGame!),
                  ],
                ),
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
    final timeLeft = state.tournament.timeToStart ?? state.tournament.timeToFinish;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(child: AutoSizeText(state.tournament.fullName, maxLines: 1, minFontSize: 14.0)),
        if (timeLeft != null)
          CountdownClockBuilder(
            timeLeft: timeLeft,
            active: true,
            tickInterval: const Duration(seconds: 1),
            builder:
                (BuildContext context, Duration timeLeft) => Center(
                  child: Text(
                    '${timeLeft.toHoursMinutesSeconds()} ',
                    style: const TextStyle(fontFeatures: [FontFeature.tabularFigures()]),
                  ),
                ),
          ),
      ],
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
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, i) {
            final player = standing.players.getOrNull(i);
            return player != null
                ? _StandingPlayer(player: player, rank: state.firstRankOfPage + i)
                : null;
          },
        ),
        _StandingControls(state: state),
      ],
    );
  }
}

class _StandingPlayer extends StatelessWidget {
  const _StandingPlayer({required this.player, required this.rank});

  final StandingPlayer player;
  final int rank;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO show player detail page
      },
      child: ColoredBox(
        color:
            rank.isEven
                ? ColorScheme.of(context).surfaceContainerLow
                : ColorScheme.of(context).surfaceContainerHigh,
        child: Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 8, right: 8, left: 2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 5,
            children: [
              SizedBox(
                width: 30,
                child:
                    player.withdraw
                        ? const Icon(Icons.pause, color: LichessColors.grey, size: 20)
                        : Text('$rank', textAlign: TextAlign.center),
              ),
              UserFullNameWidget(
                user: player.user,
                rating: player.rating,
                provisional: player.provisional,
                shouldShowOnline: false,
                showFlair: false,
                showPatron: false,
              ),
              Expanded(child: _Scores(player.sheet.scores)),
              Visibility.maintain(
                visible: player.sheet.fire,
                child: const Icon(LichessIcons.blitz, size: 17, color: LichessColors.brag),
              ),
              Text('${player.score}', style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
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
      alignment: WrapAlignment.end,
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
                        : LichessColors.grey,
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed:
              state.hasPreviousPage
                  ? ref.read(tournamentControllerProvider(state.id).notifier).loadFirstStandingsPage
                  : null,
          icon: const Icon(Icons.first_page),
        ),
        IconButton(
          onPressed:
              state.hasPreviousPage
                  ? ref
                      .read(tournamentControllerProvider(state.id).notifier)
                      .loadPreviousStandingsPage
                  : null,
          icon: const Icon(Icons.skip_previous),
        ),
        Text(
          '${state.firstRankOfPage}-${min(state.firstRankOfPage + kStandingsPageSize - 1, state.tournament.nbPlayers)} / ${state.tournament.nbPlayers}',
        ),
        IconButton(
          onPressed:
              state.hasNextPage
                  ? ref.read(tournamentControllerProvider(state.id).notifier).loadNextStandingsPage
                  : null,
          icon: const Icon(Icons.skip_next),
        ),
        IconButton(
          onPressed:
              state.hasNextPage
                  ? ref.read(tournamentControllerProvider(state.id).notifier).loadLastStandingsPage
                  : null,
          icon: const Icon(Icons.last_page),
        ),
        if (state.tournament.me != null)
          IconButton(
            onPressed: ref.read(tournamentControllerProvider(state.id).notifier).jumpToMyPage,
            icon: const Icon(LichessIcons.target),
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
                      ? LichessColors.good
                      : LichessColors.error
                  : null,
          size: 30,
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final verdict in verdicts.list)
              if (verdict.condition != 'Bot players are not allowed')
                Text(
                  verdict.condition,
                  style: TextStyle(
                    color:
                        isLoggedIn
                            ? verdict.ok
                                ? LichessColors.good
                                : LichessColors.error
                            : null,
                  ),
                ),
          ],
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
        switch (ref.watch(
          tvControllerProvider(null, (featuredGame.id, featuredGame.orientation)),
        )) {
          case AsyncData(:final value):
            {
              final game = value.game;

              final whitePlayer = _FeaturedGamePlayer(
                game: game,
                player: featuredGame.white,
                side: Side.white,
              );

              final blackPlayer = _FeaturedGamePlayer(
                game: game,
                player: featuredGame.black,
                side: Side.black,
              );

              return BoardThumbnail(
                size: boardSize,
                orientation: featuredGame.orientation,
                fen: game.lastPosition.fen,
                header: featuredGame.orientation == Side.white ? blackPlayer : whitePlayer,
                footer: featuredGame.orientation == Side.white ? whitePlayer : blackPlayer,
                lastMove: game.lastMove,
              );
            }
          case _:
            return BoardThumbnail(
              size: boardSize,
              fen: featuredGame.fen,
              orientation: featuredGame.orientation,
              header: const Shimmer(child: LoadingPlayerWidget()),
              footer: const Shimmer(child: LoadingPlayerWidget()),
            );
        }
      },
    );
  }
}

class _FeaturedGamePlayer extends StatelessWidget {
  const _FeaturedGamePlayer({required this.game, required this.player, required this.side});

  final PlayableGame game;
  final FeaturedPlayer player;
  final Side side;

  @override
  Widget build(BuildContext context) {
    final activeClockSide = game.lastPosition.fullmoves > 1 ? game.lastPosition.turn : null;
    return GamePlayer(
      game: game,
      side: side,
      clock:
          game.clock != null
              ? CountdownClockBuilder(
                key: key,
                timeLeft: game.clockOf(side)!,
                delay: game.clock!.lag ?? const Duration(milliseconds: 10),
                clockUpdatedAt: game.clock!.at,
                active: activeClockSide == side,
                builder: (context, timeLeft) {
                  return Clock(timeLeft: timeLeft, active: activeClockSide == side);
                },
              )
              : null,
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
