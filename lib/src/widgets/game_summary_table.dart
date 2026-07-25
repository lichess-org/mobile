import 'dart:math' as math;

import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/game/player.dart';
import 'package:lichess_mobile/src/model/settings/general_preferences.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/user/user_or_profile_screen.dart';
import 'package:url_launcher/url_launcher.dart';

/// A reusable table displaying game summary with player names, result, and analysis statistics.
///
/// Shows player names, game result, accuracy, inaccuracies, mistakes, blunders, and ACPL
/// in a formatted table layout.
class GameSummaryTable extends ConsumerWidget {
  const GameSummaryTable({
    required this.pgnHeaders,
    required this.playersAnalysis,
    this.whiteUser,
    this.blackUser,
    super.key,
  });

  /// PGN headers containing player names, titles, and result
  final IMap<String, String> pgnHeaders;

  /// White and Black player's analysis summary
  final PlayersAnalysis playersAnalysis;

  /// White player's lichess user, when known
  final LightUser? whiteUser;

  /// Black player's lichess user, when known
  final LightUser? blackUser;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = pgnHeaders.get('Result') ?? '';

    final whiteAnalysis = playersAnalysis.white;
    final blackAnalysis = playersAnalysis.black;

    final bool usingCustomBackground = ref.watch(
      generalPreferencesProvider.select(
        (prefs) => prefs.backgroundImage != null || prefs.backgroundColor != null,
      ),
    );

    return Center(
      child: SizedBox(
        width: math.min(MediaQuery.widthOf(context), 500),
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
                  _SummaryPlayerName(.white, pgnHeaders, whiteUser),
                  Center(
                    child: Text(result, style: const TextStyle(fontWeight: .bold)),
                  ),
                  _SummaryPlayerName(.black, pgnHeaders, blackUser),
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
              for (final (whiteText, whiteTextColor, label, blackText, blackTextColor) in [
                if (whiteAnalysis.phases?.opening != null && blackAnalysis.phases?.opening != null)
                  (
                    '${whiteAnalysis.phases!.opening}%',
                    _accuracyColor(whiteAnalysis.phases!.opening!, context),
                    context.l10n.opening,
                    '${blackAnalysis.phases!.opening}%',
                    _accuracyColor(blackAnalysis.phases!.opening!, context),
                  ),
                if (whiteAnalysis.phases?.middlegame != null &&
                    blackAnalysis.phases?.middlegame != null)
                  (
                    '${whiteAnalysis.phases!.middlegame}%',
                    _accuracyColor(whiteAnalysis.phases!.middlegame!, context),
                    context.l10n.middlegame,
                    '${blackAnalysis.phases!.middlegame}%',
                    _accuracyColor(blackAnalysis.phases!.middlegame!, context),
                  ),
                if (whiteAnalysis.phases?.endgame != null && blackAnalysis.phases?.endgame != null)
                  (
                    '${whiteAnalysis.phases!.endgame}%',
                    _accuracyColor(whiteAnalysis.phases!.endgame!, context),
                    context.l10n.endgame,
                    '${blackAnalysis.phases!.endgame}%',
                    _accuracyColor(blackAnalysis.phases!.endgame!, context),
                  ),
              ])
                TableRow(
                  children: [
                    _SummaryNumber(whiteText, color: usingCustomBackground ? null : whiteTextColor),
                    Center(heightFactor: 1.2, child: Text(label, softWrap: true)),
                    _SummaryNumber(blackText, color: usingCustomBackground ? null : blackTextColor),
                  ],
                ),
              for (final (whiteText, label, blackText, color) in [
                (
                  whiteAnalysis.inaccuracies.toString(),
                  context.l10n.numberInaccuracies(2).replaceAll('2', '').trim(),
                  blackAnalysis.inaccuracies.toString(),
                  LichessColors.inaccuracy,
                ),
                (
                  whiteAnalysis.mistakes.toString(),
                  context.l10n.numberMistakes(2).replaceAll('2', '').trim(),
                  blackAnalysis.mistakes.toString(),
                  LichessColors.mistake,
                ),
                (
                  whiteAnalysis.blunders.toString(),
                  context.l10n.numberBlunders(2).replaceAll('2', '').trim(),
                  blackAnalysis.blunders.toString(),
                  LichessColors.blunder,
                ),
              ])
                TableRow(
                  children: [
                    _SummaryNumber(whiteText, color: usingCustomBackground ? null : color),
                    Center(heightFactor: 1.2, child: Text(label, softWrap: true)),
                    _SummaryNumber(blackText, color: usingCustomBackground ? null : color),
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
  const _SummaryNumber(this.data, {this.color});
  final String data;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(data, softWrap: true, style: TextStyle(color: color)),
    );
  }
}

class _SummaryPlayerName extends StatelessWidget {
  const _SummaryPlayerName(this.side, this.pgnHeaders, this.user);
  final Side side;
  final IMap<String, String> pgnHeaders;
  final LightUser? user;

  @override
  Widget build(BuildContext context) {
    final playerTitle = side == .white
        ? pgnHeaders.get('WhiteTitle')
        : pgnHeaders.get('BlackTitle');
    final playerName = side == .white
        ? pgnHeaders.get('White') ?? context.l10n.white
        : pgnHeaders.get('Black') ?? context.l10n.black;

    final brightness = Theme.of(context).brightness;

    final nameText = Text.rich(
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
    );

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
              if (user != null)
                GestureDetector(
                  onTap: () => Navigator.of(context).push(UserOrProfileScreen.buildRoute(user!)),
                  child: nameText,
                )
              else
                nameText,
            ],
          ),
        ),
      ),
    );
  }
}

Color _accuracyColor(int accuracy, BuildContext context) {
  if (accuracy >= 85) {
    return LichessColors.good;
  }
  if (accuracy >= 70) {
    return LichessColors.inaccuracy;
  }

  if (accuracy >= 55) {
    return LichessColors.mistake;
  }
  return LichessColors.blunder;
}
