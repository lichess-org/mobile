import 'package:chessground/src/piece_sets.dart';
import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/model/settings/settings_repository.dart';

class FakeSettingsRepository implements SettingsRepository {
  ThemeMode themeMode = ThemeMode.system;
  bool soundMuted = false;
  PieceSet pieceSet = PieceSet.merida;

  @override
  Future<bool> setThemeMode(ThemeMode mode) async {
    themeMode = mode;
    return true;
  }

  @override
  ThemeMode getThemeMode() {
    return themeMode;
  }

  @override
  Future<bool> toggleSound() async {
    soundMuted = !soundMuted;
    return true;
  }

  @override
  bool isSoundMuted() {
    return soundMuted;
  }

  @override
  PieceSet getPieceSet() {
    return pieceSet;
  }

  @override
  Future<bool> setPieceSet(PieceSet set) async {
    pieceSet = set;
    return true;
  }
}
