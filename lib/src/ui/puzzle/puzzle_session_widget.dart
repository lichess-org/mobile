import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lichess_mobile/src/common/brightness.dart';
import 'package:lichess_mobile/src/common/lichess_colors.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_session.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_service.dart';

import 'puzzle_view_model.dart';

class PuzzleSessionWidget extends ConsumerStatefulWidget {
  const PuzzleSessionWidget({
    required this.initialPuzzleContext,
    required this.viewModelProvider,
  });

  final PuzzleContext initialPuzzleContext;
  final PuzzleViewModelProvider viewModelProvider;

  @override
  ConsumerState<PuzzleSessionWidget> createState() =>
      PuzzleSessionWidgetState();
}

class PuzzleSessionWidgetState extends ConsumerState<PuzzleSessionWidget> {
  final lastAttemptKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (lastAttemptKey.currentContext != null) {
        Scrollable.ensureVisible(
          lastAttemptKey.currentContext!,
        );
      }
    });
  }

  @override
  void didUpdateWidget(covariant PuzzleSessionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (lastAttemptKey.currentContext != null) {
        Scrollable.ensureVisible(
          lastAttemptKey.currentContext!,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(
      puzzleSessionProvider(
        widget.initialPuzzleContext.userId,
        widget.initialPuzzleContext.theme,
      ),
    );
    final puzzleState = ref.watch(widget.viewModelProvider);
    final brightness = ref.watch(currentBrightnessProvider);
    final currentAttempt = session.attempts.firstWhereOrNull(
      (a) => a.id == puzzleState.puzzle.puzzle.id,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: OrientationBuilder(
        builder: (context, orientation) {
          // some devices don't have much space around the board so let's estimate
          // how much space we can safely get to disaply 1 or 2 rows of attempts
          final mediaQueryData = MediaQuery.of(context);
          final width = mediaQueryData.size.width;
          final height = mediaQueryData.size.height;
          final padding = mediaQueryData.padding;
          final safeHeight = height - padding.top - padding.bottom;
          // viewport height - board size - app bar height - bottom bar height
          final estimatedTableHeight = (safeHeight - width - 50 - 56) / 2;
          const estimatedRatingWidgetHeight = 33.0;
          final estimatedWidgetHeight =
              estimatedTableHeight - estimatedRatingWidgetHeight;
          final maxHeight = orientation == Orientation.portrait
              ? estimatedWidgetHeight >= 60
                  ? 60.0
                  : 26.0
              : 60.0;

          return ConstrainedBox(
            constraints: BoxConstraints(minHeight: 26.0, maxHeight: maxHeight),
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                verticalDirection: VerticalDirection.up,
                children: [
                  for (final attempt in session.attempts)
                    _SessionItem(
                      isCurrent: attempt.id == puzzleState.puzzle.puzzle.id,
                      brightness: brightness,
                      attempt: attempt,
                    ),
                  if (puzzleState.mode == PuzzleMode.view ||
                      currentAttempt == null)
                    _SessionItem(
                      isCurrent: currentAttempt == null,
                      brightness: brightness,
                      key: lastAttemptKey,
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SessionItem extends StatelessWidget {
  const _SessionItem({
    this.attempt,
    required this.isCurrent,
    required this.brightness,
    super.key,
  });

  final bool isCurrent;
  final PuzzleAttempt? attempt;
  final Brightness brightness;

  Color get good => brightness == Brightness.light
      ? LichessColors.good.shade300
      : defaultTargetPlatform == TargetPlatform.iOS
          ? LichessColors.good.shade600
          : LichessColors.good.shade400;

  Color get error => brightness == Brightness.light
      ? LichessColors.error.shade300
      : defaultTargetPlatform == TargetPlatform.iOS
          ? LichessColors.error.shade600
          : LichessColors.error.shade400;

  Color get next => Colors.grey.withOpacity(0.5);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 26,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: isCurrent
            ? Colors.grey
            : attempt != null
                ? attempt!.win
                    ? good
                    : error
                : next,
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      child: attempt?.ratingDiff != null && attempt!.ratingDiff != 0
          ? Padding(
              padding: const EdgeInsets.all(2.0),
              child: FittedBox(
                fit: BoxFit.cover,
                child: Text(
                  attempt!.ratingDiffString!,
                  maxLines: 1,
                  style: const TextStyle(
                    color: Colors.white,
                    height: 1,
                  ),
                ),
              ),
            )
          : Icon(
              attempt != null
                  ? attempt!.win
                      ? Icons.check
                      : Icons.close
                  : null,
              color: Colors.white,
              size: 18,
            ),
    );
  }
}
