import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/user/search_history.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/model/user/user_repository_providers.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/utils/rate_limit.dart';
import 'package:lichess_mobile/src/view/user/user_screen.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/user_list_tile.dart';

const _kSaveHistoryDebouncTimer = Duration(milliseconds: 500);

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen();

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();
  final saveHistoryDebouncer = Debouncer(_kSaveHistoryDebouncTimer);
  final searchFocus = FocusNode();
  String? _term;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    // searchFocus.requestFocus();
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
    searchFocus.dispose();
  }

  void _onSearchChanged() {
    final term = _searchController.text;
    if (term.length >= 3) {
      ref.read(autoCompleteUserProvider(term));
      setState(() {
        _term = term;
      });
      saveHistoryDebouncer.call(() {
        ref.read(searchHistoryProvider.notifier).saveTerm(term);
      });
    } else {
      setState(() {
        _term = null;
      });
    }
  }

  // ignore: use_setters_to_change_properties
  void setSearchText(String text) {
    _searchController.text = text;
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _androidBuilder,
      iosBuilder: _iosBuilder,
    );
  }

  Widget _androidBuilder(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80, // Custom height to fit the search bar
        title: SearchAnchor(
          suggestionsBuilder: (context, controller) => [],
          builder: (context, controller) => Hero(
            tag: 'searchBar',
            child: SearchBar(
              // onTap: () => searchFocus.requestFocus(),
              // focusNode: searchFocus,
              leading: const Icon(Icons.search),
              trailing: [
                if (_searchController.text.isNotEmpty)
                  IconButton(
                    onPressed: () => _searchController.clear(),
                    icon: const Icon(
                      Icons.close,
                    ),
                  ),
              ],
              hintText: 'Search Lichess',
              controller: _searchController,
            ),
          ),
        ),
      ),
      body: _Body(_term, setSearchText),
    );
  }

  Widget _iosBuilder(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        automaticallyImplyLeading: false,
        middle: CupertinoSearchTextField(
          // focusNode: searchFocus,
          placeholder: 'Search Lichess',
          controller: _searchController,
        ),
        trailing: NoPaddingTextButton(
          child: Text(context.l10n.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      child: _Body(_term, setSearchText),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body(this.term, this.onRecentSearchTap);

  final String? term;
  final void Function(String) onRecentSearchTap;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (term != null) {
      return SafeArea(
        child: _UserList(term!),
      );
    } else {
      final searchHistory = ref.watch(searchHistoryProvider).history;
      return SafeArea(
        child: SingleChildScrollView(
          child: searchHistory.isEmpty
              ? kEmptyWidget
              : ListSection(
                  header: const Text('Recent'),
                  showDividerBetweenTiles: true,
                  children: searchHistory
                      .map(
                        (term) => PlatformListTile(
                          leading: const Icon(Icons.history),
                          title: Text(term),
                          trailing: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => ref
                                .read(searchHistoryProvider.notifier)
                                .removeTerm(term),
                          ),
                          onTap: () => onRecentSearchTap(term),
                        ),
                      )
                      .toList(),
                ),
        ),
      );
    }
  }
}

class _UserList extends ConsumerWidget {
  const _UserList(this.term);

  final String term;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final autoComplete = ref.watch(autoCompleteUserProvider(term));
    return SingleChildScrollView(
      child: ListSection(
        header: Row(
          children: [
            const Icon(Icons.person),
            const SizedBox(width: 8),
            Text('Players with "$term"'),
          ],
        ),
        showDividerBetweenTiles: true,
        children: autoComplete.when(
          data: (userList) => userList.isNotEmpty
              ? userList
                  .map(
                    (user) => UserListTile.fromLightUser(
                      user,
                      onTap: () => {
                        pushPlatformRoute(
                          context,
                          builder: (ctx) => UserScreen(user: user),
                        ),
                      },
                    ),
                  )
                  .toList()
              : const [Center(child: Text('No Result'))],
          error: (e, s) => const [Center(child: Text('Error Loading Results'))],
          loading: () => const [SizedBox(height: 8), CenterLoadingIndicator()],
        ),
      ),
    );
  }
}
