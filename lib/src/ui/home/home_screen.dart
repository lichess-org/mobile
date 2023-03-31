import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartchess/dartchess.dart';

import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/common/styles.dart';
import 'package:lichess_mobile/src/common/connectivity.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/chessground_compat.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/widgets/board_preview.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_service.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_providers.dart';
import 'package:lichess_mobile/src/model/user/user_repository_providers.dart';
import 'package:lichess_mobile/src/ui/auth/sign_in_widget.dart';
import 'package:lichess_mobile/src/ui/puzzle/puzzle_screen.dart';
import 'package:lichess_mobile/src/ui/user/leaderboard_widget.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _androidRefreshKey = GlobalKey<RefreshIndicatorState>();

  bool isOnline = true;

  @override
  Widget build(BuildContext context) {
    ref.listen(connectivityChangesProvider, (_, connectivity) {
      // Refresh the data only when the user comes back online
      if (!connectivity.isRefreshing && connectivity.hasValue) {
        final newOnlineValue = connectivity.value!.isOnline;

        if (isOnline == false && newOnlineValue == true) {
          _refreshData();
        }

        isOnline = newOnlineValue;
      }
    });

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
      body: RefreshIndicator(
        key: _androidRefreshKey,
        onRefresh: _refreshData,
        child: const _HomeScaffold(
          child: _HomeBody(),
        ),
      ),
    );
  }

  Widget _iosBuilder(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: [
          const CupertinoSliverNavigationBar(
            largeTitle: Text('Home'),
            trailing: SignInWidget(),
          ),
          CupertinoSliverRefreshControl(
            onRefresh: _refreshData,
          ),
          const SliverToBoxAdapter(child: _ConnectivityBanner()),
          const SliverSafeArea(
            top: false,
            sliver: _HomeBody(),
          ),
        ],
      ),
    );
  }

  Future<void> _refreshData() {
    return ref.refresh(top1Provider.future);
  }
}

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
          const _ConnectivityBanner(),
          Expanded(
            child: child,
          ),
        ],
      ),
    );
  }
}

class _HomeBody extends ConsumerWidget {
  const _HomeBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivity = ref.watch(connectivityChangesProvider);
    return connectivity.when(
      data: (data) {
        if (data.isOnline) {
          return defaultTargetPlatform == TargetPlatform.android
              ? ListView(
                  children: [
                    const _DailyPuzzle(),
                    LeaderboardWidget(),
                  ],
                )
              : SliverList(
                  delegate: SliverChildListDelegate([
                    const _DailyPuzzle(),
                    LeaderboardWidget(),
                  ]),
                );
        } else {
          return defaultTargetPlatform == TargetPlatform.android
              ? ListView(
                  children: const [
                    _OfflinePuzzlePreview(),
                  ],
                )
              : SliverList(
                  delegate: SliverChildListDelegate([
                    const _OfflinePuzzlePreview(),
                  ]),
                );
        }
      },
      loading: () {
        const child = CenterLoadingIndicator();
        return defaultTargetPlatform == TargetPlatform.android
            ? child
            : const SliverToBoxAdapter(child: child);
      },
      error: (error, stack) {
        const child = SizedBox.shrink();
        return defaultTargetPlatform == TargetPlatform.android
            ? child
            : const SliverToBoxAdapter(child: child);
      },
    );
  }
}

class _ConnectivityBanner extends ConsumerWidget {
  const _ConnectivityBanner();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivity = ref.watch(connectivityChangesProvider);
    final themeData = CupertinoTheme.of(context);
    return connectivity.when(
      data: (data) {
        if (data.isOnline) {
          return const SizedBox.shrink();
        }
        return Container(
          height: 45,
          color: themeData.barBackgroundColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.report, color: themeData.textTheme.textStyle.color),
                const SizedBox(width: 5),
                const Flexible(
                  child: Text(
                    'Network connectivity unavailable.',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (error, stack) => const SizedBox.shrink(),
    );
  }
}

class _DailyPuzzle extends ConsumerWidget {
  const _DailyPuzzle();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final puzzle = ref.watch(dailyPuzzleProvider);
    return puzzle.when(
      data: (data) {
        final preview = PuzzlePreview.fromPuzzle(data);
        return BoardPreview(
          orientation: preview.orientation.cg,
          fen: preview.initialFen,
          lastMove: preview.initialMove.cg,
          header: Text(context.l10n.puzzleDailyPuzzle),
          onTap: () {
            final session = ref.read(authSessionProvider);
            pushPlatformRoute(
              context,
              rootNavigator: true,
              builder: (context) => PuzzleScreen(
                theme: PuzzleTheme.mix,
                initialPuzzleContext: PuzzleContext(
                  theme: PuzzleTheme.mix,
                  puzzle: data,
                  userId: session?.user.id,
                ),
              ),
            ).then((_) {
              ref.invalidate(nextPuzzleProvider(PuzzleTheme.mix));
            });
          },
        );
      },
      loading: () => BoardPreview(
        orientation: Side.white.cg,
        fen: kEmptyFen,
        header: Text(context.l10n.puzzleDailyPuzzle),
      ),
      error: (error, stack) => Padding(
        padding: Styles.bodySectionPadding,
        child: const Text('Could not load the daily puzzle.'),
      ),
    );
  }
}

class _OfflinePuzzlePreview extends ConsumerWidget {
  const _OfflinePuzzlePreview();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final puzzle = ref.watch(nextPuzzleProvider(PuzzleTheme.mix));
    return puzzle.when(
      data: (data) {
        final preview =
            data != null ? PuzzlePreview.fromPuzzle(data.puzzle) : null;
        return BoardPreview(
          orientation: preview?.orientation.cg ?? Side.white.cg,
          fen: preview?.initialFen ?? kEmptyFen,
          lastMove: preview?.initialMove.cg,
          header: Text(context.l10n.puzzles),
          errorMessage: data == null
              ? 'No offline puzzles available. Go online to get more puzzles.'
              : null,
          onTap: data != null
              ? () {
                  pushPlatformRoute(
                    context,
                    rootNavigator: true,
                    builder: (context) => PuzzleScreen(
                      theme: PuzzleTheme.mix,
                      initialPuzzleContext: data,
                    ),
                  ).then((_) {
                    ref.invalidate(nextPuzzleProvider(PuzzleTheme.mix));
                  });
                }
              : null,
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Padding(
        padding: Styles.bodySectionPadding,
        child: const Text('Could not load offline puzzles.'),
      ),
    );
  }
}
