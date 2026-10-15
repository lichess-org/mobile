import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_providers.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';

final _dateFormatter = DateFormat.MMMd();

String _formatDates(BroadcastTournamentDates dates) => dates.endsAt == null
    ? _dateFormatter.format(dates.startsAt)
    : '${_dateFormatter.format(dates.startsAt)} - ${_dateFormatter.format(dates.endsAt!)}';

/// The information of a broadcast tournament as text, in the order of the overview sheet cards,
/// without the links.
Iterable<String> broadcastInformationTexts(BroadcastTournamentInformation information) => [
  if (information.dates case final dates?) _formatDates(dates),
  ?information.format,
  ?information.timeControl,
  ?information.location,
  ?information.players,
];

/// Shows the overview of a broadcast tournament in a full height bottom sheet.
Future<void> showBroadcastOverviewSheet(BuildContext context, BroadcastTournamentId tournamentId) {
  return showAdaptiveFullHeightBottomSheet<void>(
    context: context,
    title: _BroadcastOverviewTitle(tournamentId: tournamentId),
    builder: (context, scrollController) =>
        _BroadcastOverview(tournamentId: tournamentId, scrollController: scrollController),
  );
}

class const _BroadcastOverviewTitle({required final BroadcastTournamentId tournamentId})
    extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = ref.watch(
      broadcastTournamentProvider(tournamentId).select((t) => t.value?.data.name),
    );
    return WhenRouteSettled(
      ready: name != null,
      placeholder: const SizedBox.shrink(),
      builder: (context) => Text(name!),
    );
  }
}

class const _BroadcastOverview({
  required final BroadcastTournamentId tournamentId,
  required final ScrollController scrollController,
}) extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tournament = ref.watch(broadcastTournamentProvider(tournamentId));

    return WhenRouteSettled(
      ready: tournament.hasValue || tournament.hasError,
      placeholder: const Center(child: CircularProgressIndicator.adaptive()),
      builder: (context) {
        switch (tournament) {
          case AsyncData(value: final tournament):
            final information = tournament.data.information;
            final description = tournament.data.description;
            return ListView(
              controller: scrollController,
              padding: Styles.bodyPadding.add(
                EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom),
              ),
              children: [
                Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    if (information.dates != null)
                      _BroadcastOverviewCard(
                        CupertinoIcons.calendar,
                        _formatDates(information.dates!),
                      ),
                    if (information.format != null)
                      _BroadcastOverviewCard(Icons.emoji_events, '${information.format}'),
                    if (information.timeControl != null)
                      _BroadcastOverviewCard(
                        CupertinoIcons.stopwatch_fill,
                        '${information.timeControl}',
                      ),
                    if (information.location != null)
                      _BroadcastOverviewCard(Icons.public, '${information.location}'),
                    if (information.players != null)
                      _BroadcastOverviewCard(Icons.person, '${information.players}'),
                    if (information.website != null)
                      _BroadcastOverviewCard(
                        Icons.link,
                        context.l10n.broadcastOfficialWebsite,
                        information.website,
                      ),
                    if (information.standings != null)
                      _BroadcastOverviewCard(
                        Icons.link,
                        context.l10n.broadcastOfficialStandings,
                        information.standings,
                      ),
                  ],
                ),
                if (description != null) ...[
                  const SizedBox(height: 16),
                  MarkdownBody(
                    data: description,
                    onTapLink: (text, url, title) {
                      if (url == null) return;
                      launchUrl(Uri.https('lichess.org').resolve(url));
                    },
                    softLineBreak: true,
                  ),
                ],
              ],
            );
          case AsyncError(:final error):
            return Center(child: Text('Cannot load broadcast data: $error'));
          case _:
            return const Center(child: CircularProgressIndicator.adaptive());
        }
      },
    );
  }
}

class const _BroadcastOverviewCard(final IconData iconData, final String text, [final Uri? website])
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
      margin: const EdgeInsets.all(4.0),
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        onTap: website != null ? () => launchUrl(website!) : null,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(iconData, color: website != null ? ColorScheme.of(context).primary : null),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  text,
                  style: TextStyle(color: website != null ? ColorScheme.of(context).primary : null),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
