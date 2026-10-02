import 'dart:convert';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/game/game.dart';
import 'package:lichess_mobile/src/model/game/playable_game.dart';
import 'package:lichess_mobile/src/model/lobby/game_seek.dart';
import 'package:lichess_mobile/src/model/lobby/game_setup_preferences.dart';
import 'package:lichess_mobile/src/model/user/user.dart';

void main() {
  group('GameSeek.newOpponentFromGame', () {
    test('calculates ratingRange using updated rating (rating + ratingDiff) and custom delta', () {
      final game = PlayableGame.fromServerJson(
        jsonDecode(_playableGameJson) as Map<String, dynamic>,
      );
      // game.white.rating is 1789, ratingDiff is 9 -> updated rating = 1798.
      // youAre is white.
      final setup = GameSetupPrefs.defaults.copyWith(customRatingDelta: (0, 500));

      final seek = GameSeek.newOpponentFromGame(game, setup);

      expect(seek.rated, isTrue);
      expect(seek.ratingRange, const (1798, 2298));
      expect(seek.ratingDelta, isNull);
    });

    test('sets ratingRange to null when customRatingDelta is default (-500, 500)', () {
      final game = PlayableGame.fromServerJson(
        jsonDecode(_playableGameJson) as Map<String, dynamic>,
      );
      const setup = GameSetupPrefs.defaults; // kDefaultRatingDelta is (-500, 500)

      final seek = GameSeek.newOpponentFromGame(game, setup);

      expect(seek.rated, isTrue);
      expect(seek.ratingRange, isNull);
      expect(seek.ratingDelta, isNull);
    });

    test('sets ratingRange to null when game is unrated', () {
      final game = PlayableGame.fromServerJson(
        jsonDecode(_playableGameJson) as Map<String, dynamic>,
      );
      final unratedGame = game.copyWith(meta: game.meta.copyWith(rated: false));
      final setup = GameSetupPrefs.defaults.copyWith(customRatingDelta: (0, 500));

      final seek = GameSeek.newOpponentFromGame(unratedGame, setup);

      expect(seek.rated, isFalse);
      expect(seek.ratingRange, isNull);
      expect(seek.ratingDelta, isNull);
    });

    test('sets ratingRange to null when game source is not lobby', () {
      final game = PlayableGame.fromServerJson(
        jsonDecode(_playableGameJson) as Map<String, dynamic>,
      );
      final poolGame = game.copyWith(source: GameSource.pool);
      final setup = GameSetupPrefs.defaults.copyWith(customRatingDelta: (0, 500));

      final seek = GameSeek.newOpponentFromGame(poolGame, setup);

      expect(seek.ratingRange, isNull);
      expect(seek.ratingDelta, isNull);
    });

    test('falls back to account perfs when player rating in game is null', () {
      final game = PlayableGame.fromServerJson(
        jsonDecode(_playableGameJson) as Map<String, dynamic>,
      );
      final gameWithoutRating = game.copyWith(
        white: game.white.copyWith(rating: null, ratingDiff: null),
      );
      const user = User(
        id: UserId('veloce'),
        username: 'veloce',
        perfs: IMapConst({
          Perf.bullet: UserPerf(
            rating: 1850,
            ratingDeviation: 50,
            progression: 10,
            provisional: false,
          ),
        }),
      );
      final setup = GameSetupPrefs.defaults.copyWith(customRatingDelta: (-100, 200));

      final seek = GameSeek.newOpponentFromGame(gameWithoutRating, setup, account: user);

      expect(seek.ratingRange, const (1750, 2050));
      expect(seek.ratingDelta, isNull);
    });

    test('clamps minimum rating in range to 0', () {
      final game = PlayableGame.fromServerJson(
        jsonDecode(_playableGameJson) as Map<String, dynamic>,
      );
      final lowRatedGame = game.copyWith(
        white: game.white.copyWith(rating: 200, ratingDiff: -50), // 150
      );
      final setup = GameSetupPrefs.defaults.copyWith(customRatingDelta: (-300, 200));

      final seek = GameSeek.newOpponentFromGame(lowRatedGame, setup);

      expect(seek.ratingRange, const (0, 350));
    });
  });
}

const _playableGameJson = '''
{"game":{"id":"CCW6EEru","variant":{"key":"standard","name":"Standard","short":"Std"},"speed":"bullet","perf":"bullet","rated":true,"fen":"6kr/p1p2rpp/4Q3/2b1p3/8/2P5/P2N1PPP/R3R1K1 b - - 0 22","turns":43,"source":"lobby","status":{"id":31,"name":"resign"},"createdAt":1706185945680,"winner":"white","pgn":"e4 e5 Nf3 Nc6 Bc4 Bc5 b4 Bxb4 c3 Ba5 d4 Bb6 Ba3 Nf6 Qb3 d6 Bxf7+ Kf8 O-O Qe7 Nxe5 Nxe5 dxe5 Be6 Bxe6 Nxe4 Re1 Nc5 Bxc5 Bxc5 Qxb7 Re8 Bh3 dxe5 Qf3+ Kg8 Nd2 Rf8 Qd5+ Rf7 Be6 Qxe6 Qxe6"},"white":{"user":{"name":"veloce","id":"veloce"},"rating":1789,"ratingDiff":9},"black":{"user":{"name":"chabrot","id":"chabrot"},"rating":1810,"ratingDiff":-9},"socket":0,"clock":{"running":false,"initial":120,"increment":1,"white":31.2,"black":27.42,"emerg":15,"moretime":15},"takebackable":true,"youAre":"white","prefs":{"autoQueen":2,"zen":2,"confirmResign":true,"enablePremove":true},"chat":{"lines":[]}}
''';
