import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
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
    required ConnectivityResult connectivityResult,
    required bool isOnline,
  }) = _ConnectivityStatus;
}

@riverpod
Future<ConnectivityStatus> connectivity(ConnectivityRef ref) async {
  final client = httpClient('Lichess Mobile');
  ref.onDispose(client.close);
  final connectivityResult = await Connectivity().checkConnectivity();
  return ConnectivityStatus(
    connectivityResult: connectivityResult,
    isOnline: await isOnline(client),
  );
}

@riverpod
Stream<ConnectivityStatus> connectivityChanges(ConnectivityChangesRef ref) {
  final client = httpClient('Lichess Mobile');
  ref.onDispose(client.close);
  // some android devices needs to check connectivity on start
  final firstCheck =
      Stream.fromFuture(Connectivity().checkConnectivity()).asyncMap(
    (result) async => ConnectivityStatus(
      connectivityResult: result,
      isOnline: await isOnline(client),
    ),
  );

  return Connectivity()
      .onConnectivityChanged
      .asyncMap(
        (result) async => ConnectivityStatus(
          connectivityResult: result,
          isOnline: await isOnline(client),
        ),
      )
      .startWithStream(firstCheck);
}

final _internetCheckUris = [
  Uri.parse('https://www.gstatic.com/generate_204'),
  Uri.parse('$kLichessCDNHost/assets/logo/lichess-favicon-32.png'),
];

Future<bool> isOnline(Client client) {
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
