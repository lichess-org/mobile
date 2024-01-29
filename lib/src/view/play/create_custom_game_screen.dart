import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/lobby/game_seek.dart';
import 'package:lichess_mobile/src/model/lobby/game_setup.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/game/lobby_screen.dart';
import 'package:lichess_mobile/src/widgets/adaptive_choice_picker.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/expanded_section.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/non_linear_slider.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';

import 'common_play_widgets.dart';

class CreateCustomGameScreen extends StatelessWidget {
  const CreateCustomGameScreen();

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(androidBuilder: _buildAndroid, iosBuilder: _buildIos);
  }

  Widget _buildIos(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(),
      child: _Body(),
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.custom),
      ),
      body: const _Body(),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountAsync = ref.watch(accountProvider);
    final preferences = ref.watch(gameSetupPreferencesProvider);
    final session = ref.watch(authSessionProvider);
    final isValidTimeControl = preferences.customTimeSeconds > 0 ||
        preferences.customIncrementSeconds > 0;

    return accountAsync.when(
      data: (account) {
        final userPerf = account?.perfs[preferences.perfFromCustom];

        return Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              Builder(
                builder: (context) {
                  int customTimeSeconds = preferences.customTimeSeconds;
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
                                text: _clockTimeLabel(customTimeSeconds),
                              ),
                            ],
                          ),
                        ),
                        subtitle: NonLinearSlider(
                          value: customTimeSeconds,
                          values: kAvailableTimesInSeconds,
                          labelBuilder: _clockTimeLabel,
                          onChange: defaultTargetPlatform == TargetPlatform.iOS
                              ? (num value) {
                                  setState(() {
                                    customTimeSeconds = value.toInt();
                                  });
                                }
                              : null,
                          onChangeEnd: (num value) {
                            setState(() {
                              customTimeSeconds = value.toInt();
                            });
                            ref
                                .read(gameSetupPreferencesProvider.notifier)
                                .setCustomTimeSeconds(value.toInt());
                          },
                        ),
                      );
                    },
                  );
                },
              ),
              Builder(
                builder: (context) {
                  int customIncrementSeconds =
                      preferences.customIncrementSeconds;
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
                                text: customIncrementSeconds.toString(),
                              ),
                            ],
                          ),
                        ),
                        subtitle: NonLinearSlider(
                          value: customIncrementSeconds,
                          values: kAvailableIncrementsInSeconds,
                          onChange: defaultTargetPlatform == TargetPlatform.iOS
                              ? (num value) {
                                  setState(() {
                                    customIncrementSeconds = value.toInt();
                                  });
                                }
                              : null,
                          onChangeEnd: (num value) {
                            setState(() {
                              customIncrementSeconds = value.toInt();
                            });
                            ref
                                .read(gameSetupPreferencesProvider.notifier)
                                .setCustomIncrementSeconds(value.toInt());
                          },
                        ),
                      );
                    },
                  );
                },
              ),
              PlatformListTile(
                harmonizeCupertinoTitleStyle: true,
                title: Text(context.l10n.variant),
                trailing: AdaptiveTextButton(
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
                child: PlatformListTile(
                  harmonizeCupertinoTitleStyle: true,
                  title: Text(context.l10n.side),
                  trailing: AdaptiveTextButton(
                    onPressed: () {
                      showChoicePicker<PlayableSide>(
                        context,
                        choices: PlayableSide.values,
                        selectedItem: preferences.customSide,
                        labelBuilder: (PlayableSide side) =>
                            Text(_customSideLabel(context, side)),
                        onSelectedItemChanged: (PlayableSide side) {
                          ref
                              .read(gameSetupPreferencesProvider.notifier)
                              .setCustomSide(side);
                        },
                      );
                    },
                    child:
                        Text(_customSideLabel(context, preferences.customSide)),
                  ),
                ),
              ),
              if (session != null)
                PlatformListTile(
                  harmonizeCupertinoTitleStyle: true,
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: FatButton(
                  semanticsLabel: context.l10n.createAGame,
                  onPressed: isValidTimeControl
                      ? () {
                          ref
                              .read(gameSetupPreferencesProvider.notifier)
                              .setSeekMode(SeekMode.custom);
                          pushPlatformRoute(
                            context,
                            rootNavigator: true,
                            builder: (BuildContext context) {
                              return LobbyScreen(
                                seek: GameSeek.custom(preferences, account),
                              );
                            },
                          );
                        }
                      : null,
                  child: Text(context.l10n.studyStart, style: Styles.bold),
                ),
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
}

String _clockTimeLabel(num seconds) {
  switch (seconds) {
    case 0:
      return '0';
    case 45:
      return '¾';
    case 30:
      return '½';
    case 15:
      return '¼';
    default:
      return (seconds / 60).toString().replaceAll('.0', '');
  }
}

String _customSideLabel(BuildContext context, PlayableSide side) {
  switch (side) {
    case PlayableSide.white:
      return context.l10n.white;
    case PlayableSide.black:
      return context.l10n.black;
    case PlayableSide.random:
      return context.l10n.randomColor;
  }
}
