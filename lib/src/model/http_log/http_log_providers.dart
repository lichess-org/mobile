import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/http_log/http_log_storage.dart';

part 'http_log_providers.freezed.dart';

final httpLogsNotifierProvider = StateNotifierProvider((ref) => HttpLogsNotifier(ref));

class HttpLogsNotifier extends StateNotifier<HttpLogsState> {
  HttpLogsNotifier(this.ref) : super(const HttpLogsState.initial()) {
    fetchNextPage();
  }

  final Ref ref;

  Future<void> fetchNextPage() async {
    if (state is LoadingHttpLogsState) return;
    if (state is DataHttpLogsState && (state as DataHttpLogsState).next == null) return;
    state = switch (state) {
      final InitialHttpLogsState initial => initial,
      DataHttpLogsState(:final httpLogs, :final next) => HttpLogsState.loading(
        httpLogs: httpLogs,
        next: next,
      ),
      ErrorHttpLogsState(:final httpLogs, :final next) => HttpLogsState.loading(
        httpLogs: httpLogs,
        next: next,
      ),
      LoadingHttpLogsState() => throw StateError('State should not be loading.'),
    };
    try {
      final storage = await ref.read(httpLogStorageProvider.future);
      final data = await storage.page(cursor: (state as LoadingHttpLogsState).next);
      state = switch (state) {
        InitialHttpLogsState() => HttpLogsState.data(httpLogs: data.items, next: data.next),
        LoadingHttpLogsState(:final httpLogs) => HttpLogsState.data(
          httpLogs: httpLogs.addAll(data.items),
          next: data.next,
        ),
        _ => throw StateError('State should be initial of loading.'),
      };
    } catch (e) {
      state = switch (state) {
        InitialHttpLogsState() => HttpLogsState.error(
          error: e,
          httpLogs: const IList.empty(),
          next: null,
        ),
        LoadingHttpLogsState(:final httpLogs, :final next) => HttpLogsState.error(
          error: e,
          httpLogs: httpLogs,
          next: next,
        ),
        _ => throw StateError('State should be initial or loading.'),
      };
    }
  }

  Future<void> refresh() async {
    state = const HttpLogsState.initial();
    await fetchNextPage();
  }
}

@freezed
sealed class HttpLogsState with _$HttpLogsState {
  const factory HttpLogsState.initial() = InitialHttpLogsState;

  const factory HttpLogsState.data({required IList<HttpLog> httpLogs, int? next}) =
      DataHttpLogsState;

  const factory HttpLogsState.loading({required IList<HttpLog> httpLogs, int? next}) =
      LoadingHttpLogsState;

  const factory HttpLogsState.error({
    required Object error,
    required IList<HttpLog> httpLogs,
    int? next,
  }) = ErrorHttpLogsState;
}
