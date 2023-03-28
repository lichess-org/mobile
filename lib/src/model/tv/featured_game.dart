import 'dart:async';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dartchess/dartchess.dart';

import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/common/sound_service.dart';
import 'featured_position.dart';
import 'featured_player.dart';
import 'tv_event.dart';
import 'tv_repository.dart';

part 'featured_game.freezed.dart';
part 'featured_game.g.dart';

@riverpod
class FeaturedGame extends _$FeaturedGame {
  StreamSubscription<TvEvent>? _streamSub;

  @override
  Future<FeaturedGameState> build({required bool withSound}) async {
    final stream = connectStream();

    ref.onDispose(() => _streamSub?.cancel());

    return stream.firstWhere((event) => event is TvFeaturedEvent).then(
      (event) {
        final featuredEvent = event as TvFeaturedEvent;
        return FeaturedGameState(
          id: featuredEvent.id,
          orientation: featuredEvent.orientation,
          initialFen: featuredEvent.fen,
          white: featuredEvent.white,
          black: featuredEvent.black,
          position: FeaturedPosition.fromTvEvent(featuredEvent),
        );
      },
    );
  }

  Stream<TvEvent> connectStream() {
    final tvRepository = ref.watch(tvRepositoryProvider);
    final stream = tvRepository.tvFeed().asBroadcastStream();

    _streamSub = stream.listen((event) {
      if (event is TvFeaturedEvent) {
        _onFeaturedEvent(event);
      } else if (event is TvFenEvent) {
        _onFenEvent(event);
      }
    });

    return stream;
  }

  void disconnectStream() {
    _streamSub?.cancel();
  }

  void _onFeaturedEvent(TvFeaturedEvent event) {
    state = AsyncData(
      FeaturedGameState(
        id: event.id,
        orientation: event.orientation,
        initialFen: event.fen,
        white: event.white,
        black: event.black,
        position: FeaturedPosition.fromTvEvent(event),
      ),
    );
  }

  void _onFenEvent(TvFenEvent event) {
    if (withSound) {
      ref.read(soundServiceProvider).playMove();
    }
    // TvFeaturedEvent is always emitted first so we can safely assume that
    // at this point the state is loaded.
    final game = state.requireValue;
    state = AsyncData(
      game.copyWith(
        white: game.white.withSeconds(event.whiteSeconds),
        black: game.black.withSeconds(event.whiteSeconds),
        position: FeaturedPosition.fromTvEvent(event),
      ),
    );
  }
}

@freezed
class FeaturedGameState with _$FeaturedGameState {
  const factory FeaturedGameState({
    required GameId id,
    required Side orientation,
    required String initialFen,
    required FeaturedPlayer white,
    required FeaturedPlayer black,
    required FeaturedPosition position,
  }) = _FeaturedGameState;
}
