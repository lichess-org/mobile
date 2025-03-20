import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/user/leaderboard.dart';
import 'package:lichess_mobile/src/model/user/user_repository_providers.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/user/leaderboard_screen.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';

/// Create a leaderboard list of the highest rated player for each perf.

class LeaderboardWidget extends ConsumerStatefulWidget {
  final int index;

  const LeaderboardWidget({super.key, required this.index});

  @override
  ConsumerState<LeaderboardWidget> createState() => _LeaderboardWidgetState();
}

class _LeaderboardWidgetState extends ConsumerState<LeaderboardWidget> {
  // Store the previous index to detect changes
  late int previousIndex = widget.index;

  @override
  void didUpdateWidget(LeaderboardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Force refresh when index changes
    if (oldWidget.index != widget.index) {
      previousIndex = widget.index;
      // Invalidate providers or force rebuild
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    // Access the current index from widget directly
    final currentIndex = widget.index;

    // Watch the top1Provider
    // final leaderboardState = ref.watch(top1Provider);
    final leaderboard = ref.watch(leaderboardProvider);

    return leaderboard.when(
      data: (data) {
        // Filter data based on current index
        List<LeaderboardUser> filteredData = [];

        if (currentIndex == 0) {
          filteredData = data.bullet.take(10).toList();
        } else if (currentIndex == 1) {
          filteredData = data.rapid.take(10).toList();
        }

        // Map.fromEntries(
        // data.entries.where((entry) {
        //   if (currentIndex == 0) {
        //     return
        //     entry.key.icon == Perf.bullet.icon;
        //   } else if (currentIndex == 1) {
        //     return entry.key.icon == Perf.rapid.icon;
        //   }
        //   return false;
        // }),
        // );

        // Return empty container if no data matches the index
        if (filteredData.isEmpty) {
          return const SizedBox.shrink();
        }

        return SingleChildScrollView(
          child: ListSection(
            backgroundColor: Color(0xff2B2D30),
            hasLeading: true,
            header: const Text('World Rank'),
            headerTrailing: NoPaddingTextButton(
              onPressed: () {
                Navigator.of(context).push(LeaderboardScreen.buildRoute(context));
              },
              child: Container(
                height: 36,
                width: 36, 
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white10),
                ),
                child: Icon(Icons.north_east,color: Colors.white,),
              ),
              // Text(context.l10n.more),
            ),
            children: [
              for (final (index, entry) in filteredData.indexed)
                LeaderboardListTile(
                  index: index + 1,
                  user: entry,
                  perfIcon: currentIndex == 0 ? Perf.bullet.icon : Perf.rapid.icon,
                ),
            ],
          ),
        );
      },
      error: (error, stackTrace) {
        debugPrint(
          'SEVERE: [LeaderboardWidget] could not lead leaderboard data; $error\n $stackTrace',
        );
        return const Padding(
          padding: Styles.bodySectionPadding,
          child: Text('Could not load leaderboard.'),
        );
      },
      loading:
          () => Shimmer(
            child: ShimmerLoading(
              isLoading: true,
              child: ListSection.loading(itemsNumber: 5, header: true, hasLeading: true),
            ),
          ),
    );
  }
}
