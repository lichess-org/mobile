import 'dart:io';
import 'package:http/http.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:lichess_mobile/src/http_client.dart';

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
  final connectivityResult = await Connectivity().checkConnectivity();
  return ConnectivityStatus(
    connectivityResult: connectivityResult,
    isOnline: await isOnline(ref.read(httpClientProvider)),
  );
}

@riverpod
Stream<ConnectivityStatus> connectivityChanges(ConnectivityChangesRef ref) {
  // some android devices needs to check connectivity on start
  final firstCheck =
      Stream.fromFuture(Connectivity().checkConnectivity()).asyncMap(
    (result) async => ConnectivityStatus(
      connectivityResult: result,
      isOnline: await isOnline(ref.read(httpClientProvider)),
    ),
  );

  return Connectivity()
      .onConnectivityChanged
      .asyncMap(
        (result) async => ConnectivityStatus(
          connectivityResult: result,
          isOnline: await isOnline(ref.read(httpClientProvider)),
        ),
      )
      .startWithStream(firstCheck);
}

Future<bool> isOnline(Client client) async {
  try {
    final response =
        await client.head(Uri.parse('https://lichess.org/api/status')).timeout(
              const Duration(seconds: 5),
            );
    if (response.statusCode == HttpStatus.ok) {
      return true;
    }
    return false;
  } catch (_) {
    return false;
  }
}
