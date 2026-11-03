import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/study/study_filter.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/tab_navigation.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/study/create_study_bottom_sheet.dart';
import 'package:lichess_mobile/src/view/study/create_study_chapter_bottom_sheet.dart';
import 'package:lichess_mobile/src/view/study/study_list.dart';
import 'package:lichess_mobile/src/view/study/study_screen.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/bottom_search_bar.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:material_ui/material_ui.dart';

class const AddPgnToStudyScreen({required final String pgn, final Side? orientation})
    extends ConsumerStatefulWidget {
  static Route<dynamic> buildRoute({required String pgn, Side? orientation}) {
    return buildScreenRoute(
      screen: AddPgnToStudyScreen(pgn: pgn, orientation: orientation),
    );
  }

  @override
  ConsumerState<AddPgnToStudyScreen> createState() => _AddPgnToStudyScreenState();
}

class _AddPgnToStudyScreenState() extends ConsumerState<AddPgnToStudyScreen> {
  StudyCategory category = StudyCategory.private;

  void _showCreateStudySheet(LightUser authUser) {
    showAdaptiveBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (context) => CreateStudyBottomSheet(
        user: authUser,
        pgn: widget.pgn,
        orientation: widget.orientation,
        onStudyCreated: (context, studyId) {
          Navigator.of(context).pop();
          Navigator.of(context)
              .pushHidingTabBar(StudyScreen.buildRoute((id: studyId, initialChapter: null)));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authUser = ref.watch(authControllerProvider)?.user;
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    return PlatformScaffold(
      appBar: PlatformAppBar(title: Text(context.l10n.mobileSelectAStudy)),
      body: StudyList(
        category: category,
        order: StudyListOrder.updated,
        onStudyTap: (context, study) {
          showAdaptiveBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            useRootNavigator: true,
            builder: (context) => CreateStudyChapterBottomSheet(
              params: CreateChapterOfExistingStudy(
                study.id,
                pgn: widget.pgn,
                orientation: widget.orientation,
              ),
              initialChapterName: context.l10n.studyNewChapter,
              onChaptersCreated: (studyId, chapters) {
                // The server always answers with the created chapters, but the response
                // mapper tolerates an empty list, and this runs after the sheet was popped:
                // an exception here would surface as an unhandled error.
                final chapterId = chapters.firstOrNull;
                if (chapterId != null) {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushHidingTabBar(
                    StudyScreen.buildRoute((id: studyId, initialChapter: chapterId)),
                  );
                }
              },
            ),
          );
        },
        header: authUser != null
            ? StudyCategoryChips(
                categories: [
                  StudyCategory.private,
                  StudyCategory.public,
                  StudyCategory.mine,
                  StudyCategory.member,
                ].lock,
                currentCategory: category,
                onCategorySelected: (cat) {
                  setState(() {
                    category = cat;
                  });
                },
              )
            : null,
        searchAction: authUser != null
            ? BottomSearchBarButton(
                onPressed: () => _showCreateStudySheet(authUser),
                icon: const Icon(Icons.add),
                semanticsLabel: context.l10n.studyCreateStudy,
              )
            : null,
      ),
      // On iOS, the action is next to the search field at the bottom of the screen.
      floatingActionButton: authUser != null && !isIOS
          ? PlatformFloatingActionButton(
              onPressed: () => _showCreateStudySheet(authUser),
              label: context.l10n.studyCreateStudy,
            )
          : null,
    );
  }
}
