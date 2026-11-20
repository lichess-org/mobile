import 'package:dartchess/dartchess.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/study/study.dart';
import 'package:lichess_mobile/src/model/study/study_controller.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/study/create_study_chapter_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/adaptive_action_sheet.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/adaptive_choice_picker.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/platform_alert_dialog.dart';
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

    final canEdit = state.canIContribute;

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
            trailing: canEdit
                ? IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () =>
                        _showChapterSettings(context, ref, state: state, chapter: chapter),
                  )
                : null,
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

  void _showChapterSettings(
    BuildContext context,
    WidgetRef ref, {
    required StudyState state,
    required StudyChapterMeta chapter,
  }) {
    showAdaptiveActionSheet<void>(
      context: context,
      actions: [
        BottomSheetAction(
          makeLabel: (context) => Text(context.l10n.mobileRenameChapter),
          onPressed: () => _showRenameDialog(context, ref, chapter: chapter),
        ),
        BottomSheetAction(
          makeLabel: (_) => Text(context.l10n.studyOrientation),
          onPressed: () => _showOrientationPicker(context, ref, state: state, chapter: chapter),
        ),
        BottomSheetAction(
          makeLabel: (_) => Text(context.l10n.studyDeleteChapter),
          isDestructiveAction: true,
          onPressed: () {
            // Confirming pops the chapters sheet, which unmounts [context], so hold on to a
            // context that outlives it to be able to report a failure.
            final rootContext = Navigator.of(context, rootNavigator: true).context;
            showConfirmDialog<void>(
              context,
              title: Text(context.l10n.studyDeleteThisChapter),
              isDestructiveAction: true,
              onConfirm: () {
                Navigator.of(context).pop();
                ref
                    .read(studyControllerProvider(widget.options).notifier)
                    .deleteChapter(chapter.id)
                    .catchError((Object e) {
                      if (rootContext.mounted) {
                        showSnackBar(rootContext, e.toString(), type: SnackBarType.error);
                      }
                    });
              },
            );
          },
        ),
      ],
    );
  }

  void _showRenameDialog(BuildContext context, WidgetRef ref, {required StudyChapterMeta chapter}) {
    final textController = TextEditingController(text: chapter.name);
    showAdaptiveDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog.adaptive(
          title: Text(context.l10n.mobileRenameChapter),
          content: TextField(
            controller: textController,
            autofocus: true,
            textInputAction: TextInputAction.done,
            onSubmitted: (value) {
              if (value.trim().isNotEmpty) {
                ref
                    .read(studyControllerProvider(widget.options).notifier)
                    .editChapter(chapter.id, name: value.trim());
              }
              Navigator.of(context).pop();
            },
          ),
          actions: [
            PlatformDialogAction(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(context.l10n.cancel),
            ),
            PlatformDialogAction(
              onPressed: () {
                final value = textController.text;
                if (value.trim().isNotEmpty) {
                  ref
                      .read(studyControllerProvider(widget.options).notifier)
                      .editChapter(chapter.id, name: value.trim());
                }
                Navigator.of(context).pop();
              },
              child: Text(context.l10n.mobileOkButton),
            ),
          ],
        );
      },
    );
  }

  void _showOrientationPicker(
    BuildContext context,
    WidgetRef ref, {
    required StudyState state,
    required StudyChapterMeta chapter,
  }) {
    final currentOrientation = chapter.id == state.currentChapter.id
        ? state.study.chapter.setup.orientation
        : Side.white;

    showChoicePicker<Side>(
      context,
      title: Text(context.l10n.studyOrientation),
      choices: Side.values,
      selectedItem: currentOrientation,
      labelBuilder: (side) => Text(side == Side.white ? context.l10n.white : context.l10n.black),
      onSelectedItemChanged: (side) {
        ref
            .read(studyControllerProvider(widget.options).notifier)
            .editChapter(chapter.id, orientation: side);
      },
    );
  }
}
