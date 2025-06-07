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
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/platform_context_menu_button.dart';
import 'package:lichess_mobile/src/widgets/platform_search_bar.dart';
import 'package:lichess_mobile/src/widgets/user_full_name.dart';

/// A screen that displays a paginated list of studies
class StudyListScreen extends ConsumerStatefulWidget {
  const StudyListScreen({super.key});

  static Route<dynamic> buildRoute(BuildContext context) {
    return buildScreenRoute(context, screen: const StudyListScreen());
  }

  @override
  ConsumerState<StudyListScreen> createState() => _StudyListScreenState();
}

class _StudyListScreenState extends ConsumerState<StudyListScreen> {
  StudyCategory category = StudyCategory.all;
  StudyListOrder order = StudyListOrder.hot;

  String? search;

  final _searchController = TextEditingController();

  final _scrollController = ScrollController(keepScrollOffset: true);

  bool requestedNextPage = false;

  StudyListPaginatorProvider get paginatorProvider =>
      StudyListPaginatorProvider(category: category, order: order, search: search);

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
    final sessionUser = ref.watch(authSessionProvider)?.user;

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

    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(sessionUser != null ? context.l10n.studyMenu : context.l10n.studyAllStudies),
        actions: [
          ContextMenuIconButton(
            consumeOutsideTap: true,
            icon: const Icon(Icons.sort_outlined),
            semanticsLabel: 'Sort studies',
            actions: [
              ContextMenuAction(
                icon: order == StudyListOrder.hot ? Icons.check : null,
                label: context.l10n.studyHot,
                onPressed: () => setState(() {
                  order = StudyListOrder.hot;
                }),
              ),
              ContextMenuAction(
                icon: order == StudyListOrder.newest ? Icons.check : null,
                label: context.l10n.studyDateAddedNewest,
                onPressed: () => setState(() {
                  order = StudyListOrder.newest;
                }),
              ),
              ContextMenuAction(
                icon: order == StudyListOrder.updated ? Icons.check : null,
                label: context.l10n.studyRecentlyUpdated,
                onPressed: () => setState(() {
                  order = StudyListOrder.updated;
                }),
              ),
              ContextMenuAction(
                icon: order == StudyListOrder.popular ? Icons.check : null,
                label: context.l10n.studyMostPopular,
                onPressed: () => setState(() {
                  order = StudyListOrder.popular;
                }),
              ),
            ],
          ),
        ],
        bottom: sessionUser != null
            ? PreferredSize(
                preferredSize: const Size.fromHeight(50.0),
                child: SizedBox(
                  height: 50.0,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 6.0),
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: StudyCategory.values.length,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      separatorBuilder: (context, index) => const SizedBox(width: 8.0),
                      itemBuilder: (context, index) {
                        final cat = StudyCategory.values[index];
                        return ChoiceChip(
                          showCheckmark: false,
                          label: Text(cat.l10n(context.l10n)),
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                          selected: category == cat,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                category = cat;
                                if ([
                                  StudyCategory.mine,
                                  StudyCategory.public,
                                  StudyCategory.private,
                                ].contains(cat)) {
                                  search = null;
                                  _searchController.value = TextEditingValue(
                                    text: 'owner:${sessionUser.id} ',
                                  );
                                } else if (cat == StudyCategory.member) {
                                  search = null;
                                  _searchController.value = TextEditingValue(
                                    text: 'member:${sessionUser.id} ',
                                  );
                                } else {
                                  search = null;
                                  _searchController.clear();
                                }
                              });
                            }
                          },
                        );
                      },
                    ),
                  ),
                ),
              )
            : null,
      ),
      body: switch (studiesAsync) {
        AsyncData(value: final studies) => ListView.separated(
          shrinkWrap: true,
          itemCount: studies.studies.length + 1,
          controller: _scrollController,
          separatorBuilder: (context, index) => index == 0
              ? const SizedBox.shrink()
              : Theme.of(context).platform == TargetPlatform.iOS
              ? const PlatformDivider(height: 1, cupertinoHasLeading: true)
              : const PlatformDivider(height: 1, color: Colors.transparent),
          itemBuilder: (context, index) =>
              index == 0 ? searchBar : _StudyListItem(study: studies.studies[index - 1]),
        ),
        AsyncError() => FullScreenRetryRequest(onRetry: () => ref.invalidate(paginatorProvider)),
        _ => Column(
          children: [
            searchBar,
            const Expanded(child: Center(child: CircularProgressIndicator.adaptive())),
          ],
        ),
      },
    );
  }
}

class _StudyListItem extends StatelessWidget {
  const _StudyListItem({required this.study});

  final StudyPageData study;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _StudyFlair(flair: study.flair, size: 30),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text(study.name, overflow: TextOverflow.ellipsis, maxLines: 2)],
      ),
      subtitle: _StudySubtitle(study: study),
      onTap: () => Navigator.of(
        context,
        rootNavigator: true,
      ).push(StudyScreen.buildRoute(context, study.id)),
      onLongPress: () {
        showModalBottomSheet<void>(
          context: context,
          useRootNavigator: true,
          isDismissible: true,
          isScrollControlled: true,
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
        Text(
          study.name,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(height: 1.1, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16.0),
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
    return ListSection(
      // crossAxisAlignment: CrossAxisAlignment.start,
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

class _StudyMembers extends StatelessWidget {
  const _StudyMembers({required this.study});

  final StudyPageData study;

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
            errorWidget: (_, _, _) => iconIfNoFlair,
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
