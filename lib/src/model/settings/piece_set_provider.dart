import 'package:chessground/chessground.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'settings_repository.dart';

final pieceSetProvider =
StateNotifierProvider<PieceSetNotifier, PieceSet>((ref) {
  final repository = ref.watch(settingsRepositoryProvider);
  return PieceSetNotifier(ref, repository.getPieceSet());
});

class PieceSetNotifier extends StateNotifier<PieceSet> {
  PieceSetNotifier(this.ref, PieceSet initialSet)
      : super(initialSet);

  final Ref ref;

  Future<void> changePieceSet(PieceSet set) async {
    final repository = ref.read(settingsRepositoryProvider);
    final ok = await repository.setPieceSet(set);
    if (ok) {
      state = set;
    }
  }
}
