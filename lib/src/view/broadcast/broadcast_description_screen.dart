import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';

class BroadcastDescriptionScreen extends StatelessWidget {
  final Broadcast broadcast;

  const BroadcastDescriptionScreen({super.key, required this.broadcast});

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _androidBuilder,
      iosBuilder: _iosBuilder,
    );
  }

  Widget _androidBuilder(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.broadcastBroadcasts),
      ),
      body: _Body(broadcast: broadcast),
    );
  }

  Widget _iosBuilder(
    BuildContext context,
  ) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(context.l10n.broadcastBroadcasts),
      ),
      child: _Body(
        broadcast: broadcast,
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final Broadcast broadcast;
  const _Body({required this.broadcast});

  @override
  Widget build(BuildContext context) {
    final currentLocale = Intl.getCurrentLocale();
    final dateFormatter = DateFormat.yMMMd(currentLocale).add_jm();

    return Padding(
      padding: Styles.bodySectionPadding,
      child: Column(
        children: [
          Text(
            broadcast.tour.name,
            style: Styles.title,
          ),
          const SizedBox(height: 10),
          Text(
            broadcast.tour.description,
            style: Styles.subtitle,
          ),
          const SizedBox(height: 10),
          Text(
            '${context.l10n.broadcastStartDate}: ${dateFormatter.format(broadcast.rounds.first.startsAt)}',
            style: Styles.subtitle,
          ),
        ],
      ),
    );
  }
}
