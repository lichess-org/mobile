import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_preferences.dart';
import 'package:lichess_mobile/src/model/analysis/server_analysis_service.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/game/player.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/acpl_chart.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/game_summary_table.dart';
import 'package:lichess_mobile/src/widgets/move_times_chart.dart';
import 'package:material_ui/material_ui.dart';

class ServerAnalysisSummary extends ConsumerWidget {
  const ServerAnalysisSummary({
    required this.serverAnalysisSource,
    required this.playersAnalysis,
    required this.pgnHeaders,
    required this.acplChartParams,
    required this.moveTimesChartParams,
    required this.onRequestServerAnalysis,
    this.whiteUser,
    this.blackUser,
    super.key,
  });

  final ServerAnalysisSource? serverAnalysisSource;

  final PlayersAnalysis? playersAnalysis;

  final IMap<String, String> pgnHeaders;

  final LightUser? whiteUser;

  final LightUser? blackUser;

  final AcplChartParams? acplChartParams;

  /// Move times of the game, if it was played with a clock.
  ///
  /// Unlike [acplChartParams] this does not depend on a server analysis, so the chart is shown
  /// whatever the state of the computer analysis.
  final MoveTimesChartParams? moveTimesChartParams;

  final Future<void> Function() onRequestServerAnalysis;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analysisPrefs = ref.watch(analysisPreferencesProvider);

    final currentGameAnalysis = ref.watch(currentAnalysisProvider);

    final serverAnalysisAllowed = serverAnalysisSource != null;

    final moveTimesChart = moveTimesChartParams != null
        ? MoveTimesChart(params: moveTimesChartParams!)
        : null;

    // The move times chart needs no server analysis, so it is appended below whatever the tab
    // shows: the computer analysis, or the button to request one.
    Widget layout(Widget content) => moveTimesChart == null
        ? Center(child: content)
        : ListView(
            children: [
              Padding(padding: const EdgeInsets.symmetric(vertical: 16.0), child: content),
              moveTimesChart,
            ],
          );

    if (analysisPrefs.enableServerAnalysis == false || !serverAnalysisAllowed) {
      return layout(
        Column(
          mainAxisSize: .min,
          children: [
            Text(context.l10n.computerAnalysisDisabled),
            if (serverAnalysisAllowed)
              FilledButton.tonal(
                onPressed: () {
                  ref.read(analysisPreferencesProvider.notifier).toggleServerAnalysis();
                },
                child: Text(context.l10n.enable),
              ),
          ],
        ),
      );
    }

    if (playersAnalysis != null) {
      return ListView(
        children: [
          if (serverAnalysisSource == currentGameAnalysis)
            const Padding(padding: EdgeInsets.only(top: 16.0), child: WaitingForServerAnalysis()),
          if (acplChartParams != null) AcplChart(params: acplChartParams!),
          GameSummaryTable(
            pgnHeaders: pgnHeaders,
            playersAnalysis: playersAnalysis!,
            whiteUser: whiteUser,
            blackUser: blackUser,
          ),
          if (moveTimesChart != null) moveTimesChart,
        ],
      );
    }

    if (currentGameAnalysis == serverAnalysisSource) {
      return layout(const WaitingForServerAnalysis());
    }

    return layout(
      Builder(
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
                            showSnackBar(context, context.l10n.youNeedAnAccountToDoThat);
                          }
                        : snapshot.connectionState == ConnectionState.waiting
                        ? null
                        : () {
                            setState(() {
                              pendingRequest = onRequestServerAnalysis().catchError((Object e) {
                                if (context.mounted) {
                                  showSnackBar(context, e.toString(), type: SnackBarType.error);
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
        Image.asset('assets/images/stockfish/icon.webp', width: 30, height: 30),
        const SizedBox(width: 8.0),
        Text(context.l10n.waitingForAnalysis),
        const SizedBox(width: 8.0),
        const CircularProgressIndicator.adaptive(),
      ],
    );
  }
}
