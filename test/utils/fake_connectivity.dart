import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

/// A fake implementation of [Connectivity] that always returns [ConnectivityResult.wifi].
class FakeConnectivity implements Connectivity {
  @override
  Future<List<ConnectivityResult>> checkConnectivity() {
    return Future.value([ConnectivityResult.wifi]);
  }

  /// A broadcast stream controller of connectivity changes.
  ///
  /// This is used to simulate connectivity changes in tests.
  static StreamController<List<ConnectivityResult>> controller = StreamController.broadcast();

  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged => controller.stream;
}
