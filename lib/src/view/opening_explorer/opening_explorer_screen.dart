import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/opening_explorer/opening_explorer.dart';
import 'package:lichess_mobile/src/model/opening_explorer/opening_explorer_preferences.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/screen.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_board.dart';
import 'package:lichess_mobile/src/view/opening_explorer/opening_explorer_view_builder.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar_button.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/move_list.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';

import 'opening_explorer_settings.dart';

const _kTabletBoardRadius = BorderRadius.all(Radius.circular(4.0));

class OpeningExplorerScreen extends ConsumerWidget {
  const OpeningExplorerScreen({required this.options});

  final AnalysisOptions options;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrlProvider = analysisControllerProvider(options);
    switch (ref.watch(ctrlProvider)) {
      case AsyncData(value: final state):
        return OpeningExplorerViewBuilder(
          ply: state.currentNode.position.ply,
          fen: state.currentNode.position.fen,
          onMoveSelected: ref.read(ctrlProvider.notifier).onUserMove,
          builder: (
            context,
            children, {
            required isLoading,
            required isIndexing,
          }) {
            return _OpeningExplorerView(
              options: options,
              isLoading: isLoading,
              isIndexing: isIndexing,
              children: children,
            );
          },
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
                          borderRadius: isTablet ? _kTabletBoardRadius : null,
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
