import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/utils/rate_limit.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connectivity.g.dart';

final _logger = Logger('Connectivity');

/// A provider that exposes a [Connectivity] instance.
@Riverpod(keepAlive: true)
Connectivity connectivityPlugin(Ref _) => Connectivity();

/// This provider is used to check the device's connectivity status, reacting to
/// changes in connectivity and app lifecycle events.
///
/// - Uses the [Connectivity] plugin to listen to connectivity changes
/// - Uses [AppLifecycleListener] to check connectivity on app resume
@Riverpod(keepAlive: true)
class ConnectivityChanges extends _$ConnectivityChanges {
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  AppLifecycleListener? _appLifecycleListener;

  final _connectivityChangesDebouncer = Debouncer(const Duration(seconds: 5));

  Client get _defaultClient => ref.read(defaultClientProvider);
  Connectivity get _connectivity => ref.read(connectivityPluginProvider);

  @override
  Future<ConnectivityStatus> build() {
    ref.onDispose(() {
      _connectivitySubscription?.cancel();
      _appLifecycleListener?.dispose();
      _connectivityChangesDebouncer.cancel();
    });

    _connectivitySubscription?.cancel();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((result) {
      _connectivityChangesDebouncer(() => _onConnectivityChange(result));
    });

    final AppLifecycleState? appState = WidgetsBinding.instance.lifecycleState;

    _appLifecycleListener = AppLifecycleListener(onStateChange: _onAppLifecycleChange);

    return _connectivity.checkConnectivity().then((r) => _getConnectivityStatus(r, appState));
  }

  Future<void> _onAppLifecycleChange(AppLifecycleState appState) async {
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
    _logger.fine('Online check result: $isOnline');

    if (newIsOnline != wasOnline) {
      _logger.info('Connectivity status: $result, isOnline: $isOnline');
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

final _internetCheckUris = [
  Uri.parse('https://www.gstatic.com/generate_204'),
  Uri.parse('$kLichessCDNHost/assets/logo/lichess-favicon-32.png'),
];

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
