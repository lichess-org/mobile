import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/study/study_controller.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_screen.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar_button.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';

class StudyBottomBar extends ConsumerWidget {
  const StudyBottomBar({
    required this.id,
  });

  final StudyId id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gamebook = ref.watch(
      studyControllerProvider(id).select(
        (s) => s.requireValue.gamebookActive,
      ),
    );

    return gamebook ? _GamebookBottomBar(id: id) : _AnalysisBottomBar(id: id);
  }
}

class _AnalysisBottomBar extends ConsumerWidget {
  const _AnalysisBottomBar({
    required this.id,
  });

  final StudyId id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(studyControllerProvider(id)).valueOrNull;
    if (state == null) {
      return const BottomBar(children: []);
    }

    final onGoForward = state.canGoNext
        ? ref.read(studyControllerProvider(id).notifier).userNext
        : null;
    final onGoBack = state.canGoBack
        ? ref.read(studyControllerProvider(id).notifier).userPrevious
        : null;

    return BottomBar(
      children: [
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
        BottomBarButton(
          onTap: state.hasNextChapter
              ? ref.read(studyControllerProvider(id).notifier).nextChapter
              : null,
          icon: Icons.play_arrow,
          label: context.l10n.studyNextChapter,
          showLabel: true,
          blink: !state.isIntroductoryChapter &&
              state.isAtEndOfChapter &&
              state.hasNextChapter,
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
  const _GamebookBottomBar({
    required this.id,
  });

  final StudyId id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(studyControllerProvider(id)).requireValue;

    return BottomBar(
      children: [
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
                onTap: ref
                    .read(studyControllerProvider(id).notifier)
                    .showGamebookSolution,
              ),
            ],
          GamebookState.startLesson || GamebookState.correctMove => [
              BottomBarButton(
                onTap: ref.read(studyControllerProvider(id).notifier).userNext,
                icon: Icons.play_arrow,
                label: context.l10n.studyNext,
                showLabel: true,
                blink: state.gamebookComment != null &&
                    !state.isIntroductoryChapter,
              ),
            ],
          GamebookState.incorrectMove => [
              BottomBarButton(
                onTap:
                    ref.read(studyControllerProvider(id).notifier).userPrevious,
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
              BottomBarButton(
                onTap: state.hasNextChapter
                    ? ref.read(studyControllerProvider(id).notifier).nextChapter
                    : null,
                icon: Icons.play_arrow,
                label: context.l10n.studyNextChapter,
                showLabel: true,
                blink: !state.isIntroductoryChapter && state.hasNextChapter,
              ),
              if (!state.isIntroductoryChapter)
                BottomBarButton(
                  onTap: () => pushPlatformRoute(
                    context,
                    rootNavigator: true,
                    builder: (context) => AnalysisScreen(
                      options: AnalysisOptions(
                        standalone: (
                          pgn: state.pgn,
                          isComputerAnalysisAllowed: true,
                          variant: state.variant,
                          orientation: state.pov,
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
