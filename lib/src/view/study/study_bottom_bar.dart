import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/study/study_controller.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
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
            label: 'Previous',
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
          label: 'Next chapter',
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
            label: context.l10n.next,
            showLabel: true,
            showTooltip: false,
          ),
        ),
      ],
    );
  }
}
