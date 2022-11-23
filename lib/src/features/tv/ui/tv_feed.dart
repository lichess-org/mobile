import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chessground/chessground.dart' as cg;
import 'package:dartchess/dartchess.dart';

import '../domain/stream_event.dart';
import '../domain/featured_player.dart';
import '../data/tv_repository.dart';

@immutable
class TvFeedState {
  const TvFeedState({
    required this.orientation,
    required this.fen,
    required this.position,
    required this.turn,
    required this.players,
    this.lastMove,
  });

  TvFeedState.fromFeaturedEvent(FeaturedEvent event)
      : orientation = event.orientation,
        fen = event.fen,
        position = Chess.fromSetup(Setup.parseFen(event.fen)),
        turn = event.fen.substring(event.fen.length - 1) == 'w'
            ? cg.Side.white
            : cg.Side.black,
        players = {...event.players},
        lastMove = null;

  final cg.Side orientation;
  final String fen;
  final Chess position;
  final cg.Side turn;
  final cg.Move? lastMove;
  final Map<cg.Side, FeaturedPlayer> players;

  bool get isGameOngoing => !position.isGameOver;

  TvFeedState updateWithFenEvent(FenEvent event) {
    final white = players[cg.Side.white];
    final black = players[cg.Side.black];
    return copyWith(
      fen: event.fen,
      position: Chess.fromSetup(Setup.parseFen(event.fen)),
      turn: event.fen.substring(event.fen.length - 1) == 'w'
          ? cg.Side.white
          : cg.Side.black,
      players: {
        if (white != null) cg.Side.white: white.withSeconds(event.whiteSeconds),
        if (black != null) cg.Side.black: black.withSeconds(event.blackSeconds),
      },
      lastMove: event.lastMove,
    );
  }

  TvFeedState copyWith({
    cg.Side? orientation,
    String? fen,
    Chess? position,
    cg.Side? turn,
    cg.Move? lastMove,
    Map<cg.Side, FeaturedPlayer>? players,
  }) {
    return TvFeedState(
      orientation: orientation ?? this.orientation,
      fen: fen ?? this.fen,
      position: position ?? this.position,
      turn: turn ?? this.turn,
      lastMove: lastMove,
      players: players != null
          ? Map.unmodifiable({...this.players, ...players})
          : this.players,
    );
  }
}

final tvFeedProvider = StreamProvider.autoDispose<TvFeedState>((ref) {
  final tvRepository = ref.watch(tvRepositoryProvider);
  ref.onDispose(() {
    print('tvFeedProvider onDispose');
    tvRepository.dispose();
  });
  return tvRepository.tvFeed().map((event) {
    print(event);
    switch (event['t']) {
      case 'featured':
        return TvFeedState.fromFeaturedEvent(
            FeaturedEvent.fromJson(event['d']));

      case 'fen':
        return TvFeedState.fromFeaturedEvent(
            FeaturedEvent.fromJson(event['d']));

      default:
        throw Exception('Unsupported event $event');
    }
  });
});
