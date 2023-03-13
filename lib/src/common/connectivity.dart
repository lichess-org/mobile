import 'dart:io';
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
Stream<ConnectivityStatus> connectivityChanges(ConnectivityChangesRef ref) {
  return Connectivity().onConnectivityChanged.asyncMap(
        (result) async => ConnectivityStatus(
          connectivityResult: result,
          isOnline: await isOnline(),
        ),
      );
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
