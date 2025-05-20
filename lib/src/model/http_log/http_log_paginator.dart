import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/http_log/http_log_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'http_log_paginator.freezed.dart';
part 'http_log_paginator.g.dart';

/// The number of HTTP logs to fetch per page.
const _pageSize = 20;

/// A Riverpod controller for managing HTTP logs.
///
/// The `HttpLogController` class is responsible for fetching and managing
/// paginated HTTP log entries from the storage. It uses a throttler to limit
/// the rate of fetching new pages.
@riverpod
class HttpLogPaginator extends _$HttpLogPaginator {
  @override
  Future<HttpLogState> build() async {
    final storage = await ref.read(httpLogStorageProvider.future);
    return HttpLogState(
      data: IList.new([await AsyncValue.guard(() => storage.page(limit: _pageSize))]),
    );
  }

  /// Fetches the next page of HTTP logs.
  ///
  /// This method uses a throttler to limit the rate of fetching new pages.
  /// It updates the state with the new page of HTTP logs.
  Future<void> next() async {
    if (state.hasValue && state.requireValue.hasMore) {
      final storage = await ref.read(httpLogStorageProvider.future);
      final asyncPage = await AsyncValue.guard(
        () => storage.page(limit: _pageSize, cursor: state.requireValue.nextPage),
      );
      state = AsyncValue.data(
        state.requireValue.copyWith(data: state.requireValue.data.add(asyncPage)),
      );
    }
  }

  /// Deletes all HTTP logs from the storage.
  ///
  /// This method reads the `httpLogStorageProvider` to get the storage instance
  /// and then deletes all the logs from the storage. After deletion, it updates
  /// the state with an empty list of HTTP logs.
  ///
  /// Returns a [Future] that completes when the deletion is done.
  Future<void> deleteAll() async {
    final storage = await ref.read(httpLogStorageProvider.future);
    await storage.deleteAll();
    ref.invalidateSelf();
  }

  /// Refreshes the HTTP logs by fetching the first page again.
  ///
  /// This method updates the state with the first page of HTTP logs.
  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

@freezed
sealed class HttpLogState with _$HttpLogState {
  const HttpLogState._();

  const factory HttpLogState({required IList<AsyncValue<HttpLog>> data}) = _HttpLogState;

  bool get initialized => data.isNotEmpty;
  List<HttpLogEntry> get logs =>
      data.expand((e) => e.valueOrNull?.items ?? <HttpLogEntry>[]).toList();
  int? get nextPage => data.lastOrNull?.valueOrNull?.next;
  bool get hasMore => initialized && nextPage != null;
  bool get isLoading => data.lastOrNull?.isLoading == true;
  bool get isDeleteButtonVisible => logs.isNotEmpty;
}
