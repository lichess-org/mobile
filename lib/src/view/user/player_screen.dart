import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/relation/online_friends.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/model/user/user_repository_providers.dart';
import 'package:lichess_mobile/src/utils/focus_detector.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/account/rating_pref_aware.dart';
import 'package:lichess_mobile/src/view/relation/following_screen.dart';
import 'package:lichess_mobile/src/view/user/leaderboard_widget.dart';
import 'package:lichess_mobile/src/view/user/search_screen.dart';
import 'package:lichess_mobile/src/view/user/user_screen.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/platform_search_bar.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';
import 'package:lichess_mobile/src/widgets/user_full_name.dart';

class PlayerScreen extends ConsumerStatefulWidget {
  const PlayerScreen({super.key});

  static Route<dynamic> buildRoute(BuildContext context) {
    return buildScreenRoute(context, screen: const PlayerScreen(), title: context.l10n.players);
  }

  @override
  ConsumerState<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends ConsumerState<PlayerScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Initial filter
    // filterData(0);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        // filterData(_tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Widget> filteredChildren = [];
  @override
  Widget build(BuildContext context) {
    final session = ref.watch(authSessionProvider);
    void onUserTap(LightUser user) =>
        Navigator.of(context).push(UserScreen.buildRoute(context, user));

    final searchButton = PreferredSize(
      preferredSize: Size.fromHeight(
        Theme.of(context).platform == TargetPlatform.iOS
            ? kMinInteractiveDimensionCupertino
            : kToolbarHeight,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: PlatformSearchBar(
          hintText: context.l10n.searchSearch,
          focusNode: AlwaysDisabledFocusNode(),
          onTap:
              () => Navigator.of(
                context,
              ).push(SearchScreen.buildRoute(context, onUserTap: onUserTap)),
        ),
      ),
    );

    final listContent = [
      if (session != null) _OnlineFriendsWidget(),
      RatingPrefAware(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Container(
                height: 44.0,
                decoration: BoxDecoration(
                  color: const Color(0xff464A4F),

                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    children: [
                      _buildTabButton(
                        0,
                        'Bullet',
                        Image.asset('assets/images/bullet.png', color: Colors.amber),
                      ),
                      _buildTabButton(1, 'Rapid', Icon(Icons.timer_outlined, color: Colors.green)),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: 480,
              child: TabBarView(
                controller: _tabController,
                children: [
                  LeaderboardWidget(index: _selectedIndex),
                  LeaderboardWidget(index: _selectedIndex),
                ],
              ),
            ),
          ],
        ),
      ),
    ];

    return FocusDetector(
      onFocusRegained: () {
        ref.read(onlineFriendsProvider.notifier).startWatchingFriends();
      },
      onFocusLost: () {
        if (context.mounted) {
          ref.read(onlineFriendsProvider.notifier).stopWatchingFriends();
        }
      },
      child: PlatformWidget(
        androidBuilder:
            (context) => Scaffold(
              appBar: AppBar(
                title: const Text('Leaderboard'),
                centerTitle: true,

                //  bottom: searchButton
              ),
              body: _Body(),
            ),
        iosBuilder:
            (context) => CupertinoPageScaffold(
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(title: const Text('Leaderboard'), centerTitle: true),

                  // CupertinoSliverNavigationBar(
                  //   previousPageTitle: 'Leaderboard',
                  //   alwaysShowMiddle: true,
                  //   largeTitle: Text(''),
                  //   // bottom: searchButton,
                  // ),
                  SliverList(delegate: SliverChildListDelegate(listContent)),
                ],
              ),
            ),
      ),
    );
  }

  Widget _buildTabButton(int index, String text, Widget icon) {
    final isSelected = _selectedIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedIndex = index;
            // filterData(index);
          });
        },
        child: Container(
          height: 40.0,
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              const SizedBox(width: 8.0),
              Text(
                text,
                style: TextStyle(
                  color: isSelected ? Colors.black : Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Body extends ConsumerStatefulWidget {
  @override
  ConsumerState<_Body> createState() => _BodyState();
}

class _BodyState extends ConsumerState<_Body> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Initial filter
    // filterData(0);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        // filterData(_tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Widget> filteredChildren = [];
  @override
  Widget build(BuildContext context) {
    final session = ref.watch(authSessionProvider);
    final leaderboardState = ref.watch(top1Provider);

    return ListView(
      children: [
        if (session != null) _OnlineFriendsWidget(),
        RatingPrefAware(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Container(
                  height: 44.0,
                  decoration: BoxDecoration(
                    color: const Color(0xff464A4F),

                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      children: [
                        _buildTabButton(
                          0,
                          'Bullet',
                          Image.asset('assets/images/bullet.png', color: Colors.amber),
                        ),
                        _buildTabButton(
                          1,
                          'Rapid',
                          Icon(Icons.timer_outlined, color: Colors.green),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                height: 480,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    LeaderboardWidget(index: _selectedIndex),
                    LeaderboardWidget(index: _selectedIndex),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // void filterData(int index) {
  //   setState(() {
  //     if (index == 0) {
  //       // Show only items related to Bullet
  //       debugPrint(widget.children.toList().toString());
  //       filteredChildren =
  //           widget.children.where((item) {
  //             debugPrint(item.key.toString());
  //             return item.key == Perf.bullet;
  //           }).toList();
  //     } else {
  //       // Show only items related to Rapid
  //       filteredChildren =
  //           widget.children.where((item) {
  //             return item.key.toString().contains('Rapid');
  //           }).toList();
  //     }
  //   });
  // }

  Widget _buildTabButton(int index, String text, Widget icon) {
    final isSelected = _selectedIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedIndex = index;
            // filterData(index);
          });
        },
        child: Container(
          height: 40.0,
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              const SizedBox(width: 8.0),
              Text(
                text,
                style: TextStyle(
                  color: isSelected ? Colors.black : Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

class _OnlineFriendsWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncFriends = ref.watch(onlineFriendsProvider);

    return asyncFriends.when(
      data: (data) {
        return ListSection(
          header: Text(context.l10n.nbFriendsOnline(data.length)),
          headerTrailing:
              data.isEmpty
                  ? null
                  : NoPaddingTextButton(
                    onPressed: () => _handleTap(context, data),
                    child: Text(context.l10n.more),
                  ),
          children: [
            if (data.isEmpty)
              PlatformListTile(
                title: Text(context.l10n.friends),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _handleTap(context, data),
              ),
            for (final user in data)
              PlatformListTile(
                title: Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: UserFullNameWidget(user: user),
                ),
                onTap: () => Navigator.of(context).push(UserScreen.buildRoute(context, user)),
              ),
          ],
        );
      },
      error: (error, stackTrace) {
        debugPrint(
          'SEVERE: [PlayerScreen] could not load following online users; $error\n $stackTrace',
        );
        return const Center(child: Text('Could not load online friends'));
      },
      loading:
          () => Shimmer(
            child: ShimmerLoading(
              isLoading: true,
              child: ListSection.loading(itemsNumber: 3, header: true),
            ),
          ),
    );
  }

  void _handleTap(BuildContext context, IList<LightUser> followingOnlines) {
    Navigator.of(context).push(FollowingScreen.buildRoute(context));
  }
}
