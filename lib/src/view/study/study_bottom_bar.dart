import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/game_share_service.dart';
import 'package:lichess_mobile/src/model/study/study_controller.dart';
import 'package:lichess_mobile/src/model/study/study_repository.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/share.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_screen.dart';
import 'package:lichess_mobile/src/view/study/study_settings.dart';
import 'package:lichess_mobile/src/widgets/adaptive_action_sheet.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:share_plus/share_plus.dart';

class StudyBottomBar extends ConsumerWidget {
  const StudyBottomBar({required this.id});

  final StudyId id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gamebook = ref.watch(
      studyControllerProvider(id).select((s) => s.requireValue.gamebookActive),
    );

    return gamebook ? _GamebookBottomBar(id: id) : _AnalysisBottomBar(id: id);
  }
}

class _AnalysisBottomBar extends ConsumerWidget {
  const _AnalysisBottomBar({required this.id});

  final StudyId id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(studyControllerProvider(id)).valueOrNull;
    if (state == null) {
      return const BottomBar(children: []);
    }

    final onGoForward =
        state.canGoNext ? ref.read(studyControllerProvider(id).notifier).userNext : null;
    final onGoBack =
        state.canGoBack ? ref.read(studyControllerProvider(id).notifier).userPrevious : null;

    return BottomBar(
      transparentBackground: false,
      children: [
        BottomBarButton(
          label: context.l10n.menu,
          onTap: () {
            _showStudyMenu(id, context, ref);
          },
          icon: Icons.menu,
        ),
        _ChapterButton(state: state),
        _NextChapterButton(
          id: id,
          chapterId: state.study.chapter.id,
          hasNextChapter: state.hasNextChapter,
          blink: !state.isIntroductoryChapter && state.isAtEndOfChapter && state.hasNextChapter,
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
  const _GamebookBottomBar({required this.id});

  final StudyId id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(studyControllerProvider(id)).requireValue;

    return BottomBar(
      children: [
        BottomBarButton(
          label: context.l10n.menu,
          onTap: () {
            _showStudyMenu(id, context, ref);
          },
          icon: Icons.menu,
        ),
        _ChapterButton(state: state),
        ...switch (state.gamebookState) {
          GamebookState.findTheMove => [
            if (!state.currentNode.isRoot)
              BottomBarButton(
                onTap: ref.read(studyControllerProvider(id).notifier).reset,
                icon: Icons.skip_previous,
                label: 'Back',
                showLabel: true,
              ),
            BottomBarButton(
              icon: Icons.help,
              label: context.l10n.viewTheSolution,
              showLabel: true,
              onTap: ref.read(studyControllerProvider(id).notifier).showGamebookSolution,
            ),
          ],
          GamebookState.startLesson || GamebookState.correctMove => [
            BottomBarButton(
              onTap: ref.read(studyControllerProvider(id).notifier).userNext,
              icon: Icons.play_arrow,
              label: context.l10n.studyNext,
              showLabel: true,
              blink: state.gamebookComment != null && !state.isIntroductoryChapter,
            ),
          ],
          GamebookState.incorrectMove => [
            BottomBarButton(
              onTap: ref.read(studyControllerProvider(id).notifier).userPrevious,
              label: context.l10n.retry,
              showLabel: true,
              icon: Icons.refresh,
              blink: state.gamebookComment != null,
            ),
          ],
          GamebookState.lessonComplete => [
            if (!state.isIntroductoryChapter)
              BottomBarButton(
                onTap: ref.read(studyControllerProvider(id).notifier).reset,
                icon: Icons.refresh,
                label: context.l10n.studyPlayAgain,
                showLabel: true,
              ),
            _NextChapterButton(
              id: id,
              chapterId: state.study.chapter.id,
              hasNextChapter: state.hasNextChapter,
              blink: !state.isIntroductoryChapter && state.hasNextChapter,
            ),
            if (!state.isIntroductoryChapter)
              BottomBarButton(
                onTap:
                    () => Navigator.of(context, rootNavigator: true).push(
                      AnalysisScreen.buildRoute(
                        context,
                        AnalysisOptions(
                          orientation: state.pov,
                          standalone: (
                            pgn: state.pgn,
                            isComputerAnalysisAllowed: true,
                            variant: state.variant,
                          ),
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
    required this.id,
    required this.chapterId,
    required this.hasNextChapter,
    required this.blink,
  });

  final StudyId id;
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
          onTap:
              widget.hasNextChapter
                  ? () {
                    ref.read(studyControllerProvider(widget.id).notifier).nextChapter();
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
  const _ChapterButton({required this.state});

  final StudyState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BottomBarButton(
      onTap:
          () => showAdaptiveBottomSheet<void>(
            context: context,
            showDragHandle: true,
            isScrollControlled: true,
            isDismissible: true,
            builder:
                (_) => DraggableScrollableSheet(
                  initialChildSize: 0.6,
                  maxChildSize: 0.6,
                  snap: true,
                  expand: false,
                  builder: (context, scrollController) {
                    return _StudyChaptersMenu(
                      id: state.study.id,
                      scrollController: scrollController,
                    );
                  },
                ),
          ),
      label: context.l10n.studyNbChapters(state.study.chapters.length),
      showLabel: true,
      icon: Icons.menu_book,
    );
  }
}

class _StudyChaptersMenu extends ConsumerStatefulWidget {
  const _StudyChaptersMenu({required this.id, required this.scrollController});

  final StudyId id;
  final ScrollController scrollController;

  @override
  ConsumerState<_StudyChaptersMenu> createState() => _StudyChaptersMenuState();
}

class _StudyChaptersMenuState extends ConsumerState<_StudyChaptersMenu> {
  final currentChapterKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(studyControllerProvider(widget.id)).requireValue;

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
              ref.read(studyControllerProvider(widget.id).notifier).goToChapter(chapter.id);
              Navigator.of(context).pop();
            },
            selected: chapter.id == state.currentChapter.id,
          ),
      ],
    );
  }
}

Future<void> _showStudyMenu(StudyId id, BuildContext context, WidgetRef ref) {
  final session = ref.read(authSessionProvider);
  final state = ref.read(studyControllerProvider(id)).requireValue;
  return showAdaptiveActionSheet(
    context: context,
    actions: [
      BottomSheetAction(
        leading: const Icon(Icons.settings),
        makeLabel: (context) => Text(context.l10n.settingsSettings),
        onPressed: () {
          Navigator.of(context).push(StudySettingsScreen.buildRoute(context, id));
        },
      ),
      if (session != null)
        BottomSheetAction(
          leading: Icon(state.study.liked ? Icons.favorite : Icons.favorite_border),
          makeLabel:
              (context) =>
                  Text(state.study.liked ? context.l10n.studyUnlike : context.l10n.studyLike),
          onPressed: () {
            ref.read(studyControllerProvider(id).notifier).toggleLike();
          },
        ),
      BottomSheetAction(
        leading: const PlatformShareIcon(),
        makeLabel: (context) => Text(context.l10n.studyShareAndExport),
        onPressed: () {
          showAdaptiveActionSheet<void>(
            context: context,
            actions: [
              BottomSheetAction(
                makeLabel: (context) => Text(context.l10n.studyStudyUrl),
                onPressed: () {
                  launchShareDialog(
                    context,
                    ShareParams(uri: lichessUri('/study/${state.study.id}')),
                  );
                },
              ),
              BottomSheetAction(
                makeLabel: (context) => Text(context.l10n.studyCurrentChapterUrl),
                onPressed: () {
                  launchShareDialog(
                    context,
                    ShareParams(
                      uri: lichessUri('/study/${state.study.id}/${state.study.chapter.id}'),
                    ),
                  );
                },
              ),
              if (!state.gamebookActive) ...[
                BottomSheetAction(
                  makeLabel: (context) => Text(context.l10n.studyStudyPgn),
                  onPressed: () async {
                    try {
                      final pgn = await ref
                          .read(studyRepositoryProvider)
                          .getStudyPgn(state.study.id);
                      if (context.mounted) {
                        launchShareDialog(context, ShareParams(text: pgn));
                      }
                    } catch (e) {
                      if (context.mounted) {
                        showSnackBar(context, 'Failed to get PGN', type: SnackBarType.error);
                      }
                    }
                  },
                ),
                BottomSheetAction(
                  makeLabel: (context) => Text(context.l10n.studyChapterPgn),
                  onPressed: () {
                    launchShareDialog(context, ShareParams(text: state.pgn));
                  },
                ),
                if (state.currentPosition != null)
                  BottomSheetAction(
                    makeLabel: (context) => Text(context.l10n.screenshotCurrentPosition),
                    onPressed: () async {
                      try {
                        final image = await ref
                            .read(gameShareServiceProvider)
                            .screenshotPosition(
                              state.pov,
                              state.currentPosition!.fen,
                              state.lastMove,
                            );
                        if (context.mounted) {
                          launchShareDialog(
                            context,
                            ShareParams(
                              files: [image],
                              subject: context.l10n.puzzleFromGameLink(
                                lichessUri('/study/${state.study.id}').toString(),
                              ),
                            ),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          showSnackBar(context, 'Failed to get GIF', type: SnackBarType.error);
                        }
                      }
                    },
                  ),
                BottomSheetAction(
                  makeLabel: (context) => const Text('GIF'),
                  onPressed: () async {
                    try {
                      final gif = await ref
                          .read(gameShareServiceProvider)
                          .chapterGif(state.study.id, state.study.chapter.id);
                      if (context.mounted) {
                        launchShareDialog(
                          context,
                          ShareParams(
                            files: [gif],
                            fileNameOverrides: ['${state.study.chapter.id}.gif'],
                            subject: context.l10n.studyChapterX(
                              state.study.currentChapterMeta.name,
                            ),
                          ),
                        );
                      }
                    } catch (e) {
                      debugPrint(e.toString());
                      if (context.mounted) {
                        showSnackBar(context, 'Failed to get GIF', type: SnackBarType.error);
                      }
                    }
                  },
                ),
              ],
            ],
          );
        },
      ),
    ],
  );
}
