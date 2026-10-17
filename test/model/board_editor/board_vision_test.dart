import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/board_editor/board_vision.dart';

const _resolution = 644;
const _classes = 13;

/// Logits that score [labels], one class index per square from a8 to h1, above every other class.
Float32List _logitsFor(List<int> labels) {
  final logits = Float32List(64 * _classes);
  for (var square = 0; square < 64; square++) {
    for (var label = 0; label < _classes; label++) {
      logits[square * _classes + label] = label == labels[square] ? 2.5 : -1.0 - label;
    }
  }
  return logits;
}

void main() {
  group('placementFromLogits', () {
    test('empty board', () {
      expect(placementFromLogits(_logitsFor(List.filled(64, 0))), '8/8/8/8/8/8/8/8');
    });

    test('starting position', () {
      // Classes: . P N B R Q K p n b r q k
      final labels = [
        ...[10, 8, 9, 11, 12, 9, 8, 10],
        ...List.filled(8, 7),
        ...List.filled(32, 0),
        ...List.filled(8, 1),
        ...[4, 2, 3, 5, 6, 3, 2, 4],
      ];
      expect(
        placementFromLogits(_logitsFor(labels)),
        'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR',
      );
    });

    test('empty squares between and after pieces', () {
      final labels = List.filled(64, 0);
      labels[1] = 12; // b8: black king
      labels[5] = 1; // f8: white pawn
      labels[63] = 6; // h1: white king
      expect(placementFromLogits(_logitsFor(labels)), '1k3P2/8/8/8/8/8/8/7K');
    });
  });

  test('imageTensorFromRgba normalizes into planar channels', () {
    final rgba = Uint8List(_resolution * _resolution * 4);
    // First pixel pure red, last pixel white; alpha is ignored.
    rgba[0] = 255;
    rgba[3] = 17;
    rgba.fillRange(rgba.length - 4, rgba.length, 255);

    final tensor = imageTensorFromRgba(rgba);
    const channel = _resolution * _resolution;
    expect(tensor.length, 3 * channel);
    expect(tensor[0], closeTo((1 - 0.485) / 0.229, 1e-5));
    expect(tensor[channel], closeTo(-0.456 / 0.224, 1e-5));
    expect(tensor[2 * channel], closeTo(-0.406 / 0.225, 1e-5));
    expect(tensor[channel - 1], closeTo((1 - 0.485) / 0.229, 1e-5));
    expect(tensor[3 * channel - 1], closeTo((1 - 0.406) / 0.225, 1e-5));
  });
}
