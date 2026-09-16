import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/practice/practice_progress.dart';
import 'package:lichess_mobile/src/model/practice/practice_repository.dart';
import 'package:lichess_mobile/src/model/practice/practice_structure.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/practice/practice_chapter_screen.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform_context_menu_button.dart';
import 'package:lichess_mobile/src/widgets/yes_no_dialog.dart';
import 'package:material_ui/material_ui.dart';

/// The practice sections and their studies, with the progress made in each.
class const PracticeScreen({super.key}) extends ConsumerWidget {
  static Route<dynamic> buildRoute() {
    return buildScreenRoute(screen: const PracticeScreen());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final structure = ref.watch(practiceStructureProvider);
    final progress = ref.watch(practiceProgressProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.practice),
        actions: [
          if (progress case AsyncData(value: final progress) when !progress.isEmpty)
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
      body: switch ((structure, progress)) {
        (AsyncData(value: final structure), AsyncData(value: final progress)) => _Body(
          structure: structure,
          progress: progress,
        ),
        (AsyncError(:final error), _) ||
        (_, AsyncError(:final error)) => Center(child: Text('Could not load practice: $error')),
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
          ref.read(practiceProgressProvider.notifier).reset();
          Navigator.of(context).pop();
        },
      ),
    );
  }
}

class const _Body({
  required final PracticeStructure structure,
  required final PracticeProgress progress,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final percent = progress.percent(structure);
    return ListView(
      children: [
        Padding(
          padding: Styles.horizontalBodyPadding.add(const EdgeInsets.only(top: 16.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(context.l10n.learnProgressX('$percent%')),
              const SizedBox(height: 8.0),
              LinearProgressIndicator(
                value: percent / 100,
                borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                minHeight: 8.0,
              ),
            ],
          ),
        ),
        for (final section in structure.sections)
          ListSection(
            header: Text(section.name),
            children: [
              for (final study in section.studies) _StudyTile(study: study, progress: progress),
            ],
          ),
      ],
    );
  }
}

class const _StudyTile({
  required final PracticeStudy study,
  required final PracticeProgress progress,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final done = progress.countDone(study);
    return ListTile(
      title: Text(study.name),
      trailing: progress.isStudyComplete(study)
          ? const Icon(Icons.check_circle, color: LichessColors.good)
          : Text('$done / ${study.chapters.length}'),
      // Straight to the chapter to play: the others are a tap away in the chapter screen.
      onTap: () =>
          Navigator.of(context)
              .push(PracticeChapterScreen.buildRoute(progress.firstOngoingIn(study))),
    );
  }
}
