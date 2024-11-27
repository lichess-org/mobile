import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/game/archived_game.dart';
import 'package:lichess_mobile/src/model/game/playable_game.dart';

void main() {
  group('PlayableGame', () {
    test('makePgn, unfinished game', () {
      final game = PlayableGame.fromServerJson(
        jsonDecode(_unfinishedGameJson) as Map<String, dynamic>,
      );

      expect(
        game.makePgn(),
        '''
[Event "Rated Bullet game"]
[Site "https://lichess.dev/Fn9UvVKF"]
[Date "2024.01.25"]
[White "chabrot"]
[Black "veloce"]
[Result "*"]
[WhiteElo "1801"]
[BlackElo "1798"]
[Variant "Standard"]
[TimeControl "120+1"]

*
''',
      );
    });

    test('makePgn, finished game', () {
      final game = PlayableGame.fromServerJson(
        jsonDecode(_playableGameJson) as Map<String, dynamic>,
      );

      expect(
        game.makePgn(),
        '''
[Event "Rated Bullet game"]
[Site "https://lichess.dev/CCW6EEru"]
[Date "2024.01.25"]
[White "veloce"]
[Black "chabrot"]
[Result "1-0"]
[WhiteElo "1789"]
[BlackElo "1810"]
[WhiteRatingDiff "+9"]
[BlackRatingDiff "-9"]
[Variant "Standard"]
[TimeControl "120+1"]

1. e4 e5 2. Nf3 Nc6 3. Bc4 Bc5 4. b4 Bxb4 5. c3 Ba5 6. d4 Bb6 7. Ba3 Nf6 8. Qb3 d6 9. Bxf7+ Kf8 10. O-O Qe7 11. Nxe5 Nxe5 12. dxe5 Be6 13. Bxe6 Nxe4 14. Re1 Nc5 15. Bxc5 Bxc5 16. Qxb7 Re8 17. Bh3 dxe5 18. Qf3+ Kg8 19. Nd2 Rf8 20. Qd5+ Rf7 21. Be6 Qxe6 22. Qxe6 1-0
''',
      );
    });

    test('toArchivedGame', () {
      for (final game in [_playableGameJson, _playable960GameJson]) {
        final playableGame = PlayableGame.fromServerJson(
          jsonDecode(game) as Map<String, dynamic>,
        );
        final now = DateTime.now();
        final archivedGame = playableGame.toArchivedGame(finishedAt: now);

        expect(archivedGame.id, playableGame.id);
        expect(archivedGame.meta, playableGame.meta);
        expect(archivedGame.source, playableGame.source);
        expect(archivedGame.data.id, playableGame.id);
        expect(archivedGame.data.lastMoveAt, now);
        expect(archivedGame.data.createdAt, playableGame.meta.createdAt);
        expect(archivedGame.data.lastFen, playableGame.lastPosition.fen);
        expect(archivedGame.data.variant, playableGame.meta.variant);
        expect(archivedGame.data.perf, playableGame.meta.perf);
        expect(archivedGame.data.speed, playableGame.meta.speed);
        expect(archivedGame.data.rated, playableGame.meta.rated);
        expect(archivedGame.data.winner, playableGame.winner);
        expect(archivedGame.data.white, playableGame.white);
        expect(archivedGame.data.black, playableGame.black);
        expect(archivedGame.data.opening, playableGame.meta.opening);
        expect(
          archivedGame.data.clock,
          playableGame.meta.clock != null
              ? (
                  initial: playableGame.meta.clock!.initial,
                  increment: playableGame.meta.clock!.increment,
                )
              : null,
        );
        expect(archivedGame.initialFen, playableGame.initialFen);
        expect(
          archivedGame.isThreefoldRepetition,
          playableGame.isThreefoldRepetition,
        );
        expect(archivedGame.status, playableGame.status);
        expect(archivedGame.winner, playableGame.winner);
        expect(archivedGame.white, playableGame.white);
        expect(archivedGame.black, playableGame.black);
        expect(archivedGame.steps, playableGame.steps);
        expect(archivedGame.clocks, playableGame.clocks);
        expect(archivedGame.evals, playableGame.evals);
        expect(archivedGame.youAre, playableGame.youAre);
      }
    });
  });

  group('ArchivedGame', () {
    test('makePgn, with clocks', () {
      final game = ArchivedGame.fromServerJson(
        jsonDecode(_archivedGameJsonNoEvals) as Map<String, dynamic>,
      );
      expect(
        game.makePgn(),
        '''
[Event "Rated Bullet game"]
[Site "https://lichess.dev/CCW6EEru"]
[Date "2024.01.25"]
[White "veloce"]
[Black "chabrot"]
[Result "1-0"]
[WhiteElo "1789"]
[BlackElo "1810"]
[WhiteRatingDiff "+9"]
[BlackRatingDiff "-9"]
[Variant "Standard"]
[TimeControl "120+1"]
[ECO "C52"]
[Opening "Italian Game: Evans Gambit, Main Line"]

1. e4 { [%clk 0:02:00.03] } e5 { [%clk 0:02:00.03] } 2. Nf3 { [%emt 0:00:02.2] [%clk 0:01:58.83] } Nc6 { [%emt 0:00:02.92] [%clk 0:01:58.11] } 3. Bc4 { [%emt 0:00:03] [%clk 0:01:56.83] } Bc5 { [%emt 0:00:05.32] [%clk 0:01:53.79] } 4. b4 { [%emt 0:00:04.76] [%clk 0:01:53.07] } Bxb4 { [%emt 0:00:03.16] [%clk 0:01:51.63] } 5. c3 { [%emt 0:00:03.64] [%clk 0:01:50.43] } Ba5 { [%emt 0:00:02.2] [%clk 0:01:50.43] } 6. d4 { [%emt 0:00:02.44] [%clk 0:01:48.99] } Bb6 { [%emt 0:00:04.36] [%clk 0:01:47.07] } 7. Ba3 { [%emt 0:00:08.44] [%clk 0:01:41.55] } Nf6 { [%emt 0:00:03.24] [%clk 0:01:44.83] } 8. Qb3 { [%emt 0:00:02.36] [%clk 0:01:40.19] } d6 { [%emt 0:00:05.88] [%clk 0:01:39.95] } 9. Bxf7+ { [%emt 0:00:04.84] [%clk 0:01:36.35] } Kf8 { [%emt 0:00:01.72] [%clk 0:01:39.23] } 10. O-O { [%emt 0:00:07.72] [%clk 0:01:29.63] } Qe7 { [%emt 0:00:14.2] [%clk 0:01:26.03] } 11. Nxe5 { [%emt 0:00:11.48] [%clk 0:01:19.15] } Nxe5 { [%emt 0:00:04.2] [%clk 0:01:22.83] } 12. dxe5 { [%emt 0:00:02.52] [%clk 0:01:17.63] } Be6 { [%emt 0:00:09.24] [%clk 0:01:14.59] } 13. Bxe6 { [%emt 0:00:04.84] [%clk 0:01:13.79] } Nxe4 { [%emt 0:00:14.76] [%clk 0:01:00.83] } 14. Re1 { [%emt 0:00:08.92] [%clk 0:01:05.87] } Nc5 { [%emt 0:00:03.64] [%clk 0:00:58.19] } 15. Bxc5 { [%emt 0:00:03.24] [%clk 0:01:03.63] } Bxc5 { [%emt 0:00:02.68] [%clk 0:00:56.51] } 16. Qxb7 { [%emt 0:00:03.88] [%clk 0:01:00.75] } Re8 { [%emt 0:00:02.44] [%clk 0:00:55.07] } 17. Bh3 { [%emt 0:00:05] [%clk 0:00:56.75] } dxe5 { [%emt 0:00:08.04] [%clk 0:00:48.03] } 18. Qf3+ { [%emt 0:00:07.16] [%clk 0:00:50.59] } Kg8 { [%emt 0:00:03.88] [%clk 0:00:45.15] } 19. Nd2 { [%emt 0:00:06.12] [%clk 0:00:45.47] } Rf8 { [%emt 0:00:10.6] [%clk 0:00:35.55] } 20. Qd5+ { [%emt 0:00:06.76] [%clk 0:00:39.71] } Rf7 { [%emt 0:00:02.44] [%clk 0:00:34.11] } 21. Be6 { [%emt 0:00:08.36] [%clk 0:00:32.35] } Qxe6 { [%emt 0:00:03.88] [%clk 0:00:31.23] } 22. Qxe6 { [%emt 0:00:02.15] [%clk 0:00:31.2] } 1-0
''',
      );
    });

    test('makePgn, with evals and clocks', () {
      final game = ArchivedGame.fromServerJson(
        jsonDecode(_archivedGameJson) as Map<String, dynamic>,
      );
      expect(
        game.makePgn(),
        '''
[Event "Rated Bullet game"]
[Site "https://lichess.dev/CCW6EEru"]
[Date "2024.01.25"]
[White "veloce"]
[Black "chabrot"]
[Result "1-0"]
[WhiteElo "1789"]
[BlackElo "1810"]
[WhiteRatingDiff "+9"]
[BlackRatingDiff "-9"]
[Variant "Standard"]
[TimeControl "120+1"]
[ECO "C52"]
[Opening "Italian Game: Evans Gambit, Main Line"]

1. e4 { [%eval 0.32] [%clk 0:02:00.03] } e5 { [%eval 0.41] [%clk 0:02:00.03] } 2. Nf3 { [%eval 0.39] [%emt 0:00:02.2] [%clk 0:01:58.83] } Nc6 { [%eval 0.20] [%emt 0:00:02.92] [%clk 0:01:58.11] } 3. Bc4 { [%eval 0.17] [%emt 0:00:03] [%clk 0:01:56.83] } Bc5 { [%eval 0.21] [%emt 0:00:05.32] [%clk 0:01:53.79] } 4. b4 { [%eval -0.21] [%emt 0:00:04.76] [%clk 0:01:53.07] } Bxb4 { [%eval -0.14] [%emt 0:00:03.16] [%clk 0:01:51.63] } 5. c3 { [%eval -0.23] [%emt 0:00:03.64] [%clk 0:01:50.43] } Ba5 { [%eval -0.24] [%emt 0:00:02.2] [%clk 0:01:50.43] } 6. d4 { [%eval -0.24] [%emt 0:00:02.44] [%clk 0:01:48.99] } Bb6 \$6 { Inaccuracy. d6 was best. [%eval 0.52] [%emt 0:00:04.36] [%clk 0:01:47.07] } ( 6... d6 ) 7. Ba3 \$6 { Inaccuracy. Nxe5 was best. [%eval -0.56] [%emt 0:00:08.44] [%clk 0:01:41.55] } ( 7. Nxe5 ) 7... Nf6 \$4 { Blunder. d6 was best. [%eval 1.77] [%emt 0:00:03.24] [%clk 0:01:44.83] } ( 7... d6 ) 8. Qb3 \$4 { Blunder. dxe5 was best. [%eval -0.19] [%emt 0:00:02.36] [%clk 0:01:40.19] } ( 8. dxe5 Ng4 9. Qd5 Nh6 10. Nbd2 Ne7 11. Qd3 O-O 12. h3 d6 13. g4 Kh8 14. exd6 cxd6 ) 8... d6 { [%eval -0.16] [%emt 0:00:05.88] [%clk 0:01:39.95] } 9. Bxf7+ { [%eval -0.20] [%emt 0:00:04.84] [%clk 0:01:36.35] } Kf8 { [%eval -0.12] [%emt 0:00:01.72] [%clk 0:01:39.23] } 10. O-O \$2 { Mistake. Bd5 was best. [%eval -1.45] [%emt 0:00:07.72] [%clk 0:01:29.63] } ( 10. Bd5 Nxd5 ) 10... Qe7 \$4 { Blunder. Na5 was best. [%eval 0.72] [%emt 0:00:14.2] [%clk 0:01:26.03] } ( 10... Na5 11. Qd1 Kxf7 12. dxe5 dxe5 13. Nxe5+ Ke8 14. Nd2 Be6 15. Qa4+ Bd7 16. Qd1 Nc6 17. Ndc4 ) 11. Nxe5 \$6 { Inaccuracy. Bd5 was best. [%eval -0.36] [%emt 0:00:11.48] [%clk 0:01:19.15] } ( 11. Bd5 Nxd5 12. exd5 Na5 13. Qb4 exd4 14. cxd4 Kg8 15. Re1 Qf7 16. Ng5 Qg6 17. Nc3 h6 ) 11... Nxe5 { [%eval -0.41] [%emt 0:00:04.2] [%clk 0:01:22.83] } 12. dxe5 { [%eval -0.42] [%emt 0:00:02.52] [%clk 0:01:17.63] } Be6 \$4 { Blunder. Qxf7 was best. [%eval 5.93] [%emt 0:00:09.24] [%clk 0:01:14.59] } ( 12... Qxf7 13. exf6 gxf6 14. c4 Rg8 15. Nd2 Qh5 16. c5 Bh3 17. g3 Bxc5 18. Bxc5 dxc5 19. Rfe1 ) 13. Bxe6 { [%eval 5.89] [%emt 0:00:04.84] [%clk 0:01:13.79] } Nxe4 { [%eval 6.30] [%emt 0:00:14.76] [%clk 0:01:00.83] } 14. Re1 \$4 { Blunder. exd6 was best. [%eval -0.32] [%emt 0:00:08.92] [%clk 0:01:05.87] } ( 14. exd6 cxd6 15. Bd5 Nxf2 16. Nd2 g5 17. Nc4 Kg7 18. Nxb6 Qe3 19. Rxf2 Rhf8 20. Bf3 axb6 ) 14... Nc5 \$4 { Blunder. Bxf2+ was best. [%eval 6.02] [%emt 0:00:03.64] [%clk 0:00:58.19] } ( 14... Bxf2+ ) 15. Bxc5 { [%eval 5.81] [%emt 0:00:03.24] [%clk 0:01:03.63] } Bxc5 { [%eval 6.56] [%emt 0:00:02.68] [%clk 0:00:56.51] } 16. Qxb7 { [%eval 6.62] [%emt 0:00:03.88] [%clk 0:01:00.75] } Re8 \$4 { Checkmate is now unavoidable. g6 was best. [%eval #15] [%emt 0:00:02.44] [%clk 0:00:55.07] } ( 16... g6 17. Qxa8+ Kg7 18. Qd5 c6 19. Qb3 Rf8 20. Re2 Qh4 21. Qb7+ Kh6 22. Qb2 dxe5 23. Nd2 ) 17. Bh3 \$4 { Lost forced checkmate sequence. Qf3+ was best. [%eval 5.66] [%emt 0:00:05] [%clk 0:00:56.75] } ( 17. Qf3+ Qf6 18. exf6 g6 19. f7 Kg7 20. fxe8=Q Rxe8 21. Qf7+ Kh6 22. Qxe8 d5 23. g4 c6 ) 17... dxe5 { [%eval 5.74] [%emt 0:00:08.04] [%clk 0:00:48.03] } 18. Qf3+ { [%eval 5.66] [%emt 0:00:07.16] [%clk 0:00:50.59] } Kg8 { [%eval 5.80] [%emt 0:00:03.88] [%clk 0:00:45.15] } 19. Nd2 { [%eval 5.69] [%emt 0:00:06.12] [%clk 0:00:45.47] } Rf8 \$6 { Inaccuracy. g6 was best. [%eval 7.74] [%emt 0:00:10.6] [%clk 0:00:35.55] } ( 19... g6 20. Ne4 Kg7 21. Qe2 Rd8 22. a4 h5 23. Rad1 Rxd1 24. Rxd1 Bb6 25. Rd7 Qxd7 26. Bxd7 ) 20. Qd5+ { [%eval 7.39] [%emt 0:00:06.76] [%clk 0:00:39.71] } Rf7 { [%eval 7.43] [%emt 0:00:02.44] [%clk 0:00:34.11] } 21. Be6 { [%eval 6.15] [%emt 0:00:08.36] [%clk 0:00:32.35] } Qxe6 \$6 { Inaccuracy. Bxf2+ was best. [%eval 9.34] [%emt 0:00:03.88] [%clk 0:00:31.23] } ( 21... Bxf2+ 22. Kh1 Bxe1 23. Rxe1 g6 24. Rf1 Kg7 25. Rxf7+ Qxf7 26. Bxf7 Rf8 27. Be6 e4 28. Qxe4 ) 22. Qxe6 { [%eval 8.61] [%emt 0:00:02.15] [%clk 0:00:31.2] } 1-0
''',
      );
    });
  });
}

const _unfinishedGameJson = '''
{"game":{"id":"Fn9UvVKF","variant":{"key":"standard","name":"Standard","short":"Std"},"speed":"bullet","perf":"bullet","rated":true,"fen":"rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1","turns":0,"source":"lobby","status":{"id":20,"name":"started"},"createdAt":1706204482969,"pgn":""},"white":{"user":{"name":"chabrot","id":"chabrot"},"rating":1801},"black":{"user":{"name":"veloce","id":"veloce"},"rating":1798},"socket":0,"expiration":{"idleMillis":67,"millisToMove":20000},"clock":{"running":false,"initial":120,"increment":1,"white":120,"black":120,"emerg":15,"moretime":15},"takebackable":true,"youAre":"black","prefs":{"autoQueen":2,"zen":2,"confirmResign":true,"enablePremove":true},"chat":{"lines":[]}}
''';

const _playableGameJson = '''
{"game":{"id":"CCW6EEru","variant":{"key":"standard","name":"Standard","short":"Std"},"speed":"bullet","perf":"bullet","rated":true,"fen":"6kr/p1p2rpp/4Q3/2b1p3/8/2P5/P2N1PPP/R3R1K1 b - - 0 22","turns":43,"source":"lobby","status":{"id":31,"name":"resign"},"createdAt":1706185945680,"winner":"white","pgn":"e4 e5 Nf3 Nc6 Bc4 Bc5 b4 Bxb4 c3 Ba5 d4 Bb6 Ba3 Nf6 Qb3 d6 Bxf7+ Kf8 O-O Qe7 Nxe5 Nxe5 dxe5 Be6 Bxe6 Nxe4 Re1 Nc5 Bxc5 Bxc5 Qxb7 Re8 Bh3 dxe5 Qf3+ Kg8 Nd2 Rf8 Qd5+ Rf7 Be6 Qxe6 Qxe6"},"white":{"user":{"name":"veloce","id":"veloce"},"rating":1789,"ratingDiff":9},"black":{"user":{"name":"chabrot","id":"chabrot"},"rating":1810,"ratingDiff":-9},"socket":0,"clock":{"running":false,"initial":120,"increment":1,"white":31.2,"black":27.42,"emerg":15,"moretime":15},"takebackable":true,"youAre":"white","prefs":{"autoQueen":2,"zen":2,"confirmResign":true,"enablePremove":true},"chat":{"lines":[]}}
''';

const _playable960GameJson = '''
{"game":{"id":"sfqnC9ZK","variant":{"key":"chess960","name":"Chess960","short":"960"},"speed":"blitz","perf":"chess960","rated":false,"fen":"1k2rb1n/pp4pp/1n3p2/2Npr3/5N2/5PP1/1PPBP2P/q1KRR1Q1 w - - 1 15","turns":28,"source":"lobby","status":{"id":30,"name":"mate"},"createdAt":1686125895867,"initialFen":"nrbkrbqn/pppppppp/8/8/8/8/PPPPPPPP/NRBKRBQN w KQkq - 0 1","winner":"black","pgn":"f3 Nb6 d3 d6 Be3 c5 d4 Bf5 O-O-O O-O-O Nf2 e5 dxe5 Rxe5 g3 Kb8 Bh3 Bxh3 Nxh3 f6 Nf4 Qxa2 Nb3 Rde8 Bd2 d5 Nxc5 Qa1#"},"white":{"user":{"name":"MinBorn","id":"minborn"},"rating":1500,"provisional":true},"black":{"user":{"name":"veloce","patron":true,"id":"veloce"},"rating":1292,"provisional":true,"onGame":true},"socket":0,"clock":{"running":false,"initial":180,"increment":2,"white":145.34,"black":118.8,"emerg":22,"moretime":15},"youAre":"black","prefs":{"autoQueen":2,"zen":0,"confirmResign":true,"enablePremove":true},"chat":{"lines":[]}}
''';

const _archivedGameJson = '''
{"id":"CCW6EEru","rated":true,"source":"lobby","variant":"standard","speed":"bullet","perf":"bullet","createdAt":1706185945680,"lastMoveAt":1706186170504,"status":"resign","players":{"white":{"user":{"name":"veloce","id":"veloce"},"rating":1789,"ratingDiff":9,"analysis":{"inaccuracy":2,"mistake":1,"blunder":3,"acpl":90}},"black":{"user":{"name":"chabrot","id":"chabrot"},"rating":1810,"ratingDiff":-9,"analysis":{"inaccuracy":3,"mistake":0,"blunder":5,"acpl":135}}},"winner":"white","opening":{"eco":"C52","name":"Italian Game: Evans Gambit, Main Line","ply":10},"moves":"e4 e5 Nf3 Nc6 Bc4 Bc5 b4 Bxb4 c3 Ba5 d4 Bb6 Ba3 Nf6 Qb3 d6 Bxf7+ Kf8 O-O Qe7 Nxe5 Nxe5 dxe5 Be6 Bxe6 Nxe4 Re1 Nc5 Bxc5 Bxc5 Qxb7 Re8 Bh3 dxe5 Qf3+ Kg8 Nd2 Rf8 Qd5+ Rf7 Be6 Qxe6 Qxe6","clocks":[12003,12003,11883,11811,11683,11379,11307,11163,11043,11043,10899,10707,10155,10483,10019,9995,9635,9923,8963,8603,7915,8283,7763,7459,7379,6083,6587,5819,6363,5651,6075,5507,5675,4803,5059,4515,4547,3555,3971,3411,3235,3123,3120,2742],"analysis":[{"eval":32},{"eval":41},{"eval":39},{"eval":20},{"eval":17},{"eval":21},{"eval":-21},{"eval":-14},{"eval":-23},{"eval":-24},{"eval":-24},{"eval":52,"best":"d7d6","variation":"d6","judgment":{"name":"Inaccuracy","comment":"Inaccuracy. d6 was best."}},{"eval":-56,"best":"f3e5","variation":"Nxe5","judgment":{"name":"Inaccuracy","comment":"Inaccuracy. Nxe5 was best."}},{"eval":177,"best":"d7d6","variation":"d6","judgment":{"name":"Blunder","comment":"Blunder. d6 was best."}},{"eval":-19,"best":"d4e5","variation":"dxe5 Ng4 Qd5 Nh6 Nbd2 Ne7 Qd3 O-O h3 d6 g4 Kh8 exd6 cxd6","judgment":{"name":"Blunder","comment":"Blunder. dxe5 was best."}},{"eval":-16},{"eval":-20},{"eval":-12},{"eval":-145,"best":"f7d5","variation":"Bd5 Nxd5","judgment":{"name":"Mistake","comment":"Mistake. Bd5 was best."}},{"eval":72,"best":"c6a5","variation":"Na5 Qd1 Kxf7 dxe5 dxe5 Nxe5+ Ke8 Nd2 Be6 Qa4+ Bd7 Qd1 Nc6 Ndc4","judgment":{"name":"Blunder","comment":"Blunder. Na5 was best."}},{"eval":-36,"best":"f7d5","variation":"Bd5 Nxd5 exd5 Na5 Qb4 exd4 cxd4 Kg8 Re1 Qf7 Ng5 Qg6 Nc3 h6","judgment":{"name":"Inaccuracy","comment":"Inaccuracy. Bd5 was best."}},{"eval":-41},{"eval":-42},{"eval":593,"best":"e7f7","variation":"Qxf7 exf6 gxf6 c4 Rg8 Nd2 Qh5 c5 Bh3 g3 Bxc5 Bxc5 dxc5 Rfe1","judgment":{"name":"Blunder","comment":"Blunder. Qxf7 was best."}},{"eval":589},{"eval":630},{"eval":-32,"best":"e5d6","variation":"exd6 cxd6 Bd5 Nxf2 Nd2 g5 Nc4 Kg7 Nxb6 Qe3 Rxf2 Rhf8 Bf3 axb6","judgment":{"name":"Blunder","comment":"Blunder. exd6 was best."}},{"eval":602,"best":"b6f2","variation":"Bxf2+","judgment":{"name":"Blunder","comment":"Blunder. Bxf2+ was best."}},{"eval":581},{"eval":656},{"eval":662},{"mate":15,"best":"g7g6","variation":"g6 Qxa8+ Kg7 Qd5 c6 Qb3 Rf8 Re2 Qh4 Qb7+ Kh6 Qb2 dxe5 Nd2","judgment":{"name":"Blunder","comment":"Checkmate is now unavoidable. g6 was best."}},{"eval":566,"best":"b7f3","variation":"Qf3+ Qf6 exf6 g6 f7 Kg7 fxe8=Q Rxe8 Qf7+ Kh6 Qxe8 d5 g4 c6","judgment":{"name":"Blunder","comment":"Lost forced checkmate sequence. Qf3+ was best."}},{"eval":574},{"eval":566},{"eval":580},{"eval":569},{"eval":774,"best":"g7g6","variation":"g6 Ne4 Kg7 Qe2 Rd8 a4 h5 Rad1 Rxd1 Rxd1 Bb6 Rd7 Qxd7 Bxd7","judgment":{"name":"Inaccuracy","comment":"Inaccuracy. g6 was best."}},{"eval":739},{"eval":743},{"eval":615},{"eval":934,"best":"c5f2","variation":"Bxf2+ Kh1 Bxe1 Rxe1 g6 Rf1 Kg7 Rxf7+ Qxf7 Bxf7 Rf8 Be6 e4 Qxe4","judgment":{"name":"Inaccuracy","comment":"Inaccuracy. Bxf2+ was best."}},{"eval":861}],"clock":{"initial":120,"increment":1,"totalTime":160}}
''';

const _archivedGameJsonNoEvals = '''
{"id":"CCW6EEru","rated":true,"source":"lobby","variant":"standard","speed":"bullet","perf":"bullet","createdAt":1706185945680,"lastMoveAt":1706186170504,"status":"resign","players":{"white":{"user":{"name":"veloce","id":"veloce"},"rating":1789,"ratingDiff":9},"black":{"user":{"name":"chabrot","id":"chabrot"},"rating":1810,"ratingDiff":-9}},"winner":"white","opening":{"eco":"C52","name":"Italian Game: Evans Gambit, Main Line","ply":10},"moves":"e4 e5 Nf3 Nc6 Bc4 Bc5 b4 Bxb4 c3 Ba5 d4 Bb6 Ba3 Nf6 Qb3 d6 Bxf7+ Kf8 O-O Qe7 Nxe5 Nxe5 dxe5 Be6 Bxe6 Nxe4 Re1 Nc5 Bxc5 Bxc5 Qxb7 Re8 Bh3 dxe5 Qf3+ Kg8 Nd2 Rf8 Qd5+ Rf7 Be6 Qxe6 Qxe6","clocks":[12003,12003,11883,11811,11683,11379,11307,11163,11043,11043,10899,10707,10155,10483,10019,9995,9635,9923,8963,8603,7915,8283,7763,7459,7379,6083,6587,5819,6363,5651,6075,5507,5675,4803,5059,4515,4547,3555,3971,3411,3235,3123,3120,2742],"clock":{"initial":120,"increment":1,"totalTime":160}}
''';
