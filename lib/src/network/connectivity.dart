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
/// - Uses [SocketPool] to check if the device is online when the current status is offline and a
/// socket connects or fails to connect.
final connectivityChangesProvider =
    AsyncNotifierProvider<ConnectivityChangesNotifier, ConnectivityStatus>(
      ConnectivityChangesNotifier.new,
      name: 'ConnectivityChangesProvider',
    );

class ConnectivityChangesNotifier extends AsyncNotifier<ConnectivityStatus> {
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  AppLifecycleListener? _appLifecycleListener;

  // Trailing: [onSocketFailing] reports a run of failures once, so a call dropped here is a signal
  // lost for good — no later notification would ask for the check again, and the status would stay
  // online while the socket keeps failing.
  final _connectivityChangesThrottler = Throttler(kConnectivityThrottleDelay, trailing: true);

  /// Bumped by every write that decides whether the device is online.
  ///
  /// A check reads the network over hundreds of milliseconds, and a resume, a socket pong or
  /// another check can settle the question with fresher evidence while it runs. Each check
  /// captures this revision before it starts and drops its result if it has moved since, so that a
  /// slow answer never overwrites what happened while it was on its way.
  int _onlineStatusRevision = 0;

  Client get _defaultClient => ref.read(defaultClientProvider);
  Connectivity get _connectivity => ref.read(connectivityPluginProvider);

  /// Writes a status, and marks every check that is already running as outdated.
  void _setOnlineStatus(bool isOnline) {
    _onlineStatusRevision++;
    state = AsyncValue.data((isOnline: isOnline, appState: state.requireValue.appState));
  }

  /// Whether a check that started at [revision] may still commit its result.
  bool _isCurrent(int revision) {
    if (!ref.mounted) return false;
    if (revision != _onlineStatusRevision) {
      return false;
    }
    return true;
  }

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

    final pool = ref.read(socketPoolProvider);

    // A socket answering the ping/pong protocol is proof that the device can reach the network, so
    // it clears an offline status right away rather than leaving it up until the next check.
    void onSocketConnected() {
      if (pool.averageLag.value == Duration.zero) return;
      // Deferred: the pool updates this from inside [SocketPool.open], which controllers call
      // while building, and Riverpod forbids a provider modifying another during a build.
      scheduleMicrotask(() {
        if (!ref.mounted || state.value?.isOnline != false) return;
        _setOnlineStatus(true);
      });
    }

    // The other way around, a socket that cannot connect is only a suspicion: it may be lichess
    // that is down, and the socket goes on failing long after the network is back. So it does not
    // set the status offline, it merely asks the check to run — the check remains the authority.
    //
    // This is also what keeps the two providers from egging each other on: [SocketPool] reconnects
    // on the offline -> online edge only, and a socket only reports a *run* of failures once, so
    // each failing run costs at most one check.
    void onSocketFailing() {
      if (!pool.isFailing.value) return;
      scheduleMicrotask(() {
        // A device already known to be offline has nothing to learn from a socket that fails, and
        // must not take up the throttler's window: the connectivity event that brings the network
        // back is what has to run next, without waiting out a delay.
        if (!ref.mounted || state.value?.isOnline != true) return;
        _connectivityChangesThrottler(() {
          // Checked again: the throttler may run this a delay later, by which time the status may
          // have settled offline on its own.
          if (!ref.mounted || state.value?.isOnline != true) return;
          _refreshOnlineStatus('socket cannot connect');
        });
      });
    }

    pool.averageLag.addListener(onSocketConnected);
    pool.isFailing.addListener(onSocketFailing);
    ref.onDispose(() {
      pool.averageLag.removeListener(onSocketConnected);
      pool.isFailing.removeListener(onSocketFailing);
    });

    final AppLifecycleState? appState = WidgetsBinding.instance.lifecycleState;

    _appLifecycleListener = AppLifecycleListener(onStateChange: _onAppLifecycleChange);

    return _initialStatus(appState, pool);
  }

  /// Runs the first check, and reconciles its result with the socket pool.
  ///
  /// [onSocketConnected] has no status to correct while this check is still running, so a pong
  /// that lands in that window would otherwise be dropped, leaving the device reported offline
  /// until the next lag change. A socket that is connected by the time the check answers is proof
  /// of a working network, and outranks a check that came back offline.
  Future<ConnectivityStatus> _initialStatus(AppLifecycleState? appState, SocketPool pool) async {
    final result = await _connectivity.checkConnectivity();
    final status = await _getConnectivityStatus(result, appState);
    if (!status.isOnline && pool.averageLag.value != Duration.zero) {
      return (isOnline: true, appState: status.appState);
    }
    return status;
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

    // The lifecycle state is known right away, whatever the check that follows finds. It says
    // nothing about connectivity, so it does not outdate a check that is already running.
    state = AsyncValue.data((isOnline: state.requireValue.isOnline, appState: appState));

    if (appState != AppLifecycleState.resumed) {
      return;
    }

    final revision = _onlineStatusRevision;
    final result = await _connectivity.checkConnectivity();
    final newConn = await _getConnectivityStatus(result, appState);

    if (!_isCurrent(revision)) return;

    // The app may have been backgrounded again while the check ran, so the lifecycle state is read
    // again rather than taken from the check.
    _setOnlineStatus(newConn.isOnline);
  }

  Future<void> _onConnectivityChange(List<ConnectivityResult> result) {
    return _refreshOnlineStatus('connectivity changed: $result');
  }

  /// Runs the online check and updates the status if it disagrees with it.
  ///
  /// [reason] is what prompted the check, for the logs.
  Future<void> _refreshOnlineStatus(String reason) async {
    if (!state.hasValue) {
      return;
    }

    final revision = _onlineStatusRevision;
    final wasOnline = state.requireValue.isOnline;
    final newIsOnline = await isOnline(_defaultClient);

    if (!_isCurrent(revision)) return;

    if (newIsOnline != wasOnline) {
      _logger.info('Connectivity status: $reason, isOnline: $newIsOnline');
      _setOnlineStatus(newIsOnline);
    } else {
      // A check that confirms the status is evidence just as fresh as one that changes it: it has
      // nothing to notify about, but it still outdates the slower checks it has overtaken.
      _onlineStatusRevision++;
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
