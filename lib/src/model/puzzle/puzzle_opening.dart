import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_providers.dart';
import 'package:lichess_mobile/src/utils/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'puzzle_opening.freezed.dart';
part 'puzzle_opening.g.dart';

@freezed
class PuzzleOpeningFamily with _$PuzzleOpeningFamily {
  const factory PuzzleOpeningFamily({
    required String key,
    required String name,
    required int count,
    required IList<PuzzleOpeningData> openings,
  }) = _PuzzleOpeningFamily;
}

@freezed
class PuzzleOpeningData with _$PuzzleOpeningData {
  const factory PuzzleOpeningData({
    required String key,
    required String name,
    required int count,
  }) = _PuzzleOpeningData;
}

/// Returns a flattened list of openings with their respective counts.
///
/// The list is cached for 1 day.
@riverpod
Future<IList<PuzzleOpeningData>> flatOpeningsList(
  FlatOpeningsListRef ref,
) async {
  ref.cacheFor(const Duration(days: 1));
  final families = await ref.watch(puzzleOpeningsProvider.future);
  return families
      .map(
        (f) => [
          PuzzleOpeningData(key: f.key, name: f.name, count: f.count),
          ...f.openings.map(
            (o) => PuzzleOpeningData(
              key: o.key,
              name: '${f.name}: ${o.name}',
              count: o.count,
            ),
          ),
        ],
      )
      .expand((e) => e)
      .toIList();
}

@riverpod
Future<String> puzzleOpeningName(PuzzleOpeningNameRef ref, String key) async {
  final openings = await ref.watch(flatOpeningsListProvider.future);
  return openings.firstWhere((element) => element.key == key).name;
}
