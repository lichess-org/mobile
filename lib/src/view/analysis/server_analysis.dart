import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_preferences.dart';
import 'package:lichess_mobile/src/model/analysis/server_analysis_service.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/game/player.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/acpl_chart.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/game_summary_table.dart';

class ServerAnalysisSummary extends ConsumerWidget {
  const ServerAnalysisSummary({
    required this.serverAnalysisSource,
    required this.playersAnalysis,
    required this.pgnHeaders,
    required this.acplChartParams,
    required this.onRequestServerAnalysis,
    super.key,
  });

  final ServerAnalysisSource? serverAnalysisSource;

  final PlayersAnalysis? playersAnalysis;

  final IMap<String, String> pgnHeaders;

  final AcplChartParams? acplChartParams;

  final Future<void> Function() onRequestServerAnalysis;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analysisPrefs = ref.watch(analysisPreferencesProvider);

    final currentGameAnalysis = ref.watch(currentAnalysisProvider);

    final bool serverAnalysisAllowed = serverAnalysisSource != null;
    if (analysisPrefs.enableServerAnalysis == false || !serverAnalysisAllowed) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const Spacer(),
              Text(context.l10n.computerAnalysisDisabled),
              if (serverAnalysisAllowed)
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
              if (serverAnalysisSource == currentGameAnalysis)
                const Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: WaitingForServerAnalysis(),
                ),

              if (acplChartParams != null) AcplChart(params: acplChartParams!),
              GameSummaryTable(pgnHeaders: pgnHeaders, playersAnalysis: playersAnalysis!),
            ],
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              if (currentGameAnalysis == serverAnalysisSource)
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
                                            pendingRequest = onRequestServerAnalysis().catchError((
                                              Object e,
                                            ) {
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
