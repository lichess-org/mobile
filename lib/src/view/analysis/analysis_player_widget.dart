import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_player.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/duration.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_layout.dart';
import 'package:material_ui/material_ui.dart';

({PgnPlayerWidget? white, PgnPlayerWidget? black}) playerWidgetsFromPgnHeaders({
  required IMap<String, String> pgnHeaders,
  required Side sideToMove,
  required Duration? whiteClock,
  required Duration? blackClock,
}) {
  final whitePlayer = AnalysisPlayer.fromPgnHeaders(pgnHeaders, Side.white);
  final blackPlayer = AnalysisPlayer.fromPgnHeaders(pgnHeaders, Side.black);

  if (whitePlayer != null || blackPlayer != null) {
    final resultString = pgnHeaders.get('Result');
    final result = resultString != null
        ? AnalysisGameResult.resultFromPgnResult(resultString)
        : null;

    return (
      white: whitePlayer != null
          ? PgnPlayerWidget(
              player: whitePlayer,
              result: result,
              isSideToMove: sideToMove == Side.white,
              clock: whiteClock,
            )
          : null,
      black: blackPlayer != null
          ? PgnPlayerWidget(
              player: blackPlayer,
              result: result,
              isSideToMove: sideToMove == Side.black,
              clock: blackClock,
            )
          : null,
    );
  }

  return (white: null, black: null);
}

/// Player widget for PGN imports, displaying analysis player info
class PgnPlayerWidget extends StatelessWidget {
  const PgnPlayerWidget({
    required this.player,
    required this.isSideToMove,
    required this.result,
    this.clock,
  });

  final AnalysisPlayer player;
  final Duration? clock;
  final bool isSideToMove;
  final AnalysisGameResult? result;

  @override
  Widget build(BuildContext context) {
    return AnalysisPlayerWidget(
      side: player.side,
      result: result,
      clock: clock,
      isSideToMove: isSideToMove,
      playerNameWidget: Row(
        children: [
          if (player.title != null) ...[
            Text(
              player.title!,
              style: TextStyle(
                color: (player.title == 'BOT')
                    ? context.lichessColors.fancy
                    : context.lichessColors.brag,
                fontWeight: .bold,
              ),
            ),
            const SizedBox(width: 5),
          ],
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                player.name,
                style: const TextStyle(fontWeight: .bold),
                overflow: .ellipsis,
              ),
              if (player.rating != null) ...[
                const SizedBox(width: 5),
                Text(
                  player.rating.toString(),
                  overflow: .ellipsis,
                  style: TextStyle(fontWeight: FontWeight.w400, color: textShade(context, 0.8)),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class AnalysisPlayerWidget extends StatelessWidget {
  const AnalysisPlayerWidget({
    required this.playerNameWidget,
    required this.result,
    required this.side,
    required this.isSideToMove,
    required this.clock,
  });

  final Widget playerNameWidget;
  final AnalysisGameResult? result;
  final Side side;
  final Duration? clock;
  final bool isSideToMove;

  @override
  Widget build(BuildContext context) {
    final resultString = result?.resultToString(side);
    final colorScheme = ColorScheme.of(context);
    return Container(
      height: kAnalysisBoardHeaderOrFooterHeight,
      padding: const EdgeInsets.only(left: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                if (resultString != null) ...[
                  Text(
                    resultString,
                    style: TextStyle(
                      fontWeight: .bold,
                      color: switch (result!) {
                        AnalysisGameResult.whiteWins =>
                          side == Side.white
                              ? context.lichessColors.good
                              : context.lichessColors.error,
                        AnalysisGameResult.blackWins =>
                          side == Side.white
                              ? context.lichessColors.error
                              : context.lichessColors.good,
                        _ => null,
                      },
                    ),
                  ),
                  const SizedBox(width: 16.0),
                ],
                playerNameWidget,
              ],
            ),
          ),
          if (clock != null)
            Container(
              height: kAnalysisBoardHeaderOrFooterHeight,
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              color: isSideToMove ? colorScheme.secondaryContainer : null,
              child: Center(
                child: Text(
                  clock!.toHoursMinutesSeconds(showTenths: clock! < const Duration(minutes: 1)),
                  style: TextStyle(
                    color: isSideToMove ? colorScheme.onSecondaryContainer : null,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
