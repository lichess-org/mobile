import 'package:chessground/chessground.dart';
import 'package:collection/collection.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_providers.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_repository.dart';
import 'package:lichess_mobile/src/model/puzzle/storm.dart';
import 'package:lichess_mobile/src/model/puzzle/storm_controller.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/gestures_exclusion.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/puzzle/puzzle_history_screen.dart';
import 'package:lichess_mobile/src/view/puzzle/storm_clock.dart';
import 'package:lichess_mobile/src/view/puzzle/storm_dashboard.dart';
import 'package:lichess_mobile/src/view/settings/toggle_sound_button.dart';
import 'package:lichess_mobile/src/widgets/board_table.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/interactive_board.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform_alert_dialog.dart';
import 'package:lichess_mobile/src/widgets/yes_no_dialog.dart';

class StormScreen extends ConsumerStatefulWidget {
  const StormScreen({super.key});

  static Route<dynamic> buildRoute(BuildContext context) {
    return buildScreenRoute(context, screen: const StormScreen());
  }

  @override
  ConsumerState<StormScreen> createState() => _StormScreenState();
}

class _StormScreenState extends ConsumerState<StormScreen> {
  final _boardKey = GlobalKey(debugLabel: 'boardOnStormScreen');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [_StormDashboardButton(), const ToggleSoundButton()],
        title: const Text('Puzzle Storm'),
      ),
      body: _Body(_boardKey),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body(this.boardKey);

  final GlobalKey boardKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storm = ref.watch(stormProvider);

    switch (storm) {
      case AsyncData(value: final PuzzleStormResponse data):
        final ctrlProvider = stormControllerProvider(data.puzzles, data.timestamp);
        final stormState = ref.watch(ctrlProvider);

        ref.listen(ctrlProvider, (prev, state) {
          if (prev?.mode != StormMode.ended && state.mode == StormMode.ended) {
            Future.delayed(const Duration(milliseconds: 200), () {
              if (context.mounted) {
                _showStats(context, ref.read(ctrlProvider).stats!);
              }
            });
          }

          if (state.mode == StormMode.ended) {
            clearAndroidBoardGesturesExclusion();
          }
        });

        return InteractiveBoardScreen(
          boardKey: boardKey,
          canPop: stormState.mode != StormMode.running,
          onPopInvokedWithResult: (bool didPop, _) async {
            if (didPop) {
              return;
            }
            final NavigatorState navigator = Navigator.of(context);
            final shouldPop = await showAdaptiveDialog<bool>(
              context: context,
              builder: (context) => YesNoDialog(
                title: Text(context.l10n.mobileAreYouSure),
                content: Text(context.l10n.mobilePuzzleStormConfirmEndRun),
                onYes: () {
                  return Navigator.of(context).pop(true);
                },
                onNo: () => Navigator.of(context).pop(false),
              ),
            );
            if (shouldPop ?? false) {
              navigator.pop();
            }
          },
          child: Column(
            children: [
              Expanded(
                child: BoardTable(
                  boardKey: boardKey,
                  orientation: stormState.pov,
                  lastMove: stormState.lastMove as NormalMove?,
                  fen: stormState.position.fen,
                  interactiveBoardParams: (
                    position: stormState.position,
                    variant: Variant.standard,
                    playerSide:
                        !stormState.firstMovePlayed ||
                            stormState.mode == StormMode.ended ||
                            stormState.position.isGameOver
                        ? PlayerSide.none
                        : stormState.pov == Side.white
                        ? PlayerSide.white
                        : PlayerSide.black,
                    promotionMove: stormState.promotionMove,
                    onMove: (move, {isDrop, captured}) =>
                        ref.read(ctrlProvider.notifier).onUserMove(move),
                    onPromotionSelection: (role) =>
                        ref.read(ctrlProvider.notifier).onPromotionSelection(role),
                    premovable: null,
                  ),
                  topTable: _TopTable(data),
                  bottomTable: _Combo(stormState.combo),
                ),
              ),
              _BottomBar(ctrlProvider),
            ],
          ),
        );

      case AsyncError(:final error, :final stackTrace):
        debugPrint('SEVERE: [PuzzleStormScreen] could not load storm; $error\n$stackTrace');
        return Center(
          child: BoardTable(
            topTable: kEmptyWidget,
            bottomTable: kEmptyWidget,
            fen: kEmptyFen,
            orientation: Side.white,
            errorMessage: 'An error occurred while loading the storm: $error',
          ),
        );
      case _:
        return const CenterLoadingIndicator();
    }
  }
}

Future<void> _stormInfoDialogBuilder(BuildContext context) {
  return showAdaptiveDialog(
    context: context,
    builder: (context) {
      return AlertDialog.adaptive(
        title: Text(context.l10n.aboutX('Puzzle Storm')),
        content: const SingleChildScrollView(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(text: '\n'),
                TextSpan(
                  text:
                      'Each puzzle grants one point. The goal is to get as many points as you can before the time runs out.',
                ),
                TextSpan(text: '\n\n'),
                TextSpan(text: 'Combo bar\n', style: TextStyle(fontSize: 18)),
                TextSpan(
                  text: 'Each correct ',
                  children: [
                    TextSpan(
                      text: 'move',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text:
                          ' fills the combo bar. When the bar is full, you get a time bonus, and you increase the value of the next bonus.',
                    ),
                  ],
                ),
                TextSpan(text: '\n\n'),
                TextSpan(text: 'Bonus values:\n'),
                TextSpan(text: '• 5 moves: +3s\n'),
                TextSpan(text: '• 12 moves: +5s\n'),
                TextSpan(text: '• 20 moves: +7s\n'),
                TextSpan(text: '• 30 moves: +10s\n'),
                TextSpan(text: '• Then +10s every 10 other moves.\n'),
                TextSpan(text: '\n'),
                TextSpan(
                  text:
                      'When you play a wrong move, the combo bar is depleted, and you lose 10 seconds.',
                ),
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

void _showStats(BuildContext context, StormRunStats stats) {
  Navigator.of(context, rootNavigator: true).push(_RunStats.buildRoute(context, stats));
}

class _TopTable extends ConsumerWidget {
  const _TopTable(this.data);

  final PuzzleStormResponse data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stormState = ref.watch(stormControllerProvider(data.puzzles, data.timestamp));
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (stormState.mode == StormMode.initial)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.stormMoveToStart,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      stormState.pov == Side.white
                          ? context.l10n.stormYouPlayTheWhitePiecesInAllPuzzles
                          : context.l10n.stormYouPlayTheBlackPiecesInAllPuzzles,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            )
          else ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(LichessIcons.storm, size: 50.0, color: ColorScheme.of(context).primary),
                    const SizedBox(width: 8),
                    Text(
                      stormState.numSolved.toString().padRight(2),
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color: ColorScheme.of(context).primary,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
          ],
          StormClockWidget(clock: stormState.clock),
        ],
      ),
    );
  }
}

class _Combo extends ConsumerStatefulWidget {
  const _Combo(this.combo);

  final StormCombo combo;

  @override
  ConsumerState<_Combo> createState() => _ComboState();
}

class _ComboState extends ConsumerState<_Combo> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
      value: widget.combo.percent(getNext: false) / 100,
    );
  }

  @override
  void didUpdateWidget(covariant _Combo oldWidget) {
    super.didUpdateWidget(oldWidget);

    final newVal = widget.combo.percent(getNext: false) / 100;
    if (_controller.value != newVal) {
      // next lvl reached
      if (_controller.value > newVal && widget.combo.current != 0) {
        if (ref.read(boardPreferencesProvider).hapticFeedback) {
          HapticFeedback.heavyImpact();
        }
        _controller.animateTo(1.0, curve: Curves.easeInOut).then((_) async {
          await Future<void>.delayed(const Duration(milliseconds: 300));
          if (mounted) {
            _controller.value = 0;
          }
        });
        return;
      }
      _controller.animateTo(newVal, curve: Curves.easeIn);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lvl = widget.combo.currentLevel();
    final indicatorColor = ColorScheme.of(context).secondary;

    final comboShades = generateShades(
      ColorScheme.of(context).secondary,
      Theme.of(context).brightness,
    );
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.combo.current.toString(),
                      style: const TextStyle(
                        fontSize: 26,
                        height: 1.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(context.l10n.stormCombo),
                  ],
                ),
              ),
              SizedBox(
                width: constraints.maxWidth * 0.65,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 25,
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: _controller.value == 1.0
                              ? [
                                  BoxShadow(
                                    color: indicatorColor.withValues(alpha: 0.3),
                                    blurRadius: 10.0,
                                    spreadRadius: 2.0,
                                  ),
                                ]
                              : [],
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(3.0)),
                          child: LinearProgressIndicator(
                            value: _controller.value,
                            valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: StormCombo.levelBonus.mapIndexed((index, level) {
                        final isCurrentLevel = index < lvl;
                        return AnimatedContainer(
                          alignment: Alignment.center,
                          curve: Curves.easeIn,
                          duration: const Duration(milliseconds: 1000),
                          width: 28 * MediaQuery.textScalerOf(context).scale(14) / 14,
                          height: 24 * MediaQuery.textScalerOf(context).scale(14) / 14,
                          decoration: isCurrentLevel
                              ? BoxDecoration(
                                  color: comboShades[index],
                                  borderRadius: const BorderRadius.all(Radius.circular(3.0)),
                                )
                              : null,
                          child: Text(
                            '${level}s',
                            style: TextStyle(
                              color: isCurrentLevel ? ColorScheme.of(context).onSecondary : null,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10.0),
            ],
          );
        },
      ),
    );
  }

  List<Color> generateShades(Color baseColor, Brightness brightness) {
    return List.generate(4, (index) {
      final shade = switch (index) {
        0 => 0.1,
        1 => 0.3,
        2 => 0.5,
        3 => 0.7,
        _ => 0.0,
      };
      return brightness == Brightness.light ? darken(baseColor, shade) : lighten(baseColor, shade);
    });
  }
}

class _BottomBar extends ConsumerWidget {
  const _BottomBar(this.ctrl);

  final StormControllerProvider ctrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stormState = ref.watch(ctrl);
    return BottomBar(
      children: [
        if (stormState.mode == StormMode.initial)
          BottomBarButton(
            icon: Icons.info_outline,
            label: context.l10n.aboutX('Storm'),
            showLabel: true,
            onTap: () => _stormInfoDialogBuilder(context),
          ),
        BottomBarButton(
          icon: Icons.delete,
          label: context.l10n.stormNewRun.split('(').first.trimRight(),
          showLabel: true,
          onTap: () {
            stormState.clock.reset();
            ref.invalidate(stormProvider);
          },
        ),
        if (stormState.mode == StormMode.running)
          BottomBarButton(
            icon: LichessIcons.flag,
            label: context.l10n.stormEndRun.split('(').first.trimRight(),
            showLabel: true,
            onTap: stormState.puzzleIndex >= 1
                ? () {
                    if (stormState.clock.startAt != null) {
                      stormState.clock.sendEnd();
                    }
                  }
                : null,
          ),
        if (stormState.mode == StormMode.ended && stormState.stats != null)
          BottomBarButton(
            icon: Icons.open_in_new,
            label: 'Result',
            showLabel: true,
            onTap: () => _showStats(context, stormState.stats!),
          ),
      ],
    );
  }
}

class _RunStats extends StatelessWidget {
  const _RunStats(this.stats);
  final StormRunStats stats;

  static Route<dynamic> buildRoute(BuildContext context, StormRunStats stats) {
    return buildScreenRoute(context, screen: _RunStats(stats), fullscreenDialog: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const SizedBox.shrink(),
      ),
      body: _RunStatsPopup(stats),
    );
  }
}

class _RunStatsPopup extends ConsumerStatefulWidget {
  const _RunStatsPopup(this.stats);

  final StormRunStats stats;

  @override
  ConsumerState<_RunStatsPopup> createState() => _RunStatsPopupState();
}

class _RunStatsPopupState extends ConsumerState<_RunStatsPopup> {
  StormFilter filter = const StormFilter(slow: false, failed: false);
  @override
  Widget build(BuildContext context) {
    final puzzleList = widget.stats.historyFilter(filter);
    final highScoreWidgets = widget.stats.newHigh != null
        ? [
            const SizedBox(height: 16),
            Card(
              margin: Styles.bodySectionPadding,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  leading: Icon(
                    LichessIcons.storm,
                    size: 46,
                    color: ColorScheme.of(context).primary,
                  ),
                  title: Text(
                    newHighTitle(context, widget.stats.newHigh!),
                    style: Styles.sectionTitle,
                  ),
                  subtitle: Text(
                    context.l10n.stormPreviousHighscoreWasX(widget.stats.newHigh!.prev.toString()),
                  ),
                ),
              ),
            ),
          ]
        : null;

    return SafeArea(
      child: ListView(
        children: [
          if (highScoreWidgets != null) ...highScoreWidgets,
          ListSection(
            header: Text('${widget.stats.score} ${context.l10n.stormPuzzlesSolved}'),
            children: [
              _StatsRow(context.l10n.stormMoves, widget.stats.moves.toString()),
              _StatsRow(
                context.l10n.accuracy,
                '${(((widget.stats.moves - widget.stats.errors) / widget.stats.moves) * 100).toStringAsFixed(2)}%',
              ),
              _StatsRow(context.l10n.stormCombo, widget.stats.comboBest.toString()),
              _StatsRow(context.l10n.stormTime, '${widget.stats.time.inSeconds}s'),
              _StatsRow(
                context.l10n.stormTimePerMove,
                '${widget.stats.timePerMove.toStringAsFixed(1)}s',
              ),
              _StatsRow(context.l10n.stormHighestSolved, widget.stats.highest.toString()),
            ],
          ),
          const SizedBox(height: 10.0),
          Padding(
            padding: Styles.horizontalBodyPadding,
            child: FilledButton(
              onPressed: () {
                ref.invalidate(stormProvider);
                Navigator.of(context).pop();
              },
              child: Text(context.l10n.stormPlayAgain),
            ),
          ),
          const SizedBox(height: 10.0),
          Padding(
            padding: Styles.bodySectionPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(context.l10n.stormPuzzlesPlayed, style: Styles.sectionTitle),
                    const Spacer(),
                    Tooltip(
                      excludeFromSemantics: true,
                      message: context.l10n.stormFailedPuzzles,
                      child: SemanticIconButton(
                        semanticsLabel: context.l10n.stormFailedPuzzles,
                        icon: const Icon(Icons.close),
                        onPressed: () =>
                            setState(() => filter = filter.copyWith(failed: !filter.failed)),
                        color: filter.failed ? ColorScheme.of(context).primary : null,
                      ),
                    ),
                    Tooltip(
                      message: context.l10n.stormSlowPuzzles,
                      excludeFromSemantics: true,
                      child: SemanticIconButton(
                        semanticsLabel: context.l10n.stormSlowPuzzles,
                        icon: const Icon(Icons.hourglass_bottom),
                        onPressed: () =>
                            setState(() => filter = filter.copyWith(slow: !filter.slow)),
                        color: filter.slow ? ColorScheme.of(context).primary : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3.0),
                if (puzzleList.isNotEmpty)
                  PuzzleHistoryPreview(puzzleList, shouldOpenCasualPuzzleRun: true)
                else
                  Center(child: Text(context.l10n.mobilePuzzleStormFilterNothingToShow)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String newHighTitle(BuildContext context, StormNewHigh newHigh) {
    switch (newHigh.key) {
      case StormNewHighType.day:
        return context.l10n.stormNewDailyHighscore;
      case StormNewHighType.week:
        return context.l10n.stormNewWeeklyHighscore;
      case StormNewHighType.month:
        return context.l10n.stormNewMonthlyHighscore;
      case StormNewHighType.allTime:
        return context.l10n.stormNewAllTimeHighscore;
    }
  }
}

class _StatsRow extends StatelessWidget {
  final String label;
  final String? value;

  const _StatsRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label), if (value != null) Text(value!)],
      ),
    );
  }
}

class _StormDashboardButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(authSessionProvider);
    if (session != null) {
      return IconButton(
        tooltip: 'Storm History',
        onPressed: () => _showDashboard(context, session),
        icon: const Icon(Icons.history),
      );
    }
    return const SizedBox.shrink();
  }

  void _showDashboard(BuildContext context, AuthSessionState session) => Navigator.of(
    context,
    rootNavigator: true,
  ).push(StormDashboardModal.buildRoute(context, session.user));
}
