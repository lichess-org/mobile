import 'dart:async';

import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/challenge/challenge.dart';
import 'package:lichess_mobile/src/model/challenge/challenge_preferences.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/game.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';
import 'package:lichess_mobile/src/model/lobby/create_game_service.dart';
import 'package:lichess_mobile/src/model/lobby/game_setup_preferences.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/game/game_screen.dart';
import 'package:lichess_mobile/src/view/game/game_screen_providers.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/adaptive_choice_picker.dart';
import 'package:lichess_mobile/src/widgets/board_preview.dart';
import 'package:lichess_mobile/src/widgets/expanded_section.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/non_linear_slider.dart';
import 'package:lichess_mobile/src/widgets/user.dart';

class CreateChallengeBottomSheet extends ConsumerStatefulWidget {
  const CreateChallengeBottomSheet(this.user, {this.positionFen});

  final LightUser user;
  final String? positionFen;

  @override
  ConsumerState<CreateChallengeBottomSheet> createState() => _CreateChallengeBottomSheetState();
}

class _CreateChallengeBottomSheetState extends ConsumerState<CreateChallengeBottomSheet> {
  Future<ChallengeDeclineReason?>? _pendingCorrespondenceChallenge;
  final _controller = TextEditingController();

  String? fromPositionFenInput;

  @override
  void initState() {
    super.initState();
    if (widget.positionFen != null) {
      fromPositionFenInput = widget.positionFen;
      _controller.text = widget.positionFen!;
      ref.read(challengePreferencesProvider.notifier).setVariant(Variant.fromPosition);
    } else {
      fromPositionFenInput = null;
    }
    _controller.addListener(() {
      setState(() {
        fromPositionFenInput = _controller.text;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accountAsync = ref.watch(accountProvider);
    final preferences = ref.watch(challengePreferencesProvider);

    final isValidTimeControl =
        preferences.timeControl != ChallengeTimeControlType.clock ||
        preferences.clock.time > Duration.zero ||
        preferences.clock.increment > Duration.zero;

    final isValidPosition =
        (fromPositionFenInput != null && fromPositionFenInput!.isNotEmpty) ||
        preferences.variant != Variant.fromPosition;

    switch (accountAsync) {
      case AsyncError():
        return const Center(child: Text('Could not load account data'));
      case AsyncData(value: final account):
        final timeControl = preferences.timeControl;
        return BottomSheetScrollableContainer(
          padding: Styles.verticalBodyPadding,
          children: [
            ListTile(
              title: Text(context.l10n.timeControl),
              trailing: TextButton(
                onPressed: () {
                  showChoicePicker(
                    context,
                    choices: [
                      ChallengeTimeControlType.clock,
                      ChallengeTimeControlType.correspondence,
                      ChallengeTimeControlType.unlimited,
                    ],
                    selectedItem: preferences.timeControl,
                    labelBuilder: (ChallengeTimeControlType timeControl) =>
                        Text(timeControl.label(context.l10n)),
                    onSelectedItemChanged: (ChallengeTimeControlType value) {
                      ref.read(challengePreferencesProvider.notifier).setTimeControl(value);
                    },
                  );
                },
                child: Text(preferences.timeControl.label(context.l10n)),
              ),
            ),
            if (timeControl == ChallengeTimeControlType.clock) ...[
              Builder(
                builder: (context) {
                  int seconds = preferences.clock.time.inSeconds;
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return ListTile(
                        title: Text.rich(
                          TextSpan(
                            text: '${context.l10n.minutesPerSide}: ',
                            children: [
                              TextSpan(
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                text: clockLabelInMinutes(seconds),
                              ),
                            ],
                          ),
                        ),
                        subtitle: NonLinearSlider(
                          value: seconds,
                          values: kAvailableTimesInSeconds,
                          labelBuilder: clockLabelInMinutes,
                          onChange: (num value) {
                            setState(() {
                              seconds = value.toInt();
                            });
                          },
                          onChangeEnd: (num value) {
                            setState(() {
                              seconds = value.toInt();
                            });
                            ref
                                .read(challengePreferencesProvider.notifier)
                                .setClock(
                                  Duration(seconds: value.toInt()),
                                  preferences.clock.increment,
                                );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
              Builder(
                builder: (context) {
                  int incrementSeconds = preferences.clock.increment.inSeconds;
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return ListTile(
                        title: Text.rich(
                          TextSpan(
                            text: '${context.l10n.incrementInSeconds}: ',
                            children: [
                              TextSpan(
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                text: incrementSeconds.toString(),
                              ),
                            ],
                          ),
                        ),
                        subtitle: NonLinearSlider(
                          value: incrementSeconds,
                          values: kAvailableIncrementsInSeconds,
                          onChange: (num value) {
                            setState(() {
                              incrementSeconds = value.toInt();
                            });
                          },
                          onChangeEnd: (num value) {
                            setState(() {
                              incrementSeconds = value.toInt();
                            });
                            ref
                                .read(challengePreferencesProvider.notifier)
                                .setClock(preferences.clock.time, Duration(seconds: value.toInt()));
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ] else if (timeControl == ChallengeTimeControlType.correspondence) ...[
              Builder(
                builder: (context) {
                  int daysPerTurn = preferences.days;
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return ListTile(
                        title: Text.rich(
                          TextSpan(
                            text: '${context.l10n.daysPerTurn}: ',
                            children: [
                              TextSpan(
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
                            ref.read(challengePreferencesProvider.notifier).setDays(value.toInt());
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ],
            ListTile(
              title: Text(context.l10n.variant),
              trailing: TextButton(
                onPressed: () {
                  showChoicePicker(
                    context,
                    choices: [Variant.standard, Variant.chess960, Variant.fromPosition],
                    selectedItem: preferences.variant,
                    labelBuilder: (Variant variant) => Text(variant.label),
                    onSelectedItemChanged: (Variant variant) {
                      ref.read(challengePreferencesProvider.notifier).setVariant(variant);
                    },
                  );
                },
                child: Text(preferences.variant.label),
              ),
            ),
            ExpandedSection(
              expand: preferences.variant == Variant.fromPosition,
              child: SmallBoardPreview(
                orientation: preferences.sideChoice == SideChoice.black ? Side.black : Side.white,
                fen: fromPositionFenInput ?? kEmptyFen,
                description: TextField(
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: context.l10n.pasteTheFenStringHere,
                    suffixIcon: const Icon(Icons.paste),
                  ),
                  controller: _controller,
                  readOnly: true,
                  onTap: _getClipboardData,
                ),
              ),
            ),
            ListTile(
              title: Text(context.l10n.side),
              trailing: TextButton(
                onPressed: () {
                  showChoicePicker<SideChoice>(
                    context,
                    choices: SideChoice.values,
                    selectedItem: preferences.sideChoice,
                    labelBuilder: (SideChoice side) => Text(side.label(context.l10n)),
                    onSelectedItemChanged: (SideChoice side) {
                      ref.read(challengePreferencesProvider.notifier).setSideChoice(side);
                    },
                  );
                },
                child: Text(preferences.sideChoice.label(context.l10n)),
              ),
            ),
            if (account != null)
              ListTile(
                title: Text(context.l10n.rated),
                trailing: Switch.adaptive(
                  value: preferences.isRatedAllowed && preferences.rated,
                  onChanged: preferences.isRatedAllowed
                      ? (bool value) {
                          ref.read(challengePreferencesProvider.notifier).setRated(value);
                        }
                      : null,
                ),
              ),
            const SizedBox(height: 20),
            FutureBuilder(
              future: _pendingCorrespondenceChallenge,
              builder: (context, snapshot) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: FilledButton(
                    onPressed: switch (timeControl) {
                      ChallengeTimeControlType.clock =>
                        isValidTimeControl && isValidPosition
                            ? () {
                                Navigator.of(
                                  context,
                                ).popUntil((route) => route is! ModalBottomSheetRoute);
                                Navigator.of(context, rootNavigator: true).push(
                                  GameScreen.buildRoute(
                                    context,
                                    source: UserChallengeSource(
                                      preferences.makeRequest(
                                        widget.user,
                                        preferences.variant != Variant.fromPosition
                                            ? null
                                            : fromPositionFenInput,
                                      ),
                                    ),
                                  ),
                                );
                              }
                            : null,
                      ChallengeTimeControlType.correspondence ||
                      ChallengeTimeControlType.unlimited =>
                        snapshot.connectionState != ConnectionState.waiting
                            ? () async {
                                final createGameService = ref.read(createGameServiceProvider);
                                setState(() {
                                  _pendingCorrespondenceChallenge = createGameService
                                      .newCorrespondenceChallenge(
                                        preferences.makeRequest(
                                          widget.user,
                                          preferences.variant != Variant.fromPosition
                                              ? null
                                              : fromPositionFenInput,
                                        ),
                                      );
                                });

                                try {
                                  final maybeDeclined = await _pendingCorrespondenceChallenge;

                                  if (!context.mounted) return;

                                  Navigator.of(
                                    context,
                                  ).popUntil((route) => route is! ModalBottomSheetRoute);

                                  if (maybeDeclined != null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(context.l10n.challengeChallengeDeclined),
                                            const SizedBox(height: 8.0),
                                            const Divider(height: 26.0, thickness: 0.0),
                                            Text(
                                              maybeDeclined.label(context.l10n),
                                              style: const TextStyle(fontStyle: FontStyle.italic),
                                            ),
                                            const Divider(height: 26.0, thickness: 0.0),
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Text(' — '),
                                                  UserFullNameWidget(user: widget.user),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        duration: const Duration(seconds: 5),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(context.l10n.mobileChallengeCreated)),
                                    );
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    showSnackBar(
                                      context,
                                      context.l10n.mobileSomethingWentWrong,
                                      type: SnackBarType.error,
                                    );
                                  }
                                } finally {
                                  setState(() {
                                    _pendingCorrespondenceChallenge = null;
                                  });
                                }
                              }
                            : null,
                    },
                    child: Text(context.l10n.challengeChallengeToPlay, style: Styles.bold),
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

  Future<void> _getClipboardData() async {
    final ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data != null) {
      try {
        Chess.fromSetup(Setup.parseFen(data.text!.trim()));
        _controller.text = data.text!;
      } catch (_) {
        if (mounted) {
          showSnackBar(context, context.l10n.invalidFen, type: SnackBarType.error);
        }
      }
    }
  }
}

String _daysLabel(num days) {
  return days == -1 ? '∞' : days.toString();
}
