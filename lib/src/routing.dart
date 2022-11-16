import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/authentication/data/auth_repository.dart';
import 'features/authentication/presentation/auth_widget.dart';
import 'features/profile/presentation/profile_screen.dart';

class PuzzlesLocation extends BeamLocation<BeamState> {
  PuzzlesLocation(RouteInformation routeInformation) : super(routeInformation);

  @override
  List<String> get pathPatterns => ['/puzzles'];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) => [
        const BeamPage(
          key: ValueKey('puzzles'),
          title: 'Puzzles',
          type: BeamPageType.noTransition,
          child: PuzzlesScreen(),
        ),
      ];
}

class WatchLocation extends BeamLocation<BeamState> {
  WatchLocation(RouteInformation routeInformation) : super(routeInformation);

  @override
  List<String> get pathPatterns => ['/watch'];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) => [
        const BeamPage(
          key: ValueKey('watch'),
          title: 'Watch',
          type: BeamPageType.noTransition,
          child: WatchScreen(),
        ),
      ];
}

// --

// Temporary unimplemented screens

class PuzzlesScreen extends StatelessWidget {
  const PuzzlesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('lichess.org'), actions: const [
        AuthWidget(),
      ]),
      body: Center(child: Consumer(builder: (_, WidgetRef ref, __) {
        final authState = ref.watch(authStateChangesProvider);
        return authState.maybeWhen(
          data: (account) =>
              account != null ? Text('Hello, ${account.username}') : const Text('Hello'),
          orElse: () => const CircularProgressIndicator(),
        );
      })),
    );
  }
}

class WatchScreen extends StatelessWidget {
  const WatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watch'),
      ),
      body: const Center(child: Text('TODO')),
    );
  }
}
