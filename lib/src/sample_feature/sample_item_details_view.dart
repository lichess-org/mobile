import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

/// Displays detailed information about a SampleItem.
class SampleItemDetailsView extends StatelessWidget {
  const SampleItemDetailsView({super.key});

  static const routeName = '/sample_item';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).puzzles),
      ),
      body: Column(
        children: [
          Text(AppLocalizations.of(context).nbPlayed(3)),
          Text(AppLocalizations.of(context).fromXGamesFound('2', '42430')),
          Text(AppLocalizations.of(context).nbPointsBelowYourPuzzleRating(2)),
          Text(AppLocalizations.of(context).nbPointsBelowYourPuzzleRating(1)),
          Text(AppLocalizations.of(context).nbPlayed(1)),
        ],
      ),
    );
  }
}
