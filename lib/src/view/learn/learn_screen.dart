import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/learn/learn_level.dart';
import 'package:lichess_mobile/src/model/learn/learn_progress.dart';
import 'package:lichess_mobile/src/model/learn/learn_score.dart';
import 'package:lichess_mobile/src/model/learn/learn_stages.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/learn/learn_stage_screen.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform_context_menu_button.dart';
import 'package:lichess_mobile/src/widgets/yes_no_dialog.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

/// The list of learn stages, grouped by category.
class const LearnScreen({super.key}) extends ConsumerWidget {
  static Route<dynamic> buildRoute() {
    return buildScreenRoute(screen: const LearnScreen());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(learnProgressProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.learnLearnChess),
        actions: [
          if ((progress.value?.percent ?? 0) > 0)
            ContextMenuIconButton(
              icon: const Icon(Icons.more_horiz),
              semanticsLabel: context.l10n.menu,
              actions: [
                ContextMenuAction(
                  icon: Icons.restart_alt,
                  label: context.l10n.learnResetMyProgress,
                  onPressed: () => _confirmReset(context, ref),
                ),
              ],
            ),
        ],
      ),
      body: switch (progress) {
        AsyncData(:final value) => _Body(progress: value),
        AsyncError(:final error) => Center(child: Text('Could not load progress: $error')),
        _ => const Center(child: CircularProgressIndicator.adaptive()),
      },
    );
  }

  Future<void> _confirmReset(BuildContext context, WidgetRef ref) {
    return showAdaptiveDialog<void>(
      context: context,
      builder: (context) => YesNoDialog(
        title: Text(context.l10n.learnResetMyProgress),
        content: Text(context.l10n.learnYouWillLoseAllYourProgress),
        onNo: () => Navigator.of(context).pop(),
        onYes: () {
          ref.read(learnProgressProvider.notifier).reset();
          Navigator.of(context).pop();
        },
      ),
    );
  }
}

class const _Body({required final LearnProgress progress}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: Styles.horizontalBodyPadding.add(const EdgeInsets.only(top: 16.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(context.l10n.learnProgressX('${progress.percent}%')),
              const SizedBox(height: 8.0),
              LinearProgressIndicator(
                value: progress.percent / 100,
                borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                minHeight: 8.0,
              ),
            ],
          ),
        ),
        if (progress.resumeStage case final stage?)
          ListSection(
            hasLeading: true,
            children: [
              ListTile(
                leading: LearnStageIcon(stage: stage),
                title: Text(context.l10n.resumeLearning),
                subtitle: Text(stage.title(context.l10n)),
                trailing: Theme.of(context).platform == TargetPlatform.iOS
                    ? const CupertinoListTileChevron()
                    : null,
                onTap: () => Navigator.of(
                  context,
                  rootNavigator: true,
                ).push(LearnStageScreen.buildRoute(stage)),
              ),
            ],
          ),
        for (final category in learnCategories)
          ListSection(
            header: Text(category.name(context.l10n)),
            hasLeading: true,
            children: [
              for (final stage in category.stages) _StageTile(stage: stage, progress: progress),
            ],
          ),
      ],
    );
  }
}

class const _StageTile({required final LearnStage stage, required final LearnProgress progress})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final completed = progress.completedLevels(stage);
    final isComplete = progress.isStageComplete(stage);
    return ListTile(
      leading: LearnStageIcon(stage: stage),
      title: Text(stage.title(context.l10n)),
      subtitle: Text(stage.subtitle(context.l10n)),
      trailing: isComplete
          ? LearnStars(rank: learnStageRank(stage, progress.stageScores(stage)))
          : completed > 0
          ? Text('$completed / ${stage.levels.length}')
          : null,
      onTap: () =>
          Navigator.of(context, rootNavigator: true).push(LearnStageScreen.buildRoute(stage)),
    );
  }
}

/// The illustration of a learn stage, tinted with the ambient icon color.
class const LearnStageIcon({required final LearnStage stage, final double size = 32.0})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/learn/${stage.image}.webp',
      width: size,
      height: size,
      color: IconTheme.of(context).color,
      colorBlendMode: BlendMode.srcIn,
      filterQuality: FilterQuality.medium,
    );
  }
}

/// One to three stars, for a [LearnRank].
class const LearnStars({required final LearnRank rank, final double size = 18.0})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < 4 - rank; i++)
          Icon(Symbols.star, fill: 1, size: size, color: const Color(0xFFFFC107)),
      ],
    );
  }
}
