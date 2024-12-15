import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_game_controller.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_repository.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/game_share_service.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/share.dart';
import 'package:lichess_mobile/src/widgets/adaptive_action_sheet.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar_button.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';

class BroadcastGameBottomBar extends ConsumerWidget {
  const BroadcastGameBottomBar({
    required this.roundId,
    required this.gameId,
    required this.broadcastTitle,
    required this.roundTitle,
  });

  final BroadcastRoundId roundId;
  final BroadcastGameId gameId;
  final String broadcastTitle;
  final String roundTitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrlProvider = broadcastGameControllerProvider(roundId, gameId);
    final broadcastGameState = ref.watch(ctrlProvider).requireValue;

    return BottomBar(
      children: [
        BottomBarButton(
          label: context.l10n.menu,
          onTap: () {
            showAdaptiveActionSheet<void>(
              context: context,
              actions: [
                BottomSheetAction(
                  makeLabel: (context) => Text(context.l10n.mobileShareGameURL),
                  onPressed: (context) async {
                    launchShareDialog(
                      context,
                      uri: lichessUri(
                        '/broadcast/${broadcastTitle.toLowerCase().replaceAll(' ', '-')}/${roundTitle.toLowerCase().replaceAll(' ', '-')}/$roundId/$gameId',
                      ),
                    );
                  },
                ),
                BottomSheetAction(
                  makeLabel: (context) => Text(context.l10n.mobileShareGamePGN),
                  onPressed: (context) async {
                    try {
                      final pgn = await ref.withClient(
                        (client) => BroadcastRepository(client).getGamePgn(roundId, gameId),
                      );
                      if (context.mounted) {
                        launchShareDialog(context, text: pgn);
                      }
                    } catch (e) {
                      if (context.mounted) {
                        showPlatformSnackbar(
                          context,
                          'Failed to get PGN',
                          type: SnackBarType.error,
                        );
                      }
                    }
                  },
                ),
                BottomSheetAction(
                  makeLabel: (context) => const Text('GIF'),
                  onPressed: (_) async {
                    try {
                      final gif = await ref
                          .read(gameShareServiceProvider)
                          .chapterGif(roundId, gameId);
                      if (context.mounted) {
                        launchShareDialog(context, files: [gif]);
                      }
                    } catch (e) {
                      debugPrint(e.toString());
                      if (context.mounted) {
                        showPlatformSnackbar(
                          context,
                          'Failed to get GIF',
                          type: SnackBarType.error,
                        );
                      }
                    }
                  },
                ),
              ],
            );
          },
          icon:
              Theme.of(context).platform == TargetPlatform.iOS ? CupertinoIcons.share : Icons.share,
        ),
        BottomBarButton(
          label: context.l10n.flipBoard,
          onTap: () {
            ref.read(ctrlProvider.notifier).toggleBoard();
          },
          icon: CupertinoIcons.arrow_2_squarepath,
        ),
        RepeatButton(
          onLongPress: broadcastGameState.canGoBack ? () => _moveBackward(ref) : null,
          child: BottomBarButton(
            key: const ValueKey('goto-previous'),
            onTap: broadcastGameState.canGoBack ? () => _moveBackward(ref) : null,
            label: 'Previous',
            icon: CupertinoIcons.chevron_back,
            showTooltip: false,
          ),
        ),
        RepeatButton(
          onLongPress: broadcastGameState.canGoNext ? () => _moveForward(ref) : null,
          child: BottomBarButton(
            key: const ValueKey('goto-next'),
            icon: CupertinoIcons.chevron_forward,
            label: context.l10n.next,
            onTap: broadcastGameState.canGoNext ? () => _moveForward(ref) : null,
            showTooltip: false,
          ),
        ),
      ],
    );
  }

  void _moveForward(WidgetRef ref) =>
      ref.read(broadcastGameControllerProvider(roundId, gameId).notifier).userNext();
  void _moveBackward(WidgetRef ref) =>
      ref.read(broadcastGameControllerProvider(roundId, gameId).notifier).userPrevious();
}
