import 'dart:async';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_providers.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_repository.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/utils/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'puzzle_activity.freezed.dart';
part 'puzzle_activity.g.dart';

const _nbPerPage = 50;
const _maxPuzzles = 500;

@riverpod
class PuzzleActivity extends _$PuzzleActivity {
  final _list = <PuzzleHistoryEntry>[];

  @override
  Future<PuzzleActivityState> build() async {
    ref.cacheFor(const Duration(minutes: 5));
    ref.onDispose(() {
      _list.clear();
    });
    final recentActivity = await ref.watch(puzzleRecentActivityProvider.future);
    if (recentActivity == null) {
      return const PuzzleActivityState(
        historyByDay: {},
        isLoading: false,
        hasMore: false,
        hasError: false,
      );
    }
    _list.addAll(recentActivity);
    return PuzzleActivityState(
      historyByDay: _groupByDay(_list),
      isLoading: false,
      hasMore: true,
      hasError: false,
    );
  }

  Map<DateTime, IList<PuzzleHistoryEntry>> _groupByDay(Iterable<PuzzleHistoryEntry> list) {
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

  Future<void> getNext() async {
    if (!state.hasValue) return;

    final currentVal = state.requireValue;
    if (currentVal.hasMore && _list.length < _maxPuzzles) {
      state = AsyncData(currentVal.copyWith(isLoading: true));
      try {
        final value = await ref.withClient(
          (client) => PuzzleRepository(client).puzzleActivity(_nbPerPage, before: _list.last.date),
        );
        if (value.isEmpty) {
          state = AsyncData(currentVal.copyWith(hasMore: false, isLoading: false));
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
      } catch (error) {
        state = AsyncData(currentVal.copyWith(isLoading: false, hasError: true));
      }
    }
  }
}

@freezed
sealed class PuzzleActivityState with _$PuzzleActivityState {
  const factory PuzzleActivityState({
    required Map<DateTime, IList<PuzzleHistoryEntry>> historyByDay,
    required bool isLoading,
    required bool hasMore,
    required bool hasError,
  }) = _PuzzleActivityState;
}
