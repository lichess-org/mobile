import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/study/create_study_bottom_sheet.dart';
import 'package:lichess_mobile/src/view/study/study_screen.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:material_ui/material_ui.dart';

class const CreateStudyFloatingActionButton({super.key}) extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authUser = ref.watch(authControllerProvider)?.user;
    if (authUser == null) {
      return const SizedBox.shrink();
    }
    return FloatingActionButton.extended(
      onPressed: () => showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        useRootNavigator: true,
        builder: (context) => CreateStudyBottomSheet(
          user: authUser,
          onStudyCreated: (context, studyId) => Navigator.of(
            context,
            rootNavigator: true,
          ).push(StudyScreen.buildRoute((id: studyId, initialChapter: null))),
        ),
      ),
      icon: const Icon(Symbols.school_rounded),
      label: Text(context.l10n.studyCreateStudy),
    );
  }
}
