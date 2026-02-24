import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_providers.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:logging/logging.dart';

final _logger = Logger('HomeWidgetService');

const _kAppGroupId = 'group.org.lichess.mobileV2';
const _kIOSWidgetName = 'DailyPuzzleWidget';
const _kAndroidWidgetName = 'DailyPuzzleWidgetReceiver';

const _kPuzzleIdKey = 'puzzle_id';
const _kPuzzleFenKey = 'puzzle_fen';
const _kPuzzleSideToMoveKey = 'puzzle_side_to_move';
const _kPuzzlePlaysKey = 'puzzle_plays';
const _kBoardImageKey = 'puzzle_board_image';

/// Provider for the [HomeWidgetService].
final homeWidgetServiceProvider = Provider<HomeWidgetService>((Ref ref) {
  return HomeWidgetService(ref);
});

/// Service that keeps the home screen widget updated with the daily puzzle.
class HomeWidgetService {
  HomeWidgetService(this._ref);

  final Ref _ref;

  void start() {
    HomeWidget.setAppGroupId(_kAppGroupId);

    _ref.listen<AsyncValue<Puzzle>>(dailyPuzzleProvider, (_, AsyncValue<Puzzle> next) {
      if (next case AsyncData(value: final puzzle)) {
        _updateWidget(puzzle);
      }
    });

    _ref.listen<BoardPrefs>(boardPreferencesProvider, (BoardPrefs? prev, BoardPrefs next) {
      if (prev?.pieceSet != next.pieceSet ||
          prev?.boardTheme != next.boardTheme ||
          prev?.brightness != next.brightness ||
          prev?.hue != next.hue) {
        // Re-render the board image with new board settings
        final puzzleState = _ref.read(dailyPuzzleProvider);
        if (puzzleState case AsyncData(value: final puzzle)) {
          _updateWidget(puzzle);
        }
      }
    });
  }

  Future<void> _updateWidget(Puzzle puzzle) async {
    try {
      final preview = PuzzlePreview.fromPuzzle(puzzle);
      final boardPrefs = _ref.read(boardPreferencesProvider);

      // Save puzzle metadata
      await Future.wait<void>([
        HomeWidget.saveWidgetData<String>(_kPuzzleIdKey, puzzle.puzzle.id.value),
        HomeWidget.saveWidgetData<String>(_kPuzzleFenKey, preview.initialFen),
        HomeWidget.saveWidgetData<String>(
          _kPuzzleSideToMoveKey,
          puzzle.puzzle.sideToMove == Side.white ? 'white' : 'black',
        ),
        HomeWidget.saveWidgetData<int>(_kPuzzlePlaysKey, puzzle.puzzle.plays),
      ]);

      // Render the board as an image
      await HomeWidget.renderFlutterWidget(
        StaticChessboard(
          size: 360.0,
          fen: preview.initialFen,
          orientation: preview.orientation,
          lastMove: preview.initialMove,
          enableCoordinates: false,
          pieceAssets: boardPrefs.pieceSet.assets,
          colorScheme: boardPrefs.boardTheme.colors,
          brightness: boardPrefs.brightness,
          hue: boardPrefs.hue,
        ),
        key: _kBoardImageKey,
        logicalSize: const Size(360, 360),
      );

      // Trigger native widget update
      await HomeWidget.updateWidget(iOSName: _kIOSWidgetName, androidName: _kAndroidWidgetName);

      _logger.info('Home widget updated for puzzle ${puzzle.puzzle.id}');
    } catch (e, st) {
      _logger.warning('Failed to update home widget', e, st);
    }
  }
}
