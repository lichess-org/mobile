import 'package:chessground/chessground.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/utils/screen.dart';
import 'package:lichess_mobile/src/utils/system.dart';
import 'package:lichess_mobile/src/view/settings/board_clock_position_screen.dart';
import 'package:lichess_mobile/src/widgets/adaptive_choice_picker.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';

class BoardSettingsScreen extends StatelessWidget {
  const BoardSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _androidBuilder,
      iosBuilder: _iosBuilder,
    );
  }

  Widget _androidBuilder(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.board)),
      body: const _Body(),
    );
  }

  Widget _iosBuilder(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(),
      child: _Body(),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boardPrefs = ref.watch(boardPreferencesProvider);

    final androidVersionAsync = ref.watch(androidVersionProvider);

    return SafeArea(
      child: ListView(
        children: [
          ListSection(
            header: SettingsSectionTitle(context.l10n.preferencesGameBehavior),
            hasLeading: false,
            showDivider: false,
            children: [
              SettingsListTile(
                settingsLabel: Text(context.l10n.preferencesHowDoYouMovePieces),
                settingsValue:
                    pieceShiftMethodl10n(context, boardPrefs.pieceShiftMethod),
                showCupertinoTrailingValue: false,
                onTap: () {
                  if (Theme.of(context).platform == TargetPlatform.android) {
                    showChoicePicker(
                      context,
                      choices: PieceShiftMethod.values,
                      selectedItem: boardPrefs.pieceShiftMethod,
                      labelBuilder: (t) =>
                          Text(pieceShiftMethodl10n(context, t)),
                      onSelectedItemChanged: (PieceShiftMethod? value) {
                        ref
                            .read(boardPreferencesProvider.notifier)
                            .setPieceShiftMethod(
                              value ?? PieceShiftMethod.either,
                            );
                      },
                    );
                  } else {
                    pushPlatformRoute(
                      context,
                      title: context.l10n.preferencesHowDoYouMovePieces,
                      builder: (context) =>
                          const PieceShiftMethodSettingsScreen(),
                    );
                  }
                },
              ),
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
                // TODO translate
                settingsLabel: const Text('Drag target'),
                explanation:
                    // TODO translate
                    'How the target square is highlighted when dragging a piece.',
                settingsValue: dragTargetKindLabel(boardPrefs.dragTargetKind),
                onTap: () {
                  if (Theme.of(context).platform == TargetPlatform.android) {
                    showChoicePicker(
                      context,
                      choices: DragTargetKind.values,
                      selectedItem: boardPrefs.dragTargetKind,
                      labelBuilder: (t) => Text(dragTargetKindLabel(t)),
                      onSelectedItemChanged: (DragTargetKind? value) {
                        ref
                            .read(boardPreferencesProvider.notifier)
                            .setDragTargetKind(
                              value ?? DragTargetKind.circle,
                            );
                      },
                    );
                  } else {
                    pushPlatformRoute(
                      context,
                      title: 'Dragged piece target',
                      builder: (context) =>
                          const DragTargetKindSettingsScreen(),
                    );
                  }
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
                  textAlign: TextAlign.justify,
                ),
                onChanged: (value) {
                  ref
                      .read(boardPreferencesProvider.notifier)
                      .toggleHapticFeedback();
                },
              ),
              SwitchSettingTile(
                title: Text(
                  context.l10n.preferencesPieceAnimation,
                ),
                value: boardPrefs.pieceAnimation,
                onChanged: (value) {
                  ref
                      .read(boardPreferencesProvider.notifier)
                      .togglePieceAnimation();
                },
              ),
            ],
          ),
          ListSection(
            header: SettingsSectionTitle(context.l10n.preferencesDisplay),
            hasLeading: false,
            showDivider: false,
            children: [
              if (Theme.of(context).platform == TargetPlatform.android &&
                  !isTabletOrLarger(context))
                androidVersionAsync.maybeWhen(
                  data: (version) => version != null && version.sdkInt >= 29
                      ? SwitchSettingTile(
                          title: Text(context.l10n.mobileSettingsImmersiveMode),
                          subtitle: Text(
                            context.l10n.mobileSettingsImmersiveModeSubtitle,
                            textAlign: TextAlign.justify,
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
                title: Text(
                  context.l10n.preferencesPieceDestinations,
                ),
                value: boardPrefs.showLegalMoves,
                onChanged: (value) {
                  ref
                      .read(boardPreferencesProvider.notifier)
                      .toggleShowLegalMoves();
                },
              ),
              SwitchSettingTile(
                title: Text(
                  context.l10n.preferencesBoardHighlights,
                ),
                value: boardPrefs.boardHighlights,
                onChanged: (value) {
                  ref
                      .read(boardPreferencesProvider.notifier)
                      .toggleBoardHighlights();
                },
              ),
              SwitchSettingTile(
                title: Text(
                  context.l10n.preferencesMaterialDifference,
                ),
                value: boardPrefs.showMaterialDifference,
                onChanged: (value) {
                  ref
                      .read(boardPreferencesProvider.notifier)
                      .toggleShowMaterialDifference();
                },
              ),
              SwitchSettingTile(
                // TODO: Add l10n
                title: const Text('Shape drawing'),
                subtitle: const Text(
                  // TODO: translate
                  'Draw shapes using two fingers: maintain one finger on an empty square and drag another finger to draw a shape.',
                  maxLines: 5,
                  textAlign: TextAlign.justify,
                ),
                value: boardPrefs.enableShapeDrawings,
                onChanged: (value) {
                  ref
                      .read(boardPreferencesProvider.notifier)
                      .toggleEnableShapeDrawings();
                },
              ),
              SettingsListTile(
                //TODO Add l10n
                settingsLabel: const Text('Clock position'),
                settingsValue: BoardClockPositionScreen.position(
                  context,
                  boardPrefs.clockPosition,
                ),
                onTap: () {
                  if (Theme.of(context).platform == TargetPlatform.android) {
                    showChoicePicker(
                      context,
                      choices: ClockPosition.values,
                      selectedItem: boardPrefs.clockPosition,
                      labelBuilder: (t) =>
                          Text(BoardClockPositionScreen.position(context, t)),
                      onSelectedItemChanged: (ClockPosition? value) => ref
                          .read(boardPreferencesProvider.notifier)
                          .setClockPosition(value ?? ClockPosition.right),
                    );
                  } else {
                    pushPlatformRoute(
                      context,
                      title: 'Clock position',
                      builder: (context) => const BoardClockPositionScreen(),
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PieceShiftMethodSettingsScreen extends ConsumerWidget {
  const PieceShiftMethodSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pieceShiftMethod = ref.watch(
      boardPreferencesProvider.select(
        (state) => state.pieceShiftMethod,
      ),
    );

    void onChanged(PieceShiftMethod? value) {
      ref
          .read(boardPreferencesProvider.notifier)
          .setPieceShiftMethod(value ?? PieceShiftMethod.either);
    }

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(),
      child: SafeArea(
        child: ListView(
          children: [
            ChoicePicker(
              notchedTile: true,
              choices: PieceShiftMethod.values,
              selectedItem: pieceShiftMethod,
              titleBuilder: (t) => Text(pieceShiftMethodl10n(context, t)),
              onSelectedItemChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}

class DragTargetKindSettingsScreen extends ConsumerWidget {
  const DragTargetKindSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dragTargetKind = ref.watch(
      boardPreferencesProvider.select(
        (state) => state.dragTargetKind,
      ),
    );

    void onChanged(DragTargetKind? value) {
      ref
          .read(boardPreferencesProvider.notifier)
          .setDragTargetKind(value ?? DragTargetKind.circle);
    }

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(),
      child: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding:
                  Styles.horizontalBodyPadding.add(Styles.sectionTopPadding),
              child: const Text(
                'How the target square is highlighted when dragging a piece.',
              ),
            ),
            ChoicePicker(
              notchedTile: true,
              choices: DragTargetKind.values,
              selectedItem: dragTargetKind,
              titleBuilder: (t) => Text(dragTargetKindLabel(t)),
              onSelectedItemChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}

String pieceShiftMethodl10n(
  BuildContext context,
  PieceShiftMethod pieceShiftMethod,
) =>
    switch (pieceShiftMethod) {
      // TODO add this to mobile translations
      PieceShiftMethod.either => 'Either tap or drag',
      PieceShiftMethod.drag => context.l10n.preferencesDragPiece,
      PieceShiftMethod.tapTwoSquares => 'Tap two squares',
    };
