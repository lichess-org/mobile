import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_preferences.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_analysis_controller.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/settings/general_preferences.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/analysis/stockfish_settings.dart';
import 'package:lichess_mobile/src/view/opening_explorer/opening_explorer_settings.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform_scaffold.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';

class BroadcastGameSettings extends ConsumerWidget {
  const BroadcastGameSettings(this.roundId, this.gameId);

  final BroadcastRoundId roundId;
  final BroadcastGameId gameId;

  static Route<dynamic> buildRoute(
    BuildContext context, {
    required BroadcastRoundId roundId,
    required BroadcastGameId gameId,
  }) {
    return buildScreenRoute(
      context,
      screen: BroadcastGameSettings(roundId, gameId),
      title: context.l10n.settingsSettings,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = broadcastAnalysisControllerProvider(roundId, gameId);

    final analysisPrefs = ref.watch(analysisPreferencesProvider);
    final isSoundEnabled = ref.watch(
      generalPreferencesProvider.select((pref) => pref.isSoundEnabled),
    );

    return PlatformThemedScaffold(
      appBar: PlatformAppBar(title: Text(context.l10n.settingsSettings)),
      body: ListView(
        children: [
          StockfishSettingsWidget(
            onToggleLocalEvaluation: () => ref.read(controller.notifier).toggleLocalEvaluation(),
            onSetEngineSearchTime:
                (value) => ref.read(controller.notifier).setEngineSearchTime(value),
            onSetNumEvalLines: (value) => ref.read(controller.notifier).setNumEvalLines(value),
            onSetEngineCores: (value) => ref.read(controller.notifier).setEngineCores(value),
          ),
          ListSection(
            children: [
              SwitchSettingTile(
                title: Text(context.l10n.toggleGlyphAnnotations),
                value: analysisPrefs.showAnnotations,
                onChanged:
                    (_) => ref.read(analysisPreferencesProvider.notifier).toggleAnnotations(),
              ),
              SwitchSettingTile(
                title: Text(context.l10n.mobileShowComments),
                value: analysisPrefs.showPgnComments,
                onChanged:
                    (_) => ref.read(analysisPreferencesProvider.notifier).togglePgnComments(),
              ),
            ],
          ),
          ListSection(
            children: [
              PlatformListTile(
                title: Text(context.l10n.openingExplorer),
                onTap:
                    () => showAdaptiveBottomSheet<void>(
                      context: context,
                      isScrollControlled: true,
                      showDragHandle: true,
                      isDismissible: true,
                      builder: (_) => const OpeningExplorerSettings(),
                    ),
              ),
              SwitchSettingTile(
                title: Text(context.l10n.sound),
                value: isSoundEnabled,
                onChanged: (value) {
                  ref.read(generalPreferencesProvider.notifier).toggleSoundEnabled();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
