import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_providers.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_list_tile.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform_search_bar.dart';

class BroadcastSearchScreen extends StatefulWidget {
  const BroadcastSearchScreen();

  static Route<dynamic> buildRoute(BuildContext context) {
    return buildScreenRoute(context, screen: const BroadcastSearchScreen(), fullscreenDialog: true);
  }

  @override
  State<BroadcastSearchScreen> createState() => _BroadcastSearchScreenState();
}

class _BroadcastSearchScreenState extends State<BroadcastSearchScreen> {
  late final TextEditingController _searchController;
  String? searchTerm;

  void onSubmitted(String term) {
    setState(() {
      searchTerm = term.trim();
    });
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchBar = PlatformSearchBar(
      controller: _searchController,
      hintText: context.l10n.searchSearch,
      autoFocus: true,
      onSubmitted: onSubmitted,
    );

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80, // Custom height to fit the search bar
        title: searchBar,
      ),
      body: (searchTerm != null)
          ? (searchTerm!.isNotEmpty)
                ? _Body(searchTerm!)
                : const Center(
                    child: Text(
                      'Search is empty', // TODO: translate
                      style: Styles.noResultTextStyle,
                    ),
                  )
          : kEmptyWidget,
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body(this.searchTerm);

  final String searchTerm;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final broadcastList = ref.watch(broadcastsSearchPaginatorProvider(searchTerm));

    return SafeArea(
      child: broadcastList.when(
        skipLoadingOnReload: true,
        data: (value) {
          final broadcasts = value.broadcasts;
          final hasMorePages = value.nextPage != null && value.nextPage! <= 20;
          final notifier = ref.read(broadcastsSearchPaginatorProvider(searchTerm).notifier);

          return (broadcasts.isNotEmpty)
              ? ListView.separated(
                  separatorBuilder: (context, index) => PlatformDivider(
                    height: 1,
                    indent: BroadcastListTile.thumbnailSize(context) + 16.0 + 10.0,
                  ),
                  itemCount: broadcasts.length + (hasMorePages ? 1 : 0),
                  itemBuilder: (context, index) => (hasMorePages && index == broadcasts.length)
                      ? BroadcastNextPageTile(notifier.next)
                      : BroadcastListTile(broadcast: broadcasts[index]),
                )
              : Center(
                  child: Text(context.l10n.mobileNoSearchResults, style: Styles.noResultTextStyle),
                );
        },
        error: (_, _) => const Center(child: Text('Could not load round data')),
        loading: () => const Center(child: CircularProgressIndicator.adaptive()),
      ),
    );
  }
}
