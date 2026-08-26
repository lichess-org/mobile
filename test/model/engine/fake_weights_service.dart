import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:lichess_mobile/src/model/engine/opponent_level.dart';
import 'package:lichess_mobile/src/model/engine/weights_service.dart';

/// A [MaiaWeightsService] that hands out paths without touching the disk or the network.
///
/// [available] is what the device is pretending to have; anything else has to be "downloaded",
/// which succeeds unless [downloadSucceeds] says otherwise. The bundled network is always there,
/// as it is in the app.
class FakeMaiaWeightsService implements MaiaWeightsService {
  FakeMaiaWeightsService({Set<MaiaRating>? available, this.downloadSucceeds = true})
    : available = {...?available, MaiaRating.defaultRating};

  final Set<MaiaRating> available;

  /// Whether a download of a network that is not in [available] works.
  bool downloadSucceeds;

  /// The ratings [download] was asked for, in order.
  final List<MaiaRating> downloads = [];

  final ValueNotifier<double> _downloadProgress = ValueNotifier(0.0);

  @override
  ValueListenable<double> get downloadProgress => _downloadProgress;

  @override
  MaiaRating? get downloading => null;

  @override
  File weightsFile(MaiaRating rating) => File('/fake/maia/${rating.fileName}');

  @override
  Future<bool> isAvailable(MaiaRating rating) async => available.contains(rating);

  @override
  Future<Set<MaiaRating>> availableRatings() async => available;

  @override
  Future<String?> download(MaiaRating rating) async {
    downloads.add(rating);
    if (!downloadSucceeds) return null;
    available.add(rating);
    return weightsFile(rating).path;
  }

  @override
  Future<({MaiaRating rating, String path})> ensureWeights(MaiaRating rating) async {
    if (available.contains(rating) || await download(rating) != null) {
      return (rating: rating, path: weightsFile(rating).path);
    }
    return (rating: MaiaRating.defaultRating, path: weightsFile(MaiaRating.defaultRating).path);
  }

  @override
  Future<void> deleteWeights() async {
    available
      ..clear()
      ..add(MaiaRating.defaultRating);
  }
}
