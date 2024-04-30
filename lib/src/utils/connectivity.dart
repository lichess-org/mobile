import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:http/http.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/common/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stream_transform/stream_transform.dart';

part 'connectivity.freezed.dart';
part 'connectivity.g.dart';

@freezed
class ConnectivityStatus with _$ConnectivityStatus {
  const factory ConnectivityStatus({
    required IList<ConnectivityResult> connectivityResult,
    required bool isOnline,
  }) = _ConnectivityStatus;
}

/// This provider is used to listen to connectivity changes and check if the
/// device is online.
///
/// It uses the [Connectivity] plugin to listen to changes and make HEAD requests
/// to some known URIs.
@riverpod
Stream<ConnectivityStatus> connectivityChanges(ConnectivityChangesRef ref) {
  // some android devices needs to check connectivity on start
  final firstCheck =
      Stream.fromFuture(Connectivity().checkConnectivity()).asyncMap(
    (result) async {
      final client = httpClientFactory();
      try {
        return ConnectivityStatus(
          connectivityResult: result.lock,
          isOnline: await onlineCheck(client),
        );
      } finally {
        client.close();
      }
    },
  );

  return Connectivity().onConnectivityChanged.asyncMap(
    (result) async {
      final client = httpClientFactory();
      try {
        return ConnectivityStatus(
          connectivityResult: result.lock,
          isOnline: await onlineCheck(client),
        );
      } finally {
        client.close();
      }
    },
  ).startWithStream(firstCheck);
}

/// This provider is used to check if the device is online.
///
/// It will react to connectivity status changes.
@riverpod
Future<bool> isOnline(IsOnlineRef ref) async {
  return ref.watch(
    connectivityChangesProvider.selectAsync((status) => status.isOnline),
  );
}

final _internetCheckUris = [
  Uri.parse('https://www.gstatic.com/generate_204'),
  Uri.parse('$kLichessCDNHost/assets/logo/lichess-favicon-32.png'),
];

Future<bool> onlineCheck(Client client) {
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
