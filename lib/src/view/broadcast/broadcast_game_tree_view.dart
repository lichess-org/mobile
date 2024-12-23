import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_preferences.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_game_controller.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/widgets/pgn.dart';

const kOpeningHeaderHeight = 32.0;

class BroadcastGameTreeView extends ConsumerWidget {
  const BroadcastGameTreeView(this.roundId, this.gameId);

  final BroadcastRoundId roundId;
  final BroadcastGameId gameId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrlProvider = broadcastGameControllerProvider(roundId, gameId);
    final broadcastGameState = ref.watch(ctrlProvider).requireValue;

    final analysisPrefs = ref.watch(analysisPreferencesProvider);

    return SingleChildScrollView(
      child: DebouncedPgnTreeView(
        root: broadcastGameState.root,
        currentPath: broadcastGameState.currentPath,
        broadcastLivePath: broadcastGameState.broadcastLivePath,
        pgnRootComments: broadcastGameState.pgnRootComments,
        shouldShowAnnotations: analysisPrefs.showAnnotations,
        notifier: ref.read(ctrlProvider.notifier),
      ),
    );
  }
}
