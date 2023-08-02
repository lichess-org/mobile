import 'dart:async';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dartchess/dartchess.dart';
import 'package:lichess_mobile/src/utils/rate_limit.dart';

import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/service/sound_service.dart';
import 'featured_position.dart';
import 'featured_player.dart';
import 'tv_event.dart';
import 'tv_repository.dart';

part 'featured_game.freezed.dart';
part 'featured_game.g.dart';

@riverpod
class FeaturedGame extends _$FeaturedGame {
  StreamSubscription<TvEvent>? _streamSub;

  final _debounceConnect = Debouncer(const Duration(seconds: 1));

  @override
  Future<FeaturedGameState> build() async {
    ref.onDispose(() => _streamSub?.cancel());

    final stream = _connectStream();

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

  void connectStream() {
    _debounceConnect(_connectStream);
  }

  Stream<TvEvent> _connectStream() {
    final tvRepository = ref.watch(tvRepositoryProvider);
    final stream = tvRepository.tvFeed().asBroadcastStream();

    _streamSub?.cancel();
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
    state.maybeWhen(
      data: (game) {
        state = AsyncData(
          game.copyWith(
            position: FeaturedPosition.fromTvEvent(event),
          ),
        );

        ref.read(soundServiceProvider).play(Sound.move);
      },
      orElse: () => ref.invalidateSelf(),
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
