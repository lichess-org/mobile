import 'dart:async';

import 'package:async/async.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:result_extensions/result_extensions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:lichess_mobile/src/utils/riverpod.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_repository.dart';

part 'history_provider.g.dart';
part 'history_provider.freezed.dart';

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
  PuzzleRepository? _repo;
  @override
  Future<PuzzleActivityState> build() async {
    ref.cacheFor(const Duration(minutes: 10));
    _repo = ref.read(puzzleRepositoryProvider);
    final value = await ref.read(puzzleRecentActivityProvider.future);
    return PuzzleActivityState(
      list: value,
      isLoading: false,
      hasMore: true,
      hasError: false,
    );
  }

  void getNext() {
    final currentVal = state.requireValue;
    if (currentVal.list.length < _maxPuzzles) {
      state = AsyncData(currentVal.copyWith(isLoading: true));
      _repo!.puzzleActivity(50, before: currentVal.list.last.date).fold(
        (value) {
          if (value.isEmpty) {
            state = AsyncData(
              currentVal.copyWith(hasMore: false, isLoading: false),
            );
            return;
          }
          state = AsyncData(
            PuzzleActivityState(
              list: IList([...currentVal.list, ...value]),
              isLoading: false,
              hasMore: true,
              hasError: false,
            ),
          );
        },
        (error, stackTrace) {
          state =
              AsyncData(currentVal.copyWith(isLoading: false, hasError: true));
          Timer.periodic(const Duration(seconds: 1), (_) {
            state = AsyncData(
              currentVal.copyWith(isLoading: false, hasError: false),
            );
          });
        },
      );
    }
  }
}

@freezed
class PuzzleActivityState with _$PuzzleActivityState {
  const factory PuzzleActivityState({
    required IList<PuzzleHistoryEntry> list,
    required bool isLoading,
    required bool hasMore,
    required bool hasError,
  }) = _PuzzleActivityState;
}
