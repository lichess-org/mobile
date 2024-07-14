import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:http/http.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/common/http.dart';
import 'package:lichess_mobile/src/utils/rate_limit.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connectivity.freezed.dart';
part 'connectivity.g.dart';

final _logger = Logger('Connectivity');

/// This provider is used to check the device's connectivity status, reacting to
/// changes in connectivity and app lifecycle events.
///
/// - Uses the [Connectivity] plugin to listen to connectivity changes
/// - Uses [AppLifecycleListener] to check connectivity on app resume
@riverpod
class ConnectivityChanges extends _$ConnectivityChanges {
  StreamSubscription<List<ConnectivityResult>>? _socketSubscription;
  AppLifecycleListener? _appLifecycleListener;

  final _connectivityChangesDebouncer = Debouncer(const Duration(seconds: 5));

  @override
  Future<ConnectivityStatus> build() {
    ref.onDispose(() {
      _socketSubscription?.cancel();
      _appLifecycleListener?.dispose();
      _connectivityChangesDebouncer.dispose();
    });

    _socketSubscription?.cancel();
    _socketSubscription = Connectivity().onConnectivityChanged.listen((result) {
      _connectivityChangesDebouncer(() => _onConnectivityChange(result));
    });

    final AppLifecycleState? appState = WidgetsBinding.instance.lifecycleState;

    _appLifecycleListener = AppLifecycleListener(
      onStateChange: _onAppLifecycleChange,
    );

    return Connectivity()
        .checkConnectivity()
        .then((r) => _getConnectivityStatus(r, appState));
  }

  Future<void> _onAppLifecycleChange(AppLifecycleState appState) async {
    if (!state.hasValue) {
      return;
    }

    if (appState == AppLifecycleState.resumed) {
      final newConn = await Connectivity()
          .checkConnectivity()
          .then((r) => _getConnectivityStatus(r, appState));

      state = AsyncValue.data(newConn);
    } else {
      state = AsyncValue.data(state.requireValue.copyWith(appState: appState));
    }
  }

  Future<void> _onConnectivityChange(List<ConnectivityResult> result) async {
    if (!state.hasValue) {
      return;
    }

    final wasOnline = state.requireValue.isOnline;

    final client = httpClientFactory();
    try {
      _logger.fine('Connectivity changed: $result');
      final isOnline = await _onlineCheck(client);
      _logger.fine('Online check result: $isOnline');

      if (isOnline != wasOnline) {
        _logger.info('Connectivity status: $result, isOnline: $isOnline');
        state = AsyncValue.data(
          ConnectivityStatus(
            isOnline: isOnline,
            appState: state.valueOrNull?.appState,
          ),
        );
      }
    } finally {
      client.close();
    }
  }

  Future<ConnectivityStatus> _getConnectivityStatus(
    List<ConnectivityResult> result,
    AppLifecycleState? appState,
  ) async {
    final client = httpClientFactory();
    try {
      final status = ConnectivityStatus(
        isOnline: await _onlineCheck(client),
        appState: appState,
      );
      _logger
          .info('Connectivity status: $result, isOnline: ${status.isOnline}');
      return status;
    } finally {
      client.close();
    }
  }
}

@freezed
class ConnectivityStatus with _$ConnectivityStatus {
  const factory ConnectivityStatus({
    required bool isOnline,
    AppLifecycleState? appState,
  }) = _ConnectivityStatus;
}

final _internetCheckUris = [
  Uri.parse('https://www.gstatic.com/generate_204'),
  Uri.parse('$kLichessCDNHost/assets/logo/lichess-favicon-32.png'),
];

Future<bool> _onlineCheck(Client client) {
  final completer = Completer<bool>();
  try {
    int remaining = _internetCheckUris.length;
    final futures = _internetCheckUris.map(
      (uri) => client.head(uri).timeout(const Duration(seconds: 10)).then(
            (response) => true,
            onError: (_) => false,
          ),
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
