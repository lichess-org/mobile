import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/node.dart';
import 'package:lichess_mobile/src/model/study/study_controller.dart';
import 'package:lichess_mobile/src/model/study/study_preferences.dart';
import 'package:lichess_mobile/src/widgets/pgn.dart';
import 'package:lichess_mobile/src/widgets/variations_bar.dart';

class StudyTreeView extends ConsumerWidget {
  const StudyTreeView(this.options, {required this.showTopDivider});

  final StudyOptions options;

  final bool showTopDivider;

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

    return Column(
      crossAxisAlignment: .stretch,
      children: [
        Expanded(
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
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
            ],
          ),
        ),
        VariationsBar(
          currentNode: currentNode,
          currentPath: studyState.currentPath,
          showAnnotations: studyPrefs.showAnnotations,
          onJump: (path) => ref.read(studyControllerProvider(options).notifier).userJump(path),
        ),
      ],
    );
  }
}
