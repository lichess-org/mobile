import 'package:lichess_mobile/src/model/engine/engine_slot.dart';
import 'package:multistockfish/multistockfish.dart';

/// What engine to create.
///
/// A spec is a value type, because it is the identity of a live engine: two callers asking for the
/// same spec get the same [Engine], and two specs that would run in the same native library are
/// by construction the same spec. See [EngineSlot].
///
/// Note what a spec does *not* carry: the chess variant. `UCI_Variant` is a per-search option
/// rather than a start-up parameter, so an atomic analysis and an atomic opponent — or two screens
/// on two different variants — share one Fairy-Stockfish engine instead of colliding over it.
sealed class EngineSpec {
  const EngineSpec();

  /// The native library this engine runs in.
  EngineSlot get slot;

  /// The plugin flavor this spec starts.
  StockfishFlavor get flavor;
}

/// A Stockfish engine, in one of the three flavors the app ships.
final class StockfishSpec extends EngineSpec {
  /// Stockfish 16, NNUE embedded in the binary.
  const StockfishSpec.sf16()
    : slot = EngineSlot.sf16,
      flavor = StockfishFlavor.sf16,
      bigNetPath = null,
      smallNetPath = null;

  /// The latest Stockfish, with its nets loaded from disk (see `NnueService`).
  const StockfishSpec.latest({required String this.bigNetPath, required String this.smallNetPath})
    : slot = EngineSlot.sfLatest,
      flavor = StockfishFlavor.latestNoNNUE;

  /// Fairy-Stockfish: chess variants, and the negative skill levels the weakest opponents need.
  const StockfishSpec.fairy()
    : slot = EngineSlot.fairy,
      flavor = StockfishFlavor.variant,
      bigNetPath = null,
      smallNetPath = null;

  @override
  final EngineSlot slot;

  @override
  final StockfishFlavor flavor;

  /// The big NNUE network, for [StockfishSpec.latest] only.
  final String? bigNetPath;

  /// The small NNUE network, for [StockfishSpec.latest] only.
  final String? smallNetPath;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StockfishSpec &&
          other.slot == slot &&
          other.bigNetPath == bigNetPath &&
          other.smallNetPath == smallNetPath;

  @override
  int get hashCode => Object.hash(slot, bigNetPath, smallNetPath);

  @override
  String toString() => 'StockfishSpec(${flavor.name})';
}
