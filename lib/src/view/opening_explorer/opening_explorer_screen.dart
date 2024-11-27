import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/opening_explorer/opening_explorer.dart';
import 'package:lichess_mobile/src/model/opening_explorer/opening_explorer_preferences.dart';
import 'package:lichess_mobile/src/model/opening_explorer/opening_explorer_repository.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/screen.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_board.dart';
import 'package:lichess_mobile/src/view/opening_explorer/opening_explorer_widgets.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar_button.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/move_list.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import 'opening_explorer_settings.dart';

const _kTableRowVerticalPadding = 12.0;
const _kTableRowHorizontalPadding = 8.0;
const _kTableRowPadding = EdgeInsets.symmetric(
  horizontal: _kTableRowHorizontalPadding,
  vertical: _kTableRowVerticalPadding,
);
const _kTabletBoardRadius = Radius.circular(4.0);

class OpeningExplorerScreen extends ConsumerStatefulWidget {
  const OpeningExplorerScreen({required this.options});

  final AnalysisOptions options;

  @override
  ConsumerState<OpeningExplorerScreen> createState() => _OpeningExplorerState();
}

class _OpeningExplorerState extends ConsumerState<OpeningExplorerScreen> {
  final Map<OpeningExplorerCacheKey, OpeningExplorerEntry> cache = {};

  /// Last explorer content that was successfully loaded. This is used to
  /// display a loading indicator while the new content is being fetched.
  List<Widget>? lastExplorerWidgets;

  @override
  Widget build(BuildContext context) {
    switch (ref.watch(analysisControllerProvider(widget.options))) {
      case AsyncData(value: final analysisState):
        final opening = analysisState.currentNode.isRoot
            ? LightOpening(
                eco: '',
                name: context.l10n.startPosition,
              )
            : analysisState.currentNode.opening ??
                analysisState.currentBranchOpening ??
                analysisState.contextOpening;

        final Widget openingHeader = Container(
          padding: _kTableRowPadding,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
          ),
          child: opening != null
              ? GestureDetector(
                  onTap: opening.name == context.l10n.startPosition
                      ? null
                      : () => launchUrl(
                            Uri.parse(
                              'https://lichess.org/opening/${opening.name}',
                            ),
                          ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.open_in_browser_outlined,
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                      const SizedBox(width: 6.0),
                      Expanded(
                        child: Text(
                          opening.name,
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onSecondaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        );

        if (analysisState.position.ply >= 50) {
          return _OpeningExplorerView(
            options: widget.options,
            isLoading: false,
            isIndexing: false,
            children: [
              openingHeader,
              OpeningExplorerMoveTable.maxDepth(
                options: widget.options,
              ),
            ],
          );
        }

        final prefs = ref.watch(openingExplorerPreferencesProvider);

        if (prefs.db == OpeningDatabase.player &&
            prefs.playerDb.username == null) {
          return _OpeningExplorerView(
            options: widget.options,
            isLoading: false,
            isIndexing: false,
            children: [
              openingHeader,
              const Padding(
                padding: _kTableRowPadding,
                child: Center(
                  // TODO: l10n
                  child: Text('Select a Lichess player in the settings.'),
                ),
              ),
            ],
          );
        }

        final cacheKey = OpeningExplorerCacheKey(
          fen: analysisState.position.fen,
          prefs: prefs,
        );
        final cacheOpeningExplorer = cache[cacheKey];
        final openingExplorerAsync = cacheOpeningExplorer != null
            ? AsyncValue.data(
                (entry: cacheOpeningExplorer, isIndexing: false),
              )
            : ref.watch(
                openingExplorerProvider(fen: analysisState.position.fen),
              );

        if (cacheOpeningExplorer == null) {
          ref.listen(openingExplorerProvider(fen: analysisState.position.fen),
              (_, curAsync) {
            curAsync.whenData((cur) {
              if (cur != null && !cur.isIndexing) {
                cache[cacheKey] = cur.entry;
              }
            });
          });
        }

        final isLoading = openingExplorerAsync.isLoading ||
            openingExplorerAsync.value == null;

        return _OpeningExplorerView(
          options: widget.options,
          isLoading: isLoading,
          isIndexing: openingExplorerAsync.value?.isIndexing ?? false,
          children: openingExplorerAsync.when(
            data: (openingExplorer) {
              if (openingExplorer == null) {
                return lastExplorerWidgets ??
                    [
                      Shimmer(
                        child: ShimmerLoading(
                          isLoading: true,
                          child: OpeningExplorerMoveTable.loading(
                            options: widget.options,
                          ),
                        ),
                      ),
                    ];
              }

              final topGames = openingExplorer.entry.topGames;
              final recentGames = openingExplorer.entry.recentGames;

              final ply = analysisState.position.ply;

              final children = [
                openingHeader,
                OpeningExplorerMoveTable(
                  moves: openingExplorer.entry.moves,
                  whiteWins: openingExplorer.entry.white,
                  draws: openingExplorer.entry.draws,
                  blackWins: openingExplorer.entry.black,
                  options: widget.options,
                ),
                if (topGames != null && topGames.isNotEmpty) ...[
                  OpeningExplorerHeaderTile(
                    key: const Key('topGamesHeader'),
                    child: Text(context.l10n.topGames),
                  ),
                  ...List.generate(
                    topGames.length,
                    (int index) {
                      return OpeningExplorerGameTile(
                        key: Key('top-game-${topGames.get(index).id}'),
                        game: topGames.get(index),
                        color: index.isEven
                            ? Theme.of(context).colorScheme.surfaceContainerLow
                            : Theme.of(context)
                                .colorScheme
                                .surfaceContainerHigh,
                        ply: ply,
                      );
                    },
                    growable: false,
                  ),
                ],
                if (recentGames != null && recentGames.isNotEmpty) ...[
                  OpeningExplorerHeaderTile(
                    key: const Key('recentGamesHeader'),
                    child: Text(context.l10n.recentGames),
                  ),
                  ...List.generate(
                    recentGames.length,
                    (int index) {
                      return OpeningExplorerGameTile(
                        key: Key('recent-game-${recentGames.get(index).id}'),
                        game: recentGames.get(index),
                        color: index.isEven
                            ? Theme.of(context).colorScheme.surfaceContainerLow
                            : Theme.of(context)
                                .colorScheme
                                .surfaceContainerHigh,
                        ply: ply,
                      );
                    },
                    growable: false,
                  ),
                ],
              ];

              lastExplorerWidgets = children;

              return children;
            },
            loading: () =>
                lastExplorerWidgets ??
                [
                  Shimmer(
                    child: ShimmerLoading(
                      isLoading: true,
                      child: OpeningExplorerMoveTable.loading(
                        options: widget.options,
                      ),
                    ),
                  ),
                ],
            error: (e, s) {
              debugPrint(
                'SEVERE: [OpeningExplorerScreen] could not load opening explorer data; $e\n$s',
              );
              return [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(e.toString()),
                  ),
                ),
              ];
            },
          ),
        );
      case AsyncError(:final error):
        debugPrint(
          'SEVERE: [OpeningExplorerScreen] could not load analysis data; $error',
        );
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(error.toString()),
          ),
        );
      case _:
        return const CenterLoadingIndicator();
    }
  }
}

class _OpeningExplorerView extends StatelessWidget {
  const _OpeningExplorerView({
    required this.options,
    required this.children,
    required this.isLoading,
    required this.isIndexing,
  });

  final AnalysisOptions options;
  final List<Widget> children;
  final bool isLoading;
  final bool isIndexing;

  @override
  Widget build(BuildContext context) {
    final isTablet = isTabletOrLarger(context);

    final body = SafeArea(
      bottom: false,
      child: Column(
        children: [
          if (Theme.of(context).platform == TargetPlatform.iOS)
            Padding(
              padding: isTablet
                  ? const EdgeInsets.symmetric(
                      horizontal: kTabletBoardTableSidePadding,
                    )
                  : EdgeInsets.zero,
              child: _MoveList(options: options),
            ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final aspectRatio = constraints.biggest.aspectRatio;
                final defaultBoardSize = constraints.biggest.shortestSide;
                final remainingHeight =
                    constraints.maxHeight - defaultBoardSize;
                final isSmallScreen =
                    remainingHeight < kSmallRemainingHeightLeftBoardThreshold;
                final boardSize = isTablet || isSmallScreen
                    ? defaultBoardSize - kTabletBoardTableSidePadding * 2
                    : defaultBoardSize;

                final isLandscape = aspectRatio > 1;
                final brightness = Theme.of(context).brightness;
                final loadingOverlay = Positioned.fill(
                  child: IgnorePointer(
                    ignoring: !isLoading,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.fastOutSlowIn,
                      opacity: isLoading ? 0.2 : 0.0,
                      child: ColoredBox(
                        color: brightness == Brightness.dark
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                  ),
                );

                if (isLandscape) {
                  return Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: kTabletBoardTableSidePadding,
                          top: kTabletBoardTableSidePadding,
                          bottom: kTabletBoardTableSidePadding,
                        ),
                        child: AnalysisBoard(
                          options,
                          boardSize,
                          radius: isTablet ? _kTabletBoardRadius : null,
                          shouldReplaceChildOnUserMove: true,
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: PlatformCard(
                                clipBehavior: Clip.hardEdge,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(4.0),
                                ),
                                margin: const EdgeInsets.all(
                                  kTabletBoardTableSidePadding,
                                ),
                                semanticContainer: false,
                                child: Stack(
                                  children: [
                                    ListView(
                                      padding: EdgeInsets.zero,
                                      children: children,
                                    ),
                                    loadingOverlay,
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  return ListView(
                    padding: isTablet
                        ? const EdgeInsets.symmetric(
                            horizontal: kTabletBoardTableSidePadding,
                          )
                        : EdgeInsets.zero,
                    children: [
                      GestureDetector(
                        // disable scrolling when dragging the board
                        onVerticalDragStart: (_) {},
                        child: AnalysisBoard(
                          options,
                          boardSize,
                          shouldReplaceChildOnUserMove: true,
                        ),
                      ),
                      Stack(
                        children: [
                          ListBody(children: children),
                          if (isLoading) loadingOverlay,
                        ],
                      ),
                    ],
                  );
                }
              },
            ),
          ),
          _BottomBar(options: options),
        ],
      ),
    );

    return PlatformWidget(
      androidBuilder: (_) => Scaffold(
        body: body,
        appBar: AppBar(
          title: Text(context.l10n.openingExplorer),
          bottom: _MoveList(options: options),
          actions: [
            if (isIndexing) const _IndexingIndicator(),
          ],
        ),
      ),
      iosBuilder: (_) => CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(context.l10n.openingExplorer),
          automaticBackgroundVisibility: false,
          border: null,
          trailing: isIndexing ? const _IndexingIndicator() : null,
        ),
        child: body,
      ),
    );
  }
}

class _IndexingIndicator extends StatefulWidget {
  const _IndexingIndicator();

  @override
  State<_IndexingIndicator> createState() => _IndexingIndicatorState();
}

class _IndexingIndicatorState extends State<_IndexingIndicator>
    with TickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..addListener(() {
        setState(() {});
      });
    controller.repeat();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator.adaptive(
          value: controller.value,
          // TODO: l10n
          semanticsLabel: 'Indexing',
        ),
      ),
    );
  }
}

class _MoveList extends ConsumerWidget implements PreferredSizeWidget {
  const _MoveList({required this.options});

  final AnalysisOptions options;

  @override
  Size get preferredSize => const Size.fromHeight(40.0);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrlProvider = analysisControllerProvider(options);
    final state = ref.watch(ctrlProvider).requireValue;
    final slicedMoves = state.root.mainline
        .map((e) => e.sanMove.san)
        .toList()
        .asMap()
        .entries
        .slices(2);
    final currentMoveIndex = state.currentNode.position.ply;

    return MoveList(
      inlineDecoration: Theme.of(context).platform == TargetPlatform.iOS
          ? BoxDecoration(
              color: Styles.cupertinoAppBarColor.resolveFrom(context),
              border: const Border(
                bottom: BorderSide(
                  color: Color(0x4D000000),
                  width: 0.0,
                ),
              ),
            )
          : null,
      type: MoveListType.inline,
      slicedMoves: slicedMoves,
      currentMoveIndex: currentMoveIndex,
      onSelectMove: (index) {
        ref.read(ctrlProvider.notifier).jumpToNthNodeOnMainline(index - 1);
      },
    );
  }
}

class _BottomBar extends ConsumerWidget {
  const _BottomBar({required this.options});

  final AnalysisOptions options;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref
        .watch(openingExplorerPreferencesProvider.select((value) => value.db));
    final ctrlProvider = analysisControllerProvider(options);
    final canGoBack =
        ref.watch(ctrlProvider.select((value) => value.requireValue.canGoBack));
    final canGoNext =
        ref.watch(ctrlProvider.select((value) => value.requireValue.canGoNext));

    final dbLabel = switch (db) {
      OpeningDatabase.master => 'Masters',
      OpeningDatabase.lichess => 'Lichess',
      OpeningDatabase.player => context.l10n.player,
    };

    return BottomBar(
      children: [
        BottomBarButton(
          label: dbLabel,
          showLabel: true,
          onTap: () => showAdaptiveBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            showDragHandle: true,
            isDismissible: true,
            builder: (_) => OpeningExplorerSettings(options),
          ),
          icon: Icons.tune,
        ),
        BottomBarButton(
          label: 'Flip',
          tooltip: context.l10n.flipBoard,
          showLabel: true,
          onTap: () => ref.read(ctrlProvider.notifier).toggleBoard(),
          icon: CupertinoIcons.arrow_2_squarepath,
        ),
        RepeatButton(
          onLongPress: canGoBack ? () => _moveBackward(ref) : null,
          child: BottomBarButton(
            onTap: canGoBack ? () => _moveBackward(ref) : null,
            label: 'Previous',
            showLabel: true,
            icon: CupertinoIcons.chevron_back,
            showTooltip: false,
          ),
        ),
        RepeatButton(
          onLongPress: canGoNext ? () => _moveForward(ref) : null,
          child: BottomBarButton(
            icon: CupertinoIcons.chevron_forward,
            label: 'Next',
            showLabel: true,
            onTap: canGoNext ? () => _moveForward(ref) : null,
            showTooltip: false,
          ),
        ),
      ],
    );
  }

  void _moveForward(WidgetRef ref) =>
      ref.read(analysisControllerProvider(options).notifier).userNext();
  void _moveBackward(WidgetRef ref) =>
      ref.read(analysisControllerProvider(options).notifier).userPrevious();
}
