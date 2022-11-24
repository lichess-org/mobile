import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chessground/chessground.dart' as cg;
import 'package:dartchess/dartchess.dart';

import '../domain/stream_event.dart';
import '../domain/featured_player.dart';
import '../data/tv_repository.dart';
import './tv_screen_controller.dart';

@immutable
class TvFeedEvent {
  const TvFeedEvent({
    required this.fen,
    required this.position,
    required this.turn,
    this.lastMove,
  });

  TvFeedEvent.fromFeaturedEvent(FeaturedEvent event)
      : fen = event.fen,
        position = Chess.fromSetup(Setup.parseFen(event.fen)),
        turn = event.fen.substring(event.fen.length - 1) == 'w'
            ? cg.Side.white
            : cg.Side.black,
        lastMove = null;

  TvFeedEvent.fromFenEvent(FenEvent event)
      : fen = event.fen,
        position = Chess.fromSetup(Setup.parseFen(event.fen)),
        turn = event.fen.substring(event.fen.length - 1) == 'w'
            ? cg.Side.white
            : cg.Side.black,
        lastMove = event.lastMove;

  final String fen;
  final Chess position;
  final cg.Side turn;
  final cg.Move? lastMove;

  bool get isGameOngoing => !position.isGameOver;

  TvFeedEvent copyWith({
    cg.Side? orientation,
    String? fen,
    Chess? position,
    cg.Side? turn,
    cg.Move? lastMove,
    Map<cg.Side, FeaturedPlayer>? players,
  }) {
    return TvFeedEvent(
      fen: fen ?? this.fen,
      position: position ?? this.position,
      turn: turn ?? this.turn,
      lastMove: lastMove,
    );
  }
}

final tvFeedProvider = StreamProvider.autoDispose<TvFeedEvent>((ref) {
  final tvRepository = ref.watch(tvRepositoryProvider);
  final tvControllerNotifier = ref.read(tvScreenControllerProvider.notifier);
  ref.onDispose(() {
    print('tvFeedProvider onDispose');
    tvRepository.dispose();
  });
  return tvRepository.tvFeed().map((event) {
    tvControllerNotifier.onReceiveEvent(event);
    switch (event['t']) {
      case 'featured':
        return TvFeedEvent.fromFeaturedEvent(
            FeaturedEvent.fromJson(event['d']));

      case 'fen':
        return TvFeedEvent.fromFenEvent(FenEvent.fromJson(event['d']));

      default:
        throw Exception('Unsupported event $event');
    }
  });
});
