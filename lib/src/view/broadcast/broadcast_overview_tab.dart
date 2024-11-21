import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_providers.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:url_launcher/url_launcher.dart';

final _dateFormatter = DateFormat.MMMd();

/// A tab that displays the overview of a broadcast.
class BroadcastOverviewTab extends ConsumerWidget {
  final BroadcastTournamentId tournamentId;

  const BroadcastOverviewTab({super.key, required this.tournamentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tournament = ref.watch(broadcastTournamentProvider(tournamentId));

    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        child: Padding(
          padding: Styles.bodyPadding,
          child: switch (tournament) {
            AsyncData(:final value) => BroadcastOverviewBody(value),
            AsyncError(:final error) => Center(
                child: Text('Cannot load game analysis: $error'),
              ),
            _ => const Center(child: CircularProgressIndicator.adaptive()),
          },
        ),
      ),
    );
  }
}

class BroadcastOverviewBody extends StatelessWidget {
  final BroadcastTournament tournament;

  const BroadcastOverviewBody(this.tournament);

  @override
  Widget build(BuildContext context) {
    final information = tournament.data.information;
    final description = tournament.data.description;

    return Column(
      children: [
        Wrap(
          alignment: WrapAlignment.center,
          children: [
            if (information.dates != null)
              BroadcastOverviewCard(
                CupertinoIcons.calendar,
                information.dates!.endsAt == null
                    ? _dateFormatter.format(information.dates!.startsAt)
                    : '${_dateFormatter.format(information.dates!.startsAt)} - ${_dateFormatter.format(information.dates!.endsAt!)}',
              ),
            if (information.format != null)
              BroadcastOverviewCard(
                Icons.emoji_events,
                '${information.format}',
              ),
            if (information.timeControl != null)
              BroadcastOverviewCard(
                CupertinoIcons.stopwatch_fill,
                '${information.timeControl}',
              ),
            if (information.players != null)
              BroadcastOverviewCard(
                Icons.person,
                '${information.players}',
              ),
          ],
        ),
        if (description != null)
          Padding(
            padding: const EdgeInsets.all(16),
            child: MarkdownBody(
              data: description,
              onTapLink: (text, url, title) {
                if (url == null) return;
                launchUrl(Uri.parse(url));
              },
            ),
          ),
      ],
    );
  }
}

class BroadcastOverviewCard extends StatelessWidget {
  final IconData iconData;
  final String text;

  const BroadcastOverviewCard(this.iconData, this.text);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(iconData),
            const SizedBox(width: 10),
            Flexible(child: Text(text)),
          ],
        ),
      ),
    );
  }
}
