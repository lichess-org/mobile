import 'dart:async';

import 'package:async/async.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:http/http.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/common/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stream_transform/stream_transform.dart';

part 'connectivity.freezed.dart';
part 'connectivity.g.dart';

/// This provider is used to check the device's connectivity status, reacting to
/// changes in connectivity and app lifecycle events.
///
/// - Uses the [Connectivity] plugin to listen to connectivity changes
/// - Uses [AppLifecycleListener] to check connectivity on app resume
@riverpod
Stream<ConnectivityStatus> connectivity(ConnectivityRef ref) {
  AppLifecycleState? appState = WidgetsBinding.instance.lifecycleState;

  // some android devices must check connectivity on start
  final firstCheck = Stream.fromFuture(Connectivity().checkConnectivity())
      .asyncMap((r) => _onConnectivityChange(r, appState));

  final connectivity = Connectivity()
      .onConnectivityChanged
      .asyncMap((r) => _onConnectivityChange(r, appState))
      .startWithStream(firstCheck);

  final appLifecycleConnectivityController =
      StreamController<ConnectivityStatus>.broadcast();

  final appLifecycleListener = AppLifecycleListener(
    onStateChange: (state) async {
      appState = state;

      if (state == AppLifecycleState.resumed) {
        appLifecycleConnectivityController.add(
          await Connectivity()
              .checkConnectivity()
              .then((r) => _onConnectivityChange(r, appState)),
        );
      }
    },
  );

  ref.onDispose(() {
    appLifecycleConnectivityController.close();
    appLifecycleListener.dispose();
  });

  return StreamGroup.mergeBroadcast([
    connectivity,
    appLifecycleConnectivityController.stream,
  ]);
}

@freezed
class ConnectivityStatus with _$ConnectivityStatus {
  const factory ConnectivityStatus({
    required IList<ConnectivityResult> connectivityResult,
    required bool isOnline,
    AppLifecycleState? appState,
  }) = _ConnectivityStatus;
}

Future<ConnectivityStatus> _onConnectivityChange(
  List<ConnectivityResult> result,
  AppLifecycleState? appState,
) async {
  final client = httpClientFactory();
  try {
    return ConnectivityStatus(
      connectivityResult: result.lock,
      isOnline: await _onlineCheck(client),
      appState: appState,
    );
  } finally {
    client.close();
  }
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
