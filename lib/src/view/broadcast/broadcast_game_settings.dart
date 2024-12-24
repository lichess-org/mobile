import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_preferences.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_game_controller.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/settings/general_preferences.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/analysis/stockfish_settings.dart';
import 'package:lichess_mobile/src/view/opening_explorer/opening_explorer_settings.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform_scaffold.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';

class BroadcastGameSettings extends ConsumerWidget {
  const BroadcastGameSettings(this.roundId, this.gameId, {super.key});

  final BroadcastRoundId roundId;
  final BroadcastGameId gameId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final broacdcastGameAnalysisController = broadcastGameControllerProvider(roundId, gameId);

    final analysisPrefs = ref.watch(analysisPreferencesProvider);
    final isSoundEnabled = ref.watch(
      generalPreferencesProvider.select((pref) => pref.isSoundEnabled),
    );

    return PlatformScaffold(
      appBar: PlatformAppBar(title: Text(context.l10n.settingsSettings)),
      body: ListView(
        children: [
          StockfishSettingsWidget(
            onToggleLocalEvaluation:
                () => ref.read(broacdcastGameAnalysisController.notifier).toggleLocalEvaluation(),
            onSetEngineSearchTime:
                (value) =>
                    ref.read(broacdcastGameAnalysisController.notifier).setEngineSearchTime(value),
            onSetNumEvalLines:
                (value) =>
                    ref.read(broacdcastGameAnalysisController.notifier).setNumEvalLines(value),
            onSetEngineCores:
                (value) =>
                    ref.read(broacdcastGameAnalysisController.notifier).setEngineCores(value),
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
