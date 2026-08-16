import 'package:chessground/chessground.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/model/account/account_preferences.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/network/connectivity.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/utils/screen.dart';
import 'package:lichess_mobile/src/utils/system.dart';
import 'package:lichess_mobile/src/view/settings/board_choice_screen.dart';
import 'package:lichess_mobile/src/view/settings/piece_set_screen.dart';
import 'package:lichess_mobile/src/widgets/adaptive_choice_picker.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';

class BoardSettingsScreen extends ConsumerStatefulWidget {
  const BoardSettingsScreen({super.key});

  static Route<dynamic> buildRoute({bool fullscreenDialog = false}) {
    return buildScreenRoute(
      fullscreenDialog: fullscreenDialog,
      screen: const BoardSettingsScreen(),
    );
  }

  @override
  ConsumerState<BoardSettingsScreen> createState() => _BoardSettingsScreenState();
}

class _BoardSettingsScreenState extends ConsumerState<BoardSettingsScreen> {
  bool isLoading = false;

  Future<void> _setAccountPref(Future<void> Function(AccountPreferences preferences) save) async {
    setState(() {
      isLoading = true;
    });
    try {
      final authUser = ref.read(authControllerProvider);
      await save(ref.read(accountPreferencesProvider.notifier));
      if (authUser != null && mounted) {
        showSnackBar(
          context,
          // TODO l10n
          'Your preference have been saved in your Lichess account. It will be synchronized across all your devices.',
          type: SnackBarType.success,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final boardPrefs = ref.watch(boardPreferencesProvider);
    final accountPrefsAsync = ref.watch(accountPreferencesProvider);
    final accountPrefs = accountPrefsAsync.value ?? defaultAccountPreferences;
    final authUser = ref.watch(authControllerProvider);
    final isOnline = ref.watch(onlineStatusProvider).value ?? false;
    // We only allow changing account preferences if the user is logged out (prefs are local in that
    // case) or if the user is logged in and online (prefs are stored on the server in that case).
    final accountPrefsEnabled =
        accountPrefsAsync.hasValue && !isLoading && (authUser == null || isOnline);
    final androidVersionAsync = ref.watch(androidVersionProvider);

    // Correspondence and unlimited time controls require an account, so anonymous
    // players cannot enable move confirmation for them.
    final submitMoveChoices = authUser == null
        ? SubmitMoveChoice.values
              .where((c) => c != SubmitMoveChoice.correspondence && c != SubmitMoveChoice.unlimited)
              .toList()
        : SubmitMoveChoice.values;
    final submitMove = authUser == null
        ? SubmitMove(accountPrefs.submitMove.choices.where(submitMoveChoices.contains))
        : accountPrefs.submitMove;

    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(context.l10n.mobileBoardSettings),
        actions: [if (isLoading) const PlatformAppBarLoadingIndicator()],
      ),
      body: ListView(
        children: [
          ListSection(
            header: SettingsSectionTitle(context.l10n.preferencesDisplay),
            hasLeading: false,
            children: [
              SettingsListTile(
                settingsLabel: Text(context.l10n.board),
                settingsValue: boardPrefs.boardTheme.label,
                onTap: () {
                  Navigator.of(context).push(BoardChoiceScreen.buildRoute());
                },
              ),
              SettingsListTile(
                settingsLabel: Text(context.l10n.pieceSet),
                settingsValue: boardPrefs.pieceSet.label,
                onTap: () {
                  Navigator.of(context).push(PieceSetScreen.buildRoute());
                },
              ),
              SettingsListTile(
                enabled: accountPrefsEnabled,
                settingsLabel: Text(context.l10n.preferencesZenMode),
                settingsValue: accountPrefs.zenMode.label(context.l10n),
                onTap: accountPrefsEnabled
                    ? () {
                        showChoicePicker(
                          context,
                          choices: Zen.values,
                          selectedItem: accountPrefs.zenMode,
                          labelBuilder: (t) => Text(t.label(context.l10n)),
                          onSelectedItemChanged: (Zen? value) {
                            _setAccountPref((prefs) => prefs.setZen(value ?? accountPrefs.zenMode));
                          },
                        );
                      }
                    : null,
              ),
              SettingsListTile(
                enabled: accountPrefsEnabled,
                settingsLabel: Text(context.l10n.preferencesPgnPieceNotation),
                settingsValue: accountPrefs.pieceNotation.label(context.l10n),
                onTap: accountPrefsEnabled
                    ? () {
                        showChoicePicker(
                          context,
                          choices: PieceNotation.values,
                          selectedItem: accountPrefs.pieceNotation,
                          labelBuilder: (t) => Text(t.label(context.l10n)),
                          onSelectedItemChanged: (PieceNotation? value) {
                            _setAccountPref(
                              (prefs) =>
                                  prefs.setPieceNotation(value ?? accountPrefs.pieceNotation),
                            );
                          },
                        );
                      }
                    : null,
              ),
              SwitchSettingTile(
                title: Text(context.l10n.preferencesBoardCoordinates),
                value: boardPrefs.coordinates,
                onChanged: (value) {
                  ref.read(boardPreferencesProvider.notifier).toggleCoordinates();
                },
              ),
              SwitchSettingTile(
                title: Text(context.l10n.mobilePrefMagnifyDraggedPiece),
                value: boardPrefs.magnifyDraggedPiece,
                onChanged: (value) {
                  ref.read(boardPreferencesProvider.notifier).toggleMagnifyDraggedPiece();
                },
              ),
              SettingsListTile(
                settingsLabel: Text(context.l10n.mobileSettingsDraggedPieceTarget),
                settingsValue: dragTargetKindLabel(context.l10n, boardPrefs.dragTargetKind),
                onTap: () {
                  showChoicePicker(
                    context,
                    choices: DragTargetKind.values,
                    selectedItem: boardPrefs.dragTargetKind,
                    labelBuilder: (t) => Text(dragTargetKindLabel(context.l10n, t)),
                    onSelectedItemChanged: (DragTargetKind? value) {
                      ref
                          .read(boardPreferencesProvider.notifier)
                          .setDragTargetKind(value ?? DragTargetKind.circle);
                    },
                  );
                },
              ),
              SwitchSettingTile(
                title: Text(context.l10n.preferencesPieceAnimation),
                value: boardPrefs.pieceAnimation,
                onChanged: (value) {
                  ref.read(boardPreferencesProvider.notifier).togglePieceAnimation();
                },
              ),
              if (Theme.of(context).platform == TargetPlatform.android &&
                  !isTabletOrLarger(context))
                androidVersionAsync.maybeWhen(
                  data: (version) => version != null && version.sdkInt >= 29
                      ? SwitchSettingTile(
                          title: Text(context.l10n.mobileSettingsImmersiveMode),
                          subtitle: Text(
                            context.l10n.mobileSettingsImmersiveModeSubtitle,
                            maxLines: 5,
                          ),
                          value: boardPrefs.immersiveModeWhilePlaying ?? false,
                          onChanged: (value) {
                            ref
                                .read(boardPreferencesProvider.notifier)
                                .toggleImmersiveModeWhilePlaying();
                          },
                        )
                      : const SizedBox.shrink(),
                  orElse: () => const SizedBox.shrink(),
                ),
              SwitchSettingTile(
                title: Text(context.l10n.preferencesPieceDestinations),
                value: boardPrefs.showLegalMoves,
                onChanged: (value) {
                  ref.read(boardPreferencesProvider.notifier).toggleShowLegalMoves();
                },
              ),
              SwitchSettingTile(
                title: Text(context.l10n.preferencesBoardHighlights),
                value: boardPrefs.boardHighlights,
                onChanged: (value) {
                  ref.read(boardPreferencesProvider.notifier).toggleBoardHighlights();
                },
              ),
              if (!isShortVerticalScreen(context))
                SwitchSettingTile(
                  title: Text(context.l10n.preferencesMoveListWhilePlaying),
                  value: boardPrefs.moveListDisplay,
                  onChanged: (value) {
                    ref.read(boardPreferencesProvider.notifier).toggleMoveListDisplay();
                  },
                ),
              SettingsListTile(
                settingsLabel: Text(context.l10n.preferencesMaterialDifference),
                settingsValue: boardPrefs.materialDifferenceFormat.l10n(
                  AppLocalizations.of(context),
                ),
                onTap: () {
                  showChoicePicker(
                    context,
                    choices: MaterialDifferenceFormat.values,
                    selectedItem: boardPrefs.materialDifferenceFormat,
                    labelBuilder: (t) => Text(t.l10n(context.l10n)),
                    onSelectedItemChanged: (MaterialDifferenceFormat? value) => ref
                        .read(boardPreferencesProvider.notifier)
                        .setMaterialDifferenceFormat(
                          value ?? MaterialDifferenceFormat.materialDifference,
                        ),
                  );
                },
              ),
              SettingsListTile(
                settingsLabel: Text(context.l10n.mobileSettingsClockPosition),
                settingsValue: boardPrefs.clockPosition.label(context.l10n),
                onTap: () {
                  showChoicePicker(
                    context,
                    choices: ClockPosition.values,
                    selectedItem: boardPrefs.clockPosition,
                    labelBuilder: (t) => Text(t.label(context.l10n)),
                    onSelectedItemChanged: (ClockPosition? value) => ref
                        .read(boardPreferencesProvider.notifier)
                        .setClockPosition(value ?? ClockPosition.right),
                  );
                },
              ),
              if (isTabletOrLarger(context))
                SettingsListTile(
                  settingsLabel: const Text('Board position in landscape mode'), // TODO l10n
                  settingsValue: boardPrefs.landscapeBoardPosition.label(context.l10n),
                  onTap: () {
                    showChoicePicker(
                      context,
                      choices: LandscapeBoardPosition.values,
                      selectedItem: boardPrefs.landscapeBoardPosition,
                      labelBuilder: (t) => Text(t.label(context.l10n)),
                      onSelectedItemChanged: (LandscapeBoardPosition? value) => ref
                          .read(boardPreferencesProvider.notifier)
                          .setLandscapeBoardPosition(value ?? LandscapeBoardPosition.left),
                    );
                  },
                ),
            ],
          ),
          ListSection(
            header: SettingsSectionTitle(context.l10n.preferencesGameBehavior),
            hasLeading: false,
            children: [
              SwitchSettingTile(
                title: Text(context.l10n.preferencesPremovesPlayingDuringOpponentTurn),
                value: boardPrefs.premoves,
                onChanged: (value) {
                  ref.read(boardPreferencesProvider.notifier).togglePremoves();
                },
              ),
              // takebacks are always enabled for anonymous players, so hide the setting.
              if (authUser != null)
                SettingsListTile(
                  enabled: accountPrefsEnabled,
                  settingsLabel: Text(context.l10n.preferencesTakebacksWithOpponentApproval),
                  settingsValue: accountPrefs.takeback.label(context.l10n),
                  onTap: accountPrefsEnabled
                      ? () {
                          showChoicePicker(
                            context,
                            choices: Takeback.values,
                            selectedItem: accountPrefs.takeback,
                            labelBuilder: (t) => Text(t.label(context.l10n)),
                            onSelectedItemChanged: (Takeback? value) {
                              _setAccountPref(
                                (prefs) => prefs.setTakeback(value ?? accountPrefs.takeback),
                              );
                            },
                          );
                        }
                      : null,
                ),
              SettingsListTile(
                enabled: accountPrefsEnabled,
                settingsLabel: Text(context.l10n.preferencesPromoteToQueenAutomatically),
                settingsValue: accountPrefs.autoQueen.label(context.l10n),
                onTap: accountPrefsEnabled
                    ? () {
                        showChoicePicker(
                          context,
                          choices: AutoQueen.values,
                          selectedItem: accountPrefs.autoQueen,
                          labelBuilder: (t) => Text(t.label(context.l10n)),
                          onSelectedItemChanged: (AutoQueen? value) {
                            _setAccountPref(
                              (prefs) => prefs.setAutoQueen(value ?? accountPrefs.autoQueen),
                            );
                          },
                        );
                      }
                    : null,
              ),
              // Auto threefold is decided server side, so hide the setting for anonymous players.
              if (authUser != null)
                SettingsListTile(
                  enabled: accountPrefsEnabled,
                  settingsLabel: Text(
                    context.l10n.preferencesClaimDrawOnThreefoldRepetitionAutomatically,
                  ),
                  settingsValue: accountPrefs.autoThreefold.label(context.l10n),
                  onTap: accountPrefsEnabled
                      ? () {
                          showChoicePicker(
                            context,
                            choices: AutoThreefold.values,
                            selectedItem: accountPrefs.autoThreefold,
                            labelBuilder: (t) => Text(t.label(context.l10n)),
                            onSelectedItemChanged: (AutoThreefold? value) {
                              _setAccountPref(
                                (prefs) =>
                                    prefs.setAutoThreefold(value ?? accountPrefs.autoThreefold),
                              );
                            },
                          );
                        }
                      : null,
                ),
              SettingsListTile(
                enabled: accountPrefsEnabled,
                settingsLabel: Text(context.l10n.preferencesMoveConfirmation),
                settingsValue: submitMove.label(context.l10n),
                onTap: accountPrefsEnabled
                    ? () {
                        showMultipleChoicesPicker(
                          context,
                          choices: submitMoveChoices,
                          selectedItems: submitMove.choices,
                          labelBuilder: (t) => Text(t.label(context.l10n)),
                        ).then((value) {
                          if (value != null) {
                            _setAccountPref((prefs) => prefs.setSubmitMove(SubmitMove(value)));
                          }
                        });
                      }
                    : null,
                explanation: context.l10n.preferencesExplainCanThenBeTemporarilyDisabled,
              ),
              SwitchSettingTile(
                title: Text(context.l10n.preferencesConfirmResignationAndDrawOffers),
                value: boardPrefs.confirmResignAndDraw,
                onChanged: (value) {
                  ref.read(boardPreferencesProvider.notifier).toggleConfirmResignAndDraw();
                },
              ),
              SwitchSettingTile(
                title: Text(context.l10n.mobileSettingsTouchFeedback),
                value: boardPrefs.hapticFeedback,
                subtitle: Text(context.l10n.mobileSettingsTouchFeedbackSubtitle, maxLines: 5),
                onChanged: (value) {
                  ref.read(boardPreferencesProvider.notifier).toggleHapticFeedback();
                },
              ),
              SettingsListTile(
                settingsLabel: Text(context.l10n.preferencesHowDoYouMovePieces),
                settingsValue: pieceShiftMethodl10n(context, boardPrefs.pieceShiftMethod),
                onTap: () {
                  showChoicePicker(
                    context,
                    choices: PieceShiftMethod.values,
                    selectedItem: boardPrefs.pieceShiftMethod,
                    labelBuilder: (t) => Text(pieceShiftMethodl10n(context, t)),
                    onSelectedItemChanged: (PieceShiftMethod? value) {
                      ref
                          .read(boardPreferencesProvider.notifier)
                          .setPieceShiftMethod(value ?? PieceShiftMethod.either);
                    },
                  );
                },
              ),
              SwitchSettingTile(
                // TODO l10n
                title: const Text('Move on release'),
                subtitle: const Text(
                  'When moving a piece by tapping, the move is made when you lift '
                  'your finger, letting you slide to change the destination square.',
                  maxLines: 5,
                ),
                value: boardPrefs.moveOnRelease,
                onChanged: (value) {
                  ref.read(boardPreferencesProvider.notifier).toggleMoveOnRelease();
                },
              ),
              SettingsListTile(
                settingsLabel: Text(
                  context.l10n.preferencesCastleByMovingTheKingTwoSquaresOrOntoTheRook,
                ),
                settingsValue: boardPrefs.castlingMethod.l10n(context.l10n),
                onTap: () {
                  showChoicePicker(
                    context,
                    choices: CastlingMethod.values,
                    selectedItem: boardPrefs.castlingMethod,
                    labelBuilder: (t) => Text(t.l10n(context.l10n)),
                    onSelectedItemChanged: (CastlingMethod? value) {
                      ref
                          .read(boardPreferencesProvider.notifier)
                          .setCastlingMethod(value ?? CastlingMethod.kingOverRook);
                    },
                  );
                },
              ),
              SwitchSettingTile(
                title: Text(context.l10n.mobileSettingsShapeDrawing),
                subtitle: Text(context.l10n.mobileSettingsShapeDrawingSubtitle, maxLines: 5),
                value: boardPrefs.enableShapeDrawings,
                onChanged: (value) {
                  ref.read(boardPreferencesProvider.notifier).toggleEnableShapeDrawings();
                },
              ),
            ],
          ),
          ListSection(
            header: SettingsSectionTitle(context.l10n.preferencesChessClock),
            hasLeading: false,
            children: [
              // Give more time is always enabled for anonymous players, so hide the setting.
              if (authUser != null)
                SettingsListTile(
                  enabled: accountPrefsEnabled,
                  settingsLabel: Text(context.l10n.preferencesGiveMoreTime),
                  settingsValue: accountPrefs.moretime.label(context.l10n),
                  onTap: accountPrefsEnabled
                      ? () {
                          showChoicePicker(
                            context,
                            choices: Moretime.values,
                            selectedItem: accountPrefs.moretime,
                            labelBuilder: (t) => Text(t.label(context.l10n)),
                            onSelectedItemChanged: (Moretime? value) {
                              _setAccountPref(
                                (prefs) => prefs.setMoretime(value ?? accountPrefs.moretime),
                              );
                            },
                          );
                        }
                      : null,
                ),
              SwitchSettingTile(
                title: Text(context.l10n.preferencesSoundWhenTimeGetsCritical),
                value: accountPrefs.clockSound.value,
                onChanged: accountPrefsEnabled
                    ? (value) {
                        _setAccountPref((prefs) => prefs.setClockSound(BooleanPref(value)));
                      }
                    : null,
              ),
              SettingsListTile(
                enabled: accountPrefsEnabled,
                settingsLabel: Text(context.l10n.preferencesTenthsOfSeconds),
                settingsValue: accountPrefs.clockTenths.label(context.l10n),
                onTap: accountPrefsEnabled
                    ? () {
                        showChoicePicker(
                          context,
                          choices: ClockTenths.values,
                          selectedItem: accountPrefs.clockTenths,
                          labelBuilder: (t) => Text(t.label(context.l10n)),
                          onSelectedItemChanged: (ClockTenths? value) {
                            _setAccountPref(
                              (prefs) => prefs.setClockTenths(value ?? accountPrefs.clockTenths),
                            );
                          },
                        );
                      }
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

String pieceShiftMethodl10n(BuildContext context, PieceShiftMethod pieceShiftMethod) =>
    switch (pieceShiftMethod) {
      PieceShiftMethod.either => context.l10n.mobileSettingsPieceShiftMethodEither,
      PieceShiftMethod.drag => context.l10n.preferencesDragPiece,
      PieceShiftMethod.tapTwoSquares => context.l10n.mobileSettingsPieceShiftMethodTapTwoSquares,
    };
