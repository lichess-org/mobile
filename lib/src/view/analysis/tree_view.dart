import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_preferences.dart';
import 'package:lichess_mobile/src/model/analysis/opening_service.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/pgn.dart';

const kOpeningHeaderHeight = 32.0;

class AnalysisTreeView extends ConsumerWidget {
  const AnalysisTreeView(this.options);

  final AnalysisOptions options;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrlProvider = analysisControllerProvider(options);

    final variant = ref.watch(
      ctrlProvider.select((value) => value.requireValue.variant),
    );
    final root =
        ref.watch(ctrlProvider.select((value) => value.requireValue.root));
    final currentPath = ref
        .watch(ctrlProvider.select((value) => value.requireValue.currentPath));
    final pgnRootComments = ref.watch(
      ctrlProvider.select((value) => value.requireValue.pgnRootComments),
    );
    final prefs = ref.watch(analysisPreferencesProvider);
    // enable computer analysis takes effect here only if it's a lichess game
    final enableComputerAnalysis =
        !options.isLichessGameAnalysis || prefs.enableComputerAnalysis;

    return CustomScrollView(
      slivers: [
        if (kOpeningAllowedVariants.contains(variant))
          SliverPersistentHeader(
            delegate: _OpeningHeaderDelegate(ctrlProvider),
          ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: DebouncedPgnTreeView(
            root: root,
            currentPath: currentPath,
            pgnRootComments: pgnRootComments,
            notifier: ref.read(ctrlProvider.notifier),
            shouldShowComputerVariations: enableComputerAnalysis,
            shouldShowComments: enableComputerAnalysis && prefs.showPgnComments,
            shouldShowAnnotations:
                enableComputerAnalysis && prefs.showAnnotations,
          ),
        ),
      ],
    );
  }
}

class _OpeningHeaderDelegate extends SliverPersistentHeaderDelegate {
  const _OpeningHeaderDelegate(this.ctrlProvider);

  final AnalysisControllerProvider ctrlProvider;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return _Opening(ctrlProvider);
  }

  @override
  double get minExtent => kOpeningHeaderHeight;

  @override
  double get maxExtent => kOpeningHeaderHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}

class _Opening extends ConsumerWidget {
  const _Opening(this.ctrlProvider);

  final AnalysisControllerProvider ctrlProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isRootNode = ref.watch(
      ctrlProvider.select((s) => s.requireValue.currentNode.isRoot),
    );
    final nodeOpening = ref
        .watch(ctrlProvider.select((s) => s.requireValue.currentNode.opening));
    final branchOpening = ref
        .watch(ctrlProvider.select((s) => s.requireValue.currentBranchOpening));
    final contextOpening =
        ref.watch(ctrlProvider.select((s) => s.requireValue.contextOpening));
    final opening = isRootNode
        ? LightOpening(
            eco: '',
            name: context.l10n.startPosition,
          )
        : nodeOpening ?? branchOpening ?? contextOpening;

    return opening != null
        ? Container(
            height: kOpeningHeaderHeight,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Center(
                child: Text(
                  opening.name,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}
