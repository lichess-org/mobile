import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/chat/chat.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_preferences.dart';
import 'package:lichess_mobile/src/model/study/study.dart';
import 'package:lichess_mobile/src/model/study/study_controller.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_actions.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_screen.dart';
import 'package:lichess_mobile/src/view/chat/chat_screen.dart';
import 'package:lichess_mobile/src/view/engine/engine_button.dart';
import 'package:lichess_mobile/src/view/study/create_study_chapter_bottom_sheet.dart';
import 'package:lichess_mobile/src/view/study/study_settings.dart';
import 'package:lichess_mobile/src/view/user/user_or_profile_screen.dart';
import 'package:lichess_mobile/src/widgets/adaptive_action_sheet.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/adaptive_choice_picker.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/platform_alert_dialog.dart';
import 'package:lichess_mobile/src/widgets/user.dart';
import 'package:material_ui/material_ui.dart';

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
        _StudyMenuButton(options: options),
        _ChapterButton(options: options),
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
        _NextChapterButton(
          options: options,
          chapterId: state.study.chapter.id,
          hasNextChapter: state.hasNextChapter,
          blink: state.isAtEndOfChapter && state.hasNextChapter,
        ),
        RepeatButton(
          onLongPress: state.canGoBack
              ? () =>
                    ref.read(studyControllerProvider(options).notifier).userPrevious(fastSeek: true)
              : null,
          child: BottomBarButton(
            key: const ValueKey('goto-previous'),
            onTap: onGoBack,
            label: context.l10n.studyBack,
            icon: CupertinoIcons.chevron_back,
            showTooltip: false,
          ),
        ),
        RepeatButton(
          onLongPress: state.canGoNext
              ? () => ref.read(studyControllerProvider(options).notifier).userNext(fastSeek: true)
              : null,
          child: BottomBarButton(
            key: const ValueKey('goto-next'),
            icon: CupertinoIcons.chevron_forward,
            onTap: onGoForward,
            label: context.l10n.studyNext,
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
        _StudyMenuButton(options: options),
        _ChapterButton(options: options),
        ...switch (state.gamebookState) {
          GamebookState.findTheMove => [
            BottomBarButton(
              onTap: !state.currentNode.isRoot
                  ? ref.read(studyControllerProvider(options).notifier).reset
                  : null,
              icon: Icons.skip_previous,
              label: context.l10n.studyBack,
            ),
            BottomBarButton(
              icon: Icons.flag_outlined,
              label: context.l10n.viewTheSolution,
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
            ),
            BottomBarButton(
              onTap: ref.read(studyControllerProvider(options).notifier).userNext,
              icon: Icons.play_arrow,
              label: context.l10n.studyNext,
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
            ),
            BottomBarButton(
              onTap: ref.read(studyControllerProvider(options).notifier).userPrevious,
              label: context.l10n.retry,
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
            blink: widget.blink,
          );
  }
}

/// Opens a bottom sheet, filling most of the screen, to browse a study.
Future<void> _showStudySheet(
  BuildContext context, {
  required Widget Function(BuildContext, ScrollController) builder,
}) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    isDismissible: true,
    constraints: BoxConstraints(maxHeight: MediaQuery.heightOf(context) * 0.9),
    builder: (_) => DraggableScrollableSheet(
      initialChildSize: 0.6,
      snap: true,
      expand: false,
      builder: builder,
    ),
  );
}

/// Menu holding the study actions that don't fit in the bottom bar.
class _StudyMenuButton extends ConsumerWidget {
  const _StudyMenuButton({required this.options});

  final StudyOptions options;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BottomBarButton(
      label: context.l10n.menu,
      icon: Icons.menu,
      onTap: () => _showStudyMenu(context, ref),
    );
  }

  Future<void> _showStudyMenu(BuildContext context, WidgetRef ref) {
    final state = ref.read(studyControllerProvider(options)).requireValue;
    final evalPrefs = ref.read(engineEvaluationPreferencesProvider);
    final isKidMode = ref.read(kidModeProvider).value == true;

    final chatOptions = state.study.chat != null
        ? StudyChatOptions(options: options, writeable: state.study.chat!.writeable)
        : null;

    return showAdaptiveActionSheet(
      context: context,
      actions: [
        BottomSheetAction(
          makeLabel: (context) => Text(context.l10n.settingsSettings),
          onPressed: () => Navigator.of(context).push(StudySettingsScreen.buildRoute(options)),
        ),
        BottomSheetAction(
          makeLabel: (context) => Text(context.l10n.studyMembers),
          onPressed: () => _showStudySheet(
            context,
            builder: (context, scrollController) =>
                _StudyMembersSheet(options: options, scrollController: scrollController),
          ),
        ),
        BottomSheetAction(
          makeLabel: (context) => Text(context.l10n.flipBoard),
          onPressed: () => ref.read(studyControllerProvider(options).notifier).toggleBoard(),
        ),
        if (chatOptions != null && !isKidMode)
          BottomSheetAction(
            makeLabel: (context) => Text(context.l10n.chatRoom),
            onPressed: () =>
                Navigator.of(context).push(ChatScreen.buildRoute(options: chatOptions)),
          ),
        if (state.isEngineAvailable(evalPrefs) && state.canShowThreat)
          BottomSheetAction(
            makeLabel: (context) => Text(
              state.engineInThreatMode
                  ? context.l10n.mobileStopShowingThreat
                  : context.l10n.showThreat,
            ),
            onPressed: () =>
                ref.read(studyControllerProvider(options).notifier).toggleEngineThreatMode(),
          ),
        if (state.isComputerAnalysisAllowed && state.currentPosition != null) ...[
          BottomSheetAction(
            makeLabel: (context) => Text(context.l10n.boardEditor),
            onPressed: () =>
                openBoardEditor(context, state.variant, state.currentPosition!.fen, state.pov),
          ),
          BottomSheetAction(
            makeLabel: (context) => Text(context.l10n.continueFromHere),
            onPressed: () =>
                showContinueFromHereMenu(context, state.variant, state.currentPosition!.fen),
          ),
        ],
      ],
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
      onTap: () => _showStudySheet(
        context,
        builder: (context, scrollController) =>
            _StudyChaptersMenu(options: options, scrollController: scrollController),
      ),
      label: context.l10n.studyNbChapters(nbChapters),
      icon: Icons.menu_book,
    );
  }
}

class _StudyMembersSheet extends ConsumerWidget {
  const _StudyMembersSheet({required this.options, required this.scrollController});

  final StudyOptions options;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(studyControllerProvider(options)).requireValue;

    return BottomSheetScrollableContainer(
      scrollController: scrollController,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            context.l10n.studyNbMembers(state.study.members.length),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 16),
        for (final member in state.study.members.values)
          ListTile(
            title: UserFullNameWidget(user: member.user),
            onTap: () {
              Navigator.of(context).push(UserOrProfileScreen.buildRoute(member.user));
            },
          ),
      ],
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

    final canEdit = state.canIContribute;

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

                showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  useRootNavigator: true,
                  builder: (context) => CreateStudyChapterBottomSheet(
                    params: CreateChapterOfExistingStudy(state.study.id),
                    chapterNumber: state.study.chapters.length + 1,
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
          makeLabel: (_) => const Text('Rename'),
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
                      if (context.mounted) {
                        showSnackBar(context, e.toString(), type: SnackBarType.error);
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
          title: const Text('Rename'),
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
