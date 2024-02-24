import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

/// Create a Screen with Top 10 players for each Lichess Variant
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
        previousPageTitle: 'Home',
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
Future<IList<LightArchivedGame>> _userFullGames(
  _UserFullGamesRef ref, {
  required UserId userId,
}) {
  return ref.withClientCacheFor(
    (client) => GameRepository(client).getRecentGames(userId, -1),
    // cache is important because the associated widget is in a [ListView] and
    // the provider may be instanciated multiple times in a short period of time
    // (e.g. when scrolling)
    // TODO: consider debouncing the request instead of caching it, or make the
    // request in the parent widget and pass the result to the child
    const Duration(minutes: 1),
  );
}

class _Body extends ConsumerWidget {
  const _Body({this.user});
  final LightUser? user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fullGames = user != null
        ? ref.watch(_userFullGamesProvider(userId: user!.id))
        : ref.watch(accountRecentGamesProvider(-1));

    final userId = user?.id ?? ref.watch(authSessionProvider)?.user.id;

    return fullGames.when(
      data: (data) {
        return _GameList(gameListData: data, userId: userId);
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

class _GameList extends StatefulWidget {
  const _GameList({required this.gameListData, this.userId});
  final IList<LightArchivedGame> gameListData;
  final UserId? userId;

  @override
  _GameListState createState() => _GameListState();
}

class _GameListState extends State<_GameList> {
  ScrollController controller = ScrollController();

  late IList<List<LightArchivedGame>> gameListData;
  late List<LightArchivedGame> displayGames;
  late UserId? userId;
  int count = 0;

  @override
  void initState() {
    super.initState();
    userId = widget.userId;
    gameListData = widget.gameListData.slices(10).toIList();
    displayGames = gameListData[0];
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
            return _SlideMenu(
              menuItems: <Widget>[
                IconButton(
                  icon: const Icon(Icons.bookmark_add_outlined),
                  onPressed: () {},
                ),
              ],
              child: ExtendedGameListTile(
                game: displayGames[index],
                userId: userId,
              ),
            );
          },
          itemCount: displayGames.length,
        ),
      ),
    );
  }

  void _scrollListener() {
    if (controller.position.extentAfter < 500) {
      setState(() {
        if (count < gameListData.length - 1) {
          count++;
          displayGames.addAll(gameListData[count]);
        }
      });
    }
  }
}

class _SlideMenu extends StatefulWidget {
  const _SlideMenu({required this.child, required this.menuItems});
  final Widget child;
  final List<Widget> menuItems;

  @override
  _SlideMenuState createState() => _SlideMenuState();
}

class _SlideMenuState extends State<_SlideMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final animation = Tween(begin: Offset.zero, end: const Offset(-0.15, 0.0))
        .animate(CurveTween(curve: Curves.decelerate).animate(_controller));

    return GestureDetector(
      onHorizontalDragUpdate: (data) {
        setState(() {
          _controller.value -= data.primaryDelta! / context.size!.width * 1.5;
        });
      },
      onHorizontalDragEnd: (data) {
        if (data.primaryVelocity! > 1500) {
          _controller.animateTo(0);
        } else if (_controller.value >= 0.3 || data.primaryVelocity! < -1500) {
          _controller.animateTo(1.0);
        } else {
          _controller.animateTo(0);
        }
      },
      child: Stack(
        children: <Widget>[
          SlideTransition(position: animation, child: widget.child),
          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, constraint) {
                return AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Stack(
                      children: <Widget>[
                        Positioned(
                          right: 0.1,
                          top: 0,
                          bottom: 0,
                          width: constraint.maxWidth * animation.value.dx * -1,
                          child: Row(
                            children: widget.menuItems.map((child) {
                              return Expanded(
                                child: child,
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
