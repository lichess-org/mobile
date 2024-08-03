import 'package:dartchess/dartchess.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/opening_explorer/opening_explorer.dart';
import 'package:lichess_mobile/src/model/opening_explorer/opening_explorer_preferences.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/user/player_screen.dart';
import 'package:lichess_mobile/src/view/user/search_screen.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/non_linear_slider.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';

class OpeningExplorerSettings extends ConsumerWidget {
  const OpeningExplorerSettings(this.pgn, this.options);

  final String pgn;
  final AnalysisOptions options;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(openingExplorerPreferencesProvider);

    final years = DateTime.now().year - MasterDbPrefState.earliestYear + 1;

    final List<Widget> masterDbSettings = [
      PlatformListTile(
        title: Text.rich(
          TextSpan(
            text: '${context.l10n.since}: ',
            style: const TextStyle(
              fontWeight: FontWeight.normal,
            ),
            children: [
              TextSpan(
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                text: prefs.masterDb.sinceYear.toString(),
              ),
            ],
          ),
        ),
        subtitle: NonLinearSlider(
          value: prefs.masterDb.sinceYear,
          values: List.generate(
            years,
            (index) => MasterDbPrefState.earliestYear + index,
          ),
          onChangeEnd: (value) => ref
              .read(openingExplorerPreferencesProvider.notifier)
              .setMasterDbSince(value.toInt()),
        ),
      ),
      PlatformListTile(
        title: Text.rich(
          TextSpan(
            text: '${context.l10n.until}: ',
            style: const TextStyle(
              fontWeight: FontWeight.normal,
            ),
            children: [
              TextSpan(
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                text: prefs.masterDb.untilYear.toString(),
              ),
            ],
          ),
        ),
        subtitle: NonLinearSlider(
          value: prefs.masterDb.untilYear,
          values: List.generate(
            years,
            (index) => MasterDbPrefState.earliestYear + index,
          ),
          onChangeEnd: (value) => ref
              .read(openingExplorerPreferencesProvider.notifier)
              .setMasterDbUntil(value.toInt()),
        ),
      ),
    ];

    final List<Widget> lichessDbSettings = [
      PlatformListTile(
        title: Text(context.l10n.timeControl),
        subtitle: Wrap(
          spacing: 5,
          children: LichessDbPrefState.availableSpeeds
              .map(
                (speed) => FilterChip(
                  label: Icon(speed.icon),
                  tooltip: speed.title,
                  selected: prefs.lichessDb.speeds.contains(speed),
                  onSelected: (value) => ref
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
          children: LichessDbPrefState.availableRatings
              .map(
                (rating) => FilterChip(
                  label: Text(rating.toString()),
                  tooltip: rating == 0
                      ? '0-1000'
                      : rating == 2500
                          ? '2500+'
                          : '$rating-${rating + 200}',
                  selected: prefs.lichessDb.ratings.contains(rating),
                  onSelected: (value) => ref
                      .read(openingExplorerPreferencesProvider.notifier)
                      .toggleLichessDbRating(rating),
                ),
              )
              .toList(growable: false),
        ),
      ),
      DatePickerSettingsTile(
        title: context.l10n.since,
        value: prefs.lichessDb.since,
        firstDate: LichessDbPrefState.earliestDate,
        onChanged: (value) => ref
            .read(openingExplorerPreferencesProvider.notifier)
            .setLichessDbSince(value),
      ),
      DatePickerSettingsTile(
        title: context.l10n.until,
        value: prefs.lichessDb.until,
        firstDate: LichessDbPrefState.earliestDate,
        onChanged: (value) => ref
            .read(openingExplorerPreferencesProvider.notifier)
            .setLichessDbUntil(value),
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
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                text: prefs.playerDb.usernameOrId,
              ),
            ],
          ),
        ),
        subtitle: PlatformWidget(
          androidBuilder: (context) => SearchBar(
            leading: const Icon(Icons.search),
            hintText: context.l10n.searchSearch,
            focusNode: AlwaysDisabledFocusNode(),
            onTap: () => pushPlatformRoute(
              context,
              fullscreenDialog: true,
              builder: (_) => SearchScreen(
                onUserTap: (user) => {
                  ref
                      .read(openingExplorerPreferencesProvider.notifier)
                      .setPlayerDbUsernameOrId(user.name),
                  Navigator.of(context).pop(),
                },
              ),
            ),
          ),
          iosBuilder: (context) => CupertinoSearchTextField(
            placeholder: context.l10n.searchSearch,
            focusNode: AlwaysDisabledFocusNode(),
            onTap: () => pushPlatformRoute(
              context,
              fullscreenDialog: true,
              builder: (_) => SearchScreen(
                onUserTap: (user) => {
                  ref
                      .read(openingExplorerPreferencesProvider.notifier)
                      .setPlayerDbUsernameOrId(user.name),
                  Navigator.of(context).pop(),
                },
              ),
            ),
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
                  onSelected: (value) => ref
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
          children: PlayerDbPrefState.availableSpeeds
              .map(
                (speed) => FilterChip(
                  label: Icon(speed.icon),
                  tooltip: speed.title,
                  selected: prefs.playerDb.speeds.contains(speed),
                  onSelected: (value) => ref
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
          children: Mode.values
              .map(
                (mode) => FilterChip(
                  label: Text(mode.title),
                  selected: prefs.playerDb.modes.contains(mode),
                  onSelected: (value) => ref
                      .read(openingExplorerPreferencesProvider.notifier)
                      .togglePlayerDbMode(mode),
                ),
              )
              .toList(growable: false),
        ),
      ),
      DatePickerSettingsTile(
        title: context.l10n.since,
        value: prefs.playerDb.since,
        firstDate: PlayerDbPrefState.earliestDate,
        onChanged: (value) => ref
            .read(openingExplorerPreferencesProvider.notifier)
            .setPlayerDbSince(value),
      ),
      DatePickerSettingsTile(
        title: context.l10n.until,
        value: prefs.playerDb.until,
        firstDate: PlayerDbPrefState.earliestDate,
        onChanged: (value) => ref
            .read(openingExplorerPreferencesProvider.notifier)
            .setPlayerDbUntil(value),
      ),
    ];

    return DraggableScrollableSheet(
      initialChildSize: .8,
      expand: false,
      snap: true,
      snapSizes: const [.8],
      builder: (context, scrollController) => ListView(
        controller: scrollController,
        children: [
          PlatformListTile(
            title:
                Text(context.l10n.settingsSettings, style: Styles.sectionTitle),
            subtitle: const SizedBox.shrink(),
          ),
          const SizedBox(height: 8.0),
          PlatformListTile(
            title: Text(context.l10n.database),
            subtitle: Wrap(
              spacing: 5,
              children: [
                ChoiceChip(
                  label: const Text('Masters'),
                  selected: prefs.db == OpeningDatabase.master,
                  onSelected: (value) => ref
                      .read(openingExplorerPreferencesProvider.notifier)
                      .setDatabase(OpeningDatabase.master),
                ),
                ChoiceChip(
                  label: const Text('Lichess'),
                  selected: prefs.db == OpeningDatabase.lichess,
                  onSelected: (value) => ref
                      .read(openingExplorerPreferencesProvider.notifier)
                      .setDatabase(OpeningDatabase.lichess),
                ),
                ChoiceChip(
                  label: Text(context.l10n.player),
                  selected: prefs.db == OpeningDatabase.player,
                  onSelected: (value) => ref
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
      ),
    );
  }
}
