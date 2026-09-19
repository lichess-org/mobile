import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/study/study.dart';
import 'package:lichess_mobile/src/model/study/study_filter.dart';
import 'package:lichess_mobile/src/model/study/study_list_paginator.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/lichess_assets.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/network_image.dart';
import 'package:lichess_mobile/src/widgets/platform_search_bar.dart';
import 'package:lichess_mobile/src/widgets/user.dart';
import 'package:material_ui/material_ui.dart';

class const StudyList({
  required final StudyCategory category,
  required final StudyListOrder order,
  required final void Function(BuildContext, StudyPageItem) onStudyTap,
  super.key,
}) extends ConsumerStatefulWidget {
  @override
  ConsumerState<StudyList> createState() => _StudyListState();
}

class _StudyListState() extends ConsumerState<StudyList> {
  String? search;

  final _searchController = TextEditingController();

  final _scrollController = ScrollController(keepScrollOffset: true);

  bool requestedNextPage = false;

  AsyncNotifierProvider<StudyListPaginatorNotifier, ({int? nextPage, IList<StudyPageItem> studies})>
  get paginatorProvider =>
      studyListPaginatorProvider((category: widget.category, order: widget.order, search: search));

  void _onCategoryChanged(StudyCategory newCategory) {
    search = null;
    _searchController.clear();

    final authUser = ref.read(authControllerProvider)?.user;
    if (authUser != null) {
      if ([StudyCategory.mine, StudyCategory.public, StudyCategory.private].contains(newCategory)) {
        _searchController.value = TextEditingValue(text: 'owner:${authUser.id} ');
      } else if (newCategory == StudyCategory.member) {
        _searchController.value = TextEditingValue(text: 'member:${authUser.id} ');
      }
    }
  }

  @override
  void didUpdateWidget(covariant StudyList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.category != widget.category) {
      _onCategoryChanged(widget.category);
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _onCategoryChanged(widget.category);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (!requestedNextPage &&
        _scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 300) {
      final studiesList = ref.read(paginatorProvider);

      if (!studiesList.isLoading) {
        setState(() {
          requestedNextPage = true;
        });

        ref.read(paginatorProvider.notifier).next();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(paginatorProvider, (prev, next) {
      if (prev?.value?.nextPage != next.value?.nextPage) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              requestedNextPage = false;
            });
          }
        });
      }
    });

    final studiesAsync = ref.watch(paginatorProvider);

    final searchBar = Padding(
      padding: Styles.bodySectionPadding,
      child: PlatformSearchBar(
        controller: _searchController,
        onClear: () => setState(() {
          search = null;
          _searchController.clear();
        }),
        hintText: search ?? context.l10n.searchSearch,
        onSubmitted: (term) {
          setState(() {
            search = term;
          });
        },
      ),
    );

    return switch (studiesAsync) {
      AsyncData(value: final studies) => ListView.separated(
        shrinkWrap: true,
        itemCount: studies.studies.length + 1,
        controller: _scrollController,
        separatorBuilder: (context, index) => index == 0
            ? const SizedBox.shrink()
            : Theme.of(context).platform == TargetPlatform.iOS
            ? const PlatformDivider(height: 1, cupertinoHasLeading: true)
            : const PlatformDivider(height: 1, color: Colors.transparent),
        itemBuilder: (context, index) => index == 0
            ? searchBar
            : StudyListItem(
                study: studies.studies[index - 1],
                flairSize: 30.0,
                onTap: widget.onStudyTap,
              ),
      ),
      AsyncError() => FullScreenRetryRequest(onRetry: () => ref.invalidate(paginatorProvider)),
      _ => Column(
        children: [
          searchBar,
          const Expanded(child: Center(child: CircularProgressIndicator.adaptive())),
        ],
      ),
    };
  }
}

class const StudyListItem({
  required final StudyPageItem study,
  final double? flairSize,
  final int? titleMaxLines,
  required final void Function(BuildContext, StudyPageItem) onTap,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _StudyFlair(flair: study.flair, size: flairSize ?? 24.0),
      title: Text(study.name, overflow: TextOverflow.ellipsis, maxLines: titleMaxLines ?? 2),
      subtitle: _StudySubtitle(study: study),
      onTap: () => onTap(context, study),
      onLongPress: () {
        showModalBottomSheet<void>(
          context: context,
          useRootNavigator: true,
          isDismissible: true,
          isScrollControlled: true,
          constraints: BoxConstraints(minHeight: MediaQuery.heightOf(context) * 0.5),
          builder: (context) => _ContextMenu(study: study),
        );
      },
    );
  }
}

class const StudyCategoryChips({
  required final IList<StudyCategory> categories,
  required final StudyCategory currentCategory,
  final Key? currentCategoryKey,
  required final void Function(StudyCategory) onCategorySelected,
  super.key,
}) extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(50.0);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: SizedBox(
        height: preferredSize.height,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 6.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              spacing: 8.0,
              children: categories.map((cat) {
                return ChoiceChip(
                  key: cat == currentCategory ? currentCategoryKey : null,
                  showCheckmark: false,
                  label: Text(cat.l10n(context.l10n)),
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                  selected: currentCategory == cat,
                  onSelected: (selected) {
                    if (selected) {
                      onCategorySelected(cat);
                    }
                  },
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class const _StudyFlair({required final String? flair, required final double size})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final iconIfNoFlair = Icon(LichessIcons.study, size: size);

    return (flair != null)
        ? HttpNetworkImageWidget(
            lichessFlairSrc(flair!),
            errorBuilder: (_, _, _) => iconIfNoFlair,
            width: size,
            height: size,
          )
        : iconIfNoFlair;
  }
}

class const _StudySubtitle({required final StudyPageItem study}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          if (study.visibility != StudyVisibility.public)
            const WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Icon(Icons.lock_rounded, size: 14),
            ),
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Icon(study.liked ? Icons.favorite : Icons.favorite_outline, size: 14),
          ),
          TextSpan(text: ' ${study.likes}'),
          const TextSpan(text: ' • '),
          if (study.owner != null) ...[
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: UserFullNameWidget(user: study.owner, showFlair: false),
            ),
            const TextSpan(text: ' • '),
          ],
          TextSpan(text: relativeDate(context.l10n, study.updatedAt)),
        ],
      ),
    );
  }
}

class const _ContextMenu({required final StudyPageItem study}) extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BottomSheetScrollableContainer(
      padding: const EdgeInsets.all(16.0),
      children: [
        Text(
          study.name,
          style: Theme.of(context).textTheme.titleMedium
              ?.copyWith(height: 1.1, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16.0),
        _StudyChapters(study: study),
        const SizedBox(height: 10.0),
        _StudyMembers(study: study),
      ],
    );
  }
}

class const _StudyChapters({required final StudyPageItem study}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListSection(
      margin: EdgeInsets.zero,
      children: [
        ...study.chapters.map(
          (chapter) => ListTile(
            dense: true,
            title: Text(chapter, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        ),
      ],
    );
  }
}

class const _StudyMembers({required final StudyPageItem study}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListSection(
      header: Text(
        context.l10n.studyMembers,

        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: textShade(context, 0.5)),
      ),
      margin: EdgeInsets.zero,
      children: [
        ...study.members.map(
          (member) => ListTile(
            dense: true,
            leading: Icon(
              member.role == 'w' ? LichessIcons.radio_tower_lichess : Icons.remove_red_eye,
            ),
            title: UserFullNameWidget(user: member.user, showFlair: false),
          ),
        ),
      ],
    );
  }
}
