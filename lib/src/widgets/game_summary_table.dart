import 'dart:math' as math;

import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/model/game/player.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:url_launcher/url_launcher.dart';

/// A reusable table displaying game summary with player names, result, and analysis statistics.
///
/// Shows player names, game result, accuracy, inaccuracies, mistakes, blunders, and ACPL
/// in a formatted table layout.
class GameSummaryTable extends StatelessWidget {
  const GameSummaryTable({required this.pgnHeaders, required this.playersAnalysis, super.key});

  /// PGN headers containing player names, titles, and result
  final IMap<String, String> pgnHeaders;

  /// White and Black player's analysis summary
  final PlayersAnalysis playersAnalysis;

  @override
  Widget build(BuildContext context) {
    final result = pgnHeaders.get('Result') ?? '';

    final whiteAnalysis = playersAnalysis.white;
    final blackAnalysis = playersAnalysis.black;

    return Center(
      child: SizedBox(
        width: math.min(MediaQuery.sizeOf(context).width, 500),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Table(
            defaultVerticalAlignment: .middle,
            columnWidths: const {
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(1),
              2: FlexColumnWidth(1),
            },
            children: [
              TableRow(
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey)),
                ),
                children: [
                  _SummaryPlayerName(.white, pgnHeaders),
                  Center(
                    child: Text(result, style: const TextStyle(fontWeight: .bold)),
                  ),
                  _SummaryPlayerName(.black, pgnHeaders),
                ],
              ),

              if (whiteAnalysis.accuracy != null && blackAnalysis.accuracy != null)
                TableRow(
                  children: [
                    _SummaryNumber('${whiteAnalysis.accuracy}%'),
                    Center(
                      heightFactor: 1.8,
                      child: InkWell(
                        onTap: () {
                          launchUrl(Uri.parse('https://lichess.org/page/accuracy'));
                        },
                        child: Text.rich(
                          TextSpan(
                            text: context.l10n.accuracy,
                            children: [
                              WidgetSpan(
                                alignment: .middle,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 4.0),
                                  child: Icon(
                                    Icons.info_outline,
                                    size: 16,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          softWrap: true,
                        ),
                      ),
                    ),
                    _SummaryNumber('${blackAnalysis.accuracy}%'),
                  ],
                ),
              for (final item in [
                (
                  whiteAnalysis.inaccuracies.toString(),
                  context.l10n.numberInaccuracies(2).replaceAll('2', '').trim(),
                  blackAnalysis.inaccuracies.toString(),
                ),
                (
                  whiteAnalysis.mistakes.toString(),
                  context.l10n.numberMistakes(2).replaceAll('2', '').trim(),
                  blackAnalysis.mistakes.toString(),
                ),
                (
                  whiteAnalysis.blunders.toString(),
                  context.l10n.numberBlunders(2).replaceAll('2', '').trim(),
                  blackAnalysis.blunders.toString(),
                ),
              ])
                TableRow(
                  children: [
                    _SummaryNumber(item.$1),
                    Center(heightFactor: 1.2, child: Text(item.$2, softWrap: true)),
                    _SummaryNumber(item.$3),
                  ],
                ),
              if (whiteAnalysis.acpl != null && blackAnalysis.acpl != null)
                TableRow(
                  children: [
                    _SummaryNumber(whiteAnalysis.acpl.toString()),
                    Center(
                      heightFactor: 1.5,
                      child: Text(
                        context.l10n.averageCentipawnLoss,
                        softWrap: true,
                        textAlign: .center,
                      ),
                    ),
                    _SummaryNumber(blackAnalysis.acpl.toString()),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryNumber extends StatelessWidget {
  const _SummaryNumber(this.data);
  final String data;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(data, softWrap: true));
  }
}

class _SummaryPlayerName extends StatelessWidget {
  const _SummaryPlayerName(this.side, this.pgnHeaders);
  final Side side;
  final IMap<String, String> pgnHeaders;

  @override
  Widget build(BuildContext context) {
    final playerTitle = side == .white
        ? pgnHeaders.get('WhiteTitle')
        : pgnHeaders.get('BlackTitle');
    final playerName = side == .white
        ? pgnHeaders.get('White') ?? context.l10n.white
        : pgnHeaders.get('Black') ?? context.l10n.black;

    final brightness = Theme.of(context).brightness;

    return TableCell(
      verticalAlignment: .top,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Column(
            children: [
              Icon(
                side == .white
                    ? brightness == .light
                          ? CupertinoIcons.circle
                          : CupertinoIcons.circle_filled
                    : brightness == .light
                    ? CupertinoIcons.circle_filled
                    : CupertinoIcons.circle,
                size: 14,
              ),
              Text.rich(
                TextSpan(
                  children: [
                    if (playerTitle != null)
                      TextSpan(
                        text: '$playerTitle ',
                        style: TextStyle(
                          fontWeight: .bold,
                          color: playerTitle == 'BOT'
                              ? context.lichessColors.fancy
                              : context.lichessColors.brag,
                        ),
                      ),
                    TextSpan(
                      text: playerName,
                      style: const TextStyle(fontWeight: .bold),
                    ),
                  ],
                ),
                textAlign: .center,
                softWrap: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
