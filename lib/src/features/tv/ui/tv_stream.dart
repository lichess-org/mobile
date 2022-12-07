import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lichess_mobile/src/common/sound.dart';
import '../model/fen_event.dart';
import '../model/featured_game.dart';
import '../model/featured_position.dart';
import '../data/tv_repository.dart';
import './featured_game_notifier.dart';

final tvStreamProvider = StreamProvider.autoDispose<FeaturedPosition>((ref) {
  final soundService = ref.watch(soundServiceProvider);
  final tvRepository = ref.watch(tvRepositoryProvider);
  final featuredGameNotifier = ref.read(featuredGameProvider.notifier);
  ref.onDispose(() {
    tvRepository.dispose();
  });
  return tvRepository.tvFeed().map((raw) {
    switch (raw['t']) {
      case 'featured':
        featuredGameNotifier.onFeaturedEvent(
            FeaturedGame.fromJson(raw['d'] as Map<String, dynamic>));
        return FeaturedPosition.fromJson(raw['d'] as Map<String, dynamic>);

      case 'fen':
        featuredGameNotifier
            .onFenEvent(FenEvent.fromJson(raw['d'] as Map<String, dynamic>));
        soundService.playMove();
        return FeaturedPosition.fromJson(raw['d'] as Map<String, dynamic>);

      default:
        throw Exception('Unsupported event $raw');
    }
  });
});
