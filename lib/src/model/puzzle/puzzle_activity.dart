import 'dart:async';
import 'package:async/async.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:result_extensions/result_extensions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:lichess_mobile/src/utils/riverpod.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_repository.dart';

part 'puzzle_activity.g.dart';
part 'puzzle_activity.freezed.dart';

const _maxPuzzles = 500;

@riverpod
Future<IList<PuzzleHistoryEntry>> puzzleRecentActivity(
  PuzzleRecentActivityRef ref,
) {
  ref.cacheFor(const Duration(minutes: 10));
  final repo = ref.watch(puzzleRepositoryProvider);
  return Result.release(repo.puzzleActivity(10));
}

@riverpod
class PuzzleActivity extends _$PuzzleActivity {
  final _list = <PuzzleHistoryEntry>[];

  @override
  Future<PuzzleActivityState> build() async {
    ref.cacheFor(const Duration(minutes: 10));
    ref.onDispose(() {
      _list.clear();
    });
    _list.addAll(await ref.read(puzzleRecentActivityProvider.future));
    return PuzzleActivityState(
      historyByDay: _groupByDay(_list),
      isLoading: false,
      hasMore: true,
      hasError: false,
    );
  }

  Map<DateTime, IList<PuzzleHistoryEntry>> _groupByDay(
    Iterable<PuzzleHistoryEntry> list,
  ) {
    final map = <DateTime, IList<PuzzleHistoryEntry>>{};
    for (final entry in list) {
      final date = DateTime(entry.date.year, entry.date.month, entry.date.day);
      if (map.containsKey(date)) {
        map[date] = map[date]!.add(entry);
      } else {
        map[date] = IList([entry]);
      }
    }
    return map;
  }

  void getNext() {
    final currentVal = state.requireValue;
    if (_list.length < _maxPuzzles) {
      state = AsyncData(currentVal.copyWith(isLoading: true));
      ref
          .read(puzzleRepositoryProvider)
          .puzzleActivity(50, before: _list.last.date)
          .fold(
        (value) {
          if (value.isEmpty) {
            state = AsyncData(
              currentVal.copyWith(hasMore: false, isLoading: false),
            );
            return;
          }
          _list.addAll(value);
          state = AsyncData(
            PuzzleActivityState(
              historyByDay: _groupByDay(_list),
              isLoading: false,
              hasMore: true,
              hasError: false,
            ),
          );
        },
        (error, stackTrace) {
          state =
              AsyncData(currentVal.copyWith(isLoading: false, hasError: true));
        },
      );
    }
  }
}

@freezed
class PuzzleActivityState with _$PuzzleActivityState {
  const factory PuzzleActivityState({
    required Map<DateTime, IList<PuzzleHistoryEntry>> historyByDay,
    required bool isLoading,
    required bool hasMore,
    required bool hasError,
  }) = _PuzzleActivityState;
}
