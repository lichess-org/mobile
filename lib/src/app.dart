import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';

import 'constants.dart';

import 'features/auth/ui/auth_widget.dart';
import 'features/game/ui/play/play_screen.dart';
import 'features/settings/ui/settings_screen.dart';
import 'features/user/ui/profile_screen.dart';
import 'features/settings/ui/theme_mode_screen.dart';
import 'features/settings/ui/theme_mode_notifier.dart';
import 'features/tv/ui/tv_screen.dart';
import 'common/lichess_icons.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final brightness = ref.watch(selectedBrigthnessProvider);
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return MaterialApp(
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
          home: const ScaffoldWithBottomNavBar(),
        );
      case TargetPlatform.iOS:
        return CupertinoApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: kSupportedLocales,
          onGenerateTitle: (BuildContext context) => 'lichess.org',
          theme: CupertinoThemeData(
            brightness: brightness,
          ),
          home: const ScaffoldWithBottomNavBar(),
        );
      default:
        assert(false, 'Unexpected platform $defaultTargetPlatform');
        return const SizedBox.shrink();
    }
  }
}

// private navigators
// final _rootNavigatorKey = GlobalKey<NavigatorState>();
// final _shellNavigatorKey = GlobalKey<NavigatorState>();

// final goRouter = GoRouter(
//   initialLocation: '/play',
//   navigatorKey: _rootNavigatorKey,
//   debugLogDiagnostics: true,
//   routes: [
//     ShellRoute(
//       navigatorKey: _shellNavigatorKey,
//       builder: (context, state, child) {
//         return ScaffoldWithBottomNavBar(child: child);
//       },
//       routes: [
//         GoRoute(
//           path: '/play',
//           pageBuilder: (context, state) => NoTransitionPage(
//             key: state.pageKey,
//             child: const PlayScreen(),
//           ),
//         ),
//         GoRoute(
//           path: '/puzzles',
//           pageBuilder: (context, state) => NoTransitionPage(
//             key: state.pageKey,
//             child: const PuzzlesScreen(),
//           ),
//         ),
//         GoRoute(
//           path: '/watch',
//           pageBuilder: (context, state) => NoTransitionPage(
//             key: state.pageKey,
//             child: const TvScreen(),
//           ),
//         ),
//         GoRoute(
//           path: '/profile',
//           pageBuilder: (context, state) => NoTransitionPage(
//             key: state.pageKey,
//             child: ProfileScreen(),
//           ),
//         ),
//         GoRoute(
//           path: '/settings',
//           pageBuilder: (context, state) => NoTransitionPage(
//             key: state.pageKey,
//             child: const SettingsScreen(),
//           ),
//           routes: [
//             GoRoute(
//               path: 'themeMode',
//               builder: (context, state) => const ThemeModeScreen(),
//             ),
//           ],
//         ),
//       ],
//     ),
//   ],
// );

class ScaffoldWithBottomNavBar extends StatefulWidget {
  const ScaffoldWithBottomNavBar({Key? key}) : super(key: key);

  @override
  State<ScaffoldWithBottomNavBar> createState() =>
      _ScaffoldWithBottomNavBarState();
}

class _ScaffoldWithBottomNavBarState extends State<ScaffoldWithBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: [
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
            icon: const Icon(Icons.person),
          ),
        ],
      ),
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
