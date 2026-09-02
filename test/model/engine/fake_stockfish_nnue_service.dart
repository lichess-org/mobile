import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:lichess_mobile/src/model/engine/weights_service.dart';

/// A fake implementation of [StockfishNnueService] for testing.
///
/// This implementation:
/// - Always returns true for [checkNNUEFiles] (NNUE files are available)
/// - Returns dummy file paths for [nnueFiles] (not used by FakeStockfish)
/// - Returns false for [downloadNNUEFiles]
/// - Does nothing for [deleteNNUEFiles]
class FakeStockfishNnueService implements StockfishNnueService {
  FakeStockfishNnueService();

  final ValueNotifier<double> _nnueDownloadProgress = ValueNotifier(0.0);

  @override
  ValueListenable<double> get nnueDownloadProgress => _nnueDownloadProgress;

  @override
  bool get isDownloadingNNUEFiles => false;

  @override
  NNUEFiles get nnueFiles {
    // Return dummy file paths - these won't be accessed by FakeStockfish
    return (bigNet: File('/tmp/fake_big.nnue'), smallNet: File('/tmp/fake_small.nnue'));
  }

  @override
  Future<bool> checkNNUEFiles() async {
    return true;
  }

  @override
  Future<bool> hasOutdatedNNUEFiles() async {
    return false;
  }

  @override
  Future<bool> downloadNNUEFiles({bool inBackground = true}) async {
    return false;
  }

  @override
  Future<void> deleteNNUEFiles() async {
    // Do nothing
  }
}

/// A fake [StockfishNnueService] that simulates missing/unavailable NNUE files.
///
/// - Always returns false for [checkNNUEFiles]
/// - Always returns true for [hasOutdatedNNUEFiles]
/// - All other behaviour is identical to [FakeStockfishNnueService]
class FakeStockfishNnueServiceUnavailable implements StockfishNnueService {
  FakeStockfishNnueServiceUnavailable();

  final ValueNotifier<double> _nnueDownloadProgress = ValueNotifier(0.0);

  @override
  ValueListenable<double> get nnueDownloadProgress => _nnueDownloadProgress;

  @override
  bool get isDownloadingNNUEFiles => false;

  @override
  NNUEFiles get nnueFiles {
    return (bigNet: File('/tmp/fake_big.nnue'), smallNet: File('/tmp/fake_small.nnue'));
  }

  @override
  Future<bool> checkNNUEFiles() async {
    return false;
  }

  @override
  Future<bool> hasOutdatedNNUEFiles() async {
    return true;
  }

  @override
  Future<bool> downloadNNUEFiles({bool inBackground = true}) async {
    return false;
  }

  @override
  Future<void> deleteNNUEFiles() async {}
}
