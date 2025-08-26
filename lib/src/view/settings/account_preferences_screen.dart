import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/account/account_preferences.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/widgets/adaptive_choice_picker.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountPreferencesScreen extends ConsumerStatefulWidget {
  const AccountPreferencesScreen({super.key});

  static Route<dynamic> buildRoute(BuildContext context) {
    return buildScreenRoute(context, screen: const AccountPreferencesScreen());
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                context.l10n.mobileAccountPreferencesHelp,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            ListSection(
              header: SettingsSectionTitle(context.l10n.preferencesDisplay),
              hasLeading: false,
              children: [
                SettingsListTile(
                  settingsLabel: Text(context.l10n.preferencesZenMode),
                  settingsValue: data.zenMode.label(context.l10n),
                  onTap: () {
                    showChoicePicker(
                      context,
                      choices: Zen.values,
                      selectedItem: data.zenMode,
                      labelBuilder: (t) => Text(t.label(context.l10n)),
                      onSelectedItemChanged: isLoading
                          ? null
                          : (Zen? value) {
                              _setPref(
                                () => ref
                                    .read(accountPreferencesProvider.notifier)
                                    .setZen(value ?? data.zenMode),
                              );
                            },
                    );
                  },
                ),
                SettingsListTile(
                  settingsLabel: Text(context.l10n.preferencesPgnPieceNotation),
                  settingsValue: data.pieceNotation.label(context.l10n),
                  onTap: () {
                    showChoicePicker(
                      context,
                      choices: PieceNotation.values,
                      selectedItem: data.pieceNotation,
                      labelBuilder: (t) => Text(t.label(context.l10n)),
                      onSelectedItemChanged: isLoading
                          ? null
                          : (PieceNotation? value) {
                              _setPref(
                                () => ref
                                    .read(accountPreferencesProvider.notifier)
                                    .setPieceNotation(value ?? data.pieceNotation),
                              );
                            },
                    );
                  },
                ),
                SettingsListTile(
                  settingsLabel: Text(context.l10n.preferencesShowPlayerRatings),
                  settingsValue: data.showRatings.label(context.l10n),
                  onTap: () {
                    showChoicePicker(
                      context,
                      choices: ShowRatings.values,
                      selectedItem: data.showRatings,
                      labelBuilder: (t) => Text(t.label(context.l10n)),
                      onSelectedItemChanged: isLoading
                          ? null
                          : (ShowRatings? value) {
                              _setPref(
                                () => ref
                                    .read(accountPreferencesProvider.notifier)
                                    .setShowRatings(value ?? data.showRatings),
                              );
                            },
                    );
                  },
                  explanation: context.l10n.preferencesExplainShowPlayerRatings,
                ),
              ],
            ),
            ListSection(
              header: SettingsSectionTitle(context.l10n.preferencesGameBehavior),
              hasLeading: false,
              children: [
                SettingsListTile(
                  settingsLabel: Text(context.l10n.preferencesTakebacksWithOpponentApproval),
                  settingsValue: data.takeback.label(context.l10n),
                  onTap: () {
                    showChoicePicker(
                      context,
                      choices: Takeback.values,
                      selectedItem: data.takeback,
                      labelBuilder: (t) => Text(t.label(context.l10n)),
                      onSelectedItemChanged: isLoading
                          ? null
                          : (Takeback? value) {
                              _setPref(
                                () => ref
                                    .read(accountPreferencesProvider.notifier)
                                    .setTakeback(value ?? data.takeback),
                              );
                            },
                    );
                  },
                ),
                SettingsListTile(
                  settingsLabel: Text(context.l10n.preferencesPromoteToQueenAutomatically),
                  settingsValue: data.autoQueen.label(context.l10n),
                  onTap: () {
                    showChoicePicker(
                      context,
                      choices: AutoQueen.values,
                      selectedItem: data.autoQueen,
                      labelBuilder: (t) => Text(t.label(context.l10n)),
                      onSelectedItemChanged: isLoading
                          ? null
                          : (AutoQueen? value) {
                              _setPref(
                                () => ref
                                    .read(accountPreferencesProvider.notifier)
                                    .setAutoQueen(value ?? data.autoQueen),
                              );
                            },
                    );
                  },
                ),
                SettingsListTile(
                  settingsLabel: Text(
                    context.l10n.preferencesClaimDrawOnThreefoldRepetitionAutomatically,
                  ),
                  settingsValue: data.autoThreefold.label(context.l10n),
                  onTap: () {
                    showChoicePicker(
                      context,
                      choices: AutoThreefold.values,
                      selectedItem: data.autoThreefold,
                      labelBuilder: (t) => Text(t.label(context.l10n)),
                      onSelectedItemChanged: isLoading
                          ? null
                          : (AutoThreefold? value) {
                              _setPref(
                                () => ref
                                    .read(accountPreferencesProvider.notifier)
                                    .setAutoThreefold(value ?? data.autoThreefold),
                              );
                            },
                    );
                  },
                ),
                SettingsListTile(
                  settingsLabel: Text(context.l10n.preferencesMoveConfirmation),
                  settingsValue: data.submitMove.label(context.l10n),
                  onTap: () {
                    showMultipleChoicesPicker(
                      context,
                      choices: SubmitMoveChoice.values,
                      selectedItems: data.submitMove.choices,
                      labelBuilder: (t) => Text(t.label(context.l10n)),
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
                  settingsValue: data.moretime.label(context.l10n),
                  onTap: () {
                    showChoicePicker(
                      context,
                      choices: Moretime.values,
                      selectedItem: data.moretime,
                      labelBuilder: (t) => Text(t.label(context.l10n)),
                      onSelectedItemChanged: isLoading
                          ? null
                          : (Moretime? value) {
                              _setPref(
                                () => ref
                                    .read(accountPreferencesProvider.notifier)
                                    .setMoretime(value ?? data.moretime),
                              );
                            },
                    );
                  },
                ),
                SwitchSettingTile(
                  title: Text(context.l10n.preferencesSoundWhenTimeGetsCritical),
                  value: data.clockSound.value,
                  onChanged: isLoading
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
                  onChanged: isLoading
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
                  settingsValue: data.challenge.label(context.l10n),
                  onTap: () {
                    showChoicePicker(
                      context,
                      choices: Challenge.values,
                      selectedItem: data.challenge,
                      labelBuilder: (t) => Text(t.label(context.l10n)),
                      onSelectedItemChanged: isLoading
                          ? null
                          : (Challenge? value) {
                              _setPref(
                                () => ref
                                    .read(accountPreferencesProvider.notifier)
                                    .setChallenge(value ?? data.challenge),
                              );
                            },
                    );
                  },
                ),
                SettingsListTile(
                  settingsLabel: Text(context.l10n.letOtherPlayersMessageYou),
                  settingsValue: data.message.label(context.l10n),
                  onTap: () {
                    showChoicePicker(
                      context,
                      choices: Message.values,
                      selectedItem: data.message,
                      labelBuilder: (t) => Text(t.label(context.l10n)),
                      onSelectedItemChanged: isLoading
                          ? null
                          : (Message? value) {
                              _setPref(
                                () => ref
                                    .read(accountPreferencesProvider.notifier)
                                    .setMessage(value ?? data.message),
                              );
                            },
                    );
                  },
                ),
              ],
            ),
            ListSection(
              header: SettingsSectionTitle(context.l10n.security),
              hasLeading: true,
              children: [
                ListTile(
                  leading: const Icon(Icons.lock),
                  title: Text(context.l10n.changePassword),
                  trailing: const _OpenInNewIcon(),
                  onTap: () {
                    launchUrl(lichessUri('/account/passwd'));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.security),
                  title: Text(context.l10n.tfaTwoFactorAuth),
                  trailing: const _OpenInNewIcon(),
                  onTap: () {
                    launchUrl(lichessUri('/account/twofactor'));
                  },
                ),
              ],
            ),
            ListSection(
              header: const SettingsSectionTitle('Danger zone'),
              hasLeading: true,
              children: [
                if (Theme.of(context).platform == TargetPlatform.iOS)
                  ListTile(
                    leading: const Icon(Icons.dangerous_outlined),
                    title: const Text('Delete your account'),
                    trailing: const _OpenInNewIcon(),
                    onTap: () {
                      launchUrl(lichessUri('/account/delete'));
                    },
                  )
                else
                  ListTile(
                    leading: const Icon(Icons.dangerous_outlined),
                    title: Text(context.l10n.settingsCloseAccount),
                    trailing: const _OpenInNewIcon(),
                    onTap: () {
                      launchUrl(lichessUri('/account/close'));
                    },
                  ),
              ],
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
      error: (err, _) {
        return FullScreenRetryRequest(onRetry: () => ref.invalidate(accountPreferencesProvider));
      },
    );

    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(context.l10n.mobileAccountPreferences),
        actions: [if (isLoading) const PlatformAppBarLoadingIndicator()],
      ),
      body: content,
    );
  }
}

class _OpenInNewIcon extends StatelessWidget {
  const _OpenInNewIcon();

  @override
  Widget build(BuildContext context) {
    return const Icon(Icons.open_in_new, size: 18);
  }
}
