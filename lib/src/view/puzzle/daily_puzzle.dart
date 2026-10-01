import 'package:dartchess/dartchess.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_angle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_providers.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';
import 'package:lichess_mobile/src/network/connectivity.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/string.dart';
import 'package:lichess_mobile/src/view/puzzle/puzzle_screen.dart';
import 'package:lichess_mobile/src/widgets/board_preview.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';
import 'package:material_ui/material_ui.dart';

TextStyle _puzzlePreviewSubtitleStyle(BuildContext context) {
  return TextStyle(
    fontSize: 14.0,
    color: DefaultTextStyle.of(context).style.color?.withValues(alpha: 0.6),
  );
}

/// A widget that displays the daily puzzle.
class const DailyPuzzle({final VoidCallback? onBeforeOpen, super.key}) extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOnline = ref.watch(isDeviceOnlineProvider);
    final puzzle = ref.watch(dailyPuzzleProvider);

    return puzzle.when(
      data: (data) {
        final preview = PuzzlePreview.fromPuzzle(data);
        return SmallBoardPreview(
          orientation: preview.orientation,
          fen: preview.initialFen,
          lastMove: preview.initialMove,
          description: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.l10n.puzzlePuzzleOfTheDay, style: Styles.boardPreviewTitle),
                  Text(
                    context.l10n.puzzlePlayedXTimes(data.puzzle.plays).localizeNumbers(),
                    style: _puzzlePreviewSubtitleStyle(context),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.today,
                    size: 32,
                    color: context.lichessColors.brag.withValues(alpha: 0.7),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      data.puzzle.sideToMove == Side.white
                          ? context.l10n.whitePlays
                          : context.l10n.blackPlays,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: textShade(context, 0.8)),
                    ),
                  ),
                ],
              ),
            ],
          ),
          onTap: () {
            if (!context.mounted) return;
            onBeforeOpen?.call();
            Navigator.of(context, rootNavigator: true).push(
              PuzzleScreen.buildRoute(angle: const PuzzleTheme(PuzzleThemeKey.mix), puzzle: data),
            );
          },
        );
      },
      loading: () => isOnline
          ? const Shimmer(
              child: ShimmerLoading(isLoading: true, child: SmallBoardPreview.loading()),
            )
          : const SizedBox.shrink(),
      error: (error, _) {
        return isOnline
            ? const Padding(
                padding: Styles.bodySectionPadding,
                child: Text('Could not load the daily puzzle.'),
              )
            : const SizedBox.shrink();
      },
    );
  }
}
