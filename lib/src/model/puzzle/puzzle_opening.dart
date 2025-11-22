import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_providers.dart';

typedef PuzzleOpeningFamily = ({
  String key,
  String name,
  int count,
  IList<PuzzleOpeningData> openings,
});

typedef PuzzleOpeningData = ({String key, String name, int count});

/// Returns a flattened list of openings with their respective counts.
final flatOpeningsListProvider = FutureProvider.autoDispose<IList<PuzzleOpeningData>>((
  Ref ref,
) async {
  final families = await ref.watch(puzzleOpeningsProvider.future);
  return families
      .map(
        (f) => [
          (key: f.key, name: f.name, count: f.count),
          ...f.openings.map((o) => (key: o.key, name: '${f.name}: ${o.name}', count: o.count)),
        ],
      )
      .expand((e) => e)
      .toIList();
}, name: 'FlatOpeningsListProvider');

/// Provides the name of a puzzle opening given its key.
final puzzleOpeningNameProvider = FutureProvider.autoDispose.family<String, String>((
  Ref ref,
  String key,
) async {
  final openings = await ref.watch(flatOpeningsListProvider.future);
  return openings.firstWhere((element) => element.key == key).name;
}, name: 'PuzzleOpeningNameProvider');
