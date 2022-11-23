import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chessground/chessground.dart' as cg;
import 'package:dartchess/dartchess.dart';

import 'package:lichess_mobile/src/constants.dart';
import '../domain/stream_event.dart';
import '../domain/featured_player.dart';
import '../data/tv_repository.dart';

class TvScreenController extends StateNotifier<TvScreenState> {
  TvScreenController()
      : super(const TvScreenState(
          orientation: cg.Side.white,
          fen: kEmptyFen,
          position: Chess.initial,
          turn: cg.Side.white,
          players: {
            cg.Side.white:
                FeaturedPlayer(side: cg.Side.white, name: '', seconds: 0),
            cg.Side.black:
                FeaturedPlayer(side: cg.Side.black, name: '', seconds: 0),
          },
        ));

  void onReceiveEvent(Map<String, dynamic> event) {
    switch (event['t']) {
      case 'featured':
        onFeaturedEvent(FeaturedEvent.fromJson(event['d']));
        break;

      case 'fen':
        onFenEvent(FenEvent.fromJson(event['d']));
        break;
    }
  }

  void onFeaturedEvent(FeaturedEvent event) {
    state = state.copyWith(
      orientation: event.orientation,
      position: Chess.fromSetup(Setup.parseFen(event.fen)),
      turn: event.fen.substring(event.fen.length - 1) == 'w'
          ? cg.Side.white
          : cg.Side.black,
      players: {...event.players},
    );
  }

  void onFenEvent(FenEvent event) {
    final white = state.players[cg.Side.white];
    final black = state.players[cg.Side.black];
    state = state.copyWith(
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
}

@immutable
class TvScreenState {
  const TvScreenState({
    required this.orientation,
    required this.fen,
    required this.position,
    required this.turn,
    required this.players,
    this.lastMove,
  });

  final cg.Side orientation;
  final String fen;
  final Chess position;
  final cg.Side turn;
  final cg.Move? lastMove;
  final Map<cg.Side, FeaturedPlayer> players;

  bool get isGameOngoing => !position.isGameOver;

  TvScreenState copyWith({
    cg.Side? orientation,
    String? fen,
    Chess? position,
    cg.Side? turn,
    cg.Move? lastMove,
    Map<cg.Side, FeaturedPlayer>? players,
  }) {
    return TvScreenState(
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

final tvScreenControllerProvider =
    StateNotifierProvider.autoDispose<TvScreenController, TvScreenState>((ref) {
  final tvFeed = ref.watch(tvFeedProvider);
  final controller = TvScreenController();
  tvFeed.whenData((event) {
    controller.onReceiveEvent(event);
  });
  return controller;
});
