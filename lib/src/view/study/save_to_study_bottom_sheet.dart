import 'package:dartchess/dartchess.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/study/study.dart';
import 'package:lichess_mobile/src/model/study/study_controller.dart';
import 'package:lichess_mobile/src/model/study/study_filter.dart';
import 'package:lichess_mobile/src/model/study/study_list_paginator.dart';
import 'package:lichess_mobile/src/model/study/study_repository.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform_search_bar.dart';
import 'package:material_ui/material_ui.dart';

/// A bottom sheet to save a PGN as a new chapter of a study: either one of the user's studies,
/// or a brand new one.
///
/// This is the mobile counterpart of the "Study" button of the website's analysis board.
///
/// The sheet pops with the [StudyOptions] locating the created chapter, or with `null` when it
/// is dismissed.
class SaveToStudyBottomSheet extends ConsumerStatefulWidget {
  const SaveToStudyBottomSheet({required this.pgn, required this.orientation});

  /// The PGN to save as a chapter.
  final String pgn;

  /// The board orientation of the chapter.
  final Side orientation;

  @override
  ConsumerState<SaveToStudyBottomSheet> createState() => _SaveToStudyBottomSheetState();
}

class _SaveToStudyBottomSheetState extends ConsumerState<SaveToStudyBottomSheet> {
  final _searchController = TextEditingController();

  /// The submitted search term, if any.
  String? _search;

  /// Whether a chapter creation request is in flight.
  bool _isSubmitting = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetScrollableContainer(
      // The sheet does no keyboard avoidance of its own, so without this the on-screen keyboard
      // covers the studies while a search term is being typed.
      padding: Styles.verticalBodyPadding.add(
        EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Text(context.l10n.toStudy, style: TextTheme.of(context).titleLarge),
        ),
        if (_isSubmitting) const LinearProgressIndicator(),
        Padding(
          padding: Styles.bodySectionPadding,
          child: PlatformSearchBar(
            controller: _searchController,
            hintText: context.l10n.searchSearch,
            onSubmitted: (term) => setState(() {
              _search = term.trim().isEmpty ? null : term.trim();
            }),
            onClear: () => setState(() {
              _search = null;
              _searchController.clear();
            }),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.add),
          title: Text(context.l10n.studyCreateStudy),
          onTap: _isSubmitting ? null : () => _createChapter(null),
        ),
        if (_search case final search?)
          _StudyPicker(
            params: (category: StudyCategory.all, order: StudyListOrder.updated, search: search),
            onSelected: _isSubmitting ? null : _createChapter,
          )
        else
          for (final category in const [StudyCategory.mine, StudyCategory.member])
            _StudyPicker(
              params: (category: category, order: StudyListOrder.updated, search: null),
              header: category.l10n(context.l10n),
              onSelected: _isSubmitting ? null : _createChapter,
            ),
      ],
    );
  }

  /// Creates the chapter in the study with the given [studyId], or in a new study if it is null.
  Future<void> _createChapter(StudyId? studyId) async {
    setState(() => _isSubmitting = true);

    final repository = ref.read(studyRepositoryProvider);
    try {
      final targetStudyId = studyId ?? await repository.createStudy(name: _newStudyName());
      final chapterIds = await repository.createChapter(
        targetStudyId,
        CreateStudyChapterPayload(
          pgn: widget.pgn,
          orientation: widget.orientation,
          initial: studyId == null,
        ),
      );

      if (!mounted) return;
      Navigator.of(context).pop((id: targetStudyId, initialChapter: chapterIds.firstOrNull));
    } catch (e) {
      if (!mounted) return;
      // Keep the sheet open so the user can retry.
      setState(() => _isSubmitting = false);
      showSnackBar(context, 'Could not create chapter: $e', type: SnackBarType.error);
    }
  }

  /// The name the website gives to a study created from a game.
  String _newStudyName() {
    final me = ref.read(authControllerProvider)?.user;
    return me != null ? "${me.name}'s Study" : context.l10n.toStudy;
  }
}

/// A paginated list of studies to pick one from, restricted to the ones the user can add a
/// chapter to.
class _StudyPicker extends ConsumerWidget {
  const _StudyPicker({required this.params, this.header, required this.onSelected});

  final StudyListNotifierParams params;

  /// The title of the list. If null, the list is displayed without a title.
  final String? header;

  /// Called with the id of the picked study. If null, the studies cannot be picked.
  final void Function(StudyId studyId)? onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studyList = ref.watch(studyListPaginatorProvider(params));
    final page = studyList.value;
    if (page == null) {
      return studyList.hasError
          ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Text('Could not load studies.'),
            )
          : const CenterLoadingIndicator();
    }

    // Only the members with the write role can add a chapter to a study, and the studies of the
    // search or of the "Studies I contribute to" list are not all in that case.
    final myId = ref.watch(authControllerProvider)?.user.id;
    final studies = page.studies.where(
      (study) => study.members.any((member) => member.user.id == myId && member.role == 'w'),
    );

    if (studies.isEmpty && page.nextPage == null) {
      return header != null
          ? const SizedBox.shrink()
          : const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Text('No study found.'), // TODO l10n
            );
    }

    return ListSection(
      header: header != null ? Text(header!) : null,
      children: [
        for (final study in studies)
          ListTile(
            title: Text(study.name, maxLines: 2, overflow: TextOverflow.ellipsis),
            subtitle: Text(context.l10n.studyNbChapters(study.chapters.length)),
            onTap: onSelected != null ? () => onSelected!(study.id) : null,
          ),
        if (page.nextPage != null)
          ListTile(
            leading: const Icon(Icons.expand_more),
            title: Text(context.l10n.more),
            onTap: () => ref.read(studyListPaginatorProvider(params).notifier).next(),
          ),
      ],
    );
  }
}
