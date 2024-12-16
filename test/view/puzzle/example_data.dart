import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_batch_storage.dart';

final puzzle = Puzzle(
  puzzle: PuzzleData(
    id: const PuzzleId('6Sz3s'),
    initialPly: 40,
    plays: 68176,
    rating: 1984,
    solution: IList(const ['h4h2', 'h1h2', 'e5f3', 'h2h3', 'b4h4']),
    themes: ISet(const ['middlegame', 'attraction', 'long', 'mateIn3', 'sacrifice', 'doubleCheck']),
  ),
  game: const PuzzleGame(
    rated: true,
    id: GameId('zgBwsXLr'),
    perf: Perf.blitz,
    pgn:
        'e4 c5 Nf3 e6 c4 Nc6 d4 cxd4 Nxd4 Bc5 Nxc6 bxc6 Be2 Ne7 O-O Ng6 Nc3 Rb8 Kh1 Bb7 f4 d5 f5 Ne5 fxe6 fxe6 cxd5 cxd5 exd5 Bxd5 Qa4+ Bc6 Qf4 Bd6 Ne4 Bxe4 Qxe4 Rb4 Qe3 Qh4 Qxa7',
    black: PuzzleGamePlayer(side: Side.black, name: 'CAMBIADOR'),
    white: PuzzleGamePlayer(side: Side.white, name: 'arroyoM10'),
  ),
);

final batch = PuzzleBatch(solved: IList(const []), unsolved: IList([puzzle]));

final puzzle2 = Puzzle(
  puzzle: PuzzleData(
    id: const PuzzleId('2nNdI'),
    rating: 1090,
    plays: 23890,
    initialPly: 88,
    solution: IList(const ['g4h4', 'h8h4', 'b4h4']),
    themes: ISet(const {'endgame', 'short', 'crushing', 'fork', 'queenRookEndgame'}),
  ),
  game: const PuzzleGame(
    id: GameId('w32JTzEf'),
    perf: Perf.blitz,
    rated: true,
    white: PuzzleGamePlayer(side: Side.white, name: 'Li', title: null),
    black: PuzzleGamePlayer(side: Side.black, name: 'Gabriela', title: null),
    pgn:
        'e4 e5 Nf3 Nc6 Bb5 a6 Ba4 b5 Bb3 Nf6 c3 Nxe4 d4 exd4 cxd4 Qe7 O-O Qd8 Bd5 Nf6 Bb3 Bd6 Nc3 O-O Bg5 h6 Bh4 g5 Nxg5 hxg5 Bxg5 Kg7 Ne4 Be7 Bxf6+ Bxf6 Qg4+ Kh8 Qh5+ Kg8 Qg6+ Kh8 Qxf6+ Qxf6 Nxf6 Nxd4 Rfd1 Ne2+ Kh1 d6 Rd5 Kg7 Nh5+ Kh6 Rad1 Be6 R5d2 Bxb3 axb3 Kxh5 Rxe2 Rfe8 Red2 Re5 h3 Rae8 Kh2 Re2 Rd5+ Kg6 f4 Rxb2 R1d3 Ree2 Rg3+ Kf6 h4 Re4 Rg4 Rxb3 h5 Rbb4 h6 Rxf4 h7 Rxg4 h8=Q+ Ke7 Rd3',
  ),
);
