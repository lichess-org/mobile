import 'package:collection/collection.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_preferences.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_round_controller.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/duration.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/screen.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_game_screen.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_player_widget.dart';
import 'package:lichess_mobile/src/widgets/board_thumbnail.dart';
import 'package:lichess_mobile/src/widgets/clock.dart';
import 'package:lichess_mobile/src/widgets/platform_search_bar.dart';
import 'package:material_ui/material_ui.dart';
import 'package:visibility_detector/visibility_detector.dart';

// height of 1.0 is important because we need to determine the height of the text
// to calculate the height of the header and footer of the board
const _kPlayerWidgetTextStyle = TextStyle(fontSize: 13, height: 1.0);

const _kPlayerWidgetPadding = EdgeInsets.symmetric(vertical: 5.0);

/// A tab that displays the live games of a broadcast round.
class const BroadcastBoardsTab({
  required final BroadcastTournamentId tournamentId,
  required final BroadcastRoundId roundId,
  required final String tournamentSlug,
  required final bool showOnlyOngoingGames,
  required final String? teamFilter,
}) extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredGameIds = ref.watch(
      broadcastRoundControllerProvider(roundId).select((state) {
        final games = state.value?.games;
        if (games == null) return null;

        final validIds = <BroadcastGameId>[];

        for (final entry in games.entries) {
          final gameId = entry.key;
          final game = entry.value;

          if (showOnlyOngoingGames && !game.isOngoing) {
            continue;
          }

          if (teamFilter != null &&
              !Side.values.any((s) => game.players[s]?.player.team == teamFilter)) {
            continue;
          }

          validIds.add(gameId);
        }

        return validIds.toIList();
      }),
    );

    final gamesMap = ref.read(broadcastRoundControllerProvider(roundId)).value?.games;

    return switch (filteredGameIds) {
      final ids? => (() {
        if (gamesMap == null) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }

        return gamesMap.isEmpty || ids.isEmpty
            ? Padding(
                padding: Styles.bodyPadding,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.info, size: 30),
                    const SizedBox(height: 8.0),
                    Text(
                      gamesMap.isEmpty
                          ? context.l10n.broadcastNoBoardsYet
                          : 'No games matching filter criteria.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            : BroadcastPreview(
                gameIds: ids,
                tournamentId: tournamentId,
                roundId: roundId,
                tournamentSlug: tournamentSlug,
                teamFilter: teamFilter,
              );
      })(),
      null => const Center(child: CircularProgressIndicator.adaptive()),
    };
  }
}

class BroadcastPreview extends ConsumerStatefulWidget {
  const new({
    required this.tournamentId,
    required this.roundId,
    required this.gameIds,
    required this.tournamentSlug,
    required this.teamFilter,
  });

  // A circular progress indicator is used instead of shimmers currently
  const new loading()
    : tournamentId = const BroadcastTournamentId(''),
      roundId = const BroadcastRoundId(''),
      gameIds = null,
      tournamentSlug = '',
      teamFilter = null;

  final BroadcastTournamentId tournamentId;
  final BroadcastRoundId roundId;
  final IList<BroadcastGameId>? gameIds;
  final String tournamentSlug;
  final String? teamFilter;

  @override
  ConsumerState<BroadcastPreview> createState() => _BroadcastPreviewState();
}

class _BroadcastPreviewState() extends ConsumerState<BroadcastPreview> {
  String _searchQuery = '';
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final showEvaluationGauges = ref.watch(
      broadcastPreferencesProvider.select((value) => value.showRoundEvaluationGauges),
    );
    const numberLoadingBoards = 12;
    const boardSpacing = 10.0;
    // height of the text based on the font size
    // since the TextStyle is defined with an height at 1.0, this is the real height
    // see: https://api.flutter.dev/flutter/painting/TextStyle/height.html
    final textHeight = _kPlayerWidgetTextStyle.fontSize!;
    final headerAndFooterHeight = textHeight + _kPlayerWidgetPadding.vertical;
    final numberOfBoardsByRow = isTabletOrLarger(context) ? 3 : 2;
    final screenWidth = MediaQuery.widthOf(context);
    final boardWithMaybeEvalBarWidth =
        (screenWidth -
            Styles.horizontalBodyPadding.horizontal -
            (numberOfBoardsByRow - 1) * boardSpacing) /
        numberOfBoardsByRow;

    final round = ref.watch(
      broadcastRoundControllerProvider(widget.roundId).select((state) => state.value?.round),
    );
    final games = _searchQuery.isNotEmpty
        ? ref.watch(
            broadcastRoundControllerProvider(widget.roundId).select((state) => state.value?.games),
          )
        : ref.read(broadcastRoundControllerProvider(widget.roundId)).value?.games;

    final IList<BroadcastGameId>? gameIds = widget.gameIds == null || games == null
        ? null
        : _searchQuery.isEmpty
        ? widget.gameIds
        : widget.gameIds!.where((gameId) {
            final game = games[gameId];
            return game != null && _containsPlayer(game, _searchQuery);
          }).toIList();

    final showSearchBar = widget.gameIds != null && widget.gameIds!.length > 6;
    final pinnedComment = round?.pinnedComment;
    final hasComment = pinnedComment != null && pinnedComment.isNotEmpty;
    final mediaQueryPadding = MediaQuery.paddingOf(context);

    return CustomScrollView(
      slivers: [
        if (hasComment)
          SliverSafeArea(
            bottom: false,
            sliver: SliverPadding(
              padding: Styles.bodyPadding.copyWith(bottom: 0.0),
              sliver: SliverToBoxAdapter(child: _PinnedCommentCard(text: pinnedComment)),
            ),
          ),

        if (showSearchBar)
          SliverSafeArea(
            top: !hasComment,
            bottom: false,
            sliver: SliverPadding(
              padding: Styles.bodyPadding.copyWith(bottom: 0.0),
              sliver: SliverToBoxAdapter(
                child: PlatformSearchBar(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  onClear: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                ),
              ),
            ),
          ),
        SliverPadding(
          padding: Styles.bodyPadding.add(
            EdgeInsetsGeometry.only(
              // top media query padding is already included in one of the SliverSafeArea above
              top: hasComment || showSearchBar ? 0.0 : mediaQueryPadding.top,
              bottom: mediaQueryPadding.bottom,
            ),
          ),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate((context, index) {
              final boardSize =
                  boardWithMaybeEvalBarWidth -
                  (showEvaluationGauges
                      ? boardThumbnailEvalGaugeAspectRatio * boardWithMaybeEvalBarWidth
                      : 0);

              if (gameIds == null) {
                return BoardThumbnail.loading(
                  size: boardSize,
                  header: _PlayerWidgetLoading(width: boardWithMaybeEvalBarWidth),
                  footer: _PlayerWidgetLoading(width: boardWithMaybeEvalBarWidth),
                );
              }

              final gameId = gameIds[index];

              return ObservedBoardThumbnail(
                roundId: widget.roundId,
                gameId: gameId,
                title: round?.name ?? '',
                tournamentId: widget.tournamentId,
                tournamentSlug: widget.tournamentSlug,
                roundSlug: round?.slug ?? '',
                showEvaluationGauge: showEvaluationGauges,
                boardSize: boardSize,
                boardWithMaybeEvalBarWidth: boardWithMaybeEvalBarWidth,
                customScoring: round?.customScoring,
                teamFilter: widget.teamFilter,
              );
            }, childCount: gameIds == null ? numberLoadingBoards : gameIds.length),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: numberOfBoardsByRow,
              crossAxisSpacing: boardSpacing,
              mainAxisSpacing: boardSpacing,
              mainAxisExtent: boardWithMaybeEvalBarWidth + 2 * headerAndFooterHeight,
              childAspectRatio: 1 + boardThumbnailEvalGaugeAspectRatio,
            ),
          ),
        ),
      ],
    );
  }
}

class const ObservedBoardThumbnail({
  required final BroadcastRoundId roundId,
  required final BroadcastGameId gameId,
  required final String title,
  required final BroadcastTournamentId tournamentId,
  required final String tournamentSlug,
  required final String roundSlug,
  required final bool showEvaluationGauge,
  required final double boardSize,
  required final double boardWithMaybeEvalBarWidth,
  required final BroadcastCustomScoring? customScoring,
  required final String? teamFilter,
}) extends ConsumerStatefulWidget {
  @override
  ConsumerState<ObservedBoardThumbnail> createState() => _ObservedBoardThumbnailState();
}

class _ObservedBoardThumbnailState() extends ConsumerState<ObservedBoardThumbnail> {
  bool isBoardVisible = false;

  @override
  Widget build(BuildContext context) {
    final game = ref.watch(
      broadcastRoundControllerProvider(widget.roundId)
          .select((state) => state.value?.games[widget.gameId]),
    );

    if (game == null) return const SizedBox.shrink();

    final playingSide = Setup.parseFen(game.fen).turn;
    final orientation = widget.teamFilter != null
        ? game.players.entries
                  .firstWhereOrNull((entry) => entry.value.player.team == widget.teamFilter)
                  ?.key ??
              Side.white
        : Side.white;

    return VisibilityDetector(
      key: ValueKey(widget.gameId),
      onVisibilityChanged: (visibilityInfo) {
        if (visibilityInfo.visibleFraction > 0.3) {
          if (!isBoardVisible && context.mounted) {
            ref.read(observedGamesControllerProvider(widget.roundId).notifier).add(widget.gameId);
            setState(() {
              isBoardVisible = true;
            });
          }
        } else {
          if (isBoardVisible && context.mounted) {
            ref
                .read(observedGamesControllerProvider(widget.roundId).notifier)
                .remove(widget.gameId);
            setState(() {
              isBoardVisible = false;
            });
          }
        }
      },
      child: BoardThumbnail(
        animationDuration: const Duration(milliseconds: 150),
        onTap: () {
          Navigator.of(context).push(
            BroadcastGameScreen.buildRoute(
              tournamentId: widget.tournamentId,
              roundId: widget.roundId,
              gameId: widget.gameId,
              tournamentSlug: widget.tournamentSlug,
              roundSlug: widget.roundSlug,
              title: widget.title,
              initialPov: orientation,
            ),
          );
        },
        orientation: orientation,
        fen: game.fen,
        showEvaluationGauge: widget.showEvaluationGauge,
        whiteWinningChances: (game.cp != null || game.mate != null)
            ? ExternalEval(cp: game.cp, mate: game.mate).winningChances(Side.white)
            : null,
        lastMove: game.lastMove,
        size: widget.boardSize,
        header: _PlayerWidget(
          width: widget.boardWithMaybeEvalBarWidth,
          game: game,
          side: orientation.opposite,
          playingSide: playingSide,
          customScoring: widget.customScoring,
        ),
        footer: _PlayerWidget(
          width: widget.boardWithMaybeEvalBarWidth,
          game: game,
          side: orientation,
          playingSide: playingSide,
          customScoring: widget.customScoring,
        ),
      ),
    );
  }
}

class const _PlayerWidgetLoading({required final double width}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Padding(
        padding: _kPlayerWidgetPadding,
        child: Container(
          height: _kPlayerWidgetTextStyle.fontSize,
          decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(5)),
        ),
      ),
    );
  }
}

class const _PlayerWidget({
  required final double width,
  required final BroadcastGame game,
  required final Side side,
  required final Side playingSide,
  required final BroadcastCustomScoring? customScoring,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final playerWithClock = game.players[side]!;
    final player = playerWithClock.player;
    final clock = playerWithClock.clock;
    final isClockActive = game.isOngoing && side == playingSide;

    return SizedBox(
      width: width,
      child: Padding(
        padding: _kPlayerWidgetPadding,
        child: DefaultTextStyle.merge(
          style: _kPlayerWidgetTextStyle,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: BroadcastPlayerWidget(player: player, showRating: false)),
              const SizedBox(width: 5),
              if (game.isOver)
                Text(
                  resultString(customScoring, side, game.status),
                  style: Theme.of(context).textTheme.bodySmall
                      ?.copyWith(fontWeight: .bold, color: game.status.colorFor(side, context)),
                )
              else if (clock != null)
                CountdownClockBuilder(
                  timeLeft: clock,
                  active: isClockActive,
                  builder: (context, timeLeft) => Text(
                    timeLeft.toHoursMinutesSeconds(),
                    style: TextStyle(
                      color: isClockActive ? Colors.orange[900] : null,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                  tickInterval: const Duration(seconds: 1),
                  clockUpdatedAt: game.updatedClockAt,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

bool _containsPlayer(BroadcastGame game, String query) {
  final q = query.toLowerCase();
  return game.players.values.any((pwc) => pwc.player.name?.toLowerCase().contains(q) ?? false);
}

class const _PinnedCommentCard({required final String text}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        leading: const Icon(LichessIcons.radio_tower_lichess, size: 28),
        title: Text(text, style: TextStyle(fontSize: _kPlayerWidgetTextStyle.fontSize)),
      ),
    );
  }
}
