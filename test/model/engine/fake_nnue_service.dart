import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:lichess_mobile/src/model/engine/nnue_service.dart';

/// A fake implementation of [NnueService] for testing.
///
/// This implementation:
/// - Always returns true for [checkNNUEFiles] (NNUE files are available)
/// - Returns dummy file paths for [nnueFiles] (not used by FakeStockfish)
/// - Returns false for [downloadNNUEFiles]
/// - Does nothing for [deleteNNUEFiles]
class FakeNnueService implements NnueService {
  FakeNnueService();

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
  Future<bool> downloadNNUEFiles({bool inBackground = true}) async {
    return false;
  }

  @override
  Future<void> deleteNNUEFiles() async {
    // Do nothing
  }
}
