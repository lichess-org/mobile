import 'package:flutter_riverpod/flutter_riverpod.dart';

enum TvChannel {
  top,
  ultrabullet,
  bullet,
  blitz,
  rapid,
  classical,
  threecheck,
  kingofthehill,
  antichess,
  chess960,
  computer,
  bot;
  // atomic,
  // horde,
  // threecheck,
  // racing kings,

  String get string {
    switch (this) {
      case TvChannel.top:
        return 'Top Rated';
      case TvChannel.ultrabullet:
        return 'UltraBullet';
      case TvChannel.blitz:
        return 'Blitz';
      case TvChannel.bullet:
        return 'Bullet';
      case TvChannel.antichess:
        return 'Antichess';
      case TvChannel.bot:
        return 'Bot';
      case TvChannel.rapid:
        return 'Rapid';
      case TvChannel.classical:
        return 'Classical';
      case TvChannel.threecheck:
        return 'Three-check';
      case TvChannel.chess960:
        return 'Chess960';
      case TvChannel.kingofthehill:
        return 'King of the Hill';
      case TvChannel.computer:
        return 'Computer';
    }
  }
}

final tvChannelProvider = StateNotifierProvider<TvChannelNotifier, TvChannel>(
  (ref) => TvChannelNotifier(initialValue: TvChannel.top),
);

class TvChannelNotifier extends StateNotifier<TvChannel> {
  TvChannelNotifier({required TvChannel initialValue}) : super(initialValue);

  TvChannel get channel => state;
  set channel(TvChannel value) => state = value;
}
