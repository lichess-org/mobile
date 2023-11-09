import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:lichess_mobile/src/model/puzzle/puzzle_providers.dart';

part 'puzzle_opening.g.dart';
part 'puzzle_opening.freezed.dart';

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

@riverpod
Future<IList<PuzzleOpeningData>> _flatOpeningsList(
  _FlatOpeningsListRef ref,
) async {
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
  final openings = await ref.watch(_flatOpeningsListProvider.future);
  return openings.firstWhere((element) => element.key == key).name;
}
