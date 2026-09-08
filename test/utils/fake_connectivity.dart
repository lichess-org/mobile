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

/// A fake implementation of [Connectivity] whose check never completes, to
/// simulate the app starting up before the connectivity status is known.
class PendingConnectivity implements Connectivity {
  @override
  Future<List<ConnectivityResult>> checkConnectivity() =>
      Completer<List<ConnectivityResult>>().future;

  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      const Stream<List<ConnectivityResult>>.empty();
}

/// A fake implementation of [Connectivity] whose check always fails, to simulate the plugin
/// itself going wrong.
///
/// It throws an [Error] rather than an [Exception] so that riverpod does not retry the build it
/// makes fail: what is under test is the state that failure leaves behind.
class FailingConnectivity implements Connectivity {
  @override
  Future<List<ConnectivityResult>> checkConnectivity() =>
      Future.error(StateError('the connectivity plugin failed'));

  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged => FakeConnectivity.controller.stream;
}

/// A fake [Connectivity] whose check fails, but only once [failNow] is called.
///
/// Lets a test have a socket connect while the very first check is still running, and only then
/// have the plugin go wrong.
class PendingThenFailingConnectivity implements Connectivity {
  final _failure = Completer<void>();

  /// Makes the pending check fail.
  void failNow() => _failure.complete();

  @override
  Future<List<ConnectivityResult>> checkConnectivity() async {
    await _failure.future;
    throw StateError('the connectivity plugin failed');
  }

  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged => FakeConnectivity.controller.stream;
}

/// A fake [Connectivity] whose check works until [shouldFail] is set, and fails from then on.
///
/// Lets a test have the plugin go wrong on a check that is not the first one.
class SwitchableConnectivity implements Connectivity {
  bool shouldFail = false;

  @override
  Future<List<ConnectivityResult>> checkConnectivity() => shouldFail
      ? Future.error(StateError('the connectivity plugin failed'))
      : Future.value([ConnectivityResult.wifi]);

  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged => FakeConnectivity.controller.stream;
}
