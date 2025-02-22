import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_providers.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:url_launcher/url_launcher.dart';

final _dateFormatter = DateFormat.MMMd();

/// A tab that displays the overview of a broadcast.
class BroadcastOverviewTab extends ConsumerWidget {
  const BroadcastOverviewTab({required this.broadcast, required this.tournamentId, super.key});

  final Broadcast broadcast;
  final BroadcastTournamentId tournamentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tournament = ref.watch(broadcastTournamentProvider(tournamentId));

    switch (tournament) {
      case AsyncData(value: final tournament):
        final information = tournament.data.information;
        final description = tournament.data.description;
        return ListView(
          padding: MediaQuery.paddingOf(context).add(Styles.bodyPadding),
          children: [
            if (tournament.data.imageUrl != null) ...[
              Image.network(tournament.data.imageUrl!),
              const SizedBox(height: 16.0),
            ],
            Wrap(
              alignment: WrapAlignment.center,
              children: [
                if (information.dates != null)
                  _BroadcastOverviewCard(
                    CupertinoIcons.calendar,
                    information.dates!.endsAt == null
                        ? _dateFormatter.format(information.dates!.startsAt)
                        : '${_dateFormatter.format(information.dates!.startsAt)} - ${_dateFormatter.format(information.dates!.endsAt!)}',
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
                    context.l10n.broadcastStandings,
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
              ),
            ],
          ],
        );
      case AsyncError(:final error):
        return Center(
          child: ListView(
            shrinkWrap: true,
            children: [Center(child: Text('Cannot load broadcast data: $error'))],
          ),
        );
      case _:
        return Center(
          child: ListView(
            shrinkWrap: true,
            children: const [Center(child: CircularProgressIndicator.adaptive())],
          ),
        );
    }
  }
}

class _BroadcastOverviewCard extends StatelessWidget {
  const _BroadcastOverviewCard(this.iconData, this.text, [this.website]);

  final IconData iconData;
  final String text;
  final Uri? website;

  @override
  Widget build(BuildContext context) {
    return PlatformCard(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      margin: const EdgeInsets.all(4.0),
      child: AdaptiveInkWell(
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
