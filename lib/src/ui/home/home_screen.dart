import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:lichess_mobile/src/common/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/ui/auth/sign_in_widget.dart';
import 'package:lichess_mobile/src/ui/game/create_game_screen.dart';
import 'package:lichess_mobile/src/ui/user/leaderboard_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
        title: const Text('Home'),
        actions: const [
          SignInWidget(),
        ],
      ),
      body: _HomeScaffold(
        child: ListView(
          children: [
            LeaderboardWidget(),
          ],
        ),
      ),
    );
  }

  Widget _iosBuilder(BuildContext context) {
    return CupertinoPageScaffold(
      // navigationBar: const CupertinoNavigationBar(trailing: SignInWidget()),
      child: _HomeScaffold(
        child: CustomScrollView(
          slivers: [
            const CupertinoSliverNavigationBar(
              largeTitle: Text('Home'),
              trailing: SignInWidget(),
            ),
            SliverSafeArea(
              top: false,
              sliver: SliverList(
                delegate: SliverChildListDelegate([LeaderboardWidget()]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Scaffold with a sticky Create Game button at the bottom
class _HomeScaffold extends StatelessWidget {
  const _HomeScaffold({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: child,
          ),
          SizedBox(
            height: 80,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0)
                  .add(Styles.horizontalBodyPadding),
              child: FatButton(
                semanticsLabel: context.l10n.createAGame,
                child: Text(context.l10n.createAGame),
                onPressed: () {
                  Navigator.of(context).push<void>(
                    MaterialPageRoute(
                      builder: (context) => const PlayScreen(),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
