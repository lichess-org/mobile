import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_analysis_controller.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_preferences.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/widgets/acpl_chart.dart';
import 'package:lichess_mobile/src/widgets/game_summary_table.dart';

class BroadcastGameSummary extends ConsumerWidget {
  const BroadcastGameSummary({
    required this.roundId,
    required this.gameId,
    this.analysisSummary,
    super.key,
  });

  final BroadcastRoundId roundId;
  final BroadcastGameId gameId;
  final BroadcastAnalysisSummary? analysisSummary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final broadcastPrefs = ref.watch(broadcastPreferencesProvider);
    final ctrlProvider = broadcastAnalysisControllerProvider((roundId: roundId, gameId: gameId));
    final analysisState = ref.watch(ctrlProvider).requireValue;

    if (!broadcastPrefs.enableServerAnalysis || analysisState.analysisSummary == null) {
      return const Center(child: Text('No server analysis available'));
    }

    return ListView(
      children: [
        _BroadcastAcplChart(roundId: roundId, gameId: gameId),
        _GameSummaryTable(roundId: roundId, gameId: gameId),
      ],
    );
  }
}

class _BroadcastAcplChart extends ConsumerWidget {
  const _BroadcastAcplChart({required this.roundId, required this.gameId});

  final BroadcastRoundId roundId;
  final BroadcastGameId gameId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrlProvider = broadcastAnalysisControllerProvider((roundId: roundId, gameId: gameId));
    final state = ref.watch(ctrlProvider).requireValue;
    final acplChartData = state.acplChartData;

    if (acplChartData == null) {
      return const SizedBox.shrink();
    }

    return AcplChart(
      acplChartData: acplChartData,
      division: state.analysisSummary!.division,
      rootPly: state.root.position.ply,
      currentNodePly: state.currentNode.position.ply,
      isOnMainline: state.isOnMainline,
      onJumpToNode: (index) {
        ref.read(ctrlProvider.notifier).jumpToNthNodeOnMainline(index);
      },
    );
  }
}

class _GameSummaryTable extends ConsumerWidget {
  const _GameSummaryTable({required this.roundId, required this.gameId});

  final BroadcastRoundId roundId;
  final BroadcastGameId gameId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrlProvider = broadcastAnalysisControllerProvider((roundId: roundId, gameId: gameId));
    final analysisState = ref.watch(ctrlProvider).requireValue;
    final summary = analysisState.analysisSummary!;

    return GameSummaryTable(
      pgnHeaders: analysisState.pgnHeaders,
      whiteSummary: (
        accuracy: summary.white.accuracy,
        inaccuracies: summary.white.inaccuracies,
        mistakes: summary.white.mistakes,
        blunders: summary.white.blunders,
        acpl: summary.white.acpl,
      ),
      blackSummary: (
        accuracy: summary.black.accuracy,
        inaccuracies: summary.black.inaccuracies,
        mistakes: summary.black.mistakes,
        blunders: summary.black.blunders,
        acpl: summary.black.acpl,
      ),
    );
  }
}
