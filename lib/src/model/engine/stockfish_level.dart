/// Stockfish strength levels. Level 1 is the easiest, level 12 is the hardest.
enum StockfishLevel {
  level1(skill: -12, multiPv: 10, searchTime: Duration(milliseconds: 500), threads: 1),
  level2(skill: -6, multiPv: 8, searchTime: Duration(milliseconds: 500), threads: 1),
  level3(skill: -1, multiPv: 7, searchTime: Duration(milliseconds: 610), threads: 1),
  level4(skill: 3, multiPv: 6, searchTime: Duration(milliseconds: 765), threads: 1),
  level5(skill: 6, multiPv: 5, searchTime: Duration(milliseconds: 920), threads: 1),
  level6(skill: 8, multiPv: 4, searchTime: Duration(milliseconds: 1075), threads: 2),
  level7(skill: 10, multiPv: 4, searchTime: Duration(milliseconds: 1225), threads: 2),
  level8(skill: 12, multiPv: 4, searchTime: Duration(milliseconds: 1380), threads: 2),
  level9(skill: 14, multiPv: 4, searchTime: Duration(milliseconds: 1535), threads: 2),
  level10(skill: 16, multiPv: 4, searchTime: Duration(milliseconds: 1690), threads: 2),
  level11(skill: 18, multiPv: 4, searchTime: Duration(milliseconds: 1845), threads: 2),
  level12(skill: 20, multiPv: 4, searchTime: Duration(milliseconds: 2000), threads: 2);

  const StockfishLevel({
    required this.skill,
    required this.multiPv,
    required this.searchTime,
    required this.threads,
  });

  /// The internal Stockfish skill level (from -20 to 20).
  ///
  /// Since we are using negative skill levels for the easier levels, this should only be used with
  /// Fairy-Stockfish, which supports negative skill levels. For regular Stockfish, the minimum skill level is 0.
  final int skill;

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
