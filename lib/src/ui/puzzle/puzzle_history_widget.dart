import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_providers.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';
import 'package:lichess_mobile/src/model/auth/user_session.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';

import 'puzzle_history_screen.dart';

class PuzzleHistoryWidget extends ConsumerWidget {
  const PuzzleHistoryWidget(this.session);

  final UserSession? session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(recentPuzzleHistoryProvider);
    return history.when(
      data: (data) {
        if (data == null || data.isEmpty) {
          return const SizedBox.shrink();
        }
        return ListSection(
          header: Text(context.l10n.puzzleHistory),
          headerTrailing: NoPaddingTextButton(
            onPressed: () {
              pushPlatformRoute(
                context,
                builder: (ctx) => HistoryScreen(data, session),
              );
            },
            child: Text(
              context.l10n.more,
            ),
          ),
          children: data
              .map(
                (e) => HistoryColumn(
                  e,
                  sectionMargin: const EdgeInsets.all(10),
                ),
              )
              .toList(),
        );
      },
      error: (e, s) {
        debugPrint(
          'SEVERE: [PuzzleHistoryWidget] could not load next Puzzle; $e\n$s',
        );
        return const Center(child: Text('Could not load Puzzle History'));
      },
      loading: () => Shimmer(
        child: ShimmerLoading(
          isLoading: true,
          child: ListSection.loading(
            itemsNumber: 10,
            header: true,
          ),
        ),
      ),
    );
  }
}
