import 'dart:async';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:lichess_mobile/src/model/common/http.dart';

extension AutoDisposeRefExtension<T> on AutoDisposeRef<T> {
  /// Keeps the provider alive for [duration]
  KeepAliveLink cacheFor(Duration duration) {
    final link = keepAlive();
    final timer = Timer(duration, link.close);
    onDispose(timer.cancel);
    return link;
  }

  /// Runs [fn] with an [AuthClient] and keeps the provider alive for [duration].
  /// This is primarily used for caching network requests in a [FutureProvider].
  ///
  /// The client is automatically closed after [fn] completes or when the
  /// provider is disposed.
  ///
  /// If [fn] throws with a [SocketException], the provider is not kept alive, this
  /// allows to retry the request later.
  Future<U> withAuthClientCacheFor<U>(
    Future<U> Function(http.Client) fn,
    Duration duration,
  ) async {
    final link = keepAlive();
    final timer = Timer(duration, link.close);
    final client = read(authClientFactoryProvider)();
    onDispose(() {
      client.close();
      timer.cancel();
    });
    try {
      return await fn(client);
    } on SocketException catch (_) {
      link.close();
      rethrow;
    } finally {
      client.close();
    }
  }
}

extension RefExtension on Ref {
  /// Delays an execution by a bit such that if a dependency changes multiple
  /// time rapidly, the rest of the code is only run once.
  Future<void> debounce(Duration duration) {
    final completer = Completer<void>();
    final timer = Timer(duration, () {
      if (!completer.isCompleted) completer.complete();
    });
    onDispose(() {
      timer.cancel();
      if (!completer.isCompleted) {
        completer.completeError(StateError('Cancelled'));
      }
    });
    return completer.future;
  }

  /// Runs [fn] with an [AuthClient].
  ///
  /// The client is automatically closed after [fn] completes or when the
  /// provider is disposed.
  Future<T> withAuthClient<T>(Future<T> Function(http.Client) fn) async {
    final client = read(authClientFactoryProvider)();
    onDispose(client.close);
    try {
      return await fn(client);
    } finally {
      client.close();
    }
  }
}
