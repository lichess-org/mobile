import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:lichess_mobile/src/model/engine/weights_service.dart';

/// A fake implementation of [StockfishNnueService] for testing.
///
/// This implementation:
/// - Always returns true for [checkNNUEFile] (the NNUE file is available)
/// - Returns a dummy file path for [nnueFile] (not used by FakeStockfish)
/// - Returns false for [downloadNNUEFile]
/// - Does nothing for [deleteNNUEFiles]
class FakeStockfishNnueService implements StockfishNnueService {
  FakeStockfishNnueService();

  final ValueNotifier<double> _nnueDownloadProgress = ValueNotifier(0.0);

  @override
  ValueListenable<double> get nnueDownloadProgress => _nnueDownloadProgress;

  @override
  bool get isDownloadingNNUEFile => false;

  @override
  File get nnueFile {
    // Return a dummy file path - it won't be accessed by FakeStockfish
    return File('/tmp/fake_net.nnue');
  }

  @override
  Future<bool> checkNNUEFile() async {
    return true;
  }

  @override
  Future<bool> hasOutdatedNNUEFiles() async {
    return false;
  }

  @override
  Future<bool> hasNNUEFilesOnDisk() async {
    return true;
  }

  @override
  Future<bool> downloadNNUEFile({bool inBackground = true}) async {
    return false;
  }

  @override
  Future<void> deleteNNUEFiles() async {
    // Do nothing
  }
}

/// A fake [StockfishNnueService] that simulates a missing/unavailable NNUE file.
///
/// - Always returns false for [checkNNUEFile]
/// - Always returns true for [hasOutdatedNNUEFiles]
/// - All other behaviour is identical to [FakeStockfishNnueService]
class FakeStockfishNnueServiceUnavailable implements StockfishNnueService {
  FakeStockfishNnueServiceUnavailable();

  final ValueNotifier<double> _nnueDownloadProgress = ValueNotifier(0.0);

  @override
  ValueListenable<double> get nnueDownloadProgress => _nnueDownloadProgress;

  @override
  bool get isDownloadingNNUEFile => false;

  @override
  File get nnueFile {
    return File('/tmp/fake_net.nnue');
  }

  @override
  Future<bool> checkNNUEFile() async {
    return false;
  }

  @override
  Future<bool> hasOutdatedNNUEFiles() async {
    return true;
  }

  @override
  Future<bool> hasNNUEFilesOnDisk() async {
    return false;
  }

  @override
  Future<bool> downloadNNUEFile({bool inBackground = true}) async {
    return false;
  }

  @override
  Future<void> deleteNNUEFiles() async {}
}
