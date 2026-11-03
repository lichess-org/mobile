import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/node.dart';
import 'package:lichess_mobile/src/model/study/study_controller.dart';
import 'package:lichess_mobile/src/model/study/study_preferences.dart';
import 'package:lichess_mobile/src/widgets/pgn.dart';
import 'package:lichess_mobile/src/widgets/variations_bar.dart';
import 'package:material_ui/material_ui.dart';

class const StudyTreeView(final StudyOptions options, {required final bool showTopDivider})
    extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studyState = ref.watch(studyControllerProvider(options)).requireValue;
    final root =
        studyState.root ??
        // If root is null, the study chapter's position is illegal.
        // We still want to display the root comments though, so create a dummy root.
        const ViewRoot(position: Chess.initial, children: IList.empty());

    final studyPrefs = ref.watch(studyPreferencesProvider);

    final currentNode = root.branchesOn(studyState.currentPath).lastOrNull ?? root;
    // The height of a bar floating over the view: the moves scroll under it, unless the variations
    // bar is shown, which is kept above it.
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final hasVariations = currentNode.children.length > 1;

    return Column(
      crossAxisAlignment: .stretch,
      children: [
        Expanded(
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: EdgeInsets.only(bottom: hasVariations ? 0.0 : bottomInset),
                sliver: SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Expanded(
                        child: DebouncedPgnTreeView(
                          root: root,
                          currentPath: studyState.currentPath,
                          pgnRootComments: studyState.pgnRootComments,
                          notifier: ref.read(studyControllerProvider(options).notifier),
                          showTopDivider: showTopDivider,
                          shouldShowAnnotations: studyPrefs.showAnnotations,
                          displayMode: studyPrefs.inlineNotation ? .inlineNotation : .twoColumn,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        if (hasVariations)
          Padding(
            padding: EdgeInsets.only(bottom: bottomInset),
            child: VariationsBar(
              currentNode: currentNode,
              currentPath: studyState.currentPath,
              showAnnotations: studyPrefs.showAnnotations,
              onJump: (path) => ref.read(studyControllerProvider(options).notifier).userJump(path),
            ),
          ),
      ],
    );
  }
}
