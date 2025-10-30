import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';

class TournamentFAQScreen extends StatelessWidget {
  const TournamentFAQScreen({super.key});

  static Route<void> buildRoute(BuildContext context) {
    return buildScreenRoute(context, screen: const TournamentFAQScreen());
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(title: Text(context.l10n.tournamentFAQ)),
      body: Padding(
        padding: Styles.horizontalBodyPadding,
        child: ListView(
          children: [
            Padding(
              padding: Styles.verticalBodyPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.l10n.arenaIsItRated, style: Styles.sectionTitle),
                  const SizedBox(height: 10),
                  Text(context.l10n.arenaSomeRated),
                ],
              ),
            ),
            Padding(
              padding: Styles.verticalBodyPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.l10n.arenaHowAreScoresCalculated, style: Styles.sectionTitle),
                  const SizedBox(height: 10),
                  Text(context.l10n.arenaHowAreScoresCalculatedAnswer),
                ],
              ),
            ),
            Padding(
              padding: Styles.verticalBodyPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.l10n.arenaBerserk, style: Styles.sectionTitle),
                  const SizedBox(height: 10),
                  Text(context.l10n.arenaBerserkAnswer),
                ],
              ),
            ),
            Padding(
              padding: Styles.verticalBodyPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.l10n.arenaHowIsTheWinnerDecided, style: Styles.sectionTitle),
                  const SizedBox(height: 10),
                  Text(context.l10n.arenaHowIsTheWinnerDecidedAnswer),
                ],
              ),
            ),
            Padding(
              padding: Styles.verticalBodyPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.l10n.arenaHowDoesPairingWork, style: Styles.sectionTitle),
                  const SizedBox(height: 10),
                  Text(context.l10n.arenaHowDoesPairingWorkAnswer),
                ],
              ),
            ),
            Padding(
              padding: Styles.verticalBodyPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.l10n.arenaHowDoesItEnd, style: Styles.sectionTitle),
                  const SizedBox(height: 10),
                  Text(context.l10n.arenaHowDoesItEndAnswer),
                ],
              ),
            ),
            Padding(
              padding: Styles.verticalBodyPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.l10n.arenaOtherRules, style: Styles.sectionTitle),
                  const SizedBox(height: 10),
                  Text(context.l10n.arenaThereIsACountdown),
                  const SizedBox(height: 6),
                  Text(context.l10n.arenaDrawingWithinNbMoves(10)),
                  const SizedBox(height: 6),
                  Text(context.l10n.arenaDrawStreakStandard('30')),
                  const SizedBox(height: 6),
                  Text(context.l10n.arenaDrawStreakVariants),
                  DataTable(
                    dataRowMinHeight: 40,
                    dataRowMaxHeight: 70,
                    columns: [
                      DataColumn(label: Text(context.l10n.arenaVariant)),
                      DataColumn(
                        label: Expanded(
                          child: Text(
                            context.l10n.arenaMinimumGameLength,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                    rows: const [
                      DataRow(
                        cells: [DataCell(Text('Standard, Chess960, Horde')), DataCell(Text('30'))],
                      ),
                      DataRow(
                        cells: [
                          DataCell(Text('Antichess, Crazyhouse, King of the Hill')),
                          DataCell(Text('20')),
                        ],
                      ),
                      DataRow(
                        cells: [
                          DataCell(Text('Three-check, Atomic, Racing Kings')),
                          DataCell(Text('10')),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
