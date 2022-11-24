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

  TvFeedEvent.fromJson(Map<String, dynamic> json)
      : fen = json['fen'],
        position = Chess.fromSetup(Setup.parseFen(json['fen'])),
        turn = json['fen'].substring(json['fen'].length - 1) == 'w'
            ? cg.Side.white
            : cg.Side.black,
        lastMove = json['lm'] != null ? cg.Move.fromUci(json['lm']) : null;

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

  @override
  bool operator ==(Object other) {
    return other is TvFeedEvent &&
        other.fen == fen &&
        other.position == position &&
        other.turn == turn &&
        other.lastMove == lastMove;
  }

  @override
  int get hashCode => Object.hash(fen, position, turn, lastMove);
}

final tvFeedProvider = StreamProvider.autoDispose<TvFeedEvent>((ref) {
  final tvRepository = ref.watch(tvRepositoryProvider);
  final tvControllerNotifier = ref.read(tvScreenControllerProvider.notifier);
  ref.onDispose(() {
    print('tvFeedProvider onDispose');
    tvRepository.dispose();
  });
  return tvRepository.tvFeed().map((raw) {
    switch (raw['t']) {
      case 'featured':
        tvControllerNotifier.onFeaturedEvent(FeaturedEvent.fromJson(raw['d']));
        return TvFeedEvent.fromJson(raw['d']);

      case 'fen':
        tvControllerNotifier.onFenEvent(FenEvent.fromJson(raw['d']));
        return TvFeedEvent.fromJson(raw['d']);

      default:
        throw Exception('Unsupported event $raw');
    }
  });
});
