import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/study/study_controller.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/study/create_study_chapter_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:material_ui/material_ui.dart';

/// Opens a bottom sheet, filling most of the screen, to browse a study.
Future<void> showStudySheet(
  BuildContext context, {
  required Widget Function(BuildContext, ScrollController) builder,
}) {
  return showAdaptiveDraggableBottomSheet<void>(
    context: context,
    constraints: BoxConstraints(maxHeight: MediaQuery.heightOf(context) * 0.9),
    initialChildSize: 0.6,
    snap: true,
    builder: builder,
  );
}

/// Opens the list of the chapters of a study, to go to one of them or create a new one.
Future<void> showStudyChaptersSheet(BuildContext context, StudyOptions options) {
  return showStudySheet(
    context,
    builder: (context, scrollController) =>
        _StudyChaptersMenu(options: options, scrollController: scrollController),
  );
}

class const _StudyChaptersMenu({
  required final StudyOptions options,
  required final ScrollController scrollController,
}) extends ConsumerStatefulWidget {
  @override
  ConsumerState<_StudyChaptersMenu> createState() => _StudyChaptersMenuState();
}

class _StudyChaptersMenuState() extends ConsumerState<_StudyChaptersMenu> {
  final currentChapterKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(studyControllerProvider(widget.options)).requireValue;

    // Scroll to the current chapter
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (currentChapterKey.currentContext != null) {
        Scrollable.ensureVisible(currentChapterKey.currentContext!, alignment: 0.5);
      }
    });

    return BottomSheetScrollableContainer(
      scrollController: widget.scrollController,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n.studyNbChapters(state.study.chapters.length),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        for (final chapter in state.study.chapters)
          ListTile(
            key: chapter.id == state.currentChapter.id ? currentChapterKey : null,
            title: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '${state.study.getChapterIndex(chapter.id) + 1} ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: chapter.name),
                ],
              ),
              maxLines: 2,
            ),
            onTap: () {
              ref.read(studyControllerProvider(widget.options).notifier).goToChapter(chapter.id);
              Navigator.of(context).pop();
            },
            selected: chapter.id == state.currentChapter.id,
          ),
        if (state.canIContribute)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: FilledButton.tonalIcon(
              onPressed: () {
                final studyNotifier = ref.read(studyControllerProvider(widget.options).notifier);
                Navigator.of(context).pop();
                if (!context.mounted) return;

                showAdaptiveBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  useRootNavigator: true,
                  builder: (context) => CreateStudyChapterBottomSheet(
                    params: CreateChapterOfExistingStudy(state.study.id),
                    initialChapterName: context.l10n.studyChapterX(
                      (state.study.chapters.length + 1).toString(),
                    ),
                    onChaptersCreated: (_, chapters) {
                      // The server always answers with the created chapters, but the response
                      // mapper tolerates an empty list, and this runs after the sheet was popped:
                      // an exception here would surface as an unhandled error.
                      final chapterId = chapters.firstOrNull;
                      if (chapterId != null) {
                        studyNotifier.goToChapter(chapterId);
                      }
                    },
                  ),
                );
              },
              label: Text(context.l10n.studyNewChapter),
              icon: const Icon(Icons.add),
            ),
          ),
      ],
    );
  }
}
