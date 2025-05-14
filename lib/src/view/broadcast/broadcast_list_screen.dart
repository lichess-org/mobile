import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_providers.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_list_tile.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_search_screen.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/filter.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/misc.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';

enum _BroadcastFilter {
  all,
  live;

  String l10n(AppLocalizations l10n) {
    switch (this) {
      case live:
        return 'Live broadcasts';
      case all:
        return 'All broadcasts';
    }
  }
}

/// A screen that displays a paginated list of broadcasts.
class BroadcastListScreen extends StatefulWidget {
  const BroadcastListScreen({super.key});

  static Route<dynamic> buildRoute(BuildContext context) {
    return buildScreenRoute(context, screen: const BroadcastListScreen());
  }

  @override
  State<BroadcastListScreen> createState() => _BroadcastListScreenState();
}

class _BroadcastListScreenState extends State<BroadcastListScreen> {
  _BroadcastFilter filter = _BroadcastFilter.all;

  @override
  Widget build(BuildContext context) {
    final title = AppBarTitleText(context.l10n.broadcastBroadcasts);
    final searchButton = SemanticIconButton(
      icon: const Icon(Icons.search),
      onPressed: () {
        Navigator.of(context).push(BroadcastSearchScreen.buildRoute(context));
      },
      semanticsLabel: context.l10n.searchSearch,
    );
    final filterButton = SemanticIconButton(
      icon: const Icon(Icons.filter_list),
      // TODO: translate
      semanticsLabel: 'Filter broadcasts',
      onPressed:
          () => showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            constraints: BoxConstraints(minHeight: MediaQuery.sizeOf(context).height * 0.4),
            builder:
                (_) => StatefulBuilder(
                  builder: (context, setLocalState) {
                    return BottomSheetScrollableContainer(
                      padding: const EdgeInsets.all(16.0),
                      children: [
                        const SizedBox(height: 16.0),
                        Filter<_BroadcastFilter>(
                          filterType: FilterType.singleChoice,
                          choices: _BroadcastFilter.values,
                          choiceSelected: (choice) => filter == choice,
                          choiceLabel: (category) => Text(category.l10n(context.l10n)),
                          onSelected: (value, selected) {
                            setLocalState(() => filter = value);
                            setState(() => filter = value);
                          },
                        ),
                        const SizedBox(height: 16.0),
                      ],
                    );
                  },
                ),
          ),
    );

    return Scaffold(
      body: _Body(filter),
      appBar: AppBar(title: title, actions: [searchButton, filterButton]),
    );
  }
}

class _Body extends ConsumerStatefulWidget {
  const _Body(this.filter);

  final _BroadcastFilter filter;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BodyState();
}

class _BodyState extends ConsumerState<_Body> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (widget.filter == _BroadcastFilter.all &&
        _scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 300) {
      final broadcastList = ref.read(broadcastsPaginatorProvider);

      if (!broadcastList.isLoading) {
        ref.read(broadcastsPaginatorProvider.notifier).next();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final broadcastList = ref.watch(broadcastsPaginatorProvider);

    if (!broadcastList.hasValue && broadcastList.isLoading) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }

    final sections = [
      (
        'ongoing',
        context.l10n.broadcastOngoing,
        broadcastList.requireValue.active
            .where((b) => b.isLive || widget.filter != _BroadcastFilter.live)
            .toList(),
      ),
      (
        'past',
        context.l10n.broadcastPastBroadcasts,
        broadcastList.requireValue.past
            .where((b) => widget.filter == _BroadcastFilter.all)
            .toList(),
      ),
    ];

    return RefreshIndicator.adaptive(
      key: _refreshIndicatorKey,
      onRefresh: () async => ref.refresh(broadcastsPaginatorProvider),
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          for (final section in sections)
            SliverMainAxisGroup(
              key: ValueKey(section.$1),
              slivers: [
                if (section.$3.isNotEmpty)
                  SliverAppBar(
                    backgroundColor: Theme.of(
                      context,
                    ).appBarTheme.backgroundColor?.withValues(alpha: 1),
                    automaticallyImplyLeading: false,
                    primary: false,
                    title: AppBarTitleText(section.$2),
                    pinned: true,
                  ),
                SliverPadding(
                  padding: Styles.sectionBottomPadding,
                  sliver: SliverList.separated(
                    separatorBuilder:
                        (context, index) => PlatformDivider(
                          height: 1,
                          indent: BroadcastListTile.thumbnailSizeFromContext(context) + 16.0 + 10.0,
                        ),
                    itemCount: section.$3.length,
                    itemBuilder:
                        (context, index) =>
                            (section.$1 == 'past' &&
                                    broadcastList.isLoading &&
                                    index >= section.$3.length - 1)
                                ? const Shimmer(
                                  child: ShimmerLoading(
                                    isLoading: true,
                                    child: BroadcastListTile.loading(),
                                  ),
                                )
                                : BroadcastListTile(broadcast: section.$3[index]),
                  ),
                ),
              ],
            ),
          const SliverSafeArea(
            top: false,
            sliver: SliverToBoxAdapter(child: SizedBox(height: 16.0)),
          ),
        ],
      ),
    );
  }
}
