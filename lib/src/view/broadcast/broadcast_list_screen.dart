import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_providers.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_list_tile.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_search_screen.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/filter.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/misc.dart';

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
      onPressed: () => showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        constraints: BoxConstraints(minHeight: MediaQuery.sizeOf(context).height * 0.4),
        builder: (_) => StatefulBuilder(
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
      appBar: AppBar(
        backgroundColor: ColorScheme.of(context).surfaceContainerHigh.withValues(alpha: 1),
        title: title,
        actions: [searchButton, filterButton],
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body(this.filter);

  final _BroadcastFilter filter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final broadcastList = ref.watch(broadcastsPaginatorProvider);

    return RefreshIndicator.adaptive(
      onRefresh: () => ref.refresh(broadcastsPaginatorProvider.future),
      child: broadcastList.when(
        data: (value) {
          final sections = [
            (
              'ongoing',
              context.l10n.broadcastOngoing,
              switch (filter) {
                _BroadcastFilter.all => value.active,
                _BroadcastFilter.live => value.active.where((b) => b.isLive),
              }.toList(growable: false),
            ),
            if (filter == _BroadcastFilter.all)
              ('past', context.l10n.broadcastPastBroadcasts, value.past.toList(growable: false)),
          ];
          final hasMorePages = value.nextPage != null && value.nextPage! <= 20;
          final notifier = ref.read(broadcastsPaginatorProvider.notifier);

          return SafeArea(
            child: CustomScrollView(
              slivers: [
                for (final section in sections)
                  SliverMainAxisGroup(
                    key: ValueKey(section.$1),
                    slivers: [
                      if (section.$3.isNotEmpty)
                        SliverAppBar(
                          centerTitle: false,
                          backgroundColor: ColorScheme.of(
                            context,
                          ).surfaceContainerHigh.withValues(alpha: 1),
                          automaticallyImplyLeading: false,
                          primary: false,
                          title: AppBarTitleText(section.$2),
                          pinned: true,
                        ),
                      SliverList.separated(
                        separatorBuilder: (context, index) => PlatformDivider(
                          height: 1,
                          indent: BroadcastListTile.thumbnailSize(context) + 16.0 + 10.0,
                        ),
                        itemCount:
                            section.$3.length + (section.$1 == 'past' && hasMorePages ? 1 : 0),
                        itemBuilder: (context, index) =>
                            (section.$1 == 'past' && hasMorePages && index == section.$3.length)
                            ? BroadcastNextPageTile(notifier.next)
                            : BroadcastListTile(broadcast: section.$3[index]),
                      ),
                    ],
                  ),
              ],
            ),
          );
        },
        error: (_, _) => const Center(child: Text('Cannot load broadcasts')),
        loading: () => const Center(child: CircularProgressIndicator.adaptive()),
      ),
    );
  }
}
