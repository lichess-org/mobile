import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:lichess_mobile/src/model/http_log/http_log_storage.dart';
import 'package:lichess_mobile/src/utils/rate_limit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'http_log_controller.g.dart';

const _pageSize = 12;

/// A Riverpod controller for managing HTTP logs.
///
/// The `HttpLogController` class is responsible for fetching and managing
/// paginated HTTP log entries from the storage. It uses a throttler to limit
/// the rate of fetching new pages.
@riverpod
class HttpLogController extends _$HttpLogController {
  final Throttler _throttler = Throttler(const Duration(milliseconds: 300));

  /// Builds the initial state of the controller by fetching the first page of HTTP logs.
  @override
  Future<HttpLogs> build() async {
    final storage = await ref.read(httpLogStorageProvider.future);
    return storage.page(limit: _pageSize);
  }

  /// Fetches the next page of HTTP logs.
  ///
  /// This method uses a throttler to limit the rate of fetching new pages.
  /// It updates the state with the new page of HTTP logs.
  Future<void> next() async {
    _throttler(() async {
      if (state.isLoading) return;
      if (state.hasValue && state.value?.next == null) return;
      final storage = await ref.read(httpLogStorageProvider.future);
      state = const AsyncValue.loading();
      state = await AsyncValue.guard(() async {
        final data = await storage.page(cursor: state.value?.next, limit: _pageSize);
        return HttpLogs(items: state.value?.items.addAll(data.items) ?? data.items, next: data.next);
      });
    });
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
    state = await AsyncValue.guard(() async {
      await storage.deleteAll();
      return const HttpLogs(items: IList.empty(), next: null);
    });
  }

  /// Refreshes the HTTP logs by fetching the first page again.
  ///
  /// This method updates the state with the first page of HTTP logs.
  Future<void> refresh() async {
    final storage = await ref.read(httpLogStorageProvider.future);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async => storage.page(limit: _pageSize));
  }
}
