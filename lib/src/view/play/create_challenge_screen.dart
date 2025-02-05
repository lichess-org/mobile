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
import 'package:lichess_mobile/src/navigation.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/game/game_screen.dart';
import 'package:lichess_mobile/src/view/user/challenge_requests_screen.dart';
import 'package:lichess_mobile/src/widgets/adaptive_choice_picker.dart';
import 'package:lichess_mobile/src/widgets/adaptive_text_field.dart';
import 'package:lichess_mobile/src/widgets/board_preview.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/expanded_section.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/non_linear_slider.dart';
import 'package:lichess_mobile/src/widgets/platform_scaffold.dart';

class CreateChallengeScreen extends StatelessWidget {
  const CreateChallengeScreen(this.user);

  final LightUser user;

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(title: Text(context.l10n.challengeChallengesX(user.name))),
      body: _ChallengeBody(user),
    );
  }
}

class _ChallengeBody extends ConsumerStatefulWidget {
  const _ChallengeBody(this.user);

  final LightUser user;

  @override
  ConsumerState<_ChallengeBody> createState() => _ChallengeBodyState();
}

class _ChallengeBodyState extends ConsumerState<_ChallengeBody> {
  Future<Challenge>? _pendingCorrespondenceChallenge;
  final _controller = TextEditingController();

  String? fromPositionFenInput;

  @override
  void initState() {
    super.initState();
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

    return accountAsync.when(
      data: (account) {
        final timeControl = preferences.timeControl;

        return Center(
          child: ListView(
            shrinkWrap: true,
            padding:
                Theme.of(context).platform == TargetPlatform.iOS
                    ? Styles.sectionBottomPadding
                    : Styles.verticalBodyPadding,
            children: [
              PlatformListTile(
                harmonizeCupertinoTitleStyle: true,
                title: Text(context.l10n.timeControl),
                trailing: AdaptiveTextButton(
                  onPressed: () {
                    showChoicePicker(
                      context,
                      choices: [
                        ChallengeTimeControlType.clock,
                        ChallengeTimeControlType.correspondence,
                      ],
                      selectedItem: preferences.timeControl,
                      labelBuilder:
                          (ChallengeTimeControlType timeControl) => Text(switch (timeControl) {
                            ChallengeTimeControlType.clock => context.l10n.realTime,
                            ChallengeTimeControlType.correspondence => context.l10n.correspondence,
                            ChallengeTimeControlType.unlimited => context.l10n.unlimited,
                          }),
                      onSelectedItemChanged: (ChallengeTimeControlType value) {
                        ref.read(challengePreferencesProvider.notifier).setTimeControl(value);
                      },
                    );
                  },
                  child: Text(
                    preferences.timeControl == ChallengeTimeControlType.clock
                        ? context.l10n.realTime
                        : context.l10n.correspondence,
                  ),
                ),
              ),
              if (timeControl == ChallengeTimeControlType.clock) ...[
                Builder(
                  builder: (context) {
                    int seconds = preferences.clock.time.inSeconds;
                    return StatefulBuilder(
                      builder: (context, setState) {
                        return PlatformListTile(
                          harmonizeCupertinoTitleStyle: true,
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
                            onChange:
                                Theme.of(context).platform == TargetPlatform.iOS
                                    ? (num value) {
                                      setState(() {
                                        seconds = value.toInt();
                                      });
                                    }
                                    : null,
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
                        return PlatformListTile(
                          harmonizeCupertinoTitleStyle: true,
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
                            onChange:
                                Theme.of(context).platform == TargetPlatform.iOS
                                    ? (num value) {
                                      setState(() {
                                        incrementSeconds = value.toInt();
                                      });
                                    }
                                    : null,
                            onChangeEnd: (num value) {
                              setState(() {
                                incrementSeconds = value.toInt();
                              });
                              ref
                                  .read(challengePreferencesProvider.notifier)
                                  .setClock(
                                    preferences.clock.time,
                                    Duration(seconds: value.toInt()),
                                  );
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ] else ...[
                Builder(
                  builder: (context) {
                    int daysPerTurn = preferences.days;
                    return StatefulBuilder(
                      builder: (context, setState) {
                        return PlatformListTile(
                          harmonizeCupertinoTitleStyle: true,
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
                            onChange:
                                Theme.of(context).platform == TargetPlatform.iOS
                                    ? (num value) {
                                      setState(() {
                                        daysPerTurn = value.toInt();
                                      });
                                    }
                                    : null,
                            onChangeEnd: (num value) {
                              setState(() {
                                daysPerTurn = value.toInt();
                              });
                              ref
                                  .read(challengePreferencesProvider.notifier)
                                  .setDays(value.toInt());
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
              PlatformListTile(
                harmonizeCupertinoTitleStyle: true,
                title: Text(context.l10n.variant),
                trailing: AdaptiveTextButton(
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
                  description: AdaptiveTextField(
                    maxLines: 5,
                    placeholder: context.l10n.pasteTheFenStringHere,
                    controller: _controller,
                    readOnly: true,
                    onTap: _getClipboardData,
                  ),
                ),
              ),
              ExpandedSection(
                expand: preferences.rated == false || preferences.variant == Variant.fromPosition,
                child: PlatformListTile(
                  harmonizeCupertinoTitleStyle: true,
                  title: Text(context.l10n.side),
                  trailing: AdaptiveTextButton(
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
              ),
              if (account != null)
                ExpandedSection(
                  expand: preferences.variant != Variant.fromPosition,
                  child: PlatformListTile(
                    harmonizeCupertinoTitleStyle: true,
                    title: Text(context.l10n.rated),
                    trailing: Switch.adaptive(
                      value: preferences.rated,
                      onChanged: (bool value) {
                        ref.read(challengePreferencesProvider.notifier).setRated(value);
                      },
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              FutureBuilder(
                future: _pendingCorrespondenceChallenge,
                builder: (context, snapshot) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: FatButton(
                      semanticsLabel: context.l10n.challengeChallengeToPlay,
                      onPressed:
                          timeControl == ChallengeTimeControlType.clock
                              ? isValidTimeControl && isValidPosition
                                  ? () {
                                    pushPlatformRoute(
                                      context,
                                      rootNavigator: true,
                                      builder: (BuildContext context) {
                                        return GameScreen(
                                          challenge: preferences.makeRequest(
                                            widget.user,
                                            preferences.variant != Variant.fromPosition
                                                ? null
                                                : fromPositionFenInput,
                                          ),
                                        );
                                      },
                                    );
                                  }
                                  : null
                              : timeControl == ChallengeTimeControlType.correspondence &&
                                  snapshot.connectionState != ConnectionState.waiting
                              ? () async {
                                final createGameService = ref.read(createGameServiceProvider);
                                _pendingCorrespondenceChallenge = createGameService
                                    .newCorrespondenceChallenge(
                                      preferences.makeRequest(
                                        widget.user,
                                        preferences.variant != Variant.fromPosition
                                            ? null
                                            : fromPositionFenInput,
                                      ),
                                    );

                                await _pendingCorrespondenceChallenge!;

                                if (!context.mounted) return;

                                Navigator.of(context).pop();

                                // Switch to the home tab
                                ref.read(currentBottomTabProvider.notifier).state = BottomTab.home;

                                // Navigate to the challenges screen where
                                // the new correspondence challenge will be
                                // displayed
                                pushPlatformRoute(context, screen: const ChallengeRequestsScreen());
                              }
                              : null,
                      child: Text(context.l10n.challengeChallengeToPlay, style: Styles.bold),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
      error: (error, stackTrace) => const Center(child: Text('Could not load account data')),
    );
  }

  Future<void> _getClipboardData() async {
    final ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data != null) {
      try {
        Chess.fromSetup(Setup.parseFen(data.text!.trim()));
        _controller.text = data.text!;
      } catch (_) {
        if (mounted) {
          showPlatformSnackbar(context, context.l10n.invalidFen, type: SnackBarType.error);
        }
      }
    }
  }
}

String _daysLabel(num days) {
  return days == -1 ? '∞' : days.toString();
}
