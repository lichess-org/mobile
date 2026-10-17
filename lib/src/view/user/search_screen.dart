import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/user/search_history.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/model/user/user_repository_providers.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/utils/rate_limit.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/platform_search_bar.dart';
import 'package:lichess_mobile/src/widgets/user_list_tile.dart';
import 'package:material_ui/material_ui.dart';

const _kSaveHistoryDebouncTimer = Duration(seconds: 2);

class const SearchScreen({
  final void Function(LightUser)? onUserTap,
  final bool autoFocus = true,
  super.key,
}) extends ConsumerStatefulWidget {
  /// Hero tag of the search field, for a [SearchHeroButton] opening this screen.
  static const heroTag = 'user-search-field';

  static Route<dynamic> buildRoute({void Function(LightUser)? onUserTap, bool autoFocus = true}) {
    return buildScreenRoute(
      screen: SearchScreen(onUserTap: onUserTap, autoFocus: autoFocus),
    );
  }

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState() extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();
  final saveHistoryDebouncer = Debouncer(_kSaveHistoryDebouncTimer);
  String? _term;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  void _onSearchChanged() {
    if (!mounted) return;

    final term = _searchController.text;
    if (term.length >= 3) {
      ref.read(autoCompleteUserProvider(term));
      setState(() {
        _term = term;
      });
      saveHistoryDebouncer.call(() {
        if (!mounted) return;
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
    final searchBar = SearchFieldHero(
      tag: SearchScreen.heroTag,
      child: PlatformSearchBar(
        hintText: context.l10n.searchSearch,
        controller: _searchController,
        autoFocus: widget.autoFocus,
        inAppBar: true,
      ),
    );

    final body = _Body(_term, setSearchText, widget.onUserTap);

    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: searchBar,
        // The search field fills the bar.
        centerTitle: false,
      ),
      body: body,
    );
  }
}

class const _Body(
  final String? term,
  final void Function(String) onRecentSearchTap,
  final void Function(LightUser)? onUserTap,
) extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (term != null) {
      return _UserList(term!, onUserTap);
    } else {
      final searchHistory = ref.watch(searchHistoryProvider).history;
      return SingleChildScrollView(
        // Not in a SafeArea, so that the content scrolls under the app bar.
        padding: MediaQuery.paddingOf(context),
        child: searchHistory.isEmpty
            ? kEmptyWidget
            : ListSection(
                header: Text(context.l10n.mobileRecentSearches),
                headerTrailing: TextButton(
                  child: Text(context.l10n.mobileClearButton),
                  onPressed: () => ref.read(searchHistoryProvider.notifier).clear(),
                ),
                hasLeading: true,
                children: searchHistory
                    .map(
                      (term) => ListTile(
                        leading: const Icon(Icons.history),
                        title: Text(term),
                        onTap: () => onRecentSearchTap(term),
                      ),
                    )
                    .toList(),
              ),
      );
    }
  }
}

class const _UserList(final String term, final void Function(LightUser)? onUserTap)
    extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final autoComplete = ref.watch(autoCompleteUserProvider(term));

    return autoComplete.when(
      data: (userList) => userList.isNotEmpty
          ? SingleChildScrollView(
              // Not in a SafeArea, so that the content scrolls under the app bar.
              padding: MediaQuery.paddingOf(context),
              child: ListSection(
                header: Row(
                  children: [
                    const Icon(Icons.person),
                    const SizedBox(width: 8),
                    Text(context.l10n.mobilePlayersMatchingSearchTerm(term)),
                  ],
                ),
                hasLeading: true,
                children: userList
                    .map(
                      (user) => UserListTile.fromLightUser(
                        user,
                        onTap: () {
                          if (onUserTap != null) {
                            onUserTap!.call(user);
                          }
                        },
                      ),
                    )
                    .toList(),
              ),
            )
          : Center(
              child: Text(context.l10n.mobileNoSearchResults, style: Styles.noResultTextStyle),
            ),
      error: (e, _) {
        debugPrint('Error loading search results: $e');
        return const Center(child: Text('Could not load search results.'));
      },
      loading: () => const Center(child: CenterLoadingIndicator()),
    );
  }
}
