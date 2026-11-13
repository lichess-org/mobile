import 'package:intl/intl.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/string.dart';
import 'package:material_ui/material_ui.dart';

const _shadeOpacity = 0.7;
const _valueStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 22);

String _formatPercentage(int value, int total) =>
    NumberFormat.percentPattern().format(total == 0 ? 0 : value / total);

/// A card with the number of games and how many were won, drawn and lost.
///
/// When [onTap] is set, the card shows a chevron: it usually opens the list of games.
class const GameResultsCard({
  required final int total,
  required final int won,
  required final int drawn,
  required final int lost,
  final VoidCallback? onTap,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final shade = textShade(context, _shadeOpacity);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(context.l10n.perfStatTotalGames, style: TextStyle(color: shade)),
                  ),
                  if (onTap != null)
                    Icon(
                      Icons.chevron_right,
                      color: shade,
                      semanticLabel: context.l10n.perfStatViewTheGames,
                    ),
                ],
              ),
              Text(
                NumberFormat.decimalPattern(Intl.getCurrentLocale()).format(total),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              const SizedBox(height: 12.0),
              _ResultsBar(won: won, drawn: drawn, lost: lost),
              const SizedBox(height: 16.0),
              IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                      child: _ResultCount(
                        label: context.l10n.wins,
                        count: won,
                        total: total,
                        color: context.lichessColors.green,
                      ),
                    ),
                    const VerticalDivider(width: 24.0),
                    Expanded(
                      child: _ResultCount(label: context.l10n.draws, count: drawn, total: total),
                    ),
                    const VerticalDivider(width: 24.0),
                    Expanded(
                      child: _ResultCount(
                        label: context.l10n.losses,
                        count: lost,
                        total: total,
                        color: context.lichessColors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A bar split in won, drawn and lost games, proportionally to their count.
class const _ResultsBar({required final int won, required final int drawn, required final int lost})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final segments = [
      (won, context.lichessColors.green),
      (drawn, textShade(context, 0.3)),
      (lost, context.lichessColors.red),
    ].where((segment) => segment.$1 > 0);
    return ExcludeSemantics(
      child: SizedBox(
        height: 8.0,
        child: Row(
          crossAxisAlignment: .stretch,
          spacing: 3.0,
          children: segments.isEmpty
              ? [Expanded(child: StatBarSegment(textShade(context, 0.15)))]
              : [
                  for (final (count, color) in segments)
                    Expanded(flex: count, child: StatBarSegment(color)),
                ],
        ),
      ),
    );
  }
}

/// A rounded segment of a stat bar, filling its parent.
class const StatBarSegment(final Color? color, {super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(Radius.circular(4.0)),
      ),
    );
  }
}

class const _ResultCount({
  required final String label,
  required final int count,
  required final int total,
  final Color? color,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final shadedStyle = TextStyle(color: textShade(context, _shadeOpacity));
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(label, style: shadedStyle, maxLines: 1, overflow: .ellipsis),
        FittedBox(
          fit: .scaleDown,
          alignment: .centerLeft,
          child: Text(
            count.toString().localizeNumbers(),
            maxLines: 1,
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: color),
          ),
        ),
        Text(_formatPercentage(count, total), style: shadedStyle),
      ],
    );
  }
}

/// A card with an icon, a label, a value and an optional caption below the value.
class const IconStatCard({
  required final IconData icon,
  required final String label,
  required final String value,
  final String? caption,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final shadedStyle = TextStyle(color: textShade(context, _shadeOpacity));
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: .start,
          spacing: 12.0,
          children: [
            Icon(icon, color: textShade(context, _shadeOpacity)),
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(label, style: shadedStyle),
                  const SizedBox(height: 4.0),
                  Text(value, style: _valueStyle),
                  if (caption != null) Text(caption!, style: shadedStyle),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A row of a stats card: an icon, a label with an optional [subtitle] below it, and a value with
/// an optional [valueCaption] below it.
///
/// Rows are meant to be stacked in a [Card], separated by dividers.
class const IconStatRow({
  required final IconData icon,
  required final String label,
  required final String value,
  final Widget? subtitle,
  final String? valueCaption,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        spacing: 12.0,
        children: [
          Icon(icon, color: textShade(context, _shadeOpacity)),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(label, style: TextStyle(color: textShade(context, _shadeOpacity))),
                ?subtitle,
              ],
            ),
          ),
          Column(
            crossAxisAlignment: .end,
            children: [
              Text(value, style: Styles.sectionTitle),
              if (valueCaption != null)
                Text(
                  valueCaption!,
                  style: TextStyle(fontSize: 12.0, color: textShade(context, _shadeOpacity)),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
