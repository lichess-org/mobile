import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/common/preloaded_data.dart';
import 'package:lichess_mobile/src/model/engine/opponent_level.dart';
import 'package:lichess_mobile/src/model/engine/weights_service.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../network/fake_http_client_factory.dart';

/// The bundled network's own bytes, which is the only content with a matching checksum.
Future<List<int>> bundledWeightsBytes() =>
    File('assets/maia/${MaiaRating.defaultRating.fileName}').readAsBytes();

ProviderContainer makeWeightsContainer({
  required Directory? appSupportDirectory,
  MockClient? mockClient,
}) {
  final container = ProviderContainer(
    overrides: [
      preloadedDataProvider.overrideWith((ref) {
        return (
          sri: 'test-sri',
          packageInfo: PackageInfo(
            appName: 'lichess_mobile_test',
            version: '0.0.0',
            buildNumber: '0',
            packageName: 'lichess_mobile_test',
          ),
          deviceInfo: BaseDeviceInfo({'name': 'test'}),
          authUser: null,
          engineMaxMemoryInMb: 256,
          appDocumentsDirectory: null,
          appSupportDirectory: appSupportDirectory,
        );
      }),
      if (mockClient != null)
        httpClientFactoryProvider.overrideWith((ref) {
          return FakeHttpClientFactory(() => mockClient);
        }),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

Future<Directory> makeTempDir() async {
  final dir = await Directory.systemTemp.createTemp('maia_weights_test_');
  addTearDown(() => dir.delete(recursive: true));
  return dir;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MaiaWeightsService', () {
    test('the bundled networks are available before anything has been downloaded', () async {
      final container = makeWeightsContainer(appSupportDirectory: await makeTempDir());
      final service = container.read(maiaWeightsServiceProvider);

      expect(await service.isAvailable(MaiaRating.defaultRating), isTrue);
      expect(await service.isAvailable(MaiaRating.maia1700), isFalse);
      expect(await service.availableRatings(), MaiaRating.bundledRatings);
    });

    test('writes the bundled network out of the asset bundle, once', () async {
      final dir = await makeTempDir();
      final container = makeWeightsContainer(appSupportDirectory: dir);
      final service = container.read(maiaWeightsServiceProvider);

      final (:rating, :path) = await service.ensureWeights(MaiaRating.defaultRating);

      // LC0 reads its network from a path, so even the bundled one has to reach the disk.
      expect(rating, MaiaRating.defaultRating);
      expect(path, '${dir.path}/maia/${MaiaRating.defaultRating.fileName}');
      expect(await File(path).length(), MaiaRating.defaultRating.expectedSize);

      // The second call is served from the file that is already there.
      final again = await service.ensureWeights(MaiaRating.defaultRating);
      expect(again.path, path);
    });

    // test('writes a bundled network that is not the default one, without the network', () async {
    //   final dir = await makeTempDir();
    //   final container = makeWeightsContainer(
    //     appSupportDirectory: dir,
    //     mockClient: MockClient((_) async => http.Response('', 404)),
    //   );
    //   final service = container.read(maiaWeightsServiceProvider);

    //   final (:rating, :path) = await service.ensureWeights(MaiaRating.maia1900);

    //   expect(rating, MaiaRating.maia1900);
    //   expect(path, '${dir.path}/maia/maia-1900.pb.gz');
    //   expect(await File(path).length(), MaiaRating.maia1900.expectedSize);
    // });

    test('downloads a network that is not there, and checks what it got', () async {
      final dir = await makeTempDir();
      final bytes = await bundledWeightsBytes();
      final requested = <Uri>[];
      final container = makeWeightsContainer(
        appSupportDirectory: dir,
        mockClient: MockClient((request) async {
          requested.add(request.url);
          return http.Response.bytes(bytes, 200);
        }),
      );
      final service = container.read(maiaWeightsServiceProvider);

      // The bytes served are the 1500 network's, so this is the only rating whose checksum can
      // match what the fake server hands back.
      final path = await service.download(MaiaRating.defaultRating);

      expect(path, '${dir.path}/maia/${MaiaRating.defaultRating.fileName}');
      expect(requested.single.path, endsWith('/maia-1500.pb.gz'));
    });

    test('a download whose checksum does not match is thrown away', () async {
      final dir = await makeTempDir();
      final container = makeWeightsContainer(
        appSupportDirectory: dir,
        mockClient: MockClient((_) async => http.Response('not a network', 200)),
      );
      final service = container.read(maiaWeightsServiceProvider);

      expect(await service.download(MaiaRating.maia1700), isNull);
      expect(await service.isAvailable(MaiaRating.maia1700), isFalse);
      expect(await File('${dir.path}/maia/maia-1700.pb.gz').exists(), isFalse);
    });

    test('a rating that cannot be downloaded falls back to the bundled network', () async {
      final dir = await makeTempDir();
      final container = makeWeightsContainer(
        appSupportDirectory: dir,
        mockClient: MockClient((_) async => http.Response('', 404)),
      );
      final service = container.read(maiaWeightsServiceProvider);

      final (:rating, :path) = await service.ensureWeights(MaiaRating.maia1700);

      // An opponent that cannot move because a download did not work is a dead end.
      expect(rating, MaiaRating.defaultRating);
      expect(path, endsWith('/maia-1500.pb.gz'));
    });

    test('two callers asking at once share one download', () async {
      final dir = await makeTempDir();
      final bytes = await bundledWeightsBytes();
      var requests = 0;
      final container = makeWeightsContainer(
        appSupportDirectory: dir,
        mockClient: MockClient((_) async {
          requests++;
          return http.Response.bytes(bytes, 200);
        }),
      );
      final service = container.read(maiaWeightsServiceProvider);

      await Future.wait([
        service.download(MaiaRating.defaultRating),
        service.download(MaiaRating.defaultRating),
      ]);

      expect(requests, 1);
    });

    test('deleting the downloaded networks leaves the bundled one obtainable', () async {
      final dir = await makeTempDir();
      final container = makeWeightsContainer(appSupportDirectory: dir);
      final service = container.read(maiaWeightsServiceProvider);

      final (:path, rating: _) = await service.ensureWeights(MaiaRating.defaultRating);
      await service.deleteWeights();
      expect(await File(path).exists(), isFalse);

      expect(await service.isAvailable(MaiaRating.defaultRating), isTrue);
      expect((await service.ensureWeights(MaiaRating.defaultRating)).path, path);
    });

    test('a network on disk that fails its checksum is deleted', () async {
      final dir = await makeTempDir();
      final container = makeWeightsContainer(appSupportDirectory: dir);
      final service = container.read(maiaWeightsServiceProvider);

      final file = File('${dir.path}/maia/maia-1700.pb.gz');
      await file.parent.create(recursive: true);
      await file.writeAsString('not a network');

      expect(await service.isAvailable(MaiaRating.maia1700), isFalse);
      expect(await file.exists(), isFalse);
    });

    test('a corrupted bundled network is replaced by the one in the asset bundle', () async {
      final dir = await makeTempDir();
      final container = makeWeightsContainer(appSupportDirectory: dir);
      final service = container.read(maiaWeightsServiceProvider);

      final file = File('${dir.path}/maia/${MaiaRating.defaultRating.fileName}');
      await file.parent.create(recursive: true);
      await file.writeAsString('not a network');

      final (:rating, :path) = await service.ensureWeights(MaiaRating.defaultRating);

      expect(rating, MaiaRating.defaultRating);
      expect(path, file.path);
      expect(await file.length(), MaiaRating.defaultRating.expectedSize);
    });

    test('a download that fails leaves nothing behind', () async {
      final dir = await makeTempDir();
      final container = makeWeightsContainer(
        appSupportDirectory: dir,
        mockClient: MockClient((_) async => http.Response('nope', 404)),
      );
      final service = container.read(maiaWeightsServiceProvider);

      expect(await service.download(MaiaRating.maia1700), isNull);
      expect(await File('${dir.path}/maia/maia-1700.pb.gz').exists(), isFalse);
    });

    test('networks no rating claims can be reported and deleted on their own', () async {
      final dir = await makeTempDir();
      final container = makeWeightsContainer(appSupportDirectory: dir);
      final service = container.read(maiaWeightsServiceProvider);

      // The bundled network, written out, is claimed and must survive.
      final (:path, rating: _) = await service.ensureWeights(MaiaRating.defaultRating);
      final stray = File('${dir.path}/maia/maia-4200.pb.gz');
      await stray.writeAsString('a network from another era');

      expect(await service.unusableWeights(), (count: 1, bytes: await stray.length()));

      await service.deleteUnusableWeights();

      expect(await stray.exists(), isFalse);
      expect(await File(path).exists(), isTrue);
      expect(await service.unusableWeights(), (count: 0, bytes: 0));
    });

    test('reports rather than throws when there is nowhere to put a network', () async {
      final container = makeWeightsContainer(appSupportDirectory: null);
      final service = container.read(maiaWeightsServiceProvider);

      expect(await service.isAvailable(MaiaRating.maia1700), isFalse);
      expect(await service.download(MaiaRating.maia1700), isNull);
    });
  });
}
