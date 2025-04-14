import 'dart:async';

import 'package:deep_pick/deep_pick.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/game.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';
import 'package:lichess_mobile/src/model/lobby/create_game_service.dart';
import 'package:lichess_mobile/src/model/lobby/game_seek.dart';
import 'package:lichess_mobile/src/model/lobby/game_setup_preferences.dart';
import 'package:lichess_mobile/src/model/lobby/lobby_repository.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/network/socket.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/game/game_screen.dart';
import 'package:lichess_mobile/src/view/play/challenge_list_item.dart';
import 'package:lichess_mobile/src/view/play/common_play_widgets.dart';
import 'package:lichess_mobile/src/widgets/adaptive_action_sheet.dart';
import 'package:lichess_mobile/src/widgets/adaptive_choice_picker.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/expanded_section.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/non_linear_slider.dart';
import 'package:lichess_mobile/src/widgets/platform_scaffold.dart';

enum _ViewMode { create, challenges }

class CreateCustomGameScreen extends StatefulWidget {
  const CreateCustomGameScreen();

  static Route<dynamic> buildRoute(BuildContext context) {
    return buildScreenRoute(
      context,
      screen: const CreateCustomGameScreen(),
      title: context.l10n.custom,
    );
  }

  @override
  State<CreateCustomGameScreen> createState() => _CreateCustomGameScreenState();
}

class _CreateCustomGameScreenState extends State<CreateCustomGameScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void setViewMode(_ViewMode mode) {
    if (mode == _ViewMode.create) {
      _tabController.animateTo(0);
    } else {
      _tabController.animateTo(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBarTitle: Text(context.l10n.custom),
      appBarBottom: TabBar(
        controller: _tabController,
        tabs: <Widget>[
          Tab(text: context.l10n.createAGame),
          Tab(text: context.l10n.mobileCustomGameJoinAGame),
        ],
      ),
      appBarAutomaticBackgroundVisibility: false,
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          _CreateGameBody(setViewMode: setViewMode),
          _ChallengesBody(setViewMode: setViewMode),
        ],
      ),
    );
  }
}

class _ChallengesBody extends ConsumerStatefulWidget {
  const _ChallengesBody({required this.setViewMode});

  final void Function(_ViewMode) setViewMode;

  @override
  ConsumerState<_ChallengesBody> createState() => _ChallengesBodyState();
}

class _ChallengesBodyState extends ConsumerState<_ChallengesBody> {
  StreamSubscription<SocketEvent>? _socketSubscription;

  late SocketClient socketClient;

  @override
  void initState() {
    super.initState();

    socketClient = ref.read(socketPoolProvider).open(Uri(path: '/lobby/socket/v5'));

    _socketSubscription = socketClient.stream.listen((event) {
      switch (event.topic) {
        // redirect after accepting a correpondence challenge
        case 'redirect':
          final data = event.data as Map<String, dynamic>;
          final gameFullId = pick(data['id']).asGameFullIdOrThrow();
          if (mounted) {
            Navigator.of(
              context,
              rootNavigator: true,
            ).push(GameScreen.buildRoute(context, initialGameId: gameFullId));
          }
          widget.setViewMode(_ViewMode.create);

        case 'reload_seeks':
          if (mounted) {
            ref.invalidate(correspondenceChallengesProvider);
          }
      }
    });
  }

  @override
  void dispose() {
    _socketSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final challengesAsync = ref.watch(correspondenceChallengesProvider);
    final session = ref.watch(authSessionProvider);

    return challengesAsync.when(
      data: (challenges) {
        final supportedChallenges =
            challenges.where((challenge) => challenge.variant.isPlaySupported).toList();
        return ListView.separated(
          itemCount: supportedChallenges.length,
          separatorBuilder:
              (context, index) =>
                  Theme.of(context).platform == TargetPlatform.iOS
                      ? const PlatformDivider(height: 1, cupertinoHasLeading: true)
                      : const SizedBox.shrink(),
          itemBuilder: (context, index) {
            final challenge = supportedChallenges[index];
            final isMySeek = UserId.fromUserName(challenge.username) == session?.user.id;

            return CorrespondenceChallengeListItem(
              challenge: challenge,
              challengerUser: LightUser(
                id: UserId.fromUserName(challenge.username),
                name: challenge.username,
                title: challenge.title,
              ),
              onPressed:
                  isMySeek
                      ? null
                      : session == null
                      ? () {
                        showPlatformSnackbar(context, context.l10n.youNeedAnAccountToDoThat);
                      }
                      : () {
                        showConfirmDialog<void>(
                          context,
                          title: Text(context.l10n.accept),
                          isDestructiveAction: true,
                          onConfirm: () {
                            socketClient.send('joinSeek', challenge.id.toString());
                          },
                        );
                      },
              onCancel:
                  isMySeek
                      ? () {
                        socketClient.send('cancelSeek', challenge.id.toString());
                      }
                      : null,
            );
          },
        );
      },
      loading: () {
        return const Center(child: CircularProgressIndicator.adaptive());
      },
      error: (error, stack) => Center(child: Text(context.l10n.mobileCustomGameJoinAGame)),
    );
  }
}

class _CreateGameBody extends ConsumerStatefulWidget {
  const _CreateGameBody({required this.setViewMode});

  final void Function(_ViewMode) setViewMode;

  @override
  ConsumerState<_CreateGameBody> createState() => _CreateGameBodyState();
}

class _CreateGameBodyState extends ConsumerState<_CreateGameBody> {
  Future<void>? _pendingCreateGame;

  @override
  Widget build(BuildContext context) {
    final accountAsync = ref.watch(accountProvider);
    final preferences = ref.watch(gameSetupPreferencesProvider);
    final isValidTimeControl =
        preferences.customTimeSeconds > 0 || preferences.customIncrementSeconds > 0;

    final realTimeSelector = [
      Builder(
        builder: (context) {
          int customTimeSeconds = preferences.customTimeSeconds;
          return StatefulBuilder(
            builder: (context, setState) {
              return ListTile(
                title: Text.rich(
                  TextSpan(
                    text: '${context.l10n.minutesPerSide}: ',
                    children: [
                      TextSpan(
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        text: clockLabelInMinutes(customTimeSeconds),
                      ),
                    ],
                  ),
                ),
                subtitle: NonLinearSlider(
                  value: customTimeSeconds,
                  values: kAvailableTimesInSeconds,
                  labelBuilder: clockLabelInMinutes,
                  onChange:
                      Theme.of(context).platform == TargetPlatform.iOS
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
          int customIncrementSeconds = preferences.customIncrementSeconds;
          return StatefulBuilder(
            builder: (context, setState) {
              return ListTile(
                title: Text.rich(
                  TextSpan(
                    text: '${context.l10n.incrementInSeconds}: ',
                    children: [
                      TextSpan(
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        text: customIncrementSeconds.toString(),
                      ),
                    ],
                  ),
                ),
                subtitle: NonLinearSlider(
                  value: customIncrementSeconds,
                  values: kAvailableIncrementsInSeconds,
                  onChange:
                      Theme.of(context).platform == TargetPlatform.iOS
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
    ];

    final correspondenceSelector = [
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
                        .read(gameSetupPreferencesProvider.notifier)
                        .setCustomDaysPerTurn(value.toInt());
                  },
                ),
              );
            },
          );
        },
      ),
    ];

    return accountAsync.when(
      data: (account) {
        final timeControl = account == null ? TimeControl.realTime : preferences.customTimeControl;

        final userPerf =
            account?.perfs[timeControl == TimeControl.realTime
                ? preferences.perfFromCustom
                : Perf.correspondence];
        return Center(
          child: ListView(
            padding: MediaQuery.paddingOf(context) + Styles.verticalBodyPadding,
            shrinkWrap: true,
            children: [
              if (account != null)
                ListTile(
                  title: Text(context.l10n.timeControl),
                  trailing: TextButton(
                    onPressed: () {
                      showChoicePicker(
                        context,
                        choices: [TimeControl.realTime, TimeControl.correspondence],
                        selectedItem: preferences.customTimeControl,
                        labelBuilder:
                            (TimeControl timeControl) => Text(
                              timeControl == TimeControl.realTime
                                  ? context.l10n.realTime
                                  : context.l10n.correspondence,
                            ),
                        onSelectedItemChanged: (TimeControl value) {
                          ref
                              .read(gameSetupPreferencesProvider.notifier)
                              .setCustomTimeControl(value);
                        },
                      );
                    },
                    child: Text(
                      preferences.customTimeControl == TimeControl.realTime
                          ? context.l10n.realTime
                          : context.l10n.correspondence,
                    ),
                  ),
                ),
              if (timeControl == TimeControl.realTime)
                ...realTimeSelector
              else
                ...correspondenceSelector,
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
                        ref.read(gameSetupPreferencesProvider.notifier).setCustomVariant(variant);
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
                      ref.read(gameSetupPreferencesProvider.notifier).setCustomRated(value);
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
                    child: FatButton(
                      semanticsLabel: context.l10n.createAGame,
                      onPressed:
                          timeControl == TimeControl.realTime
                              ? isValidTimeControl
                                  ? () {
                                    Navigator.of(context, rootNavigator: true).push(
                                      GameScreen.buildRoute(
                                        context,
                                        seek: GameSeek.custom(preferences, account),
                                      ),
                                    );
                                  }
                                  : null
                              : snapshot.connectionState == ConnectionState.waiting
                              ? null
                              : () async {
                                _pendingCreateGame = ref
                                    .read(createGameServiceProvider)
                                    .newCorrespondenceGame(
                                      GameSeek.correspondence(preferences, account),
                                    );

                                await _pendingCreateGame;
                                widget.setViewMode(_ViewMode.challenges);
                              },
                      child: Text(context.l10n.createAGame, style: Styles.bold),
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
}

String _daysLabel(num days) {
  return days == -1 ? '∞' : days.toString();
}
