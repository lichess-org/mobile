import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:url_launcher/url_launcher.dart';

final _dateFormatter = DateFormat.MMMd(Intl.getCurrentLocale());

/// A tab that displays the overview of a broadcast.
class BroadcastOverviewTab extends StatelessWidget {
  final Broadcast broadcast;

  const BroadcastOverviewTab(this.broadcast);

  @override
  Widget build(BuildContext context) {
    final tourInformation = broadcast.tour.information;

    return Column(
      children: [
        Wrap(
          alignment: WrapAlignment.center,
          children: [
            if (tourInformation.dates != null)
              BroadcastOverviewCard(
                CupertinoIcons.calendar,
                tourInformation.dates!.endsAt == null
                    ? _dateFormatter.format(tourInformation.dates!.startsAt)
                    : '${_dateFormatter.format(tourInformation.dates!.startsAt)} - ${_dateFormatter.format(tourInformation.dates!.endsAt!)}',
              ),
            if (tourInformation.format != null)
              BroadcastOverviewCard(
                Icons.emoji_events,
                '${tourInformation.format}',
              ),
            if (tourInformation.timeControl != null)
              BroadcastOverviewCard(
                CupertinoIcons.stopwatch_fill,
                '${tourInformation.timeControl}',
              ),
            if (tourInformation.players != null)
              BroadcastOverviewCard(
                Icons.person,
                '${tourInformation.players}',
              ),
          ],
        ),
        Expanded(
          child: Markdown(
            data: broadcast.tour.description,
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
