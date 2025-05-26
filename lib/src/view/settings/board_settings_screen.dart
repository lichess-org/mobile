import 'package:chessground/chessground.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/utils/screen.dart';
import 'package:lichess_mobile/src/utils/system.dart';
import 'package:lichess_mobile/src/widgets/adaptive_choice_picker.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';

class BoardSettingsScreen extends StatelessWidget {
  const BoardSettingsScreen({super.key, this.showCloseButton = false});

  /// Whether to show a close button in the app bar instead of the back button.
  final bool showCloseButton;

  static Route<dynamic> buildRoute(BuildContext context, {bool fullscreenDialog = false}) {
    return buildScreenRoute(
      context,
      fullscreenDialog: fullscreenDialog,
      screen: const BoardSettingsScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: showCloseButton ? const CloseButton() : null,
        title: Text(context.l10n.preferencesGameBehavior),
      ),
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
          hasLeading: false,
          children: [
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
              title: Text(context.l10n.mobilePrefMagnifyDraggedPiece),
              value: boardPrefs.magnifyDraggedPiece,
              onChanged: (value) {
                ref.read(boardPreferencesProvider.notifier).toggleMagnifyDraggedPiece();
              },
            ),
            SettingsListTile(
              // TODO translate
              settingsLabel: const Text('Drag target'),
              explanation:
                  // TODO translate
                  'How the target square is highlighted when dragging a piece.',
              settingsValue: dragTargetKindLabel(boardPrefs.dragTargetKind),
              onTap: () {
                showChoicePicker(
                  context,
                  choices: DragTargetKind.values,
                  selectedItem: boardPrefs.dragTargetKind,
                  labelBuilder: (t) => Text(dragTargetKindLabel(t)),
                  onSelectedItemChanged: (DragTargetKind? value) {
                    ref
                        .read(boardPreferencesProvider.notifier)
                        .setDragTargetKind(value ?? DragTargetKind.circle);
                  },
                );
              },
            ),
            SwitchSettingTile(
              // TODO translate
              title: const Text('Touch feedback'),
              value: boardPrefs.hapticFeedback,
              subtitle: const Text(
                // TODO translate
                'Vibrate when moving pieces or capturing them.',
                maxLines: 5,
              ),
              onChanged: (value) {
                ref.read(boardPreferencesProvider.notifier).toggleHapticFeedback();
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
            if (!isShortVerticalScreen(context))
              SwitchSettingTile(
                title: Text(context.l10n.preferencesMoveListWhilePlaying),
                value: boardPrefs.moveListDisplay,
                onChanged: (value) {
                  ref.read(boardPreferencesProvider.notifier).toggleMoveListDisplay();
                },
              ),
            SettingsListTile(
              //TODO Add l10n
              settingsLabel: const Text('Clock position'),
              settingsValue: boardPrefs.clockPosition.label,
              onTap: () {
                showChoicePicker(
                  context,
                  choices: ClockPosition.values,
                  selectedItem: boardPrefs.clockPosition,
                  labelBuilder: (t) => Text(t.label),
                  onSelectedItemChanged: (ClockPosition? value) => ref
                      .read(boardPreferencesProvider.notifier)
                      .setClockPosition(value ?? ClockPosition.right),
                );
              },
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
            SettingsListTile(
              settingsLabel: const Text('Material'), //TODO: l10n
              settingsValue: boardPrefs.materialDifferenceFormat.l10n(AppLocalizations.of(context)),
              onTap: () {
                showChoicePicker(
                  context,
                  choices: MaterialDifferenceFormat.values,
                  selectedItem: boardPrefs.materialDifferenceFormat,
                  labelBuilder: (t) => Text(t.label),
                  onSelectedItemChanged: (MaterialDifferenceFormat? value) => ref
                      .read(boardPreferencesProvider.notifier)
                      .setMaterialDifferenceFormat(
                        value ?? MaterialDifferenceFormat.materialDifference,
                      ),
                );
              },
            ),
            SwitchSettingTile(
              // TODO: Add l10n
              title: const Text('Shape drawing'),
              subtitle: const Text(
                // TODO: translate
                'Draw shapes using two fingers: maintain one finger on an empty square and drag another finger to draw a shape.',
                maxLines: 5,
              ),
              value: boardPrefs.enableShapeDrawings,
              onChanged: (value) {
                ref.read(boardPreferencesProvider.notifier).toggleEnableShapeDrawings();
              },
            ),
          ],
        ),
      ],
    );
  }
}

String pieceShiftMethodl10n(BuildContext context, PieceShiftMethod pieceShiftMethod) =>
    switch (pieceShiftMethod) {
      // TODO add this to mobile translations
      PieceShiftMethod.either => 'Either tap or drag',
      PieceShiftMethod.drag => context.l10n.preferencesDragPiece,
      PieceShiftMethod.tapTwoSquares => 'Tap two squares',
    };
