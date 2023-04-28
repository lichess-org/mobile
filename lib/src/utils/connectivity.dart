import 'dart:io';
import 'package:stream_transform/stream_transform.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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
    isOnline: await isOnline(),
  );
}

@riverpod
Stream<ConnectivityStatus> connectivityChanges(ConnectivityChangesRef ref) {
  // some android devices needs to check connectivity on start
  final firstCheck =
      Stream.fromFuture(Connectivity().checkConnectivity()).asyncMap(
    (result) async => ConnectivityStatus(
      connectivityResult: result,
      isOnline: await isOnline(),
    ),
  );

  return Connectivity()
      .onConnectivityChanged
      .asyncMap(
        (result) async => ConnectivityStatus(
          connectivityResult: result,
          isOnline: await isOnline(),
        ),
      )
      .startWithStream(firstCheck);
}

Future<bool> isOnline() async {
  try {
    final result = await InternetAddress.lookup('lichess.org');
    if (result.isNotEmpty && result.first.rawAddress.isNotEmpty) {
      return true;
    }
  } on SocketException catch (_) {
    return false;
  }
  return false;
}
