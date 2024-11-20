import 'package:chessground/chessground.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/utils/screen.dart';
import 'package:lichess_mobile/src/utils/system.dart';
import 'package:lichess_mobile/src/view/settings/board_clock_position_screen.dart';
import 'package:lichess_mobile/src/view/settings/piece_shift_method_settings_screen.dart';
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
                // TODO: Add l10n
                title: const Text('Shape drawing'),
                subtitle: const Text(
                  'Draw shapes using two fingers on game and puzzle boards.',
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
              SwitchSettingTile(
                title: Text(context.l10n.mobileSettingsHapticFeedback),
                value: boardPrefs.hapticFeedback,
                onChanged: (value) {
                  ref
                      .read(boardPreferencesProvider.notifier)
                      .toggleHapticFeedback();
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
                  context.l10n.preferencesBoardCoordinates,
                ),
                value: boardPrefs.coordinates,
                onChanged: (value) {
                  ref
                      .read(boardPreferencesProvider.notifier)
                      .toggleCoordinates();
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
