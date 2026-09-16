import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/practice/practice_progress.dart';
import 'package:lichess_mobile/src/model/practice/practice_structure.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/practice/practice_chapter_screen.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:material_ui/material_ui.dart';

/// The chapters of a practice study.
class const PracticeStudyScreen({required final PracticeStudy study, super.key})
    extends ConsumerWidget {
  static Route<dynamic> buildRoute(PracticeStudy study) {
    return buildScreenRoute(screen: PracticeStudyScreen(study: study));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(practiceProgressProvider).value ?? PracticeProgress.empty;

    return Scaffold(
      appBar: AppBar(title: Text(study.name)),
      body: ListView(
        children: [
          ListSection(
            hasLeading: true,
            children: [
              for (final chapter in study.chapters)
                ListTile(
                  leading: Icon(switch (chapter) {
                    PracticeEngineChapter() => Icons.memory,
                    PracticeGamebookChapter() => Icons.menu_book,
                    PracticeLessonChapter() => Icons.play_lesson,
                  }),
                  title: Text(chapter.name),
                  subtitle: Text(practiceChapterKindLabel(context, chapter)),
                  trailing: progress.isDone(chapter.id)
                      ? const Icon(Icons.check_circle, color: LichessColors.good)
                      : null,
                  onTap: () =>
                      Navigator.of(context).push(PracticeChapterScreen.buildRoute(chapter)),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
