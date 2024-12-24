import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_preferences.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/node.dart';
import 'package:lichess_mobile/src/model/study/study_controller.dart';
import 'package:lichess_mobile/src/widgets/pgn.dart';

const kNextChapterButtonHeight = 32.0;

class StudyTreeView extends ConsumerWidget {
  const StudyTreeView(this.id, {super.key});

  final StudyId id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final root =
        ref.watch(studyControllerProvider(id).select((value) => value.requireValue.root)) ??
        // If root is null, the study chapter's position is illegal.
        // We still want to display the root comments though, so create a dummy root.
        const ViewRoot(position: Chess.initial, children: IList.empty());

    final currentPath = ref.watch(
      studyControllerProvider(id).select((value) => value.requireValue.currentPath),
    );

    final pgnRootComments = ref.watch(
      studyControllerProvider(id).select((value) => value.requireValue.pgnRootComments),
    );

    final analysisPrefs = ref.watch(analysisPreferencesProvider);

    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: DebouncedPgnTreeView(
                  root: root,
                  currentPath: currentPath,
                  pgnRootComments: pgnRootComments,
                  notifier: ref.read(studyControllerProvider(id).notifier),
                  shouldShowAnnotations: analysisPrefs.showAnnotations,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
