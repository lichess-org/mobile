import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_federation.dart';
import 'package:lichess_mobile/src/model/fide/fide_player.dart';
import 'package:lichess_mobile/src/model/fide/fide_providers.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/fide/fide_player_screen.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar.dart';
import 'package:lichess_mobile/src/widgets/bottom_search_bar.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/network_image.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/platform_context_menu_button.dart';
import 'package:lichess_mobile/src/widgets/platform_search_bar.dart';
import 'package:material_ui/material_ui.dart';

/// The players of the FIDE rating list, sorted by rating, name or age, or matching a search, like
/// lichess.org/fide.
class const FidePlayersScreen() extends ConsumerStatefulWidget {
  static Route<dynamic> buildRoute() {
    return buildScreenRoute(screen: const FidePlayersScreen());
  }

  @override
  ConsumerState<FidePlayersScreen> createState() => _FidePlayersScreenState();
}

class _FidePlayersScreenState() extends ConsumerState<FidePlayersScreen> {
  FidePlayerOrder order = .standard;

  /// The submitted search, which sorts players by relevance instead of [order].
  String? query;

  final _searchController = TextEditingController();

  final _searchFocusNode = FocusNode();

  /// Whether the current tap started while the search field had focus: it only dismisses the
  /// keyboard (the search field unfocuses itself on a tap outside of it), and does not open a player.
  bool _tapUnfocusesSearch = false;

  final _scrollController = ScrollController();

  bool _requestedNextPage = false;

  FidePlayerListParams get _params => (order: order, query: query);

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
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (!_requestedNextPage &&
        _scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 300) {
      final playerList = ref.read(fidePlayerListProvider(_params));
      if (!playerList.isLoading && playerList.value?.nextPage != null) {
        _requestedNextPage = true;
        ref.read(fidePlayerListProvider(_params).notifier).next().whenComplete(() {
          _requestedNextPage = false;
        });
      }
    }
  }

  void _onOrderChanged(FidePlayerOrder newOrder) {
    setState(() {
      order = newOrder;
    });
    if (_scrollController.hasClients) _scrollController.jumpTo(0);
  }

  void _onSearch(String? term) {
    final trimmed = term?.trim();
    final newQuery = trimmed == null || trimmed.isEmpty ? null : trimmed;
    if (newQuery != null && newQuery == query) {
      // The same search again: its results are already loaded, so the listener won't see them
      // arrive.
      if (ref.read(fidePlayerListProvider(_params)).value case final page?) {
        _openIdMatch(newQuery, page);
      }
      return;
    }
    setState(() {
      query = newQuery;
    });
    if (_scrollController.hasClients) _scrollController.jumpTo(0);
  }

  /// Opens the player's page directly if the search was the FIDE ID of a player, like
  /// lichess.org does.
  void _openIdMatch(String query, FidePlayerPage page) {
    if (page.idMatch(query) case final player?) {
      Navigator.of(context).push(FidePlayerScreen.buildRoute(player.id, player: player));
    }
  }

  Future<void> _toggleFollowing(FidePlayer player, bool following) async {
    try {
      await ref.read(fideFollowingProvider.notifier).setFollowing(player.id, !following);
    } catch (_) {
      if (mounted) {
        showSnackBar(context, 'Could not update the follow status', type: SnackBarType.error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(fidePlayerListProvider(_params), (prev, next) {
      // Only when a search's first page arrives, not when more pages load.
      if (query case final query? when prev?.hasValue != true) {
        if (next case AsyncData(:final value)) _openIdMatch(query, value);
      }
    });

    final isLoggedIn = ref.watch(isLoggedInProvider);
    final playersAsync = ref.watch(fidePlayerListProvider(_params));
    final followOverrides = ref.watch(fideFollowingProvider);
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    final searchBar = PlatformSearchBar(
      controller: _searchController,
      focusNode: _searchFocusNode,
      hintText: context.l10n.searchSearch,
      onClear: () {
        _searchController.clear();
        _onSearch(null);
      },
      onSubmitted: _onSearch,
      // On iOS, a glass search field floating at the bottom of the screen.
      inAppBar: isIOS,
    );

    final leadingItems = [
      if (!isIOS) Padding(padding: Styles.bodySectionPadding, child: searchBar),
    ];
    final players = playersAsync.value?.players;

    final list = ListView.separated(
      padding: MediaQuery.paddingOf(context)
          .add(EdgeInsets.only(bottom: isIOS ? BottomSearchBar.heightOf(context) : 0.0)),
      controller: _scrollController,
      itemCount: leadingItems.length + (players == null || players.isEmpty ? 1 : players.length),
      separatorBuilder: (context, index) => index < leadingItems.length || players == null
          ? const SizedBox.shrink()
          : const PlatformDivider(height: 1, cupertinoHasLeading: true),
      itemBuilder: (context, index) {
        if (index < leadingItems.length) return leadingItems[index];
        if (players == null) {
          return SizedBox(
            height: 300.0,
            child: playersAsync is AsyncError
                ? FullScreenRetryRequest(
                    onRetry: () => ref.invalidate(fidePlayerListProvider(_params)),
                  )
                : const Center(child: CircularProgressIndicator.adaptive()),
          );
        }
        if (players.isEmpty) {
          return SizedBox(
            height: 300.0,
            child: Center(
              child: Text(context.l10n.mobileNoSearchResults, style: Styles.noResultTextStyle),
            ),
          );
        }
        final player = players[index - leadingItems.length];
        final following = followOverrides.get(player.id) ?? player.following;
        return FidePlayerListTile(
          player: player,
          order: query == null ? order : .standard,
          following: isLoggedIn ? following : null,
          onTap: () {
            if (_tapUnfocusesSearch) return;
            Navigator.of(context).push(FidePlayerScreen.buildRoute(player.id, player: player));
          },
          onFollowingToggled: () => _toggleFollowing(player, following),
        );
      },
    );

    // The search field is unfocused on a tap outside of it, from the pointer down. Its focus is
    // only updated after the pointer down event is dispatched, so it still has focus here.
    final listener = Listener(
      onPointerDown: (_) => _tapUnfocusesSearch = _searchFocusNode.hasFocus,
      child: list,
    );

    return PlatformScaffold(
      plainList: true,
      appBar: PlatformAppBar(
        title: Text(context.l10n.broadcastFidePlayers),
        actions: [
          // As on lichess.org, search results are sorted by relevance only.
          if (query == null)
            ContextMenuIconButton(
              consumeOutsideTap: true,
              icon: const Icon(Icons.sort_outlined),
              semanticsLabel: 'Sort players',
              actions: [
                for (final o in FidePlayerOrder.values)
                  if (o != .follow || isLoggedIn)
                    ContextMenuAction(
                      label: switch (o) {
                        .name => context.l10n.name,
                        .standard => context.l10n.classical,
                        .rapid => context.l10n.rapid,
                        .blitz => context.l10n.blitz,
                        .year => context.l10n.broadcastAge,
                        .follow => context.l10n.following,
                      },
                      selected: order == o,
                      onPressed: () => _onOrderChanged(o),
                    ),
              ],
            ),
        ],
      ),
      body: isIOS
          ? Stack(
              children: [
                // The list scrolls under the glass search field.
                Positioned.fill(
                  child: BottomBarScrollEdgeEffect(
                    barHeight: BottomSearchBar.heightOf(context),
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: listener,
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: BottomSearchBar(searchField: searchBar),
                ),
              ],
            )
          : listener,
    );
  }
}

/// A FIDE player in a list: photo, title, name and federation, with the value the list is sorted
/// by.
class const FidePlayerListTile({
  required final FidePlayer player,

  /// The order of the list, which picks the value shown at the end of the tile: the rating of its
  /// time control, or the age.
  required final FidePlayerOrder order,

  /// Whether the user follows the player, or null to hide the follow button.
  required final bool? following,
  required final VoidCallback onTap,
  required final VoidCallback onFollowingToggled,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FidePlayer(:photo, :title, :name, :federation) = player;
    final subtitleStyle = TextStyle(color: textShade(context, Styles.subtitleOpacity));
    final tc = order.fideTC;
    final value = order == .year ? player.age : player.ratings.get(tc);

    return ListTile(
      onTap: onTap,
      leading: ClipRRect(
        borderRadius: Styles.thumbnailBorderRadius,
        child: photo != null
            ? HttpNetworkImageWidget(photo.smallUrl, width: 40, height: 40)
            : Image.asset('assets/images/anon-face.webp', width: 40, height: 40),
      ),
      title: Text.rich(
        TextSpan(
          children: [
            if (title != null)
              TextSpan(
                text: '$title ',
                style: TextStyle(color: context.lichessColors.brag, fontWeight: FontWeight.bold),
              ),
            TextSpan(text: name),
          ],
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: federation != null
          ? Row(
              children: [
                Image.asset(federation.flagAsset, height: 12),
                const SizedBox(width: 5),
                Flexible(
                  child: Text(
                    federation.name,
                    style: subtitleStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            )
          : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (value != null) ...[
            if (order != .year) Icon(tc.icon, size: 16, color: subtitleStyle.color),
            const SizedBox(width: 4),
            Text(
              value.toString(),
              style: const TextStyle(fontFeatures: [FontFeature.tabularFigures()]),
            ),
          ],
          if (following != null)
            SemanticIconButton(
              icon: Icon(following! ? Icons.star : Icons.star_border),
              semanticsLabel: following! ? context.l10n.unfollow : context.l10n.follow,
              onPressed: onFollowingToggled,
            ),
        ],
      ),
    );
  }
}
