import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/network/connectivity.dart';
import 'package:lichess_mobile/src/network/server_status.dart';

import '../test_container.dart';
import 'fake_offline_server.dart';
import 'fake_online_server.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('connectionStatusProvider', () {
    test('returns online when network is available and server is reachable', () async {
      final container = await makeContainer(
        overrides: {serverStatusProvider: serverStatusProvider.overrideWith(FakeServerOnline.new)},
      );

      // Wait for onlineStatusProvider to resolve (FakeConnectivity returns wifi).
      await container.read(onlineStatusProvider.future);

      expect(container.read(connectionStatusProvider), ConnectionStatus.online);
    });

    test('returns networkDown when network is unavailable', () async {
      final container = await makeContainer(
        overrides: {
          serverStatusProvider: serverStatusProvider.overrideWith(FakeServerOnline.new),
          onlineStatusProvider: onlineStatusProvider.overrideWith((ref) => Future.value(false)),
        },
      );

      await container.read(onlineStatusProvider.future);

      expect(container.read(connectionStatusProvider), ConnectionStatus.networkDown);
    });

    test('returns serverDown when network is available but server is unreachable', () async {
      final container = await makeContainer(
        overrides: {serverStatusProvider: serverStatusProvider.overrideWith(FakeServerOffline.new)},
      );

      await container.read(onlineStatusProvider.future);

      expect(container.read(connectionStatusProvider), ConnectionStatus.serverDown);
    });
  });
}
