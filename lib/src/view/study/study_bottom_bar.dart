import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/chat/chat.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_preferences.dart';
import 'package:lichess_mobile/src/model/study/study_controller.dart';
import 'package:lichess_mobile/src/tab_navigation.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_actions.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_screen.dart';
import 'package:lichess_mobile/src/view/analysis/board_size_toggle_button.dart';
import 'package:lichess_mobile/src/view/chat/chat_screen.dart';
import 'package:lichess_mobile/src/view/engine/engine_button.dart';
import 'package:lichess_mobile/src/view/study/study_chapters_sheet.dart';
import 'package:lichess_mobile/src/view/study/study_settings.dart';
import 'package:lichess_mobile/src/view/user/user_or_profile_screen.dart';
import 'package:lichess_mobile/src/widgets/adaptive_action_sheet.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/user.dart';
import 'package:material_ui/material_ui.dart';

class const StudyBottomBar({
  required final StudyOptions options,
  required final bool smallBoard,
  required final VoidCallback onToggleSmallBoard,
}) extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gamebook = ref.watch(
      studyControllerProvider(options).select((s) => s.requireValue.gamebookActive),
    );

    final menuGroup = BottomBarGroup(
      children: [
        _StudyMenuButton(options: options),
        if (canToggleBoardSize(context))
          BoardSizeToggleButton(smallBoard: smallBoard, onTap: onToggleSmallBoard),
      ],
    );
    return gamebook
        ? _GamebookBottomBar(options: options, menuGroup: menuGroup)
        : _AnalysisBottomBar(options: options, menuGroup: menuGroup);
  }
}

class const _AnalysisBottomBar({
  required final StudyOptions options,

  /// The menu button, grouped with the board size button.
  required final Widget menuGroup,
}) extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(studyControllerProvider(options)).value;
    if (state == null) {
      return const BottomBar.empty(cupertinoGlass: true);
    }

    final onGoForward = state.canGoNext
        ? ref.read(studyControllerProvider(options).notifier).userNext
        : null;
    final onGoBack = state.canGoBack
        ? ref.read(studyControllerProvider(options).notifier).userPrevious
        : null;

    return BottomBar(
      cupertinoGlass: true,
      children: [
        menuGroup,
        if (state.isComputerAnalysisAllowed)
          EngineToggleButton(
            filters: (context: state.evaluationContext, path: state.currentPath),
            savedEval: state.currentNode.eval,
            onToggle: () => ref.read(studyControllerProvider(options).notifier).toggleEngine(),
            onGoDeeper: () =>
                ref.read(studyControllerProvider(options).notifier).requestEval(goDeeper: true),
          ),
        _NextChapterButton(
          options: options,
          chapterId: state.study.chapter.id,
          hasNextChapter: state.hasNextChapter,
          blink: state.isAtEndOfChapter && state.hasNextChapter,
        ),
        BottomBarGroup(
          children: [
            RepeatButton(
              onLongPress: state.canGoBack
                  ? () => ref
                        .read(studyControllerProvider(options).notifier)
                        .userPrevious(fastSeek: true)
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
                  ? () =>
                        ref.read(studyControllerProvider(options).notifier).userNext(fastSeek: true)
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
        ),
      ],
    );
  }
}

class const _GamebookBottomBar({
  required final StudyOptions options,

  /// The menu button, grouped with the board size button.
  required final Widget menuGroup,
}) extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(studyControllerProvider(options)).requireValue;

    return BottomBar(
      cupertinoGlass: true,
      children: [
        menuGroup,
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
                onTap: () => Navigator.of(context).pushHidingTabBar(
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

class const _NextChapterButton({
  required final StudyOptions options,
  required final StudyChapterId chapterId,
  required final bool hasNextChapter,
  required final bool blink,
}) extends ConsumerStatefulWidget {
  @override
  ConsumerState<_NextChapterButton> createState() => _NextChapterButtonState();
}

class _NextChapterButtonState() extends ConsumerState<_NextChapterButton> {
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

/// Menu holding the study actions that don't fit in the bottom bar.
class const _StudyMenuButton({required final StudyOptions options}) extends ConsumerWidget {
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
          onPressed: () => showStudySheet(
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

class const _StudyMembersSheet({
  required final StudyOptions options,
  required final ScrollController scrollController,
}) extends ConsumerWidget {
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
