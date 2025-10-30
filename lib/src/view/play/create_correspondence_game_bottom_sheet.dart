import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/game.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/lobby/create_game_service.dart';
import 'package:lichess_mobile/src/model/lobby/game_seek.dart';
import 'package:lichess_mobile/src/model/lobby/game_setup_preferences.dart';
import 'package:lichess_mobile/src/model/lobby/lobby_repository.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/play/common_play_widgets.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/adaptive_choice_picker.dart';
import 'package:lichess_mobile/src/widgets/expanded_section.dart';
import 'package:lichess_mobile/src/widgets/non_linear_slider.dart';

class CreateCorrespondenceGameBottomSheet extends ConsumerStatefulWidget {
  const CreateCorrespondenceGameBottomSheet({super.key});

  @override
  ConsumerState<CreateCorrespondenceGameBottomSheet> createState() =>
      _CreateGameBodyState();
}

class _CreateGameBodyState
    extends ConsumerState<CreateCorrespondenceGameBottomSheet> {
  Future<void>? _pendingCreateGame;

  @override
  Widget build(BuildContext context) {
    final accountAsync = ref.watch(accountProvider);
    final preferences = ref.watch(gameSetupPreferencesProvider);

    switch (accountAsync) {
      case AsyncError():
        return const Center(child: Text('Could not load account data.'));
      case AsyncData(value: final account):
        final userPerf = account?.perfs[Perf.correspondence];
        return BottomSheetScrollableContainer(
          padding: Styles.bodyPadding,
          children: [
            Builder(
              builder: (context) {
                int daysPerTurn = preferences.customDaysPerTurn;
                return StatefulBuilder(
                  builder: (context, setState) {
                    return ListTile(
                      title: Text.rich(
                        TextSpan(
                          text: '${context.l10n.daysPerTurn}: ',
                          children: [
                            TextSpan(
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                              text: _daysLabel(daysPerTurn),
                            ),
                          ],
                        ),
                      ),
                      subtitle: NonLinearSlider(
                        value: daysPerTurn,
                        values: kAvailableDaysPerTurn,
                        labelBuilder: _daysLabel,
                        onChange: (num value) {
                          setState(() {
                            daysPerTurn = value.toInt();
                          });
                        },
                        onChangeEnd: (num value) {
                          setState(() {
                            daysPerTurn = value.toInt();
                          });
                          ref
                              .read(gameSetupPreferencesProvider.notifier)
                              .setCustomDaysPerTurn(value.toInt());
                        },
                      ),
                    );
                  },
                );
              },
            ),
            ListTile(
              title: Text(context.l10n.variant),
              trailing: TextButton(
                onPressed: () {
                  showChoicePicker(
                    context,
                    choices: [Variant.standard, Variant.chess960],
                    selectedItem: preferences.customVariant,
                    labelBuilder: (Variant variant) => Text(variant.label),
                    onSelectedItemChanged: (Variant variant) {
                      ref
                          .read(gameSetupPreferencesProvider.notifier)
                          .setCustomVariant(variant);
                    },
                  );
                },
                child: Text(preferences.customVariant.label),
              ),
            ),
            ExpandedSection(
              expand: preferences.customRated == false,
              child: ListTile(
                title: Text(context.l10n.side),
                trailing: TextButton(
                  onPressed: null,
                  child: Text(SideChoice.random.label(context.l10n)),
                ),
              ),
            ),
            if (account != null)
              ListTile(
                title: Text(context.l10n.rated),
                trailing: Switch.adaptive(
                  value: preferences.customRated,
                  onChanged: (bool value) {
                    ref
                        .read(gameSetupPreferencesProvider.notifier)
                        .setCustomRated(value);
                  },
                ),
              ),
            if (userPerf != null)
              PlayRatingRange(
                perf: userPerf,
                ratingDelta: preferences.customRatingDelta,
                onRatingDeltaChange: (int subtract, int add) {
                  ref
                      .read(gameSetupPreferencesProvider.notifier)
                      .setCustomRatingRange(subtract, add);
                },
              ),
            const SizedBox(height: 20),
            FutureBuilder(
              future: _pendingCreateGame,
              builder: (context, snapshot) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: FilledButton(
                    onPressed:
                        snapshot.connectionState == ConnectionState.waiting
                        ? null
                        : () async {
                            setState(() {
                              _pendingCreateGame = ref
                                  .read(createGameServiceProvider)
                                  .newCorrespondenceGame(
                                    GameSeek.correspondence(
                                      preferences,
                                      account,
                                    ),
                                  );
                            });

                            try {
                              await _pendingCreateGame;
                            } finally {
                              setState(() {
                                _pendingCreateGame = null;
                              });
                            }
                            if (context.mounted) {
                              ref.invalidate(correspondenceChallengesProvider);
                              Navigator.of(context).popUntil(
                                (route) => route is! ModalBottomSheetRoute,
                              );
                            }
                          },
                    child: Text(context.l10n.createAGame),
                  ),
                );
              },
            ),
          ],
        );
      case _:
        return const Center(child: CircularProgressIndicator.adaptive());
    }
  }
}

String _daysLabel(num days) {
  return days == -1 ? '∞' : days.toString();
}
