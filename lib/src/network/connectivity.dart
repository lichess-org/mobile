import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/network/server_status.dart';
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
  return switch (ref.watch(connectivityChangesProvider)) {
    // A check that failed does mean we could not reach anything.
    AsyncValue(hasError: true) => false,
    // The last known answer, whether it comes from a settled check or from a re-run that has not
    // completed yet.
    AsyncValue(:final value?) => value.isOnline,
    _ => true,
  };
}, name: 'IsDeviceOnlineProvider');

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

final _internetCheckUris = [Uri.parse('$kLichessCDNHost/assets/logo/lichess-favicon-32.png')];

/// Checks if the device is online by making a HEAD request to a list of URIs.
Future<bool> isOnline(Client client, {Duration timeout = const Duration(seconds: 10)}) {
  final completer = Completer<bool>();
  try {
    int remaining = _internetCheckUris.length;
    final futures = _internetCheckUris.map(
      (uri) => client.head(uri).timeout(timeout).then((response) => true, onError: (_) => false),
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

extension AsyncValueConnectivity on AsyncValue<ConnectivityStatus> {
  /// Switches between device's connectivity status.
  ///
  /// Using this method assumes the the device is offline when the status is
  /// not yet available (i.e. [AsyncValue.isLoading].
  /// If you want to handle the loading state separately, use
  /// [whenIsLoading] instead.
  ///
  /// This method is similar to [AsyncValueX.maybeWhen], but it takes two
  /// functions, one for when the device is online and another for when it is
  /// offline.
  ///
  /// Example:
  /// ```dart
  /// final status = ref.watch(connectivityChangesProvider);
  /// final result = status.whenIs(
  ///   online: () => 'Online',
  ///   offline: () => 'Offline',
  /// );
  /// ```
  R whenIs<R>({required R Function() online, required R Function() offline}) {
    return maybeWhen(
      skipLoadingOnReload: true,
      data: (status) => status.isOnline ? online() : offline(),
      orElse: offline,
    );
  }

  /// Switches between device's connectivity status, but handling the loading state.
  ///
  /// This method is similar to [AsyncValueX.when], but it takes three
  /// functions, one for when the device is online, another for when it is
  /// offline, and the last for when the status is still loading.
  ///
  /// Example:
  /// ```dart
  /// final status = ref.watch(connectivityChangesProvider);
  /// final result = status.whenIsLoading(
  ///   online: () => 'Online',
  ///   offline: () => 'Offline',
  ///   loading: () => 'Loading',
  /// );
  /// ```
  R whenIsLoading<R>({
    required R Function() online,
    required R Function() offline,
    required R Function() loading,
  }) {
    return when(
      skipLoadingOnReload: true,
      data: (status) => status.isOnline ? online() : offline(),
      loading: loading,
      error: (error, stack) => offline(),
    );
  }
}
