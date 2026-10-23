import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/study/pinned_studies.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/tab_navigation.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/study/study_screen.dart';
import 'package:lichess_mobile/src/widgets/adaptive_action_sheet.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:material_ui/material_ui.dart';

/// The pinned studies, each opening at its last viewed chapter.
class const PinnedStudiesSection() extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studies = ref.watch(pinnedStudiesProvider).studies;

    if (studies.isEmpty) {
      return const SizedBox.shrink();
    }

    return ListSection(
      // not translated until the feature has been released for a while
      header: const Text('Pinned studies'),
      hasLeading: true,
      children: [
        for (final study in studies)
          ListTile(
            leading: const Icon(LichessIcons.study),
            title: Text(
              study.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Styles.callout,
            ),
            subtitle: Text(context.l10n.studyNbChapters(study.chapterCount)),
            trailing: Theme.of(context).platform == TargetPlatform.iOS
                ? const CupertinoListTileChevron()
                : null,
            onTap: () => Navigator.of(context).pushHidingTabBar(
              StudyScreen.buildRoute((id: study.id, initialChapter: study.lastChapterId)),
            ),
            onLongPress: () => showAdaptiveActionSheet<void>(
              context: context,
              actions: [
                BottomSheetAction(
                  makeLabel: (context) => const Text('Unpin study'),
                  onPressed: () => ref.read(pinnedStudiesProvider.notifier).unpin(study.id),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
