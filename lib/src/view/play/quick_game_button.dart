import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/lobby/game_seek.dart';
import 'package:lichess_mobile/src/model/lobby/game_setup_preferences.dart';
import 'package:lichess_mobile/src/network/connectivity.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/game/game_screen.dart';
import 'package:lichess_mobile/src/view/play/time_control_modal.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';

class QuickGameButton extends ConsumerWidget {
  const QuickGameButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playPrefs = ref.watch(gameSetupPreferencesProvider);
    final session = ref.watch(authSessionProvider);
    final isOnline = ref.watch(connectivityChangesProvider).valueOrNull?.isOnline ?? false;

    return Row(
      children: [
        Flexible(
          flex: kFlexGoldenRatioBase,
          child: AdaptiveTextButton(
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(playPrefs.quickPairingTimeIncrement.speed.icon),
                      const SizedBox(width: 2.0),
                      Text(playPrefs.quickPairingTimeIncrement.display),
                    ],
                  ),
                  const Icon(Icons.keyboard_arrow_down),
                ],
              ),
            ),
            onPressed: () {
              final double screenHeight = MediaQuery.sizeOf(context).height;
              showAdaptiveBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                showDragHandle: true,
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
        if (Theme.of(context).platform == TargetPlatform.android) const SizedBox(width: 8.0),
        Expanded(
          flex: kFlexGoldenRatio,
          child:
              Theme.of(context).platform == TargetPlatform.iOS
                  ? CupertinoButton.tinted(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
                    onPressed:
                        isOnline
                            ? () {
                              pushPlatformRoute(
                                context,
                                rootNavigator: true,
                                builder:
                                    (_) => GameScreen(
                                      seek: GameSeek.fastPairing(
                                        playPrefs.quickPairingTimeIncrement,
                                        session,
                                      ),
                                    ),
                              );
                            }
                            : null,
                    child: Text(context.l10n.play, style: Styles.bold),
                  )
                  : FilledButton(
                    onPressed:
                        isOnline
                            ? () {
                              pushPlatformRoute(
                                context,
                                rootNavigator: true,
                                builder:
                                    (_) => GameScreen(
                                      seek: GameSeek.fastPairing(
                                        playPrefs.quickPairingTimeIncrement,
                                        session,
                                      ),
                                    ),
                              );
                            }
                            : null,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(context.l10n.play, style: Styles.bold),
                    ),
                  ),
        ),
      ],
    );
  }
}
