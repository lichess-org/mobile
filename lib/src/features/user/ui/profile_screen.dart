import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/common/lichess_icons.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/features/settings/ui/settings_screen.dart';
import 'package:lichess_mobile/src/features/user/model/user.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _androidRefreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.profile),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.of(context).push<void>(
              MaterialPageRoute(
                builder: (context) => const SettingsScreen(),
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        key: _androidRefreshKey,
        onRefresh: _refreshData,
        child: _buildBody(context),
      ),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            trailing: CupertinoButton(
              onPressed: () => Navigator.of(context).push<void>(
                CupertinoPageRoute(
                  title: context.l10n.settings,
                  builder: (context) => const SettingsScreen(),
                ),
              ),
              child: const Icon(CupertinoIcons.settings),
            ),
          ),
          CupertinoSliverRefreshControl(
            onRefresh: _refreshData,
          ),
          SliverFillRemaining(
            child: _buildBody(context),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Padding(
        padding: kBodyPadding,
        child: Column(
          children: [
            PlatformCard(
              child: Column(
                children: [
                  const ListTile(
                    leading: Icon(LichessIcons.patron, size: 40),
                    title: Text(
                      'veloce',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text('Vincent Velociter'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 10, left: 16.0, right: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Location(
                          profile:
                              Profile(country: 'fr', location: 'Lille, France'),
                        ),
                        SizedBox(height: 5),
                        Text('Member since 18 Sept 2015'),
                        SizedBox(height: 5),
                        Text('Active 16 hours ago'),
                        SizedBox(height: 5),
                        Text(
                            'Time spent playing: 31 days, 1 hour and 47 minutes'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 106,
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 3.0),
                scrollDirection: Axis.horizontal,
                children: [
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: PlatformCard(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text('Blitz'),
                            Icon(LichessIcons.blitz),
                            Text('3079'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: PlatformCard(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text('Blitz'),
                            Icon(LichessIcons.blitz),
                            Text('3079'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: PlatformCard(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text('Blitz'),
                            Icon(LichessIcons.blitz),
                            Text('3079'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: PlatformCard(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text('Blitz'),
                            Icon(LichessIcons.blitz),
                            Text('3079'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _refreshData() {
    return Future.delayed(
      // This is just an arbitrary delay that simulates some network activity.
      const Duration(seconds: 2),
      () => {},
    );
  }
}

class Location extends StatelessWidget {
  const Location({required this.profile, super.key});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      profile.country != null
          ? CachedNetworkImage(
              imageUrl: lichessFlagSrc(profile.country!),
              errorWidget: (_, __, ___) => kEmptyWidget,
            )
          : kEmptyWidget,
      const SizedBox(width: 10),
      Text(profile.location ?? ''),
    ]);
  }
}

String lichessFlagSrc(String country) {
  return '$kLichessHost/assets/images/flags/$country.png';
}
