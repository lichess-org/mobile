import 'package:dartchess/dartchess.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/opening_explorer/opening_explorer.dart';
import 'package:lichess_mobile/src/model/opening_explorer/opening_explorer_preferences.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/user/search_screen.dart';
import 'package:lichess_mobile/src/widgets/list.dart';

class OpeningExplorerSettings extends ConsumerWidget {
  const OpeningExplorerSettings(this.pgn, this.options);

  final String pgn;
  final AnalysisOptions options;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(openingExplorerPreferencesProvider);

    final List<Widget> masterDbSettings = [
      PlatformListTile(
        title: const Text('Timespan'),
        subtitle: Wrap(
          spacing: 5,
          children: MasterDbPrefState.datesMap.keys
              .map(
                (key) => ChoiceChip(
                  label: Text(key),
                  selected: prefs.masterDb.sinceYear ==
                      MasterDbPrefState.datesMap[key],
                  onSelected: (_) => ref
                      .read(openingExplorerPreferencesProvider.notifier)
                      .setMasterDbSince(MasterDbPrefState.datesMap[key]!),
                ),
              )
              .toList(growable: false),
        ),
      ),
    ];

    final List<Widget> lichessDbSettings = [
      PlatformListTile(
        title: Text(context.l10n.timeControl),
        subtitle: Wrap(
          spacing: 5,
          children: LichessDbPrefState.kAvailableSpeeds
              .map(
                (speed) => FilterChip(
                  label: Icon(speed.icon),
                  tooltip: speed.title,
                  selected: prefs.lichessDb.speeds.contains(speed),
                  onSelected: (_) => ref
                      .read(openingExplorerPreferencesProvider.notifier)
                      .toggleLichessDbSpeed(speed),
                ),
              )
              .toList(growable: false),
        ),
      ),
      PlatformListTile(
        title: Text(context.l10n.rating),
        subtitle: Wrap(
          spacing: 5,
          children: LichessDbPrefState.kAvailableRatings
              .map(
                (rating) => FilterChip(
                  label: Text(rating.toString()),
                  tooltip: rating == 400
                      ? '400-1000'
                      : rating == 2500
                          ? '2500+'
                          : '$rating-${rating + 200}',
                  selected: prefs.lichessDb.ratings.contains(rating),
                  onSelected: (_) => ref
                      .read(openingExplorerPreferencesProvider.notifier)
                      .toggleLichessDbRating(rating),
                ),
              )
              .toList(growable: false),
        ),
      ),
      PlatformListTile(
        title: const Text('Timespan'),
        subtitle: Wrap(
          spacing: 5,
          children: LichessDbPrefState.datesMap.keys
              .map(
                (key) => ChoiceChip(
                  label: Text(key),
                  selected:
                      prefs.lichessDb.since == LichessDbPrefState.datesMap[key],
                  onSelected: (_) => ref
                      .read(openingExplorerPreferencesProvider.notifier)
                      .setLichessDbSince(LichessDbPrefState.datesMap[key]!),
                ),
              )
              .toList(growable: false),
        ),
      ),
    ];
    final List<Widget> playerDbSettings = [
      PlatformListTile(
        title: Text.rich(
          TextSpan(
            text: '${context.l10n.player}: ',
            style: const TextStyle(
              fontWeight: FontWeight.normal,
            ),
            children: [
              TextSpan(
                recognizer: TapGestureRecognizer()
                  ..onTap = () => pushPlatformRoute(
                        context,
                        fullscreenDialog: true,
                        builder: (_) => SearchScreen(
                          onUserTap: (user) => {
                            ref
                                .read(
                                  openingExplorerPreferencesProvider.notifier,
                                )
                                .setPlayerDbUsernameOrId(user.name),
                            Navigator.of(context).pop(),
                          },
                        ),
                      ),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  decoration: TextDecoration.underline,
                ),
                text: prefs.playerDb.username ?? 'Select a Lichess player',
              ),
            ],
          ),
        ),
      ),
      PlatformListTile(
        title: Text(context.l10n.side),
        subtitle: Wrap(
          spacing: 5,
          children: Side.values
              .map(
                (side) => ChoiceChip(
                  label: switch (side) {
                    Side.white => const Text('White'),
                    Side.black => const Text('Black'),
                  },
                  selected: prefs.playerDb.side == side,
                  onSelected: (_) => ref
                      .read(openingExplorerPreferencesProvider.notifier)
                      .setPlayerDbSide(side),
                ),
              )
              .toList(growable: false),
        ),
      ),
      PlatformListTile(
        title: Text(context.l10n.timeControl),
        subtitle: Wrap(
          spacing: 5,
          children: PlayerDbPrefState.kAvailableSpeeds
              .map(
                (speed) => FilterChip(
                  label: Icon(speed.icon),
                  tooltip: speed.title,
                  selected: prefs.playerDb.speeds.contains(speed),
                  onSelected: (_) => ref
                      .read(openingExplorerPreferencesProvider.notifier)
                      .togglePlayerDbSpeed(speed),
                ),
              )
              .toList(growable: false),
        ),
      ),
      PlatformListTile(
        title: Text(context.l10n.mode),
        subtitle: Wrap(
          spacing: 5,
          children: GameMode.values
              .map(
                (gameMode) => FilterChip(
                  label: Text(
                    switch (gameMode) {
                      GameMode.casual => 'Casual',
                      GameMode.rated => 'Rated',
                    },
                  ),
                  selected: prefs.playerDb.gameModes.contains(gameMode),
                  onSelected: (_) => ref
                      .read(openingExplorerPreferencesProvider.notifier)
                      .togglePlayerDbGameMode(gameMode),
                ),
              )
              .toList(growable: false),
        ),
      ),
      PlatformListTile(
        title: const Text('Timespan'),
        subtitle: Wrap(
          spacing: 5,
          children: PlayerDbPrefState.datesMap.keys
              .map(
                (key) => ChoiceChip(
                  label: Text(key),
                  selected:
                      prefs.playerDb.since == PlayerDbPrefState.datesMap[key],
                  onSelected: (_) => ref
                      .read(openingExplorerPreferencesProvider.notifier)
                      .setPlayerDbSince(PlayerDbPrefState.datesMap[key]!),
                ),
              )
              .toList(growable: false),
        ),
      ),
    ];

    return ListView(
      shrinkWrap: true,
      children: [
        PlatformListTile(
          title: Text(context.l10n.database),
          subtitle: Wrap(
            spacing: 5,
            children: [
              ChoiceChip(
                label: const Text('Masters'),
                selected: prefs.db == OpeningDatabase.master,
                onSelected: (_) => ref
                    .read(openingExplorerPreferencesProvider.notifier)
                    .setDatabase(OpeningDatabase.master),
              ),
              ChoiceChip(
                label: const Text('Lichess'),
                selected: prefs.db == OpeningDatabase.lichess,
                onSelected: (_) => ref
                    .read(openingExplorerPreferencesProvider.notifier)
                    .setDatabase(OpeningDatabase.lichess),
              ),
              ChoiceChip(
                label: Text(context.l10n.player),
                selected: prefs.db == OpeningDatabase.player,
                onSelected: (_) => ref
                    .read(openingExplorerPreferencesProvider.notifier)
                    .setDatabase(OpeningDatabase.player),
              ),
            ],
          ),
        ),
        ...switch (prefs.db) {
          OpeningDatabase.master => masterDbSettings,
          OpeningDatabase.lichess => lichessDbSettings,
          OpeningDatabase.player => playerDbSettings,
        },
      ],
    );
  }
}
