import 'package:flutter_riverpod/flutter_riverpod.dart';

enum TvChannel {
  topRated,
  bullet,
  blitz,
  rapid,
  classical,
  chess960,
  threeCheck,
  antichess,
  ultrabullet,
  bot,
  computer;

  @override
  String toString() {
    switch (name) {
      case 'topRated':
        return 'Top Rated';
      case 'bullet':
        return 'Bullet';
      case 'blitz':
        return 'Blitz';
      case 'rapid':
        return 'Rapid';
      case 'classical':
        return 'Classical';
      case 'chess960':
        return 'Chess960';
      case 'threeCheck':
        return 'Three-check';
      case 'antichess':
        return 'Antichess';
      case 'ultrabullet':
        return 'UltraBullet';
      case 'bot':
        return 'Bot';
      case 'computer':
        return 'Computer';
      default:
        return 'Top Rated';
    }
  }
}

final currentTvChannelProvider =
    StateProvider<TvChannel>((ref) => TvChannel.topRated);
