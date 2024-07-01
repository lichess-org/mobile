import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_repository.dart';
import 'package:lichess_mobile/src/model/common/http.dart';
import 'package:lichess_mobile/src/model/common/node.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'broadcast_providers.g.dart';

@riverpod
class BroadcastPage extends _$BroadcastPage {
  @override
  int build() {
    return 1;
  }

  void next() {
    if (state < 20) {
      // 20 is the last page
      state = state + 1;
    }
  }
}

@riverpod
class BroadcastsList extends _$BroadcastsList {
  @override
  Future<BroadcastResponse> build() async {
    final page = ref.watch(broadcastPageProvider);

    final broadcastResponse = await ref.withClient(
      (client) => BroadcastRepository(client).getBroadcasts(page: page),
    );

    if (page == 1) {
      return broadcastResponse;
    } else {
      return state.requireValue.copyWith(
        past: state.requireValue.past.addAll(broadcastResponse.past),
      );
    }
  }
}

@riverpod
Future<IList<BroadcastGameSnapshot>> broadcastRound(
  BroadcastRoundRef ref,
  String broadcastRoundId,
) {
  return ref.withClient(
    (client) => BroadcastRepository(client).getRound(broadcastRoundId),
  );
}

@riverpod
class BroadcastRoundBoards extends _$BroadcastRoundBoards {
  @override
  Future<IList<BroadcastGameSnapshot>> build(String broadcastRoundId) async {
    final allGames =
        await ref.watch(broadcastRoundProvider(broadcastRoundId).future);

    final stream = ref.withClientStream(
      (client) => BroadcastRepository(client).getRoundStream(broadcastRoundId),
    );

    final subscription = stream.listen(_handleNewPgn);

    ref.onDispose(() {
      subscription.cancel();
    });

    return allGames;
  }

  void _handleNewPgn(PgnGame pgn) {
    final playerNameWhite = pgn.headers['White'];
    final playerNameBlack = pgn.headers['Black'];

    if (!state.hasValue) {
      return;
    }

    final index = state.requireValue.indexWhere(
      (game) =>
          game.players[0].name == playerNameWhite &&
          game.players[1].name == playerNameBlack,
    );

    if (index == -1) {
      return;
    }

    state = AsyncData(
      state.requireValue.replace(
        index,
        state.requireValue[index].copyWith(
          pgn: pgn,
          lastMove: Root.fromPgnGame(pgn).mainline.lastOrNull?.sanMove.move,
        ),
      ),
    );
  }
}
