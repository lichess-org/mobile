import 'package:chessground/chessground.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/utils/screen.dart';
import 'package:lichess_mobile/src/utils/system.dart';
import 'package:lichess_mobile/src/widgets/adaptive_choice_picker.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';

class BoardSettingsScreen extends StatelessWidget {
  const BoardSettingsScreen({super.key});

  static Route<dynamic> buildRoute(
    BuildContext context, {
    bool fullscreenDialog = false,
  }) {
    return buildScreenRoute(
      context,
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

class _Body extends ConsumerWidget {
  const _Body();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boardPrefs = ref.watch(boardPreferencesProvider);

    final androidVersionAsync = ref.watch(androidVersionProvider);

    return ListView(
      children: [
        ListSection(
          header: SettingsSectionTitle(context.l10n.preferencesDisplay),
          hasLeading: false,
          children: [
            SwitchSettingTile(
              title: Text(context.l10n.mobilePrefMagnifyDraggedPiece),
              value: boardPrefs.magnifyDraggedPiece,
              onChanged: (value) {
                ref
                    .read(boardPreferencesProvider.notifier)
                    .toggleMagnifyDraggedPiece();
              },
            ),
            SettingsListTile(
              settingsLabel: Text(
                context.l10n.mobileSettingsDraggedPieceTarget,
              ),
              settingsValue: dragTargetKindLabel(
                context.l10n,
                boardPrefs.dragTargetKind,
              ),
              onTap: () {
                showChoicePicker(
                  context,
                  choices: DragTargetKind.values,
                  selectedItem: boardPrefs.dragTargetKind,
                  labelBuilder: (t) =>
                      Text(dragTargetKindLabel(context.l10n, t)),
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
                ref
                    .read(boardPreferencesProvider.notifier)
                    .togglePieceAnimation();
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
                ref
                    .read(boardPreferencesProvider.notifier)
                    .toggleShowLegalMoves();
              },
            ),
            SwitchSettingTile(
              title: Text(context.l10n.preferencesBoardHighlights),
              value: boardPrefs.boardHighlights,
              onChanged: (value) {
                ref
                    .read(boardPreferencesProvider.notifier)
                    .toggleBoardHighlights();
              },
            ),
            if (!isShortVerticalScreen(context))
              SwitchSettingTile(
                title: Text(context.l10n.preferencesMoveListWhilePlaying),
                value: boardPrefs.moveListDisplay,
                onChanged: (value) {
                  ref
                      .read(boardPreferencesProvider.notifier)
                      .toggleMoveListDisplay();
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
                  onSelectedItemChanged: (MaterialDifferenceFormat? value) =>
                      ref
                          .read(boardPreferencesProvider.notifier)
                          .setMaterialDifferenceFormat(
                            value ??
                                MaterialDifferenceFormat.materialDifference,
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
          ],
        ),
        ListSection(
          header: SettingsSectionTitle(context.l10n.preferencesGameBehavior),
          hasLeading: false,
          children: [
            SwitchSettingTile(
              title: Text(
                context.l10n.preferencesPremovesPlayingDuringOpponentTurn,
              ),
              value: boardPrefs.premoves,
              onChanged: (value) {
                ref.read(boardPreferencesProvider.notifier).togglePremoves();
              },
            ),
            SwitchSettingTile(
              title: Text(
                context.l10n.preferencesConfirmResignationAndDrawOffers,
              ),
              value: boardPrefs.confirmResignAndDraw,
              onChanged: (value) {
                ref
                    .read(boardPreferencesProvider.notifier)
                    .toggleConfirmResignAndDraw();
              },
            ),
            SwitchSettingTile(
              title: Text(context.l10n.mobileSettingsTouchFeedback),
              value: boardPrefs.hapticFeedback,
              subtitle: Text(
                context.l10n.mobileSettingsTouchFeedbackSubtitle,
                maxLines: 5,
              ),
              onChanged: (value) {
                ref
                    .read(boardPreferencesProvider.notifier)
                    .toggleHapticFeedback();
              },
            ),
            SettingsListTile(
              settingsLabel: Text(context.l10n.preferencesHowDoYouMovePieces),
              settingsValue: pieceShiftMethodl10n(
                context,
                boardPrefs.pieceShiftMethod,
              ),
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
                context
                    .l10n
                    .preferencesCastleByMovingTheKingTwoSquaresOrOntoTheRook,
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
                        .setCastlingMethod(
                          value ?? CastlingMethod.kingOverRook,
                        );
                  },
                );
              },
            ),
            SwitchSettingTile(
              title: Text(context.l10n.mobileSettingsShapeDrawing),
              subtitle: Text(
                context.l10n.mobileSettingsShapeDrawingSubtitle,
                maxLines: 5,
              ),
              value: boardPrefs.enableShapeDrawings,
              onChanged: (value) {
                ref
                    .read(boardPreferencesProvider.notifier)
                    .toggleEnableShapeDrawings();
              },
            ),
          ],
        ),
      ],
    );
  }
}

String pieceShiftMethodl10n(
  BuildContext context,
  PieceShiftMethod pieceShiftMethod,
) => switch (pieceShiftMethod) {
  PieceShiftMethod.either => context.l10n.mobileSettingsPieceShiftMethodEither,
  PieceShiftMethod.drag => context.l10n.preferencesDragPiece,
  PieceShiftMethod.tapTwoSquares =>
    context.l10n.mobileSettingsPieceShiftMethodTapTwoSquares,
};
