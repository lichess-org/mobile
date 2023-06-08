import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_service.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';
import 'package:lichess_mobile/src/model/settings/brightness.dart';
import 'package:lichess_mobile/src/ui/puzzle/puzzle_screen.dart';
import 'package:lichess_mobile/src/ui/puzzle/storm_clock.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chessground/chessground.dart' as cg;
import 'package:dartchess/dartchess.dart';

import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/puzzle/storm.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_providers.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_repository.dart';
import 'package:lichess_mobile/src/model/puzzle/storm_ctrl.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/adaptive_dialog.dart';
import 'package:lichess_mobile/src/widgets/board_thumbnail.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/table_board_layout.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/utils/chessground_compat.dart';
import "package:lichess_mobile/src/utils/l10n_context.dart";
import "package:lichess_mobile/src/utils/immersive_mode.dart";
import 'package:lichess_mobile/src/ui/settings/toggle_sound_button.dart';

class StormScreen extends StatelessWidget {
  const StormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _androidBuilder,
      iosBuilder: _iosBuilder,
    );
  }

  Widget _androidBuilder(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [ToggleSoundButton()],
        title: const Text('Puzzle Storm'),
      ),
      body: const _Load(),
    );
  }

  Widget _iosBuilder(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Puzzle Storm'),
        trailing: ToggleSoundButton(),
      ),
      child: const _Load(),
    );
  }
}

class _Load extends ConsumerWidget {
  const _Load();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storm = ref.watch(stormProvider);
    return storm.when(
      data: (data) {
        return _Body(data: data);
      },
      loading: () => const CenterLoadingIndicator(),
      error: (e, s) {
        debugPrint(
          'SEVERE: [PuzzleStreakScreen] could not load streak; $e\n$s',
        );
        return Center(
          child: TableBoardLayout(
            topTable: kEmptyWidget,
            bottomTable: kEmptyWidget,
            boardData: const cg.BoardData(
              fen: kEmptyFen,
              interactableSide: cg.InteractableSide.none,
              orientation: cg.Side.white,
            ),
            errorMessage: e.toString(),
          ),
        );
      },
    );
  }
}

class _Body extends ConsumerStatefulWidget {
  const _Body({required this.data});
  final PuzzleStormResponse data;

  @override
  ConsumerState<_Body> createState() => _BodyState();
}

class _BodyState extends ConsumerState<_Body> with AndroidImmersiveMode {
  @override
  Widget build(BuildContext context) {
    final ctrlProvider = stormCtrlProvider(widget.data.puzzles);
    final puzzleState = ref.watch(ctrlProvider);

    ref.listen(ctrlProvider.select((state) => state.runOver), (_, s) {
      if (s) {
        Future.delayed(const Duration(milliseconds: 200), () {
          _showStats(context, ref.read(ctrlProvider).stats!);
        });
      }
    });

    final content = Column(
      children: [
        Expanded(
          child: Center(
            child: SafeArea(
              bottom: false,
              child: TableBoardLayout(
                boardData: cg.BoardData(
                  onMove: (move, {isPremove}) => ref
                      .read(ctrlProvider.notifier)
                      .onUserMove(Move.fromUci(move.uci)!),
                  orientation: puzzleState.pov.cg,
                  interactableSide:
                      puzzleState.runOver || puzzleState.position.isGameOver
                          ? cg.InteractableSide.none
                          : puzzleState.pov == Side.white
                              ? cg.InteractableSide.white
                              : cg.InteractableSide.black,
                  fen: puzzleState.position.fen,
                  isCheck: puzzleState.position.isCheck,
                  lastMove: puzzleState.lastMove?.cg,
                  sideToMove: puzzleState.position.turn.cg,
                  validMoves: puzzleState.validMoves,
                ),
                topTable: _TopTable(
                  ctrl: ctrlProvider,
                ),
                bottomTable: _Combo(puzzleState.combo),
              ),
            ),
          ),
        ),
        _BottomBar(ctrlProvider),
      ],
    );

    return !puzzleState.clock.isActive
        ? content
        : WillPopScope(
            child: content,
            onWillPop: () async {
              final result = await showAdaptiveDialog<bool>(
                context: context,
                builder: (context) => YesNoDialog(
                  title: const Text('Are you sure?'),
                  content: const Text(
                    'Do you want to end this run?',
                  ),
                  onYes: () {
                    return Navigator.of(context).pop(true);
                  },
                  onNo: () => Navigator.of(context).pop(false),
                ),
              );
              return result ?? false;
            },
          );
  }
}

Future<void> _stormInfoDialogBuilder(BuildContext context) {
  return showAdaptiveDialog(
    context: context,
    builder: (context) {
      final content = SingleChildScrollView(
        child: RichText(
          text: TextSpan(
            style: DefaultTextStyle.of(context).style,
            children: const [
              TextSpan(
                text: '\n',
              ),
              TextSpan(
                text:
                    'Each puzzle grants one point. The goal is to get as many points as you can before the time runs out.',
              ),
              TextSpan(
                text: '\n\n',
              ),
              TextSpan(
                text: 'Combo bar\n',
                style: TextStyle(fontSize: 18),
              ),
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
              TextSpan(
                text: '\n\n',
              ),
              TextSpan(
                text: 'Bonus values:\n',
              ),
              TextSpan(
                text: '• 5 moves: +3s\n',
              ),
              TextSpan(
                text: '• 12 moves: +5s\n',
              ),
              TextSpan(
                text: '• 20 moves: +7s\n',
              ),
              TextSpan(
                text: '• 30 moves: +10s\n',
              ),
              TextSpan(
                text: '• Then +10s every 10 other moves.\n',
              ),
              TextSpan(
                text: '\n',
              ),
              TextSpan(
                text:
                    'When you play a wrong move, the combo bar is depleted, and you lose 10 seconds.',
              ),
            ],
          ),
        ),
      );
      return defaultTargetPlatform == TargetPlatform.iOS
          ? CupertinoAlertDialog(
              title: Text(context.l10n.aboutX('Puzzle Storm')),
              content: content,
              actions: [
                CupertinoDialogAction(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            )
          : AlertDialog(
              title: Text(context.l10n.aboutX('Puzzle Storm')),
              content: content,
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            );
    },
  );
}

void _showStats(BuildContext context, StormRunStats stats) {
  pushPlatformRoute(
    context,
    rootNavigator: true,
    fullscreenDialog: true,
    builder: (_) => _RunStats(stats),
  );
}

class _TopTable extends ConsumerWidget {
  const _TopTable({
    required this.ctrl,
  });

  final StormCtrlProvider ctrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final puzzleState = ref.watch(ctrl);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (!puzzleState.runStarted)
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
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      puzzleState.pov == Side.white
                          ? context.l10n.stormYouPlayTheWhitePiecesInAllPuzzles
                          : context.l10n.stormYouPlayTheBlackPiecesInAllPuzzles,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else ...[
            const Icon(
              LichessIcons.storm,
              size: 50.0,
              color: LichessColors.brag,
            ),
            const SizedBox(width: 8),
            Text(
              puzzleState.numSolved.toString(),
              style: const TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                color: LichessColors.brag,
              ),
            ),
            const Spacer(),
          ],
          StormClockWidget(clock: puzzleState.clock),
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

class _ComboState extends ConsumerState<_Combo>
    with SingleTickerProviderStateMixin {
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
        _controller.animateTo(1.0, curve: Curves.easeInOut).then(
          (_) async {
            await Future<void>.delayed(const Duration(milliseconds: 300));
            if (mounted) {
              _controller.value = 0;
            }
          },
        );
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
    final indicatorColor = Theme.of(context).colorScheme.secondary;

    final comboShades = generateShades(
      indicatorColor,
      ref.watch(currentBrightnessProvider) == Brightness.light,
    );
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.combo.current.toString(),
                  style: TextStyle(
                    fontSize: 26,
                    height: 1.0,
                    fontWeight: FontWeight.bold,
                    color: defaultTargetPlatform == TargetPlatform.iOS
                        ? CupertinoTheme.of(context).textTheme.textStyle.color
                        : null,
                  ),
                ),
                Text(
                  context.l10n.stormCombo,
                  style: TextStyle(
                    color: defaultTargetPlatform == TargetPlatform.iOS
                        ? CupertinoTheme.of(context).textTheme.textStyle.color
                        : null,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.65,
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
                                color: indicatorColor.withOpacity(0.3),
                                blurRadius: 10.0,
                                spreadRadius: 2.0,
                              ),
                            ]
                          : [],
                    ),
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(3.0)),
                      child: LinearProgressIndicator(
                        value: _controller.value,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(indicatorColor),
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
                      width: 28 * MediaQuery.of(context).textScaleFactor,
                      height: 24 * MediaQuery.of(context).textScaleFactor,
                      decoration: isCurrentLevel
                          ? BoxDecoration(
                              color: comboShades[index],
                              borderRadius: const BorderRadius.all(
                                Radius.circular(3.0),
                              ),
                            )
                          : null,
                      child: Text(
                        '${level}s',
                        style: TextStyle(
                          color: isCurrentLevel
                              ? Theme.of(context).colorScheme.onSecondary
                              : null,
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
      ),
    );
  }

  List<Color> generateShades(Color baseColor, bool light) {
    final shades = <Color>[];

    final int r = baseColor.red;
    final int g = baseColor.green;
    final int b = baseColor.blue;

    const int step = 20;

    // Generate darker shades
    for (int i = 4; i >= 2; i = i - 2) {
      final int newR = (r - i * step).clamp(0, 255);
      final int newG = (g - i * step).clamp(0, 255);
      final int newB = (b - i * step).clamp(0, 255);
      shades.add(Color.fromARGB(baseColor.alpha, newR, newG, newB));
    }

    // Generate lighter shades
    for (int i = 2; i <= 3; i++) {
      final int newR = (r + i * step).clamp(0, 255);
      final int newG = (g + i * step).clamp(0, 255);
      final int newB = (b + i * step).clamp(0, 255);
      shades.add(Color.fromARGB(baseColor.alpha, newR, newG, newB));
    }

    if (light) {
      return shades.reversed.toList();
    }

    return shades;
  }
}

class _BottomBar extends ConsumerWidget {
  const _BottomBar(this.ctrl);

  final StormCtrlProvider ctrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final puzzleState = ref.watch(ctrl);
    return Container(
      padding: Styles.horizontalBodyPadding,
      color: defaultTargetPlatform == TargetPlatform.iOS
          ? CupertinoTheme.of(context).barBackgroundColor
          : Theme.of(context).bottomAppBarTheme.color,
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            if (!puzzleState.clock.isActive && !puzzleState.runOver)
              BottomBarButton(
                icon: Icons.info_outline,
                label: context.l10n.aboutX('Storm'),
                shortLabel: context.l10n.about,
                showAndroidShortLabel: true,
                onTap: () => _stormInfoDialogBuilder(context),
              ),
            BottomBarButton(
              icon: Icons.delete,
              label: context.l10n.stormNewRun.split(' ').take(2).join(' '),
              shortLabel: context.l10n.stormNewRun.split(' ').take(2).join(' '),
              showAndroidShortLabel: true,
              onTap: () => ref.invalidate(stormProvider),
            ),
            if (puzzleState.clock.isActive)
              BottomBarButton(
                icon: LichessIcons.flag,
                label: context.l10n.stormEndRun.split(' ').take(2).join(' '),
                shortLabel:
                    context.l10n.stormEndRun.split(' ').take(2).join(' '),
                showAndroidShortLabel: true,
                onTap: () {
                  if (puzzleState.clock.startAt != null) {
                    puzzleState.clock.sendEnd();
                  }
                },
              ),
            if (puzzleState.runOver && puzzleState.stats != null)
              BottomBarButton(
                icon: Icons.open_in_new,
                label: 'Result',
                shortLabel: 'Result',
                showAndroidShortLabel: true,
                onTap: () => _showStats(context, puzzleState.stats!),
              ),
          ],
        ),
      ),
    );
  }
}

class _RunStats extends StatelessWidget {
  const _RunStats(this.stats);
  final StormRunStats stats;

  @override
  Widget build(BuildContext context) {
    return defaultTargetPlatform == TargetPlatform.iOS
        ? CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              leading: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(context.l10n.close),
              ),
            ),
            child: _RunStatsPopup(stats),
          )
        : Scaffold(
            body: _RunStatsPopup(stats),
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          );
  }
}

class _RunStatsPopup extends ConsumerWidget {
  const _RunStatsPopup(this.stats);

  final StormRunStats stats;

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final highScoreWidgets = stats.newHigh != null
        ? [
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(
                LichessIcons.storm,
                size: 46,
                color: LichessColors.brag,
              ),
              title: Text(
                newHighTitle(context, stats.newHigh!),
                style: Styles.sectionTitle.copyWith(
                  color: LichessColors.brag,
                ),
              ),
              subtitle: Text(
                context.l10n.stormPreviousHighscoreWasX(
                  stats.newHigh!.prev.toString(),
                ),
                style: const TextStyle(
                  color: LichessColors.brag,
                ),
              ),
            ),
            const SizedBox(height: 10),
          ]
        : null;

    return SafeArea(
      child: ListView(
        children: [
          if (highScoreWidgets != null) ...highScoreWidgets,
          ListSection(
            cupertinoAdditionalDividerMargin: 6,
            header: Text(
              '${stats.score} ${context.l10n.stormPuzzlesSolved}',
            ),
            children: [
              _StatsRow(
                context.l10n.stormMoves,
                stats.moves.toString(),
              ),
              _StatsRow(
                context.l10n.accuracy,
                '${(((stats.moves - stats.errors) / stats.moves) * 100).toStringAsFixed(2)}%',
              ),
              _StatsRow(
                context.l10n.stormCombo,
                stats.comboBest.toString(),
              ),
              _StatsRow(
                context.l10n.stormTime,
                '${stats.time.inSeconds}s',
              ),
              _StatsRow(
                context.l10n.stormTimePerMove,
                '${stats.timePerMove.toStringAsFixed(1)}s',
              ),
              _StatsRow(
                context.l10n.stormHighestSolved,
                stats.highest.toString(),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          Padding(
            padding: Styles.horizontalBodyPadding,
            child: FatButton(
              semanticsLabel: context.l10n.stormPlayAgain,
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
                Text(
                  context.l10n.stormPuzzlesPlayed,
                  style: Styles.sectionTitle,
                ),
                const SizedBox(height: 3.0),
                _PuzzleHistory(stats),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PuzzleHistory extends ConsumerStatefulWidget {
  const _PuzzleHistory(this.stats);

  final StormRunStats stats;

  @override
  ConsumerState createState() => _PuzzleHistoryState();
}

class _PuzzleHistoryState extends ConsumerState<_PuzzleHistory> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constrains) {
        final crossAxisCount = constrains.maxWidth > kTabletThreshold ? 4 : 2;
        const columnGap = 12.0;
        final boardWidth = (constrains.maxWidth / crossAxisCount) -
            (columnGap / crossAxisCount);
        return LayoutGrid(
          columnSizes: List.generate(crossAxisCount, (_) => 1.fr),
          rowSizes: List.generate(
            (widget.stats.history.length / crossAxisCount).ceil(),
            (_) => auto,
          ),
          rowGap: 16.0,
          columnGap: columnGap,
          children: widget.stats.history.map((e) {
            final (side, fen, lastMove) = e.$1.preview;
            return BoardThumbnail(
              size: boardWidth,
              onTap: isLoading
                  ? null
                  : () async {
                      final session = ref.read(authSessionProvider);
                      Puzzle? puzzle;
                      try {
                        setState(() => isLoading = true);
                        puzzle = await ref.read(puzzleProvider(e.$1.id).future);
                      } catch (e) {
                        showPlatformSnackbar(
                          context,
                          e.toString(),
                        );
                      } finally {
                        if (mounted && puzzle != null) {
                          setState(() => isLoading = false);
                          pushPlatformRoute(
                            context,
                            builder: (_) => PuzzleScreen(
                              theme: PuzzleTheme.mix,
                              initialPuzzleContext: PuzzleContext(
                                theme: PuzzleTheme.mix,
                                puzzle: puzzle!,
                                userId: session?.user.id,
                              ),
                            ),
                          );
                        }
                      }
                    },
              orientation: side.cg,
              fen: fen,
              lastMove: lastMove.cg,
              footer: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ColoredBox(
                      color: e.$2 ? LichessColors.good : LichessColors.red,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 1,
                          horizontal: 3,
                        ),
                        child: Row(
                          children: [
                            if (e.$2)
                              const Icon(
                                color: Colors.white,
                                Icons.done,
                                size: 20,
                              )
                            else
                              const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 20,
                              ),
                            Text(
                              '${e.$3.inSeconds}s',
                              overflow: TextOverflow.fade,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(e.$1.rating.toString()),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
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
        children: [
          Text(label),
          if (value != null) Text(value!),
        ],
      ),
    );
  }
}
