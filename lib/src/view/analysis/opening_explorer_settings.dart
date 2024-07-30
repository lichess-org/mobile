import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/analysis/opening_explorer_preferences.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/non_linear_slider.dart';

class OpeningExplorerSettings extends ConsumerWidget {
  const OpeningExplorerSettings(this.pgn, this.options);

  final String pgn;
  final AnalysisOptions options;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(openingExplorerPreferencesProvider);

    const earliestYear = 1952;
    final years = DateTime.now().year - earliestYear + 1;

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
          if (prefs.db == OpeningDatabase.master) ...[
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
                values: List.generate(years, (index) => earliestYear + index),
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
                values: List.generate(years, (index) => earliestYear + index),
                onChangeEnd: (value) => ref
                    .read(openingExplorerPreferencesProvider.notifier)
                    .setMasterDbUntil(value.toInt()),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
