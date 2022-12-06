import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/fen_event.dart';
import '../model/featured_game.dart';

class FeaturedGameNotifier extends StateNotifier<FeaturedGame?> {
  FeaturedGameNotifier() : super(null);

  void onFeaturedEvent(FeaturedGame game) {
    state = game;
  }

  void onFenEvent(FenEvent event) {
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
