import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/analysis/opening_explorer_preferences.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/list.dart';

class OpeningExplorerSettings extends ConsumerWidget {
  const OpeningExplorerSettings(this.pgn, this.options);

  final String pgn;
  final AnalysisOptions options;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final openingDatabase = ref.watch(
      openingExplorerPreferencesProvider.select(
        (state) => state.db,
      ),
    );

    return DraggableScrollableSheet(
      initialChildSize: .7,
      expand: false,
      snap: true,
      snapSizes: const [.7],
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
                  selected: openingDatabase == OpeningDatabase.master,
                  onSelected: (value) => ref
                      .read(openingExplorerPreferencesProvider.notifier)
                      .setDatabase(OpeningDatabase.master),
                ),
                ChoiceChip(
                  label: const Text('Lichess'),
                  selected: openingDatabase == OpeningDatabase.lichess,
                  onSelected: (value) => ref
                      .read(openingExplorerPreferencesProvider.notifier)
                      .setDatabase(OpeningDatabase.lichess),
                ),
                ChoiceChip(
                  label: Text(context.l10n.player),
                  selected: openingDatabase == OpeningDatabase.player,
                  onSelected: (value) => ref
                      .read(openingExplorerPreferencesProvider.notifier)
                      .setDatabase(OpeningDatabase.player),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
