import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';

import 'constants.dart';
import 'features/auth/ui/auth_widget.dart';
import 'features/game/ui/play/play_screen.dart';
import 'features/user/ui/profile_screen.dart';
import 'features/settings/ui/theme_mode_notifier.dart';
import 'features/tv/ui/tv_screen.dart';
import 'common/lichess_icons.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final brightness = ref.watch(selectedBrigthnessProvider);
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: kSupportedLocales,
      onGenerateTitle: (BuildContext context) => 'lichess.org',
      theme: ThemeData(),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      builder: (context, child) {
        return CupertinoTheme(
          data: CupertinoThemeData(
            brightness: brightness,
          ),
          child: Material(child: child),
        );
      },
      themeMode: themeMode,
      home: const ScaffoldWithBottomNavBar(),
    );
  }
}

class ScaffoldWithBottomNavBar extends StatefulWidget {
  const ScaffoldWithBottomNavBar({Key? key}) : super(key: key);

  @override
  State<ScaffoldWithBottomNavBar> createState() =>
      _ScaffoldWithBottomNavBarState();
}

class _ScaffoldWithBottomNavBarState extends State<ScaffoldWithBottomNavBar> {
  final _controller = CupertinoTabController();
  int _currentIndex = 0;

  void _onItemTapped(BuildContext context, int tabIndex) {
    // Only navigate if the tab index has changed
    if (tabIndex != _currentIndex) {
      setState(() {
        _currentIndex = tabIndex;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = [
      BottomNavigationBarItem(
        label: context.l10n.play,
        icon: const Icon(LichessIcons.chess_king),
      ),
      BottomNavigationBarItem(
        label: context.l10n.puzzles,
        icon: const Icon(LichessIcons.target),
      ),
      BottomNavigationBarItem(
        label: context.l10n.watch,
        icon: const Icon(Icons.live_tv),
      ),
      BottomNavigationBarItem(
        label: context.l10n.profile,
        icon: const Icon(CupertinoIcons.profile_circled),
      ),
    ];
    return PlatformWidget(
      androidBuilder: (BuildContext context) => _buildAndroid(context, items),
      iosBuilder: (BuildContext context) => _buildIos(context, items),
    );
  }

  Widget _buildAndroid(
      BuildContext context, List<BottomNavigationBarItem> items) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          // using CupertinoTabView here because it holds the navigation state
          CupertinoTabView(
            defaultTitle: context.l10n.play,
            builder: (context) => const PlayScreen(),
          ),
          CupertinoTabView(
            defaultTitle: context.l10n.puzzles,
            builder: (context) => const PuzzlesScreen(),
          ),
          CupertinoTabView(
            defaultTitle: context.l10n.watch,
            builder: (context) => const TvScreen(),
          ),
          CupertinoTabView(
            defaultTitle: context.l10n.profile,
            builder: (context) => const ProfileScreen(),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        items: items,
        onTap: (index) => _onItemTapped(context, index),
      ),
    );
  }

  Widget _buildIos(BuildContext context, List<BottomNavigationBarItem> items) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: items,
      ),
      controller: _controller,
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return CupertinoTabView(
              defaultTitle: context.l10n.play,
              builder: (context) => const PlayScreen(),
            );
          case 1:
            return CupertinoTabView(
              defaultTitle: context.l10n.puzzles,
              builder: (context) => const PuzzlesScreen(),
            );
          case 2:
            return CupertinoTabView(
              defaultTitle: context.l10n.watch,
              builder: (context) => const TvScreen(),
            );
          case 3:
            return CupertinoTabView(
              defaultTitle: context.l10n.profile,
              builder: (context) => const ProfileScreen(),
            );
          default:
            assert(false, 'Unexpected tab');
            return const SizedBox.shrink();
        }
      },
    );
  }
}

class PuzzlesScreen extends StatelessWidget {
  const PuzzlesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('lichess.org'), actions: const [
        AuthWidget(),
      ]),
      body: const Center(child: Text('Todo')),
    );
  }
}
