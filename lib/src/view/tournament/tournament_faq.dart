import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:material_ui/material_ui.dart';

/// Shows the arena tournaments FAQ in a full height bottom sheet.
Future<void> showTournamentFaqSheet(BuildContext context) {
  return showAdaptiveFullHeightBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    title: Text(context.l10n.tournamentFAQ),
    builder: (context, scrollController) => _TournamentFaq(scrollController: scrollController),
  );
}

class const _TournamentFaq({required final ScrollController scrollController})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: scrollController,
      padding: Styles.horizontalBodyPadding.add(
        EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom),
      ),
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
              Text(context.l10n.arenaHowArePlayersPaired, style: Styles.sectionTitle),
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
                rows: [
                  DataRow(
                    cells: [
                      DataCell(
                        Text(
                          _variantLabels(context, [
                            Variant.standard,
                            Variant.chess960,
                            Variant.horde,
                          ]),
                        ),
                      ),
                      const DataCell(Text('30')),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(
                        Text(
                          _variantLabels(context, [
                            Variant.antichess,
                            Variant.crazyhouse,
                            Variant.kingOfTheHill,
                          ]),
                        ),
                      ),
                      const DataCell(Text('20')),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(
                        Text(
                          _variantLabels(context, [
                            Variant.threeCheck,
                            Variant.atomic,
                            Variant.racingKings,
                          ]),
                        ),
                      ),
                      const DataCell(Text('10')),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

String _variantLabels(BuildContext context, Iterable<Variant> variants) =>
    variants.map((variant) => variant.label(context.l10n)).join(', ');
