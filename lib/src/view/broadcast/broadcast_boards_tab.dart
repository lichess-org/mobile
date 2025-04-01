import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_preferences.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_round_controller.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/duration.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/screen.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_game_screen.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_player_widget.dart';
import 'package:lichess_mobile/src/widgets/board_thumbnail.dart';
import 'package:lichess_mobile/src/widgets/clock.dart';
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
  });

  final BroadcastTournamentId tournamentId;
  final BroadcastRoundId roundId;
  final String tournamentSlug;
  final bool showOnlyOngoingGames;

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
              games:
                  showOnlyOngoingGames
                      ? value.games.values.where((game) => game.isOngoing).toIList()
                      : value.games.values.toIList(),
              tournamentId: tournamentId,
              roundId: roundId,
              title: value.round.name,
              tournamentSlug: tournamentSlug,
              roundSlug: value.round.slug,
            ),
      AsyncError(:final error) => Center(
        child: Center(child: Text('Could not load broadcast: $error')),
      ),
      _ => const Center(child: CircularProgressIndicator.adaptive()),
    };
  }
}

class BroadcastPreview extends ConsumerWidget {
  const BroadcastPreview({
    required this.tournamentId,
    required this.roundId,
    required this.games,
    required this.title,
    required this.tournamentSlug,
    required this.roundSlug,
  });

  // A circular progress indicator is used instead of shimmers currently
  const BroadcastPreview.loading()
    : tournamentId = const BroadcastTournamentId(''),
      roundId = const BroadcastRoundId(''),
      games = null,
      title = '',
      tournamentSlug = '',
      roundSlug = '';

  final BroadcastTournamentId tournamentId;
  final BroadcastRoundId roundId;
  final IList<BroadcastGame>? games;
  final String title;
  final String tournamentSlug;
  final String roundSlug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showEvaluationBar = ref.watch(
      broadcastPreferencesProvider.select((value) => value.showEvaluationBar),
    );
    const numberLoadingBoards = 12;
    const boardSpacing = 10.0;
    // height of the text based on the font size
    // since the TextStyle is defined with an height at 1.0, this is the real height
    // see: https://api.flutter.dev/flutter/painting/TextStyle/height.html
    final textHeight = _kPlayerWidgetTextStyle.fontSize!;
    final headerAndFooterHeight = textHeight + _kPlayerWidgetPadding.vertical;
    final numberOfBoardsByRow = isTabletOrLarger(context) ? 3 : 2;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final boardWithMaybeEvalBarWidth =
        (screenWidth -
            Styles.horizontalBodyPadding.horizontal -
            (numberOfBoardsByRow - 1) * boardSpacing) /
        numberOfBoardsByRow;

    return GridView.builder(
      padding: MediaQuery.paddingOf(context).add(Styles.bodyPadding),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: numberOfBoardsByRow,
        crossAxisSpacing: boardSpacing,
        mainAxisSpacing: boardSpacing,
        mainAxisExtent: boardWithMaybeEvalBarWidth + 2 * headerAndFooterHeight,
        childAspectRatio: 1 + boardThumbnailEvalGaugeAspectRatio,
      ),
      itemCount: games == null ? numberLoadingBoards : games!.length,
      itemBuilder: (context, index) {
        final boardSize =
            boardWithMaybeEvalBarWidth -
            (showEvaluationBar
                ? boardThumbnailEvalGaugeAspectRatio * boardWithMaybeEvalBarWidth
                : 0);

        if (games == null) {
          return BoardThumbnail.loading(
            size: boardSize,
            header: _PlayerWidgetLoading(width: boardWithMaybeEvalBarWidth),
            footer: _PlayerWidgetLoading(width: boardWithMaybeEvalBarWidth),
          );
        }

        final game = games![index];
        final playingSide = Setup.parseFen(game.fen).turn;

        return ObservedBoardThumbnail(
          roundId: roundId,
          game: game,
          title: title,
          tournamentId: tournamentId,
          tournamentSlug: tournamentSlug,
          roundSlug: roundSlug,
          showEvaluationBar: showEvaluationBar,
          boardSize: boardSize,
          boardWithMaybeEvalBarWidth: boardWithMaybeEvalBarWidth,
          playingSide: playingSide,
        );
      },
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
    required this.showEvaluationBar,
    required this.boardSize,
    required this.boardWithMaybeEvalBarWidth,
    required this.playingSide,
  });

  final BroadcastRoundId roundId;
  final BroadcastGame game;
  final String title;
  final BroadcastTournamentId tournamentId;
  final String tournamentSlug;
  final String roundSlug;
  final bool showEvaluationBar;
  final double boardSize;
  final double boardWithMaybeEvalBarWidth;
  final Side playingSide;

  @override
  ConsumerState<ObservedBoardThumbnail> createState() => _ObservedBoardThumbnailState();
}

class _ObservedBoardThumbnailState extends ConsumerState<ObservedBoardThumbnail> {
  bool isBoardVisible = false;

  @override
  Widget build(BuildContext context) {
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
              context,
              tournamentId: widget.tournamentId,
              roundId: widget.roundId,
              gameId: widget.game.id,
              tournamentSlug: widget.tournamentSlug,
              roundSlug: widget.roundSlug,
              title: widget.title,
            ),
          );
        },
        orientation: Side.white,
        fen: widget.game.fen,
        showEvaluationBar: widget.showEvaluationBar,
        whiteWinningChances:
            (widget.game.cp != null || widget.game.mate != null)
                ? ExternalEval(
                  cp: widget.game.cp,
                  mate: widget.game.mate,
                ).winningChances(Side.white)
                : null,
        lastMove: widget.game.lastMove,
        size: widget.boardSize,
        header: _PlayerWidget(
          width: widget.boardWithMaybeEvalBarWidth,
          game: widget.game,
          side: Side.black,
          playingSide: widget.playingSide,
        ),
        footer: _PlayerWidget(
          width: widget.boardWithMaybeEvalBarWidth,
          game: widget.game,
          side: Side.white,
          playingSide: widget.playingSide,
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
  });

  final BroadcastGame game;
  final Side side;
  final Side playingSide;
  final double width;

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
                  game.status.resultToString(side),
                  style: const TextStyle().copyWith(fontWeight: FontWeight.bold),
                )
              else if (clock != null)
                CountdownClockBuilder(
                  timeLeft: clock,
                  active: isClockActive,
                  builder:
                      (context, timeLeft) => Text(
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
