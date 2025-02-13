import 'package:chessground/chessground.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/utils/screen.dart';
import 'package:lichess_mobile/src/utils/system.dart';
import 'package:lichess_mobile/src/widgets/adaptive_choice_picker.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform_scaffold.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';

class BoardSettingsScreen extends StatelessWidget {
  const BoardSettingsScreen({super.key});

  static Route<dynamic> buildRoute(BuildContext context, {bool fullscreenDialog = false}) {
    return buildScreenRoute(
      context,
      fullscreenDialog: fullscreenDialog,
      screen: const BoardSettingsScreen(),
      title: context.l10n.preferencesGameBehavior,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(title: Text(context.l10n.preferencesGameBehavior)),
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
              showCupertinoTrailingValue: false,
              onTap: () {
                if (Theme.of(context).platform == TargetPlatform.android) {
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
                } else {
                  Navigator.of(context).push(PieceShiftMethodSettingsScreen.buildRoute(context));
                }
              },
            ),
            SettingsListTile(
              settingsLabel: Text(
                context.l10n.preferencesCastleByMovingTheKingTwoSquaresOrOntoTheRook,
              ),
              settingsValue: boardPrefs.castlingMethod.name,
              showCupertinoTrailingValue: false,
              onTap: () {
                if (Theme.of(context).platform == TargetPlatform.android) {
                  showChoicePicker(
                    context,
                    choices: CastlingMethod.values,
                    selectedItem: boardPrefs.castlingMethod,
                    labelBuilder: (t) => Text(t.castlingMethodl10n(context, t)),
                    onSelectedItemChanged: (CastlingMethod? value) {
                      ref
                          .read(boardPreferencesProvider.notifier)
                          .setCastlingMethod(value ?? CastlingMethod.either);
                    },
                  );
                } else {
                  Navigator.of(context).push(CastlingMethodSettingsScreen.buildRoute(context));
                }
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
                if (Theme.of(context).platform == TargetPlatform.android) {
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
                } else {
                  Navigator.of(context).push(DragTargetKindSettingsScreen.buildRoute(context));
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
                data:
                    (version) =>
                        version != null && version.sdkInt >= 29
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
            SettingsListTile(
              //TODO Add l10n
              settingsLabel: const Text('Clock position'),
              settingsValue: boardPrefs.clockPosition.label,
              onTap: () {
                if (Theme.of(context).platform == TargetPlatform.android) {
                  showChoicePicker(
                    context,
                    choices: ClockPosition.values,
                    selectedItem: boardPrefs.clockPosition,
                    labelBuilder: (t) => Text(t.label),
                    onSelectedItemChanged:
                        (ClockPosition? value) => ref
                            .read(boardPreferencesProvider.notifier)
                            .setClockPosition(value ?? ClockPosition.right),
                  );
                } else {
                  Navigator.of(context).push(BoardClockPositionScreen.buildRoute(context));
                }
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
                if (Theme.of(context).platform == TargetPlatform.android) {
                  showChoicePicker(
                    context,
                    choices: MaterialDifferenceFormat.values,
                    selectedItem: boardPrefs.materialDifferenceFormat,
                    labelBuilder: (t) => Text(t.label),
                    onSelectedItemChanged:
                        (MaterialDifferenceFormat? value) => ref
                            .read(boardPreferencesProvider.notifier)
                            .setMaterialDifferenceFormat(
                              value ?? MaterialDifferenceFormat.materialDifference,
                            ),
                  );
                } else {
                  Navigator.of(context).push(MaterialDifferenceFormatScreen.buildRoute(context));
                }
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

class PieceShiftMethodSettingsScreen extends ConsumerWidget {
  const PieceShiftMethodSettingsScreen({super.key});

  static Route<dynamic> buildRoute(BuildContext context) {
    return buildScreenRoute(
      context,
      screen: const PieceShiftMethodSettingsScreen(),
      title: context.l10n.preferencesHowDoYouMovePieces,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pieceShiftMethod = ref.watch(
      boardPreferencesProvider.select((state) => state.pieceShiftMethod),
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

class CastlingMethodSettingsScreen extends ConsumerWidget {
  const CastlingMethodSettingsScreen({super.key});

  static Route<dynamic> buildRoute(BuildContext context) {
    return buildScreenRoute(
      context,
      screen: const CastlingMethodSettingsScreen(),
      title: 'Castling method',
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final castlingMethod = ref.watch(
      boardPreferencesProvider.select((state) => state.castlingMethod),
    );

    void onChanged(CastlingMethod? value) {
      ref.read(boardPreferencesProvider.notifier).setCastlingMethod(value ?? CastlingMethod.either);
    }

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(),
      child: ListView(
        children: [
          ChoicePicker(
            notchedTile: true,
            choices: CastlingMethod.values,
            selectedItem: castlingMethod,
            titleBuilder: (t) => Text(t.castlingMethodl10n(context, t)),
            onSelectedItemChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class BoardClockPositionScreen extends ConsumerWidget {
  const BoardClockPositionScreen({super.key});

  static Route<dynamic> buildRoute(BuildContext context) {
    return buildScreenRoute(
      context,
      screen: const BoardClockPositionScreen(),
      title: 'Clock position',
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clockPosition = ref.watch(
      boardPreferencesProvider.select((state) => state.clockPosition),
    );
    void onChanged(ClockPosition? value) =>
        ref.read(boardPreferencesProvider.notifier).setClockPosition(value ?? ClockPosition.right);
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(),
      child: SafeArea(
        child: ListView(
          children: [
            ChoicePicker(
              choices: ClockPosition.values,
              selectedItem: clockPosition,
              titleBuilder: (t) => Text(t.label),
              onSelectedItemChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}

class MaterialDifferenceFormatScreen extends ConsumerWidget {
  const MaterialDifferenceFormatScreen({super.key});

  static Route<dynamic> buildRoute(BuildContext context) {
    return buildScreenRoute(
      context,
      screen: const MaterialDifferenceFormatScreen(),
      title: 'Material',
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final materialDifferenceFormat = ref.watch(
      boardPreferencesProvider.select((state) => state.materialDifferenceFormat),
    );
    void onChanged(MaterialDifferenceFormat? value) => ref
        .read(boardPreferencesProvider.notifier)
        .setMaterialDifferenceFormat(value ?? MaterialDifferenceFormat.materialDifference);
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(),
      child: ListView(
        children: [
          ChoicePicker(
            choices: MaterialDifferenceFormat.values,
            selectedItem: materialDifferenceFormat,
            titleBuilder: (t) => Text(t.label),
            onSelectedItemChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class DragTargetKindSettingsScreen extends ConsumerWidget {
  const DragTargetKindSettingsScreen({super.key});

  static Route<dynamic> buildRoute(BuildContext context) {
    return buildScreenRoute(
      context,
      screen: const DragTargetKindSettingsScreen(),
      title: 'Dragged piece target',
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dragTargetKind = ref.watch(
      boardPreferencesProvider.select((state) => state.dragTargetKind),
    );

    void onChanged(DragTargetKind? value) {
      ref.read(boardPreferencesProvider.notifier).setDragTargetKind(value ?? DragTargetKind.circle);
    }

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(),
      child: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: Styles.horizontalBodyPadding.add(Styles.sectionTopPadding),
              child: const Text('How the target square is highlighted when dragging a piece.'),
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

String pieceShiftMethodl10n(BuildContext context, PieceShiftMethod pieceShiftMethod) =>
    switch (pieceShiftMethod) {
      // TODO add this to mobile translations
      PieceShiftMethod.either => 'Either tap or drag',
      PieceShiftMethod.drag => context.l10n.preferencesDragPiece,
      PieceShiftMethod.tapTwoSquares => 'Tap two squares',
    };
