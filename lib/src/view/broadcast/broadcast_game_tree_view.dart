import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_game_controller.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
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

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        _OpeningHeader(
          ctrlProvider,
          displayMode: displayMode,
        ),
        DebouncedPgnTreeView(
          root: root,
          currentPath: currentPath,
          broadcastLivePath: broadcastLivePath,
          pgnRootComments: pgnRootComments,
          notifier: ref.read(ctrlProvider.notifier),
        ),
      ],
    );
  }
}

class _OpeningHeader extends ConsumerWidget {
  const _OpeningHeader(this.ctrlProvider, {required this.displayMode});

  final BroadcastGameControllerProvider ctrlProvider;
  final Orientation displayMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isRootNode = ref.watch(
      ctrlProvider.select((s) => s.requireValue.currentNode.isRoot),
    );
    final nodeOpening = ref
        .watch(ctrlProvider.select((s) => s.requireValue.currentNode.opening));
    final branchOpening = ref
        .watch(ctrlProvider.select((s) => s.requireValue.currentBranchOpening));
    final opening = isRootNode
        ? LightOpening(
            eco: '',
            name: context.l10n.startPosition,
          )
        : nodeOpening ?? branchOpening;

    return opening != null
        ? Container(
            height: kOpeningHeaderHeight,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Center(
                child: Text(
                  opening.name,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}
