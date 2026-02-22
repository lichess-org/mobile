import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_preferences.dart';
import 'package:lichess_mobile/src/model/analysis/server_analysis_service.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/acpl_chart.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/game_summary_table.dart';

class ServerAnalysisSummary extends ConsumerWidget {
  const ServerAnalysisSummary(this.options, {super.key});

  final AnalysisOptions options;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analysisPrefs = ref.watch(analysisPreferencesProvider);
    final ctrlProvider = analysisControllerProvider(options);

    final analysisState = ref.watch(ctrlProvider).requireValue;
    final playersAnalysis = analysisState.playersAnalysis;
    final canShowGameSummary = analysisState.canShowGameSummary;
    final pgnHeaders = ref.watch(ctrlProvider.select((value) => value.requireValue.pgnHeaders));
    final currentGameAnalysis = ref.watch(currentAnalysisProvider);

    if (analysisPrefs.enableServerAnalysis == false || !canShowGameSummary) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const Spacer(),
              Text(context.l10n.computerAnalysisDisabled),
              if (canShowGameSummary)
                FilledButton.tonal(
                  onPressed: () {
                    ref.read(analysisPreferencesProvider.notifier).toggleServerAnalysis();
                  },
                  child: Text(context.l10n.enable),
                ),
              const Spacer(),
            ],
          ),
        ),
      );
    }

    return playersAnalysis != null
        ? ListView(
            children: [
              if (currentGameAnalysis == options.gameId)
                const Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: WaitingForServerAnalysis(),
                ),

              _AnalysisAcplChart(options),
              GameSummaryTable(
                pgnHeaders: pgnHeaders,
                whiteSummary: (
                  accuracy: playersAnalysis.white.accuracy,
                  inaccuracies: playersAnalysis.white.inaccuracies,
                  mistakes: playersAnalysis.white.mistakes,
                  blunders: playersAnalysis.white.blunders,
                  acpl: playersAnalysis.white.acpl,
                ),
                blackSummary: (
                  accuracy: playersAnalysis.black.accuracy,
                  inaccuracies: playersAnalysis.black.inaccuracies,
                  mistakes: playersAnalysis.black.mistakes,
                  blunders: playersAnalysis.black.blunders,
                  acpl: playersAnalysis.black.acpl,
                ),
              ),
            ],
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              if (currentGameAnalysis == options.gameId)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: WaitingForServerAnalysis(),
                  ),
                )
              else
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Builder(
                      builder: (context) {
                        Future<void>? pendingRequest;
                        return StatefulBuilder(
                          builder: (context, setState) {
                            return FutureBuilder<void>(
                              future: pendingRequest,
                              builder: (context, snapshot) {
                                return FilledButton.tonal(
                                  onPressed: ref.watch(authControllerProvider) == null
                                      ? () {
                                          showSnackBar(
                                            context,
                                            context.l10n.youNeedAnAccountToDoThat,
                                          );
                                        }
                                      : snapshot.connectionState == ConnectionState.waiting
                                      ? null
                                      : () {
                                          setState(() {
                                            pendingRequest = ref
                                                .read(ctrlProvider.notifier)
                                                .requestServerAnalysis()
                                                .catchError((Object e) {
                                                  if (context.mounted) {
                                                    showSnackBar(
                                                      context,
                                                      e.toString(),
                                                      type: SnackBarType.error,
                                                    );
                                                  }
                                                });
                                          });
                                        },
                                  child: Text(context.l10n.requestAComputerAnalysis),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              const Spacer(),
            ],
          );
  }
}

class WaitingForServerAnalysis extends StatelessWidget {
  const WaitingForServerAnalysis({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Image.asset('assets/images/stockfish/icon.png', width: 30, height: 30),
        const SizedBox(width: 8.0),
        Text(context.l10n.waitingForAnalysis),
        const SizedBox(width: 8.0),
        const CircularProgressIndicator.adaptive(),
      ],
    );
  }
}

class _AnalysisAcplChart extends ConsumerWidget {
  const _AnalysisAcplChart(this.options);

  final AnalysisOptions options;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(analysisControllerProvider(options)).requireValue;
    final acplChartData = state.acplChartData;

    if (acplChartData == null) {
      return const SizedBox.shrink();
    }

    return AcplChart(
      acplChartData: acplChartData,
      division: state.division,
      rootPly: state.root.position.ply,
      currentNodePly: state.currentNode.position.ply,
      isOnMainline: state.isOnMainline,
      onJumpToNode: (index) {
        ref.read(analysisControllerProvider(options).notifier).jumpToNthNodeOnMainline(index);
      },
    );
  }
}
