import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/lobby/game_seek.dart';
import 'package:lichess_mobile/src/model/lobby/game_setup_preferences.dart';
import 'package:lichess_mobile/src/network/connectivity.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/game/game_screen.dart';
import 'package:lichess_mobile/src/view/play/common_play_widgets.dart';
import 'package:lichess_mobile/src/view/play/time_control_modal.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/adaptive_choice_picker.dart';

class QuickGameWidget extends ConsumerWidget {
  const QuickGameWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playPrefs = ref.watch(gameSetupPreferencesProvider);
    final session = ref.watch(authSessionProvider);
    final isOnline = ref.watch(connectivityChangesProvider).valueOrNull?.isOnline ?? false;
    final isPlayban = ref.watch(accountProvider).valueOrNull?.playban != null;
    final account = ref.watch(accountProvider).valueOrNull;
    final userPerf = account?.perfs[playPrefs.realTimePerf];
    final canUseRatingRange = userPerf != null && userPerf.provisional != true;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Theme.of(context).dividerColor),
                ),
                icon: Icon(playPrefs.timeIncrement.speed.icon),
                label: Text(
                  playPrefs.timeIncrement.display,
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
                        timeIncrement: playPrefs.timeIncrement,
                        onSelected: (choice) {
                          ref.read(gameSetupPreferencesProvider.notifier).setTimeIncrement(choice);
                        },
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Theme.of(context).dividerColor),
                ),
                icon:
                    playPrefs.customVariant != Variant.standard
                        ? Icon(playPrefs.customVariant.icon)
                        : null,
                label: Text(playPrefs.customVariant.label),
                onPressed: () {
                  showChoicePicker(
                    context,
                    title: Text(context.l10n.variant),
                    choices: [Variant.standard, Variant.chess960],
                    selectedItem: playPrefs.customVariant,
                    labelBuilder: (Variant variant) => Text(variant.label),
                    onSelectedItemChanged: (Variant variant) {
                      ref.read(gameSetupPreferencesProvider.notifier).setCustomVariant(variant);
                    },
                  );
                },
              ),
            ),
          ],
        ),
        if (account != null)
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Theme.of(context).dividerColor),
                  ),
                  onPressed: () {
                    showChoicePicker(
                      context,
                      title: Text(context.l10n.mode),
                      choices: [context.l10n.casual, context.l10n.rated],
                      selectedItem:
                          playPrefs.customRated ? context.l10n.rated : context.l10n.casual,
                      labelBuilder: (String label) => Text(label),
                      onSelectedItemChanged: (String label) {
                        ref
                            .read(gameSetupPreferencesProvider.notifier)
                            .setCustomRated(label == context.l10n.rated);
                      },
                    );
                  },
                  child: Text(playPrefs.customRated ? context.l10n.rated : context.l10n.casual),
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Theme.of(context).dividerColor),
                  ),
                  onPressed:
                      canUseRatingRange
                          ? () {
                            showAdaptiveBottomSheet<void>(
                              context: context,
                              isScrollControlled: true,
                              builder: (BuildContext context) {
                                return BottomSheetScrollableContainer(
                                  padding: const EdgeInsets.only(top: 32.0, bottom: 16.0),
                                  children: [
                                    PlayRatingRange(
                                      perf: userPerf,
                                      ratingDelta: playPrefs.customRatingDelta,
                                      onRatingDeltaChange: (int subtract, int add) {
                                        ref
                                            .read(gameSetupPreferencesProvider.notifier)
                                            .setCustomRatingRange(subtract, add);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                          : null,
                  child:
                      canUseRatingRange
                          ? Text(
                            '${playPrefs.customRatingDelta.$1 == 0 ? '-' : ''}${playPrefs.customRatingDelta.$1} / +${playPrefs.customRatingDelta.$2}',
                          )
                          : const Text('-500 / +500'),
                ),
              ),
            ],
          ),
        FilledButton(
          onPressed:
              isOnline && !isPlayban
                  ? () {
                    // Pops the play bottom sheet
                    Navigator.of(context).popUntil((route) => route is! ModalBottomSheetRoute);
                    Navigator.of(context, rootNavigator: true).push(
                      GameScreen.buildRoute(
                        context,
                        seek: GameSeek.fastPairing(playPrefs.timeIncrement, session),
                      ),
                    );
                  }
                  : null,
          child: Text(context.l10n.createAGame),
        ),
      ],
    );
  }
}
