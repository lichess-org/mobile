import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/common/http.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/archived_game.dart';
import 'package:lichess_mobile/src/model/game/game_repository.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/view/game/game_list_tile.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'full_games_screen.g.dart';

class FullGameScreen extends StatelessWidget {
  const FullGameScreen({this.user, super.key});
  final LightUser? user;

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(androidBuilder: _buildAndroid, iosBuilder: _buildIos);
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Full Game History'),
      ),
      child: _Body(user: user),
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Full Game History'),
      ),
      body: _Body(user: user),
    );
  }
}

@riverpod
Future<FullGamePaginator> _userFullGames(
  _UserFullGamesRef ref, {
  required UserId userId,
  required int page,
}) {
  return ref.withClientCacheFor(
    (client) => GameRepository(client).getFullGames(userId, page),
    const Duration(minutes: 1),
  );
}

class _Body extends ConsumerWidget {
  const _Body({this.user});
  final LightUser? user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = user?.id ?? ref.watch(authSessionProvider)?.user.id;
    final initialGame = (userId != null
        ? ref.watch(
            _userFullGamesProvider(
              page: 1,
              userId: userId,
            ),
          )
        : ref.watch(accountFullGamesProvider(1)));
    return initialGame.when(
      data: (data) {
        if (data != null) {
          return _GameList(
            userId: userId,
            initialPage: data,
          );
        } else {
          return const Text('nothing');
        }
      },
      error: (error, stackTrace) {
        debugPrint(
          'SEVERE: [FullGames] could not load game history; $error\n$stackTrace',
        );
        return Padding(
          padding: Styles.bodySectionPadding,
          child: const Text('Could not load game history.'),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
    );
  }
}

class _GameList extends ConsumerStatefulWidget {
  const _GameList({this.userId, required this.initialPage});
  final UserId? userId;
  final FullGamePaginator initialPage;

  @override
  _GameListState createState() => _GameListState();
}

class _GameListState extends ConsumerState<_GameList> {
  ScrollController controller = ScrollController();

  late List<LightArchivedGame> games;
  late FullGamePaginator page;
  late UserId? userId;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    userId = widget.userId;
    page = widget.initialPage;
    games = page.games.toList();
    controller = ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scrollbar(
        child: ListView.builder(
          controller: controller,
          itemBuilder: (context, index) {
            if (index == games.length) {
              if (isLoading || page.currentPage == 1) {
                return const Center(
                  heightFactor: 2.0,
                  child: CircularProgressIndicator.adaptive(),
                );
              } else {
                return kEmptyWidget;
              }
            } else {
              return Slidable(
                endActionPane: const ActionPane(
                  motion: ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: null,
                      icon: Icons.bookmark_add_outlined,
                      label: 'Bookmark',
                    ),
                  ],
                ),
                child: ExtendedGameListTile(
                  game: games[index],
                  userId: userId,
                ),
              );
            }
          },
          itemCount: games.length + 1,
        ),
      ),
    );
  }

  Future<void> _scrollListener() async {
    if (controller.position.extentAfter < 500 &&
        page.nextPage != null &&
        !isLoading) {
      isLoading = true;
      final nextPage = (userId != null
          ? await ref.read(
              _userFullGamesProvider(
                page: page.nextPage!,
                userId: userId!,
              ).future,
            )
          : await ref.read(accountFullGamesProvider(page.nextPage!).future));
      if (nextPage != null) page = nextPage;

      setState(() {
        games.addAll(nextPage?.games ?? []);
      });
      isLoading = false;
    }
  }
}
