import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'featured_game.dart';
import 'tv_event.dart';

class FeaturedGameNotifier extends StateNotifier<FeaturedGame?> {
  FeaturedGameNotifier() : super(null);

  void onFeaturedEvent(TvFeaturedEvent event) {
    state = FeaturedGame(
      id: event.id,
      orientation: event.orientation,
      initialFen: event.fen,
      white: event.white,
      black: event.black,
    );
  }

  void onFenEvent(TvFenEvent event) {
    state = state?.copyWith(
      white: state!.white.withSeconds(event.whiteSeconds),
      black: state!.black.withSeconds(event.whiteSeconds),
    );
  }
}

final featuredGameProvider =
    StateNotifierProvider.autoDispose<FeaturedGameNotifier, FeaturedGame?>(
        (ref) {
  return FeaturedGameNotifier();
});
