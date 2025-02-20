import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/account/account_preferences.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/widgets/adaptive_choice_picker.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform_scaffold.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';

class AccountPreferencesScreen extends ConsumerStatefulWidget {
  const AccountPreferencesScreen({super.key});

  static Route<dynamic> buildRoute(BuildContext context) {
    return buildScreenRoute(
      context,
      screen: const AccountPreferencesScreen(),
      title: context.l10n.preferencesPreferences,
    );
  }

  @override
  ConsumerState<AccountPreferencesScreen> createState() => _AccountPreferencesScreenState();
}

class _AccountPreferencesScreenState extends ConsumerState<AccountPreferencesScreen> {
  bool isLoading = false;

  Future<void> _setPref(Future<void> Function() f) async {
    setState(() {
      isLoading = true;
    });
    try {
      await f();
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final accountPrefs = ref.watch(accountPreferencesProvider);

    final content = accountPrefs.when(
      data: (data) {
        if (data == null) {
          return Center(child: Text(context.l10n.mobileMustBeLoggedIn));
        }

        return ListView(
          children: [
            ListSection(
              header: SettingsSectionTitle(context.l10n.preferencesDisplay),
              hasLeading: false,
              children: [
                SettingsListTile(
                  settingsLabel: Text(context.l10n.preferencesZenMode),
                  settingsValue: data.zenMode.label(context),
                  showCupertinoTrailingValue: false,
                  onTap: () {
                    if (Theme.of(context).platform == TargetPlatform.android) {
                      showChoicePicker(
                        context,
                        choices: Zen.values,
                        selectedItem: data.zenMode,
                        labelBuilder: (t) => Text(t.label(context)),
                        onSelectedItemChanged:
                            isLoading
                                ? null
                                : (Zen? value) {
                                  _setPref(
                                    () => ref
                                        .read(accountPreferencesProvider.notifier)
                                        .setZen(value ?? data.zenMode),
                                  );
                                },
                      );
                    } else {
                      Navigator.of(context).push(ZenSettingsScreen.buildRoute(context));
                    }
                  },
                ),
                SettingsListTile(
                  settingsLabel: Text(context.l10n.preferencesPgnPieceNotation),
                  settingsValue: data.pieceNotation.label(context),
                  showCupertinoTrailingValue: false,
                  onTap: () {
                    if (Theme.of(context).platform == TargetPlatform.android) {
                      showChoicePicker(
                        context,
                        choices: PieceNotation.values,
                        selectedItem: data.pieceNotation,
                        labelBuilder: (t) => Text(t.label(context)),
                        onSelectedItemChanged:
                            isLoading
                                ? null
                                : (PieceNotation? value) {
                                  _setPref(
                                    () => ref
                                        .read(accountPreferencesProvider.notifier)
                                        .setPieceNotation(value ?? data.pieceNotation),
                                  );
                                },
                      );
                    } else {
                      Navigator.of(context).push(PieceNotationSettingsScreen.buildRoute(context));
                    }
                  },
                ),
                SettingsListTile(
                  settingsLabel: Text(context.l10n.preferencesShowPlayerRatings),
                  settingsValue: data.showRatings.label(context),
                  showCupertinoTrailingValue: false,
                  onTap: () {
                    if (Theme.of(context).platform == TargetPlatform.android) {
                      showChoicePicker(
                        context,
                        choices: ShowRatings.values,
                        selectedItem: data.showRatings,
                        labelBuilder: (t) => Text(t.label(context)),
                        onSelectedItemChanged:
                            isLoading
                                ? null
                                : (ShowRatings? value) {
                                  _setPref(
                                    () => ref
                                        .read(accountPreferencesProvider.notifier)
                                        .setShowRatings(value ?? data.showRatings),
                                  );
                                },
                      );
                    } else {
                      Navigator.of(context).push(ShowRatingsSettingsScreen.buildRoute(context));
                    }
                  },
                  explanation: context.l10n.preferencesExplainShowPlayerRatings,
                ),
              ],
            ),
            ListSection(
              header: SettingsSectionTitle(context.l10n.preferencesGameBehavior),
              hasLeading: false,
              children: [
                SwitchSettingTile(
                  title: Text(context.l10n.preferencesPremovesPlayingDuringOpponentTurn),
                  value: data.premove.value,
                  onChanged:
                      isLoading
                          ? null
                          : (value) {
                            _setPref(
                              () => ref
                                  .read(accountPreferencesProvider.notifier)
                                  .setPremove(BooleanPref(value)),
                            );
                          },
                ),
                SwitchSettingTile(
                  title: Text(context.l10n.preferencesConfirmResignationAndDrawOffers),
                  value: data.confirmResign.value,
                  onChanged:
                      isLoading
                          ? null
                          : (value) {
                            _setPref(
                              () => ref
                                  .read(accountPreferencesProvider.notifier)
                                  .setConfirmResign(BooleanPref(value)),
                            );
                          },
                ),
                SettingsListTile(
                  settingsLabel: Text(context.l10n.preferencesTakebacksWithOpponentApproval),
                  settingsValue: data.takeback.label(context),
                  showCupertinoTrailingValue: false,
                  onTap: () {
                    if (Theme.of(context).platform == TargetPlatform.android) {
                      showChoicePicker(
                        context,
                        choices: Takeback.values,
                        selectedItem: data.takeback,
                        labelBuilder: (t) => Text(t.label(context)),
                        onSelectedItemChanged:
                            isLoading
                                ? null
                                : (Takeback? value) {
                                  _setPref(
                                    () => ref
                                        .read(accountPreferencesProvider.notifier)
                                        .setTakeback(value ?? data.takeback),
                                  );
                                },
                      );
                    } else {
                      Navigator.of(context).push(TakebackSettingsScreen.buildRoute(context));
                    }
                  },
                ),
                SettingsListTile(
                  settingsLabel: Text(context.l10n.preferencesPromoteToQueenAutomatically),
                  settingsValue: data.autoQueen.label(context),
                  showCupertinoTrailingValue: false,
                  onTap: () {
                    if (Theme.of(context).platform == TargetPlatform.android) {
                      showChoicePicker(
                        context,
                        choices: AutoQueen.values,
                        selectedItem: data.autoQueen,
                        labelBuilder: (t) => Text(t.label(context)),
                        onSelectedItemChanged:
                            isLoading
                                ? null
                                : (AutoQueen? value) {
                                  _setPref(
                                    () => ref
                                        .read(accountPreferencesProvider.notifier)
                                        .setAutoQueen(value ?? data.autoQueen),
                                  );
                                },
                      );
                    } else {
                      Navigator.of(context).push(AutoQueenSettingsScreen.buildRoute(context));
                    }
                  },
                ),
                SettingsListTile(
                  settingsLabel: Text(
                    context.l10n.preferencesClaimDrawOnThreefoldRepetitionAutomatically,
                  ),
                  settingsValue: data.autoThreefold.label(context),
                  showCupertinoTrailingValue: false,
                  onTap: () {
                    if (Theme.of(context).platform == TargetPlatform.android) {
                      showChoicePicker(
                        context,
                        choices: AutoThreefold.values,
                        selectedItem: data.autoThreefold,
                        labelBuilder: (t) => Text(t.label(context)),
                        onSelectedItemChanged:
                            isLoading
                                ? null
                                : (AutoThreefold? value) {
                                  _setPref(
                                    () => ref
                                        .read(accountPreferencesProvider.notifier)
                                        .setAutoThreefold(value ?? data.autoThreefold),
                                  );
                                },
                      );
                    } else {
                      Navigator.of(context).push(AutoThreefoldSettingsScreen.buildRoute(context));
                    }
                  },
                ),
                SettingsListTile(
                  settingsLabel: Text(context.l10n.preferencesMoveConfirmation),
                  settingsValue: data.submitMove.label(context),
                  showCupertinoTrailingValue: false,
                  onTap: () {
                    showMultipleChoicesPicker(
                      context,
                      choices: SubmitMoveChoice.values,
                      selectedItems: data.submitMove.choices,
                      labelBuilder: (t) => Text(t.label(context)),
                    ).then((value) {
                      if (value != null) {
                        _setPref(
                          () => ref
                              .read(accountPreferencesProvider.notifier)
                              .setSubmitMove(SubmitMove(value)),
                        );
                      }
                    });
                  },
                  explanation: context.l10n.preferencesExplainCanThenBeTemporarilyDisabled,
                ),
              ],
            ),
            ListSection(
              header: SettingsSectionTitle(context.l10n.preferencesChessClock),
              hasLeading: false,
              children: [
                SettingsListTile(
                  settingsLabel: Text(context.l10n.preferencesGiveMoreTime),
                  settingsValue: data.moretime.label(context),
                  showCupertinoTrailingValue: false,
                  onTap: () {
                    if (Theme.of(context).platform == TargetPlatform.android) {
                      showChoicePicker(
                        context,
                        choices: Moretime.values,
                        selectedItem: data.moretime,
                        labelBuilder: (t) => Text(t.label(context)),
                        onSelectedItemChanged:
                            isLoading
                                ? null
                                : (Moretime? value) {
                                  _setPref(
                                    () => ref
                                        .read(accountPreferencesProvider.notifier)
                                        .setMoretime(value ?? data.moretime),
                                  );
                                },
                      );
                    } else {
                      Navigator.of(context).push(MoretimeSettingsScreen.buildRoute(context));
                    }
                  },
                ),
                SwitchSettingTile(
                  title: Text(context.l10n.preferencesSoundWhenTimeGetsCritical),
                  value: data.clockSound.value,
                  onChanged:
                      isLoading
                          ? null
                          : (value) {
                            _setPref(
                              () => ref
                                  .read(accountPreferencesProvider.notifier)
                                  .setClockSound(BooleanPref(value)),
                            );
                          },
                ),
              ],
            ),
            ListSection(
              header: SettingsSectionTitle(context.l10n.preferencesPrivacy),
              hasLeading: false,
              children: [
                SwitchSettingTile(
                  title: Text(context.l10n.letOtherPlayersFollowYou),
                  value: data.follow.value,
                  onChanged:
                      isLoading
                          ? null
                          : (value) {
                            _setPref(
                              () => ref
                                  .read(accountPreferencesProvider.notifier)
                                  .setFollow(BooleanPref(value)),
                            );
                          },
                ),
                SettingsListTile(
                  settingsLabel: Text(context.l10n.letOtherPlayersChallengeYou),
                  settingsValue: data.challenge.label(context),
                  showCupertinoTrailingValue: false,
                  onTap: () {
                    if (Theme.of(context).platform == TargetPlatform.android) {
                      showChoicePicker(
                        context,
                        choices: Challenge.values,
                        selectedItem: data.challenge,
                        labelBuilder: (t) => Text(t.label(context)),
                        onSelectedItemChanged:
                            isLoading
                                ? null
                                : (Challenge? value) {
                                  _setPref(
                                    () => ref
                                        .read(accountPreferencesProvider.notifier)
                                        .setChallenge(value ?? data.challenge),
                                  );
                                },
                      );
                    } else {
                      Navigator.of(context).push(_ChallengeSettingsScreen.buildRoute(context));
                    }
                  },
                ),
              ],
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) {
        return FullScreenRetryRequest(onRetry: () => ref.invalidate(accountPreferencesProvider));
      },
    );

    return PlatformScaffold(
      appBarTitle: Text(context.l10n.preferencesPreferences),
      appBarActions: [if (isLoading) const PlatformAppBarLoadingIndicator()],
      body: content,
    );
  }
}

class ZenSettingsScreen extends ConsumerStatefulWidget {
  const ZenSettingsScreen({super.key});

  static Route<dynamic> buildRoute(BuildContext context) {
    return buildScreenRoute(
      context,
      screen: const ZenSettingsScreen(),
      title: context.l10n.preferencesZenMode,
    );
  }

  @override
  ConsumerState<ZenSettingsScreen> createState() => _ZenSettingsScreenState();
}

class _ZenSettingsScreenState extends ConsumerState<ZenSettingsScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final accountPrefs = ref.watch(accountPreferencesProvider);
    return accountPrefs.when(
      data: (data) {
        if (data == null) {
          return Center(child: Text(context.l10n.mobileMustBeLoggedIn));
        }

        return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            trailing: isLoading ? const CircularProgressIndicator.adaptive() : null,
          ),
          child: ListView(
            children: [
              ChoicePicker(
                choices: Zen.values,
                selectedItem: data.zenMode,
                titleBuilder: (t) => Text(t.label(context)),
                onSelectedItemChanged:
                    isLoading
                        ? null
                        : (Zen? v) async {
                          setState(() {
                            isLoading = true;
                          });
                          try {
                            await ref
                                .read(accountPreferencesProvider.notifier)
                                .setZen(v ?? data.zenMode);
                          } finally {
                            setState(() {
                              isLoading = false;
                            });
                          }
                        },
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text(err.toString())),
    );
  }
}

class PieceNotationSettingsScreen extends ConsumerStatefulWidget {
  const PieceNotationSettingsScreen({super.key});

  static Route<dynamic> buildRoute(BuildContext context) {
    return buildScreenRoute(
      context,
      screen: const PieceNotationSettingsScreen(),
      title: context.l10n.preferencesPgnPieceNotation,
    );
  }

  @override
  ConsumerState<PieceNotationSettingsScreen> createState() => _PieceNotationSettingsScreenState();
}

class _PieceNotationSettingsScreenState extends ConsumerState<PieceNotationSettingsScreen> {
  Future<void>? _pendingSetPieceNotation;

  @override
  Widget build(BuildContext context) {
    final accountPrefs = ref.watch(accountPreferencesProvider);
    return accountPrefs.when(
      data: (data) {
        if (data == null) {
          return Center(child: Text(context.l10n.mobileMustBeLoggedIn));
        }

        return FutureBuilder(
          future: _pendingSetPieceNotation,
          builder: (context, snapshot) {
            return CupertinoPageScaffold(
              navigationBar: CupertinoNavigationBar(
                trailing:
                    snapshot.connectionState == ConnectionState.waiting
                        ? const CircularProgressIndicator.adaptive()
                        : null,
              ),
              child: ListView(
                children: [
                  ChoicePicker(
                    choices: PieceNotation.values,
                    selectedItem: data.pieceNotation,
                    titleBuilder: (t) => Text(t.label(context)),
                    onSelectedItemChanged:
                        snapshot.connectionState == ConnectionState.waiting
                            ? null
                            : (PieceNotation? v) {
                              final future = ref
                                  .read(accountPreferencesProvider.notifier)
                                  .setPieceNotation(v ?? data.pieceNotation);
                              setState(() {
                                _pendingSetPieceNotation = future;
                              });
                            },
                  ),
                ],
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text(err.toString())),
    );
  }
}

class ShowRatingsSettingsScreen extends ConsumerStatefulWidget {
  const ShowRatingsSettingsScreen({super.key});

  static Route<dynamic> buildRoute(BuildContext context) {
    return buildScreenRoute(
      context,
      screen: const ShowRatingsSettingsScreen(),
      title: context.l10n.preferencesShowPlayerRatings,
    );
  }

  @override
  ConsumerState<ShowRatingsSettingsScreen> createState() => _ShowRatingsSettingsScreenState();
}

class _ShowRatingsSettingsScreenState extends ConsumerState<ShowRatingsSettingsScreen> {
  Future<void>? _pendingSetShowRatings;

  @override
  Widget build(BuildContext context) {
    final accountPrefs = ref.watch(accountPreferencesProvider);
    return accountPrefs.when(
      data: (data) {
        if (data == null) {
          return Center(child: Text(context.l10n.mobileMustBeLoggedIn));
        }

        return FutureBuilder(
          future: _pendingSetShowRatings,
          builder: (context, snapshot) {
            return CupertinoPageScaffold(
              navigationBar: CupertinoNavigationBar(
                trailing:
                    snapshot.connectionState == ConnectionState.waiting
                        ? const CircularProgressIndicator.adaptive()
                        : null,
              ),
              child: ListView(
                children: [
                  ChoicePicker(
                    choices: ShowRatings.values,
                    selectedItem: data.showRatings,
                    titleBuilder: (t) => Text(t.label(context)),
                    onSelectedItemChanged:
                        snapshot.connectionState == ConnectionState.waiting
                            ? null
                            : (ShowRatings? v) {
                              final future = ref
                                  .read(accountPreferencesProvider.notifier)
                                  .setShowRatings(v ?? data.showRatings);
                              setState(() {
                                _pendingSetShowRatings = future;
                              });
                            },
                  ),
                ],
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text(err.toString())),
    );
  }
}

class TakebackSettingsScreen extends ConsumerStatefulWidget {
  const TakebackSettingsScreen({super.key});

  static Route<dynamic> buildRoute(BuildContext context) {
    return buildScreenRoute(
      context,
      screen: const TakebackSettingsScreen(),
      title: context.l10n.preferencesTakebacksWithOpponentApproval,
    );
  }

  @override
  ConsumerState<TakebackSettingsScreen> createState() => _TakebackSettingsScreenState();
}

class _TakebackSettingsScreenState extends ConsumerState<TakebackSettingsScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final accountPrefs = ref.watch(accountPreferencesProvider);
    return accountPrefs.when(
      data: (data) {
        if (data == null) {
          return Center(child: Text(context.l10n.mobileMustBeLoggedIn));
        }

        return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            trailing: isLoading ? const CircularProgressIndicator.adaptive() : null,
          ),
          child: ListView(
            children: [
              ChoicePicker(
                choices: Takeback.values,
                selectedItem: data.takeback,
                titleBuilder: (t) => Text(t.label(context)),
                onSelectedItemChanged:
                    isLoading
                        ? null
                        : (Takeback? v) async {
                          setState(() {
                            isLoading = true;
                          });
                          try {
                            await ref
                                .read(accountPreferencesProvider.notifier)
                                .setTakeback(v ?? data.takeback);
                          } finally {
                            setState(() {
                              isLoading = false;
                            });
                          }
                        },
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text(err.toString())),
    );
  }
}

class AutoQueenSettingsScreen extends ConsumerStatefulWidget {
  const AutoQueenSettingsScreen({super.key});

  static Route<dynamic> buildRoute(BuildContext context) {
    return buildScreenRoute(
      context,
      screen: const AutoQueenSettingsScreen(),
      title: context.l10n.preferencesPromoteToQueenAutomatically,
    );
  }

  @override
  ConsumerState<AutoQueenSettingsScreen> createState() => _AutoQueenSettingsScreenState();
}

class _AutoQueenSettingsScreenState extends ConsumerState<AutoQueenSettingsScreen> {
  Future<void>? _pendingSetAutoQueen;

  @override
  Widget build(BuildContext context) {
    final accountPrefs = ref.watch(accountPreferencesProvider);
    return accountPrefs.when(
      data: (data) {
        if (data == null) {
          return Center(child: Text(context.l10n.mobileMustBeLoggedIn));
        }

        return FutureBuilder(
          future: _pendingSetAutoQueen,
          builder: (context, snapshot) {
            return CupertinoPageScaffold(
              navigationBar: CupertinoNavigationBar(
                trailing:
                    snapshot.connectionState == ConnectionState.waiting
                        ? const CircularProgressIndicator.adaptive()
                        : null,
              ),
              child: ListView(
                children: [
                  ChoicePicker(
                    choices: AutoQueen.values,
                    selectedItem: data.autoQueen,
                    titleBuilder: (t) => Text(t.label(context)),
                    onSelectedItemChanged:
                        snapshot.connectionState == ConnectionState.waiting
                            ? null
                            : (AutoQueen? v) {
                              final future = ref
                                  .read(accountPreferencesProvider.notifier)
                                  .setAutoQueen(v ?? data.autoQueen);
                              setState(() {
                                _pendingSetAutoQueen = future;
                              });
                            },
                  ),
                ],
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text(err.toString())),
    );
  }
}

class AutoThreefoldSettingsScreen extends ConsumerStatefulWidget {
  const AutoThreefoldSettingsScreen({super.key});

  static Route<dynamic> buildRoute(BuildContext context) {
    return buildScreenRoute(
      context,
      screen: const AutoThreefoldSettingsScreen(),
      title: context.l10n.preferencesClaimDrawOnThreefoldRepetitionAutomatically,
    );
  }

  @override
  ConsumerState<AutoThreefoldSettingsScreen> createState() => _AutoThreefoldSettingsScreenState();
}

class _AutoThreefoldSettingsScreenState extends ConsumerState<AutoThreefoldSettingsScreen> {
  Future<void>? _pendingSetAutoThreefold;

  @override
  Widget build(BuildContext context) {
    final accountPrefs = ref.watch(accountPreferencesProvider);
    return accountPrefs.when(
      data: (data) {
        if (data == null) {
          return Center(child: Text(context.l10n.mobileMustBeLoggedIn));
        }

        return FutureBuilder(
          future: _pendingSetAutoThreefold,
          builder: (context, snapshot) {
            return CupertinoPageScaffold(
              navigationBar: CupertinoNavigationBar(
                trailing:
                    snapshot.connectionState == ConnectionState.waiting
                        ? const CircularProgressIndicator.adaptive()
                        : null,
              ),
              child: ListView(
                children: [
                  ChoicePicker(
                    choices: AutoThreefold.values,
                    selectedItem: data.autoThreefold,
                    titleBuilder: (t) => Text(t.label(context)),
                    onSelectedItemChanged:
                        snapshot.connectionState == ConnectionState.waiting
                            ? null
                            : (AutoThreefold? v) {
                              final future = ref
                                  .read(accountPreferencesProvider.notifier)
                                  .setAutoThreefold(v ?? data.autoThreefold);
                              setState(() {
                                _pendingSetAutoThreefold = future;
                              });
                            },
                  ),
                ],
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text(err.toString())),
    );
  }
}

class MoretimeSettingsScreen extends ConsumerStatefulWidget {
  const MoretimeSettingsScreen({super.key});

  static Route<dynamic> buildRoute(BuildContext context) {
    return buildScreenRoute(
      context,
      screen: const MoretimeSettingsScreen(),
      title: context.l10n.preferencesGiveMoreTime,
    );
  }

  @override
  ConsumerState<MoretimeSettingsScreen> createState() => _MoretimeSettingsScreenState();
}

class _MoretimeSettingsScreenState extends ConsumerState<MoretimeSettingsScreen> {
  Future<void>? _pendingSetMoretime;

  @override
  Widget build(BuildContext context) {
    final accountPrefs = ref.watch(accountPreferencesProvider);
    return accountPrefs.when(
      data: (data) {
        if (data == null) {
          return Center(child: Text(context.l10n.mobileMustBeLoggedIn));
        }

        return FutureBuilder(
          future: _pendingSetMoretime,
          builder: (context, snapshot) {
            return CupertinoPageScaffold(
              navigationBar: CupertinoNavigationBar(
                trailing:
                    snapshot.connectionState == ConnectionState.waiting
                        ? const CircularProgressIndicator.adaptive()
                        : null,
              ),
              child: ListView(
                children: [
                  ChoicePicker(
                    choices: Moretime.values,
                    selectedItem: data.moretime,
                    titleBuilder: (t) => Text(t.label(context)),
                    onSelectedItemChanged:
                        snapshot.connectionState == ConnectionState.waiting
                            ? null
                            : (Moretime? v) {
                              setState(() {
                                _pendingSetMoretime = ref
                                    .read(accountPreferencesProvider.notifier)
                                    .setMoretime(v ?? data.moretime);
                              });
                            },
                  ),
                ],
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text(err.toString())),
    );
  }
}

class _ChallengeSettingsScreen extends ConsumerStatefulWidget {
  const _ChallengeSettingsScreen();

  static Route<dynamic> buildRoute(BuildContext context) {
    return buildScreenRoute(
      context,
      screen: const _ChallengeSettingsScreen(),
      title: context.l10n.letOtherPlayersChallengeYou,
    );
  }

  @override
  ConsumerState<_ChallengeSettingsScreen> createState() => _ChallengeSettingsScreenState();
}

class _ChallengeSettingsScreenState extends ConsumerState<_ChallengeSettingsScreen> {
  Future<void>? _pendingSetChallenge;

  @override
  Widget build(BuildContext context) {
    final accountPrefs = ref.watch(accountPreferencesProvider);
    return accountPrefs.when(
      data: (data) {
        if (data == null) {
          return Center(child: Text(context.l10n.mobileMustBeLoggedIn));
        }

        return FutureBuilder(
          future: _pendingSetChallenge,
          builder: (context, snapshot) {
            return CupertinoPageScaffold(
              navigationBar: CupertinoNavigationBar(
                trailing:
                    snapshot.connectionState == ConnectionState.waiting
                        ? const CircularProgressIndicator.adaptive()
                        : null,
              ),
              child: ListView(
                children: [
                  ChoicePicker(
                    choices: Challenge.values,
                    selectedItem: data.challenge,
                    titleBuilder: (t) => Text(t.label(context)),
                    onSelectedItemChanged:
                        snapshot.connectionState == ConnectionState.waiting
                            ? null
                            : (Challenge? v) {
                              final future = ref
                                  .read(accountPreferencesProvider.notifier)
                                  .setChallenge(v ?? data.challenge);
                              setState(() {
                                _pendingSetChallenge = future;
                              });
                            },
                  ),
                ],
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text(err.toString())),
    );
  }
}
