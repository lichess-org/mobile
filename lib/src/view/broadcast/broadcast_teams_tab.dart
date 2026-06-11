import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_preferences.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_providers.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_round_controller.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/theme.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/screen.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_game_screen.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_player_widget.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_team_screen.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_team_standings_screen.dart';
import 'package:lichess_mobile/src/view/engine/engine_gauge.dart';
import 'package:visibility_detector/visibility_detector.dart';

const _kScoreContainerWidth = 75.0;
const _kTeamNameMaxLines = 3;

const _kGameRowPadding = EdgeInsets.symmetric(vertical: 4.0, horizontal: 16);
const _kTabletSpacing = 20.0;
const _kPhoneSpacing = 8.0;

const _kEvalBarWidth = 32.0;
const _kEvalBarHeight = 14.0;
const _kEvalBarDividerWidth = _kEvalBarWidth / 50;

class BroadcastTeamsTab extends ConsumerWidget {
  const BroadcastTeamsTab({
    required this.roundId,
    required this.tournamentId,
    required this.tournamentSlug,
    this.showTeamScores = false,
  });

  final BroadcastRoundId roundId;
  final BroadcastTournamentId tournamentId;
  final String tournamentSlug;
  final bool showTeamScores;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teams = ref.watch(broadcastTeamMatchesProvider(roundId));

    return switch (teams) {
      AsyncData(value: final teams) => BroadcastTeamsList(
        teams,
        roundId,
        tournamentId,
        tournamentSlug,
        showTeamScores,
      ),
      AsyncError(:final error) => Center(child: Text('Cannot load teams data: $error')),
      _ => const Center(child: CircularProgressIndicator.adaptive()),
    };
  }
}

class BroadcastTeamsList extends ConsumerWidget {
  const BroadcastTeamsList(
    this.teamMatches,
    this.roundId,
    this.tournamentId,
    this.tournamentSlug,
    this.showTeamScores,
  );

  final IList<BroadcastTeamMatch> teamMatches;
  final BroadcastRoundId roundId;
  final BroadcastTournamentId tournamentId;
  final String tournamentSlug;
  final bool showTeamScores;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final round = ref.watch(broadcastRoundControllerProvider(roundId));
    final showEvaluationGauges = ref.watch(
      broadcastPreferencesProvider.select((value) => value.showRoundEvaluationGauges),
    );

    return switch (round) {
      AsyncData(:final value) => CustomScrollView(
        slivers: [
          if (showTeamScores)
            SliverSafeArea(
              bottom: false,
              sliver: SliverToBoxAdapter(child: _TeamStandingsButton(tournamentId: tournamentId)),
            ),
          SliverSafeArea(
            top: !showTeamScores,
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final match = teamMatches[index];
                return _TeamMatchCard(
                  match: match,
                  games: value.games,
                  tournamentId: tournamentId,
                  roundId: roundId,
                  tournamentSlug: tournamentSlug,
                  roundSlug: value.round.slug,
                  title: value.round.name,
                  showEvaluationGauge: showEvaluationGauges,
                  customScoring: value.round.customScoring,
                  showTeamScores: showTeamScores,
                );
              }, childCount: teamMatches.length),
            ),
          ),
        ],
      ),
      AsyncError(:final error) => Center(child: Text('Cannot load games data: $error')),
      _ => const Center(child: CircularProgressIndicator.adaptive()),
    };
  }
}

class _TeamStandingsButton extends StatelessWidget {
  const _TeamStandingsButton({required this.tournamentId});

  final BroadcastTournamentId tournamentId;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: Styles.horizontalBodyPadding.copyWith(top: 12.0, bottom: 8.0),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.all(16.0),
          shape: RoundedRectangleBorder(borderRadius: .circular(8.0)),
          side: BorderSide(color: colorScheme.primary, width: 0.8),
        ),
        onPressed: () {
          Navigator.of(context).push(BroadcastTeamStandingsScreen.buildRoute(tournamentId));
        },
        child: Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.leaderboard, color: colorScheme.secondary),
                const SizedBox(width: 12),
                Text(
                  context.l10n.broadcastTeamResults,
                  style: TextStyle(fontWeight: .bold, color: colorScheme.secondary, fontSize: 16),
                ),
              ],
            ),
            Icon(Icons.chevron_right, color: colorScheme.secondary),
          ],
        ),
      ),
    );
  }
}

class _TeamMatchCard extends StatelessWidget {
  const _TeamMatchCard({
    required this.match,
    required this.games,
    required this.tournamentId,
    required this.roundId,
    required this.tournamentSlug,
    required this.roundSlug,
    required this.title,
    required this.showEvaluationGauge,
    required this.customScoring,
    required this.showTeamScores,
  });

  final BroadcastTeamMatch match;
  final BroadcastRoundGames games;
  final BroadcastTournamentId tournamentId;
  final BroadcastRoundId roundId;
  final String tournamentSlug;
  final String roundSlug;
  final String title;
  final bool showEvaluationGauge;
  final BroadcastCustomScoring? customScoring;
  final bool showTeamScores;

  bool get matchFinished => games.everyEntry((e) => e.value.isOver);
  BroadcastResult? get matchStatus => matchFinished
      ? match.team1.points > match.team2.points
            ? BroadcastResult.whiteWins
            : match.team1.points < match.team2.points
            ? BroadcastResult.blackWins
            : BroadcastResult.draw
      : null;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      clipBehavior: .hardEdge,
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ColoredBox(
            color: ColorScheme.of(context).surfaceDim,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (showTeamScores) {
                          Navigator.of(context).push(
                            BroadcastTeamScreen.buildRoute(context, tournamentId, match.team1.name),
                          );
                        }
                      },
                      child: Text(
                        match.team1.name,
                        maxLines: _kTeamNameMaxLines,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Container(
                    width: _kScoreContainerWidth,
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          NumberFormat('#.#').format(match.team1.points),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: matchStatus?.colorFor(Side.white, context),
                          ),
                        ),
                        const Text(' - '),
                        Text(
                          NumberFormat('#.#').format(match.team2.points),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: matchStatus?.colorFor(Side.black, context),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (showTeamScores) {
                          Navigator.of(context).push(
                            BroadcastTeamScreen.buildRoute(context, tournamentId, match.team2.name),
                          );
                        }
                      },
                      child: Text(
                        match.team2.name,
                        maxLines: _kTeamNameMaxLines,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          ...match.games.asMap().entries.map((entry) {
            final gameIndex = entry.key;
            final teamGame = entry.value;
            final game = games[teamGame.id];
            if (game == null) return const SizedBox.shrink();

            return _GameRow(
              game: game,
              teamGame: teamGame,
              index: gameIndex,
              tournamentId: tournamentId,
              roundId: roundId,
              tournamentSlug: tournamentSlug,
              roundSlug: roundSlug,
              title: title,
              showEvaluationGauge: showEvaluationGauge,
              customScoring: customScoring,
            );
          }),
        ],
      ),
    );
  }
}

class _GameRow extends ConsumerStatefulWidget {
  const _GameRow({
    required this.game,
    required this.teamGame,
    required this.index,
    required this.tournamentId,
    required this.roundId,
    required this.tournamentSlug,
    required this.roundSlug,
    required this.title,
    required this.showEvaluationGauge,
    required this.customScoring,
  });

  final BroadcastGame game;
  final BroadcastTeamGame teamGame;
  final int index;
  final BroadcastTournamentId tournamentId;
  final BroadcastRoundId roundId;
  final String tournamentSlug;
  final String roundSlug;
  final String title;
  final bool showEvaluationGauge;
  final BroadcastCustomScoring? customScoring;
  @override
  ConsumerState<_GameRow> createState() => _GameRowState();
}

class _GameRowState extends ConsumerState<_GameRow> {
  bool isGameVisible = false;

  @override
  Widget build(BuildContext context) {
    final whitePlayer = widget.game.players[Side.white];
    final blackPlayer = widget.game.players[Side.black];
    final isTablet = isTabletOrLarger(context);

    if (whitePlayer == null || blackPlayer == null) {
      return const SizedBox.shrink();
    }

    final team1Player = widget.teamGame.pov == Side.white ? whitePlayer : blackPlayer;
    final team2Player = widget.teamGame.pov == Side.white ? blackPlayer : whitePlayer;

    final result = _getGameResultTexts(widget.game, widget.teamGame.pov, widget.customScoring);

    final whiteWinningChances =
        widget.game.isOngoing && (widget.game.cp != null || widget.game.mate != null)
        ? ExternalEval(cp: widget.game.cp, mate: widget.game.mate).winningChances(Side.white)
        : null;

    return VisibilityDetector(
      key: Key('${widget.game.id}'),
      onVisibilityChanged: (visibilityInfo) {
        if (visibilityInfo.visibleFraction > 0.1) {
          if (!isGameVisible && context.mounted) {
            ref
                .read(broadcastRoundControllerProvider(widget.roundId).notifier)
                .addObservedGame(widget.game.id);
            setState(() {
              isGameVisible = true;
            });
          }
        } else {
          if (isGameVisible && context.mounted) {
            ref
                .read(broadcastRoundControllerProvider(widget.roundId).notifier)
                .removeObservedGame(widget.game.id);
            setState(() {
              isGameVisible = false;
            });
          }
        }
      },
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            BroadcastGameScreen.buildRoute(
              tournamentId: widget.tournamentId,
              roundId: widget.roundId,
              gameId: widget.game.id,
              tournamentSlug: widget.tournamentSlug,
              roundSlug: widget.roundSlug,
              title: widget.title,
            ),
          );
        },
        child: ColoredBox(
          color: widget.index.isEven ? context.lichessTheme.rowEven : context.lichessTheme.rowOdd,
          child: Padding(
            padding: _kGameRowPadding,
            child: Row(
              children: [
                Expanded(
                  child: BroadcastPlayerWidget(player: team1Player.player, showRating: isTablet),
                ),
                SizedBox(width: isTablet ? _kTabletSpacing : _kPhoneSpacing),
                SizedBox(
                  width: _kEvalBarWidth,
                  child: widget.game.isOngoing && widget.showEvaluationGauge
                      ? whiteWinningChances != null
                            ? _MiniEvalBar(
                                whiteWinningChances: whiteWinningChances,
                                pov: widget.teamGame.pov,
                              )
                            : Container(
                                height: _kEvalBarHeight,
                                width: _kEvalBarWidth,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(_kEvalBarHeight / 2),
                                  color: Colors.grey.withValues(alpha: 0.6),
                                ),
                              )
                      : Container(
                          alignment: Alignment.center,
                          child: Row(mainAxisAlignment: .center, children: result),
                        ),
                ),
                SizedBox(width: isTablet ? _kTabletSpacing : _kPhoneSpacing),
                Expanded(
                  child: BroadcastPlayerWidget(player: team2Player.player, showRating: isTablet),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Text> _getGameResultTexts(
    BroadcastGame game,
    Side teamPov,
    BroadcastCustomScoring? customScoring,
  ) {
    if (!game.isOver) {
      return [const Text('*')];
    }
    Text povResult(BroadcastGame game, Side pov, BroadcastCustomScoring? customScoring) {
      return Text(
        resultString(customScoring, pov, game.status),
        style: TextStyle(color: game.status.colorFor(pov, context)),
      );
    }

    final team1Result = povResult(game, teamPov, customScoring);
    final team2Result = povResult(game, teamPov.opposite, customScoring);
    return [team1Result, const Text('-'), team2Result];
  }
}

class _MiniEvalBar extends StatelessWidget {
  const _MiniEvalBar({required this.whiteWinningChances, required this.pov});

  final double whiteWinningChances;
  final Side pov;

  @override
  Widget build(BuildContext context) {
    final whiteBarWidth = _kEvalBarWidth * (whiteWinningChances + 1) / 2;

    return Stack(
      alignment: Alignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(_kEvalBarHeight / 2),
          child: Row(
            children: [
              Container(
                width: pov == Side.white ? whiteBarWidth : _kEvalBarWidth - whiteBarWidth,
                height: _kEvalBarHeight,
                color: pov == Side.white
                    ? EngineGauge.valueColor(context)
                    : EngineGauge.backgroundColor(context),
              ),
              Container(
                width: pov == Side.white ? _kEvalBarWidth - whiteBarWidth : whiteBarWidth,
                height: _kEvalBarHeight,
                color: pov == Side.white
                    ? EngineGauge.backgroundColor(context)
                    : EngineGauge.valueColor(context),
              ),
            ],
          ),
        ),

        Container(width: _kEvalBarDividerWidth, height: _kEvalBarHeight, color: darken(Colors.red)),
      ],
    );
  }
}
