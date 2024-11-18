import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_game_controller.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/network/connectivity.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/opening_explorer/opening_explorer_screen.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar_button.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';

class BroadcastGameBottomBar extends ConsumerWidget {
  const BroadcastGameBottomBar({
    required this.roundId,
    required this.gameId,
  });

  final BroadcastRoundId roundId;
  final BroadcastGameId gameId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrlProvider = broadcastGameControllerProvider(roundId, gameId);
    final analysisState = ref.watch(ctrlProvider).requireValue;
    final isOnline =
        ref.watch(connectivityChangesProvider).valueOrNull?.isOnline ?? false;

    return BottomBar(
      children: [
        BottomBarButton(
          label: context.l10n.flipBoard,
          onTap: () {
            ref
                .read(
                  ctrlProvider.notifier,
                )
                .toggleBoard();
          },
          icon: CupertinoIcons.arrow_2_squarepath,
        ),
        BottomBarButton(
          label: context.l10n.openingExplorer,
          onTap: isOnline
              ? () {
                  pushPlatformRoute(
                    context,
                    title: context.l10n.openingExplorer,
                    builder: (_) => OpeningExplorerScreen(
                      pgn: ref.read(ctrlProvider.notifier).makeCurrentNodePgn(),
                      options: analysisState.openingExplorerOptions,
                    ),
                  );
                }
              : null,
          icon: Icons.explore,
        ),
        RepeatButton(
          onLongPress:
              analysisState.canGoBack ? () => _moveBackward(ref) : null,
          child: BottomBarButton(
            key: const ValueKey('goto-previous'),
            onTap: analysisState.canGoBack ? () => _moveBackward(ref) : null,
            label: 'Previous',
            icon: CupertinoIcons.chevron_back,
            showTooltip: false,
          ),
        ),
        RepeatButton(
          onLongPress: analysisState.canGoNext ? () => _moveForward(ref) : null,
          child: BottomBarButton(
            key: const ValueKey('goto-next'),
            icon: CupertinoIcons.chevron_forward,
            label: context.l10n.next,
            onTap: analysisState.canGoNext ? () => _moveForward(ref) : null,
            showTooltip: false,
          ),
        ),
      ],
    );
  }

  void _moveForward(WidgetRef ref) => ref
      .read(broadcastGameControllerProvider(roundId, gameId).notifier)
      .userNext();
  void _moveBackward(WidgetRef ref) => ref
      .read(broadcastGameControllerProvider(roundId, gameId).notifier)
      .userPrevious();
}
