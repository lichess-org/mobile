import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lichess_mobile/src/sound.dart';
import '../domain/stream_event.dart';
import '../domain/featured_game.dart';
import '../domain/featured_position.dart';
import '../data/tv_repository.dart';
import './featured_game_notifier.dart';

final tvStreamProvider = StreamProvider.autoDispose<FeaturedPosition>((ref) {
  final soundService = ref.watch(soundServiceProvider);
  final tvRepository = ref.watch(tvRepositoryProvider);
  final featuredGameNotifier = ref.read(featuredGameNotifierProvider.notifier);
  ref.onDispose(() {
    tvRepository.dispose();
  });
  return tvRepository.tvFeed().map((raw) {
    switch (raw['t']) {
      case 'featured':
        featuredGameNotifier.onFeaturedEvent(FeaturedGame.fromJson(raw['d']));
        return FeaturedPosition.fromJson(raw['d']);

      case 'fen':
        featuredGameNotifier.onFenEvent(FenEvent.fromJson(raw['d']));
        soundService.playMove();
        return FeaturedPosition.fromJson(raw['d']);

      default:
        throw Exception('Unsupported event $raw');
    }
  });
});
