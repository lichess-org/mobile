import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/utils/pgn_text_guard.dart';

void main() {
  group('isPgnText', () {
    test('accepts standard PGN with headers and empty line before moves', () {
      const pgn = '''
[Event "Live Chess"]
[Site "Chess.com"]
[Date "2026.10.30"]
[Round "?"]
[White "louis186"]
[Black "lousysp0re"]
[Result "0-1"]
[TimeControl "600"]
[WhiteElo "1313"]
[BlackElo "1319"]
[Termination "lousysp0re won by resignation"]
[ECO "B10"]
[EndTime "12:33:43 GMT+0000"]
[Link "https://www.chess.com/game/live/186215352060?move=0"]

1. e4 c6 2. Nf3 d5 3. e5 Bg4 4. d4 g6 5. Bg5 Bg7 6. h3 Bxf3 7. Qxf3 h6 8. Bf4 g5
9. Bh2 e6 10. Nd2 Ne7 11. c4 Nf5 12. Nb3 a6 13. Bd3 dxc4 14. Bxc4 a5 15. O-O-O
a4 16. Nc5 Qb6 17. b3 axb3 18. Bxb3 Nd7 19. Nxd7 Kxd7 20. d5 cxd5 21. Bxd5 Rhc8+
22. Kd2 Rxa2+ 23. Ke1 Qb4+ 24. Kf1 Qb5+ 25. Qd3 Qxd3+ 26. Rxd3 exd5 27. Rxd5+
Ke7 28. g4 Rc1+ 29. Kg2 Rcc2 30. Rf1 Ne3+ 31. Kf3 Nxd5 32. Ke4 Ke6 33. Rd1 Nc3+
0-1
''';
      expect(isPgnText(pgn), isTrue);
    });

    test('accepts Chess.com mobile format without blank line before moves', () {
      const pgn = '''
[Site "Chess.com"]
[Date "2026-10-30"]
[White "louis186"]
[Black "lousysp0re"]
[Result "0-1"]
[WhiteElo "1313"]
[BlackElo "1319"]
[TimeControl "600"]
1. e4 c6 2. Nf3 d5 3. e5 Bg4 4. d4 g6 5. Bg5 Bg7 6. h3 Bxf3 7. Qxf3 h6 8. Bf4 g5
9. Bh2 e6 10. Nd2 Ne7 11. c4 Nf5 12. Nb3 a6 13. Bd3 dxc4 14. Bxc4 a5 15. O-O-O
a4 16. Nc5 Qb6 17. b3 axb3 18. Bxb3 Nd7 19. Nxd7 Kxd7 20. d5 cxd5 21. Bxd5 Rhc8+
22. Kd2 Rxa2+ 23. Ke1 Qb4+ 24. Kf1 Qb5+ 25. Qd3 Qxd3+ 26. Rxd3 exd5 27. Rxd5+
Ke7 28. g4 Rc1+ 29. Kg2 Rcc2 30. Rf1 Ne3+ 31. Kf3 Nxd5 32. Ke4 Ke6 33. Rd1 Nc3+ 0-1
''';
      expect(isPgnText(pgn), isTrue);
    });

    test('accepts raw move-only PGN without headers', () {
      const pgn = '1. e4 c6 2. Nf3 d5 3. e5 Bg4 4. d4 g6 0-1';
      expect(isPgnText(pgn), isTrue);
    });

    test('accepts move list starting with black move', () {
      const pgn = '1... e5 2. Nf3 Nc6 3. Bb5 *';
      expect(isPgnText(pgn), isTrue);
    });

    test('accepts FEN starting position header', () {
      const pgn = '[FEN "8/8/8/8/8/8/8/K6k w - - 0 1"]\n\n*';
      expect(isPgnText(pgn), isTrue);
    });

    test('accepts multi-game PGN string', () {
      const pgn = '''
[Event "Game 1"]
[White "Player A"]
[Black "Player B"]
1. e4 e5 1-0

[Event "Game 2"]
[White "Player C"]
[Black "Player D"]
1. d4 d5 0-1
''';
      expect(isPgnText(pgn), isTrue);
    });

    test('rejects empty and whitespace-only text', () {
      expect(isPgnText(''), isFalse);
      expect(isPgnText('   \n\t  '), isFalse);
    });

    test('rejects arbitrary chat messages', () {
      expect(isPgnText('Hey, are you down for a quick chess game?'), isFalse);
      expect(isPgnText('Check this out, it was awesome!'), isFalse);
      expect(isPgnText('1. We need to talk about yesterday.'), isFalse);
    });

    test('rejects URLs', () {
      expect(isPgnText('https://www.chess.com/game/live/186215352060?move=0'), isFalse);
      expect(isPgnText('https://lichess.org/analysis'), isFalse);
    });

    test('rejects numbered lists that are not chess moves', () {
      const list = '''
1. Buy milk
2. Clean room
3. Read book
''';
      expect(isPgnText(list), isFalse);
    });

    test('rejects markdown links and json arrays', () {
      expect(isPgnText('[Lichess](https://lichess.org)'), isFalse);
      expect(isPgnText('["item1", "item2"]'), isFalse);
    });
  });
}
