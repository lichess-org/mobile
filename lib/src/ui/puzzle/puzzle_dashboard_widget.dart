import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_providers.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform_card.dart';

class PuzzleDashboardWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final puzzleDashboard = ref.watch(puzzleDashboardProvider);

    return puzzleDashboard.when(
      data: (data) {
        return ListSection(
          header: const Text('Puzzle Dashboard'),
          children: [
            CustomPlatformCardRow([
              CustomPlatformCard(
                'Performance',
                value: data.global.performance.toString(),
              ),
              CustomPlatformCard(
                'Nb',
                value: data.global.nb.toString(),
              ),
              CustomPlatformCard(
                'First Wins',
                value: data.global.firstWins.toString(),
              ),
              CustomPlatformCard(
                'Replay Wins',
                value: data.global.replayWins.toString(),
              ),
            ]),
          ],
        );
      },
      error: (e, s) {
        debugPrint(
          'SEVERE: [PuzzleDashboardWidget] could not load puzzle dashboard; $e\n$s',
        );
        return const Text('Error');
      },
      loading: () => const CircularProgressIndicator(),
    );
  }
}
