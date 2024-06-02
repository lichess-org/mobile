import 'package:lichess_mobile/src/utils/connectivity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fake_connectivity_changes.g.dart';

@riverpod
class FakeConnectivityChanges extends _$FakeConnectivityChanges
    implements ConnectivityChanges {
  @override
  Future<ConnectivityStatus> build() async {
    return const ConnectivityStatus(
      isOnline: true,
    );
  }
}
