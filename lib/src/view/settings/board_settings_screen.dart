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
import 'package:lichess_mobile/src/widgets/settings.dart';

class BoardSettingsScreen extends StatelessWidget {
  const BoardSettingsScreen({super.key});

  static Route<dynamic> buildRoute({bool fullscreenDialog = false}) {
    return buildScreenRoute(
      fullscreenDialog: fullscreenDialog,
      screen: const BoardSettingsScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.mobileBoardSettings)),
      body: const _Body(),
    );
  }
}

class _Body extends ConsumerStatefulWidget {
  const _Body();

  @override
  ConsumerState<_Body> createState() => _BodyState();
}

class _BodyState extends ConsumerState<_Body> {
  bool isLoading = false;

  Future<void> _setAccountPref({
    required Future<void> Function(LocalAccountPreferences localPreferences) local,
    required Future<void> Function(AccountPreferences accountPreferences) account,
  }) async {
    setState(() {
      isLoading = true;
    });
    try {
      final authUser = ref.read(authControllerProvider);
      if (authUser == null) {
        await local(ref.read(localAccountPreferencesProvider.notifier));
      } else {
        await account(ref.read(accountPreferencesProvider.notifier));
        if (mounted) {
          showSnackBar(
            context,
            context.l10n.preferencesYourPreferencesHaveBeenSaved,
            type: SnackBarType.success,
          );
        }
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
    final accountPrefsAsync = ref.watch(effectiveAccountPreferencesProvider);
    final accountPrefs = accountPrefsAsync.value ?? defaultAccountPreferences;
    final authUser = ref.watch(authControllerProvider);
    final isOnline = ref.watch(onlineStatusProvider).value ?? false;
    final accountPrefsEnabled =
        accountPrefsAsync.hasValue && !isLoading && (authUser == null || isOnline);
    final androidVersionAsync = ref.watch(androidVersionProvider);

    return ListView(
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
                          _setAccountPref(
                            local: (prefs) => prefs.setZen(value ?? accountPrefs.zenMode),
                            account: (prefs) => prefs.setZen(value ?? accountPrefs.zenMode),
                          );
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
                            local: (prefs) =>
                                prefs.setPieceNotation(value ?? accountPrefs.pieceNotation),
                            account: (prefs) =>
                                prefs.setPieceNotation(value ?? accountPrefs.pieceNotation),
                          );
                        },
                      );
                    }
                  : null,
            ),
            SettingsListTile(
              enabled: accountPrefsEnabled,
              settingsLabel: Text(context.l10n.preferencesShowPlayerRatings),
              settingsValue: accountPrefs.showRatings.label(context.l10n),
              onTap: accountPrefsEnabled
                  ? () {
                      showChoicePicker(
                        context,
                        choices: ShowRatings.values,
                        selectedItem: accountPrefs.showRatings,
                        labelBuilder: (t) => Text(t.label(context.l10n)),
                        onSelectedItemChanged: (ShowRatings? value) {
                          _setAccountPref(
                            local: (prefs) =>
                                prefs.setShowRatings(value ?? accountPrefs.showRatings),
                            account: (prefs) =>
                                prefs.setShowRatings(value ?? accountPrefs.showRatings),
                          );
                        },
                      );
                    }
                  : null,
              explanation: context.l10n.preferencesExplainShowPlayerRatings,
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
            if (Theme.of(context).platform == TargetPlatform.android && !isTabletOrLarger(context))
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
              settingsValue: boardPrefs.materialDifferenceFormat.l10n(AppLocalizations.of(context)),
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
                            local: (prefs) => prefs.setTakeback(value ?? accountPrefs.takeback),
                            account: (prefs) => prefs.setTakeback(value ?? accountPrefs.takeback),
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
                            local: (prefs) => prefs.setAutoQueen(value ?? accountPrefs.autoQueen),
                            account: (prefs) => prefs.setAutoQueen(value ?? accountPrefs.autoQueen),
                          );
                        },
                      );
                    }
                  : null,
            ),
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
                            local: (prefs) =>
                                prefs.setAutoThreefold(value ?? accountPrefs.autoThreefold),
                            account: (prefs) =>
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
              settingsValue: accountPrefs.submitMove.label(context.l10n),
              onTap: accountPrefsEnabled
                  ? () {
                      showMultipleChoicesPicker(
                        context,
                        choices: SubmitMoveChoice.values,
                        selectedItems: accountPrefs.submitMove.choices,
                        labelBuilder: (t) => Text(t.label(context.l10n)),
                      ).then((value) {
                        if (value != null) {
                          _setAccountPref(
                            local: (prefs) => prefs.setSubmitMove(SubmitMove(value)),
                            account: (prefs) => prefs.setSubmitMove(SubmitMove(value)),
                          );
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
                            local: (prefs) => prefs.setMoretime(value ?? accountPrefs.moretime),
                            account: (prefs) => prefs.setMoretime(value ?? accountPrefs.moretime),
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
                      _setAccountPref(
                        local: (prefs) => prefs.setClockSound(BooleanPref(value)),
                        account: (prefs) => prefs.setClockSound(BooleanPref(value)),
                      );
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
                            local: (prefs) =>
                                prefs.setClockTenths(value ?? accountPrefs.clockTenths),
                            account: (prefs) =>
                                prefs.setClockTenths(value ?? accountPrefs.clockTenths),
                          );
                        },
                      );
                    }
                  : null,
            ),
          ],
        ),
      ],
    );
  }
}

String pieceShiftMethodl10n(BuildContext context, PieceShiftMethod pieceShiftMethod) =>
    switch (pieceShiftMethod) {
      PieceShiftMethod.either => context.l10n.mobileSettingsPieceShiftMethodEither,
      PieceShiftMethod.drag => context.l10n.preferencesDragPiece,
      PieceShiftMethod.tapTwoSquares => context.l10n.mobileSettingsPieceShiftMethodTapTwoSquares,
    };
