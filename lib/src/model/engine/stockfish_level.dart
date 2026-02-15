/// Stockfish strength levels. Level 1 is the easiest, level 12 is the hardest.
enum StockfishLevel {
  level1(elo: 1320, multiPv: 10, searchTime: Duration(milliseconds: 500), threads: 1),
  level2(elo: 1450, multiPv: 8, searchTime: Duration(milliseconds: 500), threads: 1),
  level3(elo: 1550, multiPv: 7, searchTime: Duration(milliseconds: 610), threads: 1),
  level4(elo: 1650, multiPv: 6, searchTime: Duration(milliseconds: 765), threads: 1),
  level5(elo: 1750, multiPv: 5, searchTime: Duration(milliseconds: 920), threads: 1),
  level6(elo: 1850, multiPv: 4, searchTime: Duration(milliseconds: 1075), threads: 2),
  level7(elo: 1950, multiPv: 4, searchTime: Duration(milliseconds: 1225), threads: 2),
  level8(elo: 2100, multiPv: 4, searchTime: Duration(milliseconds: 1380), threads: 2),
  level9(elo: 2300, multiPv: 4, searchTime: Duration(milliseconds: 1535), threads: 2),
  level10(elo: 2550, multiPv: 4, searchTime: Duration(milliseconds: 1690), threads: 2),
  level11(elo: 2850, multiPv: 4, searchTime: Duration(milliseconds: 1845), threads: 2),
  level12(elo: 3190, multiPv: 4, searchTime: Duration(milliseconds: 2000), threads: 2);

  const StockfishLevel({
    required this.elo,
    required this.multiPv,
    required this.searchTime,
    required this.threads,
  });

  /// The internal Elo rating used to limit Stockfish strength.
  final int elo;

  /// Number of principal variations to compute for move selection.
  ///
  /// Stockfish's strength limiting works by applying a randomized bias to scores
  /// of slightly worse moves among at least 4 candidates. MultiPV increases
  /// this candidate pool, giving more suboptimal moves to choose from at lower Elos.
  final int multiPv;

  /// Search time for this level.
  final Duration searchTime;

  /// Number of threads to use for move computation.
  final int threads;

  /// The display level number (1-12).
  int get level => index + 1;

  /// The default level for new games.
  static const defaultLevel = StockfishLevel.level4;
}
