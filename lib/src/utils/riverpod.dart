import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

extension AutoDisposeRefExtension<T> on AutoDisposeRef<T> {
  /// Keeps the provider alive for [duration]
  KeepAliveLink cacheFor(Duration duration) {
    final link = keepAlive();
    final timer = Timer(duration, link.close);
    onDispose(timer.cancel);
    return link;
  }
}
