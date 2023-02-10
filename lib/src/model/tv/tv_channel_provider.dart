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

  // the int values should match the list from [getListString]
  static TvChannel getChannel(int value) {
    switch (value) {
      case 0:
        return TvChannel.top;
      case 1:
        return TvChannel.ultrabullet;
      case 2:
        return TvChannel.bullet;
      case 3:
        return TvChannel.blitz;
      case 4:
        return TvChannel.rapid;
      case 5:
        return TvChannel.classical;
      case 6:
        return TvChannel.threecheck;
      case 7:
        return TvChannel.kingofthehill;
      case 8:
        return TvChannel.antichess;
      case 9:
        return TvChannel.chess960;
      case 10:
        return TvChannel.computer;
      case 11:
        return TvChannel.bot;
      default:
        return TvChannel.top;
    }
  }

  static List<String> getListString() => [
        'Top Rated',
        'UltraBullet',
        'Bullet',
        'Blitz',
        'Rapid',
        'Classical',
        'Three-check',
        'King of the Hill',
        'Antichess',
        'Chess960',
        'Computer',
        'Bot',
      ];
}

final tvChannelProvider = StateNotifierProvider<TvChannelNotifier, TvChannel>(
  (ref) => TvChannelNotifier(initialValue: TvChannel.top),
);

class TvChannelNotifier extends StateNotifier<TvChannel> {
  TvChannelNotifier({required TvChannel initialValue}) : super(initialValue);

  void toggleChannel(int value) => state = TvChannel.getChannel(value);
}
