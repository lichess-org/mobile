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

  @override
  String toString() {
    switch (this) {
      case TvChannel.top:
        return 'Top Rated';
      case TvChannel.ultrabullet:
        return 'Ultra Bullet';
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

  static TvChannel fromString(String? str) {
    switch (str) {
      case 'Top Rated':
        return TvChannel.top;
      case 'Ultra Bullet':
        return TvChannel.ultrabullet;
      case 'Blitz':
        return TvChannel.blitz;
      case 'Bullet':
        return TvChannel.bullet;
      case 'Antichess':
        return TvChannel.antichess;
      case 'Bot':
        return TvChannel.bot;
      case 'Rapid':
        return TvChannel.rapid;
      case 'Classical':
        return TvChannel.classical;
      case 'Three Check':
        return TvChannel.threecheck;
      case 'Chess960':
        return TvChannel.chess960;
      case 'King of the Hill':
        return TvChannel.kingofthehill;
      case 'Computer':
        return TvChannel.computer;
      default:
        return TvChannel.top;
    }
  }
}
