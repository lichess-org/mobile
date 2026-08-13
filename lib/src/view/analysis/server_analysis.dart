import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_preferences.dart';
import 'package:lichess_mobile/src/model/analysis/server_analysis_service.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/game/player.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
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
        ? Column(
            crossAxisAlignment: .stretch,
            children: [
              _SectionHeader(context.l10n.moveTimes),
              MoveTimesChart(params: moveTimesChartParams!),
            ],
          )
        : null;

    // The move times chart needs no server analysis, so it is appended below whatever the tab
    // shows: the computer analysis, or the button to request one.
    //
    // Without a server analysis the space the eval chart would take is reserved and the content
    // centred in it, so the button keeps floating in the middle of that area instead of being
    // pushed against the top of the chart below it.
    Widget layout(Widget content) => moveTimesChart == null
        ? Center(child: content)
        : ListView(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: AspectRatio(aspectRatio: 2.5, child: Center(child: content)),
                ),
              ),
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
          if (acplChartParams != null) ...[
            _SectionHeader(context.l10n.computerAnalysis),
            AcplChart(params: acplChartParams!),
          ],
          _SectionHeader(context.l10n.stats),
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

/// Title of one of the blocks stacked in the computer analysis tab, to tell them apart.
class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 4.0),
      child: Text(title, style: Styles.sectionTitle),
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
