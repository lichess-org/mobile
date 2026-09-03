import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/network/server_status.dart';
import 'package:lichess_mobile/src/network/socket.dart';
import 'package:lichess_mobile/src/utils/rate_limit.dart';
import 'package:logging/logging.dart';

final _logger = Logger('Connectivity');

const kConnectivityThrottleDelay = Duration(seconds: 5);

/// A provider that exposes a [Connectivity] instance.
final connectivityPluginProvider = Provider<Connectivity>((Ref _) => Connectivity());

/// Whether the device has a network connection.
///
/// This is the synchronous, optimistic view of [connectivityChangesProvider]: while the check is
/// still running the device is assumed to be online, as the check makes network requests and is
/// therefore not instant.
///
/// Use this to gate anything that merely needs a connection. Watch [connectivityChangesProvider]
/// directly in the rare places that must not be optimistic, and [lichessConnectionStatusProvider]
/// where a lichess outage has to be shown.
final isDeviceOnlineProvider = Provider.autoDispose<bool>((ref) {
  return ref.watch(connectivityChangesProvider.select(_isDeviceOnlineIn));
}, name: 'IsDeviceOnlineProvider');

/// [isDeviceOnlineProvider]'s view of a connectivity status.
bool _isDeviceOnlineIn(AsyncValue<ConnectivityStatus> status) => switch (status) {
  // A check that failed does mean we could not reach anything.
  AsyncValue(hasError: true) => false,
  // The last known answer, whether it comes from a settled check or from a re-run that has not
  // completed yet.
  AsyncValue(:final value?) => value.isOnline,
  _ => true,
};

/// Represents the connection state of the app with respect to the lichess server.
enum LichessConnectionStatus {
  /// The device is online and the lichess server is reachable.
  online,

  /// The device has no network connection.
  networkDown,

  /// The device is online but the lichess server is undergoing planned maintenance.
  serverMaintenance,

  /// The device is online but the lichess server is unreachable.
  serverDown;

  /// Whether the lichess server is unavailable, be it for maintenance or an outage.
  ///
  /// The device itself is online in both cases, so offline features keep working.
  bool get isServerUnavailable => this == .serverMaintenance || this == .serverDown;
}

/// A provider that exposes the current [LichessConnectionStatus].
///
/// Reserve this for the tabs that show a [ServerOutageDisplay]: it is the only place where a
/// lichess outage should change the UI. Elsewhere, gate on [isDeviceOnlineProvider] instead — a
/// disabled link does not explain itself, so it is better to let the user follow it and see the
/// error than to grey it out because the server happens to be down.
///
/// Beware too that other lichess services, such as the opening explorer or the tablebase, run on
/// their own servers and may well be reachable while the main server is down.
final lichessConnectionStatusProvider = Provider.autoDispose<LichessConnectionStatus>((ref) {
  if (!ref.watch(isDeviceOnlineProvider)) return LichessConnectionStatus.networkDown;
  return switch (ref.watch(serverStatusProvider)) {
    ServerStatus.up => LichessConnectionStatus.online,
    ServerStatus.maintenance => LichessConnectionStatus.serverMaintenance,
    ServerStatus.down => LichessConnectionStatus.serverDown,
  };
}, name: 'LichessConnectionStatusProvider');

/// This provider is used to check the device's connectivity status, reacting to changes in
/// connectivity and app lifecycle events.
///
/// **Note**: to simply check whether the device is online, use [isDeviceOnlineProvider] instead.
/// Watch this one only when the status being unknown has to be handled explicitly, rather than
/// assumed to be online.
///
/// - Uses the [Connectivity] plugin to listen to connectivity changes
/// - Uses [AppLifecycleListener] to check connectivity on app resume
final connectivityChangesProvider =
    AsyncNotifierProvider<ConnectivityChangesNotifier, ConnectivityStatus>(
      ConnectivityChangesNotifier.new,
      name: 'ConnectivityChangesProvider',
    );

class ConnectivityChangesNotifier extends AsyncNotifier<ConnectivityStatus> {
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  AppLifecycleListener? _appLifecycleListener;

  final _connectivityChangesThrottler = Throttler(kConnectivityThrottleDelay);

  Client get _defaultClient => ref.read(defaultClientProvider);
  Connectivity get _connectivity => ref.read(connectivityPluginProvider);

  @override
  Future<ConnectivityStatus> build() {
    ref.onDispose(() {
      _connectivitySubscription?.cancel();
      _appLifecycleListener?.dispose();
      _connectivityChangesThrottler.cancel();
    });

    _connectivitySubscription?.cancel();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((result) {
      _connectivityChangesThrottler(() => _onConnectivityChange(result));
    });

    // A socket answering the ping/pong protocol is proof that the device can reach the network, so
    // it clears an offline status right away rather than leaving it up until the next check.
    //
    // Only that edge counts. A socket that is *not* connected proves nothing — it is also what
    // returning from the background and switching routes look like — and it notices a dead link
    // long after the check does, since that takes a ping going unanswered. The check therefore
    // stays the authority on going offline.
    final pool = ref.read(socketPoolProvider);
    void onSocketChange() {
      if (pool.averageLag.value == Duration.zero) return;
      // Deferred: the pool updates this from inside [SocketPool.open], which controllers call
      // while building, and Riverpod forbids a provider modifying another during a build.
      scheduleMicrotask(() {
        if (!ref.mounted || state.value?.isOnline != false) return;
        _logger.info('Socket connected, the device is online.');
        state = AsyncValue.data((isOnline: true, appState: state.requireValue.appState));
      });
    }

    pool.averageLag.addListener(onSocketChange);
    ref.onDispose(() => pool.averageLag.removeListener(onSocketChange));

    final AppLifecycleState? appState = WidgetsBinding.instance.lifecycleState;

    _appLifecycleListener = AppLifecycleListener(onStateChange: _onAppLifecycleChange);

    return _connectivity.checkConnectivity().then((r) => _getConnectivityStatus(r, appState));
  }

  Future<void> _onAppLifecycleChange(AppLifecycleState appState) async {
    if (appState == AppLifecycleState.resumed) {
      // Give the lichess server the benefit of the doubt again whenever the user comes back to
      // the app: see [ServerStatusNotifier.onAppResumed].
      ref.read(serverStatusProvider.notifier).onAppResumed();
    }

    if (!state.hasValue) {
      return;
    }

    if (appState == AppLifecycleState.resumed) {
      final newConn = await _connectivity.checkConnectivity().then(
        (r) => _getConnectivityStatus(r, appState),
      );

      state = AsyncValue.data(newConn);
    } else {
      final (:isOnline, appState: _) = state.requireValue;
      state = AsyncValue.data((isOnline: isOnline, appState: appState));
    }
  }

  Future<void> _onConnectivityChange(List<ConnectivityResult> result) async {
    if (!state.hasValue) {
      return;
    }

    final wasOnline = state.requireValue.isOnline;

    _logger.fine('Connectivity changed: $result');
    final newIsOnline = await isOnline(_defaultClient);
    _logger.fine('Online check result: $newIsOnline');

    if (newIsOnline != wasOnline) {
      _logger.info('Connectivity status: $result, isOnline: $newIsOnline');
      state = AsyncValue.data((isOnline: newIsOnline, appState: state.value?.appState));
    }
  }

  Future<ConnectivityStatus> _getConnectivityStatus(
    List<ConnectivityResult> result,
    AppLifecycleState? appState,
  ) async {
    final status = (isOnline: await isOnline(_defaultClient), appState: appState);
    _logger.info('Connectivity status: $result, isOnline: ${status.isOnline}');
    return status;
  }
}

typedef ConnectivityStatus = ({bool isOnline, AppLifecycleState? appState});

/// The URIs [isOnline] probes.
@visibleForTesting
final internetCheckUris = [
  Uri.parse('https://www.gstatic.com/generate_204'),
  Uri.parse('$kLichessCDNHost/assets/logo/lichess-favicon-32.png'),
];

/// Checks if the device is online by making a HEAD request to a list of URIs.
///
/// The requests are marked with [kQuietRequestHeader]: they are expected to fail whenever the
/// device is offline, which is exactly when this check matters, so their failures are not worth a
/// warning in the logs.
///
/// The [timeout] is the window in which the device gets to prove it is online: the URIs are hit in
/// parallel and the first answer wins, so a timeout is only ever reached when every one of them
/// hangs — an interface that is up but leads nowhere. A device with no interface at all fails
/// immediately, so the timeout is never reached.
/// Five seconds is generous for a HEAD request to a CDN: Android's own captive portal detection
/// decides on its parallel probes after three (`PROBE_TIMEOUT_MS` in `NetworkMonitor`).
Future<bool> isOnline(Client client, {Duration timeout = const Duration(seconds: 5)}) {
  final completer = Completer<bool>();
  try {
    int remaining = internetCheckUris.length;
    final futures = internetCheckUris.map(
      (uri) => client
          .head(uri, headers: const {kQuietRequestHeader: '1'})
          .timeout(timeout)
          .then((response) => true, onError: (_) => false),
    );
    for (final future in futures) {
      future.then((value) {
        remaining--;
        if (!completer.isCompleted) {
          if (value == true) {
            completer.complete(true);
          } else if (remaining == 0) {
            completer.complete(false);
          }
        }
      });
    }
  } catch (_) {
    completer.complete(false);
  }
  return completer.future;
}
