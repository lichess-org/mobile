import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/log/app_log_storage.dart';
import 'package:lichess_mobile/src/model/settings/log_preferences.dart';

part 'app_log_paginator.freezed.dart';

/// The number of app logs to fetch per page.
const _pageSize = 20;

/// A provider for [AppLogPaginator].
///
/// The family argument is the optional search query string.
final appLogPaginatorProvider = AsyncNotifierProvider.autoDispose
    .family<AppLogPaginator, AppLogState, String?>(
      AppLogPaginator.new,
      name: 'AppLogPaginatorProvider',
    );

/// A Riverpod controller for managing paginated app log entries.
class AppLogPaginator extends AsyncNotifier<AppLogState> {
  AppLogPaginator(this._searchQuery);

  final String? _searchQuery;

  @override
  Future<AppLogState> build() async {
    final storage = await ref.read(appLogStorageProvider.future);
    final minLevelValue = ref.watch(logPreferencesProvider.select((p) => p.level.value));
    return AppLogState(
      data: IList.new([
        await AsyncValue.guard(
          () => storage.page(
            limit: _pageSize,
            minLevelValue: minLevelValue,
            searchQuery: _searchQuery,
          ),
        ),
      ]),
    );
  }

  /// Fetches the next page of app logs.
  Future<void> next() async {
    if (state.hasValue && state.requireValue.hasMore) {
      final storage = await ref.read(appLogStorageProvider.future);
      final minLevelValue = ref.read(logPreferencesProvider.select((p) => p.level.value));
      final asyncPage = await AsyncValue.guard(
        () => storage.page(
          limit: _pageSize,
          cursor: state.requireValue.nextPage,
          minLevelValue: minLevelValue,
          searchQuery: _searchQuery,
        ),
      );
      state = AsyncValue.data(
        state.requireValue.copyWith(data: state.requireValue.data.add(asyncPage)),
      );
    }
  }

  /// Deletes all app logs from the database and refreshes.
  Future<void> deleteAll() async {
    final storage = await ref.read(appLogStorageProvider.future);
    await storage.deleteAll();
    ref.invalidateSelf();
  }

  /// Refreshes by fetching the first page again.
  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

@freezed
sealed class AppLogState with _$AppLogState {
  const AppLogState._();

  const factory AppLogState({required IList<AsyncValue<AppLogPage>> data}) = _AppLogState;

  bool get initialized => data.isNotEmpty;
  List<AppLogEntry> get logs =>
      data.expand<AppLogEntry>((e) => e.value?.items ?? <AppLogEntry>[]).toList();
  int? get nextPage => data.lastOrNull?.value?.next;
  bool get hasMore => initialized && nextPage != null;
  bool get isLoading => data.lastOrNull?.isLoading == true;
  bool get isDeleteButtonVisible => logs.isNotEmpty;
}
