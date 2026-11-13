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
class const PgnPlayerWidget({
  required final AnalysisPlayer player,
  required final bool isSideToMove,
  required final AnalysisGameResult? result,
  final Duration? clock,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnalysisPlayerWidget(
      side: player.side,
      result: result,
      clock: clock,
      isSideToMove: isSideToMove,
      playerNameWidget: Row(
        mainAxisSize: MainAxisSize.min,
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
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Only the name shrinks, with an ellipsis, when the header is too narrow.
                Flexible(
                  child: Text(
                    player.name,
                    style: const TextStyle(fontWeight: .bold),
                    maxLines: 1,
                    overflow: .ellipsis,
                  ),
                ),
                if (player.rating != null) ...[
                  const SizedBox(width: 5),
                  Text(
                    player.rating.toString(),
                    style: TextStyle(fontWeight: FontWeight.w400, color: textShade(context, 0.8)),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class const AnalysisPlayerWidget({
  required final Widget playerNameWidget,
  required final AnalysisGameResult? result,
  required final Side side,
  required final bool isSideToMove,
  required final Duration? clock,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final resultString = result?.resultToString(side);
    final colorScheme = ColorScheme.of(context);
    return SizedBox(
      height: kAnalysisBoardHeaderOrFooterHeight,
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
                              ? context.lichessColors.green
                              : context.lichessColors.red,
                        AnalysisGameResult.blackWins =>
                          side == Side.white
                              ? context.lichessColors.red
                              : context.lichessColors.green,
                        _ => null,
                      },
                    ),
                  ),
                  const SizedBox(width: 16.0),
                ],
                Flexible(child: playerNameWidget),
              ],
            ),
          ),
          if (clock != null)
            Container(
              height: kAnalysisBoardHeaderOrFooterHeight - kAnalysisBoardInnerMargin * 2,
              margin: const EdgeInsets.symmetric(vertical: kAnalysisBoardInnerMargin),
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              decoration: BoxDecoration(
                color: isSideToMove ? colorScheme.secondaryContainer : null,
                borderRadius: Styles.boardBorderRadius,
              ),
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
