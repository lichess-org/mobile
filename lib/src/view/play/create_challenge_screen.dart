import 'dart:async';

import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
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
import 'package:lichess_mobile/src/widgets/board_thumbnail.dart';
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
      appBar: PlatformAppBar(
        title: Text(context.l10n.challengeChallengesX(user.name)),
      ),
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

class _BotFen {
  final String fen;
  final Side side;

  _BotFen({required this.fen, required this.side});
}

final Map<String, List<_BotFen>> _botFens = {
  'leelaknightodds': [
    _BotFen(
      fen: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKB1R w KQkq',
      side: Side.black,
    ),
    _BotFen(
      fen: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/R1BQKBNR w KQkq',
      side: Side.black,
    ),
  ],
  'leelaqueenodds': [
    _BotFen(
      fen: 'rnb1kbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq',
      side: Side.white,
    ),
    _BotFen(
      fen: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNB1KBNR w KQkq',
      side: Side.black,
    ),
  ],
  'leelaqueenforknight': [
    _BotFen(
      fen: 'r1bqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNB1KBNR w KQkq',
      side: Side.white,
    ),
    _BotFen(
      fen: 'r1bqkbnr/pppppppp/8/8/8/8/8/PPPPPPPP/RNB1KBNR w KQkq',
      side: Side.black,
    ),
  ],
  'leelarookodds': [
    _BotFen(
      fen: '1nbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQk',
      side: Side.white,
    ),
    _BotFen(
      fen: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/1NBQKBNR w Kkq',
      side: Side.black,
    ),
  ],
  'leelapieceodds': [
    _BotFen(
      fen: 'r1bqkb1r/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq',
      side: Side.white,
    ),
    _BotFen(
      fen: 'rn1qk1nr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq',
      side: Side.white,
    ),
    _BotFen(
      fen: '1nbqkb1r/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQk',
      side: Side.white,
    ),
    _BotFen(
      fen: '1nbqkbn1/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQ',
      side: Side.white,
    ),
    _BotFen(
      fen: 'r2qk1nr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq',
      side: Side.white,
    ),
    _BotFen(
      fen: '2bqkb1r/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQk',
      side: Side.white,
    ),
    _BotFen(
      fen: '1n1qk1nr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQk',
      side: Side.white,
    ),
    _BotFen(
      fen: 'rnb1kb1r/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq',
      side: Side.white,
    ),
    _BotFen(
      fen: 'r2qk2r/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq',
      side: Side.white,
    ),
    _BotFen(
      fen: '1nb1kbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQk',
      side: Side.white,
    ),
    _BotFen(
      fen: 'r1b1kb1r/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq',
      side: Side.white,
    ),
    _BotFen(
      fen: 'rn2k1nr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq',
      side: Side.white,
    ),
    _BotFen(
      fen: '1nb1kb1r/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQk',
      side: Side.white,
    ),
    _BotFen(
      fen: '1nb1kbn1/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQ',
      side: Side.white,
    ),
    _BotFen(
      fen: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/R1BQKB1R w KQkq',
      side: Side.black,
    ),
    _BotFen(
      fen: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RN1QK1NR w KQkq',
      side: Side.black,
    ),
    _BotFen(
      fen: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/1NBQKB1R w Kkq',
      side: Side.black,
    ),
    _BotFen(
      fen: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/1NBQKBN1 w kq',
      side: Side.black,
    ),
    _BotFen(
      fen: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/R2QK1NR w KQkq',
      side: Side.black,
    ),
    _BotFen(
      fen: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/2BQKB1R w Kkq',
      side: Side.black,
    ),
    _BotFen(
      fen: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/1N1QK1NR w Kkq',
      side: Side.black,
    ),
    _BotFen(
      fen: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNB1KB1R w KQkq',
      side: Side.black,
    ),
    _BotFen(
      fen: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/R2QK2R w KQkq',
      side: Side.black,
    ),
    _BotFen(
      fen: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/1NB1KBNR w Kkq - 0 1',
      side: Side.black,
    ),
    _BotFen(
      fen: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/R1B1KB1R w KQkq - 0 1',
      side: Side.black,
    ),
    _BotFen(
      fen: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RN2K1NR w KQkq',
      side: Side.black,
    ),
    _BotFen(
      fen: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/1NB1KB1R w Kkq',
      side: Side.black,
    ),
    _BotFen(
      fen: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/1NB1KBN1 w kq',
      side: Side.black,
    ),
  ],
};

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

    final isSpecialBot = [
      'leelaknightodds',
      'leelaqueenodds',
      'leelaqueenforknight',
      'leelarookodds',
      'leelapieceodds',
    ].contains(widget.user.name.toLowerCase());

    if (isSpecialBot) {
      ref
          .read(challengePreferencesProvider.notifier)
          .setVariant(Variant.fromPosition);
      ref
          .read(challengePreferencesProvider.notifier)
          .setTimeControl(ChallengeTimeControlType.clock);
      ref.read(challengePreferencesProvider.notifier).setRated(false);
    }

    return accountAsync.when(
      data: (account) {
        final timeControl = preferences.timeControl;

        return Center(
          child: ListView(
            shrinkWrap: true,
            padding: Theme.of(context).platform == TargetPlatform.iOS
                ? Styles.sectionBottomPadding
                : Styles.verticalBodyPadding,
            children: [
              if (!isSpecialBot) ...[
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
                        labelBuilder: (ChallengeTimeControlType timeControl) =>
                            Text(
                          switch (timeControl) {
                            ChallengeTimeControlType.clock =>
                              context.l10n.realTime,
                            ChallengeTimeControlType.correspondence =>
                              context.l10n.correspondence,
                            ChallengeTimeControlType.unlimited =>
                              context.l10n.unlimited,
                          },
                        ),
                        onSelectedItemChanged:
                            (ChallengeTimeControlType value) {
                          ref
                              .read(challengePreferencesProvider.notifier)
                              .setTimeControl(value);
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
              ],
              if (timeControl == ChallengeTimeControlType.clock) ...[
                Builder(
                  builder: (context) {
                    //special bots have a shorter range of time controls, to prevent an error of the slider we need to check if the time stored in the preferences is within the range of the slider
                    int seconds = isSpecialBot &&
                            (preferences.clock.time.inSeconds < 60 ||
                                preferences.clock.time.inSeconds > 15 * 60)
                        ? 300
                        : preferences.clock.time.inSeconds;
                    return StatefulBuilder(
                      builder: (context, setState) {
                        return PlatformListTile(
                          harmonizeCupertinoTitleStyle: true,
                          title: Text.rich(
                            TextSpan(
                              text: '${context.l10n.minutesPerSide}: ',
                              children: [
                                TextSpan(
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                  text: clockLabelInMinutes(seconds),
                                ),
                              ],
                            ),
                          ),
                          subtitle: NonLinearSlider(
                            value: seconds,
                            values: isSpecialBot
                                ? List.generate(15, (i) => (i + 1) * 60)
                                : kAvailableTimesInSeconds,
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
                    int incrementSeconds = isSpecialBot &&
                            preferences.clock.increment.inSeconds > 10
                        ? 10
                        : preferences.clock.increment.inSeconds;
                    return StatefulBuilder(
                      builder: (context, setState) {
                        return PlatformListTile(
                          harmonizeCupertinoTitleStyle: true,
                          title: Text.rich(
                            TextSpan(
                              text: '${context.l10n.incrementInSeconds}: ',
                              children: [
                                TextSpan(
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                  text: incrementSeconds.toString(),
                                ),
                              ],
                            ),
                          ),
                          subtitle: NonLinearSlider(
                            value: incrementSeconds,
                            values: isSpecialBot
                                ? List.generate(11, (i) => i)
                                : kAvailableIncrementsInSeconds,
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
              if (!isSpecialBot) ...[
                PlatformListTile(
                  harmonizeCupertinoTitleStyle: true,
                  title: Text(context.l10n.variant),
                  trailing: AdaptiveTextButton(
                    onPressed: () {
                      showChoicePicker(
                        context,
                        choices: [
                          Variant.standard,
                          Variant.chess960,
                          Variant.fromPosition,
                        ],
                        selectedItem: preferences.variant,
                        labelBuilder: (Variant variant) => Text(variant.label),
                        onSelectedItemChanged: (Variant variant) {
                          ref
                              .read(challengePreferencesProvider.notifier)
                              .setVariant(variant);
                        },
                      );
                    },
                    child: Text(preferences.variant.label),
                  ),
                ),
                ExpandedSection(
                  expand: preferences.variant == Variant.fromPosition,
                  child: SmallBoardPreview(
                    orientation: preferences.sideChoice == SideChoice.black
                        ? Side.black
                        : Side.white,
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
                  expand: preferences.rated == false ||
                      preferences.variant == Variant.fromPosition,
                  child: PlatformListTile(
                    harmonizeCupertinoTitleStyle: true,
                    title: Text(context.l10n.side),
                    trailing: AdaptiveTextButton(
                      onPressed: () {
                        showChoicePicker<SideChoice>(
                          context,
                          choices: SideChoice.values,
                          selectedItem: preferences.sideChoice,
                          labelBuilder: (SideChoice side) =>
                              Text(side.label(context.l10n)),
                          onSelectedItemChanged: (SideChoice side) {
                            ref
                                .read(challengePreferencesProvider.notifier)
                                .setSideChoice(side);
                          },
                        );
                      },
                      child: Text(
                        preferences.sideChoice.label(context.l10n),
                      ),
                    ),
                  ),
                ),
              ],
              if (isSpecialBot) ...[
                LayoutBuilder(
                  builder: (context, constraints) {
                    final crossAxisCount = constraints.maxWidth > 600
                        ? 4
                        : constraints.maxWidth > 450
                            ? 3
                            : 2;
                    const sidePadding = 16.0;
                    const double borderWidth = 3.0;
                    final boardWidth = (constraints.maxWidth -
                            (sidePadding * (crossAxisCount - 1)) -
                            (2 * sidePadding) -
                            (2 * borderWidth * crossAxisCount)) /
                        crossAxisCount;
                    const borderRadius = 4.0 + borderWidth;

                    final userBotFens =
                        _botFens[widget.user.name.toLowerCase()] ?? [];
                    final rowCount =
                        (userBotFens.length / crossAxisCount).ceil();

                    return Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: sidePadding),
                      child: LayoutGrid(
                        columnSizes: List.generate(crossAxisCount, (_) => 1.fr),
                        rowSizes: List.generate(rowCount, (_) => auto),
                        rowGap: 16,
                        columnGap: sidePadding,
                        children: userBotFens.map((botFen) {
                          final fen = botFen.fen;
                          final side = botFen.side;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                fromPositionFenInput = fen;
                              });
                              ref
                                  .read(challengePreferencesProvider.notifier)
                                  .setSideChoice(
                                    side == Side.white
                                        ? SideChoice.white
                                        : SideChoice.black,
                                  );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: fromPositionFenInput == fen
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.transparent,
                                  width: borderWidth,
                                ),
                                borderRadius:
                                    BorderRadius.circular(borderRadius),
                              ),
                              child: BoardThumbnail(
                                size: boardWidth,
                                orientation: side,
                                fen: fen,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
              ],
              if (account != null && !isSpecialBot)
                ExpandedSection(
                  expand: preferences.variant != Variant.fromPosition,
                  child: PlatformListTile(
                    harmonizeCupertinoTitleStyle: true,
                    title: Text(context.l10n.rated),
                    trailing: Switch.adaptive(
                      applyCupertinoTheme: true,
                      value: preferences.rated,
                      onChanged: (bool value) {
                        ref
                            .read(challengePreferencesProvider.notifier)
                            .setRated(value);
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
                      onPressed: timeControl == ChallengeTimeControlType.clock
                          ? isValidTimeControl && isValidPosition
                              ? () {
                                  pushPlatformRoute(
                                    context,
                                    rootNavigator: true,
                                    builder: (BuildContext context) {
                                      return GameScreen(
                                        challenge: preferences.makeRequest(
                                          widget.user,
                                          preferences.variant !=
                                                  Variant.fromPosition
                                              ? null
                                              : fromPositionFenInput,
                                        ),
                                      );
                                    },
                                  );
                                }
                              : null
                          : timeControl ==
                                      ChallengeTimeControlType.correspondence &&
                                  snapshot.connectionState !=
                                      ConnectionState.waiting
                              ? () async {
                                  final createGameService =
                                      ref.read(createGameServiceProvider);
                                  _pendingCorrespondenceChallenge =
                                      createGameService
                                          .newCorrespondenceChallenge(
                                    preferences.makeRequest(
                                      widget.user,
                                      preferences.variant !=
                                              Variant.fromPosition
                                          ? null
                                          : fromPositionFenInput,
                                    ),
                                  );

                                  await _pendingCorrespondenceChallenge!;

                                  if (!context.mounted) return;

                                  Navigator.of(context).pop();

                                  // Switch to the home tab
                                  ref
                                      .read(currentBottomTabProvider.notifier)
                                      .state = BottomTab.home;

                                  // Navigate to the challenges screen where
                                  // the new correspondence challenge will be
                                  // displayed
                                  pushPlatformRoute(
                                    context,
                                    screen: const ChallengeRequestsScreen(),
                                  );
                                }
                              : null,
                      child: Text(
                        context.l10n.challengeChallengeToPlay,
                        style: Styles.bold,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
      error: (error, stackTrace) => const Center(
        child: Text('Could not load account data'),
      ),
    );
  }

  Future<void> _getClipboardData() async {
    final ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data != null) {
      try {
        Chess.fromSetup(Setup.parseFen(data.text!.trim()));
        _controller.text = data.text!;
      } catch (_, __) {
        if (mounted) {
          showPlatformSnackbar(
            context,
            context.l10n.invalidFen,
            type: SnackBarType.error,
          );
        }
      }
    }
  }
}

String _daysLabel(num days) {
  return days == -1 ? '∞' : days.toString();
}
