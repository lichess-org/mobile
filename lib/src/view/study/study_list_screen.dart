import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/study/study.dart';
import 'package:lichess_mobile/src/model/study/study_filter.dart';
import 'package:lichess_mobile/src/model/study/study_list_paginator.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/lichess_assets.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/study/study_screen.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/filter.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform_scaffold.dart';
import 'package:lichess_mobile/src/widgets/platform_search_bar.dart';
import 'package:lichess_mobile/src/widgets/user_full_name.dart';
import 'package:logging/logging.dart';

final _logger = Logger('StudyListScreen');

/// A screen that displays a paginated list of studies
class StudyListScreen extends ConsumerWidget {
  const StudyListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoggedIn = ref.watch(authSessionProvider)?.user.id != null;

    final filter = ref.watch(studyFilterProvider);
    final title = Text(isLoggedIn ? filter.category.l10n(context.l10n) : context.l10n.studyMenu);

    return PlatformScaffold(
      backgroundColor: Styles.listingsScreenBackgroundColor(context),
      appBar: PlatformAppBar(
        title: title,
        actions: [
          AppBarIconButton(
            icon: const Icon(Icons.tune),
            // TODO: translate
            semanticsLabel: 'Filter studies',
            onPressed:
                () => showAdaptiveBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  showDragHandle: true,
                  builder: (_) => _StudyFilterSheet(isLoggedIn: isLoggedIn),
                ),
          ),
        ],
      ),
      body: SafeArea(top: false, child: _Body(filter: filter)),
    );
  }
}

class _StudyFilterSheet extends ConsumerWidget {
  const _StudyFilterSheet({required this.isLoggedIn});

  final bool isLoggedIn;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(studyFilterProvider);

    return BottomSheetScrollableContainer(
      padding: const EdgeInsets.all(16.0),
      children: [
        // If we're not logged in, the only category available is "All"
        if (isLoggedIn) ...[
          Filter<StudyCategory>(
            filterType: FilterType.singleChoice,
            choices: StudyCategory.values,
            choiceSelected: (choice) => filter.category == choice,
            choiceLabel: (category) => Text(category.l10n(context.l10n)),
            onSelected:
                (value, selected) => ref.read(studyFilterProvider.notifier).setCategory(value),
          ),
          const PlatformDivider(thickness: 1, indent: 0),
          const SizedBox(height: 10.0),
        ],
        Filter<StudyListOrder>(
          // TODO mobile l10n
          filterName: 'Sort by',
          filterType: FilterType.singleChoice,
          choices: StudyListOrder.values,
          choiceSelected: (choice) => filter.order == choice,
          choiceLabel: (order) => Text(order.l10n(context.l10n)),
          onSelected: (value, selected) => ref.read(studyFilterProvider.notifier).setOrder(value),
        ),
      ],
    );
  }
}

class _Body extends ConsumerStatefulWidget {
  const _Body({required this.filter});

  final StudyFilterState filter;

  @override
  ConsumerState<_Body> createState() => _BodyState();
}

class _BodyState extends ConsumerState<_Body> {
  String? search;

  final _searchController = SearchController();

  final _scrollController = ScrollController(keepScrollOffset: true);

  bool requestedNextPage = false;

  StudyListPaginatorProvider get paginatorProvider =>
      StudyListPaginatorProvider(filter: widget.filter, search: search);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
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
        onClear:
            () => setState(() {
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

    return studiesAsync.when(
      data: (studies) {
        return ListView.separated(
          shrinkWrap: true,
          itemCount: studies.studies.length + 1,
          controller: _scrollController,
          separatorBuilder:
              (context, index) =>
                  index == 0
                      ? const SizedBox.shrink()
                      : Theme.of(context).platform == TargetPlatform.iOS
                      ? const PlatformDivider(height: 1, cupertinoHasLeading: true)
                      : const PlatformDivider(height: 1, color: Colors.transparent),
          itemBuilder:
              (context, index) =>
                  index == 0 ? searchBar : _StudyListItem(study: studies.studies[index - 1]),
        );
      },
      loading: () {
        return Column(
          children: [
            searchBar,
            const Expanded(child: Center(child: CircularProgressIndicator.adaptive())),
          ],
        );
      },
      error: (error, stack) {
        _logger.severe('Error loading studies', error, stack);
        return Center(child: Text(context.l10n.studyMenu));
      },
    );
  }
}

class _StudyListItem extends StatelessWidget {
  const _StudyListItem({required this.study});

  final StudyPageData study;

  @override
  Widget build(BuildContext context) {
    return PlatformListTile(
      padding:
          Theme.of(context).platform == TargetPlatform.iOS
              ? const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0)
              : null,
      leading: _StudyFlair(flair: study.flair, size: 30),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text(study.name, overflow: TextOverflow.ellipsis, maxLines: 2)],
      ),
      subtitle: _StudySubtitle(study: study),
      onTap:
          () => pushPlatformRoute(
            context,
            rootNavigator: true,
            builder: (context) => StudyScreen(id: study.id),
          ),
      onLongPress: () {
        showAdaptiveBottomSheet<void>(
          context: context,
          useRootNavigator: true,
          isDismissible: true,
          isScrollControlled: true,
          showDragHandle: true,
          constraints: BoxConstraints(minHeight: MediaQuery.sizeOf(context).height * 0.5),
          builder: (context) => _ContextMenu(study: study),
        );
      },
    );
  }
}

class _ContextMenu extends ConsumerWidget {
  const _ContextMenu({required this.study});

  final StudyPageData study;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BottomSheetScrollableContainer(
      padding: const EdgeInsets.all(16.0),
      children: [
        _StudyChapters(study: study),
        const SizedBox(height: 10.0),
        _StudyMembers(study: study),
      ],
    );
  }
}

class _StudyChapters extends StatelessWidget {
  const _StudyChapters({required this.study});

  final StudyPageData study;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...study.chapters.map(
          (chapter) => Text.rich(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            TextSpan(
              children: [
                WidgetSpan(
                  child: Icon(
                    Icons.circle_outlined,
                    size: DefaultTextStyle.of(context).style.fontSize,
                  ),
                ),
                TextSpan(text: ' $chapter'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _StudyMembers extends StatelessWidget {
  const _StudyMembers({required this.study});

  final StudyPageData study;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...study.members.map(
          (member) => Text.rich(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            TextSpan(
              children: [
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Icon(
                    member.role == 'w' ? LichessIcons.radio_tower_lichess : Icons.remove_red_eye,
                    size: DefaultTextStyle.of(context).style.fontSize,
                  ),
                ),
                const TextSpan(text: ' '),
                WidgetSpan(
                  alignment: PlaceholderAlignment.bottom,
                  child: UserFullNameWidget(user: member.user, showFlair: false),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _StudyFlair extends StatelessWidget {
  const _StudyFlair({required this.flair, required this.size});

  final String? flair;

  final double size;

  @override
  Widget build(BuildContext context) {
    final iconIfNoFlair = Icon(LichessIcons.study, size: size);

    return (flair != null)
        ? CachedNetworkImage(
          imageUrl: lichessFlairSrc(flair!),
          errorWidget: (_, __, ___) => iconIfNoFlair,
          width: size,
          height: size,
        )
        : iconIfNoFlair;
  }
}

class _StudySubtitle extends StatelessWidget {
  const _StudySubtitle({required this.study});

  final StudyPageData study;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
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
