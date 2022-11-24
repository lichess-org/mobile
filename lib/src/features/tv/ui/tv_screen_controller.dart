import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chessground/chessground.dart';

import '../domain/stream_event.dart';
import '../domain/featured_player.dart';

class TvScreenController extends StateNotifier<TvScreenState?> {
  TvScreenController() : super(null);

  void onFeaturedEvent(FeaturedEvent event) {
    state = TvScreenState.fromFeaturedEvent(event);
  }

  void onFenEvent(FenEvent event) {
    state = state?.copyWith(
      white: state!.white.withSeconds(event.whiteSeconds),
      black: state!.black.withSeconds(event.whiteSeconds),
    );
  }
}

@immutable
class TvScreenState {
  const TvScreenState({
    required this.orientation,
    required this.white,
    required this.black,
  });

  final Side orientation;
  final FeaturedPlayer white;
  final FeaturedPlayer black;

  TvScreenState.fromFeaturedEvent(FeaturedEvent event)
      : orientation = event.orientation,
        white = event.white,
        black = event.black;

  TvScreenState copyWith({
    Side? orientation,
    FeaturedPlayer? white,
    FeaturedPlayer? black,
  }) {
    return TvScreenState(
      orientation: orientation ?? this.orientation,
      white: white ?? this.white,
      black: black ?? this.black,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is TvScreenState &&
        other.orientation == orientation &&
        other.white == white &&
        other.black == black;
  }

  @override
  int get hashCode => Object.hash(orientation, white, black);

  @override
  toString() => '$orientation, $white, $black';
}

final tvScreenControllerProvider =
    StateNotifierProvider.autoDispose<TvScreenController, TvScreenState?>(
        (ref) {
  return TvScreenController();
});
