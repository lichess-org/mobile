import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/lobby/game_seek.dart';
import 'package:lichess_mobile/src/model/lobby/game_setup.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/game/lobby_screen.dart';
import 'package:lichess_mobile/src/view/play/time_control_modal.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';

class QuickGameButton extends ConsumerWidget {
  const QuickGameButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playPrefs = ref.watch(gameSetupPreferencesProvider);
    final session = ref.watch(authSessionProvider);

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
                      Icon(playPrefs.timeIncrement.speed.icon),
                      const SizedBox(width: 2.0),
                      Text(playPrefs.timeIncrement.display),
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
                constraints: BoxConstraints(
                  maxHeight: screenHeight - (screenHeight / 10),
                ),
                builder: (BuildContext context) {
                  return TimeControlModal(
                    value: playPrefs.timeIncrement,
                    onSelected: (choice) {
                      ref
                          .read(gameSetupPreferencesProvider.notifier)
                          .setTimeIncrement(choice);
                    },
                  );
                },
              );
            },
          ),
        ),
        if (Theme.of(context).platform == TargetPlatform.android)
          const SizedBox(width: 8.0),
        Expanded(
          flex: kFlexGoldenRatio,
          child: Theme.of(context).platform == TargetPlatform.iOS
              ? CupertinoButton.filled(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4.0,
                    vertical: 16.0,
                  ),
                  onPressed: () {
                    pushPlatformRoute(
                      context,
                      rootNavigator: true,
                      builder: (_) => LobbyScreen(
                        seek: GameSeek.fastPairing(playPrefs, session),
                      ),
                    );
                  },
                  child: Text(context.l10n.studyStart, style: Styles.bold),
                )
              : FilledButton(
                  onPressed: () {
                    pushPlatformRoute(
                      context,
                      rootNavigator: true,
                      builder: (_) => LobbyScreen(
                        seek: GameSeek.fastPairing(playPrefs, session),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(context.l10n.studyStart, style: Styles.bold),
                  ),
                ),
        ),
      ],
    );
  }
}
