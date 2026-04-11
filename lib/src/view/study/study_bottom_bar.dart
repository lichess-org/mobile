import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/study/study_controller.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_screen.dart';
import 'package:lichess_mobile/src/view/engine/engine_button.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';

class StudyBottomBar extends ConsumerWidget {
  const StudyBottomBar({required this.options});

  final StudyOptions options;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gamebook = ref.watch(
      studyControllerProvider(options).select((s) => s.requireValue.gamebookActive),
    );

    return gamebook ? _GamebookBottomBar(options: options) : _AnalysisBottomBar(options: options);
  }
}

class _AnalysisBottomBar extends ConsumerWidget {
  const _AnalysisBottomBar({required this.options});

  final StudyOptions options;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(studyControllerProvider(options)).value;
    if (state == null) {
      return const BottomBar(children: []);
    }

    final onGoForward = state.canGoNext
        ? ref.read(studyControllerProvider(options).notifier).userNext
        : null;
    final onGoBack = state.canGoBack
        ? ref.read(studyControllerProvider(options).notifier).userPrevious
        : null;

    return BottomBar(
      children: [
        _ChapterButton(options: options),
        _NextChapterButton(
          options: options,
          chapterId: state.study.chapter.id,
          hasNextChapter: state.hasNextChapter,
          blink: !state.isIntroductoryChapter && state.isAtEndOfChapter && state.hasNextChapter,
        ),
        if (state.isComputerAnalysisAllowed)
          Builder(
            builder: (context) {
              Future<void>? toggleFuture;
              return FutureBuilder(
                future: toggleFuture,
                builder: (context, snapshot) {
                  return EngineButton(
                    filters: (id: state.evaluationContext.id, path: state.currentPath),
                    savedEval: state.currentNode.eval,
                    onTap: snapshot.connectionState != ConnectionState.waiting
                        ? () async {
                            toggleFuture = ref
                                .read(studyControllerProvider(options).notifier)
                                .toggleEngine();
                            try {
                              await toggleFuture;
                            } finally {
                              toggleFuture = null;
                            }
                          }
                        : null,
                    goDeeper: () => ref
                        .read(studyControllerProvider(options).notifier)
                        .requestEval(goDeeper: true),
                  );
                },
              );
            },
          ),
        RepeatButton(
          onLongPress: onGoBack,
          child: BottomBarButton(
            key: const ValueKey('goto-previous'),
            onTap: onGoBack,
            label: context.l10n.studyBack,
            showLabel: true,
            icon: CupertinoIcons.chevron_back,
            showTooltip: false,
          ),
        ),
        RepeatButton(
          onLongPress: onGoForward,
          child: BottomBarButton(
            key: const ValueKey('goto-next'),
            icon: CupertinoIcons.chevron_forward,
            onTap: onGoForward,
            label: context.l10n.studyNext,
            showLabel: true,
            showTooltip: false,
          ),
        ),
      ],
    );
  }
}

class _GamebookBottomBar extends ConsumerWidget {
  const _GamebookBottomBar({required this.options});

  final StudyOptions options;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(studyControllerProvider(options)).requireValue;

    return BottomBar(
      children: [
        _ChapterButton(options: options),
        ...switch (state.gamebookState) {
          GamebookState.findTheMove => [
            BottomBarButton(
              onTap: !state.currentNode.isRoot
                  ? ref.read(studyControllerProvider(options).notifier).reset
                  : null,
              icon: Icons.skip_previous,
              label: context.l10n.studyBack,
              showLabel: true,
            ),
            BottomBarButton(
              icon: Icons.help,
              label: context.l10n.viewTheSolution,
              showLabel: true,
              onTap: ref.read(studyControllerProvider(options).notifier).showGamebookSolution,
            ),
          ],
          GamebookState.startLesson || GamebookState.correctMove => [
            BottomBarButton(
              onTap: !state.currentNode.isRoot
                  ? ref.read(studyControllerProvider(options).notifier).reset
                  : null,
              icon: Icons.skip_previous,
              label: context.l10n.studyBack,
              showLabel: true,
            ),
            BottomBarButton(
              onTap: ref.read(studyControllerProvider(options).notifier).userNext,
              icon: Icons.play_arrow,
              label: context.l10n.studyNext,
              showLabel: true,
              blink: state.gamebookComment != null && !state.isIntroductoryChapter,
            ),
          ],
          GamebookState.incorrectMove => [
            BottomBarButton(
              onTap: !state.currentNode.isRoot
                  ? ref.read(studyControllerProvider(options).notifier).reset
                  : null,
              icon: Icons.skip_previous,
              label: context.l10n.studyBack,
              showLabel: true,
            ),
            BottomBarButton(
              onTap: ref.read(studyControllerProvider(options).notifier).userPrevious,
              label: context.l10n.retry,
              showLabel: true,
              icon: Icons.refresh,
              blink: state.gamebookComment != null,
            ),
          ],
          GamebookState.lessonComplete => [
            if (!state.isIntroductoryChapter)
              BottomBarButton(
                onTap: ref.read(studyControllerProvider(options).notifier).reset,
                icon: Icons.refresh,
                label: context.l10n.studyPlayAgain,
                showLabel: true,
              ),
            _NextChapterButton(
              options: options,
              chapterId: state.study.chapter.id,
              hasNextChapter: state.hasNextChapter,
              blink: !state.isIntroductoryChapter && state.hasNextChapter,
            ),
            if (!state.isIntroductoryChapter)
              BottomBarButton(
                onTap: () => Navigator.of(context, rootNavigator: true).push(
                  AnalysisScreen.buildRoute(
                    context,
                    AnalysisOptions.pgn(
                      id: options.id,
                      orientation: state.pov,
                      pgn: state.pgn,
                      isComputerAnalysisAllowed: true,
                      variant: state.variant,
                    ),
                  ),
                ),
                icon: Icons.biotech,
                label: context.l10n.analysis,
                showLabel: true,
              ),
          ],
        },
      ],
    );
  }
}

class _NextChapterButton extends ConsumerStatefulWidget {
  const _NextChapterButton({
    required this.options,
    required this.chapterId,
    required this.hasNextChapter,
    required this.blink,
  });

  final StudyOptions options;
  final StudyChapterId chapterId;
  final bool hasNextChapter;
  final bool blink;

  @override
  ConsumerState<_NextChapterButton> createState() => _NextChapterButtonState();
}

class _NextChapterButtonState extends ConsumerState<_NextChapterButton> {
  bool isLoading = false;

  @override
  void didUpdateWidget(_NextChapterButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.chapterId != widget.chapterId) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator.adaptive())
        : BottomBarButton(
            onTap: widget.hasNextChapter
                ? () {
                    ref.read(studyControllerProvider(widget.options).notifier).nextChapter();
                    setState(() => isLoading = true);
                  }
                : null,
            icon: Icons.play_arrow,
            label: context.l10n.studyNextChapter,
            showLabel: true,
            blink: widget.blink,
          );
  }
}

class _ChapterButton extends ConsumerWidget {
  const _ChapterButton({required this.options});

  final StudyOptions options;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nbChapters = ref.watch(
      studyControllerProvider(options).select((s) => s.requireValue.study.chapters.length),
    );
    return BottomBarButton(
      onTap: () => showModalBottomSheet<void>(
        context: context,
        showDragHandle: true,
        isScrollControlled: true,
        isDismissible: true,
        constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.9),
        builder: (_) => DraggableScrollableSheet(
          initialChildSize: 0.6,
          snap: true,
          expand: false,
          builder: (context, scrollController) {
            return _StudyChaptersMenu(options: options, scrollController: scrollController);
          },
        ),
      ),
      label: context.l10n.studyNbChapters(nbChapters),
      showLabel: true,
      icon: Icons.menu_book,
    );
  }
}

class _StudyChaptersMenu extends ConsumerStatefulWidget {
  const _StudyChaptersMenu({required this.options, required this.scrollController});

  final StudyOptions options;
  final ScrollController scrollController;

  @override
  ConsumerState<_StudyChaptersMenu> createState() => _StudyChaptersMenuState();
}

class _StudyChaptersMenuState extends ConsumerState<_StudyChaptersMenu> {
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
          child: Text(
            context.l10n.studyNbChapters(state.study.chapters.length),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
      ],
    );
  }
}
