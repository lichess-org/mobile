import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/study/study_filter.dart';
import 'package:lichess_mobile/src/model/study/study_preferences.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/tab_navigation.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/study/create_study_bottom_sheet.dart';
import 'package:lichess_mobile/src/view/study/study_list.dart';
import 'package:lichess_mobile/src/view/study/study_screen.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/bottom_search_bar.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/platform_context_menu_button.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:material_ui/material_ui.dart';

/// A screen that displays a paginated list of studies
class const StudyListScreen({final StudyCategory? initialCategory, super.key})
    extends ConsumerStatefulWidget {
  static Route<dynamic> buildRoute({StudyCategory? initialCategory}) {
    return buildScreenRoute(screen: StudyListScreen(initialCategory: initialCategory));
  }

  @override
  ConsumerState<StudyListScreen> createState() => _StudyListScreenState();
}

class _StudyListScreenState() extends ConsumerState<StudyListScreen> {
  late StudyCategory category;
  late StudyListOrder order;

  final currentCategoryKey = GlobalKey(debugLabel: 'studyCurrentCategoryKey');

  @override
  void initState() {
    super.initState();
    category = widget.initialCategory ?? StudyCategory.all;
    order = ref.read(studyPreferencesProvider).listOrder;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (currentCategoryKey.currentContext != null) {
        Scrollable.ensureVisible(currentCategoryKey.currentContext!, alignment: 0.5);
      }
    });
  }

  void _onStudyOrderChange(StudyListOrder newOrder) {
    setState(() {
      order = newOrder;
    });
    ref.read(studyPreferencesProvider.notifier).setListOrder(newOrder);
  }

  void _showCreateStudySheet(LightUser authUser) {
    showAdaptiveBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (context) => CreateStudyBottomSheet(
        user: authUser,
        onStudyCreated: (context, studyId) =>
            Navigator.of(context)
                .pushHidingTabBar(StudyScreen.buildRoute((id: studyId, initialChapter: null))),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authUser = ref.watch(authControllerProvider)?.user;
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(authUser != null ? context.l10n.studyMenu : context.l10n.studyAllStudies),
        largeTitle: true,
        actions: [
          ContextMenuIconButton(
            consumeOutsideTap: true,
            icon: const Icon(Icons.sort_outlined),
            semanticsLabel: 'Sort studies',
            actions: [
              ContextMenuAction(
                label: context.l10n.studyHot,
                selected: order == StudyListOrder.hot,
                onPressed: () => _onStudyOrderChange(StudyListOrder.hot),
              ),
              ContextMenuAction(
                label: context.l10n.studyDateAddedNewest,
                selected: order == StudyListOrder.newest,
                onPressed: () => _onStudyOrderChange(StudyListOrder.newest),
              ),
              ContextMenuAction(
                label: context.l10n.studyRecentlyUpdated,
                selected: order == StudyListOrder.updated,
                onPressed: () => _onStudyOrderChange(StudyListOrder.updated),
              ),
              ContextMenuAction(
                label: context.l10n.studyMostPopular,
                selected: order == StudyListOrder.popular,
                onPressed: () => _onStudyOrderChange(StudyListOrder.popular),
              ),
            ],
          ),
        ],
      ),
      body: StudyList(
        category: category,
        order: order,
        onStudyTap: (context, study) =>
            Navigator.of(context)
                .pushHidingTabBar(StudyScreen.buildRoute((id: study.id, initialChapter: null))),
        header: authUser != null
            ? StudyCategoryChips(
                categories: StudyCategory.values.lock,
                currentCategory: category,
                currentCategoryKey: currentCategoryKey,
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
              icon: const Icon(Symbols.school_rounded),
              label: context.l10n.studyCreateStudy,
            )
          : null,
    );
  }
}
