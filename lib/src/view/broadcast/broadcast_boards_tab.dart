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
class BroadcastBoardsTab extends ConsumerWidget {
  const BroadcastBoardsTab({
    required this.tournamentId,
    required this.roundId,
    required this.tournamentSlug,
    required this.showOnlyOngoingGames,
    required this.teamFilter,
  });

  final BroadcastTournamentId tournamentId;
  final BroadcastRoundId roundId;
  final String tournamentSlug;
  final bool showOnlyOngoingGames;
  final String? teamFilter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final round = ref.watch(broadcastRoundControllerProvider(roundId));

    return switch (round) {
      AsyncData(:final value) =>
        value.games.isEmpty
            ? Padding(
                padding: Styles.bodyPadding,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.info, size: 30),
                    const SizedBox(height: 8.0),
                    Text(context.l10n.broadcastNoBoardsYet, textAlign: TextAlign.center),
                  ],
                ),
              )
            : BroadcastPreview(
                games: filteredGames(value.games, showOnlyOngoingGames, teamFilter),
                tournamentId: tournamentId,
                roundId: roundId,
                title: value.round.name,
                tournamentSlug: tournamentSlug,
                roundSlug: value.round.slug,
                customScoring: value.round.customScoring,
                pinnedComment: value.round.pinnedComment,
                teamFilter: teamFilter,
              ),
      AsyncError(:final error) => Center(child: Text('Could not load broadcast: $error')),
      _ => const Center(child: CircularProgressIndicator.adaptive()),
    };
  }

  IList<BroadcastGame> filteredGames(
    IMap<BroadcastGameId, BroadcastGame> games,
    bool showOnlyOngoingGames,
    String? teamFilter,
  ) {
    final ongoingFiltered = showOnlyOngoingGames
        ? games.values.where((game) => game.isOngoing).toIList()
        : games.values.toIList();
    return teamFilter == null
        ? ongoingFiltered
        : ongoingFiltered
              .where(
                (game) => Side.values.map((s) => game.players[s]?.player.team).contains(teamFilter),
              )
              .toIList();
  }
}

class BroadcastPreview extends ConsumerStatefulWidget {
  const BroadcastPreview({
    required this.tournamentId,
    required this.roundId,
    required this.games,
    required this.title,
    required this.tournamentSlug,
    required this.roundSlug,
    required this.customScoring,
    required this.pinnedComment,
    required this.teamFilter,
  });

  // A circular progress indicator is used instead of shimmers currently
  const BroadcastPreview.loading()
    : tournamentId = const BroadcastTournamentId(''),
      roundId = const BroadcastRoundId(''),
      games = null,
      title = '',
      tournamentSlug = '',
      roundSlug = '',
      customScoring = null,
      pinnedComment = null,
      teamFilter = null;

  final BroadcastTournamentId tournamentId;
  final BroadcastRoundId roundId;
  final IList<BroadcastGame>? games;
  final String title;
  final String tournamentSlug;
  final String roundSlug;
  final BroadcastCustomScoring? customScoring;
  final String? pinnedComment;
  final String? teamFilter;
  @override
  ConsumerState<BroadcastPreview> createState() => _BroadcastPreviewState();
}

class _BroadcastPreviewState extends ConsumerState<BroadcastPreview> {
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
    final IList<BroadcastGame>? games = widget.games == null
        ? null
        : _searchQuery.isEmpty
        ? widget.games
        : widget.games!.where((game) => _containsPlayer(game, _searchQuery)).toIList();
    final showSearchBar = widget.games != null && widget.games!.length > 6;
    final hasComment = widget.pinnedComment != null && widget.pinnedComment!.isNotEmpty;
    final mediaQueryPadding = MediaQuery.paddingOf(context);

    return CustomScrollView(
      slivers: [
        if (hasComment)
          SliverSafeArea(
            bottom: false,
            sliver: SliverPadding(
              padding: Styles.bodyPadding.copyWith(bottom: 0.0),
              sliver: SliverToBoxAdapter(child: _PinnedCommentCard(text: widget.pinnedComment!)),
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

              if (games == null) {
                return BoardThumbnail.loading(
                  size: boardSize,
                  header: _PlayerWidgetLoading(width: boardWithMaybeEvalBarWidth),
                  footer: _PlayerWidgetLoading(width: boardWithMaybeEvalBarWidth),
                );
              }

              final game = games[index];
              final playingSide = Setup.parseFen(game.fen).turn;

              return ObservedBoardThumbnail(
                roundId: widget.roundId,
                game: game,
                title: widget.title,
                tournamentId: widget.tournamentId,
                tournamentSlug: widget.tournamentSlug,
                roundSlug: widget.roundSlug,
                showEvaluationGauge: showEvaluationGauges,
                boardSize: boardSize,
                boardWithMaybeEvalBarWidth: boardWithMaybeEvalBarWidth,
                playingSide: playingSide,
                customScoring: widget.customScoring,
                teamFilter: widget.teamFilter,
              );
            }, childCount: games == null ? numberLoadingBoards : games.length),
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

class ObservedBoardThumbnail extends ConsumerStatefulWidget {
  const ObservedBoardThumbnail({
    required this.roundId,
    required this.game,
    required this.title,
    required this.tournamentId,
    required this.tournamentSlug,
    required this.roundSlug,
    required this.showEvaluationGauge,
    required this.boardSize,
    required this.boardWithMaybeEvalBarWidth,
    required this.playingSide,
    required this.customScoring,
    required this.teamFilter,
  });

  final BroadcastRoundId roundId;
  final BroadcastGame game;
  final String title;
  final BroadcastTournamentId tournamentId;
  final String tournamentSlug;
  final String roundSlug;
  final bool showEvaluationGauge;
  final double boardSize;
  final double boardWithMaybeEvalBarWidth;
  final Side playingSide;
  final BroadcastCustomScoring? customScoring;
  final String? teamFilter;

  @override
  ConsumerState<ObservedBoardThumbnail> createState() => _ObservedBoardThumbnailState();
}

class _ObservedBoardThumbnailState extends ConsumerState<ObservedBoardThumbnail> {
  bool isBoardVisible = false;

  @override
  Widget build(BuildContext context) {
    final orientation = widget.teamFilter != null
        ? widget.game.players.entries
                  .firstWhereOrNull((entry) => entry.value.player.team == widget.teamFilter)
                  ?.key ??
              Side.white
        : Side.white;
    return VisibilityDetector(
      key: ValueKey(widget.game.id),
      onVisibilityChanged: (visibilityInfo) {
        if (visibilityInfo.visibleFraction > 0.3) {
          if (!isBoardVisible && context.mounted) {
            ref
                .read(broadcastRoundControllerProvider(widget.roundId).notifier)
                .addObservedGame(widget.game.id);
            setState(() {
              isBoardVisible = true;
            });
          }
        } else {
          if (isBoardVisible && context.mounted) {
            ref
                .read(broadcastRoundControllerProvider(widget.roundId).notifier)
                .removeObservedGame(widget.game.id);
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
              gameId: widget.game.id,
              tournamentSlug: widget.tournamentSlug,
              roundSlug: widget.roundSlug,
              title: widget.title,
            ),
          );
        },
        orientation: orientation,
        fen: widget.game.fen,
        showEvaluationGauge: widget.showEvaluationGauge,
        whiteWinningChances: (widget.game.cp != null || widget.game.mate != null)
            ? ExternalEval(cp: widget.game.cp, mate: widget.game.mate).winningChances(Side.white)
            : null,
        lastMove: widget.game.lastMove,
        size: widget.boardSize,
        header: _PlayerWidget(
          width: widget.boardWithMaybeEvalBarWidth,
          game: widget.game,
          side: orientation.opposite,
          playingSide: widget.playingSide,
          customScoring: widget.customScoring,
        ),
        footer: _PlayerWidget(
          width: widget.boardWithMaybeEvalBarWidth,
          game: widget.game,
          side: orientation,
          playingSide: widget.playingSide,
          customScoring: widget.customScoring,
        ),
      ),
    );
  }
}

class _PlayerWidgetLoading extends StatelessWidget {
  const _PlayerWidgetLoading({required this.width});

  final double width;

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

class _PlayerWidget extends StatelessWidget {
  const _PlayerWidget({
    required this.width,
    required this.game,
    required this.side,
    required this.playingSide,
    required this.customScoring,
  });

  final BroadcastGame game;
  final Side side;
  final Side playingSide;
  final double width;
  final BroadcastCustomScoring? customScoring;

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
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: .bold,
                    color: game.status.colorFor(side, context),
                  ),
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

class _PinnedCommentCard extends StatelessWidget {
  const _PinnedCommentCard({required this.text});

  final String text;

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
