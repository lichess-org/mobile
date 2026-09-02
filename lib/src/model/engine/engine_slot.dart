/// A native engine library. At most one engine per slot can be live in the process.
///
/// This is the only place in the app that names the native single-instance constraint;
/// everything above works with [EngineSpec] and never has to think about it. Two [EngineSpec]s
/// that resolve to the same slot are the same spec, so a slot can never be asked for two engines
/// through the ordinary engine plumbing.
enum EngineSlot {
  /// Stockfish 16, with its NNUE network embedded in the binary.
  sf16,

  /// The latest Stockfish, whose networks are loaded from disk.
  sfLatest,

  /// Fairy-Stockfish: chess variants, and negative skill levels.
  fairy,

  /// Leela Chess Zero, which is also how Maia is played: Maia is LC0 with a
  /// Maia network.
  lc0,
}
