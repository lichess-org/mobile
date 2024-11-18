import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_game_controller.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/widgets/pgn.dart';

const kOpeningHeaderHeight = 32.0;

class BroadcastGameTreeView extends ConsumerWidget {
  const BroadcastGameTreeView(
    this.roundId,
    this.gameId,
    this.displayMode,
  );

  final BroadcastRoundId roundId;
  final BroadcastGameId gameId;
  final Orientation displayMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrlProvider = broadcastGameControllerProvider(roundId, gameId);

    final root =
        ref.watch(ctrlProvider.select((value) => value.requireValue.root));
    final currentPath = ref
        .watch(ctrlProvider.select((value) => value.requireValue.currentPath));
    final broadcastLivePath = ref.watch(
      ctrlProvider.select((value) => value.requireValue.broadcastLivePath),
    );
    final pgnRootComments = ref.watch(
      ctrlProvider.select((value) => value.requireValue.pgnRootComments),
    );

    return SingleChildScrollView(
      child: DebouncedPgnTreeView(
        root: root,
        currentPath: currentPath,
        broadcastLivePath: broadcastLivePath,
        pgnRootComments: pgnRootComments,
        notifier: ref.read(ctrlProvider.notifier),
      ),
    );
  }
}
