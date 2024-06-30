import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_repository.dart';
import 'package:lichess_mobile/src/model/common/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'broadcast_providers.g.dart';

@riverpod
class BroadcastPage extends _$BroadcastPage {
  @override
  int build() {
    return 1;
  }

  void next() {
    state = state + 1;
  }
}

@riverpod
class Broadcasts extends _$Broadcasts {
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
Future<IList<BroadcastGameSnapshot>> round(
  RoundRef ref,
  String broadcastRoundId,
) async {
  return ref.withClient(
    (client) => BroadcastRepository(client).getRound(broadcastRoundId),
  );
}
