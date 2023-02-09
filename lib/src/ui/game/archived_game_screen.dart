import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartchess/dartchess.dart';
import 'package:result_extensions/result_extensions.dart';
import 'package:chessground/chessground.dart' as cg;
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/common/lichess_icons.dart';
import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/utils/chessground_compat.dart';
import 'package:lichess_mobile/src/widgets/game_board_layout.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/player.dart';
import 'package:lichess_mobile/src/widgets/adaptive_action_sheet.dart';
import 'package:lichess_mobile/src/model/settings/providers.dart';
import 'package:lichess_mobile/src/model/game/game_repository.dart';
import 'package:lichess_mobile/src/model/game/game.dart';

final _positionCursorProvider = StateProvider.autoDispose<int?>((ref) => null);

final _isBoardTurnedProvider = StateProvider.autoDispose<bool>((ref) => false);

final archivedGameProvider =
    FutureProvider.autoDispose.family<ArchivedGame, GameId>((ref, id) async {
  final gameRepo = ref.watch(gameRepositoryProvider);
  final result = await gameRepo.getGame(id);
  return result.fold(
    (data) {
      ref
          .read(_positionCursorProvider.notifier)
          .update((_) => data.steps.length - 1);
      return data;
    },
    (error, _) {
      throw error;
    },
  );
});

class ArchivedGameScreen extends ConsumerWidget {
  const ArchivedGameScreen({
    required this.gameData,
    required this.orientation,
    super.key,
  });

  final ArchivedGameData gameData;
  final Side orientation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ConsumerPlatformWidget(
      ref: ref,
      androidBuilder: _androidBuilder,
      iosBuilder: _iosBuilder,
    );
  }

  Widget _androidBuilder(BuildContext context, WidgetRef ref) {
    final isSoundMuted = ref.watch(muteSoundSettingProvider);
    final ArchivedGame? archivedGame =
        ref.watch(archivedGameProvider(gameData.id)).asData?.value;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: isSoundMuted
                ? const Icon(Icons.volume_off)
                : const Icon(Icons.volume_up),
            onPressed: () =>
                ref.read(muteSoundSettingProvider.notifier).toggle(),
          )
        ],
      ),
      body: _BoardBody(
        gameData: gameData,
        game: archivedGame,
        orientation: orientation,
      ),
      bottomNavigationBar:
          _BottomBar(gameData: gameData, steps: archivedGame?.steps),
    );
  }

  Widget _iosBuilder(BuildContext context, WidgetRef ref) {
    final isSoundMuted = ref.watch(muteSoundSettingProvider);
    final ArchivedGame? archivedGame =
        ref.watch(archivedGameProvider(gameData.id)).asData?.value;
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        padding: const EdgeInsetsDirectional.only(end: 16.0),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Icon(CupertinoIcons.back),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: isSoundMuted
              ? const Icon(CupertinoIcons.volume_off)
              : const Icon(CupertinoIcons.volume_up),
          onPressed: () => ref.read(muteSoundSettingProvider.notifier).toggle(),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _BoardBody(
                gameData: gameData,
                game: archivedGame,
                orientation: orientation,
              ),
            ),
            _BottomBar(gameData: gameData, steps: archivedGame?.steps),
          ],
        ),
      ),
    );
  }
}

class _BoardBody extends ConsumerWidget {
  const _BoardBody({
    required this.gameData,
    this.game,
    required this.orientation,
  });

  final ArchivedGameData gameData;
  final ArchivedGame? game;
  final Side orientation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBoardTurned = ref.watch(_isBoardTurnedProvider);
    final positionCursor = ref.watch(_positionCursorProvider);
    final black = BoardPlayer(
      key: const ValueKey('black-player'),
      name: gameData.black.name,
      rating: gameData.black.rating,
      title: gameData.black.title,
      active: false,
      clock: positionCursor != null
          ? game?.blackClockAt(positionCursor)
          : game?.clock?.initial,
    );
    final white = BoardPlayer(
      key: const ValueKey('white-player'),
      name: gameData.white.name,
      rating: gameData.white.rating,
      title: gameData.white.title,
      active: false,
      clock: positionCursor != null
          ? game?.whiteClockAt(positionCursor)
          : game?.clock?.initial,
    );
    final topPlayer = orientation == Side.white ? black : white;
    final bottomPlayer = orientation == Side.white ? white : black;

    return GameBoardLayout(
      boardData: cg.BoardData(
        interactableSide: cg.InteractableSide.none,
        orientation: (isBoardTurned ? orientation.opposite : orientation).cg,
        fen: game?.fenAt(positionCursor ?? 0) ??
            gameData.lastFen ??
            kInitialBoardFEN,
        lastMove: (positionCursor != null
                ? game?.moveAt(positionCursor)
                : game?.lastMove)
            ?.cg,
      ),
      topPlayer: topPlayer,
      bottomPlayer: bottomPlayer,
      moves: game?.steps.map((e) => e.san).toList(growable: false),
      currentMoveIndex: positionCursor,
      onSelectMove: (moveIndex) {
        ref.read(_positionCursorProvider.notifier).state = moveIndex;
      },
    );
  }
}

final _canGoForwardProvider =
    Provider.autoDispose.family<bool, int?>((ref, stepsLength) {
  final positionCursor = ref.watch(_positionCursorProvider);
  return stepsLength != null &&
      positionCursor != null &&
      positionCursor < stepsLength - 1;
});

final _canGoBackwardProvider = Provider.autoDispose<bool>((ref) {
  final positionCursor = ref.watch(_positionCursorProvider);
  return positionCursor != null && positionCursor > 0;
});

class _BottomBar extends ConsumerWidget {
  const _BottomBar({required this.gameData, this.steps});

  final ArchivedGameData gameData;
  final IList<GameStep>? steps;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canGoForward = ref.watch(_canGoForwardProvider(steps?.length));
    final canGoBackward = ref.watch(_canGoBackwardProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            _showGameMenu(context, ref);
          },
          icon: const Icon(Icons.menu),
        ),
        Row(
          children: [
            IconButton(
              key: const ValueKey('cursor-first'),
              // TODO add translation
              tooltip: 'First position',
              onPressed: canGoBackward
                  ? () {
                      ref.read(_positionCursorProvider.notifier).state = 0;
                    }
                  : null,
              icon: const Icon(LichessIcons.fast_backward),
              iconSize: 20,
            ),
            IconButton(
              key: const ValueKey('cursor-back'),
              // TODO add translation
              tooltip: 'Backward',
              onPressed: canGoBackward
                  ? () {
                      ref
                          .read(_positionCursorProvider.notifier)
                          .update((state) {
                        if (state != null) {
                          state--;
                        }
                        return state;
                      });
                    }
                  : null,
              icon: const Icon(LichessIcons.step_backward),
              iconSize: 20,
            ),
            IconButton(
              key: const ValueKey('cursor-forward'),
              // TODO add translation
              tooltip: 'Forward',
              onPressed: canGoForward
                  ? () {
                      ref
                          .read(_positionCursorProvider.notifier)
                          .update((state) {
                        if (state != null) {
                          state++;
                        }
                        return state;
                      });
                    }
                  : null,
              icon: const Icon(LichessIcons.step_forward),
              iconSize: 20,
            ),
            IconButton(
              key: const ValueKey('cursor-last'),
              // TODO add translation
              tooltip: 'Last position',
              onPressed: canGoForward
                  ? () {
                      ref.read(_positionCursorProvider.notifier).state =
                          steps!.length - 1;
                    }
                  : null,
              icon: const Icon(LichessIcons.fast_forward),
              iconSize: 20,
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _showGameMenu(BuildContext context, WidgetRef ref) {
    return showAdaptiveActionSheet(
      context: context,
      actions: [
        BottomSheetAction(
          leading: const Icon(Icons.swap_vert),
          label: Text(context.l10n.flipBoard),
          onPressed: (context) {
            ref.read(_isBoardTurnedProvider.notifier).state =
                !ref.read(_isBoardTurnedProvider);
          },
        ),
      ],
    );
  }
}
