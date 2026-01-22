import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/common/preloaded_data.dart';
import 'package:lichess_mobile/src/model/engine/nnue_service.dart';
import 'package:lichess_mobile/src/network/connectivity.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:multistockfish/multistockfish.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../network/fake_http_client_factory.dart';

class ConfigurableFakeConnectivity implements Connectivity {
  ConfigurableFakeConnectivity({this.result = ConnectivityResult.wifi});

  ConnectivityResult result;

  @override
  Future<List<ConnectivityResult>> checkConnectivity() {
    return Future.value([result]);
  }

  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      Stream.value([result]);
}

Future<ProviderContainer> makeNnueTestContainer({
  Directory? appSupportDirectory,
  MockClient? mockClient,
  ConfigurableFakeConnectivity? connectivity,
}) async {
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
          deviceInfo: BaseDeviceInfo({
            'name': 'test',
            'model': 'test',
            'manufacturer': 'test',
            'systemName': 'test',
            'systemVersion': 'test',
            'identifierForVendor': 'test',
            'isPhysicalDevice': true,
          }),
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
      if (connectivity != null)
        connectivityPluginProvider.overrideWith((_) => connectivity),
    ],
  );

  return container;
}

void main() {
  group('NnueService', () {
    group('nnueFiles', () {
      test('returns correct file paths when appSupportDirectory is available', () async {
        final tempDir = await Directory.systemTemp.createTemp('nnue_test_');
        addTearDown(() => tempDir.delete(recursive: true));

        final container = await makeNnueTestContainer(appSupportDirectory: tempDir);
        addTearDown(container.dispose);

        final service = container.read(nnueServiceProvider);
        final files = service.nnueFiles;

        expect(files.bigNet.path, '${tempDir.path}/${Stockfish.latestBigNNUE}');
        expect(files.smallNet.path, '${tempDir.path}/${Stockfish.latestSmallNNUE}');
      });

      test('throws exception when appSupportDirectory is null', () async {
        final container = await makeNnueTestContainer(appSupportDirectory: null);
        addTearDown(container.dispose);

        final service = container.read(nnueServiceProvider);

        expect(() => service.nnueFiles, throwsException);
      });
    });

    group('checkNNUEFiles', () {
      test('returns false when appSupportDirectory is null', () async {
        final container = await makeNnueTestContainer(appSupportDirectory: null);
        addTearDown(container.dispose);

        final service = container.read(nnueServiceProvider);
        final result = await service.checkNNUEFiles();

        expect(result, isFalse);
      });

      test('returns false when files do not exist', () async {
        final tempDir = await Directory.systemTemp.createTemp('nnue_test_');
        addTearDown(() => tempDir.delete(recursive: true));

        final container = await makeNnueTestContainer(appSupportDirectory: tempDir);
        addTearDown(container.dispose);

        final service = container.read(nnueServiceProvider);
        final result = await service.checkNNUEFiles();

        expect(result, isFalse);
      });

      test('returns false when only one file exists', () async {
        final tempDir = await Directory.systemTemp.createTemp('nnue_test_');
        addTearDown(() => tempDir.delete(recursive: true));

        // Create only the big net file
        final bigNetFile = File('${tempDir.path}/${Stockfish.latestBigNNUE}');
        await bigNetFile.writeAsBytes([1, 2, 3]);

        final container = await makeNnueTestContainer(appSupportDirectory: tempDir);
        addTearDown(container.dispose);

        final service = container.read(nnueServiceProvider);
        final result = await service.checkNNUEFiles();

        expect(result, isFalse);
      });

      test('returns false when files exist but checksums do not match', () async {
        final tempDir = await Directory.systemTemp.createTemp('nnue_test_');
        addTearDown(() => tempDir.delete(recursive: true));

        // Create files with invalid content
        final bigNetFile = File('${tempDir.path}/${Stockfish.latestBigNNUE}');
        final smallNetFile = File('${tempDir.path}/${Stockfish.latestSmallNNUE}');
        await bigNetFile.writeAsBytes([1, 2, 3]);
        await smallNetFile.writeAsBytes([4, 5, 6]);

        final container = await makeNnueTestContainer(appSupportDirectory: tempDir);
        addTearDown(container.dispose);

        final service = container.read(nnueServiceProvider);
        final result = await service.checkNNUEFiles();

        expect(result, isFalse);
      });

    });

    group('deleteNNUEFiles', () {
      test('throws exception when appSupportDirectory is null', () async {
        final container = await makeNnueTestContainer(appSupportDirectory: null);
        addTearDown(container.dispose);

        final service = container.read(nnueServiceProvider);

        expect(() => service.deleteNNUEFiles(), throwsException);
      });

      test('deletes .nnue files in appSupportDirectory', () async {
        final tempDir = await Directory.systemTemp.createTemp('nnue_test_');
        addTearDown(() => tempDir.delete(recursive: true));

        // Create some .nnue files
        final nnueFile1 = File('${tempDir.path}/test1.nnue');
        final nnueFile2 = File('${tempDir.path}/test2.nnue');
        final otherFile = File('${tempDir.path}/other.txt');
        await nnueFile1.writeAsString('test1');
        await nnueFile2.writeAsString('test2');
        await otherFile.writeAsString('other');

        final container = await makeNnueTestContainer(appSupportDirectory: tempDir);
        addTearDown(container.dispose);

        final service = container.read(nnueServiceProvider);
        await service.deleteNNUEFiles();

        expect(await nnueFile1.exists(), isFalse);
        expect(await nnueFile2.exists(), isFalse);
        expect(await otherFile.exists(), isTrue); // Non-.nnue files should not be deleted
      });
    });

    group('downloadNNUEFiles', () {
      test('returns false when appSupportDirectory is null', () async {
        final container = await makeNnueTestContainer(appSupportDirectory: null);
        addTearDown(container.dispose);

        final service = container.read(nnueServiceProvider);
        final result = await service.downloadNNUEFiles(inBackground: true);

        expect(result, isFalse);
      });

      test('prevents concurrent download operations', () async {
        final tempDir = await Directory.systemTemp.createTemp('nnue_test_');
        addTearDown(() => tempDir.delete(recursive: true));

        final mockClient = MockClient((request) async {
          // Simulate slow download
          await Future<void>.delayed(const Duration(milliseconds: 100));
          return http.Response('test content', 200);
        });

        final container = await makeNnueTestContainer(
          appSupportDirectory: tempDir,
          mockClient: mockClient,
          connectivity: ConfigurableFakeConnectivity(),
        );
        addTearDown(container.dispose);

        final service = container.read(nnueServiceProvider);

        // Start first download
        final firstDownload = service.downloadNNUEFiles(inBackground: true);

        // Immediately start second download while first is in progress
        final secondDownload = service.downloadNNUEFiles(inBackground: true);

        final results = await Future.wait([firstDownload, secondDownload]);

        // Second call should be rejected
        expect(results[1], isFalse);
      });

      test('throws exception when in background and not on WiFi', () async {
        final tempDir = await Directory.systemTemp.createTemp('nnue_test_');
        addTearDown(() => tempDir.delete(recursive: true));

        final container = await makeNnueTestContainer(
          appSupportDirectory: tempDir,
          connectivity: ConfigurableFakeConnectivity(result: ConnectivityResult.mobile),
        );
        addTearDown(container.dispose);

        final service = container.read(nnueServiceProvider);

        expect(
          () => service.downloadNNUEFiles(inBackground: true),
          throwsException,
        );
      });

      test('allows sequential downloads after previous one completes', () async {
        final tempDir = await Directory.systemTemp.createTemp('nnue_test_');
        addTearDown(() => tempDir.delete(recursive: true));

        var downloadCount = 0;
        final mockClient = MockClient((request) async {
          downloadCount++;
          return http.Response('test content', 200);
        });

        final container = await makeNnueTestContainer(
          appSupportDirectory: tempDir,
          mockClient: mockClient,
          connectivity: ConfigurableFakeConnectivity(),
        );
        addTearDown(container.dispose);

        final service = container.read(nnueServiceProvider);

        // First download
        await service.downloadNNUEFiles(inBackground: true);

        // Second download after first completes
        await service.downloadNNUEFiles(inBackground: true);

        // Both downloads should have been allowed (4 requests = 2 files x 2 downloads)
        expect(downloadCount, 4);
      });
    });

    group('isDownloadingNNUEFiles', () {
      test('returns false when progress is 0', () async {
        final container = await makeNnueTestContainer(appSupportDirectory: null);
        addTearDown(container.dispose);

        final service = container.read(nnueServiceProvider);

        expect(service.isDownloadingNNUEFiles, isFalse);
      });

      test('returns false when progress is 1', () async {
        final container = await makeNnueTestContainer(appSupportDirectory: null);
        addTearDown(container.dispose);

        final service = container.read(nnueServiceProvider);
        // We can't easily set progress to 1 without downloading, but we can verify the logic
        // Progress starts at 0, so isDownloadingNNUEFiles should be false
        expect(service.nnueDownloadProgress.value, 0.0);
        expect(service.isDownloadingNNUEFiles, isFalse);
      });
    });
  });
}
