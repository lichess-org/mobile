import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartchess/dartchess.dart';
import 'package:chessground/chessground.dart' as cg;

import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/common/lichess_icons.dart';
import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/utils/chessground_compat.dart';
import 'package:lichess_mobile/src/utils/async_value.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/player.dart';
import 'package:lichess_mobile/src/widgets/adaptive_action_sheet.dart';
import 'package:lichess_mobile/src/features/settings/ui/is_sound_muted_notifier.dart';
import 'package:lichess_mobile/src/features/user/model/user.dart';

import '../../data/game_repository.dart';
import '../../model/game.dart' hide Player;

final positionCursorProvider = StateProvider.autoDispose<int>((ref) => 0);

final isBoardTurnedProvider = StateProvider.autoDispose<bool>((ref) => false);

final archivedGameProvider =
    FutureProvider.autoDispose.family<ArchivedGame, GameId>((ref, id) async {
  final gameRepo = ref.watch(gameRepositoryProvider);
  final either = await gameRepo.getGameTask(id).run();
  // retry on error, cache indefinitely on success
  return either.match((error) => throw error, (data) {
    ref.keepAlive();
    return data;
  });
});

class ArchivedGameScreen extends ConsumerWidget {
  const ArchivedGameScreen(
      {required this.gameId, required this.account, super.key});

  final GameId gameId;
  final User account;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PlatformWidget(
      androidBuilder: (context) => _androidBuilder(context, ref),
      iosBuilder: (context) => _iosBuilder(context, ref),
    );
  }

  Widget _androidBuilder(BuildContext context, WidgetRef ref) {
    final isSoundMuted = ref.watch(isSoundMutedProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        actions: [
          IconButton(
              icon: isSoundMuted
                  ? const Icon(Icons.volume_off)
                  : const Icon(Icons.volume_up),
              onPressed: () =>
                  ref.read(isSoundMutedProvider.notifier).toggleSound())
        ],
      ),
      // body: _BoardBody(game: game, account: account),
      // bottomNavigationBar: _BottomBar(game: game, account: account),
    );
  }

  Widget _iosBuilder(BuildContext context, WidgetRef ref) {
    final isSoundMuted = ref.watch(isSoundMutedProvider);
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
          padding: const EdgeInsetsDirectional.only(start: 0, end: 16.0),
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
              onPressed: () =>
                  ref.read(isSoundMutedProvider.notifier).toggleSound())),
      child: SafeArea(
        child: Column(
          children: [
            // Expanded(child: _BoardBody(game: game, account: account)),
            // _BottomBar(game: game, account: account),
          ],
        ),
      ),
    );
  }
}

class _BoardBody extends ConsumerWidget {
  const _BoardBody({required this.game, required this.account});

  final ArchivedGame game;
  final User account;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    throw UnimplementedError();
  }
}

class _BottomBar extends ConsumerWidget {
  const _BottomBar({required this.game, required this.account});

  final ArchivedGame game;
  final User account;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final positionCursor = ref.watch(positionCursorProvider);

    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              _showGameMenu(context, ref);
            },
            icon: const Icon(Icons.menu),
          ),
          Row(children: [
            IconButton(
              key: const ValueKey('cursor-first'),
              // TODO add translation
              tooltip: 'First position',
              onPressed: positionCursor > 0
                  ? () {
                      ref.read(positionCursorProvider.notifier).state = 0;
                    }
                  : null,
              icon: const Icon(LichessIcons.fast_backward),
              iconSize: 20,
            ),
            IconButton(
              key: const ValueKey('cursor-back'),
              // TODO add translation
              tooltip: 'Backward',
              onPressed: positionCursor > 0
                  ? () {
                      ref.read(positionCursorProvider.notifier).state--;
                    }
                  : null,
              icon: const Icon(LichessIcons.step_backward),
              iconSize: 20,
            ),
            IconButton(
              key: const ValueKey('cursor-forward'),
              // TODO add translation
              tooltip: 'Forward',
              onPressed: positionCursor < game.steps.length
                  ? () {
                      ref.read(positionCursorProvider.notifier).state++;
                    }
                  : null,
              icon: const Icon(LichessIcons.step_forward),
              iconSize: 20,
            ),
            IconButton(
              key: const ValueKey('cursor-last'),
              // TODO add translation
              tooltip: 'Last position',
              onPressed: positionCursor < game.steps.length
                  ? () {
                      ref.read(positionCursorProvider.notifier).state =
                          game.steps.length;
                    }
                  : null,
              icon: const Icon(LichessIcons.fast_forward),
              iconSize: 20,
            ),
          ]),
        ],
      ),
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
            ref.read(isBoardTurnedProvider.notifier).state =
                !ref.read(isBoardTurnedProvider);
          },
        ),
      ],
    );
  }
}
