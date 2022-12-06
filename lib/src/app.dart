import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';

import 'constants.dart';

import 'features/auth/ui/auth_widget.dart';
import 'features/game/ui/play/screen.dart';
import 'features/settings/ui/settings_screen.dart';
import 'features/settings/ui/theme_mode_screen.dart';
import 'features/settings/ui/theme_mode_notifier.dart';
import 'features/tv/ui/tv_screen.dart';
import 'common/lichess_icons.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    return MaterialApp.router(
      restorationScopeId: 'app',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: kSupportedLocales,
      onGenerateTitle: (BuildContext context) => 'lichess.org',
      theme: ThemeData(
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: themeMode,
      routerConfig: goRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}

// private navigators
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final goRouter = GoRouter(
  initialLocation: '/play',
  navigatorKey: _rootNavigatorKey,
  debugLogDiagnostics: true,
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return ScaffoldWithBottomNavBar(child: child);
      },
      routes: [
        GoRoute(
          path: '/play',
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: const PlayScreen(),
          ),
        ),
        GoRoute(
          path: '/puzzles',
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: const PuzzlesScreen(),
          ),
        ),
        GoRoute(
          path: '/watch',
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: const TvScreen(),
          ),
        ),
        GoRoute(
          path: '/settings',
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: const SettingsScreen(),
          ),
          routes: [
            GoRoute(
              path: 'themeMode',
              builder: (context, state) => const ThemeModeScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);

class ScaffoldWithBottomNavBar extends StatefulWidget {
  const ScaffoldWithBottomNavBar({Key? key, required this.child})
      : super(key: key);
  final Widget child;

  @override
  State<ScaffoldWithBottomNavBar> createState() =>
      _ScaffoldWithBottomNavBarState();
}

class _ScaffoldWithBottomNavBarState extends State<ScaffoldWithBottomNavBar> {
  final tabs = const [
    '/play',
    '/puzzles',
    '/watch',
    '/settings',
  ];

  int _locationToTabIndex(String location) {
    final index = tabs.indexWhere((t) => location.startsWith(t));
    // if index not found (-1), return 0
    return index < 0 ? 0 : index;
  }

  int get _currentIndex => _locationToTabIndex(GoRouter.of(context).location);

  void _onItemTapped(BuildContext context, int tabIndex) {
    // Only navigate if the tab index has changed
    if (tabIndex != _currentIndex) {
      context.go(tabs[tabIndex]);
    }
  }

  @override
  Widget build(BuildContext context) {
    const icons = {
      '/play': Icon(LichessIcons.chess_king),
      '/puzzles': Icon(LichessIcons.target),
      '/watch': Icon(Icons.live_tv),
      '/settings': Icon(Icons.settings),
    };
    final labels = {
      '/play': context.l10n.play,
      '/puzzles': context.l10n.puzzles,
      '/watch': context.l10n.watch,
      '/settings': context.l10n.settings,
    };
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: kOrange,
        currentIndex: _currentIndex,
        items: <BottomNavigationBarItem>[
          for (final tab in tabs)
            BottomNavigationBarItem(
              icon: icons[tab]!,
              label: labels[tab]!,
            )
        ],
        onTap: (index) => _onItemTapped(context, index),
      ),
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
