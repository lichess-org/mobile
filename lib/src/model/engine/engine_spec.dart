import 'package:lichess_mobile/src/model/engine/engine_slot.dart';
import 'package:meta/meta.dart';
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

  /// A short name for the engine, for logs and failure reports.
  String get label;
}

/// A Stockfish engine, in one of the three flavors the app ships.
@immutable
final class StockfishSpec extends EngineSpec {
  /// Stockfish with a small NNUE network embedded in the binary.
  const StockfishSpec.light()
    : slot = EngineSlot.sfLight,
      flavor = StockfishFlavor.light,
      nnuePath = null;

  /// The latest Stockfish, with its net loaded from disk (see `StockfishNnueService`).
  const StockfishSpec.latest({required String this.nnuePath})
    : slot = EngineSlot.sfLatest,
      flavor = StockfishFlavor.latestNoNNUE;

  /// Fairy-Stockfish: chess variants, and the negative skill levels the weakest opponents need.
  const StockfishSpec.fairy()
    : slot = EngineSlot.fairy,
      flavor = StockfishFlavor.variant,
      nnuePath = null;

  @override
  final EngineSlot slot;

  /// The plugin flavor this spec starts.
  final StockfishFlavor flavor;

  @override
  String get label => flavor.name;

  /// The NNUE network, for [StockfishSpec.latest] only.
  final String? nnuePath;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StockfishSpec && other.slot == slot && other.nnuePath == nnuePath;

  @override
  int get hashCode => Object.hash(slot, nnuePath);

  @override
  String toString() => 'StockfishSpec(${flavor.name})';
}

/// Leela Chess Zero.
///
/// Note what this does *not* carry: the network. `setoption name WeightsFile` is
/// honoured at runtime — `Engine::SetPosition` rebuilds the backend when the
/// options it was built from have changed — so the network is a per-search
/// option like any other. Two Maia ratings are therefore the same spec, and
/// share one engine, rather than being two engines fighting over one slot.
final class Lc0Spec extends EngineSpec {
  const Lc0Spec();

  @override
  EngineSlot get slot => EngineSlot.lc0;

  @override
  String get label => 'lc0';

  @override
  bool operator ==(Object other) => other is Lc0Spec;

  @override
  int get hashCode => (Lc0Spec).hashCode;

  @override
  String toString() => 'Lc0Spec()';
}
