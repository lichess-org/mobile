import 'package:flutter/material.dart';
import 'package:chessground/chessground.dart';

import '../domain/stream_event.dart';
import '../domain/featured_player.dart';

@immutable
class TvFeedState {
  const TvFeedState({
    required this.orientation,
    required this.white,
    required this.black,
  });

  final Side orientation;
  final FeaturedPlayer white;
  final FeaturedPlayer black;

  TvFeedState.fromFeaturedEvent(FeaturedEvent event)
      : orientation = event.orientation,
        white = event.white,
        black = event.black;

  TvFeedState copyWith({
    Side? orientation,
    FeaturedPlayer? white,
    FeaturedPlayer? black,
  }) {
    return TvFeedState(
      orientation: orientation ?? this.orientation,
      white: white ?? this.white,
      black: black ?? this.black,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is TvFeedState &&
        other.orientation == orientation &&
        other.white == white &&
        other.black == black;
  }

  @override
  int get hashCode => Object.hash(orientation, white, black);

  @override
  toString() => '$orientation, $white, $black';
}
