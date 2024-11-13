import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_preferences.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_game_controller.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_service.dart';
import 'package:lichess_mobile/src/model/settings/general_preferences.dart';
import 'package:lichess_mobile/src/model/study/study_preferences.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/non_linear_slider.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';

class BroadcastGameSettings extends ConsumerWidget {
  const BroadcastGameSettings(this.roundId, this.gameId);

  final BroadcastRoundId roundId;
  final BroadcastGameId gameId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final broacdcastGameAnalysisController =
        broadcastGameControllerProvider(roundId, gameId);

    final isLocalEvaluationAllowed = ref.watch(
      broacdcastGameAnalysisController
          .select((s) => s.requireValue.isLocalEvaluationAllowed),
    );
    final isEngineAvailable = ref.watch(
      broacdcastGameAnalysisController
          .select((s) => s.requireValue.isEngineAvailable),
    );

    final analysisPrefs = ref.watch(analysisPreferencesProvider);
    final studyPrefs = ref.watch(studyPreferencesProvider);
    final isSoundEnabled = ref.watch(
      generalPreferencesProvider.select((pref) => pref.isSoundEnabled),
    );

    return BottomSheetScrollableContainer(
      children: [
        SwitchSettingTile(
          title: Text(context.l10n.toggleLocalEvaluation),
          value: analysisPrefs.enableLocalEvaluation,
          onChanged: isLocalEvaluationAllowed
              ? (_) {
                  ref
                      .read(broacdcastGameAnalysisController.notifier)
                      .toggleLocalEvaluation();
                }
              : null,
        ),
        PlatformListTile(
          title: Text.rich(
            TextSpan(
              text: '${context.l10n.multipleLines}: ',
              style: const TextStyle(
                fontWeight: FontWeight.normal,
              ),
              children: [
                TextSpan(
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  text: analysisPrefs.numEvalLines.toString(),
                ),
              ],
            ),
          ),
          subtitle: NonLinearSlider(
            value: analysisPrefs.numEvalLines,
            values: const [0, 1, 2, 3],
            onChangeEnd: isEngineAvailable
                ? (value) => ref
                    .read(broacdcastGameAnalysisController.notifier)
                    .setNumEvalLines(value.toInt())
                : null,
          ),
        ),
        if (maxEngineCores > 1)
          PlatformListTile(
            title: Text.rich(
              TextSpan(
                text: '${context.l10n.cpus}: ',
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                ),
                children: [
                  TextSpan(
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    text: analysisPrefs.numEngineCores.toString(),
                  ),
                ],
              ),
            ),
            subtitle: NonLinearSlider(
              value: analysisPrefs.numEngineCores,
              values: List.generate(maxEngineCores, (index) => index + 1),
              onChangeEnd: isEngineAvailable
                  ? (value) => ref
                      .read(broacdcastGameAnalysisController.notifier)
                      .setEngineCores(value.toInt())
                  : null,
            ),
          ),
        SwitchSettingTile(
          title: Text(context.l10n.bestMoveArrow),
          value: analysisPrefs.showBestMoveArrow,
          onChanged: isEngineAvailable
              ? (value) => ref
                  .read(analysisPreferencesProvider.notifier)
                  .toggleShowBestMoveArrow()
              : null,
        ),
        SwitchSettingTile(
          title: Text(context.l10n.showVariationArrows),
          value: studyPrefs.showVariationArrows,
          onChanged: (value) => ref
              .read(studyPreferencesProvider.notifier)
              .toggleShowVariationArrows(),
        ),
        SwitchSettingTile(
          title: Text(context.l10n.evaluationGauge),
          value: analysisPrefs.showEvaluationGauge,
          onChanged: (value) => ref
              .read(analysisPreferencesProvider.notifier)
              .toggleShowEvaluationGauge(),
        ),
        SwitchSettingTile(
          title: Text(context.l10n.toggleGlyphAnnotations),
          value: analysisPrefs.showAnnotations,
          onChanged: (_) => ref
              .read(analysisPreferencesProvider.notifier)
              .toggleAnnotations(),
        ),
        SwitchSettingTile(
          title: Text(context.l10n.mobileShowComments),
          value: analysisPrefs.showPgnComments,
          onChanged: (_) => ref
              .read(analysisPreferencesProvider.notifier)
              .togglePgnComments(),
        ),
        SwitchSettingTile(
          title: Text(context.l10n.sound),
          value: isSoundEnabled,
          onChanged: (value) {
            ref.read(generalPreferencesProvider.notifier).toggleSoundEnabled();
          },
        ),
      ],
    );
  }
}
