import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/lobby/game_seek.dart';
import 'package:lichess_mobile/src/model/lobby/game_setup_preferences.dart';
import 'package:lichess_mobile/src/network/connectivity.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/game/game_screen.dart';
import 'package:lichess_mobile/src/view/play/custom_game_bottom_sheet.dart';
import 'package:lichess_mobile/src/view/play/time_control_modal.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:material_symbols_icons/symbols.dart';

class QuickGameButton extends ConsumerWidget {
  const QuickGameButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playPrefs = ref.watch(gameSetupPreferencesProvider);
    final session = ref.watch(authSessionProvider);
    final isOnline = ref.watch(connectivityChangesProvider).valueOrNull?.isOnline ?? false;
    final isPlayban = ref.watch(accountProvider).valueOrNull?.playban != null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: kFlexGoldenRatioBase,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(side: BorderSide.none),
                icon: const Icon(Icons.access_time),
                label: Text(
                  playPrefs.quickPairingTimeIncrement.display,
                  style: const TextStyle(letterSpacing: 2.0),
                ),
                onPressed: () {
                  final double screenHeight = MediaQuery.sizeOf(context).height;
                  showAdaptiveBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    constraints: BoxConstraints(maxHeight: screenHeight - (screenHeight / 10)),
                    builder: (BuildContext context) {
                      return TimeControlModal(
                        value: playPrefs.quickPairingTimeIncrement,
                        onSelected: (choice) {
                          ref
                              .read(gameSetupPreferencesProvider.notifier)
                              .setQuickPairingTimeIncrement(choice);
                        },
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              flex: kFlexGoldenRatio,
              child: FilledButton.icon(
                icon: const Icon(Symbols.chess_pawn_rounded),
                onPressed:
                    isOnline && !isPlayban
                        ? () {
                          // Pops the play bottom sheet
                          Navigator.of(
                            context,
                          ).popUntil((route) => route is! ModalBottomSheetRoute);
                          Navigator.of(context, rootNavigator: true).push(
                            GameScreen.buildRoute(
                              context,
                              seek: GameSeek.fastPairing(
                                playPrefs.quickPairingTimeIncrement,
                                session,
                              ),
                            ),
                          );
                        }
                        : null,
                label: Text(context.l10n.play),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(flex: kFlexGoldenRatioBase, child: SizedBox.shrink()),
            const SizedBox(width: 8.0),
            Expanded(
              flex: kFlexGoldenRatio,
              child: FilledButton.tonalIcon(
                onPressed:
                    isOnline && !isPlayban
                        ? () {
                          ref.invalidate(accountProvider);
                          showAdaptiveBottomSheet<void>(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) {
                              return const CustomGameBottomSheet();
                            },
                          );
                        }
                        : null,
                icon: const Icon(Icons.tune),
                label: Text(context.l10n.custom),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
