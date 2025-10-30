import 'dart:async';

import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/common/game.dart';
import 'package:lichess_mobile/src/model/coordinate_training/coordinate_training_controller.dart';
import 'package:lichess_mobile/src/model/coordinate_training/coordinate_training_preferences.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/utils/screen.dart';
import 'package:lichess_mobile/src/view/coordinate_training/coordinate_display.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/filter.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform_alert_dialog.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';

class CoordinateTrainingScreen extends StatelessWidget {
  const CoordinateTrainingScreen({super.key});

  static Route<dynamic> buildRoute(BuildContext context) {
    return buildScreenRoute(context, screen: const CoordinateTrainingScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.coordinatesCoordinateTraining),
        actions: [
          Builder(
            builder: (context) {
              return SemanticIconButton(
                icon: const Icon(Icons.settings),
                semanticsLabel: context.l10n.settingsSettings,
                onPressed: () => showModalBottomSheet<void>(
                  context: context,
                  showDragHandle: true,
                  builder: (BuildContext context) => const _CoordinateTrainingMenu(),
                ),
              );
            },
          ),
        ],
      ),
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
  Square? highlightLastGuess;

  Timer? highlightTimer;

  @override
  void dispose() {
    super.dispose();
    highlightTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final trainingState = ref.watch(coordinateTrainingControllerProvider);
    final trainingPrefs = ref.watch(coordinateTrainingPreferencesProvider);

    final IMap<Square, SquareHighlight> squareHighlights = <Square, SquareHighlight>{
      if (trainingState.trainingActive)
        if (trainingPrefs.mode == TrainingMode.findSquare) ...{
          if (highlightLastGuess != null) ...{
            highlightLastGuess!: SquareHighlight(
              details: HighlightDetails(
                solidColor:
                    (trainingState.lastGuess == Guess.correct
                            ? context.lichessColors.good
                            : context.lichessColors.error)
                        .withValues(alpha: 0.5),
              ),
            ),
          },
        } else ...{
          trainingState.currentCoord!: SquareHighlight(
            details: HighlightDetails(
              solidColor: context.lichessColors.good.withValues(alpha: 0.5),
            ),
          ),
        },
    }.lock;

    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final aspectRatio = constraints.biggest.aspectRatio;

                final defaultBoardSize = constraints.biggest.shortestSide;
                final isTablet = isTabletOrLarger(context);
                final remainingHeight = constraints.maxHeight - defaultBoardSize;
                final isSmallScreen = remainingHeight < kSmallHeightMinusBoard;
                final boardSize = isTablet || isSmallScreen
                    ? defaultBoardSize - kTabletBoardTableSidePadding * 2
                    : defaultBoardSize;

                final direction = aspectRatio > 1 ? Axis.horizontal : Axis.vertical;

                return Flex(
                  direction: direction,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        _TimeBar(
                          maxWidth: boardSize,
                          timeFractionElapsed: trainingState.timeFractionElapsed,
                          color: trainingState.lastGuess == Guess.incorrect
                              ? context.lichessColors.error
                              : context.lichessColors.good,
                        ),
                        _TrainingBoard(
                          boardSize: boardSize,
                          isTablet: isTablet,
                          orientation: trainingState.orientation,
                          squareHighlights: squareHighlights,
                          onGuess: _onGuess,
                        ),
                      ],
                    ),
                    if (trainingState.trainingActive)
                      _ScoreAndTrainingButton(
                        scoreSize: boardSize / 8,
                        score: trainingState.score,
                        onPressed: ref
                            .read(coordinateTrainingControllerProvider.notifier)
                            .abortTraining,
                        label: 'Abort Training',
                      )
                    else if (trainingState.lastScore != null)
                      _ScoreAndTrainingButton(
                        scoreSize: boardSize / 8,
                        score: trainingState.lastScore!,
                        onPressed: () {
                          ref
                              .read(coordinateTrainingControllerProvider.notifier)
                              .startTraining(trainingPrefs.timeChoice.duration);
                        },
                        label: context.l10n.coordinatesStartTraining,
                      )
                    else
                      Expanded(
                        child: Center(
                          child: _Button(
                            onPressed: () {
                              ref
                                  .read(coordinateTrainingControllerProvider.notifier)
                                  .startTraining(trainingPrefs.timeChoice.duration);
                            },
                            label: context.l10n.coordinatesStartTraining,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          if (!trainingState.trainingActive)
            BottomBar(
              children: [
                BottomBarButton(
                  label: context.l10n.menu,
                  onTap: () => _coordinateTrainingSettingsBuilder(context),
                  icon: Icons.tune,
                ),
                BottomBarButton(
                  icon: Icons.info_outline,
                  label: context.l10n.aboutX('Coordinate Training'),
                  onTap: () => _coordinateTrainingInfoDialogBuilder(context),
                ),
              ],
            ),
        ],
      ),
    );
  }

  void _onGuess(Square square) {
    ref.read(coordinateTrainingControllerProvider.notifier).guessCoordinate(square);

    setState(() {
      highlightLastGuess = square;

      highlightTimer?.cancel();
      highlightTimer = Timer(const Duration(milliseconds: 200), () {
        setState(() {
          highlightLastGuess = null;
        });
      });
    });
  }
}

class _TimeBar extends StatelessWidget {
  const _TimeBar({required this.maxWidth, required this.timeFractionElapsed, required this.color});

  final double maxWidth;
  final double? timeFractionElapsed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        width: maxWidth * (timeFractionElapsed ?? 0.0),
        height: 15.0,
        child: ColoredBox(color: color),
      ),
    );
  }
}

class _CoordinateTrainingMenu extends ConsumerWidget {
  const _CoordinateTrainingMenu();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trainingPrefs = ref.watch(coordinateTrainingPreferencesProvider);

    return BottomSheetScrollableContainer(
      children: [
        ListSection(
          materialFilledCard: true,
          header: SettingsSectionTitle(context.l10n.preferencesDisplay),
          children: [
            SwitchSettingTile(
              title: Text(context.l10n.coordinatesShowCoordinates),
              value: trainingPrefs.showCoordinates,
              onChanged: ref
                  .read(coordinateTrainingPreferencesProvider.notifier)
                  .setShowCoordinates,
            ),
            SwitchSettingTile(
              title: const Text('Show Pieces'),
              value: trainingPrefs.showPieces,
              onChanged: ref.read(coordinateTrainingPreferencesProvider.notifier).setShowPieces,
            ),
          ],
        ),
      ],
    );
  }
}

class _ScoreAndTrainingButton extends ConsumerWidget {
  const _ScoreAndTrainingButton({
    required this.scoreSize,
    required this.score,
    required this.onPressed,
    required this.label,
  });

  final double scoreSize;
  final int score;
  final VoidCallback onPressed;
  final String label;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trainingState = ref.watch(coordinateTrainingControllerProvider);

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _Score(
            score: score,
            size: scoreSize,
            color: trainingState.lastGuess == Guess.incorrect
                ? context.lichessColors.error
                : context.lichessColors.good,
          ),
          _Button(label: label, onPressed: onPressed),
        ],
      ),
    );
  }
}

class _Score extends StatelessWidget {
  const _Score({required this.size, required this.color, required this.score});

  final int score;

  final double size;

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(4.0)),
          color: color,
        ),
        width: size,
        height: size,
        child: Center(
          child: Text(
            score.toString(),
            style: Styles.bold.copyWith(color: Colors.white, fontSize: 24.0),
          ),
        ),
      ),
    );
  }
}

class _Button extends StatelessWidget {
  const _Button({required this.onPressed, required this.label});

  final VoidCallback onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      child: Text(label, style: Styles.bold),
    );
  }
}

class SettingsBottomSheet extends ConsumerWidget {
  const SettingsBottomSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trainingPrefs = ref.watch(coordinateTrainingPreferencesProvider);

    return BottomSheetScrollableContainer(
      padding: const EdgeInsets.all(16.0),
      children: [
        Filter(
          filterName: context.l10n.side,
          filterType: FilterType.singleChoice,
          choices: SideChoice.values,
          showCheckmark: false,
          choiceSelected: (choice) => trainingPrefs.sideChoice == choice,
          choiceLabel: (choice) => Text(choice.label(context.l10n)),
          onSelected: (choice, selected) {
            if (selected) {
              ref.read(coordinateTrainingPreferencesProvider.notifier).setSideChoice(choice);
            }
          },
        ),
        const SizedBox(height: 12.0),
        const PlatformDivider(thickness: 1, indent: 0),
        const SizedBox(height: 12.0),
        Filter(
          filterName: context.l10n.time,
          filterType: FilterType.singleChoice,
          choices: TimeChoice.values,
          showCheckmark: false,
          choiceSelected: (choice) => trainingPrefs.timeChoice == choice,
          choiceLabel: (choice) => choice.label(context.l10n),
          onSelected: (choice, selected) {
            if (selected) {
              ref.read(coordinateTrainingPreferencesProvider.notifier).setTimeChoice(choice);
            }
          },
        ),
      ],
    );
  }
}

class _TrainingBoard extends ConsumerStatefulWidget {
  const _TrainingBoard({
    required this.boardSize,
    required this.isTablet,
    required this.orientation,
    required this.onGuess,
    required this.squareHighlights,
  });

  final double boardSize;

  final bool isTablet;

  final Side orientation;

  final void Function(Square) onGuess;

  final IMap<Square, SquareHighlight> squareHighlights;

  @override
  ConsumerState<_TrainingBoard> createState() => _TrainingBoardState();
}

class _TrainingBoardState extends ConsumerState<_TrainingBoard> {
  @override
  Widget build(BuildContext context) {
    final boardPrefs = ref.watch(boardPreferencesProvider);
    final trainingPrefs = ref.watch(coordinateTrainingPreferencesProvider);
    final trainingState = ref.watch(coordinateTrainingControllerProvider);

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Chessboard.fixed(
              size: widget.boardSize,
              fen: trainingPrefs.showPieces ? kInitialFEN : kEmptyFEN,
              squareHighlights: widget.squareHighlights,
              orientation: widget.orientation,
              settings: boardPrefs.toBoardSettings().copyWith(
                enableCoordinates: trainingPrefs.showCoordinates,
                borderRadius: widget.isTablet
                    ? const BorderRadius.all(Radius.circular(4.0))
                    : BorderRadius.zero,
                boxShadow: widget.isTablet ? boardShadows : const <BoxShadow>[],
              ),
              onTouchedSquare: (square) {
                if (trainingState.trainingActive && trainingPrefs.mode == TrainingMode.findSquare) {
                  widget.onGuess(square);
                }
              },
            ),
            if (trainingState.trainingActive && trainingPrefs.mode == TrainingMode.findSquare)
              CoordinateDisplay(
                currentCoord: trainingState.currentCoord!,
                nextCoord: trainingState.nextCoord!,
              ),
          ],
        ),
      ],
    );
  }
}

Future<void> _coordinateTrainingSettingsBuilder(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    builder: (BuildContext context) => const SettingsBottomSheet(),
  );
}

Future<void> _coordinateTrainingInfoDialogBuilder(BuildContext context) {
  return showAdaptiveDialog(
    context: context,
    builder: (context) {
      return AlertDialog.adaptive(
        title: Text(context.l10n.aboutX(context.l10n.coordinatesCoordinateTraining)),
        content: SingleChildScrollView(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(text: '${context.l10n.coordinatesKnowingTheChessBoard}\n'),
                TextSpan(text: '  • ${context.l10n.coordinatesMostChessCourses}\n'),
                TextSpan(text: '  • ${context.l10n.coordinatesTalkToYourChessFriends}\n'),
                TextSpan(
                  text: '  • ${context.l10n.coordinatesYouCanAnalyseAGameMoreEffectively}\n',
                ),
                const TextSpan(text: '\n'),
                TextSpan(
                  text: '${context.l10n.coordinatesFindSquare}\n',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: '${context.l10n.coordinatesACoordinateAppears}\n'),
                TextSpan(text: '${context.l10n.coordinatesYouHaveThirtySeconds}\n'),
              ],
            ),
          ),
        ),
        actions: [
          PlatformDialogAction(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(context.l10n.mobileOkButton),
          ),
        ],
      );
    },
  );
}
