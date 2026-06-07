import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_analysis_controller.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_preferences.dart';
import 'package:lichess_mobile/src/widgets/acpl_chart.dart';
import 'package:lichess_mobile/src/widgets/game_summary_table.dart';

class BroadcastGameSummary extends ConsumerWidget {
  const BroadcastGameSummary(this.controllerParams);

  final BroadcastAnalysisControllerParams controllerParams;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final broadcastPrefs = ref.watch(broadcastPreferencesProvider);
    final ctrlProvider = broadcastAnalysisControllerProvider(controllerParams);
    final analysisState = ref.watch(ctrlProvider).requireValue;

    if (!broadcastPrefs.enableServerAnalysis || analysisState.analysisSummary == null) {
      return const Center(child: Text('No server analysis available'));
    }

    return ListView(
      children: [
        _BroadcastAcplChart(controllerParams: controllerParams),
        _GameSummaryTable(controllerParams: controllerParams),
      ],
    );
  }
}

class _BroadcastAcplChart extends ConsumerWidget {
  const _BroadcastAcplChart({required this.controllerParams});

  final BroadcastAnalysisControllerParams controllerParams;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrlProvider = broadcastAnalysisControllerProvider(controllerParams);
    final state = ref.watch(ctrlProvider).requireValue;
    final acplChartData = state.acplChartData;

    if (acplChartData == null) {
      return const SizedBox.shrink();
    }

    return AcplChart(
      params: (
        acplChartData: acplChartData,
        division: state.analysisSummary!.division,
        rootPly: state.root.position.ply,
        currentNodePly: state.currentNode.position.ply,
        isOnMainline: state.isOnMainline,
        onJumpToNode: (index) {
          ref.read(ctrlProvider.notifier).jumpToNthNodeOnMainline(index);
        },
      ),
    );
  }
}

class _GameSummaryTable extends ConsumerWidget {
  const _GameSummaryTable({required this.controllerParams});

  final BroadcastAnalysisControllerParams controllerParams;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrlProvider = broadcastAnalysisControllerProvider(controllerParams);
    final analysisState = ref.watch(ctrlProvider).requireValue;

    return GameSummaryTable(
      pgnHeaders: analysisState.pgnHeaders,
      playersAnalysis: analysisState.playersAnalysis!,
    );
  }
}
